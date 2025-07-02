package h3d.scene.pbr;

import h3d.prim.Cube;

class RectangleLight extends Light {

	var pbr : h3d.shader.pbr.Light.RectangleLight;
	public var width(default, set) : Float = 0.5;
	public var height(default, set) : Float = 0.5;
	public var verticalAngle(default, set) : Float = 0.5;
	public var horizontalAngle(default, set) : Float = 0.5;
	public var range(default, set) : Float = 1;
	public var fallOff : Float = 1;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.RectangleLight();
		shadows = new h3d.pass.CapsuleShadowMap(this, true);
		super(pbr,parent);
		range = 10;
	}

	public function set_width(v) {
		width = v;
		updatePrim();
		return width;
	}

	public function set_height(v) {
		height = v;
		updatePrim();
		return height;
	}

	public function set_verticalAngle(v) {
		verticalAngle = v;
		updatePrim();
		return verticalAngle;
	}

	public function set_horizontalAngle(v) {
		horizontalAngle = v;
		updatePrim();
		return horizontalAngle;
	}

	function set_range(v:Float) {
		range = v;
		updatePrim();
		return v;
	}

	public override function clone( ?o : h3d.scene.Object ) : h3d.scene.Object {
		var rec = o == null ? new RectangleLight(null) : cast o;
		super.clone(rec);
		rec.width = width;
		rec.height = height;
		rec.horizontalAngle = horizontalAngle;
		rec.verticalAngle = verticalAngle;
		rec.range = range;
		rec.fallOff = fallOff;
		return rec;
	}

	override function draw(ctx:RenderContext) {
		primitive.render(ctx.engine);
	}

	override function sync(ctx) {
		super.sync(ctx);

		inline function getPoint(signY : Float, signZ : Float) : h3d.col.Point {
			return new h3d.col.Point(0, (width / 2) * signY, (height / 2) * signZ).transformed(getAbsPos());
		}

		pbr.lightColor.load(_color);
		var power = power;
		pbr.lightColor.scale(power * power);
		pbr.lightPos.set(absPos.tx, absPos.ty, absPos.tz);
		pbr.width = width;
		pbr.height = height;
		pbr.p0.load(getPoint(-1, -1));
		pbr.p1.load(getPoint(1, -1));
		pbr.p2.load(getPoint(-1, 1));
		pbr.p3.load(getPoint(1, 1));
		pbr.lightDir.load(absPos.front());
		pbr.verticalAngle = hxd.Math.cos(hxd.Math.degToRad(verticalAngle/2.0));
		pbr.verticalFallOff = hxd.Math.cos(hxd.Math.degToRad(hxd.Math.min(verticalAngle/2.0, fallOff)));
		pbr.horizontalAngle = hxd.Math.cos(hxd.Math.degToRad(horizontalAngle/2.0));
		pbr.horizontalFallOff = hxd.Math.cos(hxd.Math.degToRad(hxd.Math.min(horizontalAngle/2.0, fallOff)));
		pbr.range = range;
		pbr.invLightRange4 = 1 / (range * range * range * range);
		pbr.occlusionFactor = occlusionFactor;
	}

	var s = new h3d.col.Sphere();
	var d = new h3d.Vector();
	override function emit(ctx:RenderContext) {
		if( ctx.computingStatic ) {
			super.emit(ctx);
			return;
		}

		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";

		d.load(absPos.front());
		d.scale(range / 2.0);
		s.x = absPos.tx + d.x;
		s.y = absPos.ty + d.y;
		s.z = absPos.tz + d.z;
		s.r = range / 2.0;

		if( !inFrustum(ctx.camera.frustum) )
			return;

		super.emit(ctx);
		ctx.emitPass(ctx.pbrLightPass, this);
	}

	function updatePrim() {
		if ( primitive != null )
			primitive.dispose();

		var p1 = new h3d.col.Point(0,-width / 2,-height / 2);
		var p2 = new h3d.col.Point(0, width / 2, -height / 2);
		var p3 = new h3d.col.Point(0,-width / 2,height / 2);
		var p4 = new h3d.col.Point(0, width / 2, height / 2);
		var p5 = p1 + new h3d.col.Point(range,-hxd.Math.sin(hxd.Math.degToRad(horizontalAngle / 2)) * range,-hxd.Math.sin(hxd.Math.degToRad(verticalAngle / 2)) * range);
		var p6 =  p2 + new h3d.col.Point(range,hxd.Math.sin(hxd.Math.degToRad(horizontalAngle / 2)) * range,-hxd.Math.sin(hxd.Math.degToRad(verticalAngle / 2)) * range);
		var p7 =  p3 + new h3d.col.Point(range,-hxd.Math.sin(hxd.Math.degToRad(horizontalAngle / 2)) * range,hxd.Math.sin(hxd.Math.degToRad(verticalAngle / 2)) * range);
		var p8 =  p4 + new h3d.col.Point(range,hxd.Math.sin(hxd.Math.degToRad(horizontalAngle / 2)) * range,hxd.Math.sin(hxd.Math.degToRad(verticalAngle / 2)) * range);

		var points = new Array<h3d.col.Point>();

		// Back
		points.push(p1);
		points.push(p3);
		points.push(p4);
		points.push(p4);
		points.push(p2);
		points.push(p1);

		// Front
		points.push(p6);
		points.push(p8);
		points.push(p7);
		points.push(p7);
		points.push(p5);
		points.push(p6);

		// Left
		points.push(p1);
		points.push(p5);
		points.push(p7);
		points.push(p7);
		points.push(p3);
		points.push(p1);

		// Top
		points.push(p3);
		points.push(p7);
		points.push(p8);
		points.push(p8);
		points.push(p4);
		points.push(p3);

		// Right
		points.push(p4);
		points.push(p8);
		points.push(p6);
		points.push(p4);
		points.push(p6);
		points.push(p2);

		// Bot
		points.push(p2);
		points.push(p6);
		points.push(p5);
		points.push(p5);
		points.push(p1);
		points.push(p2);

		primitive = new h3d.prim.Polygon(points);
		return primitive;
	}

	override function inFrustum(frustum : h3d.col.Frustum) {
		return frustum.hasSphere(s);
	}
}