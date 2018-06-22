package h3d.scene.pbr;

class PointLight extends Light {

	var pbr : h3d.shader.pbr.Light.PointLight;
	public var size : Float;
	/**
		Alias for uniform scale.
	**/
	public var range(get,set) : Float;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.PointLight();
		super(pbr,parent);
		range = 10;
		primitive = h3d.prim.Sphere.defaultUnitSphere();
	}

	function get_range() {
		return cullingDistance;
	}

	function set_range(v:Float) {
		setScale(v);
		return cullingDistance = v;
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