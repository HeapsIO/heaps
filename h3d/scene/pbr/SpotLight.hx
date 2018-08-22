package h3d.scene.pbr;

class SpotLight extends Light {

	var pbr : h3d.shader.pbr.Light.SpotLight;

	public var range : Float;
	public var maxRange(get,set) : Float;
	public var angle : Float;
	public var fallOff : Float;


	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.SpotLight();
		shadows = new h3d.pass.SpotShadowMap(this);
		super(pbr,parent);
		range = 10;
		primitive = h3d.prim.Sphere.defaultUnitSphere();
	}

	function get_maxRange() {
		return cullingDistance;
	}

	function set_maxRange(v:Float) {
		setScale(v);
		return cullingDistance = v;
	}

	override function getShadowDirection() : h3d.Vector {
		return absPos.front();
	}

	override function draw(ctx) {
		primitive.render(ctx.engine);
	}

	override function sync(ctx) {
		super.sync(ctx);

		pbr.lightColor.load(_color);
		var power = power;
		pbr.lightColor.scale3(power * power);
		pbr.lightPos.set(absPos.tx, absPos.ty, absPos.tz);
		pbr.spotDir.load(absPos.front());
		pbr.angle = hxd.Math.cos(hxd.Math.degToRad(angle));
		pbr.fallOff = hxd.Math.cos(hxd.Math.degToRad(hxd.Math.min(angle, fallOff)));
		pbr.range = hxd.Math.min(range, maxRange);
		pbr.invLightRange4 = 1 / (maxRange * maxRange * maxRange * maxRange);
	}

	override function emit(ctx:RenderContext) {
		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";

		super.emit(ctx);
		ctx.emitPass(ctx.pbrLightPass, this);
	}
}