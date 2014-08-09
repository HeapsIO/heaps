package h3d.scene;

class Light extends Object {

	var shader : hxsl.Shader;
	var objectDistance : Float; // used internaly
	@:noCompletion public var next : Light;

	public var color(get, never) : h3d.Vector;
	public var priority : Int = 0;

	function new(shader,?parent) {
		super(parent);
		this.shader = shader;
	}

	// dummy implementation
	function get_color() {
		return new h3d.Vector();
	}

	override function emit(ctx:RenderContext) {
		ctx.emitLight(this);
	}

}