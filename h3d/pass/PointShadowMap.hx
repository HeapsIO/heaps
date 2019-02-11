package h3d.pass;

class PointShadowMap extends Shadows {

	var customDepth : Bool;
	var depth : h3d.mat.DepthBuffer;
	var pshader : h3d.shader.PointShadow;
	var mergePass = new h3d.pass.ScreenFx(new h3d.shader.MinMaxShader.CubeMinMaxShader());

	var cubeDir = [ h3d.Matrix.L([0,0,-1,0, 0,-1,0,0, 1,0,0,0]),
					h3d.Matrix.L([0,0,1,0, 0,-1,0,0, -1,0,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,1,0, 0,1,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,-1,0, 0,-1,0,0]),
				 	h3d.Matrix.L([1,0,0,0, 0,-1,0,0, 0,1,0,0]),
				 	h3d.Matrix.L([-1,0,0,0, 0,-1,0,0, 0,0,-1,0]) ];

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

	override function getShadowTex() {
		return pshader.shadowMap;
	}

	override function setGlobals() {
		super.setGlobals();
		cameraViewProj = getShadowProj();
		cameraFar = lightCamera.zFar;
		cameraPos = lightCamera.pos;
	}

	function syncShader(texture) {
		var absPos = light.getAbsPos();
		var pointLight = cast(light, h3d.scene.pbr.PointLight);
		pshader.shadowMap = texture;
		pshader.shadowBias = bias;
		pshader.shadowPower = power;
		pshader.lightPos = new h3d.Vector(absPos.tx, absPos.ty, absPos.tz);
		pshader.zFar = pointLight.range;
	}

	override function saveStaticData() {
		if( mode != Mixed && mode != Static )
			return null;
		if( staticTexture == null )
			throw "Data not computed";

		var buffer = new haxe.io.BytesBuffer();
		buffer.addInt32(staticTexture.width);

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

		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = new h3d.mat.Texture(size, size, [Target, Cube], format);
		staticTexture.name = "staticTexture";

		for(i in 0 ... 6){
			var len = buffer.readInt32();
			var pixels = new hxd.Pixels(size, size, haxe.zip.Uncompress.run(buffer.read(len)), format);
			staticTexture.uploadPixels(pixels, 0, i);
		}
		syncShader(staticTexture);
		return true;
	}

	function createDefaultShadowMap(){
		var tex = new h3d.mat.Texture(1,1, [Target,Cube], format);
		tex.name = "defaultStaticTexture";
		for(i in 0 ... 6)
			tex.clear(0xFFFFFF, i);
		return tex;
	}

	override function draw( passes ) {

		if( !ctx.computingStatic ){
			switch( mode ) {
			case None:
				return passes;
			case Dynamic:
				// nothing
			case Mixed:
				if( staticTexture == null || staticTexture.isDisposed() )
					staticTexture = createDefaultShadowMap();
			case Static:
				if( staticTexture == null || staticTexture.isDisposed() )
					staticTexture = createDefaultShadowMap();
				updateCamera();
				syncShader(staticTexture);
				return passes;
			}
		}

		var passes = filterPasses(passes);

		var texture = ctx.textures.allocTarget("pointShadowMap", size, size, false, format, [Target, Cube]);
		if(depth == null || depth.width != size || depth.height != size || depth.isDisposed() ) {
				if( depth != null ) depth.dispose();
				depth = new h3d.mat.DepthBuffer(size, size);
		}
		texture.depthBuffer = depth;

		var validBakedTexture = (staticTexture != null && staticTexture.width == texture.width);
		var merge : h3d.mat.Texture = null;
		if( mode == Mixed && !ctx.computingStatic && validBakedTexture)
			merge = ctx.textures.allocTarget("mergedPointShadowMap", size, size, false, format, [Target, Cube]);

		var pointLight = cast(light, h3d.scene.pbr.PointLight);
		var absPos = light.getAbsPos();
		var lightBounds = new h3d.col.Bounds();
		lightBounds.addPoint( new h3d.col.Point(absPos.tx + pointLight.range, absPos.ty + pointLight.range, absPos.tz + pointLight.range));
		lightBounds.addPoint( new h3d.col.Point(absPos.tx - pointLight.range, absPos.ty - pointLight.range, absPos.tz - pointLight.range));

		for(i in 0 ... 6){

			var pointLight = cast(light, h3d.scene.pbr.PointLight);

			var absPos = light.getAbsPos();
			lightCamera.setCubeMap(i, new h3d.Vector(absPos.tx, absPos.ty, absPos.tz));
			lightCamera.zFar = pointLight.range;
			lightCamera.zNear = pointLight.zNear;
			lightCamera.update();

			ctx.engine.pushTarget(texture, i);
			ctx.engine.clear(0xFFFFFF, 1);
			passes = customDraw(passes, lightBounds);

			ctx.engine.popTarget();
		}

		if( blur.radius > 0 )
			blur.apply(ctx, texture);

		if( mode == Mixed && !ctx.computingStatic && merge != null ) {
			for(i in 0 ... 6){
				mergePass.shader.texA = texture;
				mergePass.shader.texB = staticTexture;
				mergePass.shader.mat = cubeDir[i];
				ctx.engine.pushTarget(merge, i);
				mergePass.render();
				ctx.engine.popTarget();
			}
			texture = merge;
		}

		syncShader(texture);
		return passes;
	}

