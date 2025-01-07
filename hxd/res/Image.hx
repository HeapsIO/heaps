package hxd.res;

enum abstract ImageFormat(Int) {
	var Jpg = 0;
	var Png = 1;
	var Gif = 2;
	var Tga = 3;
	var Dds = 4;
	var Raw = 5;
	var Hdr = 6;
	var Ktx2 = 7;

	/*
		Tells if we might not be able to directly decode the image without going through a loadBitmap async call.
		This for example occurs when we want to decode progressive JPG in JS.
	 */
	public var useLoadBitmap(get, never):Bool;

	inline function get_useLoadBitmap() {
		#if hl
		return false;
		#else
		return this == Jpg.toInt();
		#end
	}

	inline function toInt()
		return this;

	public function getName() {
		return switch ((cast this : ImageFormat)) {
			case Jpg: "JPG";
			case Png: "PNG";
			case Gif: "GIF";
			case Tga: "TGA";
			case Dds: "DDS";
			case Raw: "RAW";
			case Hdr: "HDR";
			case Ktx2: "KTX2";
		};
	}
}

enum ImageInfoFlag {
	IsCube;
	Dxt10Header;
}

@:allow(hxd.res.Image)
class ImageInfo {
	public var width(default, null):Int = 0;
	public var height(default, null):Int = 0;
	public var mipLevels(default, null):Int = 1;
	public var mipOffset(default, null):Int = 0;
	public var layerCount(default, null):Int = 1;
	public var flags(default, null):haxe.EnumFlags<ImageInfoFlag>;
	public var dataFormat(default, null):ImageFormat;
	public var pixelFormat(default, null):PixelFormat;

	public function new() {
		flags = new haxe.EnumFlags();
	}
}

class Image extends Resource {
	/**
		Specify if we will automatically convert non-power-of-two textures to power-of-two.
	**/
	public static var DEFAULT_FILTER:h3d.mat.Data.Filter = Linear;

	/**
		Reduce textures quality with mipmaps by only loading up to the desired size.
	**/
	public static var MIPMAP_MAX_SIZE = 0;

	static var ENABLE_AUTO_WATCH = true;

	var tex:h3d.mat.Texture;
	var inf:ImageInfo;

	public var enableAsyncLoading:Bool;

	public inline function getFormat() {
		return getInfo().dataFormat;
	}

	public inline function getPixelFormat() {
		return getInfo().pixelFormat;
	}

	public inline function getSize() {
		return getInfo();
	}

