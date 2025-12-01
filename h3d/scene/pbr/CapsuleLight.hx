package h3d.scene.pbr;

class CapsuleLight extends Light {

	var pbr : h3d.shader.pbr.Light.CapsuleLight;
	public var radius : Float = 0.5;
	public var length(default, set) : Float = 1.0;
	public var zNear : Float = 0.02;
	/**
		Alias for uniform scale.
	**/
	public var range(get,set) : Float;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.CapsuleLight();
		shadows = new h3d.pass.CapsuleShadowMap(this, true);
		super(pbr,parent);
		range = 10;
	}

	public override function clone( ?o : h3d.scene.Object ) : h3d.scene.Object {
		var cl = o == null ? new CapsuleLight(null) : cast o;
		super.clone(cl);
		cl.radius = radius;
		cl.length = length;
		cl.range = range;
		return cl;
	}

	function get_range() {
		var minScale = 1.0;
		var p = parent;
		while (p != null) {
			minScale *= hxd.Math.min(p.scaleX, hxd.Math.min(p.scaleY, p.scaleZ));
			p = p.parent;
		}
		return scaleX * minScale;
	}

	function updatePrim() {
		if ( primitive != null )
			primitive.dispose();
		primitive = new h3d.prim.Capsule(1.0, length / scaleX, 16);
	}

	function set_range(v:Float) {
		setScale(v);
		updatePrim();
		return v;
	}

	function set_length(v:Float) {
		length = v;
		updatePrim();
		return length;
	}

	override function draw(ctx:RenderContext) {
		primitive.render(ctx.engine);
	}

	override function sync(ctx) {
		super.sync(ctx);

		pbr.lightColor.load(_color);
		var range = hxd.Math.max(range, 1e-10);
		var power = power * 10; // base scale
		pbr.lightColor.scale(power * power);
		pbr.lightPos.set(absPos.getPosition().x, absPos.getPosition().y, absPos.getPosition().z);
		pbr.radius = radius;
		pbr.halfLength = length * 0.5;
		pbr.occlusionFactor = occlusionFactor;
		pbr.left.load(absPos.front());
		var d = range - radius;
		pbr.invRange4 = 1 / (d * d * d * d);
	}

	var s = new h3d.col.Sphere();
	override function emit(ctx:RenderContext) {
		if( ctx.computingStatic ) {
			super.emit(ctx);
			return;
		}

		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";

		s.x = absPos._41;
		s.y = absPos._42;
		s.z = absPos._43;
		// TODO optimize culling
		s.r = range + length;

		if( !inFrustum(ctx.camera.frustum) )
			return;

		super.emit(ctx);
		ctx.emitPass(ctx.pbrLightPass, this);
	}

	override function inFrustum(frustum : h3d.col.Frustum) {
		return frustum.hasSphere(s);
	}
}