	@:access(h3d.scene)
	function customDraw( passes : Object, lightBounds : h3d.col.Bounds) {
		for( g in ctx.sharedGlobals )
			globals.fastSet(g.gid, g.value);
		setGlobals();
		setupShaders(passes);
		var p = passes;
		var shaderStart = shaderCount, textureStart = textureCount;
		while( p != null ) {
			if( shaderIdMap[p.shader.id] < shaderStart #if js || shaderIdMap[p.shader.id] == null #end )
				shaderIdMap[p.shader.id] = shaderCount++;
			if( textureIdMap[p.texture] < textureStart #if js || textureIdMap[p.shader.id] == null #end )
				textureIdMap[p.texture] = textureCount++;
			p = p.next;
		}
		if( sortPasses )
			passes = haxe.ds.ListSort.sortSingleLinked(passes, function(o1:Object, o2:Object) {
				var d = shaderIdMap[o1.shader.id] - shaderIdMap[o2.shader.id];
				if( d != 0 ) return d;
				return textureIdMap[o1.texture] - textureIdMap[o2.texture];
			});
		ctx.uploadParams = uploadParams;
		var p = passes;
		var buf = cachedBuffer, prevShader = null;
		var drawTri = 0, drawCalls = 0, shaderSwitches = 0;
		if( ctx.engine.driver.logEnable ) {
			if( logEnable ) log("Pass " + (passes == null ? "???" : passes.pass.name) + " start");
			drawTri = ctx.engine.drawTriangles;
			drawCalls = ctx.engine.drawCalls;
			shaderSwitches = ctx.engine.shaderSwitches;
		}
		while( p != null ) {

			if( !lightCamera.frustum.hasBounds(p.obj.getBounds())) {
				p = p.next;
				continue;
			}

			if( logEnable ) log("Render " + p.obj + "." + p.pass.name);
			globalModelView = p.obj.absPos;
			if( p.shader.hasGlobal(globalModelViewInverse_id.toInt()) )
				globalModelViewInverse = p.obj.getInvPos();
			if( prevShader != p.shader ) {
				prevShader = p.shader;
				ctx.engine.selectShader(p.shader);
				if( buf == null )
					buf = cachedBuffer = new h3d.shader.Buffers(p.shader);
				else
					buf.grow(p.shader);
				manager.fillGlobals(buf, p.shader);
				ctx.engine.uploadShaderBuffers(buf, Globals);
			}
			if( !p.pass.dynamicParameters ) {
				manager.fillParams(buf, p.shader, p.shaders);
				ctx.engine.uploadShaderBuffers(buf, Params);
				ctx.engine.uploadShaderBuffers(buf, Textures);
				ctx.engine.uploadShaderBuffers(buf, Buffers);
			}
			drawObject(p);
			p = p.next;
		}
		if( logEnable ) {
			log("Pass " + (passes == null ? "???" : passes.pass.name) + " end");
			log("\t" + (ctx.engine.drawTriangles - drawTri) + " tri " + (ctx.engine.drawCalls - drawCalls) + " calls " + (ctx.engine.shaderSwitches - shaderSwitches) + " shaders");
		}
		ctx.nextPass();
		return passes;
	}

	function updateCamera(){
		var absPos = light.getAbsPos();
		lightCamera.pos.set(absPos.tx, absPos.ty, absPos.tz);
		lightCamera.update();
	}

	override function computeStatic( passes : h3d.pass.Object ) {
		if( mode != Static && mode != Mixed )
			return;
		draw(passes);
		var texture = pshader.shadowMap;
		if( staticTexture != null ) staticTexture.dispose();
		staticTexture = texture.clone();
		staticTexture.name = "StaticPointShadowMap";
		pshader.shadowMap = staticTexture;
	}
}