	public function getInfo() {
		if (inf != null)
			return inf;
		inf = new ImageInfo();
		var f = entry.open();
		f.fetch(256); // should be enough to fit DDS header
		var head = try f.readUInt16() catch (e:haxe.io.Eof) 0;
		switch (head) {
			case 0xD8FF: // JPG
				inf.dataFormat = Jpg;
				inf.pixelFormat = BGRA;
				f.bigEndian = true;
				while (true) {
					switch (f.readUInt16()) {
						case 0xFFC2, 0xFFC1, 0xFFC0:
							var len = f.readUInt16();
							var prec = f.readByte();
							inf.height = f.readUInt16();
							inf.width = f.readUInt16();
							break;
						default:
							f.skip(f.readUInt16() - 2);
					}
				}
			case 0x5089: // PNG
				inf.dataFormat = Png;
				f.bigEndian = true;
				f.skip(6); // header
				while (true) {
					var dataLen = f.readInt32();
					if (f.readInt32() == ('I'.code << 24) | ('H'.code << 16) | ('D'.code << 8) | 'R'.code) {
						inf.width = f.readInt32();
						inf.height = f.readInt32();
						var colbits = f.readByte();
						var colType = f.readByte();
						inf.pixelFormat = switch ([colbits, colType]) {
							case [8, _]: BGRA; // TODO : grayscale png image
							case [16, 0]: R16U;
							case [16, 2]: RGBA16U; // RGB16U is not supported on DirectX !
							case [16, 4]: RG16U; // gray + alpha
							case [16, 6]: RGBA16U;
							default: throw "Unsupported png format " + colbits + "/" + colType + "(" + entry.path + ")";
						}
						break;
					}
					f.skip(dataLen + 4); // CRC
				}
			case 0x4947: // GIF
				inf.dataFormat = Gif;
				inf.pixelFormat = BGRA;
				f.readInt32(); // skip
				inf.width = f.readUInt16();
				inf.height = f.readUInt16();

			case 0x4444: // DDS
				inf.dataFormat = Dds;
				f.skip(10);
				inf.height = f.readInt32();
				inf.width = f.readInt32();
				f.skip(2 * 4);
				inf.mipLevels = f.readInt32();
				f.skip(12 * 4);
				var caps = f.readInt32();
				var fourCC = f.readInt32();
				var bpp = f.readInt32();
				var rMask = f.readInt32();
				var gMask = f.readInt32();
				var bMask = f.readInt32();
				var aMask = f.readInt32();
				var caps2 = f.readInt32();
				var cubes = f.readInt32();
				if (cubes & 0xFE00 == 0xFE00) // all 6 surfaces required
					inf.flags.set(IsCube);
				switch (fourCC & 0xFFFFFF) {
					case 0x545844: /* DXT */
						var dxt = (fourCC >>> 24) - "0".code;
						inf.pixelFormat = switch (dxt) {
							case 1: S3TC(1);
							case 2, 3: S3TC(2);
							case 4, 5: S3TC(3);
							default: null;
						}
					case 0x495441: /* ATI */
						var v = (fourCC >>> 24) - "0".code;
						inf.pixelFormat = switch (v) {
							case 1: S3TC(4);
							case 2: S3TC(5);
							default: null;
						}
					case _ if (fourCC == 0x30315844 /* DX10 */):
						f.skip(3 * 4);
						inf.flags.set(Dxt10Header);
						var dxgi = f.readInt32(); // DXGI_FORMAT_xxxx value
						inf.pixelFormat = switch (dxgi) {
							case 28:
								RGBA;
							case 71: // BC1_UNORM
								S3TC(1);
							case 74: // BC2_UNORM
								S3TC(2);
							case 77: // BC3_UNORM
								S3TC(3);
							case 95: // BC6H_UF16
								S3TC(6);
							case 98: // BC7_UNORM
								S3TC(7);
							default:
								throw entry.path + " has unsupported DXGI format " + dxgi;
						}
						var imgType = f.readInt32();
						f.skip(4);
						inf.layerCount = f.readInt32();
					case 111: // D3DFMT_R16F
						inf.pixelFormat = R16F;
					case 112: // D3DFMT_G16R16F
						inf.pixelFormat = RG16F;
					case 113: // D3DFMT_A16B16G16R16F
						inf.pixelFormat = RGBA16F;
					case 114: // D3DFMT_R13F
						inf.pixelFormat = R32F;
					case 115: // D3DFMT_G32R32F
						inf.pixelFormat = RG32F;
					case 116: // D3DFMT_A32B32G32R32F
						inf.pixelFormat = RGBA32F;
					case 0:
						// RGB
						switch ([bpp, rMask, gMask, bMask, aMask]) {
							case [32, 0xFF0000, 0xFF00, 0xFF, 0xFF000000]:
								inf.pixelFormat = BGRA;
							case [32, 0xFF, 0xFF00, 0xFF0000, 0xFF000000]:
								inf.pixelFormat = RGBA;
							case [16, 0xFFFF, 0, 0, 0]:
								inf.pixelFormat = R16U;
							case [32, 0xFFFF, 0xFFFF0000, 0, 0]:
								inf.pixelFormat = RG16U;
							default:
								throw "Unsupported RGB DDS " + bpp + "bits " + StringTools.hex(rMask) + "/" + StringTools.hex(gMask) + "/"
									+ StringTools.hex(bMask) + "/" + StringTools.hex(aMask);
						}
					case 36:
						inf.pixelFormat = RGBA16U;
					default:
				}

				if (inf.pixelFormat == null) {
					var fid = String.fromCharCode(fourCC & 0xFF) + String.fromCharCode((fourCC >> 8) & 0xFF) + String.fromCharCode((fourCC >> 16) & 0xFF)
						+ String.fromCharCode(fourCC >>> 24);
					if (fourCC & 0xFF == fourCC)
						fid = "" + fourCC;
					throw entry.path + " has unsupported 4CC " + fid;
				}
			#if js
			case 0x4273:
				throw 'Use .ktx2 files for GPU compressed textures instead of .basis';
			case 0x4BAB:
				final ktx2 = hxd.res.Ktx2.readFile(new haxe.io.BytesInput(@:privateAccess f.cache));
				inf.pixelFormat = switch ktx2.dfd.colorModel {
					case hxd.res.Ktx2.DFDModel.ETC1S: ETC(hxd.res.Ktx2.TranscoderFormat.ETC1);
					case hxd.res.Ktx2.DFDModel.UASTC: ASTC(hxd.res.Ktx2.TranscoderFormat.ASTC_4x4);
					default: throw 'Unsupported colorModel in ktx2 file ${ktx2.dfd.colorModel}';
				}
				inf.mipLevels = ktx2.header.levelCount;
				inf.width = ktx2.header.pixelWidth;
				inf.height = ktx2.header.pixelHeight;
				inf.dataFormat = Ktx2;
			#end
			case 0x3F23: // HDR RADIANCE

				inf.dataFormat = Hdr;
				while (f.readLine() != "") {}
				var parts = f.readLine().split(" ");
				inf.pixelFormat = RGBA32F;
				inf.height = Std.parseInt(parts[1]);
				inf.width = Std.parseInt(parts[3]);

			case _ if (entry.extension == "tga"):
				inf.dataFormat = Tga;
				inf.pixelFormat = ARGB;
				f.skip(10);
				inf.width = f.readUInt16();
				inf.height = f.readUInt16();

			case _ if (entry.extension == "raw"):
				inf.dataFormat = Raw;
				inf.pixelFormat = R32F;
				var size = Std.int(Math.sqrt(entry.size >> 2));
				if (entry.size != size * size * 4) {
					var size2 = Std.int(Math.sqrt(entry.size >> 1));
					if (entry.size == size2 * size2 * 2) {
						inf.pixelFormat = R16F;
						size = size2;
					} else
						throw "RAW format does not match 32 bit per components on " + size + "x" + size;
				}
				inf.width = inf.height = size;

			default:
				throw "Unsupported texture format " + entry.path;
		}

		f.close();
		if (inf.pixelFormat == null)
			throw "Unsupported internal format (" + entry.path + ")";

		if (MIPMAP_MAX_SIZE != 0 && inf.mipLevels > 1) {
			// Check next miplevel dimensions are divisible by 4.
			while ((inf.width | inf.height) & 7 == 0 && inf.width >> 1 >= MIPMAP_MAX_SIZE && inf.height >> 1 >= MIPMAP_MAX_SIZE) {
				inf.width >>= 1;
				inf.height >>= 1;
				inf.mipLevels--;
				inf.mipOffset++;
			}
		}

		customCheckInfo(this);

		return inf;
	}

