package hxd.res;
#if js
import hxd.PixelFormat;
import js.html.ImageData;
import h3d.mat.Texture;
import h3d.impl.GlDriver;
import h3d.mat.Data;

class BasisTextureLoader {
	public static var workerLimit = 4;
	public static var transcoderPath = 'vendor/basis_transcoder.js';
	public static var wasmPath = 'vendor/basis_transcoder.wasm';

	static var _workerNextTaskID = 1;
	static var _workerSourceURL:String;
	static var _workerConfig = {
		format: 0,
		astcSupported: false,
		etc1Supported: false,
		etc2Supported: false,
		dxtSupported: false,
		pvrtcSupported: false,
	};
	static var _workerPool:Array<WorkerTask> = [];
	static var _transcoderPending:js.lib.Promise<Dynamic>;
	static var _transcoderBinary:Dynamic;

	public static function getTexture(bytes:haxe.io.BytesData) {
		detectSupport();
		return createTexture(bytes);
	}

	static function detectSupport() {
		final driver:GlDriver = cast h3d.Engine.getCurrent().driver;
		final fmt = driver.textureSupport;
		_workerConfig.format = switch(fmt) {
			case ETC(_): BASIS_FORMAT.cTFETC1;
			case ASTC(_): BASIS_FORMAT.cTFASTC_4x4;
			case S3TC(_): BASIS_FORMAT.cTFBC3;
			case PVRTC(_): BASIS_FORMAT.cTFPVRTC1_4_RGBA;
			default: throw 'No suitable compressed texture format found.';
		}
	}

	static function createTexture(buffer:haxe.io.BytesData):js.lib.Promise<h3d.mat.Texture> {
		var worker:js.html.Worker;
		var workerTask:WorkerTask;
		var taskID:Int;
		var texturePending = getWorker().then((task) -> {
			workerTask = task;
			worker = workerTask.worker;
			taskID = _workerNextTaskID++;
			return new js.lib.Promise((resolve, reject) -> {
				workerTask.callbacks.set(taskID, {
					resolve: resolve,
					reject: reject,
				});
				workerTask.taskCosts.set(taskID, buffer.byteLength);
				workerTask.taskLoad += workerTask.taskCosts.get(taskID);
				worker.postMessage({type: 'transcode', id: taskID, buffer: buffer}, [buffer]);
			});
		}).then((message) -> {
				final w = message.width;
				final h = message.height;
				final mipmaps:Array<ImageData> = message.mipmaps;
				final format = message.format;
				final create = (fmt) -> {
					final texture = new h3d.mat.Texture(w, h, null, fmt);
					var level = 0;
					for (mipmap in mipmaps) {
						final bytes = haxe.io.Bytes.ofData(cast mipmap.data);
						final pixels = new hxd.Pixels(mipmap.width, mipmap.height, bytes, fmt);
						texture.uploadPixels(pixels, level);
						level++;
					}
					return texture;
				}
				var texture:h3d.mat.Texture;
				switch (format) {
					case BASIS_FORMAT.cTFASTC_4x4:
						texture = create(hxd.PixelFormat.ASTC(format));
					case BASIS_FORMAT.cTFBC1, BASIS_FORMAT.cTFBC3:
						texture = create(hxd.PixelFormat.S3TC(format));
					case BASIS_FORMAT.cTFETC1:
						texture = create(hxd.PixelFormat.ETC(format));
					case BASIS_FORMAT.cTFPVRTC1_4_RGB, BASIS_FORMAT.cTFPVRTC1_4_RGBA:
						texture = create(hxd.PixelFormat.PVRTC(format));
					default:
						throw 'BasisTextureLoader: No supported format available.';
				}
				if (mipmaps.length > 1) {
					texture.flags.set(MipMapped);
				}
				return texture;
			}).then((tex) -> {
				if (workerTask != null && taskID > 0) {
					workerTask.taskLoad -= workerTask.taskCosts.get(taskID);
					workerTask.callbacks.remove(taskID);
					workerTask.taskCosts.remove(taskID);
				}
				return tex;
			});
		return texturePending;
	}

