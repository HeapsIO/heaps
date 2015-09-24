package h3d.scene;

class Light extends Object {

	var shader : hxsl.Shader;
	var objectDistance : Float; // used internaly
	var cullingDistance : Float = 1e10;
	@:noCompletion public var next : Light;

	public var color(get, never) : h3d.Vector;
	public var priority : Int = 0;
	public var enableSpecular(get, set) : Bool;

	function new(shader,?parent) {
		super(parent);
		this.shader = shader;
	}

	// dummy implementation
	function get_color() {
		return new h3d.Vector();
	}

	function get_enableSpecular() {
		return false;
	}

	function set_enableSpecular(b) {
		if( b ) throw "Not implemented for this light";
		return false;
	}

	override function emit(ctx:RenderContext) {
		ctx.emitLight(this);
	}

}