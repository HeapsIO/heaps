package h3d.scene.pbr;

class LightBuffer {

	public var defaultForwardShader = new h3d.shader.pbr.DefaultForward();

	var MAX_DIR_LIGHT = 2;
	var MAX_POINT_LIGHT = 100;
	var MAX_SPOT_LIGHT = 100;
	var DIR_LIGHT_PER_TILE = 2;
	var POINT_LIGHT_PER_TILE = 8;
	var SPOT_LIGHT_PER_TILE = 8;
	var GRID_SIZE = 64;

	var pointLights : Array<PointLight> = [];
	var spotLights : Array<SpotLight> = [];
	var dirLights : Array<DirLight> = [];

	var allLightsInfos : hxd.FloatBuffer;
	final POINT_LIGHT_INFO_SIZE = 3;
	final SPOT_LIGHT_INFO_SIZE = 8;
	final DIR_LIGHT_INFO_SIZE = 5;

	var allLightsBuffer : h3d.Buffer;

	var shaderList = new h3d.mat.Pass("lightBuffer");
	var shader = new h3d.shader.pbr.LightBufferShader();

	public function new() {
		shaderList.addShader(shader);
		createBuffers();
	}

	function createBuffers() {
		var stride = 4;
		var size = 0;
		var tileCount = GRID_SIZE * GRID_SIZE;

		var tileStride = DIR_LIGHT_PER_TILE;
		tileStride += POINT_LIGHT_PER_TILE;
		tileStride += SPOT_LIGHT_PER_TILE;

		size = tileCount * tileStride;
		size = hxd.Math.imax(1, size); // Avoid empty buffer
		
		var allLightsSize = MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE;
		allLightsSize += MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE;
		allLightsSize += MAX_SPOT_LIGHT * SPOT_LIGHT_INFO_SIZE;
		allLightsInfos = new hxd.FloatBuffer(allLightsSize * 4);
		if ( allLightsBuffer != null )
			allLightsBuffer.dispose();
		allLightsBuffer = new h3d.Buffer(allLightsSize, hxd.BufferFormat.VEC4_DATA, [ReadWriteBuffer, Dynamic]);
		
		if ( defaultForwardShader.tileBuffer != null )
			defaultForwardShader.tileBuffer.dispose();
		defaultForwardShader.tileBuffer = new h3d.Buffer(size, hxd.BufferFormat.make([{ name : "", type : DFloat }]), [ReadWriteBuffer, Dynamic]);
		defaultForwardShader.allLights = allLightsBuffer;
		defaultForwardShader.pointLightStride = POINT_LIGHT_INFO_SIZE;
		defaultForwardShader.spotLightStride = SPOT_LIGHT_INFO_SIZE;
		defaultForwardShader.dirLightStride = DIR_LIGHT_INFO_SIZE;
		defaultForwardShader.gridSize = GRID_SIZE;
		defaultForwardShader.tileStride = tileStride;
		defaultForwardShader.pointLightPerTile = POINT_LIGHT_PER_TILE;
		defaultForwardShader.spotLightPerTile = SPOT_LIGHT_PER_TILE;
		defaultForwardShader.dirLightPerTile = DIR_LIGHT_PER_TILE;
		defaultForwardShader.maxDirLight = MAX_DIR_LIGHT;
		defaultForwardShader.maxSpotLight = MAX_SPOT_LIGHT;
		defaultForwardShader.maxPointLight = MAX_POINT_LIGHT;

		shader.gridSize = GRID_SIZE;
		shader.tileStride = tileStride;
		shader.allLights = allLightsBuffer;
		shader.tileBuffer = defaultForwardShader.tileBuffer;
		shader.MAX_DIR_LIGHT = MAX_DIR_LIGHT;
		shader.MAX_POINT_LIGHT = MAX_POINT_LIGHT;
		shader.MAX_SPOT_LIGHT = MAX_SPOT_LIGHT;
		shader.dirLightPerTile = DIR_LIGHT_PER_TILE;
		shader.pointLightPerTile = POINT_LIGHT_PER_TILE;
		shader.spotLightPerTile = SPOT_LIGHT_PER_TILE;
		shader.dirLightStride = DIR_LIGHT_INFO_SIZE;
		shader.pointLightStride = POINT_LIGHT_INFO_SIZE;
		shader.spotLightStride = SPOT_LIGHT_INFO_SIZE;
	}

