package h3d.mat;
import h3d.mat.Data;

class Texture3D extends Texture {

	var depth : Int;

	public function new(w, h, d, ?flags : Array<TextureFlags>, ?format : TextureFormat ) {
		this.depth = d;
		if( flags == null ) flags = [];
		flags.push(Is3D);
		super(w,h,flags,format);
	}

	override function get_layerCount() {
		return depth;
	}

	override function clone() {
		var old = lastFrame;
		preventAutoDispose();
		var t = new Texture3D(width, height, depth, null, format);
		h3d.pass.Copy.run(this, t);
		lastFrame = old;
		return t;
	}

	override function toString() {
		return super.toString()+"x("+depth+")";
	}

	/**
		Returns a default 1x1x1 black 3D texture
	**/
	public static function default3DTexture() {
		var engine = h3d.Engine.getCurrent();
		var t : h3d.mat.Texture3D = @:privateAccess engine.resCache.get(Texture3D);
		if( t != null )
			return t;
		t = new Texture3D(1, 1, 1, hxd.PixelFormat.R8);
		@:privateAccess engine.resCache.set(Texture,t);
		return t;
	}

}