	static function initTranscoder() {
		if (_transcoderBinary == null) {
			// Load transcoder wrapper.
			final jsLoader = new hxd.net.BinaryLoader(transcoderPath);
			final jsContent = new js.lib.Promise((resolve, reject) -> {
				jsLoader.onLoaded = resolve;
				jsLoader.onError = reject;
				jsLoader.load();
			});
			// Load transcoder WASM binary.
			final binaryLoader = new hxd.net.BinaryLoader(wasmPath);
			final binaryContent = new js.lib.Promise((resolve, reject) -> {
				binaryLoader.onLoaded = resolve;
				binaryLoader.onError = reject;
				binaryLoader.load(true);
			});

			_transcoderPending = js.lib.Promise.all([jsContent, binaryContent]).then((arr) -> {
				final transcoder = arr[0].toString();
				final wasm = arr[1];
				var fn = BasisWorker.func;

				var body = [
					'/* basis_transcoder.js */',
					transcoder,
					'/* worker */',
					fn.substring(fn.indexOf('{') + 1, fn.lastIndexOf('}'))
				].join('\n');

				_workerSourceURL = js.html.URL.createObjectURL(new js.html.Blob([body]));
				_transcoderBinary = wasm;
			});
		}

		return _transcoderPending;
	}

	static function getWorker() {
		return initTranscoder().then((val) -> {
			if (_workerPool.length < workerLimit) {
				final worker = new js.html.Worker(_workerSourceURL);
				final workerTask:WorkerTask = {
					worker: worker,
					callbacks: new haxe.ds.IntMap(),
					taskCosts: new haxe.ds.IntMap(),
					taskLoad: 0,
				}

				worker.postMessage({
					type: 'init',
					config: _workerConfig,
					transcoderBinary: _transcoderBinary,
				});

				worker.onmessage = function(e) {
					var message = e.data;

					switch (message.type) {
						case 'transcode':
							workerTask.callbacks.get(message.id).resolve(message);
						case 'error':
							workerTask.callbacks.get(message.id).reject(message);
						default:
							throw 'BasisTextureLoader: Unexpected message, "' + message.type + '"';
					}
				};

				_workerPool.push(workerTask);
			} else {
				_workerPool.sort(function(a, b) {
					return a.taskLoad > b.taskLoad ? -1 : 1;
				});
			}

			return _workerPool[_workerPool.length - 1];
		});
	}
}

enum abstract BASIS_FORMAT(Int) from Int to Int {
	final cTFETC1 = 0;
	final cTFETC2 = 1;
	final cTFBC1 = 2;
	final cTFBC3 = 3;
	final cTFBC4 = 4;
	final cTFBC5 = 5;
	final cTFBC7_M6_OPAQUE_ONLY = 6;
	final cTFBC7_M5 = 7;
	final cTFPVRTC1_4_RGB = 8;
	final cTFPVRTC1_4_RGBA = 9;
	final cTFASTC_4x4 = 10;
	final cTFATC_RGB = 11;
	final cTFATC_RGBA_INTERPOLATED_ALPHA = 12;
	final cTFRGBA32 = 13;
	final cTFRGB565 = 14;
	final cTFBGR565 = 15;
	final cTFRGBA4444 = 16;
}

enum abstract FORMAT(Int) from Int to Int {
	final RGB_S3TC_DXT1_Format = 33776;
	final RGBA_S3TC_DXT1_Format = 33777;
	final RGBA_S3TC_DXT3_Format = 33778;
	final RGBA_S3TC_DXT5_Format = 33779;
	final RGB_PVRTC_4BPPV1_Format = 35840;
	final RGB_PVRTC_2BPPV1_Format = 35841;
	final RGBA_PVRTC_4BPPV1_Format = 35842;
	final RGBA_PVRTC_2BPPV1_Format = 35843;
	final RGB_ETC1_Format = 36196;
	final RGBA_ASTC_4x4_Format = 37808;
	final RGBA_ASTC_5x4_Format = 37809;
	final RGBA_ASTC_5x5_Format = 37810;
	final RGBA_ASTC_6x5_Format = 37811;
	final RGBA_ASTC_6x6_Format = 37812;
	final RGBA_ASTC_8x5_Format = 37813;
	final RGBA_ASTC_8x6_Format = 37814;
	final RGBA_ASTC_8x8_Format = 37815;
	final RGBA_ASTC_10x5_Format = 37816;
	final RGBA_ASTC_10x6_Format = 37817;
	final RGBA_ASTC_10x8_Format = 37818;
	final RGBA_ASTC_10x10_Format = 37819;
	final RGBA_ASTC_12x10_Format = 37820;
	final RGBA_ASTC_12x12_Format = 37821;
}

