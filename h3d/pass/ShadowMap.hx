package h3d.pass;

class ShadowMap extends Default {

	var lightCamera : h3d.Camera;
	var shadowMapId : Int;
	var shadowProjId : Int;
	var shadowColorId : Int;
	var shadowPowerId : Int;
	var shadowBiasId : Int;
	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	@ignore public var border : Border;
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
		customDepth = h3d.Engine.getCurrent().driver.hasFeature(AllocDepthBuffer);
		if( !customDepth ) depth = h3d.mat.DepthBuffer.getDefault();
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
		var mtmp = new h3d.Matrix();


		// add visible casters in light camera position
		ctx.scene.iterVisibleMeshes(function(m) {
			if( m.primitive == null || !m.material.castShadows ) return;
			var b = m.primitive.getBounds();
			if( b.xMin > b.xMax ) return;
			mtmp.multiply3x4(m.getAbsPos(), camera.mcam);

			var p = new h3d.col.Point(b.xMin, b.yMin, b.zMin);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMin, b.yMin, b.zMax);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMin, b.yMax, b.zMin);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMin, b.yMax, b.zMax);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMax, b.yMin, b.zMin);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMax, b.yMin, b.zMax);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMax, b.yMax, b.zMin);
			p.transform(mtmp);
			bounds.addPoint(p);

			var p = new h3d.col.Point(b.xMax, b.yMax, b.zMax);
			p.transform(mtmp);
			bounds.addPoint(p);

		});

		// intersect with frustum bounds
		var cameraBounds = new h3d.col.Bounds();
		for( pt in ctx.camera.getFrustumCorners() ) {
			pt.transform(camera.mcam);
			cameraBounds.addPos(pt.x, pt.y, pt.z);
		}
		bounds.intersection(bounds, cameraBounds);
		bounds.scaleCenter(1.01);
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
		var texture = tcache.allocTarget("shadowMap", ctx, size, size, false);
		if( customDepth && (depth == null || depth.width != size || depth.height != size || depth.isDisposed()) ) {
			if( depth != null ) depth.dispose();
			depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;
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
		ctx.engine.clear(0xFFFFFF, 1);
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