package h3d.scene.pbr;

import h3d.pass.CascadeShadowMap;

class LightBuffer {

	public var defaultForwardShader = new h3d.shader.pbr.DefaultForward();

	var MAX_DIR_SHADOW = 1;
	var MAX_SPOT_SHADOW = 2;
	var MAX_POINT_SHADOW = 2;

	var pointLightsShadow : Array<PointLight> = [];
	var spotLightsShadow : Array<SpotLight> = [];
	var dirLightsShadow : Array<DirLight> = [];
	var cascadeLight : DirLight;
	var pointLights : Array<PointLight> = [];
	var spotLights : Array<SpotLight> = [];
	var dirLights : Array<DirLight> = [];

	var lightInfos : hxd.FloatBuffer;
	final POINT_LIGHT_INFO_SIZE = 3;
	final SPOT_LIGHT_INFO_SIZE = 8;
	final DIR_LIGHT_INFO_SIZE = 5;
	final CASCADE_SHADOW_INFO_SIZE = 13;
	final BUFFER_MAX_SIZE = 4096;

	public function new() {
		createBuffers();
	}

	function createBuffers() {
		lightInfos = new hxd.FloatBuffer(BUFFER_MAX_SIZE << 2);
		defaultForwardShader.lightInfos = new h3d.Buffer(BUFFER_MAX_SIZE, hxd.BufferFormat.make([{ name : "uniformData", type : DVec4 }]), [UniformBuffer, Dynamic]);
	}