	public function setBuffers( s : h3d.shader.pbr.DefaultForward ) {
		s.tileBuffer = defaultForwardShader.tileBuffer;
		s.allLights = defaultForwardShader.allLights;
		s.dirLightStride = defaultForwardShader.dirLightStride;
		s.pointLightStride = defaultForwardShader.pointLightStride;
		s.spotLightStride = defaultForwardShader.spotLightStride;
		s.cameraPosition = defaultForwardShader.cameraPosition;
		s.emissivePower = defaultForwardShader.emissivePower;
		s.gridSize = defaultForwardShader.gridSize;
		s.tileStride = defaultForwardShader.tileStride;

		s.pointLightPerTile = defaultForwardShader.pointLightPerTile;
		s.spotLightPerTile = defaultForwardShader.spotLightPerTile;
		s.dirLightPerTile = defaultForwardShader.dirLightPerTile;

		s.maxPointLight = defaultForwardShader.maxPointLight;
		s.maxSpotLight = defaultForwardShader.maxSpotLight;
		s.maxDirLight = defaultForwardShader.maxDirLight;

		s.USE_INDIRECT = defaultForwardShader.USE_INDIRECT;
		if( s.USE_INDIRECT ) {
			s.irrRotation = defaultForwardShader.irrRotation;
			s.irrPower = defaultForwardShader.irrPower;
			s.irrLut = defaultForwardShader.irrLut;
			s.irrDiffuse = defaultForwardShader.irrDiffuse;
			s.irrSpecular = defaultForwardShader.irrSpecular;
			s.irrSpecularLevels = defaultForwardShader.irrSpecularLevels;
		}
	}

	function fillFloats( b : hxd.FloatBuffer, f1 : Float, f2 : Float, f3 : Float, f4 : Float, i : Int ) {
		b[i+0] = f1;
		b[i+1] = f2;
		b[i+2] = f3;
		b[i+3] = f4;
	}

	function fillVector( b : hxd.FloatBuffer, v : h3d.Vector, i : Int ) {
		b[i+0] = v.r;
		b[i+1] = v.g;
		b[i+2] = v.b;
		b[i+3] = 1;
	}

	function sortingCriteria ( l1 : Light, l2 : Light, cameraTarget : Vector ) {
		var d1 = l1.getAbsPos().getPosition().sub(cameraTarget).length();
		var d2 = l2.getAbsPos().getPosition().sub(cameraTarget).length();
		return d1 > d2 ? 1 : -1;
	}

	public function sortLights ( ctx : h3d.scene.RenderContext ) : Array<Light> @:privateAccess {
		var lights = [];
		var l = Std.downcast(ctx.lights, Light);
		if ( l == null )
			return null;
		while ( l != null ) {
			if (l.enableForward) {
				lights.push(l);
			}
			l = Std.downcast(l.next, Light);
		}
		lights.sort(function(l1,l2) { return sortingCriteria(l1, l2, @:privateAccess ctx.camera.target); });
		return lights;
	}

	public function fillLights (lights : Array<Light>, shadows : Bool) {
		if (lights == null)
			return;
		pointLights.resize(MAX_POINT_LIGHT);
		spotLights.resize(MAX_SPOT_LIGHT);
		dirLights.resize(MAX_DIR_LIGHT);

		var dirLightCount = 0;
		var pointLightCount = 0;
		var spotLightCount = 0;

		for (l in lights) {
			var dl = Std.downcast(l, DirLight);
			if (dl != null) {
				if (dirLightCount < MAX_DIR_LIGHT) {
					dirLights[dirLightCount] = dl;
					dirLightCount++;
				}
			}

			var pl = Std.downcast(l, PointLight);
			if (pl != null) {
				if (pointLightCount < MAX_POINT_LIGHT) {
					pointLights[pointLightCount] = pl;
					pointLightCount++;
				}
			}

			var sl = Std.downcast(l, SpotLight);
			if (sl != null) {
				if (spotLightCount < MAX_SPOT_LIGHT) {
					spotLights[spotLightCount] = sl;
					spotLightCount++;
				}
			}
		}
	}

	function uploadDirLight(dl : h3d.scene.pbr.DirLight, pos : Int, floatBuffer : hxd.FloatBuffer) {
		var pbr = @:privateAccess dl.pbr;
		fillVector(floatBuffer, pbr.lightColor, pos);
		floatBuffer[pos+3] = -1.0;
		fillVector(floatBuffer, pbr.lightDir, pos+4);
	}

	function uploadSpotLight(sl : h3d.scene.pbr.SpotLight, pos : Int, floatBuffer : hxd.FloatBuffer) {
		var pbr = @:privateAccess sl.pbr;
		fillVector(floatBuffer, pbr.lightColor, pos);
		floatBuffer[pos+3] = pbr.range;
		fillVector(floatBuffer, pbr.lightPos, pos+4);
		floatBuffer[pos+7] = pbr.invLightRange4;
		fillVector(floatBuffer, pbr.spotDir, pos+8);
		floatBuffer[pos+12] = pbr.angle;
		floatBuffer[pos+13] = pbr.fallOff;
		floatBuffer[pos+14] = -1.0;
	}

