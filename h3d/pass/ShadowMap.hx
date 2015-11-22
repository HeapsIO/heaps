package h3d.pass;

class ShadowMap extends Default {

	var lightCamera : h3d.Camera;
	var shadowMapId : Int;
	var shadowProjId : Int;
	var shadowColorId : Int;
	var shadowPowerId : Int;
	var shadowBiasId : Int;
	public var border : Border;
	public var size(default,set) : Int;
	public var color : h3d.Vector;
	public var power = 10.0;
	public var bias = 0.01;
	public var blur : Blur;

	public function new(size) {
		super();
		this.size = size;
		priority = 9;
		lightCamera = new h3d.Camera();
		lightCamera.orthoBounds = new h3d.col.Bounds();
		shadowMapId = hxsl.Globals.allocID("shadow.map");
		shadowProjId = hxsl.Globals.allocID("shadow.proj");
		shadowColorId = hxsl.Globals.allocID("shadow.color");
		shadowPowerId = hxsl.Globals.allocID("shadow.power");
		shadowBiasId = hxsl.Globals.allocID("shadow.bias");
		color = new h3d.Vector();
		blur = new Blur(2, 3);
		border = new Border(size, size);
	}

	function set_size(s) {
		if( border != null && size != s ) {
			border.dispose();
			border = new Border(s, s);
		}
		return size = s;
	}

	override function dispose() {
		super.dispose();
		blur.dispose();
		if( border != null ) border.dispose();
	}

	public dynamic function calcShadowBounds( camera : h3d.Camera ) {
		var bounds = camera.orthoBounds;
		bounds.xMin = -10;
		bounds.yMin = -10;
		bounds.zMin = -10;
		bounds.xMax = 10;
		bounds.yMax = 10;
		bounds.zMax = 10;
	}

	override function getOutputs() {
		return ["output.position", "output.depth"];
	}

	override function setGlobals() {
		super.setGlobals();
		lightCamera.orthoBounds.empty();
		calcShadowBounds(lightCamera);
		lightCamera.update();
		cameraViewProj = lightCamera.m;
	}

	override function draw( passes ) {
		var texture = tcache.allocTarget("shadowMap", ctx, size, size);
		var ct = ctx.camera.target;
		var slight = ctx.lightSystem.shadowLight;
		if( slight == null )
			lightCamera.target.set(0, 0, -1);
		else {
			lightCamera.target.set(slight.direction.x, slight.direction.y, slight.direction.z);
			lightCamera.target.normalize();
		}
		lightCamera.target.x += ct.x;
		lightCamera.target.y += ct.y;
		lightCamera.target.z += ct.z;
		lightCamera.pos.load(ct);
		lightCamera.update();

		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0xFFFFFF, 1, tcache.fullClearRequired ? 0 : null);
		passes = super.draw(passes);
		if( border != null ) border.render();
		ctx.engine.popTarget();

		if( blur.quality > 0 && blur.passes > 0 )
			blur.apply(texture, tcache.allocTarget("tmpBlur", ctx, size, size, false), true);

		ctx.setGlobalID(shadowMapId, texture);
		ctx.setGlobalID(shadowProjId, lightCamera.m);
		ctx.setGlobalID(shadowColorId, color);
		ctx.setGlobalID(shadowPowerId, power);
		ctx.setGlobalID(shadowBiasId, bias);
		return passes;
	}


}