	public function setBuffers( s : h3d.shader.pbr.DefaultForward ) {
		s.lightInfos = defaultForwardShader.lightInfos;
		s.pointLightStride = defaultForwardShader.pointLightStride;
		s.spotLightStride = defaultForwardShader.spotLightStride;
		s.cascadeLightStride = defaultForwardShader.cascadeLightStride;
		s.cameraPosition = defaultForwardShader.cameraPosition;
		s.emissivePower = defaultForwardShader.emissivePower;

		s.pointLightCount = defaultForwardShader.pointLightCount;
		s.spotLightCount = defaultForwardShader.spotLightCount;
		s.dirLightCount = defaultForwardShader.dirLightCount;
		s.pointShadowCount = defaultForwardShader.pointShadowCount;
		s.spotShadowCount = defaultForwardShader.spotShadowCount;
		s.dirShadowCount = defaultForwardShader.dirShadowCount;
		s.MAX_DIR_SHADOW_COUNT = defaultForwardShader.MAX_DIR_SHADOW_COUNT;
		s.MAX_POINT_SHADOW_COUNT = defaultForwardShader.MAX_POINT_SHADOW_COUNT;
		s.MAX_SPOT_SHADOW_COUNT = defaultForwardShader.MAX_SPOT_SHADOW_COUNT;
		s.CASCADE_COUNT = defaultForwardShader.CASCADE_COUNT;

		for( i in 0 ... defaultForwardShader.MAX_POINT_SHADOW_COUNT )
			s.pointShadowMaps[i] = defaultForwardShader.pointShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_SPOT_SHADOW_COUNT )
			s.spotShadowMaps[i] = defaultForwardShader.spotShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_DIR_SHADOW_COUNT )
			s.dirShadowMaps[i] = defaultForwardShader.dirShadowMaps[i];
		for ( i in 0... defaultForwardShader.CASCADE_COUNT )
			s.cascadeShadowMaps[i] = defaultForwardShader.cascadeShadowMaps[i];

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

	function sortingCriteria ( l1 : Light, l2 : Light, cameraTarget : h3d.Vector ) {
		var dirL1 = Std.isOfType(l1, DirLight);
		var dirL2 = Std.isOfType(l2, DirLight);
		if ( dirL1 && !dirL2 )
			return -1;
		if ( dirL2 && !dirL1 )
			return 1;
		var d1 = l1.getAbsPos().getPosition().sub(cameraTarget).length();
		var d2 = l2.getAbsPos().getPosition().sub(cameraTarget).length();
		return d1 == d2 ? 0 : (d1 > d2 ? 1 : -1);
	}

	public function sortLights ( ctx : h3d.scene.RenderContext ) : Array<Light> @:privateAccess {
		var lights = [];
		var l = Std.downcast(ctx.lights, Light);
		if ( l == null )
			return null;
		while ( l != null ) {
			if (l.enableForward && l.inFrustum(ctx.camera.frustum)) {
				lights.push(l);
			}
			l = Std.downcast(l.next, Light);
		}
		lights.sort(function(l1,l2) { return sortingCriteria(l1, l2, ctx.camera.target); });
		return lights;
	}

	public function fillLights (lights : Array<Light>, shadows : Bool) {
		if (lights == null)
			return;
		pointLightsShadow = [];
		spotLightsShadow = [];
		dirLightsShadow = [];
		cascadeLight = null;
		pointLights = [];
		spotLights = [];
		dirLights = [];

		var dirShadowCount = 0;
		var pointShadowCount = 0;
		var spotShadowCount = 0;

		var dirLightCount = 0;
		var pointLightCount = 0;
		var spotLightCount = 0;

		var curSize = 0;
		for (l in lights) {
			var dl = Std.downcast(l, DirLight);
			if (dl != null) {
				if ( curSize + DIR_LIGHT_INFO_SIZE < BUFFER_MAX_SIZE ) {
					curSize += DIR_LIGHT_INFO_SIZE;
					var hasShadow = dl.shadows != null && dl.shadows.enabled && dl.shadows.mode != None && shadows;
					if (hasShadow && dirShadowCount < MAX_DIR_SHADOW) {
						var cascade = Std.downcast(dl.shadows, CascadeShadowMap);
						if ( cascade != null ) {
							curSize -= DIR_LIGHT_INFO_SIZE;
							if ( curSize + CASCADE_SHADOW_INFO_SIZE < BUFFER_MAX_SIZE ) {
								curSize += CASCADE_SHADOW_INFO_SIZE;
								cascadeLight = dl;
							}
						} else
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
				if ( curSize + POINT_LIGHT_INFO_SIZE < BUFFER_MAX_SIZE ) {
					curSize += POINT_LIGHT_INFO_SIZE;
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
				if ( curSize + SPOT_LIGHT_INFO_SIZE < BUFFER_MAX_SIZE ) {
					curSize += SPOT_LIGHT_INFO_SIZE;
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
		s.CASCADE_COUNT = 0;

		// Safe Reset
		for( i in 0 ... lightInfos.length )
			lightInfos[i] = 0;

		var lights = sortLights(ctx);
		fillLights(lights, pbrRenderer.shadows);

		// Dir Light With Shadow
		var stride = 0;
		for (li in 0...dirLightsShadow.length) {
			var dl = dirLightsShadow[li];
			var pbr = @:privateAccess dl.pbr;
			var i = stride << 2;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = 1.0;
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+7] = dl.shadows.bias;
			s.dirShadowMaps[li] = dl.shadows.getShadowTex();
			var mat = dl.shadows.getShadowProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
			stride += DIR_LIGHT_INFO_SIZE;
		}

		// Dir Light
		for (li in 0...dirLights.length) {
			var dl = dirLights[li];
			var i = stride << 2;
			var pbr = @:privateAccess dl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = -1.0;
			fillVector(lightInfos, pbr.lightDir, i+4);
			stride += DIR_LIGHT_INFO_SIZE;
		}

		s.pointLightStride = stride;

		// Point Light With Shadows
		for (li in 0...pointLightsShadow.length) {
			var pl = pointLightsShadow[li];
			var i = stride << 2;
			var pbr = @:privateAccess pl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			lightInfos[i+8] = pl.range;
			lightInfos[i+9] = 1.0;
			lightInfos[i+10] = pl.shadows.bias;
			s.pointShadowMaps[li] = pl.shadows.getShadowTex();
			stride += POINT_LIGHT_INFO_SIZE;
		}

		// Point Light
		for (li in 0...pointLights.length) {
			var pl = pointLights[li];
			var i = stride << 2;
			var pbr = @:privateAccess pl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			lightInfos[i+8] = pl.range;
			lightInfos[i+9] = -1.0;
			stride += POINT_LIGHT_INFO_SIZE;
		}

		s.spotLightStride = stride;

		// Spot Light With Shadow
		for (li in 0...spotLightsShadow.length) {
			var sl = spotLightsShadow[li];
			var i = stride << 2;
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
			stride += SPOT_LIGHT_INFO_SIZE;
		}

		// Spot Light
		for (li in 0...spotLights.length) {
			var sl = spotLights[li];
			var i = stride << 2;
			var pbr = @:privateAccess sl.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = pbr.range;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+12] = pbr.angle;
			lightInfos[i+13] = pbr.fallOff;
			lightInfos[i+14] = -1.0;
			stride += SPOT_LIGHT_INFO_SIZE;
		}

		s.cascadeLightStride = stride;

		// Cascade shadows
		if ( cascadeLight != null ) {
			var i = stride << 2;
			var pbr = @:privateAccess cascadeLight.pbr;
			fillVector(lightInfos, pbr.lightColor, i);
			lightInfos[i+3] = 0.0;
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+7] = 0.0;
			var cascadeShadow = cast(cascadeLight.shadows, CascadeShadowMap);
			var shadowMaps = cascadeShadow.getShadowTextures();
			s.CASCADE_COUNT = cascadeShadow.cascade;
			var mat = cascadeShadow.cascadeViewProj;
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
			for ( index in 0...cascadeShadow.cascade ) {
				s.cascadeShadowMaps[index] = shadowMaps[index];
				fillVector(lightInfos, cascadeShadow.getCascadeScale(index).toVector(), i + 20 + index * 8);
				fillVector(lightInfos, cascadeShadow.getCascadeOffset(index).toVector(), i + 24 + index * 8);
			}
		}

		s.dirLightCount = dirLights.length;
		s.pointLightCount = pointLights.length;
		s.spotLightCount = spotLights.length;
		s.MAX_DIR_SHADOW_COUNT = MAX_DIR_SHADOW;
		s.MAX_POINT_SHADOW_COUNT = MAX_POINT_SHADOW;
		s.MAX_SPOT_SHADOW_COUNT = MAX_SPOT_SHADOW;
		s.dirShadowCount = dirLightsShadow.length;
		s.pointShadowCount = pointLightsShadow.length;
		s.spotShadowCount = spotLightsShadow.length;
		s.lightInfos.uploadFloats(lightInfos, 0, s.lightInfos.vertices, 0);
		pointLights = [];
		spotLights = [];
		dirLights = [];
		pointLightsShadow = [];
		spotLightsShadow = [];
		dirLightsShadow = [];
		cascadeLight = null;

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
