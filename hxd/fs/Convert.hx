package hxd.fs;

@:keep @:keepSub
class Convert {
	public var sourceExts(default, null):Array<String>;
	public var destExt(default, null):String;

	/**
		Major version of the Convert.
		When incremented, all files processed by this Convert would be rebuilt. **/
	public var version(default, null):Int;

	public var params:Dynamic;
	public var localParams:Dynamic;

	public var srcPath:String;
	public var dstPath:String;
	public var baseDir:String;
	public var originalFilename:String;
	public var srcBytes:haxe.io.Bytes;
	/*
		The calculated hash for the input source file content.
	*/
	public var hash : String;

	public function new(sourceExts:String, destExt:String) {
		this.sourceExts = sourceExts == null ? null : sourceExts.split(",");
		this.destExt = destExt;
		this.version = 0;
	}

	public function cleanup() {
		params = null;
		localParams = null;
		srcPath = null;
		dstPath = null;
		baseDir = null;
		originalFilename = null;
		srcBytes = null;
		hash = null;
	}

	public function convert() {
		throw "Not implemented";
	}

	/**
		A function that should return quickly if the convert might have local params or not.
		Do not have access to: srcBytes, hash.
	**/
	public function hasLocalParams():Bool {
		return false;
	}

	public function computeLocalParams():Dynamic {
		return null;
	}

	function hasParam(name:String) {
		var f:Dynamic = Reflect.field(params, name);
		return f != null && f != false;
	}

	function getParam(name:String):Dynamic {
		var f:Dynamic = Reflect.field(params, name);
		if (f == null)
			throw "Missing required parameter '" + name + "' for converting " + srcPath + " to " + dstPath;
		return f;
	}

	function save(bytes:haxe.io.Bytes) {
		hxd.File.saveBytes(dstPath, bytes);
	}

	function command(cmd:String, args:Array<String>) {
		#if (sys || nodejs)
		var code = Sys.command(cmd, args);
		if (code != 0)
			throw "Command '" + cmd + (args.length == 0 ? "" : " " + args.join(" ")) + "' failed with exit code " + code;
		#else
		throw "Don't know how to run command on this platform";
		#end
	}

	@:persistent static var converts = new Map<String, Array<Convert>>();

	public static function register(c:Convert):Int {
		var dest = converts.get(c.destExt);
		if (dest == null) {
			dest = [];
			converts.set(c.destExt, dest);
		}
		dest.unshift(c); // latest registered get priority ! (allow override defaults)
		return 0;
	}
}

#if (sys || nodejs)
class ConvertFBX2HMD extends Convert {
	var fbx : hxd.fmt.fbx.Data.FbxNode;

	public function new() {
		super("fbx", "hmd");
	}

	override function cleanup() {
		super.cleanup();
		fbx = null;
	}

	override function hasLocalParams():Bool {
		return (params != null && params.collide != null);
	}

	override function computeLocalParams():Dynamic {
		// Parse fbx to find used materials
		fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch (e:Dynamic) throw Std.string(e) + " in " + srcPath;
		var matNodes = hxd.fmt.fbx.Data.FbxTools.getAll(fbx, "Objects.Material");
		var matNames = [];
		for( o in matNodes ) {
			var name = hxd.fmt.fbx.Data.FbxTools.getName(o);
			matNames.push(name);
		}
		// Parse material.props to find material config
		var ignoredMaterials = [];
		var dirPath = srcPath.substring(0, srcPath.lastIndexOf("/"));
		var matPropsPath = dirPath + "/materials.props";
		var matProps = null;
		try {
			var res = hxd.File.getBytes(matPropsPath).toString();
			matProps = haxe.Json.parse(res).materials;
		} catch( e ) {
		}
		if( matProps == null )
			return null;
		var modelLibCache = new Map<String, Array<Dynamic>>();
		for( config in Reflect.fields(matProps) ) {
			var configProps = Reflect.field(matProps, config);
			for( matName in matNames ) {
				var m = Reflect.field(configProps, matName);
				if( m == null )
					continue;
				if( m.ignoreCollide == true ) {
					ignoredMaterials.push(matName);
					continue;
				}
				// Parse model library
				if( m.__ref != null && m.name != null ) {
					var libchildren = modelLibCache.get(m.__ref);
					if( libchildren == null ) {
						var lib = try haxe.Json.parse(hxd.File.getBytes(baseDir + m.__ref).toString()) catch( e ) null;
						if( lib == null || lib.children == null )
							continue;
						libchildren = lib.children;
						modelLibCache.set(m.__ref, libchildren);
					}
					for( c in libchildren ) {
						if( c.type == "material" && c.name == m.name ) {
							if( c.props?.PBR?.ignoreCollide == true ) {
								ignoredMaterials.push(matName);
							}
							break;
						}
					}
				}
			}
		}
		return { ignoreCollideMaterials : ignoredMaterials };
	}