	public static dynamic function customCheckInfo(i:Image) {}

	public function getPixels(?fmt:PixelFormat, ?index:Int) {
		var pixels:hxd.Pixels;
		if (index == null)
			index = 0;
		switch (getInfo().dataFormat) {
			case Png:
				var bytes = entry.getBytes(); // using getTmpBytes cause bug in E2
				#if hl
				if (fmt == null)
					fmt = inf.pixelFormat;
				pixels = decodePNG(bytes, inf.width, inf.height, fmt);
				if (pixels == null)
					throw "Failed to decode PNG " + entry.path;
				#else
				var png = new format.png.Reader(new haxe.io.BytesInput(bytes));
				png.checkCRC = false;
				pixels = Pixels.alloc(inf.width, inf.height, inf.pixelFormat);
				var pdata = png.read();
				switch (inf.pixelFormat) {
					case BGRA:
						format.png.Tools.extract32(pdata, pixels.bytes, false);
					case R16U, RG16U, RGB16U, RGBA16U:
						format.png.Tools.extract(pdata, pixels.bytes, inf.pixelFormat == RGBA16U && format.png.Tools.getHeader(pdata)
							.color.match(ColTrue(false)));
					default:
						throw "No support to decode " + inf.pixelFormat + " on this platform (" + entry.path + ")";
				}
				#end
			case Gif:
				var bytes = entry.getBytes();
				var gif = new format.gif.Reader(new haxe.io.BytesInput(bytes)).read();
				if (fmt == RGBA)
					pixels = new Pixels(inf.width, inf.height, format.gif.Tools.extractFullRGBA(gif, 0), RGBA);
				else
					pixels = new Pixels(inf.width, inf.height, format.gif.Tools.extractFullBGRA(gif, 0), BGRA);
			case Jpg:
				var bytes = entry.getBytes();
				#if hl
				if (fmt == null)
					fmt = inf.pixelFormat;
				pixels = decodeJPG(bytes, inf.width, inf.height, fmt);
				if (pixels == null)
					throw "Failed to decode JPG " + entry.path;
				#else
				if (inf.pixelFormat != BGRA)
					throw "No support to decode " + inf.pixelFormat + " on this platform (" + entry.path + ")";
				var p = try NanoJpeg.decode(bytes) catch (e:Dynamic) throw "Failed to decode JPG " + entry.path + " (" + e + ")";
				pixels = new Pixels(p.width, p.height, p.pixels, BGRA);
				#end
			case Tga:
				var bytes = entry.getBytes();
				var r = new format.tga.Reader(new haxe.io.BytesInput(bytes)).read();
				if (r.header.imageType != UncompressedTrueColor || r.header.bitsPerPixel != 32)
					throw "Not supported TGA " + r.header.imageType + "/" + r.header.bitsPerPixel;
				var w = r.header.width;
				var h = r.header.height;
				if (fmt == RGBA) {
					pixels = hxd.Pixels.alloc(w, h, RGBA);
					var bytes = pixels.bytes;
					#if hl
					var bytes:hl.Bytes = bytes;
					inline function set(i, c)
						bytes.setI32(i << 2, c);
					#else
					inline function set(i, c)
						bytes.setInt32(i << 2, c);
					#end
					for (i in 0...w * h) {
						var c = r.imageData[i];
						c = (c >>> 24) | (c << 8);
						set(i, c);
					}
				} else {
					pixels = hxd.Pixels.alloc(w, h, ARGB);
					var access:hxd.Pixels.PixelsARGB = pixels;
					var p = 0;
					for (y in 0...h) {
						for (x in 0...w) {
							var c = r.imageData[p++];
							access.setPixel(x, y, c);
						}
					}
				}
				switch (r.header.imageOrigin) {
					case BottomLeft: pixels.flipY();
					case TopLeft: // nothing
					default: throw "Not supported " + r.header.imageOrigin;
				}
			case Dds:
				var pos = 128;
				var mipLevel = 0;
				if (inf.flags.has(Dxt10Header))
					pos += 20;
				index += inf.mipOffset;
				if (index > 0) {
					var totLevels = inf.mipLevels + inf.mipOffset;
					var bpp = hxd.Pixels.calcStride(1, inf.pixelFormat);
					var layer = Std.int(index / totLevels);
					mipLevel = index % totLevels;
					var totSize = 0;
					for (i in 0...totLevels) {
						var w = (inf.width << inf.mipOffset) >> i;
						var h = (inf.height << inf.mipOffset) >> i;
						if (w == 0)
							w = 1;
						if (h == 0)
							h = 1;
						var size = hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
						totSize += size;
						if (i < mipLevel)
							pos += size
						else if (layer == 0)
							break;
					}
					pos += totSize * layer;
				}
				var bytes;
				var w = inf.width >> (mipLevel - inf.mipOffset);
				var h = inf.height >> (mipLevel - inf.mipOffset);
				if (w == 0)
					w = 1;
				if (h == 0)
					h = 1;
				if (inf.mipLevels + inf.mipOffset == 1 && !inf.flags.has(IsCube)) {
					bytes = entry.getBytes();
				} else {
					var size = hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
					bytes = haxe.io.Bytes.alloc(size);
					entry.readFull(bytes, pos, size);
					pos = 0;
				}
				pixels = new hxd.Pixels(w, h, bytes, inf.pixelFormat, pos);
			case Raw:
				var bytes = entry.getBytes();
				pixels = new hxd.Pixels(inf.width, inf.height, bytes, inf.pixelFormat);
			case Hdr:
				var data = hxd.fmt.hdr.Reader.decode(entry.getBytes(), false);
				pixels = new hxd.Pixels(data.width, data.height, data.bytes, inf.pixelFormat);
			case Ktx2:
				var bytes = entry.getBytes();
				pixels = new hxd.Pixels(inf.width, inf.height, bytes, inf.pixelFormat);
		}
		if (fmt != null)
			pixels.convert(fmt);
		return pixels;
	}

