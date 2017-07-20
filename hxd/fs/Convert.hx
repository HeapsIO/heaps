package hxd.fs;

class Convert {

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
		#else
		var code = Sys.command(cmd, args);
		if( code != 0 )
			throw "Command '" + cmd + (args.length == 0 ? "" : " " + args.join(" ")) + "' failed with exit code " + code;
		#end
	}

}

class ConvertFBX2HMD extends Convert {

	public function new() {
		super("fbx", "hmd");
	}

	override function convert() {
		var fbx = try hxd.fmt.fbx.Parser.parse(srcBytes.toString()) catch( e : Dynamic ) throw Std.string(e) + " in " + srcPath;
		var hmdout = new hxd.fmt.fbx.HMDOut();
		hmdout.load(fbx);
		var isAnim = StringTools.startsWith(srcFilename, "Anim_") || srcFilename.toLowerCase().indexOf("_anim_") > 0;
		var hmd = hmdout.toHMD(null, !isAnim);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		save(out.getBytes());
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
		command("oggenc2", ["--resample", "44100", "-Q", srcPath, "-o", dstPath]);
	}

}