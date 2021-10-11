package h3d.scene.pbr;

class LightBuffer {

	public var defaultForwardShader = new h3d.shader.pbr.DefaultForward();

	var MAX_DIR_LIGHT = 2;
	var MAX_SPOT_LIGHT = 10;
	var MAX_POINT_LIGHT = 10;
	var MAX_DIR_SHADOW = 1;
	var MAX_SPOT_SHADOW = 3;
	var MAX_POINT_SHADOW = 3;

	var pointLightsShadow : Array<PointLight> = [];
	var spotLightsShadow : Array<SpotLight> = [];
	var dirLightsShadow : Array<DirLight> = [];
	var pointLights : Array<PointLight> = [];
	var spotLights : Array<SpotLight> = [];
	var dirLights : Array<DirLight> = [];

	var lightInfos : hxd.FloatBuffer;
	final POINT_LIGHT_INFO_SIZE = 3;
	final SPOT_LIGHT_INFO_SIZE = 8;
	final DIR_LIGHT_INFO_SIZE = 5;


	public function new() {
		createBuffers();
	}

	function createBuffers() {
		var stride = 4;
		var size = 0;
		size += MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE;
		size += MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE;
		size += MAX_SPOT_LIGHT * SPOT_LIGHT_INFO_SIZE;
		size = hxd.Math.imax(1, size); // Avoid empty buffer
		lightInfos = new hxd.FloatBuffer(size * stride);
		defaultForwardShader.lightInfos = new h3d.Buffer(size, stride, [UniformBuffer, Dynamic]);
		defaultForwardShader.BUFFER_SIZE = size;
		defaultForwardShader.dirLightStride = DIR_LIGHT_INFO_SIZE * MAX_DIR_LIGHT;
		defaultForwardShader.pointLightStride = POINT_LIGHT_INFO_SIZE * MAX_POINT_LIGHT;
	}

	public function setBuffers( s : h3d.shader.pbr.DefaultForward ) {
		s.lightInfos = defaultForwardShader.lightInfos;
		s.dirLightStride = defaultForwardShader.dirLightStride;
		s.pointLightStride = defaultForwardShader.pointLightStride;
		s.cameraPosition = defaultForwardShader.cameraPosition;
		s.emissivePower = defaultForwardShader.emissivePower;
		s.BUFFER_SIZE = defaultForwardShader.BUFFER_SIZE;

		s.pointLightCount = defaultForwardShader.pointLightCount;
		s.spotLightCount = defaultForwardShader.spotLightCount;
		s.dirLightCount = defaultForwardShader.dirLightCount;
		s.DIR_SHADOW_COUNT = defaultForwardShader.DIR_SHADOW_COUNT;
		s.POINT_SHADOW_COUNT = defaultForwardShader.POINT_SHADOW_COUNT;
		s.SPOT_SHADOW_COUNT = defaultForwardShader.SPOT_SHADOW_COUNT;

		for( i in 0 ... defaultForwardShader.POINT_SHADOW_COUNT )
			s.pointShadowMaps[i] = defaultForwardShader.pointShadowMaps[i];
		for( i in 0 ... defaultForwardShader.SPOT_SHADOW_COUNT )
			s.spotShadowMaps[i] = defaultForwardShader.spotShadowMaps[i];
		for( i in 0 ... defaultForwardShader.DIR_SHADOW_COUNT )
			s.dirShadowMaps[i] = defaultForwardShader.dirShadowMaps[i];

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

	inline function fillFloats( b : hxd.FloatBuffer, f1 : Float, f2 : Float, f3 : Float, f4 : Float, i : Int ) {
		b[i+0] = f1;
		b[i+1] = f2;
		b[i+2] = f3;
		b[i+3] = f4;
	}

	inline function fillVector( b : hxd.FloatBuffer, v : h3d.Vector, i : Int ) {
		b[i+0] = v.r;
		b[i+1] = v.g;
		b[i+2] = v.b;
		b[i+3] = v.a;
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
		pointLightsShadow = [];
		spotLightsShadow = [];
		dirLightsShadow = [];
		pointLights = [];
		spotLights = [];
		dirLights = [];

		var dirShadowCount = 0;
		var pointShadowCount = 0;
		var spotShadowCount = 0;

		var dirLightCount = 0;
		var pointLightCount = 0;
		var spotLightCount = 0;

		for (l in lights) {
			var dl = Std.downcast(l, DirLight);
			if (dl != null) {
				if (dirLightCount + dirShadowCount < MAX_DIR_LIGHT) {
					var hasShadow = dl.shadows != null && dl.shadows.enabled && dl.shadows.mode != None && shadows;
					if (hasShadow && dirShadowCount < MAX_DIR_SHADOW) {
						dirLightsShadow.push(dl);
						dirShadowCount++;
					} else {
						dirLights.push(dl);
						dirLightCount++;
					}
				}

			}

			var pl = Std.downcast(l, PointLight);
			if (pl != null) {
				if (pointLightCount + pointShadowCount < MAX_POINT_LIGHT) {
					var hasShadow = pl.shadows != null && pl.shadows.enabled && pl.shadows.mode != None && shadows;
					if (hasShadow && pointShadowCount < MAX_POINT_SHADOW) {
						pointLightsShadow.push(pl);
						pointShadowCount++;
					} else {
						pointLights.push(pl);
						pointLightCount++;
					}
				}

			}

			var sl = Std.downcast(l, SpotLight);
			if (sl != null) {
				if (spotLightCount + spotShadowCount < MAX_SPOT_LIGHT) {
					var hasShadow = sl.shadows != null && sl.shadows.enabled && sl.shadows.mode != None && shadows;
					if (hasShadow && spotShadowCount < MAX_SPOT_SHADOW) {
						spotLightsShadow.push(sl);
						spotShadowCount++;
					} else {
						spotLights.push(sl);
						spotLightCount++;
					}
				}

			}
		}
	}

	public function sync( ctx : h3d.scene.RenderContext ) {
		if (defaultForwardShader.lightInfos.isDisposed())
			createBuffers();

		var r = @:privateAccess ctx.scene.renderer;
		var pbrRenderer = Std.downcast(r, Renderer);
		if( pbrRenderer == null ) return;
		var p : h3d.scene.pbr.Renderer.RenderProps = pbrRenderer.props;
		var s = defaultForwardShader;


		s.cameraPosition = ctx.camera.pos;
		s.emissivePower = p.emissive * p.emissive;

		s.pointLightCount = 0;
		s.spotLightCount = 0;
		s.dirLightCount = 0;

		// Safe Reset
		for( i in 0 ... lightInfos.length )
			lightInfos[i] = 0;

		var lights = sortLights(ctx);
		fillLights(lights, pbrRenderer.shadows);

		// Dir Light With Shadow
		for (li in 0...dirLightsShadow.length) {
			var dl = dirLightsShadow[li];
			var i = li * DIR_LIGHT_INFO_SIZE * 4;
			var pbr = @:privateAccess dl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+3] = 1.0;
			lightInfos[i+7] = dl.shadows.bias;
			s.dirShadowMaps[li] = dl.shadows.getShadowTex();
			var mat = dl.shadows.getShadowProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
		}

		// Dir Light
		for (li in 0...dirLights.length) {
			var dl = dirLights[li];
			var i = (li + dirLightsShadow.length) * DIR_LIGHT_INFO_SIZE * 4;
			var pbr = @:privateAccess dl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+3] = -1.0;
		}

