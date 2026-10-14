package h3d.scene.pbr;

class SpotLight extends Light {

	var pbr : h3d.shader.pbr.Light.SpotLight;

	public var range(get,set) : Float;
	public var angle(default,set) : Float;
	public var fallOff : Float = 0.;
	public var cookie : h3d.mat.Texture;
	var lightProj : h3d.Camera;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.SpotLight();
		shadows = new h3d.pass.SpotShadowMap(this);
		primitive = spotLightPrim();
		super(pbr,parent);
		lightProj = new h3d.Camera();
		lightProj.screenRatio = 1.0;
		range = 10;
		angle = 45;
	}

	public override function clone( ?o : h3d.scene.Object ) : h3d.scene.Object {
		var sl = o == null ? new SpotLight(null) : cast o;
		super.clone(sl);
		sl.range = range;
		sl.angle = angle;
		sl.fallOff = fallOff;
		sl.cookie = cookie;
		sl.lightProj.load(lightProj);
		return sl;
	}

	function get_range() {
		return scaleX * getParentScale();
	}

	function set_range(v:Float) {
		scaleX = v;
		lightProj.zFar = v;
		updateConeScale();
		return v;
	}

	function set_angle(v:Float) {
		angle = v;
		updateConeScale();
		lightProj.fovY = v;
		return v;
	}

	function updateConeScale() {
		scaleY = hxd.Math.tan(hxd.Math.degToRad(angle/2.0)) * scaleX;
		scaleZ = scaleY;
	}

	public static function spotLightPrim() : h3d.prim.Polygon {
		var engine = h3d.Engine.getCurrent();
		var p : h3d.prim.Polygon = @:privateAccess engine.resCache.get(SpotLight);
		if( p != null )
			return p;

		var points = new Array<h3d.col.Point>();
		// Left
		points.push(new h3d.col.Point(0,0,0));
		points.push(new h3d.col.Point(1,-1,-1));
		points.push(new h3d.col.Point(1,-1,1));
		// Right
		points.push(new h3d.col.Point(0,0,0));
		points.push(new h3d.col.Point(1,1,1));
		points.push(new h3d.col.Point(1,1,-1));
		// Up
		points.push(new h3d.col.Point(0,0,0));
		points.push(new h3d.col.Point(1,-1,1));
		points.push(new h3d.col.Point(1,1,1));
		// Down
		points.push(new h3d.col.Point(0,0,0));
		points.push(new h3d.col.Point(1,1,-1));
		points.push(new h3d.col.Point(1,-1,-1));
		// Front
		points.push(new h3d.col.Point(1,-1,-1));
		points.push(new h3d.col.Point(1,1,-1));
		points.push(new h3d.col.Point(1,1,1));
		points.push(new h3d.col.Point(1,1,1));
		points.push(new h3d.col.Point(1,-1,1));
		points.push(new h3d.col.Point(1,-1,-1));
		p = new h3d.prim.Polygon(points);
		p.addNormals();

		@:privateAccess engine.resCache.set(SpotLight, p);
		return p;
	}

	function generateLightProj(){
		lightProj.pos.set(absPos.tx, absPos.ty, absPos.tz);
		var ldir = absPos.front();
		lightProj.target.set(absPos.tx + ldir.x, absPos.ty + ldir.y, absPos.tz + ldir.z);
		lightProj.update();
	}

	override function getShadowDirection( ?v: h3d.Vector ) : h3d.Vector {
		if( v == null ) v = new h3d.Vector();
		v.load(absPos.front());
		return v;
	}

	override function draw(ctx:RenderContext) {
		primitive.render(ctx.engine);
	}

	override function sync(ctx) {
		super.sync(ctx);

		pbr.lightColor.load(_color);
		pbr.lightColor.scale(getIntensity());
		pbr.lightPos.set(absPos.tx, absPos.ty, absPos.tz);
		pbr.spotDir.load(absPos.front());
		pbr.angle = hxd.Math.cos(hxd.Math.degToRad(angle/2.0));
		pbr.fallOff = hxd.Math.cos(hxd.Math.degToRad(hxd.Math.min(angle/2.0, fallOff)));
		pbr.range = range;
		pbr.invLightRange4 = 1 / (range * range * range * range);
		pbr.occlusionFactor = occlusionFactor;

		if(cookie != null){
			pbr.useCookie = true;
			pbr.cookieTex = cookie;
			generateLightProj();
			pbr.lightProj.load(lightProj.m);
		}else{
			pbr.useCookie = false;
		}
	}

	override function emit(ctx:RenderContext) {
		if( ctx.computingStatic ) {
			super.emit(ctx);
			return;
		}

		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";

		if( !inFrustum(ctx.camera.frustum) )
			return;

		super.emit(ctx);
		ctx.emitPass(ctx.pbrLightPass, this);
	}

	@:access(h3d.col.Plane)
	override function inFrustum(frustum : h3d.col.Frustum) {
		var r = range;
		var cosA = hxd.Math.cos(hxd.Math.degToRad(angle / 2.0));
		var sinA = Math.sqrt(hxd.Math.max(0, 1 - cosA * cosA));
		var d = absPos.front();
		var pos = absPos.getPosition();
		inline function outside( p : h3d.col.Plane ) {
			var k = p.nx * d.x + p.ny * d.y + p.nz * d.z;
			var h = (k >= cosA || cosA <= 0) ? 1.0 : hxd.Math.max(0, k * cosA + Math.sqrt(hxd.Math.max(0, 1 - k * k)) * sinA);
			return p.distance(pos) + r * h < 0;
		}
		if( outside(frustum.pleft) || outside(frustum.pright) || outside(frustum.ptop) || outside(frustum.pbottom) )
			return false;
		if( frustum.checkNearFar && (outside(frustum.pnear) || outside(frustum.pfar)) )
			return false;
		return true;
	}
}