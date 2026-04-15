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

	public static function defaultArrayTexture() {
		var engine = h3d.Engine.getCurrent();
		var t : h3d.mat.TextureArray = @:privateAccess engine.resCache.get(TextureArray);
		if( t != null )
			return t;
		t = new TextureArray(1, 1, 1);
		t.clear(0x202020);
		t.realloc = function() t.clear(0x202020);
		t.setName("defaultArrayTexture");
		@:privateAccess engine.resCache.set(TextureArray, t);
		return t;
	}

	override function toString() {
		return super.toString()+"["+layers+"]";
	}

}