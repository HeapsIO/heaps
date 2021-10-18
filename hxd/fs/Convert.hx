package hxd.fs;

/**
	The base class that processes raw asset file into a compatible with the engine format.

	@see [Resource baking](https://heaps.io/documentation/resource-baking.html) wiki entry.
**/
@:keep @:keepSub
class Convert {
	/**
		The list of original file extensions this Convert can process.

		Considered to be able to process any file type if `null`.
	**/
	public var sourceExts(default,null) : Array<String>;
	/**
		The output extension of the processed file.
	**/
	public var destExt(default,null) : String;

	/**
		Major version of the Convert.
		When incremented, all files processed by this Convert would be rebuilt.
	**/
	public var version(default, null) : Int;

	/**
		The extra data passed via the convert rule. Can be null.

		For example, when declaring convert as `{ convert: "myFancyConvert", compress: true }` would put `compress: true` inside the `params` objects.
		Note that `convert`, `priority` and `then` names are reserved and cannot be used as params.
	**/
	public var params : Dynamic;

	/**
		The path to the original asset file that is to be converted.

		Can be utilized to access files referenced by the asset.
		The asset data itself can be accessed via `Convert.srcBytes`.
	**/
	public var srcPath : String;
	/**
		The path to the resulting converted asset file.

		Should be used to save the output. Alternatively `Convert.save` can be used.
	**/
	public var dstPath : String;
	/**
		The name of the file that is to be converted.
	**/
	public var originalFilename : String;
	/**
		The contents of the original asset that should be converted.
	**/
	public var srcBytes : haxe.io.Bytes;

	/**
		Create a new Convert instance. Base class should not be instantiated directly.

		@param sourceExts The comma-separated list of the original file extensions this Convert can process or `null` for any.
		@param destExt The output extension of the processed file.
	**/
	public function new( sourceExts : String, destExt : String ) {
		this.sourceExts = sourceExts == null ? null : sourceExts.split(",");
		this.destExt = destExt;
		this.version = 0;
	}

	/**
		Executes the conversion operation. Should be overridden by the subclass convert.

		Should create the file at `Convert.dstPath` by calling `Convert.save` or directly via `sys.io.File` API.
	**/
	public function convert() {
		throw "Not implemented";
	}

	/**
		Checks if the param under `name` exists in the `Convert.params`, not `null` and not `false`.
	**/
	@:dox(show)
	function hasParam( name : String ) {
		var f : Dynamic = Reflect.field(params, name);
		return f != null && f != false;
	}

	/**
		Returns the param under `name` from the `Convert.params`. Throws an error if param is `null`.
	**/
	@:dox(show)
	function getParam( name : String ) : Dynamic {
		var f : Dynamic = Reflect.field(params, name);
		if( f == null ) throw "Missing required parameter '"+name+"' for converting "+srcPath+" to "+dstPath;
		return f;
	}

	/**
		Saves the resulting `bytes` to the `Convert.dstPath`.
		Should be called during `Convert.convert`, or the file in dstPath created via `sys.io.File`.
	**/
	@:dox(show)
	function save( bytes : haxe.io.Bytes ) {
		hxd.File.saveBytes(dstPath, bytes);
	}

	/**
		Executes a shell command `cmd` with the given arguments `args`.

		Equivalent to `Sys.command`, but will throw an error if the resulting code is not `0`.
	**/
	@:dox(show)
	function command( cmd : String, args : Array<String> ) {
		#if flash
		trace("TODO");
		#elseif (sys || nodejs)
		var code = Sys.command(cmd, args);
		if( code != 0 )
			throw "Command '" + cmd + (args.length == 0 ? "" : " " + args.join(" ")) + "' failed with exit code " + code;
		#else
		throw "Don't know how to run command on this platform";
		#end
	}

	static var converts = new Map<String,Array<Convert>>();
	/**
		Registers the Convert in the system to be used for file conversion.
	**/
	public static function register( c : Convert ) : Int {
		var dest = converts.get(c.destExt);
		if( dest == null ) {
			dest = [];
			converts.set(c.destExt, dest);
		}
		dest.unshift(c); // latest registered get priority ! (allow override defaults)
		return 0;
	}


}

/**
	Converts FBX models to internal optimized HMD models.

	Registered and enabled by default.
**/
class ConvertFBX2HMD extends Convert {

