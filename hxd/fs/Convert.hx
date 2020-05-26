package hxd.fs;

@:keep @:keepSub
class Convert {

	public var sourceExts(default,null) : Array<String>;
	public var destExt(default,null) : String;

	/**
		Major version of the Convert.
		When incremented, all files processed by this Convert would be rebuilt. **/
	public var version(default, null) : Int;

	public var params : Dynamic;

	public var srcPath : String;
	public var dstPath : String;
	public var originalFilename : String;
	public var srcBytes : haxe.io.Bytes;

	public function new( sourceExts, destExt ) {
		this.sourceExts = sourceExts == null ? null : sourceExts.split(",");
		this.destExt = destExt;
		this.version = 0;
	}

	public function convert() {
		throw "Not implemented";
	}

	function hasParam( name : String ) {
		var f : Dynamic = Reflect.field(params, name);
		return f != null && f != false;
	}

	function getParam( name : String ) {
		var f = Reflect.field(params, name);
		if( f == null ) throw "Missing required parameter '"+name+"' for converting "+srcPath+" to "+dstPath;
		return f;
	}

	function save( bytes : haxe.io.Bytes ) {
		hxd.File.saveBytes(dstPath, bytes);
	}

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

class ConvertFBX2HMD extends Convert {

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

class Command extends Convert {

	var cmd : String;
	var args : Array<String>;

	public function new(fr,to,cmd:String,args:Array<String>) {
		super(fr,to);
		this.cmd = cmd;
		this.args = args;
	}

	override function convert() {
		command(cmd,[for( a in args ) if( a == "%SRC" ) srcPath else if( a == "%DST" ) dstPath else a]);
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

class ConvertTGA2PNG extends Convert {

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

class ConvertFNT2BFNT extends Convert {

	var emptyTile : h2d.Tile;

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


class CompressIMG extends Convert {

	override function convert() {
		command("CompressonatorCLI", ["-silent","-fd",getParam("format"),srcPath,dstPath]);
	}

	static var _ = Convert.register(new CompressIMG("png,tga,jpg,jpeg","dds"));

}

class DummyConvert extends Convert {

	override function convert() {
		save(haxe.io.Bytes.alloc(0));
	}

	static var _ = [
		Convert.register(new DummyConvert(null,"dummy")),
		Convert.register(new DummyConvert(null,"remove"))
	];

}