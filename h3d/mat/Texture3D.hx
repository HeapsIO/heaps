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

}