package h3d.mat;
import h3d.mat.Data;

class TextureArray extends Texture {

	var layers : Int;

	public function new(w, h, layers, ?flags : Array<TextureFlags>, ?format : TextureFormat, ?allocPos : h3d.impl.AllocPos ) {
		this.layers = layers;
		if( flags == null ) flags = [];
		flags.push(IsArray);
		super(w,h,flags,format,allocPos);
	}

	override function get_layerCount() {
		return layers;
	}

	override function clone( ?allocPos : h3d.impl.AllocPos ) {
		var old = lastFrame;
		preventAutoDispose();
		var t = new TextureArray(width, height, layers, null, format, allocPos);
		h3d.pass.Copy.run(this, t);
		lastFrame = old;
		return t;
	}

	override function toString() {
		return super.toString()+"["+layers+"]";
	}

}