package h3d.scene;

class Light extends Object {

	var shader : hxsl.Shader;
	var objectDistance : Float; // used internaly
	@:noCompletion public var next : Light; // used internaly (public to allow sorting)

	@:s var cullingDistance : Float = -1;
	@:s public var priority : Int = 0;
	public var color(get, set) : h3d.Vector;
	public var enableSpecular(get, set) : Bool;

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

	function getShadowDirection() : h3d.Vector {
		return null;
	}

	#if (hxbit && !macro && heaps_enable_serialize)
	override function customSerialize(ctx:hxbit.Serializer) {
		super.customSerialize(ctx);
		ctx.addDouble(color.x);
		ctx.addDouble(color.y);
		ctx.addDouble(color.z);
		ctx.addDouble(color.w);
		ctx.addBool(enableSpecular);
	}
	override function customUnserialize(ctx:hxbit.Serializer) {
		super.customUnserialize(ctx);
		color.set(ctx.getDouble(), ctx.getDouble(), ctx.getDouble(), ctx.getDouble());
		enableSpecular = ctx.getBool();
	}
	#end


}