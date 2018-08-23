package h3d.scene.pbr;

class SpotLight extends Light {

	var pbr : h3d.shader.pbr.Light.SpotLight;

	public var range : Float;
	public var maxRange(get,set) : Float;
	public var angle(default,set) : Float;
	public var fallOff : Float;
	public var cookie : h3d.mat.Texture;
	var lightProj : h3d.Camera;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.SpotLight();
		shadows = new h3d.pass.SpotShadowMap(this);
		super(pbr,parent);
		range = 10;
		generatePrim();
		lightProj = new h3d.Camera();
		lightProj.screenRatio = 1.0;
	}

	function get_maxRange() {
		return cullingDistance;
	}

	function set_maxRange(v:Float) {
		scaleX = v;
		lightProj.zFar = v;
		return cullingDistance = v;
	}

	function set_angle(v:Float) {
		scaleY = hxd.Math.tan(hxd.Math.degToRad(v/2.0)) * maxRange;
		scaleZ = scaleY;
		lightProj.fovY = v;
		return angle = v;
	}

	function generatePrim(){
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

		var prim = new h3d.prim.Polygon(points);
		prim.addNormals();
		primitive = prim;
	}

	function generateLightProj(){
		lightProj.pos.set(absPos.tx, absPos.ty, absPos.tz);
		var ldir = absPos.front();
		lightProj.target.set(absPos.tx + ldir.x, absPos.ty + ldir.y, absPos.tz + ldir.z);
		lightProj.update();
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
		pbr.angle = hxd.Math.cos(hxd.Math.degToRad(angle/2.0));
		pbr.fallOff = hxd.Math.cos(hxd.Math.degToRad(hxd.Math.min(angle/2.0, fallOff)));
		pbr.range = hxd.Math.min(range, maxRange);
		pbr.invLightRange4 = 1 / (maxRange * maxRange * maxRange * maxRange);

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
		if( ctx.pbrLightPass == null )
			throw "Rendering a pbr light require a PBR compatible scene renderer";

		super.emit(ctx);
		ctx.emitPass(ctx.pbrLightPass, this);
	}
}