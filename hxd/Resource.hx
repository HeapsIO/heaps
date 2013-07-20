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
			// converts BGRA to RGBA
			var pos = 0;
			for( i in 0...pngHeader.width * pngHeader.height ) {
				var b = pngBytes.get(pos);
				var r = pngBytes.get(pos + 2);
				pngBytes.set(pos, r);
				pngBytes.set(pos + 2, b);
				pos += 4;
			}
			var tex = engine.mem.allocTexture(pngHeader.width, pngHeader.height);
			tex.uploadBytes(pngBytes);
			return tex;
		} else {
			throw "TODO";
		}
	}
}

#elseif flash

abstract BitmapRes(Class<flash.display.BitmapData>) {
	public function new( cl ) {
		this = cl;
	}
	public function toTexture() {
		var bmp = Type.createInstance(this, [0, 0]);
		var tex = h3d.mat.Texture.fromBitmap(hxd.BitmapData.fromNative(bmp));
		bmp.dispose();
		return tex;
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
					var className = "I_" + StringTools.urlEncode(path.split(".").join("_")).split("%").join("_").split(" ").join("_");
					var pos = Context.currentPos();
					Context.defineType( {
						pos : pos,
						params : [],
						pack : ["res"],
						name : className,
						meta : [ { name : ":bitmap", params : [ { expr : EConst(CString(path)), pos : pos } ], pos : pos } ],
						kind : TDClass({ pack : ["flash","display"], name : "BitmapData", params : [] }),
						isExtern : false,
						fields : [],
					});
					return macro new hxd.Resource.BitmapRes(res.$className);
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