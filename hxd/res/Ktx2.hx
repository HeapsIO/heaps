package hxd.res;

import haxe.io.UInt8Array;
using Lambda;

#if js
typedef Promise<T> = js.lib.Promise<T>;
typedef ImageData = js.html.ImageData;
typedef Uint8Array = js.lib.Uint8Array;
typedef Worker = js.html.Worker;
#else
// TODO: Add support for native targets, just dummy typing for now...
class Promise<T> {
	public function new(cb:(resolve:T, reject:T) -> Void) {}

	public function then<T>(cb:(message:T) -> Void) {};

	static function resolve<T>(thenable:Dynamic<T>):Promise<T> {
		return null;
	};

	static function reject<T>(?reason:Dynamic):Promise<T> {
		return null;
	};
}

typedef ImageData = Dynamic;
typedef Uint8Array = UInt8Array;

class Worker {
	public var index:Int;

	public function new(url:String) {}

	public function postMessage(message:Dynamic, ?transfer:Array<Dynamic>) {}

	dynamic public function onmessage(e:{data:{type:String, id:Int}}) {};
}
#end

/**
	Ktx2 file parser.
**/
class Ktx2 {
	static inline final BYTE_INDEX_ERROR = 'ktx2 files with a file size exceeding 32 bit address space is not supported';

	/**
		Read ktx2 file

		@param bytes BytesInput containing ktx2 file data

		@return Parsed ktx2 file
	**/
	public static function readFile(bytes:haxe.io.BytesInput):Ktx2File {
		final header = readHeader(bytes);
		final levels = readLevels(bytes, header.levelCount);
		final dfd = readDfd(bytes);
		final file:Ktx2File = {
			header: header,
			levels: levels,
			dfd: dfd,
			data: new Uint8Array(cast @:privateAccess bytes.b),
			supercompressionGlobalData: null,
		}
		return file;
	}

	public static function readHeader(bytes:haxe.io.BytesInput):KTX2Header {
		final ktx2Id = [
			// '´', 'K', 'T', 'X', '2', '0', 'ª', '\r', '\n', '\x1A', '\n'
			0xAB,
			0x4B,
			0x54,
			0x58,
			0x20,
			0x32,
			0x30,
			0xBB,
			0x0D,
			0x0A,
			0x1A,
			0x0A,
		];

		final matching = ktx2Id.mapi((i, id) -> id == bytes.readByte());

		if (matching.contains(false)) {
			throw 'Invalid KTX2 header';
		}
		final header:KTX2Header = {
			vkFormat: bytes.readInt32(),
			typeSize: bytes.readInt32(),
			pixelWidth: bytes.readInt32(),
			pixelHeight: bytes.readInt32(),
			pixelDepth: bytes.readInt32(),
			layerCount: bytes.readInt32(),
			faceCount: bytes.readInt32(),
			levelCount: bytes.readInt32(),
			supercompressionScheme: bytes.readInt32(),

			dfdByteOffset: bytes.readInt32(),
			dfdByteLength: bytes.readInt32(),
			kvdByteOffset: bytes.readInt32(),
			kvdByteLength: bytes.readInt32(),
			sgdByteOffset: {
				final val = bytes.read(8).getInt64(0);
				if (val.high > 0) {
					throw BYTE_INDEX_ERROR;
				}
				val.low;
			},
			sgdByteLength: {
				final val = bytes.read(8).getInt64(0);
				if (val.high > 0) {
					throw BYTE_INDEX_ERROR;
				}
				val.low;
			}
		}

		if (header.pixelDepth > 0) {
			throw 'Failed to parse KTX2 file - Only 2D textures are currently supported.';
		}
		if (header.layerCount > 1) {
			throw 'Failed to parse KTX2 file - Array textures are not currently supported.';
		}
		if (header.faceCount > 1) {
			throw 'Failed to parse KTX2 file - Cube textures are not currently supported.';
		}
		return header;
	}

