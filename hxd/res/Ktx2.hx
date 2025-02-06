package hxd.res;
#if js
import haxe.io.UInt8Array;
using Lambda;
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
	public static function readFile( bytes : haxe.io.BytesInput ) : Ktx2File {
		final header = readHeader(bytes);
		final levels = readLevels(bytes, header.levelCount);
		final dfd = readDfd(bytes);
		final file : Ktx2File = {
			header: header,
			levels: levels,
			dfd: dfd,
			data: new js.lib.Uint8Array(@:privateAccess bytes.b),
			supercompressionGlobalData: null,
		}
		return file;
	}

	public static function readHeader( bytes : haxe.io.BytesInput) : KTX2Header {
		final ktx2Id = [
			// '´', 'K', 'T', 'X', '2', '0', 'ª', '\r', '\n', '\x1A', '\n'
			0xAB, 0x4B, 0x54, 0x58, 0x20, 0x32, 0x30, 0xBB, 0x0D, 0x0A, 0x1A, 0x0A,
		];
		
		final matching = ktx2Id.mapi((i, id) -> id == bytes.readByte());
		
		if( matching.contains(false) ) {
			throw 'Invalid KTX2 header';
		}
		final header  :KTX2Header = {
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
				if( val.high>0 ) {
					throw BYTE_INDEX_ERROR;
				}
				val.low;
			}, 
			sgdByteLength: {
				final val = bytes.read(8).getInt64(0);
				if( val.high>0 ) {
					throw BYTE_INDEX_ERROR;
				}
				val.low;
			}
		}

		if( header.pixelDepth>0 ) {
			throw 'Failed to parse KTX2 file - Only 2D textures are currently supported.';
		}
		if( header.layerCount>1 ) {
				throw 'Failed to parse KTX2 file - Array textures are not currently supported.';
		}
		if( header.faceCount>1 ) {
				throw 'Failed to parse KTX2 file - Cube textures are not currently supported.';
		}
		return header;
	}

	static function readLevels( bytes : haxe.io.BytesInput, levelCount : Int) : Array<KTX2Level> {
		levelCount = hxd.Math.imax(1, levelCount);
		final length = levelCount * 3 * (2 * 4);
		final level = bytes.read(length);
		final levels:Array<KTX2Level> = [];
		
		while( levelCount-- > 0 ) {
			levels.push({
				byteOffset: {
					final val = level.getInt64(0);
					if( val.high>0 ) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
				byteLength: {
					final val = level.getInt64(8);
					if( val.high>0 ) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
				uncompressedByteLength: {
					final val = level.getInt64(16);
					if( val.high>0 ) {
						throw BYTE_INDEX_ERROR;
					}
					val.low;
				},
			});
		}
		return levels;
	}

	static function readDfd( bytes : haxe.io.BytesInput) : KTX2DFD {
		final totalSize = bytes.readInt32();
		final vendorId = bytes.readInt16();
		final descriptorType = bytes.readInt16();
		final versionNumber = bytes.readInt16();
		final descriptorBlockSize = bytes.readInt16();
		final numSamples = Std.int((descriptorBlockSize-24)/16);
		final dfdBlock : KTX2DFD = {
			vendorId:vendorId,
			descriptorType: descriptorType,
			versionNumber: versionNumber,
			descriptorBlockSize: descriptorBlockSize,
			colorModel: bytes.readByte(),
			colorPrimaries: bytes.readByte(),
			transferFunction: bytes.readByte(),
			flags: bytes.readByte(),
			texelBlockDimension: {
				x: bytes.readByte()+1,
				y: bytes.readByte()+1,
				z: bytes.readByte()+1,
				w: bytes.readByte()+1,
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
				for( i in 0...numSamples ) {
					final bitOffset = bytes.readUInt16();
					final bitLength = bytes.readByte()+1;
					final channelType = bytes.readByte();
					final channelFlags =  (channelType & 0xf0)>>4;
					final samplePosition =  [
						bytes.readByte() /* samplePosition0 */,
						bytes.readByte() /* samplePosition1 */,
						bytes.readByte() /* samplePosition2 */,
						bytes.readByte() /* samplePosition3 */,
					];
					final sampleLower = bytes.readUInt16()+bytes.readUInt16();
					final sampleUpper = bytes.readUInt16()+bytes.readUInt16();
					final sample : KTX2Sample = {
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

class Ktx2Decoder {
	public static var mscTranscoder : Dynamic;
	public static var workerLimit = 4;

	static var _workerNextTaskID = 1;
	static var _workerSourceURL : String;
	static var _workerConfig : BasisWorkerConfig;
	static var _workerPool : Array<WorkerTask> = [];
	static var _transcoderPending : js.lib.Promise<Dynamic>;
	static var _transcoderBinary : haxe.io.Bytes;
	static var _transcoderScript : String;
	static var _transcoderLoading : js.lib.Promise<{ script : String, wasm : haxe.io.Bytes }>;

	public static function getTexture(bytes : haxe.io.BytesInput, cb : (texture : h3d.mat.Texture) -> Void) {
		createTexture(bytes, cb);
	}

	static function detectSupport(fmt : KtxTranscodeTarget) {
		final driver : h3d.impl.GlDriver = cast h3d.Engine.getCurrent().driver;
		return {
			astcSupported: driver.textureSupport.astc,
			etc1Supported: driver.textureSupport.etc1,
			etc2Supported: driver.textureSupport.etc2,
			dxtSupported: driver.textureSupport.dxt,
			bptcSupported: driver.textureSupport.bptc,
		}
	}

	static function getWorker() {
		return initTranscoder().then(val -> {
			if( _workerPool.length < workerLimit ) {
				final worker = new js.html.Worker(_workerSourceURL);
				final workerTask : WorkerTask = {
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
					switch( message.type ) {
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
	
			return _workerPool[_workerPool.length-1];
		});
	}

	static function createTexture( buffer : haxe.io.BytesInput, cb : (texture:h3d.mat.Texture) -> Void) {
		final ktx = Ktx2.readFile(buffer);

		final w = ktx.header.pixelWidth;
		final h = ktx.header.pixelHeight;
		
		final transcodeTarget = switch ktx.dfd.colorModel {
		case hxd.res.Ktx2.DFDModel.ETC1S: 
			KtxTranscodeTarget.ETC1S({}, {
				fmt: CompressedFormat.ETC1,
				alpha: ktx.dfd.hasAlpha(),
				needsPowerOfTwo: true,
			});
		case hxd.res.Ktx2.DFDModel.UASTC:
			KtxTranscodeTarget.UASTC({}, {
				fmt: CompressedFormat.ASTC,
				alpha: ktx.dfd.hasAlpha(),
				needsPowerOfTwo: true,
			});
		default: throw 'Unsupported colorModel in ktx2 file ${ktx.dfd.colorModel}';
		}
		_workerConfig = detectSupport(transcodeTarget);
		getWorker().then(task -> {
			final worker = task.worker;
			final taskID = _workerNextTaskID++;
	
			final textureDone = new js.lib.Promise((resolve, reject) -> {
				task.callbacks.set(taskID, {
					resolve: resolve,
					reject: reject,
				});
				task.taskCosts.set(taskID, buffer.length);
				task.taskLoad += task.taskCosts.get(taskID);
				buffer.position = 0;
				final bytes = buffer.readAll().getData();
				worker.postMessage({type: 'transcode', id: taskID, buffer: bytes}, [bytes]);
			});
	
			textureDone.then(( message : BasisWorkerMessage )-> {
				if( message.type == 'error' ) {
					throw 'Unable to decode ktx2 file: ${message.error}';
				}

				final w = message.data.width;
				final h = message.data.height;
				final create = (fmt:hxd.PixelFormat) -> {
					if( ktx.header.faceCount > 1 || ktx.header.layerCount > 1 ) {
						// TODO: Handle cube texture
						throw 'Multi texture ktx2 files not supported';
					}
					final face = message.data.faces[0];
					final mipmaps:Array<js.html.ImageData> = face.mipmaps;
					final texture = new h3d.mat.Texture(w, h, null, fmt);
					var level = 0;
					for (mipmap in mipmaps) {
						final bytes = haxe.io.Bytes.ofData(cast mipmap.data);
						final pixels = new hxd.Pixels(mipmap.width, mipmap.height, bytes, fmt);
						texture.uploadPixels(pixels, level);
						level++;
					}
					if(mipmaps.length>1) {
						texture.flags.set(MipMapped);
						texture.mipMap = Linear;
					}
					texture;
				}
				final texture = switch message.data.format {
					case EngineFormat.RGBA_ASTC_4x4_Format:
						create(hxd.PixelFormat.ASTC(10));
					case EngineFormat.RGB_BPTC_UNSIGNED_Format:
						create(hxd.PixelFormat.S3TC(6));
					case EngineFormat.RGBA_BPTC_Format:
						create(hxd.PixelFormat.S3TC(7));
					case EngineFormat.RGBA_S3TC_DXT5_Format:
						create(hxd.PixelFormat.S3TC(3));
					case EngineFormat.RGB_ETC1_Format:
						create(hxd.PixelFormat.ETC(0));
					case EngineFormat.RGBA_ETC2_EAC_Format:
						create(hxd.PixelFormat.ETC(1));
					default:
						throw 'Ktx2Loader: No supported format available.';
				}
	
				if( task != null && taskID > 0 ) {
					task.taskLoad -= task.taskCosts.get(taskID);
					task.callbacks.remove(taskID);
					task.taskCosts.remove(taskID);
				}
				cb(texture);
			});
		});
		
	}

	static function initTranscoder() {
		_transcoderLoading = if( _transcoderLoading == null ) {
			// Load transcoder wrapper.
			final jsLoader = new hxd.net.BinaryLoader('vendor/basis_transcoder.js');
			final jsContent = new js.lib.Promise((resolve, reject) -> {
				jsLoader.onLoaded = resolve;
				jsLoader.onError = reject;
				jsLoader.load();
			});
			// Load transcoder WASM binary.
			final binaryLoader = new hxd.net.BinaryLoader('vendor/basis_transcoder.wasm');
			final binaryContent = new js.lib.Promise((resolve, reject) -> {
				binaryLoader.onLoaded = resolve;
				binaryLoader.onError = reject;
				binaryLoader.load(true);
			});
			js.lib.Promise.all([jsContent, binaryContent]).then(arr -> {script:arr[0].toString(), wasm:arr[1]});
		} else {
			_transcoderLoading;
		}
		
		_transcoderPending = _transcoderLoading.then(o -> {
			_transcoderScript = o.script;
			_transcoderBinary = o.wasm;
			final transcoderFormat = Type.getClassFields(TranscoderFormat).map(f -> '"$f": ${Reflect.field(TranscoderFormat, f)},\n').fold((curr, acc) -> '$acc\t$curr', '{\n') + '}';
			final basisFormat = Type.allEnums(BasisFormat).fold((curr, acc) -> '$acc\t"${curr.getName()}": ${curr.getIndex()},\n', '{\n') + '}';
			final engineFormat = Type.getClassFields(EngineFormat).map(f -> '"$f": ${Reflect.field(EngineFormat, f)},\n').fold((curr, acc) -> '$acc\t$curr', '{\n') + '}';
			final engineType = Type.getClassFields(EngineType).map(f -> '"$f": ${Reflect.field(EngineType, f)},\n').fold((curr, acc) -> '$acc\t$curr', '{\n') + '}';
			final body = [
				'/* constants */',
				'let _EngineFormat = $engineFormat',
				'let _EngineType = $engineType',
				'let _TranscoderFormat = $transcoderFormat',
				'let _BasisFormat = $basisFormat',
				'/* basis_transcoder.js */',
				_transcoderScript,
				'/* worker */',
				basisWorker()
			].join('\n');

			_workerSourceURL = js.html.URL.createObjectURL(new js.html.Blob([body]));
		});
		return _transcoderPending;
	}
}

typedef Ktx2File = {
	header : KTX2Header,
	levels : Array<KTX2Level>,
	dfd : KTX2DFD,
	data : js.lib.Uint8Array,
	supercompressionGlobalData : KTX2SupercompressionGlobalData,
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

/** @internal */
@:structInit class KTX2Header {
	public final vkFormat : Int;
	public final typeSize : Int;
	public final pixelWidth : Int;
	public final pixelHeight : Int;
	public final pixelDepth : Int;
	public final layerCount : Int;
	public final faceCount : Int;
	public final levelCount : Int;
	public final supercompressionScheme : Int;
	public final dfdByteOffset : Int;
	public final dfdByteLength : Int;
	public final kvdByteOffset : Int;
	public final kvdByteLength : Int;
	public final sgdByteOffset : Int;
	public final sgdByteLength : Int;

	public function needZSTDDecoder() {
		return supercompressionScheme == SupercompressionScheme.ZStandard;
  }
}

/** @internal */
typedef KTX2Level = {
	/**
		Byte offset. According to spec this should be 64 bit, but since a lot of byte code in haxe is using regular 32 bit Int for indexing, 
		supporting files to large to fit in 32bit space is complicated and should not be needed for individual game assets. 
	**/
	final byteOffset : Int;
	final byteLength : Int;
	final uncompressedByteLength : Int;
}

typedef KTX2Sample = {
	final bitOffset : Int;
	final bitLength : Int;
	final channelType : Int;
	final channelFlags : Int;
	final samplePosition : Array<Int>;
	final sampleLower : Int;
	final sampleUpper : Int;
}

/** @internal */
@:structInit class KTX2DFD  {
	public final vendorId : Int;
	public final descriptorType : Int;
	public final versionNumber : Int;
	public final descriptorBlockSize : Int;
	public final colorModel : Int;
	public final colorPrimaries : Int;
	public final transferFunction : Int;
	public final flags : Int;
	public final texelBlockDimension : {
		 x : Int,
		 y : Int,
		 z : Int,
		 w : Int,
	};
	public final bytesPlane : Array<Int>;
	public final numSamples : Int;
	public final samples : Array<KTX2Sample>;

	public function hasAlpha() {
		return switch colorModel {
			case hxd.res.Ktx2.DFDModel.ETC1S: 
				numSamples == 2 && (samples[0].channelType == DFDChannel_ETC1S.AAA || samples[1].channelType == DFDChannel_ETC1S.AAA);
			case hxd.res.Ktx2.DFDModel.UASTC: 
				samples[0].channelType == DFDChannel_UASTC.RGBA;
			default: throw 'Unsupported colorModel in ktx2 file ${colorModel}';
		}
	}

	public function isInGammaSpace() {
		return transferFunction == DFDTransferFunction.SRGB;
	}
}

/** @internal */
typedef KTX2ImageDesc = {
	final imageFlags : Int;
	final rgbSliceByteOffset : Int;
	final rgbSliceByteLength : Int;
	final alphaSliceByteOffset : Int;
	final alphaSliceByteLength : Int;
}

/** @internal */
typedef KTX2SupercompressionGlobalData = {
	final endpointCount : Int;
	final selectorCount : Int;
	final endpointsByteLength : Int;
	final selectorsByteLength : Int;
	final tablesByteLength : Int;
	final extendedByteLength : Int;
	final imageDescs : Array<KTX2ImageDesc>;
	final endpointsData : haxe.io.UInt8Array;
	final selectorsData : haxe.io.UInt8Array;
	final tablesData : haxe.io.UInt8Array;
	final extendedData : haxe.io.UInt8Array;
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
	cTFETC2; // Not used
	cTFBC1;
	cTFBC3;
	cTFBC4; // Not used
	cTFBC5; // Not used
	cTFBC7_M6_OPAQUE_ONLY; // Not used
	cTFBC7_M5; // Not used
	cTFPVRTC1_4_RGB; // Not used
	cTFPVRTC1_4_RGBA; // Not used
	cTFASTC_4x4;
	cTFATC_RGB1; // Not used
	cTFATC_RGBA_INTERPOLATED_ALPHA2; // Not used
	cTFRGBA321;
	cTFRGB5654; // Not used
	cTFBGR5655; // Not used
	cTFRGBA44446; // Not used
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
	public static final RGB_ETC1_Format =  CompressedTextureFormat.ETC_FORMAT.RGB_ETC1;
	public static final RGBA_ETC2_EAC_Format = CompressedTextureFormat.ETC_FORMAT.RGBA_ETC2;
	public static final RGB_ETC2_Format = 0x9274;
}

@:keep
class EngineType {
	public static final UnsignedByteType = 1009;
	public static final FloatType = 1015;
	public static final HalfFloatType = 1016;
}

/**
 * Defines a mipmap level
 */
@:structInit class MipmapLevel {
	/**
	 * The data of the mipmap level
	 */
	public var data : Null<UInt8Array> = null;

	/**
	 * The width of the mipmap level
	 */
	public final width : Int;

	/**
	 * The height of the mipmap level
	 */
	public final height : Int;
}

enum KtxTranscodeTarget {
	ETC1S(options : ETC1SDecoderOptions, caps : Ktx2Caps);
	UASTC(options : UASTCDecoderOptions, caps : Ktx2Caps);
}

@:structInit class KtxTranscodeConfig {
	public final transcodeFormat :TranscodeTarget;
	public final engineFormat :Int;
	public final engineType = EngineType.UnsignedByteType;
	public final roundToMultiple4 = true;
}


@:structInit class Ktx2Caps {
	public final fmt : CompressedFormat;

	public final alpha : Null<Bool> = null;

	public final needsPowerOfTwo = true;
}

enum CompressedFormat {
	ETC2;
	ETC1;
	S3TC;
	ASTC;
	BPTC;
}

/**
* Options passed to the KTX2 decode function
*/
@:structInit class UASTCDecoderOptions {
	/** use RGBA format if ASTC and BC7 are not available as transcoded format */
	public final useRGBAIfASTCBC7NotAvailableWhenUASTC = false;

	/** force to always use (uncompressed) RGBA for transcoded format */
	public final forceRGBA = false;

	/** force to always use (uncompressed) R8 for transcoded format */
	public final forceR8 = false;

	/** force to always use (uncompressed) RG8 for transcoded format */
	public final forceRG8 = false;
}

@:structInit class ETC1SDecoderOptions {	
	public final forceRGBA = false;
}

enum TranscodeTarget {
	ASTC_4X4_RGBA;
	BC7_RGBA;
	BC3_RGBA;
	BC1_RGB;
	ETC2_RGBA;
	ETC1_RGB;
	RGBA32;
	R8;
	RG8;
}

typedef WorkerTask = {
	worker : js.html.Worker,
	callbacks : haxe.ds.IntMap<{ resolve : (value : Dynamic) -> Void, reject : (reason : Dynamic) -> Void }>,
	taskCosts : haxe.ds.IntMap<Int>,
	taskLoad : Int,
}

typedef BasisWorkerConfig = {
	astcSupported : Bool,
	etc1Supported : Bool,
	etc2Supported : Bool,
	dxtSupported : Bool,
}

function basisWorker() {
	return "
	let config;
	let transcoderPending;
	let BasisModule;

	const EngineFormat = _EngineFormat;
	const EngineType = _EngineType;
	const TranscoderFormat = _TranscoderFormat;
	const BasisFormat = _BasisFormat;

	self.addEventListener( 'message', function ( e ) {
		const message = e.data;
		switch ( message.type ) {
			case 'init':
				config = message.config;
				init( message.transcoderBinary );
				break;
			case 'transcode':
				transcoderPending.then( () => {
					try {
						const { faces, buffers, width, height, hasAlpha, format, type, dfdFlags } = transcode( message.buffer );
						self.postMessage( { type: 'transcode', id: message.id, data: { faces, width, height, hasAlpha, format, type, dfdFlags } }, buffers );
					} catch ( error ) {
						console.error( error );
						self.postMessage( { type: 'error', id: message.id, error: error.message } );
					}
				} );
				break;
		}
	} );

	function init( wasmBinary ) {
		transcoderPending = new Promise( ( resolve ) => {
			BasisModule = { wasmBinary, onRuntimeInitialized: resolve };
			BASIS( BasisModule ); // eslint-disable-line no-undef
		} ).then( () => {
			BasisModule.initializeBasis();
			if ( BasisModule.KTX2File === undefined ) {
				console.warn( 'KTX2Loader: Please update Basis Universal transcoder.' );
			}
		} );
	}

	function transcode( buffer ) {
		const ktx2File = new BasisModule.KTX2File( new Uint8Array( buffer ) );
		function cleanup() {
			ktx2File.close();
			ktx2File.delete();
		}

		if ( ! ktx2File.isValid() ) {
			cleanup();
			throw new Error( 'KTX2Loader:	Invalid or unsupported .ktx2 file' );
		}
		let basisFormat;
		if ( ktx2File.isUASTC() ) {
			basisFormat = BasisFormat.UASTC;
		} else if ( ktx2File.isETC1S() ) {
			basisFormat = BasisFormat.ETC1S;
		} else if ( ktx2File.isHDR() ) {
			basisFormat = BasisFormat.UASTC_HDR;
		} else {
			throw new Error( 'KTX2Loader: Unknown Basis encoding' );
		}
		const width = ktx2File.getWidth();
		const height = ktx2File.getHeight();
		const layerCount = ktx2File.getLayers() || 1;
		const levelCount = ktx2File.getLevels();
		const faceCount = ktx2File.getFaces();
		const hasAlpha = ktx2File.getHasAlpha();
		const dfdFlags = ktx2File.getDFDFlags();
		const { transcoderFormat, engineFormat, engineType } = getTranscoderFormat( basisFormat, width, height, hasAlpha );
		if ( ! width || ! height || ! levelCount ) {
			cleanup();
			throw new Error( `KTX2Loader:	Invalid texture ktx2File:${JSON.stringify(ktx2File)} w:${width} h: ${height} levelCount:${levelCount}` );
		}

		if ( ! ktx2File.startTranscoding() ) {
			cleanup();
			throw new Error( 'KTX2Loader: .startTranscoding failed' );
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
						console.warn( 'KTX2Loader: ETC1S and UASTC textures should use multiple-of-four dimensions.' );
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

					if ( engineType === EngineType.HalfFloatType ) {
						dst = new Uint16Array( dst.buffer, dst.byteOffset, dst.byteLength / Uint16Array.BYTES_PER_ELEMENT );
					}

					if ( ! status ) {
						cleanup();
						throw new Error( 'KTX2Loader: .transcodeImage failed.' );
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
	//

	// Optimal choice of a transcoder target format depends on the Basis format (ETC1S, UASTC, or
	// UASTC HDR), device capabilities, and texture dimensions. The list below ranks the formats
	// separately for each format. Currently, priority is assigned based on:
	//
	//   high quality > low quality > uncompressed
	//
	// Prioritization may be revisited, or exposed for configuration, in the future.
	//
	// Reference: https://github.com/KhronosGroup/3D-Formats-Guidelines/blob/main/KTXDeveloperGuide.md
	const FORMAT_OPTIONS = [
		{
			if: 'astcSupported',
			basisFormat: [ BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.ASTC_4x4, TranscoderFormat.ASTC_4x4 ],
			engineFormat: [ EngineFormat.RGBA_ASTC_4x4_Format, EngineFormat.RGBA_ASTC_4x4_Format ],
			engineType: [ EngineType.UnsignedByteType ],
			priorityETC1S: Infinity,
			priorityUASTC: 1,
			needsPowerOfTwo: false,
		},
		{
			if: 'bptcSupported',
			basisFormat: [ BasisFormat.ETC1S, BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.BC7_M5, TranscoderFormat.BC7_M5 ],
			engineFormat: [ EngineFormat.RGBA_BPTC_Format, EngineFormat.RGBA_BPTC_Format ],
			engineType: [ EngineType.UnsignedByteType ],
			priorityETC1S: 3,
			priorityUASTC: 2,
			needsPowerOfTwo: false,
		},
		{
			if: 'dxtSupported',
			basisFormat: [ BasisFormat.ETC1S, BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.BC1, TranscoderFormat.BC3 ],
			engineFormat: [ EngineFormat.RGBA_S3TC_DXT1_Format, EngineFormat.RGBA_S3TC_DXT5_Format ],
			engineType: [ EngineType.UnsignedByteType ],
			priorityETC1S: 4,
			priorityUASTC: 5,
			needsPowerOfTwo: false,
		},
		{
			if: 'etc2Supported',
			basisFormat: [ BasisFormat.ETC1S, BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.ETC1, TranscoderFormat.ETC2 ],
			engineFormat: [ EngineFormat.RGB_ETC2_Format, EngineFormat.RGBA_ETC2_EAC_Format ],
			engineType: [ EngineType.UnsignedByteType ],
			priorityETC1S: 1,
			priorityUASTC: 3,
			needsPowerOfTwo: false,
		},
		{
			if: 'etc1Supported',
			basisFormat: [ BasisFormat.ETC1S, BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.ETC1 ],
			engineFormat: [ EngineFormat.RGB_ETC1_Format ],
			engineType: [ EngineType.UnsignedByteType ],
			priorityETC1S: 2,
			priorityUASTC: 4,
			needsPowerOfTwo: false,
		},

		// Uncompressed fallbacks.

		{
			basisFormat: [ BasisFormat.ETC1S, BasisFormat.UASTC ],
			transcoderFormat: [ TranscoderFormat.RGBA32, TranscoderFormat.RGBA32 ],
			engineFormat: [ EngineFormat.RGBAFormat, EngineFormat.RGBAFormat ],
			engineType: [ EngineType.UnsignedByteType, EngineType.UnsignedByteType ],
			priorityETC1S: 100,
			priorityUASTC: 100,
			needsPowerOfTwo: false,
		},
		{
			basisFormat: [ BasisFormat.UASTC_HDR ],
			transcoderFormat: [ TranscoderFormat.RGBA_HALF ],
			engineFormat: [ EngineFormat.RGBAFormat ],
			engineType: [ EngineType.HalfFloatType ],
			priorityHDR: 100,
			needsPowerOfTwo: false,
		}
	];

	const OPTIONS = {
		// TODO: For ETC1S we intentionally sort by _UASTC_ priority, preserving
		// a historical accident shown to avoid performance pitfalls for Linux with
		// Firefox & AMD GPU (RadeonSI). Further work needed.
		// See https://github.com/mrdoob/three.js/pull/29730.
		[ BasisFormat.ETC1S ]: FORMAT_OPTIONS
			.filter( ( opt ) => opt.basisFormat.includes( BasisFormat.ETC1S ) )
			.sort( ( a, b ) => a.priorityUASTC - b.priorityUASTC ),

		[ BasisFormat.UASTC ]: FORMAT_OPTIONS
			.filter( ( opt ) => opt.basisFormat.includes( BasisFormat.UASTC ) )
			.sort( ( a, b ) => a.priorityUASTC - b.priorityUASTC ),

		[ BasisFormat.UASTC_HDR ]: FORMAT_OPTIONS
			.filter( ( opt ) => opt.basisFormat.includes( BasisFormat.UASTC_HDR ) )
			.sort( ( a, b ) => a.priorityHDR - b.priorityHDR ),
	};

	function getTranscoderFormat( basisFormat, width, height, hasAlpha ) {
		const options = OPTIONS[ basisFormat ];
		for ( let i = 0; i < options.length; i++ ) {
			const opt = options[ i ];
			if ( opt.if && ! config[ opt.if ] ) continue;
			if ( ! opt.basisFormat.includes( basisFormat ) ) continue;
			if ( hasAlpha && opt.transcoderFormat.length < 2 ) continue;
			if ( opt.needsPowerOfTwo && ! ( isPowerOfTwo( width ) && isPowerOfTwo( height ) ) ) continue;
			const transcoderFormat = opt.transcoderFormat[ hasAlpha ? 1 : 0 ];
			const engineFormat = opt.engineFormat[ hasAlpha ? 1 : 0 ];
			const engineType = opt.engineType[ 0 ];
			console.log(`opt: ${JSON.stringify(opt)}`);

			return { transcoderFormat, engineFormat, engineType };
		}
		throw new Error( 'KTX2Loader: Failed to identify transcoding target.' );
	}

	function isPowerOfTwo( value ) {
		if ( value <= 2 ) return true;
		return ( value & ( value - 1 ) ) === 0 && value !== 0;
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
	}";
}

@:structInit class BasisWorkerMessage {
	public final id : String;
	public final type = 'transcode';
	public final data : {
		faces : Array<{ mipmaps : Array<js.html.ImageData>, width : Int, height : Int, format : Int, type : Int }>,
		width : Int,
		height : Int,
		hasAlpha : Bool,
		format : Int,
		type : Int,
		dfdFlags : Int,
	};
	public final error : String = null;
}
#end