typedef WorkerTask = {
	worker:js.html.Worker,
	callbacks:haxe.ds.IntMap<{resolve:(value:Dynamic) -> Void, reject:(reason:Dynamic) -> Void}>,
	taskCosts:haxe.ds.IntMap<Int>,
	taskLoad:Int,
}

class BasisWorker {
	static public final func = "function () {

        var config;
        var transcoderPending;
        var _BasisFile;

        onmessage = function ( e ) {

            var message = e.data;

            switch ( message.type ) {

                case 'init':
                    config = message.config;
                    init( message.transcoderBinary );
                    break;

                case 'transcode':
                    transcoderPending.then( () => {

                        try {

                            var { width, height, hasAlpha, mipmaps, format } = transcode( message.buffer );

                            var buffers = [];

                            for ( var i = 0; i < mipmaps.length; ++ i ) {

                                buffers.push( mipmaps[ i ].data.buffer );

                            }
                            self.postMessage( { type: 'transcode', id: message.id, width, height, hasAlpha, mipmaps, format }, buffers );

                        } catch ( error ) {

                            console.error( error );

                            self.postMessage( { type: 'error', id: message.id, error: error.message } );

                        }

                    } );
                    break;

            }

        };

        function init( wasmBinary ) {

            var BasisModule;
            transcoderPending = new Promise( ( resolve ) => {

                BasisModule = { wasmBinary, onRuntimeInitialized: resolve };
                BASIS( BasisModule );

            } ).then( () => {

                var { BasisFile, initializeBasis } = BasisModule;

                _BasisFile = BasisFile;

                initializeBasis();

            } );

        }

        function transcode( buffer ) {

            var basisFile = new _BasisFile( new Uint8Array( buffer ) );

            var width = basisFile.getImageWidth( 0, 0 );
            var height = basisFile.getImageHeight( 0, 0 );
            var levels = basisFile.getNumLevels( 0 );
            var hasAlpha = basisFile.getHasAlpha();

            function cleanup() {

                basisFile.close();
                basisFile.delete();

            }

            if ( ! hasAlpha ) {

                switch ( config.format ) {

                    case 9: // Hardcoded: BASIS_FORMAT.cTFPVRTC1_4_RGBA
                        config.format = 8; // BASIS_FORMAT.cTFPVRTC1_4_RGB;
                        break;
                    default:
                        break;

                }

            }

            if ( ! width || ! height || ! levels ) {

                cleanup();
                throw new Error( 'BasisTextureLoader:  Invalid .basis file' );

            }

            if ( ! basisFile.startTranscoding() ) {

                cleanup();
                throw new Error( 'BasisTextureLoader: .startTranscoding failed' );

            }

            var mipmaps = [];

            for ( var mip = 0; mip < levels; mip ++ ) {

                var mipWidth = basisFile.getImageWidth( 0, mip );
                var mipHeight = basisFile.getImageHeight( 0, mip );
                var dst = new Uint8Array( basisFile.getImageTranscodedSizeInBytes( 0, mip, config.format ) );

                var status = basisFile.transcodeImage(
                    dst,
                    0,
                    mip,
                    config.format,
                    0,
                    hasAlpha
                );

                if ( ! status ) {

                    cleanup();
                    throw new Error( 'BasisTextureLoader: .transcodeImage failed.' );

                }

                mipmaps.push( { data: dst, width: mipWidth, height: mipHeight } );

            }

            cleanup();

            return { width, height, hasAlpha, mipmaps, format: config.format };

        }

    }";
}
#end
