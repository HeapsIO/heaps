package h3d.pass;

class DirShadowMap extends Shadows {

	var lightCamera : h3d.Camera;
	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	var dshader : h3d.shader.DirShadow;
	var border : Border;
	var staticTexture : h3d.mat.Texture;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader());
	public var power = 30.0;
	public var bias = 0.01;

	public function new() {
		super();

		lightCamera = new h3d.Camera();
		lightCamera.orthoBounds = new h3d.col.Bounds();
		shader = dshader = new h3d.shader.DirShadow();
		border = new Border(size, size);
		customDepth = h3d.Engine.getCurrent().driver.hasFeature(AllocDepthBuffer);
		if( !customDepth ) depth = h3d.mat.DepthBuffer.getDefault();
	}

	override function set_mode(m:Shadows.RenderMode) {
		dshader.enable = m != None;
		return mode = m;
	}

	override function set_size(s) {
		if( border != null && size != s ) {
			border.dispose();
			border = new Border(s, s);
		}
		return size = s;
	}

	override function dispose() {
		super.dispose();
		if( customDepth && depth != null ) depth.dispose();
		if( staticTexture != null ) staticTexture.dispose();
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

		if( mode == Dynamic ) {
			// intersect with frustum bounds
			var cameraBounds = new h3d.col.Bounds();
			for( pt in ctx.camera.getFrustumCorners() ) {
				pt.transform(camera.mcam);
				cameraBounds.addPos(pt.x, pt.y, pt.z);
			}
			bounds.intersection(bounds, cameraBounds);
		}

		bounds.scaleCenter(1.01);
	}

	override function setGlobals() {
		super.setGlobals();
		if( mode != Mixed || ctx.computingStatic ) {
			lightCamera.orthoBounds.empty();
			calcShadowBounds(lightCamera);
			lightCamera.update();
		}
		cameraViewProj = lightCamera.m;
	}

	public function getShadowProj() {
		return lightCamera.m;
	}

	override function draw( passes ) {

		if( !ctx.computingStatic )
			switch( mode ) {
			case None:
				return passes;
			case Dynamic:
				// nothing
			case Static, Mixed:
				if( staticTexture == null ) throw "Static texture is missing, call s3d.computeStatic() first";
				if( mode == Static ) return passes;
			}

		passes = filterPasses(passes);

		var texture = ctx.textures.allocTarget("shadowMap", size, size, false, format);
		if( customDepth && (depth == null || depth.width != size || depth.height != size || depth.isDisposed()) ) {
			if( depth != null ) depth.dispose();
			depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;

		if( mode != Mixed || ctx.computingStatic ) {
			var ct = ctx.camera.target;
			var slight = ctx.lightSystem.shadowLight;
			var ldir = slight == null ? null : @:privateAccess slight.getShadowDirection();
			if( ldir == null )
				lightCamera.target.set(0, 0, -1);
			else {
				lightCamera.target.set(ldir.x, ldir.y, ldir.z);
				lightCamera.target.normalize();
			}
			lightCamera.target.x += ct.x;
			lightCamera.target.y += ct.y;
			lightCamera.target.z += ct.z;
			lightCamera.pos.load(ct);
			lightCamera.update();
		}

		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0xFFFFFF, 1);
		passes = super.draw(passes);
		if( border != null ) border.render();
		ctx.engine.popTarget();

		if( mode == Mixed && !ctx.computingStatic ) {
			var merge = ctx.textures.allocTarget("shadowMap", size, size, false, format);
			mergePass.shader.texA = texture;
			mergePass.shader.texB = staticTexture;
			ctx.engine.pushTarget(merge);
			mergePass.render();
			ctx.engine.popTarget();
			texture = merge;
		}

		if( blur.radius > 0 && (mode != Mixed || !ctx.computingStatic) )
			blur.apply(ctx, texture);

		dshader.shadowMap = texture;
		dshader.shadowMapChannel = format == h3d.mat.Texture.nativeFormat ? PackedFloat : R;
		dshader.shadowBias = bias;
		dshader.shadowPower = power;
		dshader.shadowProj = getShadowProj();
		return passes;
	}

	override function computeStatic( passes : h3d.pass.Object ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
		var texture = dshader.shadowMap;
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = texture.clone();
		dshader.shadowMap = staticTexture;
	}


}