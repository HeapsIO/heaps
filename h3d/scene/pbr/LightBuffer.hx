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
	// Keep in sync with h3d.shader.pbr.DefaultForward
	final DIR_LIGHT_STRIDE   = 1;
	final POINT_LIGHT_STRIDE = 2;
	final SPOT_LIGHT_STRIDE  = 3;

	final DIR_SHADOW_STRIDE  = 3;
	final SPOT_SHADOW_STRIDE = 5;
	final CUBE_SHADOW_STRIDE = 1;

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
		s.pointLightOffset = defaultForwardShader.pointLightOffset;
		s.spotLightOffset = defaultForwardShader.spotLightOffset;
		s.cascadeLightStride = defaultForwardShader.cascadeLightStride;
		s.dirShadowOffset = defaultForwardShader.dirShadowOffset;
		s.cubeShadowOffset = defaultForwardShader.cubeShadowOffset;
		s.spotShadowOffset = defaultForwardShader.spotShadowOffset;
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
		s.cascadeShadowMaps = defaultForwardShader.cascadeShadowMaps;

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

	function fillVector4( b : hxd.FloatBuffer, v : h3d.Vector4, i : Int ) {
		b[i+0] = v.r;
		b[i+1] = v.g;
		b[i+2] = v.b;
		b[i+3] = v.a;
	}

	function sortingCriteria ( l1 : Light, l2 : Light, cameraTarget : h3d.Vector ) {
		var dirL1 = Std.isOfType(l1, DirLight);
		var dirL2 = Std.isOfType(l2, DirLight);
		if ( dirL1 && !dirL2 )
			return -1;
		if ( dirL2 && !dirL1 )
			return 1;
		var d1 = l1.getAbsPos().getPosition().sub(cameraTarget).lengthSq();
		var d2 = l2.getAbsPos().getPosition().sub(cameraTarget).lengthSq();
		return d1 == d2 ? 0 : (d1 > d2 ? 1 : -1);
	}

	var tmpLights = [];

	public function sortLights ( ctx : h3d.scene.RenderContext ) : Array<Light> @:privateAccess {
		var l = Std.downcast(ctx.lights, Light);
		if ( l == null )
			return null;
		var pos = 0;
		while ( l != null ) {
			if (l.enableForward && l.inFrustum(ctx.camera.frustum)) {
				tmpLights[pos++] = l;
			}
			l = Std.downcast(l.next, Light);
		}
		while( tmpLights.length > pos ) tmpLights.pop();
		tmpLights.sort(function(l1,l2) { return sortingCriteria(l1, l2, ctx.camera.target); });
		return tmpLights;
	}

	public function fillLights (lights : Array<Light>, shadows : Bool) {
		if (lights == null)
			return;
		cascadeLight = null;

		var reserved = CASCADE_SHADOW_INFO_SIZE + MAX_POINT_SHADOW * CUBE_SHADOW_STRIDE + MAX_SPOT_SHADOW * SPOT_SHADOW_STRIDE;
		var budget = BUFFER_MAX_SIZE - reserved;

		var curSize = 0;
		for (l in lights) {
			var dl = Std.downcast(l, DirLight);
			if(dl != null) {
				var hasShadow = dl.shadows != null && dl.shadows.enabled && dl.shadows.mode != None && shadows;
				var cascade = hasShadow ? Std.downcast(dl.shadows, CascadeShadowMap) : null;
				if( cascade != null ) {
					if( cascadeLight == null )
						cascadeLight = dl;
				} else if( curSize + DIR_LIGHT_INFO_SIZE <= budget ) {
					curSize += DIR_LIGHT_INFO_SIZE;
					if( hasShadow && dirLightsShadow.length < MAX_DIR_SHADOW )
						dirLightsShadow.push(dl);
					else
						dirLights.push(dl);
				}
				continue;
			}

			var pl = Std.downcast(l, PointLight);
			if (pl != null) {
				if ( curSize + POINT_LIGHT_STRIDE <= budget ) {
					curSize += POINT_LIGHT_STRIDE;
					var hasShadow = pl.shadows != null && pl.shadows.enabled && pl.shadows.mode != None && shadows;
					if (hasShadow && pointLightsShadow.length < MAX_POINT_SHADOW)
						pointLightsShadow.push(pl);
					else
						pointLights.push(pl);
				}
				continue;
			}

			var sl = Std.downcast(l, SpotLight);
			if (sl != null) {
				if ( curSize + SPOT_LIGHT_STRIDE <= budget ) {
					curSize += SPOT_LIGHT_STRIDE;
					var hasShadow = sl.shadows != null && sl.shadows.enabled && sl.shadows.mode != None && shadows;
					if (hasShadow && spotLightsShadow.length < MAX_SPOT_SHADOW)
						spotLightsShadow.push(sl);
					else
						spotLights.push(sl);
				}
				continue;
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

		inline function shadowParam( shadows : h3d.pass.Shadows ) {
			return shadows.samplingKind == PCF ? shadows.pcfScale / shadows.size : shadows.power;
		}

		inline function fillColor( i : Int, color : h3d.Vector, intensity : Float ) {
			// drop toColor()'s alpha byte so the value stays exact as a float
			lightInfos[i+0] = color.toColor() & 0xFFFFFF;
			lightInfos[i+1] = intensity;
		}

		inline function fillDirCommon( i : Int, color : h3d.Vector, intensity : Float, shadows : h3d.pass.Shadows ) {
			fillColor(i, color, intensity);
			lightInfos[i+2] = shadows == null ? 0.0 : shadowParam(shadows);
			lightInfos[i+3] = shadows == null ? -1.0 : shadows.samplingKind;
		}

		inline function fillShadowCommon( i : Int, shadows : h3d.pass.Shadows, extra : Float ) {
			lightInfos[i+0] = shadows.bias;
			lightInfos[i+1] = extra;
			lightInfos[i+2] = shadowParam(shadows);
			lightInfos[i+3] = shadows.samplingKind;
		}

		// Safe Reset
		for( i in 0 ... lightInfos.length )
			lightInfos[i] = 0;

		var lights = sortLights(ctx);
		fillLights(lights, pbrRenderer.shadows);

		var pointShadowCount = pointLightsShadow.length;
		var spotShadowCount = spotLightsShadow.length;
		var dirTotal = dirLightsShadow.length + dirLights.length;
		var cascadeLightStride = dirTotal * DIR_LIGHT_INFO_SIZE;
		var pointLightOffset = cascadeLightStride + (cascadeLight != null ? CASCADE_SHADOW_INFO_SIZE : 0);
		var spotLightOffset = pointLightOffset + (pointShadowCount + pointLights.length) * POINT_LIGHT_STRIDE;
		var cubeShadowOffset = spotLightOffset + (spotShadowCount + spotLights.length) * SPOT_LIGHT_STRIDE;
		var spotShadowOffset = cubeShadowOffset + pointShadowCount * CUBE_SHADOW_STRIDE;
		s.cascadeLightStride = cascadeLightStride;
		s.pointLightOffset = pointLightOffset;
		s.spotLightOffset = spotLightOffset;
		s.cubeShadowOffset = cubeShadowOffset;
		s.spotShadowOffset = spotShadowOffset;

		// Dir Light With Shadow
		for (li in 0...dirLightsShadow.length) {
			var dl = dirLightsShadow[li];
			var pbr = @:privateAccess dl.pbr;
			var i = (li * DIR_LIGHT_INFO_SIZE) << 2;
			fillDirCommon(i, dl.color, dl.getIntensity(), dl.shadows);
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+7] = dl.shadows.bias;
			s.dirShadowMaps[li] = dl.shadows.getShadowTex();
			var mat = dl.shadows.getShadowViewProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
		}

		// Dir Light
		for (li in 0...dirLights.length) {
			var dl = dirLights[li];
			var i = ((dirLightsShadow.length + li) * DIR_LIGHT_INFO_SIZE) << 2;
			var pbr = @:privateAccess dl.pbr;
			fillDirCommon(i, dl.color, dl.getIntensity(), null);
			fillVector(lightInfos, pbr.lightDir, i+4);
		}

		// Point Light With Shadows
		for (li in 0...pointLightsShadow.length) {
			var pl = pointLightsShadow[li];
			var i = (pointLightOffset + li * POINT_LIGHT_STRIDE) << 2;
			var pbr = @:privateAccess pl.pbr;
			fillColor(i, pl.color, pl.getIntensity());
			lightInfos[i+2] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillShadowCommon((cubeShadowOffset + li * CUBE_SHADOW_STRIDE) << 2, pl.shadows, pl.range);
			s.pointShadowMaps[li] = pl.shadows.getShadowTex();
		}

		// Point Light
		for (li in 0...pointLights.length) {
			var pl = pointLights[li];
			var i = (pointLightOffset + (pointShadowCount + li) * POINT_LIGHT_STRIDE) << 2;
			var pbr = @:privateAccess pl.pbr;
			fillColor(i, pl.color, pl.getIntensity());
			lightInfos[i+2] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
		}

		// Spot Light With Shadow
		for (li in 0...spotLightsShadow.length) {
			var sl = spotLightsShadow[li];
			var i = (spotLightOffset + li * SPOT_LIGHT_STRIDE) << 2;
			var pbr = @:privateAccess sl.pbr;
			fillColor(i, sl.color, sl.getIntensity());
			lightInfos[i+2] = pbr.angle;
			lightInfos[i+3] = pbr.fallOff;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+11] = pbr.range;
			var si = (spotShadowOffset + li * SPOT_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, sl.shadows, 0.0);
			var mat = sl.shadows.getShadowViewProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, si+4);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, si+8);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, si+12);
			fillFloats(lightInfos, mat._14, mat._24, mat._34, mat._44, si+16);
			s.spotShadowMaps[li] = sl.shadows.getShadowTex();
		}

		// Spot Light
		for (li in 0...spotLights.length) {
			var sl = spotLights[li];
			var i = (spotLightOffset + (spotShadowCount + li) * SPOT_LIGHT_STRIDE) << 2;
			var pbr = @:privateAccess sl.pbr;
			fillColor(i, sl.color, sl.getIntensity());
			lightInfos[i+2] = pbr.angle;
			lightInfos[i+3] = pbr.fallOff;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+11] = pbr.range;
		}

		// Cascade shadows
		if ( cascadeLight != null ) {
			var i = cascadeLightStride << 2;
			var pbr = @:privateAccess cascadeLight.pbr;
			var cascadeShadow = cast(cascadeLight.shadows, CascadeShadowMap);
			fillDirCommon(i, cascadeLight.color, cascadeLight.getIntensity(), cascadeShadow);
			fillVector(lightInfos, pbr.lightDir, i+4);
			lightInfos[i+7] = cascadeShadow.transitionFraction;
			s.cascadeShadowMaps = cascadeShadow.getShadowTex();
			s.CASCADE_COUNT = cascadeShadow.cascade;
			var mat = cascadeShadow.cascadeViewProj;
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, i+8);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, i+12);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, i+16);
			for ( index in 0...cascadeShadow.cascade ) {
				fillVector4(lightInfos, cascadeShadow.getCascadeScale(index), i + 20 + index * 8);
				fillVector4(lightInfos, cascadeShadow.getCascadeOffset(index), i + 24 + index * 8);
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
		while( pointLights.length > 0 ) pointLights.pop();
		while( spotLights.length > 0 ) spotLights.pop();
		while( dirLights.length > 0 ) dirLights.pop();
		while( pointLightsShadow.length > 0 ) pointLightsShadow.pop();
		while( spotLightsShadow.length > 0 ) spotLightsShadow.pop();
		while( dirLightsShadow.length > 0 ) dirLightsShadow.pop();
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