	override function convert() {
		if( fbx == null ) {
			fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch (e:Dynamic) throw Std.string(e) + " in " + srcPath;
		}
		var hmdout = new hxd.fmt.fbx.HMDOut(srcPath);
		if (params != null) {
			if (params.normals)
				hmdout.generateNormals = true;
			if (params.precise) {
				hmdout.highPrecision = true;
				hmdout.fourBonesByVertex = true;
			}
			if (params.maxBones != null)
				hmdout.maxBonesPerSkin = params.maxBones;
			if (params.tangents != null)
				hmdout.generateTangents = true;
			if (params.collide != null) {
				var collide = params.collide;
				hmdout.generateCollides = { precision : collide.precision,
					maxConvexHulls : collide.maxConvexHulls,
					maxSubdiv : collide.maxSubdiv
				};
			}
			if (params.lowp != null) {
				var m:haxe.DynamicAccess<String> = params.lowp;
				hmdout.lowPrecConfig = [];
				for (k in m.keys())
					hmdout.lowPrecConfig.set(k, switch (m.get(k)) {
						case "f16": F16;
						case "u8": U8;
						case "s8": S8;
						case x: throw "Invalid precision '" + x + "' should be u8|s8|f16";
					});
			}
			if ( params.optimizeMesh != null )
				hmdout.optimizeMesh = params.optimizeMesh;
			if (params.lodsDecimation != null) {
				var config: Array<Float> = params.lodsDecimation;
				hmdout.lodsDecimation = [for(lod in config) lod];
			}
		}
		if( localParams != null ) {
			if( localParams.ignoreCollideMaterials != null ) {
				hmdout.ignoreCollides = localParams.ignoreCollideMaterials;
			}
		}
		hmdout.load(fbx);
		var isAnim = StringTools.startsWith(originalFilename, "Anim_") || originalFilename.toLowerCase().indexOf("_anim_") > 0;
		var hmd = hmdout.toHMD(null, !isAnim);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		save(out.getBytes());
	}

	static var _ = Convert.register(new ConvertFBX2HMD());
}

class Command extends Convert {
	var cmd:String;
	var args:Array<String>;

	public function new(fr, to, cmd:String, args:Array<String>) {
		super(fr, to);
		this.cmd = cmd;
		this.args = args;
	}

	override function convert() {
		command(cmd, [for (a in args) if (a == "%SRC") srcPath else if (a == "%DST") dstPath else a]);
	}
}

class ConvertWAV2MP3 extends Convert {
	public function new() {
		super("wav", "mp3");
	}

	override function convert() {
		command("lame", ["--resample", "44100", "--silent", "-h", srcPath, dstPath]);
	}

	static var _ = Convert.register(new ConvertWAV2MP3());
}

class ConvertWAV2OGG extends Convert {
	public function new() {
		super("wav", "ogg");
	}

	override function convert() {
		var cmd = "oggenc";
		var args = ["--resample", "44100", "-Q", srcPath, "-o", dstPath];
		if (Sys.systemName() == "Windows")
			cmd = "oggenc2";
		if (hasParam("mono")) {
			var f = sys.io.File.read(srcPath);
			var wav = new format.wav.Reader(f).read();
			f.close();
			if (wav.header.channels >= 2)
				args.push("--downmix");
		}
		command(cmd, args);
	}

	static var _ = Convert.register(new ConvertWAV2OGG());
}

