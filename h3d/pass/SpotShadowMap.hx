package h3d.pass;

class SpotShadowMap extends Shadows {

	var depth : h3d.mat.Texture;
	var sshader : h3d.shader.SpotShadow;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader());

	public function new( light : h3d.scene.Light ) {
		format = R32F;
		super(light);
		lightCamera = new h3d.Camera();
		lightCamera.screenRatio = 1.0;
		lightCamera.zNear = 0.01;
		shader = sshader = new h3d.shader.SpotShadow();
	}

	override function set_mode(m:Shadows.RenderMode) {
		sshader.enable = m != None;
		return mode = m;
	}

	override function set_enabled(b:Bool) {
		sshader.enable = b && mode != None;
		return enabled = b;
	}

	override function isUsingWorldDist(){
		return false;
	}

	override function dispose() {
		super.dispose();
		if( depth != null ) depth.dispose();
	}

	public override function getShadowTex() {
		return sshader.shadowMap;
	}

	override function syncShader(texture) {
		sshader.shadowMap = texture;
		sshader.shadowMapChannel = format == h3d.mat.Texture.nativeFormat ? PackedFloat : R;
		sshader.shadowBias = bias;
		sshader.shadowProj = getShadowProj();

		//ESM
		sshader.USE_ESM = samplingKind == ESM;
		sshader.shadowPower = power;

		// PCF
		sshader.USE_PCF = samplingKind == PCF;
		sshader.shadowRes.set(texture.width,texture.height);
		sshader.pcfScale = pcfScale;
		sshader.pcfQuality = pcfQuality;
	}

	override function saveStaticData() {
		if( mode != Mixed && mode != Static )
			return null;
		if( staticTexture == null )
			throw "Data not computed";
		var bytes = haxe.zip.Compress.run(staticTexture.capturePixels().bytes,9);
		var buffer = new haxe.io.BytesBuffer();
		buffer.addInt32(staticTexture.width);
		buffer.addInt32(bytes.length);
		buffer.add(bytes);
		return buffer.getBytes();
	}

	function createStaticTexture() : h3d.mat.Texture {
		if( staticTexture != null && staticTexture.width == size && staticTexture.width == size && staticTexture.format == format )
			return staticTexture;
		if( staticTexture != null )
			staticTexture.dispose();
		staticTexture = new h3d.mat.Texture(size, size, [Target], format);
		staticTexture.name = "staticTexture";
		staticTexture.preventAutoDispose();
		staticTexture.realloc = function () {
			if( pixelsForRealloc != null ) {
				staticTexture.uploadPixels(pixelsForRealloc);
			}
		}
		return staticTexture;
	}

	var pixelsForRealloc : hxd.Pixels = null;
	override function loadStaticData( bytes : haxe.io.Bytes ) {
		if( (mode != Mixed && mode != Static) || bytes == null )
			return false;
		var buffer = new haxe.io.BytesInput(bytes);
		var size = buffer.readInt32();
		if( size != this.size )
			return false;

		createStaticTexture();

		var len = buffer.readInt32();
		var pixels = new hxd.Pixels(size, size, haxe.zip.Uncompress.run(buffer.read(len)), format);
		pixelsForRealloc = pixels;

		syncShader(staticTexture);
		return true;
	}

	override function draw( passes : h3d.pass.PassList, ?sort ) {
		if( !enabled )
			return;

		if( !filterPasses(passes) )
			return;

		updateCamera();
		cullPasses(passes, function(col) return col.inFrustum(lightCamera.frustum));

		var prevFar = @:privateAccess ctx.cameraFar;
		var prevPos = @:privateAccess ctx.cameraPos;
		var prevViewProj = @:privateAccess ctx.cameraViewProj;
		@:privateAccess ctx.cameraViewProj = getShadowProj();
		@:privateAccess ctx.cameraFar = lightCamera.zFar;
		@:privateAccess ctx.cameraPos = lightCamera.pos;

		var computingStatic = ctx.computingStatic || updateStatic;

		var texture = computingStatic ? createStaticTexture() : ctx.textures.allocTarget("spotShadowMap", size, size, false, format);
		if( depth == null || depth.width != texture.width || depth.height != texture.height || depth.isDisposed() ) {
			if( depth != null ) depth.dispose();
			depth = new h3d.mat.Texture(texture.width, texture.height, Depth24Stencil8);
		}
		texture.depthBuffer = depth;

		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0xFFFFFF, 1);
		super.draw(passes, sort);
		ctx.engine.popTarget();

		if( blur.radius > 0 )
			blur.apply(ctx, texture);

		if( mode == Mixed && !computingStatic && staticTexture != null && !staticTexture.isDisposed() ) {
			if ( staticTexture.width != texture.width )
				throw "Static shadow map doesnt match dynamic shadow map";
			var merge = ctx.textures.allocTarget("mergedSpotShadowMap", size, size, false, format);
			mergePass.shader.texA = texture;
			mergePass.shader.texB = staticTexture;
			ctx.engine.pushTarget(merge);
			mergePass.render();
			ctx.engine.popTarget();
			texture = merge;
		}
		@:privateAccess ctx.cameraFar = prevFar;
		@:privateAccess ctx.cameraPos = prevPos;
		@:privateAccess ctx.cameraViewProj = prevViewProj;

		syncShader(texture);

		updateStatic = false;
	}

	function updateCamera(){
		var absPos = light.getAbsPos();
		var spotLight = cast(light, h3d.scene.pbr.SpotLight);
		var ldir = absPos.front();
		lightCamera.pos.set(absPos.tx, absPos.ty, absPos.tz);
		lightCamera.target.set(absPos.tx + ldir.x, absPos.ty + ldir.y, absPos.tz + ldir.z);
		lightCamera.fovY = spotLight.angle;
		lightCamera.zNear = spotLight.range * 0.05; // first 5% outside of range
		lightCamera.zFar = spotLight.range;
		lightCamera.update();
	}

	override function computeStatic( passes : h3d.pass.PassList ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
	}
}