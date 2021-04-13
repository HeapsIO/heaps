package h3d.pass;

class DirShadowMap extends Shadows {

	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	var dshader : h3d.shader.DirShadow;
	var border : Border;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader());

	// Shrink the frustum of the light to the bounds containing all visible objects
	public var autoShrink = true;
	// Clamp the zFar of the frustum of the camera for bounds calculation
	public var maxDist = -1.0;
	// Clamp the zNear of the frustum of the camera for bounds calculation
	public var minDist = -1.0;

	public function new( light : h3d.scene.Light ) {
		super(light);
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

	override function set_enabled(b:Bool) {
		dshader.enable = b && mode != None;
		return enabled = b;
	}

	override function set_size(s) {
		if( border != null && size != s ) {
			border.dispose();
			border = new Border(s, s);
		}
		return super.set_size(s);
	}

	override function dispose() {
		super.dispose();
		if( customDepth && depth != null ) depth.dispose();
		border.dispose();
	}

	public override function getShadowTex() {
		return dshader.shadowMap;
	}

	public dynamic function calcShadowBounds( camera : h3d.Camera ) {
		var bounds = camera.orthoBounds;

		if( autoShrink ) {
			// add visible casters in light camera position
			var mtmp = new h3d.Matrix();
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
		}
		else {
			if( mode == Dynamic )
				bounds.all();
		}

		if( mode == Dynamic ) {

			// Intersect with frustum bounds
			var cameraBounds = new h3d.col.Bounds();
			var zMin = minDist < 0 ? 1.0 : ctx.camera.distanceToDepth(minDist);
			var zMax = maxDist < 0 ? 1.0 : ctx.camera.distanceToDepth(maxDist);
			for( pt in ctx.camera.getFrustumCorners(zMax, zMin) ) {
				pt.transform(camera.mcam);
				cameraBounds.addPos(pt.x, pt.y, pt.z);
			}

			if( autoShrink ) {
				// Keep the zMin from the bounds of visible objects
				// Prevent shadows inside frustum from objects outside frustum being clipped
				cameraBounds.zMin = bounds.zMin;
				bounds.intersection(bounds, cameraBounds);
			}
			else
				bounds.load( cameraBounds );
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
		cameraViewProj = getShadowProj();
	}

	override function syncShader(texture) {
		dshader.shadowMap = texture;
		dshader.shadowMapChannel = format == h3d.mat.Texture.nativeFormat ? PackedFloat : R;
		dshader.shadowBias = bias;
		dshader.shadowPower = power;
		dshader.shadowProj = getShadowProj();

		//ESM
		dshader.USE_ESM = samplingKind == ESM;
		dshader.shadowPower = power;

		// PCF
		dshader.USE_PCF = samplingKind == PCF;
		dshader.shadowRes.set(texture.width,texture.height);
		dshader.pcfScale = pcfScale;
		dshader.pcfQuality = pcfQuality;
	}

	override function saveStaticData() {
		if( mode != Mixed && mode != Static )
			return null;
		if( staticTexture == null )
			throw "Data not computed";
		var bytes = haxe.zip.Compress.run(staticTexture.capturePixels().bytes,9);
		var buffer = new haxe.io.BytesBuffer();
		buffer.addInt32(staticTexture.width);
		buffer.addFloat(lightCamera.pos.x);
		buffer.addFloat(lightCamera.pos.y);
		buffer.addFloat(lightCamera.pos.z);
		buffer.addFloat(lightCamera.target.x);
		buffer.addFloat(lightCamera.target.y);
		buffer.addFloat(lightCamera.target.z);
		buffer.addFloat(lightCamera.orthoBounds.xMin);
		buffer.addFloat(lightCamera.orthoBounds.yMin);
		buffer.addFloat(lightCamera.orthoBounds.zMin);
		buffer.addFloat(lightCamera.orthoBounds.xMax);
		buffer.addFloat(lightCamera.orthoBounds.yMax);
		buffer.addFloat(lightCamera.orthoBounds.zMax);
		buffer.addInt32(bytes.length);
		buffer.add(bytes);
		return buffer.getBytes();
	}

	override function loadStaticData( bytes : haxe.io.Bytes ) {
		if( (mode != Mixed && mode != Static) || bytes == null )
			return false;
		var buffer = new haxe.io.BytesInput(bytes);
		var size = buffer.readInt32();
		if( size != this.size )
			return false;
		lightCamera.pos.x = buffer.readFloat();
		lightCamera.pos.y = buffer.readFloat();
		lightCamera.pos.z = buffer.readFloat();
		lightCamera.target.x = buffer.readFloat();
		lightCamera.target.y = buffer.readFloat();
		lightCamera.target.z = buffer.readFloat();
		lightCamera.orthoBounds.xMin = buffer.readFloat();
		lightCamera.orthoBounds.yMin = buffer.readFloat();
		lightCamera.orthoBounds.zMin = buffer.readFloat();
		lightCamera.orthoBounds.xMax = buffer.readFloat();
		lightCamera.orthoBounds.yMax = buffer.readFloat();
		lightCamera.orthoBounds.zMax = buffer.readFloat();
		lightCamera.update();
		var len = buffer.readInt32();
		var pixels = new hxd.Pixels(size, size, haxe.zip.Uncompress.run(buffer.read(len)), format);
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = new h3d.mat.Texture(size, size, [Target], format);
		staticTexture.uploadPixels(pixels);
		staticTexture.name = "staticTexture";
		staticTexture.preventAutoDispose();
		syncShader(staticTexture);
		return true;
	}

	override function draw( passes, ?sort ) {
		if( !enabled )
			return;

		if( !filterPasses(passes) )
			return;

		cullPasses(passes,function(col) return col.inFrustum(lightCamera.frustum));

		var texture = ctx.textures.allocTarget("dirShadowMap", size, size, false, format);
		if( customDepth && (depth == null || depth.width != size || depth.height != size || depth.isDisposed()) ) {
			if( depth != null ) depth.dispose();
			depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;

		if( mode != Mixed || ctx.computingStatic ) {
			var ct = ctx.camera.target;
			var slight = light == null ? ctx.lightSystem.shadowLight : light;
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
		super.draw(passes, sort);

		if( border != null )
			border.render();

		ctx.engine.popTarget();

		if( mode == Mixed && !ctx.computingStatic ) {
			var merge = ctx.textures.allocTarget("mergedDirShadowMap", size, size, false, format);
			mergePass.shader.texA = texture;
			mergePass.shader.texB = staticTexture;
			ctx.engine.pushTarget(merge);
			mergePass.render();
			ctx.engine.popTarget();
			texture = merge;
		}

		if( blur.radius > 0 && (mode != Mixed || !ctx.computingStatic) )
			blur.apply(ctx, texture);

		syncShader(texture);
	}

	override function computeStatic( passes : h3d.pass.PassList ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
		var texture = dshader.shadowMap;
		var old = staticTexture;
		staticTexture = texture.clone();
		staticTexture.name = "StaticDirShadowMap";
		staticTexture.preventAutoDispose();
		dshader.shadowMap = staticTexture;
		if( old != null )
			old.dispose();
	}
}