	@:dox(hide)
	public function new() {
		super("fbx", "hmd");
	}

	override function convert() {
		var fbx = try hxd.fmt.fbx.Parser.parse(srcBytes) catch( e : Dynamic ) throw Std.string(e) + " in " + srcPath;
		var hmdout = new hxd.fmt.fbx.HMDOut(srcPath);
		hmdout.load(fbx);
		var isAnim = StringTools.startsWith(originalFilename, "Anim_") || originalFilename.toLowerCase().indexOf("_anim_") > 0;
		var hmd = hmdout.toHMD(null, !isAnim);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		save(out.getBytes());
	}

	static var _ = Convert.register(new ConvertFBX2HMD());

}

/**
	The shell command convert.

	Uses `Convert.command` to perform an operation via external tool and expects it to save the processed file at the `Convert.dstPath`.
	The following two arguments can be used to substitute `Convert.srcPath` and `Convert.dstPath` respectively: `%SRC` and `%DST`.

	For example, to create a simple shell command convert, register it as such:
	`static var _ = Convert.register(new Command("gif", "png", "gif-split", ["%SRC", "%DST", "-horizontal", "-spacing", "2"]))`
**/
class Command extends Convert {

	var cmd : String;
	var args : Array<String>;

	/**
		Create a new shell command convert.
		@param fr The comma-separated list of the original file extensions this Convert can process or `null` for any.
		@param to The output extension of the processed file.
		@param cmd The command that is to be executed.
		@param args The list of arguments passed to the command. Use `%SRC` and `%DST` as a placeholder for `Convert.srcPath` and `Convert.dstPath` respectively.
	**/
	public function new(fr,to,cmd:String,args:Array<String>) {
		super(fr,to);
		this.cmd = cmd;
		this.args = args;
	}

	override function convert() {
		command(cmd,[for( a in args ) if( a == "%SRC" ) srcPath else if( a == "%DST" ) dstPath else a]);
	}

}

/**
	Converts raw wave audio files to MP3.
	
	Expects `lame` to be accessible from command line.

	Uses `--resample 44100` and `-h` flags.

	Registered by default.

	@see [Lame project](https://lame.sourceforge.io/) for the encoder.
**/
class ConvertWAV2MP3 extends Convert {

	@:dox(hide)
	public function new() {
		super("wav", "mp3");
	}

	override function convert() {
		command("lame", ["--resample", "44100", "--silent", "-h", srcPath, dstPath]);
	}

	static var _ = Convert.register(new ConvertWAV2MP3());

}

/**
	Converts raw wave audio files to OGG.

	Expects `oggenc` to be accessible from command line.

	Uses `--resample 44100` and `-Q` flags.

	Registered by default.

	@see [Xiph website](https://www.xiph.org/) for vorbis-tools.
**/
class ConvertWAV2OGG extends Convert {

	@:dox(hide)
	public function new() {
		super("wav", "ogg");
	}

	override function convert() {
		var cmd = "oggenc";
		var args = ["--resample", "44100", "-Q", srcPath, "-o", dstPath];
		#if (sys || nodejs)
		if( Sys.systemName() == "Windows" ) cmd = "oggenc2";
		if( hasParam("mono") ) {
			var f = sys.io.File.read(srcPath);
			var wav = new format.wav.Reader(f).read();
			f.close();
			if( wav.header.channels >= 2 )
				args.push("--downmix");
		}
		#end
		command(cmd, args);
	}

	static var _ = Convert.register(new ConvertWAV2OGG());

}

/**
	Converts Truevision TGA files to PNG.

	Registered by default.
**/
class ConvertTGA2PNG extends Convert {

	@:dox(hide)
	public function new() {
		super("tga", "png");
	}

	override function convert() {
		#if (sys || nodejs)
		var input = new haxe.io.BytesInput(sys.io.File.getBytes(srcPath));
		var r = new format.tga.Reader(input).read();
		if( r.header.imageType != UncompressedTrueColor || r.header.bitsPerPixel != 32 )
			throw "Not supported "+r.header.imageType+"/"+r.header.bitsPerPixel;
		var w = r.header.width;
		var h = r.header.height;
		var pix = hxd.Pixels.alloc(w, h, ARGB);
		var access : hxd.Pixels.PixelsARGB = pix;
		var p = 0;
		for( y in 0...h )
			for( x in 0...w ) {
				var c = r.imageData[x + y * w];
				access.setPixel(x, y, c);
			}
		switch( r.header.imageOrigin ) {
		case BottomLeft:
			pix.flags.set(FlipY);
		case TopLeft:
		default:
			throw "Not supported "+r.header.imageOrigin;
		}
		sys.io.File.saveBytes(dstPath, pix.toPNG());
		#else
		throw "Not implemented";
		#end
	}

