package h3d.pass;

class ShadowMap extends Base {

	var size : Int;
	var texture : h3d.mat.Texture;
	var lightCamera : h3d.Camera;
	var shadowMapId : Int;
	var shadowProjId : Int;
	public var lightDirection : h3d.Vector;

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
	
	override function draw( ctx : h3d.scene.RenderContext, passes) {
		if( texture == null || texture.isDisposed() ) {
			if( texture != null ) texture.dispose();
			texture = h3d.mat.Texture.alloc(size, size, true);
		}
		var ct = ctx.camera.target;
		lightCamera.target.set(ct.x, ct.y, ct.z);
		lightCamera.pos.set(ct.x - lightDirection.x, ct.y - lightDirection.y, ct.z - lightDirection.z);
		ctx.engine.setTarget(texture, true);
		super.draw(ctx, passes);
		ctx.engine.setTarget(null);
		ctx.sharedGlobals.set(shadowMapId, texture);
		ctx.sharedGlobals.set(shadowProjId, lightCamera.m);
	}

	
}