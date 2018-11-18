package hxd.fs;

class Convert {

	/**
		Custom list of converts that should be used in FileSystem.
		Should be added in hxml `--macro` to ensure proper function.
		Example of adding a Convert:
		```haxe
		static function initCustomConverts() {
			hxd.fs.Convert.converts.push("path.to.my.Convert");
			hxd.fs.Convert.converts.push("path.to.my.OtherConvert");
		}
		```
		Adn in hxml:
		`--macro path.to.my.MacroScript.initCustomConverts()`
	**/
	public static var converts:Array<String> = new Array();

	static macro function getConverts() : haxe.macro.Expr {
		var exprs:Array<haxe.macro.Expr> = new Array();
		var pos = haxe.macro.Context.currentPos();
		
		for ( p in converts ) {
			var t = haxe.macro.Context.getType(p);
			var ct = haxe.macro.TypeTools.toComplexType(t);
			switch (ct) {
				case TPath(t):
					var newExpr : haxe.macro.Expr = { expr: ENew(t, []), pos: pos };
					exprs.push(macro addConvert($newExpr));
				default:
			}
		}
		return macro $b{exprs}
	}

	public var sourceExt(default,null) : String;
	public var destExt(default,null) : String;

	public var srcPath : String;
	public var dstPath : String;
	public var srcFilename : String;
	public var srcBytes : haxe.io.Bytes;

	public function new( sourceExt, destExt ) {
		this.sourceExt = sourceExt;
		this.destExt = destExt;
	}

	public function convert() {
		throw "Not implemented";
	}

	function save( bytes : haxe.io.Bytes ) {
		hxd.File.saveBytes(dstPath, bytes);
	}

	function command( cmd : String, args : Array<String> ) {
		#if flash
		trace("TODO");
		#elseif sys
		var code = Sys.command(cmd, args);
		if( code != 0 )
			throw "Command '" + cmd + (args.length == 0 ? "" : " " + args.join(" ")) + "' failed with exit code " + code;
		#else
		throw "Don't know how to run command on this platform";
		#end
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
		var isAnim = StringTools.startsWith(srcFilename, "Anim_") || srcFilename.toLowerCase().indexOf("_anim_") > 0;
		var hmd = hmdout.toHMD(null, !isAnim);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		save(out.getBytes());
	}

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

}

class ConvertWAV2OGG extends Convert {

	public function new() {
		super("wav", "ogg");
	}

	override function convert() {
		var cmd = "oggenc";
		#if (sys || nodejs)
		if( Sys.systemName() == "Windows" ) cmd = "oggenc2";
		#end
		command(cmd, ["--resample", "44100", "-Q", srcPath, "-o", dstPath]);
	}

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

}

class ConvertFNT2BFNT extends Convert {
	
	var emptyTile : h2d.Tile;
	
	public function new() {
		// Fake tile create subs before discarding the font.
		emptyTile = @:privateAccess new h2d.Tile(null, 0, 0, 0, 0, 0, 0);
		super("fnt", "bfnt");
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
}