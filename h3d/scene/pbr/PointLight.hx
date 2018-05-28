package h3d.scene.pbr;

class PointLight extends Light {

	var _color : h3d.Vector;
	var pbr : h3d.shader.pbr.Light.PointLight;
	@:s public var power : Float = 1.;
	public var size : Float;
	/**
		Alias for uniform scale.
	**/
	public var range(get,set) : Float;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.PointLight();
		super(pbr,parent);
		range = 10;
		_color = new h3d.Vector(1,1,1,1);
		primitive = h3d.prim.Sphere.defaultUnitSphere();
	}

	override function get_color() {
		return _color;
	}

	override function set_color(v:h3d.Vector) {
		return _color = v;
	}

	function get_range() {
		return cullingDistance;
	}

	function set_range(v:Float) {
		setScale(v);
		return cullingDistance = v;
	}

	override function get_isSun() {
		return pbr.isSun;
	}

	override function set_isSun(b:Bool) {
		return pbr.isSun = b;
	}

	override function draw(ctx) {
		primitive.render(ctx.engine);
	}

	override function emit(ctx:RenderContext) {
		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";
		ctx.emitPass(ctx.pbrLightPass, this);
		pbr.lightColor.load(_color);
		var range = hxd.Math.max(range, 1e-10);
		var size = hxd.Math.min(size, range);
		var power = power * 10; // base scale
		pbr.lightColor.scale3(power * power);
		pbr.lightPos.set(absPos.tx, absPos.ty, absPos.tz);
		pbr.invLightRange4 = 1 / (range * range * range * range);
		pbr.pointSize = size;
	}

}