		// Point Light With Shadows
		for (li in 0...pointLightsShadow.length) {
			var pl = pointLightsShadow[li];
			var offset = MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE * 4;
			var i = li * POINT_LIGHT_INFO_SIZE * 4 + offset;
			var pbr = @:privateAccess pl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			lightInfos[i+8] = pl.range;
			lightInfos[i+9] = 1.0;
			lightInfos[i+10] = pl.shadows.bias;
			s.pointShadowMaps[li] = pl.shadows.getShadowTex();
		}

		// Point Light
		for (li in 0...pointLights.length) {
			var pl = pointLights[li];
			var offset = MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE * 4;
			var i = (li + pointLightsShadow.length) * POINT_LIGHT_INFO_SIZE * 4 + offset;
			var pbr = @:privateAccess pl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			lightInfos[i+8] = pl.range;
			lightInfos[i+9] = -1.0;
		}

		// Spot Light With Shadow
		for (li in 0...spotLightsShadow.length) {
			var sl = spotLightsShadow[li];
			var offset = (MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE + MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE) * 4 ;
			var i = li * SPOT_LIGHT_INFO_SIZE * 4 + offset;
			var pbr = @:privateAccess sl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.range;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+12] = pbr.angle;
			lightInfos[i+13] = pbr.fallOff;
			lightInfos[i+14] = 1.0;
			lightInfos[i+15] = sl.shadows.bias;
			var mat = sl.shadows.getShadowProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+16);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+20);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+24);
			fillFloats(lightInfos, mat._14, mat._24, mat._34, mat._44, i+28);
			s.spotShadowMaps[li] = sl.shadows.getShadowTex();
		}

		// Spot Light
		for (li in 0...spotLights.length) {
			var sl = spotLights[li];
			var offset = (MAX_DIR_LIGHT * DIR_LIGHT_INFO_SIZE + MAX_POINT_LIGHT * POINT_LIGHT_INFO_SIZE) * 4 ;
			var i = (li + spotLightsShadow.length) * SPOT_LIGHT_INFO_SIZE * 4 + offset;
			var pbr = @:privateAccess sl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.range;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+12] = pbr.angle;
			lightInfos[i+13] = pbr.fallOff;
			lightInfos[i+14] = -1.0;
		}

		s.dirLightCount = dirLights.length;
		s.pointLightCount = pointLights.length;
		s.spotLightCount = spotLights.length;
		s.DIR_SHADOW_COUNT = dirLightsShadow.length;
		s.POINT_SHADOW_COUNT = pointLightsShadow.length;
		s.SPOT_SHADOW_COUNT = spotLightsShadow.length;
		s.lightInfos.uploadVector(lightInfos, 0, s.lightInfos.vertices, 0);

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
	}

	public function dispose() {
		defaultForwardShader.lightInfos.dispose();
	}
}
