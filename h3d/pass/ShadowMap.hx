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
	public var lightDirection : h3d.Vector;
	public var color : h3d.Vector;
	public var power = 10.0;
	public var bias = 0.01;
	public var blur : Blur;

	public function new(size) {
		super();
		this.size = size;
		priority = 9;
		lightSystem = null;
		lightDirection = new h3d.Vector(0, 0, -1);
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
		if( border != null ) {
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

	public dynamic function getSceneBounds( bounds : h3d.col.Bounds ) {
		bounds.xMin = -10;
		bounds.yMin = -10;
		bounds.zMin = -10;
		bounds.xMax = 10;
		bounds.yMax = 10;
		bounds.zMax = 10;
	}

	override function getOutputs() {
		return ["output.position", "output.distance"];
	}

	override function setGlobals() {
		super.setGlobals();
		lightCamera.orthoBounds.empty();
		getSceneBounds(lightCamera.orthoBounds);
		lightCamera.update();
		cameraViewProj = lightCamera.m;
	}

	override function draw( name : String, passes ) {
		var texture = getTargetTexture("shadowMap", size, size);
		var ct = ctx.camera.target;
		lightCamera.target.set(lightDirection.x, lightDirection.y, lightDirection.z);
		lightCamera.target.normalize();
		lightCamera.target.x += ct.x;
		lightCamera.target.y += ct.y;
		lightCamera.target.z += ct.z;
		lightCamera.pos.load(ct);
		ctx.engine.setTarget(texture);
		ctx.engine.clear(0xFFFFFF, 1, fullClearRequired ? 0 : null);
		passes = super.draw(name, passes);
		if( border != null ) border.render();
		ctx.engine.setTarget(null);

		if( blur.quality > 0 )
			blur.apply(texture, getTargetTexture("tmpBlur", size, size, false), true);

		ctx.sharedGlobals.set(shadowMapId, texture);
		ctx.sharedGlobals.set(shadowProjId, lightCamera.m);
		ctx.sharedGlobals.set(shadowColorId, color);
		ctx.sharedGlobals.set(shadowPowerId, power);
		ctx.sharedGlobals.set(shadowBiasId, bias);
		return passes;
	}


}