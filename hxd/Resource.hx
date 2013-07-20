package hxd;
#if macro
import haxe.macro.Context;
#end

#if js
abstract BitmapRes(String) {
	public function new( resourceName : String ) {
		this = resourceName;
	}
	public function toTexture() {
		var engine = h3d.Engine.getCurrent();
		var res = haxe.Resource.getBytes(this);
		if( res == null ) throw "Missing resource " + this;
		var isPng = res.get(0) == 137;
		if( isPng ) {
			var png = new format.png.Reader(new haxe.io.BytesInput(res)).read();
			var pngBytes = format.png.Tools.extract32(png);
			var pngHeader = format.png.Tools.getHeader(png);
			var tex = engine.mem.allocTexture(pngHeader.width, pngHeader.height);
			tex.uploadBytes(pngBytes);
			return tex;
		} else {
			throw "TODO";
		}
	}
}
#end


class Resource {

	public static macro function embed( fileName : String ) {
		try {
			var path = Context.resolvePath(fileName);
			var ext = fileName.split(".").pop().toLowerCase();
			switch( ext ) {
			case "png", "jpg":
				if( Context.defined("flash") ) {
					throw "TODO";
				} else if( Context.defined("js") ) {
					Context.addResource(fileName, sys.io.File.getBytes(path));
					return macro new hxd.Resource.BitmapRes($v{fileName});
				}
			default:
				throw "Unsupported file extension '" + ext + "'";
			}
			throw "Not implementation for this platform";
		} catch( msg : String ) {
			Context.error(msg, Context.currentPos());
			return macro null;
		}
	}
	
}