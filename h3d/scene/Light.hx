package h3d.scene;

class Light extends Object {

	var shader : hxsl.Shader;
	@:noCompletion public var next : Light; // used internaly (public to allow sorting)

	public var color(get, set) : h3d.Vector;

	function new(shader,?parent) {
		super(parent);
		this.shader = shader;
	}

	// dummy implementation
	function get_color() {
		return new h3d.Vector();
	}

	function set_color(v:h3d.Vector) {
		return v;
	}

	override function emit(ctx:RenderContext) {
		ctx.emitLight(this);
	}

	function getShadowDirection() : h3d.Vector {
		return null;
	}

}