class ConvertTGA2PNG extends Convert {
	public function new() {
		super("tga", "png");
	}

	override function convert() {
		var input = new haxe.io.BytesInput(sys.io.File.getBytes(srcPath));
		var r = new format.tga.Reader(input).read();
		if (r.header.imageType != UncompressedTrueColor || r.header.bitsPerPixel != 32)
			throw "Not supported " + r.header.imageType + "/" + r.header.bitsPerPixel;
		var w = r.header.width;
		var h = r.header.height;
		var pix = hxd.Pixels.alloc(w, h, ARGB);
		var access:hxd.Pixels.PixelsARGB = pix;
		var p = 0;
		for (y in 0...h)
			for (x in 0...w) {
				var c = r.imageData[x + y * w];
				access.setPixel(x, y, c);
			}
		switch (r.header.imageOrigin) {
			case BottomLeft:
				pix.flipY();
			case TopLeft:
			default:
				throw "Not supported " + r.header.imageOrigin;
		}
		sys.io.File.saveBytes(dstPath, pix.toPNG());
	}

	static var _ = Convert.register(new ConvertTGA2PNG());
}

class ConvertFNT2BFNT extends Convert {
	var emptyTile:h2d.Tile;

	public function new() {
		// Fake tile create subs before discarding the font.
		emptyTile = @:privateAccess new h2d.Tile(null, 0, 0, 0, 0, 0, 0);
		super("fnt", "bfnt");
		version = 1;
	}

	override public function convert() {
		var font = hxd.fmt.bfnt.FontParser.parse(srcBytes, srcPath, resolveTile);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.bfnt.Writer(out).write(font);
		save(out.getBytes());
	}

	function resolveTile(path:String):h2d.Tile {
		if (!sys.FileSystem.exists(path))
			throw "Could not resolve BitmapFont texture reference at path: " + path;
		return emptyTile;
	}

	static var _ = Convert.register(new ConvertFNT2BFNT());
}

class CompressIMG extends Convert {
	static var TEXCONV_FMT = [
		"R16F" => "R16_FLOAT",
		"R32F" => "R32_FLOAT",
		"RG16F" => "R16G16_FLOAT",
		"RG32F" => "R32G32_FLOAT",
		"RGB16F" => "R16G16B16_FLOAT",
		"RGB32F" => "R32G32B32_FLOAT",
		"RGBA16F" => "R16G16B16A16_FLOAT",
		"RGBA32F" => "R32G32B32A32_FLOAT",
		"RGBA" => "R8G8B8A8_UNORM",
		"R16U" => "R16_UNORM",
		"RG16U" => "R16G16_UNORM",
		"RGBA16U" => "R16G16B16A16_UNORM",
	];

	function makeImage(path:String) {
		return @:privateAccess new hxd.res.Image(new hxd.fs.BytesFileSystem.BytesFileEntry(path, sys.io.File.getBytes(path)));
	}

