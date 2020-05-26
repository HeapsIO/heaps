package h3d.mat;
import h3d.mat.Data;

class TextureArray extends Texture {

	var layers : Int;

	public function new(w, h, layers, ?flags : Array<TextureFlags>, ?format : TextureFormat ) {
		this.layers = layers;
		if( flags == null ) flags = [];
		flags.push(IsArray);
		super(w,h,flags,format);
	}

	override function get_layerCount() {
		return layers;
	}

	override function clone() {
		var old = lastFrame;
		preventAutoDispose();
		var t = new TextureArray(width, height, layers, null, format);
		h3d.pass.Copy.run(this, t);
		lastFrame = old;
		return t;
	}

	override function toString() {
		return super.toString()+"["+layers+"]";
	}

}