	#if hl
	static function decodeJPG(src:haxe.io.Bytes, width:Int, height:Int, requestedFmt:hxd.PixelFormat) {
		var outFmt = requestedFmt;
		var ifmt:format.hl.Native.PixelFormat = switch (requestedFmt) {
			case RGBA: RGBA;
			case BGRA: BGRA;
			case ARGB: ARGB;
			default:
				outFmt = BGRA;
				BGRA;
		};
		var dst = haxe.io.Bytes.alloc(width * height * 4);
		if (!format.hl.Native.decodeJPG(src.getData(), src.length, dst.getData(), width, height, width * 4, ifmt, 0))
			return null;
		var pix = new hxd.Pixels(width, height, dst, outFmt);
		return pix;
	}

	static function decodePNG(src:haxe.io.Bytes, width:Int, height:Int, requestedFmt:hxd.PixelFormat) {
		var outFmt = requestedFmt;
		var ifmt:format.hl.Native.PixelFormat = switch (requestedFmt) {
			case RGBA: RGBA;
			case BGRA: BGRA;
			case ARGB: ARGB;
			case R16U: cast 12;
			case RGB16U: cast 13;
			case RGBA16U: cast 14;
			case RG16U: cast 15;
			default:
				outFmt = BGRA;
				BGRA;
		};
		var stride = 4; // row_stride is the step, in png_byte or png_uint_16 units	as appropriate, between adjacent rows
		var pxsize = 4;
		switch (outFmt) {
			case R16U:
				stride = 1;
				pxsize = 2;
			case RG16U:
				stride = 2;
				pxsize = 4;
			case RGB16U:
				stride = 3;
				pxsize = 6;
			case RGBA16U:
				stride = 4;
				pxsize = 8;
			default:
		}
		var dst = haxe.io.Bytes.alloc(width * height * pxsize);
		if (!format.hl.Native.decodePNG(src.getData(), src.length, dst.getData(), width, height, width * stride, ifmt, 0))
			return null;
		var pix = new hxd.Pixels(width, height, dst, outFmt);
		return pix;
	}
	#end

