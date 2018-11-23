package h3d.pass;

class SpotShadowMap extends Shadows {

	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	var sshader : h3d.shader.SpotShadow;
	var border : Border;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader());

	public function new( light : h3d.scene.Light ) {
		super(light);
		lightCamera = new h3d.Camera();
		lightCamera.screenRatio = 1.0;
		lightCamera.zNear = 3.0;
		shader = sshader = new h3d.shader.SpotShadow();
		border = new Border(size, size);
		customDepth = h3d.Engine.getCurrent().driver.hasFeature(AllocDepthBuffer);
		if( !customDepth ) depth = h3d.mat.DepthBuffer.getDefault();
	}

	override function set_mode(m:Shadows.RenderMode) {
		sshader.enable = m != None;
		return mode = m;
	}

	override function set_size(s) {
		if( border != null && size != s ) {
			border.dispose();
			border = new Border(s, s);
		}
		return super.set_size(s);
	}

	override function isUsingWorldDist(){
		return false;
	}

	override function dispose() {
		super.dispose();
		if( customDepth && depth != null ) depth.dispose();
	}

	public override function getShadowTex() {
		return sshader.shadowMap;
	}

	override function setGlobals() {
		super.setGlobals();
		cameraViewProj = getShadowProj();
	}

	function syncShader(texture) {
		sshader.shadowMap = texture;
		sshader.shadowMapChannel = format == h3d.mat.Texture.nativeFormat ? PackedFloat : R;
		sshader.shadowBias = bias;
		sshader.shadowPower = power;
		sshader.shadowProj = getShadowProj();
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

	override function loadStaticData( bytes : haxe.io.Bytes ) {
		if( (mode != Mixed && mode != Static) || bytes == null )
			return false;
		var buffer = new haxe.io.BytesInput(bytes);
		var size = buffer.readInt32();
		if( size != this.size )
			return false;

		var len = buffer.readInt32();
		var pixels = new hxd.Pixels(size, size, haxe.zip.Uncompress.run(buffer.read(len)), format);
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = new h3d.mat.Texture(size, size, [Target], format);
		staticTexture.uploadPixels(pixels);
		syncShader(staticTexture);
		return true;
	}

	override function draw( passes ) {

		if( !ctx.computingStatic )
			switch( mode ) {
			case None:
				return passes;
			case Dynamic:
				// nothing
			case Mixed:
				if( staticTexture == null || staticTexture.isDisposed() )
					staticTexture = h3d.mat.Texture.fromColor(0xFFFFFF);
			case Static:
				if( staticTexture == null || staticTexture.isDisposed() )
					staticTexture = h3d.mat.Texture.fromColor(0xFFFFFF);
				updateCamera();
				syncShader(staticTexture);
				return passes;
			}

		passes = filterPasses(passes);
		updateCamera();

		var texture = ctx.textures.allocTarget("shadowMap", size, size, false, format);
		if( customDepth && (depth == null || depth.width != size || depth.height != size || depth.isDisposed()) ) {
			if( depth != null ) depth.dispose();
			depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;

		ctx.engine.pushTarget(texture);
		ctx.engine.clear(0xFFFFFF, 1);
		passes = super.draw(passes);
		if( border != null ) border.render();
		ctx.engine.popTarget();

		if( blur.radius > 0 )
			blur.apply(ctx, texture);

		var validBakedTexture = (staticTexture != null && staticTexture.width == texture.width);
		if( mode == Mixed && !ctx.computingStatic && validBakedTexture ) {
			var merge = ctx.textures.allocTarget("shadowMap", size, size, false, format);
			mergePass.shader.texA = texture;
			mergePass.shader.texB = staticTexture;
			ctx.engine.pushTarget(merge);
			mergePass.render();
			ctx.engine.popTarget();
			texture = merge;
		}

		syncShader(texture);
		return passes;
	}

	function updateCamera(){
		var absPos = light.getAbsPos();
		var spotLight = cast(light, h3d.scene.pbr.SpotLight);
		var ldir = absPos.front();
		lightCamera.pos.set(absPos.tx, absPos.ty, absPos.tz);
		lightCamera.target.set(absPos.tx + ldir.x, absPos.ty + ldir.y, absPos.tz + ldir.z);
		lightCamera.fovY = spotLight.angle;
		lightCamera.zFar = spotLight.maxRange;
		lightCamera.update();
	}

	override function computeStatic( passes : h3d.pass.Object ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
		var texture = sshader.shadowMap;
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = texture.clone();
		sshader.shadowMap = staticTexture;
	}
}