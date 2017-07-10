package h3d.scene;

class DirLight extends Light {

	var dshader : h3d.shader.DirLight;
	public var direction : h3d.Vector;

	public function new(dir, ?parent) {
		dshader = new h3d.shader.DirLight();
		direction = dir;
		super(dshader, parent);
		priority = 100;
	}

	override function get_color() {
		return dshader.color;
	}

	override function get_enableSpecular() {
		return dshader.enableSpecular;
	}

	override function set_enableSpecular(b) {
		return dshader.enableSpecular = b;
	}

	override function emit(ctx) {
		dshader.direction.set(direction.x, direction.y, direction.z);
		dshader.direction.normalize();
		super.emit(ctx);
	}

	#if hxbit
	override function customSerialize(ctx:hxbit.Serializer) {
		super.customSerialize(ctx);
		ctx.addDouble(direction.x);
		ctx.addDouble(direction.y);
		ctx.addDouble(direction.z);
	}
	override function customUnserialize(ctx:hxbit.Serializer) {
		shader = dshader = new h3d.shader.DirLight();
		super.customUnserialize(ctx);
		direction = new h3d.Vector(ctx.getDouble(), ctx.getDouble(), ctx.getDouble());
	}
	#end

}