	override function convert() {
		var resizedImagePath:String = null;
		var mips = hasParam("mips") && getParam("mips") == true;
		if (hasParam("size")) {
			try {
				var maxSize = getParam("size");
				var image = makeImage(srcPath);
				var pxls = image.getPixels();
				if (pxls.width == pxls.height && pxls.width > maxSize) {
					pxls.dispose();
					var prevMip = mips;
					if (!prevMip)
						Reflect.setField(params, "mips", true);
					Reflect.deleteField(params, "size");
					var tmpPath = new haxe.io.Path(dstPath);
					tmpPath.ext = "forced_mips." + tmpPath.ext;
					var prevDstPath = dstPath;
					dstPath = tmpPath.toString();
					convert();
					dstPath = prevDstPath;
					Reflect.setField(params, "size", maxSize);
					if (!prevMip)
						Reflect.deleteField(params, "mips");
					var prevMipSize = hxd.res.Image.MIPMAP_MAX_SIZE;
					hxd.res.Image.MIPMAP_MAX_SIZE = maxSize;
					var mippedImage = makeImage(tmpPath.toString());
					var resizedPixels = mippedImage.getPixels();
					hxd.res.Image.MIPMAP_MAX_SIZE = prevMipSize;
					srcPath = Sys.getEnv("TEMP") + "/output_resized_" + srcPath.split("/").pop();
					resizedImagePath = srcPath;
					sys.io.File.saveBytes(srcPath, resizedPixels.toPNG());
					resizedPixels.dispose();
					sys.FileSystem.deleteFile(tmpPath.toString());
				}
			} catch (e:Dynamic) {
				trace("Faile to resize", e);
			}
		}
		var format = getParam("format");
		var tcFmt = TEXCONV_FMT.get(format);
		if (tcFmt != null) {
			// texconv can only handle output dir, and it prepended to srcPath :'(
			var tmpPath = new haxe.io.Path(dstPath);
			tmpPath.ext = "tmp." + new haxe.io.Path(srcPath).ext;
			var tmpFile = tmpPath.toString();
			try
				sys.FileSystem.deleteFile(tmpFile)
			catch (e:Dynamic) {};
			try
				sys.FileSystem.deleteFile(dstPath)
			catch (e:Dynamic) {};
			sys.io.File.copy(srcPath, tmpFile);

			var args = [
				"-f",
				tcFmt,
				"-y",
				"-nologo",
				"-srgb", // Convert srgb to linear color space if target format doesn't support srgb (i.e from convertig from PNG to dds RGBA)
				tmpFile
			];

			if (!mips)
				args = ["-m", "1"].concat(args);
			command("texconv", args);
			sys.FileSystem.deleteFile(tmpFile);
			tmpPath.ext = "tmp.DDS";
			var p = tmpPath.toString();
			if ( sys.FileSystem.exists(p) )
				sys.FileSystem.rename(p, dstPath);
			return;
		}
		var path = new haxe.io.Path(srcPath);
		if (path.ext == "dds") {
			var image = makeImage(srcPath);
			var info = image.getInfo();
			if (info.layerCount > 1 && info.dataFormat == Dds) {
				var oldBytes = srcBytes;
				var oldPath = srcPath;
				for (layer in 0...info.layerCount) {
					var layerPixels = [];
					for (mip in 0...info.mipLevels) {
						var pixels = image.getPixels(null, layer * info.mipLevels + mip);
						layerPixels.push(pixels);
					}
					var layerBytes = hxd.Pixels.toDDSLayers(layerPixels);
					for (pixels in layerPixels)
						pixels.dispose();
					var tmpPath = dstPath + path.file + "_" + layer + "." + path.ext;
					sys.io.File.saveBytes(tmpPath, layerBytes);
					srcBytes = layerBytes;
					srcPath = tmpPath;
					convert();
					sys.FileSystem.deleteFile(tmpPath);
				}
				srcBytes = oldBytes;
				srcPath = oldPath;
				var convertPixels = [];
				for (layer in 0...info.layerCount) {
					var layerPath = dstPath + path.file + "_" + layer + "_dds_" + format + "." + path.ext;
					var image = makeImage(layerPath);
					for (mip in 0...info.mipLevels) {
						var pixels = image.getPixels(null, mip);
						convertPixels.push(pixels);
					}
					sys.FileSystem.deleteFile(layerPath);
				}
				var convertBytes = hxd.Pixels.toDDSLayers(convertPixels);
				for (pixels in convertPixels)
					pixels.dispose();
				var tmpPath = dstPath + path.file + "_" + format + "." + path.ext;
				sys.io.File.saveBytes(tmpPath, convertBytes);
				return;
			}
		}
		var args = ["-silent"];
		if (mips) {
			args.push("-miplevels");
			args.push("20"); // max ?
		}
		var ext = srcPath.split(".").pop();
		var tmpPath = null;
		if (ext == "envd" || ext == "envs") {
			// copy temporary (compressonator uses file extension ;_;)
			tmpPath = Sys.getEnv("TEMP") + "/output_" + dstPath.split("/").pop() + ".dds";
			sys.io.File.saveBytes(tmpPath, sys.io.File.getBytes(srcPath));
		}
		if (hasParam("alpha") && format == "BC1")
			args = args.concat(["-DXT1UseAlpha", "1", "-AlphaThreshold", "" + getParam("alpha")]);
		args = args.concat(["-fd", "" + getParam("format"), tmpPath == null ? srcPath : tmpPath, dstPath]);
		command("CompressonatorCLI", args);
		if (tmpPath != null)
			sys.FileSystem.deleteFile(tmpPath);
		if (resizedImagePath != null)
			sys.FileSystem.deleteFile(resizedImagePath);
	}