	static function readLevels(bytes:haxe.io.BytesInput, levelCount:Int):Array<KTX2Level> {
		levelCount = hxd.Math.imax(1, levelCount);
		final length = levelCount * 3 * (2 * 4);
		final level = bytes.read(length);
		final levels:Array<KTX2Level> = [];

		while (levelCount-- > 0) {
			levels.push({
				byteOffset: {
					final val = level.getInt64(0);
					if (val.high > 0) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
				byteLength: {
					final val = level.getInt64(8);
					if (val.high > 0) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
				uncompressedByteLength: {
					final val = level.getInt64(16);
					if (val.high > 0) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
			});
		}
		return levels;
	}

	static function readDfd(bytes:haxe.io.BytesInput):KTX2DFD {
		final totalSize = bytes.readInt32();
		final vendorId = bytes.readInt16();
		final descriptorType = bytes.readInt16();
		final versionNumber = bytes.readInt16();
		final descriptorBlockSize = bytes.readInt16();
		final numSamples = Std.int((descriptorBlockSize - 24) / 16);
		final dfdBlock:KTX2DFD = {
			vendorId: vendorId,
			descriptorType: descriptorType,
			versionNumber: versionNumber,
			descriptorBlockSize: descriptorBlockSize,
			colorModel: bytes.readByte(),
			colorPrimaries: bytes.readByte(),
			transferFunction: bytes.readByte(),
			flags: bytes.readByte(),
			texelBlockDimension: {
				x: bytes.readByte() + 1,
				y: bytes.readByte() + 1,
				z: bytes.readByte() + 1,
				w: bytes.readByte() + 1,
			},
			bytesPlane: [
				bytes.readByte() /* bytesPlane0 */,
				bytes.readByte() /* bytesPlane1 */,
				bytes.readByte() /* bytesPlane2 */,
				bytes.readByte() /* bytesPlane3 */,
				bytes.readByte() /* bytesPlane4 */,
				bytes.readByte() /* bytesPlane5 */,
				bytes.readByte() /* bytesPlane6 */,
				bytes.readByte() /* bytesPlane7 */,
			],
			numSamples: numSamples,
			samples: [
				for (i in 0...numSamples) {
					final bitOffset = bytes.readUInt16();
					final bitLength = bytes.readByte() + 1;
					final channelType = bytes.readByte();
					final channelFlags = (channelType & 0xf0) >> 4;
					final samplePosition = [
						bytes.readByte() /* samplePosition0 */,
						bytes.readByte() /* samplePosition1 */,
						bytes.readByte() /* samplePosition2 */,
						bytes.readByte() /* samplePosition3 */,
					];
					final sampleLower = bytes.readUInt16() + bytes.readUInt16();
					final sampleUpper = bytes.readUInt16() + bytes.readUInt16();
					final sample:KTX2Sample = {
						bitOffset: bitOffset,
						bitLength: bitLength,
						channelType: channelType & 0x0F,
						channelFlags: channelFlags,
						samplePosition: samplePosition,
						sampleLower: sampleLower,
						sampleUpper: sampleUpper,
					};
					sample;
				}
			],
		}
		return dfdBlock;
	}
}

/**
	Handles transcoding of Ktx2 textures
**/
class Ktx2Decoder {
	public static var mscTranscoder:Dynamic;
	public static var workerLimit = 4;

	static var _workerNextTaskID = 1;
	static var _workerSourceURL:String;
	static var _workerConfig:BasisWorkerConfig;
	static var _workerPool:Array<WorkerTask> = [];
	static var _transcoderPending:Promise<Dynamic>;
	static var _transcoderBinary:haxe.io.Bytes;
	static var _transcoderScript:String;
	static var _transcoderLoading:Promise<{script:String, wasm:haxe.io.Bytes}>;

	/**
		Transcode and get the texture data.

		@param bytes Texture data as BytesInput
		@param cb Callback invoked when transcoding is done, passing the transcoded texture data.

	**/
	public static function getTranscodedData(buffer:haxe.io.BytesInput, cb:(data:BasisWorkerMessageData, header:KTX2Header) -> Void) {
		_workerConfig ??= detectSupport();
		if (_workerConfig == null) {
			throw "Not implemented: Ktx2 only supported on js target";
		}

		final ktx2File = Ktx2.readFile(buffer);
		// Determine basis format
		final basisFormat = if (ktx2File.header.vkFormat == 0) {
			if (ktx2File.dfd.colorModel == Ktx2.DFDModel.ETC1S)
				ETC1S
			else if (ktx2File.dfd.colorModel == Ktx2.DFDModel.UASTC)
				UASTC
			else if (ktx2File.dfd.transferFunction == Ktx2.DFDTransferFunction.LINEAR)
				UASTC_HDR
			else
				throw "KTX2Loader: Unknown Basis encoding";
		} else {
			throw "KTX2Loader: Non-zero vkFormat not supported";
		};

		// Get transcoder format
		final formatInfo = getTranscoderFormat(basisFormat, ktx2File.header.pixelWidth, ktx2File.header.pixelHeight, ktx2File.dfd.hasAlpha());
		getWorker().then((task:WorkerTask) -> {
			final worker = task.worker;
			final taskID = _workerNextTaskID++;

			final textureDone = new Promise((resolve, reject) -> {
				task.callbacks.set(taskID, {
					resolve: resolve,
					reject: reject,
				});
				task.taskCosts.set(taskID, buffer.length);
				task.taskLoad += task.taskCosts.get(taskID);
				buffer.position = 0;
				final bytes = buffer.readAll().getData();
				worker.postMessage({
					type: 'transcode',
					id: taskID,
					buffer: bytes,
					formatInfo: formatInfo,
				}, [bytes]);
			});

			textureDone.then((message:BasisWorkerMessage) -> {
				if (message.type == 'error') {
					throw 'Unable to decode ktx2 file: ${message.error}';
				}
				buffer.position = 0;
				final header = Ktx2.readFile(buffer).header;
				cb(message.data, header);
			});
		});
	}

	static function detectSupport() {
		#if js
		final driver:h3d.impl.GlDriver = cast h3d.Engine.getCurrent().driver;
		return {
			astcSupported: driver.textureSupport.astc,
			etc1Supported: driver.textureSupport.etc1,
			etc2Supported: driver.textureSupport.etc2,
			dxtSupported: driver.textureSupport.dxt,
			bptcSupported: driver.textureSupport.bptc,
		}
		#else
		return null;
		#end
	}

	#if non_res_ktx2
	/**
		Get transcoded texture. 

		Used in combination with "non_res_ktx2" flag when handling loading of ktx2 outside of heaps res system.

		@param bytes Texture data as BytesInput
		@param cb Callback invoked when transcoding is done, passing the transcoded texture.
	**/
	public static function getTexture(bytes:haxe.io.BytesInput, cb:(texture:h3d.mat.Texture, header:KTX2Header) -> Void) {
		getTranscodedData(bytes, (data, header) -> {
			cb(createTexture(data, header), header);
		});
	}

	static function createTexture(data:BasisWorkerMessageData, header:KTX2Header) {
		final create = (fmt:hxd.PixelFormat) -> {
			if (header.faceCount > 1 || header.layerCount > 1) {
				// TODO: Handle cube texture
				throw 'Multi texture ktx2 files not supported';
			}
			final face = data.faces[0];
			final mipmaps:Array<ImageData> = face.mipmaps;
			final texture = new h3d.mat.Texture(data.width, data.height, null, fmt);
			var level = 0;
			for (mipmap in mipmaps) {
				final bytes = haxe.io.Bytes.ofData(cast mipmap.data);
				final pixels = new hxd.Pixels(mipmap.width, mipmap.height, bytes, fmt);
				texture.uploadPixels(pixels, level);
				level++;
			}
			if (mipmaps.length > 1) {
				texture.flags.set(MipMapped);
				texture.mipMap = Linear;
			}
			texture;
		}
		final texture = switch (data.format) {
			case EngineFormat.RGBA_ASTC_4x4_Format: create(hxd.PixelFormat.ASTC(10));
			case EngineFormat.RGBA_BPTC_Format: create(hxd.PixelFormat.S3TC(7));
			case EngineFormat.RGBA_S3TC_DXT5_Format: create(hxd.PixelFormat.S3TC(3));
			case EngineFormat.RGB_ETC1_Format: create(hxd.PixelFormat.ETC(0));
			case EngineFormat.RGBA_ETC2_EAC_Format: create(hxd.PixelFormat.ETC(1));
			default:
				throw 'Ktx2Loader: No supported format available.';
		}
		return texture;
	}
	#end

	static function getWorker():Promise<WorkerTask> {
		return initTranscoder().then(val -> {
			if (_workerPool.length < workerLimit) {
				final worker = new Worker(_workerSourceURL);
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

				worker.onmessage = e -> {
					var message = e.data;
					switch (message.type) {
						case 'transcode':
							workerTask.callbacks.get(message.id).resolve(message);
						case 'error':
							workerTask.callbacks.get(message.id).reject(message);
						default:
							throw 'Ktx2Loader: Unexpected message, "${message.type}"';
					}
				};
				_workerPool.push(workerTask);
			} else {
				_workerPool.sort((a, b) -> a.taskLoad > b.taskLoad ? -1 : 1);
			}

			return _workerPool[_workerPool.length - 1];
		});
	}

	#if js
	static function initTranscoder() {
		_transcoderLoading = if (_transcoderLoading == null) {
			// Load transcoder wrapper.
			final jsLoader = new hxd.net.BinaryLoader('vendor/basis_transcoder.js');
			final jsContent = new Promise((resolve, reject) -> {
				jsLoader.onLoaded = resolve;
				jsLoader.onError = reject;
				jsLoader.load();
			});
			// Load transcoder WASM binary.
			final binaryLoader = new hxd.net.BinaryLoader('vendor/basis_transcoder.wasm');
			final binaryContent = new Promise((resolve, reject) -> {
				binaryLoader.onLoaded = resolve;
				binaryLoader.onError = reject;
				binaryLoader.load(true);
			});
			Promise.all([jsContent, binaryContent]).then(arr -> {script: arr[0].toString(), wasm: arr[1]});
		} else {
			_transcoderLoading;
		}

		_transcoderPending = _transcoderLoading.then(o -> {
			_transcoderScript = o.script;
			_transcoderBinary = o.wasm;
			final workerScript = '
			let config;
			let transcoderPending;
			let formatInfo;
			let BasisModule;
			// Inject the basis transcoder script into the workers context
			${_transcoderScript}

			self.onmessage = function(e) {
				const message = e.data;
				switch (message.type) {
					case "init":
						config = message.config;
						init(message.transcoderBinary);
						break;
					case "transcode":
						formatInfo = message.formatInfo;
						transcoderPending.then(function() {
							try {
								const { faces, buffers, width, height, hasAlpha, format, type, dfdFlags } = transcode( message.buffer );
								self.postMessage( { type: "transcode", id: message.id, data: { faces, width, height, hasAlpha, format, type, dfdFlags } }, buffers );
							} catch (error) {
								self.postMessage({ type: "error", id: message.id, error: error.message });
							}
						});
						break;
				}
			};

			function init(wasmBinary) {
				transcoderPending = new Promise(function(resolve) {
					BasisModule = { wasmBinary, onRuntimeInitialized: resolve };
					BASIS(BasisModule);
				}).then(function() {
					BasisModule.initializeBasis();
				});
			}

			/** Concatenates N byte arrays. */
			function concat( arrays ) {
				if ( arrays.length === 1 ) return arrays[ 0 ];
				let totalByteLength = 0;
				for ( let i = 0; i < arrays.length; i ++ ) {
					const array = arrays[ i ];
					totalByteLength += array.byteLength;
				}
				const result = new Uint8Array( totalByteLength );
				let byteOffset = 0;
				for ( let i = 0; i < arrays.length; i ++ ) {
					const array = arrays[ i ];
					result.set( array, byteOffset );
					byteOffset += array.byteLength;
				}
				return result;
			}

			function transcode(buffer) {
				let ktx2File = new BasisModule.KTX2File(new Uint8Array(buffer));
				function cleanup() {
					ktx2File.close();
					ktx2File.delete();
				}
				if ( ! ktx2File.isValid() ) {
					cleanup();
					throw new Error( "KTX2Loader:	Invalid or unsupported .ktx2 file" );
				}
				let basisFormat;
				if ( ktx2File.isUASTC() ) {
					basisFormat = ${BasisFormat.UASTC.getIndex()};
				} else if ( ktx2File.isETC1S() ) {
					basisFormat = ${BasisFormat.ETC1S.getIndex()};
				} else if ( ktx2File.isHDR() ) {
					basisFormat = ${BasisFormat.UASTC_HDR.getIndex()};
				} else {
					throw new Error( "KTX2Loader: Unknown Basis encoding" );
				}
				const width = ktx2File.getWidth();
				const height = ktx2File.getHeight();
				const layerCount = ktx2File.getLayers() || 1;
				const levelCount = ktx2File.getLevels();
				const faceCount = ktx2File.getFaces();
				const hasAlpha = ktx2File.getHasAlpha();
				const dfdFlags = ktx2File.getDFDFlags();
				const { transcoderFormat, engineFormat, engineType } = formatInfo;
				if ( ! width || ! height || ! levelCount ) {
					cleanup();
					throw new Error("KTX2Loader: Invalid texture ktx2File:" + JSON.stringify(ktx2File));
				}
				if ( ! ktx2File.startTranscoding() ) {
					cleanup();
					throw new Error( "KTX2Loader: .startTranscoding failed" );
				}
				const faces = [];
				const buffers = [];
				for ( let face = 0; face < faceCount; face ++ ) {
					const mipmaps = [];
					for ( let mip = 0; mip < levelCount; mip ++ ) {
						const layerMips = [];
						let mipWidth, mipHeight;
						for ( let layer = 0; layer < layerCount; layer ++ ) {
							const levelInfo = ktx2File.getImageLevelInfo( mip, layer, face );
							if ( face === 0 && mip === 0 && layer === 0 && ( levelInfo.origWidth % 4 !== 0 || levelInfo.origHeight % 4 !== 0 ) ) {
								console.warn( "KTX2Loader: ETC1S and UASTC textures should use multiple-of-four dimensions." );
							}
							if ( levelCount > 1 ) {
								mipWidth = levelInfo.origWidth;
								mipHeight = levelInfo.origHeight;
							} else {
								// Handles non-multiple-of-four dimensions in textures without mipmaps. Textures with
								// mipmaps must use multiple-of-four dimensions, for some texture formats and APIs.
								// See mrdoob/three.js#25908.
								mipWidth = levelInfo.width;
								mipHeight = levelInfo.height;
							}
							let dst = new Uint8Array( ktx2File.getImageTranscodedSizeInBytes( mip, layer, 0, transcoderFormat ) );
							const status = ktx2File.transcodeImage( dst, mip, layer, face, transcoderFormat, 0, - 1, - 1 );
							if ( engineType === ${EngineType.HalfFloatType} ) {
								dst = new Uint16Array( dst.buffer, dst.byteOffset, dst.byteLength / Uint16Array.BYTES_PER_ELEMENT );
							}
							if ( ! status ) {
								cleanup();
								throw new Error( "KTX2Loader: .transcodeImage failed." );
							}
							layerMips.push( dst );
						}
						const mipData = concat( layerMips );
						mipmaps.push( { data: mipData, width: mipWidth, height: mipHeight } );
						buffers.push( mipData.buffer );
					}
					faces.push( { mipmaps, width, height, format: engineFormat, type: engineType } );
				}
				cleanup();
				return { faces, buffers, width, height, hasAlpha, dfdFlags, format: engineFormat, type: engineType };
			}
		';

			final blob = new js.html.Blob([workerScript], {type: "text/javascript"});
			_workerSourceURL = js.Syntax.code("URL.createObjectURL({0})", blob);
		});
		return _transcoderPending;
	}
	#else
	static function initTranscoder() {
		return null;
	}
	#end

	public static function getTranscoderFormat(basisFormat:BasisFormat, width:Int, height:Int,
			hasAlpha:Bool):{transcoderFormat:Int, engineFormat:Int, engineType:Int} {
		_workerConfig ??= detectSupport();
		final caps = _workerConfig;
		return switch basisFormat {
			case BasisFormat.ETC1S if (hasAlpha && caps.etc2Supported):
				{transcoderFormat: TranscoderFormat.ETC2, engineFormat: EngineFormat.RGBA_ETC2_EAC_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.ETC1S if (!hasAlpha && (caps.etc1Supported || caps.etc2Supported)):
				{transcoderFormat: TranscoderFormat.ETC1, engineFormat: EngineFormat.RGB_ETC1_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.ETC1S if (caps.bptcSupported):
				{transcoderFormat: TranscoderFormat.BC7_M5, engineFormat: EngineFormat.RGBA_BPTC_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.ETC1S if (hasAlpha && caps.dxtSupported):
				{transcoderFormat: TranscoderFormat.BC3, engineFormat: EngineFormat.RGBA_S3TC_DXT5_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.ETC1S if (!hasAlpha && caps.dxtSupported):
				{transcoderFormat: TranscoderFormat.BC1, engineFormat: EngineFormat.RGB_S3TC_DXT1_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.ETC1S:
				{transcoderFormat: TranscoderFormat.RGBA32, engineFormat: EngineFormat.RGBAFormat, engineType: EngineType.UnsignedByteType};

			case BasisFormat.UASTC if (caps.astcSupported):
				{transcoderFormat: TranscoderFormat.ASTC_4x4, engineFormat: EngineFormat.RGBA_ASTC_4x4_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC if (caps.bptcSupported):
				{transcoderFormat: TranscoderFormat.BC7_M5, engineFormat: EngineFormat.RGBA_BPTC_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC if (hasAlpha && caps.etc2Supported):
				{transcoderFormat: TranscoderFormat.ETC2, engineFormat: EngineFormat.RGBA_ETC2_EAC_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC if ((!hasAlpha && caps.etc2Supported) || caps.etc1Supported):
				{transcoderFormat: TranscoderFormat.ETC1, engineFormat: EngineFormat.RGB_ETC1_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC if (hasAlpha && caps.dxtSupported):
				{transcoderFormat: TranscoderFormat.BC3, engineFormat: EngineFormat.RGBA_S3TC_DXT5_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC if (!hasAlpha && caps.dxtSupported):
				{transcoderFormat: TranscoderFormat.BC1, engineFormat: EngineFormat.RGB_S3TC_DXT1_Format, engineType: EngineType.UnsignedByteType};
			case BasisFormat.UASTC:
				{transcoderFormat: TranscoderFormat.RGBA32, engineFormat: EngineFormat.RGBAFormat, engineType: EngineType.UnsignedByteType};

			case BasisFormat.UASTC_HDR:
				{transcoderFormat: TranscoderFormat.RGBA_HALF, engineFormat: EngineFormat.RGBAFormat, engineType: EngineType.HalfFloatType};

			case _:
				throw 'KTX2Loader: Failed to identify transcoding target.';
		}
	}

	static function isPowerOfTwo(value:Int):Bool {
		return value > 0 && (value & (value - 1)) == 0;
	}
}

typedef Ktx2File = {
	header:KTX2Header,
	levels:Array<KTX2Level>,
	dfd:KTX2DFD,
	data:Uint8Array,
	supercompressionGlobalData:KTX2SupercompressionGlobalData,
}

enum abstract SuperCompressionScheme(Int) from Int to Int {
	final NONE = 0;
	final BASISLZ = 1;
	final ZSTANDARD = 2;
	final ZLIB = 3;
}

enum abstract DFDModel(Int) from Int to Int {
	final ETC1S = 163;
	final UASTC = 166;
}

enum abstract DFDChannel_ETC1S(Int) from Int to Int {
	final RGB = 0;
	final RRR = 3;
	final GGG = 4;
	final AAA = 15;
}

enum abstract DFDChannel_UASTC(Int) from Int to Int {
	final RGB = 0;
	final RGBA = 3;
	final RRR = 4;
	final RRRG = 5;
}

enum abstract DFDTransferFunction(Int) from Int to Int {
	final LINEAR = 1;
	final SRGB = 2;
}

enum abstract SupercompressionScheme(Int) from Int to Int {
	public final None = 0;
	public final BasisLZ = 1;
	public final ZStandard = 2;
	public final ZLib = 3;
}

/** 
	Ktx2 file header

	See https://github.khronos.org/KTX-Specification/ktxspec.v2.html for detailed information.
**/
@:structInit class KTX2Header {
	/**
		Vulkan format. Will be 0 for universal texture formats.
	**/
	public final vkFormat:Int;

	/**
		Size of data type in bytes used to upload data to a graphics API.
	**/
	public final typeSize:Int;

	/**
		The width of texture image for level 0, in pixels.
	**/
	public final pixelWidth:Int;

	/**
		The height of texture image for level 0, in pixels.
	**/
	public final pixelHeight:Int;

	/**
		The depth of texture image for level 0, in pixels.
	**/
	public final pixelDepth:Int;

	/**
		Number of array elements. If texture is not an array texture, layerCount must equal 0.
	**/
	public final layerCount:Int;

	/**
		Number of cubemap faces. For cubemaps and cubemap arrays this must be 6. For non cubemaps this must be 1.
	**/
	public final faceCount:Int;

	/**
		Specifies number of mip levels.
	**/
	public final levelCount:Int;

	/***
		Indicates if supercompression scheme has been applied. 0=None, 1=BasisLZ, 2=Zstandard, 3=ZLIB
	**/
	public final supercompressionScheme:Int;

	/**
		Offset from start of file for dfdTotalSize field in Data Format Descriptor
	**/
	public final dfdByteOffset:Int;

	/**
		Total number of bytes in the Data Format Descriptor, including dfdTotalSize field.
	**/
	public final dfdByteLength:Int;

	/**
		Offset of key/value pair data
	**/
	public final kvdByteOffset:Int;

	/**
		Total number of bytes of key/value data
	**/
	public final kvdByteLength:Int;

	/**
		The offset from the start of the file of supercompressionGlobalData.
	**/
	public final sgdByteOffset:Int;

	/**
		Number of bytes of supercompressionGlobalData. 
	**/
	public final sgdByteLength:Int;

	public function needZSTDDecoder() {
		return supercompressionScheme == SupercompressionScheme.ZStandard;
	}
}

typedef KTX2Level = {
	/**
		Byte offset. According to spec this should be 64 bit, but since a lot of byte code in haxe is using regular 32 bit Int for indexing, 
		supporting files too large to fit in 32bit space is complicated and should not be needed for individual game assets. 
	**/
	final byteOffset:Int;

	final byteLength:Int;
	final uncompressedByteLength:Int;
}

typedef KTX2Sample = {
	final bitOffset:Int;
	final bitLength:Int;
	final channelType:Int;
	final channelFlags:Int;
	final samplePosition:Array<Int>;
	final sampleLower:Int;
	final sampleUpper:Int;
}

/** Ktx2 Document Format Description */
@:structInit class KTX2DFD {
	/**
		Defined as 0 in spec
	**/
	public final vendorId:Int;

	/**
		Defined as 0 in spec
	**/
	public final descriptorType:Int;

	/**
		Defined as 2 in spec for ktx2
	**/
	public final versionNumber:Int;

	/**
		Size in bytes of this Descriptor Block
	**/
	public final descriptorBlockSize:Int;

	/**
		Color model for encoded data (ETC1S=163, UASTC=166)
	**/
	public final colorModel:Int;

	/**
		Color primaries used when encoding. BT709/SRGB (1) recommended for standard dynamic range, standard gamut images. See KHR_DF_PRIMARIES in khr_df.h for other values.
	**/
	public final colorPrimaries:Int;

	/**
		Encoding curve used to map luminance, with values like KHR_DF_TRANSFER_LINEAR, KHR_DF_TRANSFER_SRGB, or KHR_DF_TRANSFER_ST2084 for HDR. See KHR_DF_TRANSFER in khr_df.h for other values.
	**/
	public final transferFunction:Int;

	/**
		Indicates if premultiplied aplha should be used. KHR_DF_FLAG_ALPHA_PREMULTIPLIED (1) for PMA, or KHR_DF_FLAG_ALPHA_STRAIGHT (0) for non-PMA.
	**/
	public final flags:Int;

	/**
		Integer bound on range of coordinates covered by repeating block described by samples. Four separate values, represented as unsigned 8-bit integers, are supported, corresponding to successive dimensions.
	**/
	public final texelBlockDimension:{
		x:Int,
		y:Int,
		z:Int,
		w:Int,
	};

	/**
		Number of bytes which a plane contributes to the format.
	**/
	public final bytesPlane:Array<Int>;

	/**
		Number of samples present in the format.
	**/
	public final numSamples:Int;

	/**
		Samples data
	**/
	public final samples:Array<KTX2Sample>;

	/**
		Check if texture data has alpha channel

		@return True if file has alpha channel
	**/
	public function hasAlpha() {
		return switch colorModel {
			case hxd.res.Ktx2.DFDModel.ETC1S: numSamples == 2 && (samples[0].channelType == DFDChannel_ETC1S.AAA
					|| samples[1].channelType == DFDChannel_ETC1S.AAA);
			case hxd.res.Ktx2.DFDModel.UASTC:
				samples[0].channelType == DFDChannel_UASTC.RGBA;
			default: throw 'Unsupported colorModel in ktx2 file ${colorModel}';
		}
	}

	/**
		Check if texture data is in gamma space.

		@return True if texture is in gamma space
	**/
	public function isInGammaSpace() {
		return transferFunction == DFDTransferFunction.SRGB;
	}
}

typedef KTX2ImageDesc = {
	final imageFlags:Int;
	final rgbSliceByteOffset:Int;
	final rgbSliceByteLength:Int;
	final alphaSliceByteOffset:Int;
	final alphaSliceByteLength:Int;
}

typedef KTX2SupercompressionGlobalData = {
	final endpointCount:Int;
	final selectorCount:Int;
	final endpointsByteLength:Int;
	final selectorsByteLength:Int;
	final tablesByteLength:Int;
	final extendedByteLength:Int;
	final imageDescs:Array<KTX2ImageDesc>;
	final endpointsData:haxe.io.UInt8Array;
	final selectorsData:haxe.io.UInt8Array;
	final tablesData:haxe.io.UInt8Array;
	final extendedData:haxe.io.UInt8Array;
}

@:keep
class TranscoderFormat {
	public static final ETC1 = 0;
	public static final ETC2 = 1;
	public static final BC1 = 2;
	public static final BC3 = 3;
	public static final BC4 = 4;
	public static final BC5 = 5;
	public static final BC7_M6_OPAQUE_ONLY = 6;
	public static final BC7_M5 = 7;

	public static final ASTC_4x4 = 10;
	public static final ATC_RGB = 11;
	public static final ATC_RGBA_INTERPOLATED_ALPHA = 12;
	public static final RGBA32 = 13;
	public static final RGB565 = 14;
	public static final BGR565 = 15;
	public static final RGBA4444 = 16;
	public static final BC6H = 22;
	public static final RGB_HALF = 24;
	public static final RGBA_HALF = 25;
}

enum TranscoderType {
	cTFETC1;
	cTFETC2;
	cTFBC1;
	cTFBC3;
	cTFBC4;
	cTFBC5;
	cTFBC7_M6_OPAQUE_ONLY;
	cTFBC7_M5;
	cTFPVRTC1_4_RGB;
	cTFPVRTC1_4_RGBA;
	cTFASTC_4x4;
	cTFATC_RGB1;
	cTFATC_RGBA_INTERPOLATED_ALPHA2;
	cTFRGBA321;
	cTFRGB5654;
	cTFBGR5655;
	cTFRGBA44446;
}

@:keep
enum BasisFormat {
	ETC1S;
	UASTC;
	UASTC_HDR;
}

@:keep
class EngineFormat {
	public static final RGBAFormat = 0x03FF;
	public static final RGBA8Format = 0x8058;
	public static final R8Format = 0x8229;
	public static final RG8Format = 0x822b;
	public static final RGBA_ASTC_4x4_Format = CompressedTextureFormat.ASTC_FORMAT.RGBA_4x4;
	public static final RGB_BPTC_UNSIGNED_Format = CompressedTextureFormat.BPTC_FORMAT.RGB_BPTC_UNSIGNED;
	public static final RGBA_BPTC_Format = CompressedTextureFormat.BPTC_FORMAT.RGBA_BPTC;
	public static final RGB_S3TC_DXT1_Format = CompressedTextureFormat.DXT_FORMAT.RGB_DXT1;
	public static final RGBA_S3TC_DXT1_Format = CompressedTextureFormat.DXT_FORMAT.RGBA_DXT1;
	public static final RGBA_S3TC_DXT5_Format = CompressedTextureFormat.DXT_FORMAT.RGBA_DXT5;
	public static final RGB_ETC1_Format = CompressedTextureFormat.ETC_FORMAT.RGB_ETC1;
	public static final RGBA_ETC2_EAC_Format = CompressedTextureFormat.ETC_FORMAT.RGBA_ETC2;
	public static final RGB_ETC2_Format = 0x9274;
}

@:keep
class EngineType {
	public static final UnsignedByteType = 1009;
	public static final FloatType = 1015;
	public static final HalfFloatType = 1016;
}

class InternalFormat {
	public static final COMPRESSED_SRGB_ALPHA_BPTC_UNORM_EXT = 0x8E8D;
}

/**
 * Defines a mipmap level
 */
@:structInit class MipmapLevel {
	/**
	 * The data of the mipmap level
	 */
	public var data:Null<UInt8Array> = null;

	/**
	 * The width of the mipmap level
	 */
	public final width:Int;

	/**
	 * The height of the mipmap level
	 */
	public final height:Int;
}

typedef WorkerTask = {
	worker:Worker,
	callbacks:haxe.ds.IntMap<{resolve:(value:Dynamic) -> Void, reject:(reason:Dynamic) -> Void}>,
	taskCosts:haxe.ds.IntMap<Int>,
	taskLoad:Int,
}

typedef BasisWorkerConfig = {
	astcSupported:Bool,
	etc1Supported:Bool,
	etc2Supported:Bool,
	dxtSupported:Bool,
	bptcSupported:Bool,
}

@:structInit class BasisWorkerMessage {
	public final id:String;
	public final type = 'transcode';
	public final data:BasisWorkerMessageData;
	public final error:String = null;
}

typedef BasisWorkerMessageData = {
	faces:Array<{
		mipmaps:Array<ImageData>,
		width:Int,
		height:Int,
		format:Int,
		type:Int
	}>,
	width:Int,
	height:Int,
	hasAlpha:Bool,
	format:Int,
	type:Int,
	dfdFlags:Int,
}