	function uploadPointLight(pl : h3d.scene.pbr.PointLight, pos : Int, floatBuffer : hxd.FloatBuffer) {
		var pbr = @:privateAccess pl.pbr;
		fillVector(floatBuffer, pbr.lightColor, pos);
		floatBuffer[pos+3] = pbr.pointSize;
		fillVector(floatBuffer, pbr.lightPos, pos+4);
		floatBuffer[pos+7] = pbr.invLightRange4;
		floatBuffer[pos+8] = pl.range;
		floatBuffer[pos+9] = -1.0;
	}

	public function sync( ctx : h3d.scene.RenderContext ) {
		if (defaultForwardShader.tileBuffer.isDisposed())
			createBuffers();

		var r = @:privateAccess ctx.scene.renderer;
		var pbrRenderer = Std.downcast(r, Renderer);
		if( pbrRenderer == null ) return;
		var p : h3d.scene.pbr.Renderer.RenderProps = pbrRenderer.props;
		var s = defaultForwardShader;

		s.cameraPosition = ctx.camera.pos;
		s.emissivePower = p.emissive * p.emissive;

		var lights = sortLights(ctx);
		fillLights(lights, pbrRenderer.shadows);

		updateAllLightsBuffer(ctx);

		#if !js
		shader.depthBuffer = ctx.engine.driver.getDefaultDepthBuffer();
		shader.screenSize.set(ctx.engine.width, ctx.engine.height);
		shader.inverseProj = ctx.camera.getInverseProj();
		ctx.computeList(@:privateAccess shaderList.shaders);
		ctx.computeDispatch(null, GRID_SIZE, GRID_SIZE, 1);
		var p0 = ctx.camera.unproject(-1.0, -1.0, 1.0);
		var p1 = ctx.camera.unproject(1.0, -1.0, 1.0);
		var p2 = ctx.camera.unproject(-1.0, 1.0, 1.0);
		var p3 = ctx.camera.unproject(1.0, 1.0, 1.0);
		#end

		var pbrIndirect = @:privateAccess pbrRenderer.pbrIndirect;
		s.USE_INDIRECT = pbrRenderer.env != null && pbrIndirect.irrLut != null;
		if( s.USE_INDIRECT ) {
			s.irrRotation = pbrIndirect.irrRotation;
			s.irrPower = pbrIndirect.irrPower;
			s.irrLut = pbrIndirect.irrLut;
			s.irrDiffuse = pbrIndirect.irrDiffuse;
			s.irrSpecular = pbrIndirect.irrSpecular;
			s.irrSpecularLevels = pbrIndirect.irrSpecularLevels;
		}

		for ( i in 0...pointLights.length )
			pointLights[i] = null;
		for ( i in 0...dirLights.length )
			dirLights[i] = null;
		for ( i in 0...spotLights.length )
			spotLights[i] = null;
	}

	function cullDirLight(dl : h3d.scene.pbr.DirLight, camera : h3d.Camera) {
		return false;
	}

	function cullSpotLight(sl : h3d.scene.pbr.SpotLight, camera : h3d.Camera) {
		return false;//!sl.inFrustum(camera.frustum);
	}

	function cullPointLight(pl : h3d.scene.pbr.PointLight, camera : h3d.Camera) {
		return false;//!pl.inFrustum(camera.frustum);
	}
	
	function updateAllLightsBuffer(ctx : h3d.scene.RenderContext) {
		if ( allLightsBuffer.isDisposed() )
			createBuffers();

		for( i in 0 ... allLightsInfos.length )
			allLightsInfos[i] = 0;

		var dirCount = 0;
		for (li in 0...dirLights.length) {
			var dl = dirLights[li];
			if ( dl == null )
				break;
			if ( cullDirLight(dl, ctx.camera) )
				break;
			if ( dirCount >= MAX_DIR_LIGHT )
				break;
			dirCount++;
			uploadDirLight(dl, li * DIR_LIGHT_INFO_SIZE * 4, allLightsInfos);
		}

		var pointCount = 0;
		for (li in 0...pointLights.length) {
			var pl = pointLights[li];
			if ( pl == null )
				break;
			if ( cullPointLight(pl, ctx.camera) )
				break;
			if ( pointCount >= MAX_POINT_LIGHT )
				break;
			pointCount++;
			var offset = MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE * 4;
			uploadPointLight(pl, li * POINT_LIGHT_INFO_SIZE * 4 + offset, allLightsInfos);
		}

		var spotCount = 0;
		for (li in 0...spotLights.length) {
			var sl = spotLights[li];
			if ( sl == null )
				break;
			if ( cullSpotLight(sl, ctx.camera) )
				break;
			if ( spotCount >= MAX_SPOT_LIGHT )
				break;
			spotCount++;
			var offset = (MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE + MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE) * 4 ;
			uploadSpotLight(sl, li * SPOT_LIGHT_INFO_SIZE * 4 + offset, allLightsInfos);
		}

		allLightsBuffer.uploadFloats(allLightsInfos, 0, allLightsBuffer.vertices);
	}

	public function dispose() {
		defaultForwardShader.tileBuffer.dispose();
	}
}