	static var _ = Convert.register(new ConvertTGA2PNG());

}

/**
	Converts the BMFont FNT format to internal BFNT.

	Registered and enabled by default.
**/
class ConvertFNT2BFNT extends Convert {

	var emptyTile : h2d.Tile;

	@:dox(hide)
	public function new() {
		// Fake tile create subs before discarding the font.
		emptyTile = @:privateAccess new h2d.Tile(null, 0, 0, 0, 0, 0, 0);
		super("fnt", "bfnt");
		version = 1;
	}

	override public function convert()
	{
		var font = hxd.fmt.bfnt.FontParser.parse(srcBytes, srcPath, resolveTile);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.bfnt.Writer(out).write(font);
		save(out.getBytes());
	}

	function resolveTile( path : String ) : h2d.Tile {
		#if sys
		if (!sys.FileSystem.exists(path)) throw "Could not resolve BitmapFont texture reference at path: " + path;
		#end
		return emptyTile;
	}

	static var _ = Convert.register(new ConvertFNT2BFNT());

}

/**
	Compresses the images to the DDS texture based on input params.

	@param format The texture format to convert.
	The following formats require `texconv` to be accessible from command-line: `R16F`, `R32F`, `RG16F`, `RG32F`, `RGB16F`, `RGB32F`, `RGBA16F`, `RGBA32F`
	Any other format expects `CompressonatorCLI` to be accessible from command-line.
	@param mips Set to `true` to enable mipmap generation.
	@param alpha Required when `BC1` format to set alpha threshold.

	@see [DirectXTex](https://github.com/microsoft/DirectXTex)
	@see [Compressonator](https://gpuopen.com/compressonator/)

	Registered for png, tga, jpg, jpeg by default.
**/
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
	];

	override function convert() {
		var format = getParam("format");
		var mips = hasParam("mips") && getParam("mips") == true;
		var tcFmt = TEXCONV_FMT.get(format);
		if( tcFmt != null ) {
			// texconv can only handle output dir, and it prepended to srcPath :'(
			var tmpPath = new haxe.io.Path(dstPath);
			tmpPath.ext = "tmp."+new haxe.io.Path(srcPath).ext;
			var tmpFile = tmpPath.toString();
			#if (sys || nodejs)
			try sys.FileSystem.deleteFile(tmpFile) catch( e : Dynamic ) {};
			try sys.FileSystem.deleteFile(dstPath) catch( e : Dynamic ) {};
			sys.io.File.copy(srcPath, tmpFile);
			var args = ["-f", tcFmt, "-y", "-nologo", tmpFile];
			if( !mips ) args = ["-m", "1"].concat(args);
			command("texconv", args);
			sys.FileSystem.deleteFile(tmpFile);
			tmpPath.ext = "tmp.DDS";
			sys.FileSystem.rename(tmpPath.toString(), dstPath);
			#else
			throw "Require sys";
			#end
			return;
		}
		var args = ["-silent"];
		if( mips ) {
			args.push("-miplevels");
			args.push("20"); // max ?
		}
		if( hasParam("alpha") && format == "BC1" )
			args = args.concat(["-DXT1UseAlpha","1","-AlphaThreshold",""+getParam("alpha")]);
		args = args.concat(["-fd",""+getParam("format"),srcPath,dstPath]);
		command("CompressonatorCLI", args);
	}

	static var _ = Convert.register(new CompressIMG("png,tga,jpg,jpeg","dds"));

}

/**
	The dummy convert that saves an empty file.

	Registered under names `dummy` and `remove` by default.
**/
class DummyConvert extends Convert {

	override function convert() {
		save(haxe.io.Bytes.alloc(0));
	}

	static var _ = [
		Convert.register(new DummyConvert(null,"dummy")),
		Convert.register(new DummyConvert(null,"remove"))
	];

}