	public function toBitmap():hxd.BitmapData {
		getInfo();
		var bmp = new hxd.BitmapData(inf.width, inf.height);
		var pixels = getPixels();
		bmp.setPixels(pixels);
		pixels.dispose();
		return bmp;
	}

	function watchCallb() {
		var prevInfo = inf;
		inf = null;
		try {
			getInfo();
		} catch ( e : Dynamic ) {
			inf = prevInfo;
			return;
		}
		var s = getSize();
		if (prevInfo.width != s.width || prevInfo.height != s.height)
			tex.resize(s.width, s.height);
		tex.realloc = null;
		loadTexture();
	}

	static var BLACK_1x1 = Pixels.alloc(1, 1, RGBA);
	public static var ASYNC_LOADER:hxd.impl.AsyncLoader;
	public static var LOG_TEXTURE_LOAD = #if heaps_texture_load true #else false #end;

	function asyncLoad(data:haxe.io.Bytes) {
		if (tex == null || tex.isDisposed())
			return;
		tex.dispose();
		tex.flags.unset(Loading);
		@:privateAccess {
			tex.format = inf.pixelFormat;
			tex.width = inf.width;
			tex.height = inf.height;
		}
		loadTexture(data);
	}

	function loadTexture(?asyncData:haxe.io.Bytes) {
		if (getFormat().useLoadBitmap) {
			// use native decoding
			tex.flags.set(Loading);
			entry.loadBitmap(function(bmp) {
				var bmp = bmp.toBitmap();
				tex.alloc();
					tex.uploadBitmap(bmp);
					bmp.dispose();
				tex.realloc = () -> loadTexture();
				tex.flags.unset(Loading);
				@:privateAccess if (tex.waitLoads != null) {
					var arr = tex.waitLoads;
					tex.waitLoads = null;
					for (f in arr)
						f();
				}

				if (ENABLE_AUTO_WATCH)
					watch(watchCallb);
			});
			return;
		}

		function load() {
			if ((enableAsyncLoading || tex.flags.has(AsyncLoading)) && asyncData == null && ASYNC_LOADER != null && ASYNC_LOADER.isSupported(this))
				@:privateAccess {
					tex.dispose();
					tex.format = RGBA;
					tex.width = 1;
					tex.height = 1;
					tex.customMipLevels = 1;
					tex.flags.set(Loading);
					tex.alloc();
					tex.uploadPixels(BLACK_1x1);
					tex.width = inf.width;
					tex.height = inf.height;
					ASYNC_LOADER.load(this);
				tex.realloc = () -> loadTexture();
					return;
			}
			var t0 = haxe.Timer.stamp();
			// immediately loading the PNG is faster than going through loadBitmap
			@:privateAccess tex.customMipLevels = inf.mipLevels;
			tex.alloc();
			switch (inf.dataFormat) {
				case Dds:
					var pos = 128;
					if (inf.flags.has(Dxt10Header))
						pos += 20;
					for (layer in 0...tex.layerCount) {
						for (mip in 0...inf.mipOffset) {
							var w = (inf.width << inf.mipOffset) >> mip;
							var h = (inf.height << inf.mipOffset) >> mip;
							var size = hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
							pos += size;
						}
						for (mip in 0...inf.mipLevels) {
							var w = inf.width >> mip;
							var h = inf.height >> mip;
							if (w == 0)
								w = 1;
							if (h == 0)
								h = 1;
							var size = hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
							var bytes = asyncData == null ? entry.fetchBytes(pos, size) : asyncData;
							tex.uploadPixels(new hxd.Pixels(w, h, bytes, inf.pixelFormat, asyncData == null ? 0 : pos), mip, layer);
							pos += size;
						}
					}
				case Ktx2:
					throw 'Ktx2 loading using heaps resource system not implemented';
					#if js
					// TODO: Need to handle async loading of compressed textures
					var bytes = asyncData == null ? entry.getBytes() : asyncData;
					hxd.res.Ktx2.Ktx2Decoder.getTexture(new haxe.io.BytesInput(bytes), texture ->  {
						tex = texture;
					});
					#end
				default:
					for (layer in 0...tex.layerCount) {
						for (mip in 0...inf.mipLevels) {
							var pixels = getPixels(tex.format, layer * inf.mipLevels + mip);
							tex.uploadPixels(pixels, mip, layer);
							pixels.dispose();
						}
					}
			}
			if (LOG_TEXTURE_LOAD && asyncData == null) {
				var time = (haxe.Timer.stamp() - t0) * 1000.0;
				var fmtStr = inf.pixelFormat.match(S3TC(_)) ? "DXT" : inf.dataFormat.getName();
				#if hl Sys.println #else trace #end (fmtStr + " " + Std.int(time) + "." + (Std.int(time * 10) % 10) + "ms " + inf.width + "x" + inf.height
					+ " " + entry.path);
			}
			tex.realloc = () -> loadTexture();
			if (ENABLE_AUTO_WATCH)
				watch(watchCallb);
		}
		if (entry.isAvailable)
			load();
		else
			entry.load(load);
	}

	public function toTexture():h3d.mat.Texture {
		if (tex != null)
			return tex;
		getInfo();
		var flags:Array<h3d.mat.Data.TextureFlags> = [NoAlloc];
		var fmt = inf.pixelFormat;
		// for these formats, we will ignore the pixel format and always use native one
		// our decoders most likely allows to decode in correct format anyway
		if (fmt == BGRA || fmt == ARGB || fmt == RGBA)
			fmt = h3d.mat.Texture.nativeFormat;
		if (inf.flags.has(IsCube))
			flags.push(Cube);
		if (inf.mipLevels > 1) {
			flags.push(MipMapped);
			flags.push(ManualMipMapGen);
		}
		if (inf.layerCount > 1)
			tex = new h3d.mat.TextureArray(inf.width, inf.height, inf.layerCount, flags, fmt);
		else
			tex = new h3d.mat.Texture(inf.width, inf.height, flags, fmt);
		if (DEFAULT_FILTER != Linear)
			tex.filter = DEFAULT_FILTER;
		tex.setName(entry.path);
		setupTextureFlags(tex);
		// DirectX12 texture array triggers an access violation.
		if (tex.flags.has(IsArray) || !tex.flags.has(LazyLoading))
			loadTexture();
		else
			tex.realloc = () -> loadTexture();
		return tex;
	}

	public function toTile():h2d.Tile {
		final tex = toTexture();
		return h2d.Tile.fromTexture(tex).sub(0, 0, tex.width, tex.height);
	}

	public static dynamic function setupTextureFlags(tex:h3d.mat.Texture) {}
}
