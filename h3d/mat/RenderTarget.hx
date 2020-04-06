package h3d.mat;
import h3d.mat.Data;

class RenderTarget extends Texture {

	public var scale(default, set) : Float;

	public function new(scale = 1., ?format : TextureFormat ) {
		super(0, 0, [NoAlloc, Target], format);
		this.scale = scale;
	}

	function set_scale( f : Float ) {
		dispose();
		return scale = f;
	}

	override function alloc() {
		var engine = h3d.Engine.getCurrent();
		width = Math.ceil(engine.width * scale);
		height = Math.ceil(engine.height * scale);
		super.alloc();
	}

}