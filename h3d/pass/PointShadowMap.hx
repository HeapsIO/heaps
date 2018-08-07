package h3d.pass;

class PointShadowMap extends Shadows {

	var lightCamera : h3d.Camera;
	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	var pshader : h3d.shader.PointShadow;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader.CubeMinMaxShader());

	var cubeDir = [ h3d.Matrix.L([0,0,-1,0, 0,1,0,0, -1,-1,1,0]),
					h3d.Matrix.L([0,0,1,0, 0,1,0,0, 1,-1,-1,0]),
	 				h3d.Matrix.L([-1,0,0,0, 0,0,1,0, 1,-1,-1,0]),
	 				h3d.Matrix.L([-1,0,0,0, 0,0,-1,0, 1,1,1,0]),
				 	h3d.Matrix.L([-1,0,0,0, 0,1,0,0, 1,-1,1,0]),
				 	h3d.Matrix.L([1,0,0,0, 0,1,0,0, -1,-1,-1,0]) ];

	public function new( light : h3d.scene.Light, useWorldDist : Bool ) {
		super(light);
		lightCamera = new h3d.Camera();
		lightCamera.screenRatio = 1.0;
		lightCamera.fovY = 90;
		shader = pshader = new h3d.shader.PointShadow();
		customDepth = h3d.Engine.getCurrent().driver.hasFeature(AllocDepthBuffer);
		if( !customDepth ) depth = h3d.mat.DepthBuffer.getDefault();
	}

	override function set_mode(m:Shadows.RenderMode) {
		pshader.enable = m != None;
		return mode = m;
	}

	override function set_size(s) {
		return super.set_size(s);
	}

	override function dispose() {
		super.dispose();
		if( customDepth && depth != null ) depth.dispose();
	}

	override function isUsingWorldDist(){
		return true;
	}

	function getShadowProj() {
		return lightCamera.m;
	}

	public dynamic function calcShadowBounds( camera : h3d.Camera ) {
		var pt : Array<h3d.Vector> = camera.getFrustumCorners();
		for( p in pt) {
			camera.orthoBounds.addPos(p.x, p.y, p.z);
		}
	}

	override function setGlobals() {
		super.setGlobals();
		cameraViewProj = getShadowProj();
		cameraFar = lightCamera.zFar;
		cameraPos = lightCamera.pos;
	}

	function syncShader(texture) {
		pshader.shadowMap = texture;
		pshader.shadowBias = bias;
		pshader.shadowPower = power;
		pshader.lightPos = lightCamera.pos;
		pshader.zFar = lightCamera.zFar;
	}

	override function saveStaticData() {
		if( mode != Mixed && mode != Static )
			return null;
		if( staticTexture == null )
			throw "Data not computed";

		var buffer = new haxe.io.BytesBuffer();
		buffer.addInt32(staticTexture.width);
		buffer.addFloat(lightCamera.pos.x);
		buffer.addFloat(lightCamera.pos.y);
		buffer.addFloat(lightCamera.pos.z);

		for(i in 0 ... 6){
			var bytes = haxe.zip.Compress.run(staticTexture.capturePixels(i).bytes,9);
			buffer.addInt32(bytes.length);
			buffer.add(bytes);
		}

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
		lightCamera.update();

		if( staticTexture != null ) staticTexture.dispose();
			staticTexture = new h3d.mat.Texture(size, size, [Target, Cube], format);

		for(i in 0 ... 6){
			var len = buffer.readInt32();
			var pixels = new hxd.Pixels(size, size, haxe.zip.Uncompress.run(buffer.read(len)), format);
			staticTexture.uploadPixels(pixels, 0, i);
		}
		syncShader(staticTexture);
		return true;
	}

	function createDefaultShadowMap(){
		var tex = new h3d.mat.Texture(1,1, [Cube,Target], format);
		for(i in 0 ... 6){
			tex.clear(0xFFFFFF, i);
		}
		return tex;
	}

	override function draw( passes ) {

		if( !ctx.computingStatic ){
			switch( mode ) {
			case None:
				return passes;
			case Dynamic:	// nothing
			case Mixed:		// nothing
			case Static:
				if( staticTexture == null || staticTexture.isDisposed() ) staticTexture = createDefaultShadowMap();
				syncShader(staticTexture);
				return passes;
			}
		}

		passes = filterPasses(passes);

		var texture = ctx.textures.allocTarget("pointShadowMap", size, size, false, format, [Target, Cube]);
		if(depth == null || depth.width != size || depth.height != size || depth.isDisposed() ) {
				if( depth != null ) depth.dispose();
				depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;

		var textureTest = ctx.textures.allocTarget("pointShadowMap", size, size, false, format);
		textureTest.depthBuffer = depth;

		var merge : h3d.mat.Texture = null;
		if( mode == Mixed && !ctx.computingStatic )
			merge = ctx.textures.allocTarget("pointShadowMap", size, size, false, format, [Target, Cube]);

		for(i in 0 ... 6){

			var pointLight = cast(light, h3d.scene.pbr.PointLight);

			if( mode != Mixed || ctx.computingStatic ) {
				var absPos = light.getAbsPos();
				lightCamera.setCubeMap(i, new h3d.Vector(absPos.tx, absPos.ty, absPos.tz));
				lightCamera.zFar = pointLight.range;
				lightCamera.update();
			}

			ctx.engine.pushTarget(texture, i);
			ctx.engine.clear(0xFFFFFF, 1);
			passes = super.draw(passes);
			ctx.engine.popTarget();

			if( mode == Mixed && !ctx.computingStatic ) {
				mergePass.shader.texA = texture;
				mergePass.shader.texB = staticTexture;
				mergePass.shader.mat = cubeDir[i];
				ctx.engine.pushTarget(merge, i);
				mergePass.render();
				ctx.engine.popTarget();
			}

			// To Do
			//if( blur.radius > 0 && (mode != Mixed || !ctx.computingStatic) )
				//blur.apply(ctx, texture);
		}

		if( mode == Mixed && !ctx.computingStatic )
			texture = merge;

		syncShader(texture);
		return passes;
	}

	override function computeStatic( passes : h3d.pass.Object ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
		var texture = pshader.shadowMap;
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = texture.clone();
		pshader.shadowMap = staticTexture;
	}
}