	static var _ = Convert.register(new CompressIMG("png,tga,jpg,jpeg,dds,envd,envs", "dds"));
}

class DummyConvert extends Convert {
	override function convert() {
		save(haxe.io.Bytes.alloc(0));
	}

	static var _ = [
		Convert.register(new DummyConvert(null, "dummy")),
		Convert.register(new DummyConvert(null, "remove"))
	];
}

class ConvertBinJSON extends Convert {
	override function convert() {
		var json = haxe.Json.parse(srcBytes.toString());
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hbson.Writer(out).write(json);
		save(out.getBytes());
	}

	static var _ = [Convert.register(new ConvertBinJSON("json,prefab,l3d", "hbson"))];
}

class ConvertSVGToMSDF extends Convert {
	override function convert() {
		var size = hasParam("size") ? getParam("size") : 128;
		command("msdfgen.exe", ["-svg", srcPath, "-size", '$size', '$size', "-autoframe", "-o", dstPath]);
	}

	static var _ = Convert.register(new ConvertSVGToMSDF("svg", "png"));
}

class ConvertPngToKtx2 extends hxd.fs.Convert {
	override function convert() {
		final format = params.dataFormat ?? 'R8G8B8A8_SRGB';
		final oetf = params.assignOetf ?? 'srgb';
		final primaries = params.assignPrimaries ?? 'bt709';
		final cmd = if ( params.format == 'etc1s' ) {
			final clevel = params.clevel ?? 3;
			final qlevel = params.qlevel ?? 128;
			'ktx create --encode basis-lz --format ${format} --assign-oetf ${oetf} --clevel ${clevel} --qlevel ${qlevel} --warn-on-color-conversions --compare-psnr ${srcPath} ${dstPath}';

		} else {
			final quality = params.quality ?? 2;
			'ktx create --encode uastc --zstd 18 --format ${format} --assign-oetf ${oetf} --uastc-quality ${quality} --warn-on-color-conversions --compare-psnr ${srcPath} ${dstPath}';
		}
		final scProcess = new sys.io.Process(cmd);
		final errorMsg = 'Error compressing $srcPath to ktx2: ${scProcess.stderr.readAll().toString()}';
		if ( scProcess.exitCode() != 0 ) {
			throw errorMsg;
		} 
		final regexp = ~/PSNR Max: (.+)/;
		final result = scProcess.stdout.readAll().toString();
		final snr = regexp.match(result) ? regexp.matched(1) : null;
		#if log_ktx2_snr Sys.println('        Converted ${haxe.io.Path.withoutDirectory(srcPath)} with PSNR Max: ${snr}'); #end
		if ( params.snrThreshold != null && params.format == 'etc1s' ) {
			if ( Std.parseFloat(snr) < params.snrThreshold ) {
				params.format = 'uastc';
				// If signal to noise ratio is too low, discard ETC1S and use UASTC encoding instead
				sys.FileSystem.deleteFile(dstPath);
				trace('⚠️⚠️⚠️  Low signal to noise ratio when encoding $srcPath as ETC1S. Will fall back to using UASTC with default settings. Update props.json to use "uastc" as format, or ajust or remove "snrThreshold" to make it pass verification. ⚠️⚠️⚠️');
				final process = new sys.io.Process('ktx create --encode uastc --zstd 18 --format ${format} --assign-oetf ${oetf} --uastc-quality 2 --warn-on-color-conversions ${srcPath} ${dstPath}');
				if ( process.exitCode() != 0 ) {
					throw errorMsg;
				}
			}
		}
		
	}

	// register the convert so it can be found
	static var _ = hxd.fs.Convert.register(new ConvertPngToKtx2('png', 'ktx2'));
}
#end
