package h3d.scene.pbr;

import h3d.pass.CascadeShadowMap;

class LightBuffer {

	public var defaultForwardShader = new h3d.shader.pbr.DefaultForward();

	var useBindless : Bool;
	var useDynamicSamplerIndex : Bool;
	public var shadowHandles : Array<h3d.mat.TextureHandle> = [];

	var MAX_DIR_SHADOW = 1;
	var MAX_SPOT_SHADOW = 2;
	var MAX_POINT_SHADOW = 2;
	var MAX_CAPSULE_SHADOW = 1;
	var MAX_RECT_SHADOW = 1;

	var cascadeLight : DirLight;
	var dirLightsShadow : Array<DirLight> = [];
	var dirLights : Array<DirLight> = [];
	var pointLightsShadow : Array<PointLight> = [];
	var pointLights : Array<PointLight> = [];
	var spotLightsShadow : Array<SpotLight> = [];
	var spotLights : Array<SpotLight> = [];
	var capsuleLightsShadow : Array<CapsuleLight> = [];
	var capsuleLights : Array<CapsuleLight> = [];
	var rectLightsShadow : Array<RectangleLight> = [];
	var rectLights : Array<RectangleLight> = [];

	var lightInfos : hxd.FloatBuffer;
	// Keep in sync with h3d.shader.pbr.DefaultForward
	final DIR_LIGHT_STRIDE     = 2;
	final POINT_LIGHT_STRIDE   = 2;
	final SPOT_LIGHT_STRIDE    = 3;
	final CAPSULE_LIGHT_STRIDE = 3;
	final RECT_LIGHT_STRIDE    = 6;

	final DIR_SHADOW_STRIDE    = 5;
	final SPOT_SHADOW_STRIDE   = 6;
	final CUBE_SHADOW_STRIDE   = 2;

	final CASCADE_SHADOW_STRIDE = 13;
	final BUFFER_MAX_SIZE = 4096;

	// Keep in sync with h3d.shader.pbr.ClusterCull
	final CLUSTER_COUNT = 16 * 9 * 24;
	final CLUSTER_Z = 24;
	final CLUSTER_STRIDE = 128;

	public var clusterMaxDistance = 0.;
	public var enableClustering = true;
	var cullShader : h3d.shader.pbr.ClusterCull;
	var clusterBuffer : h3d.Buffer;

	// Camera of the last built clusters, for createClusterDebug
	var hasClusterCamera = false;
	var clusterInvView = new h3d.Matrix();
	var clusterInvProj = new h3d.Matrix();
	var clusterNear = 0.;
	var clusterFar = 0.;

	public function new() {
		var engine = h3d.Engine.getCurrent();
		useBindless = engine != null && engine.driver.hasFeature(Bindless);
		useDynamicSamplerIndex = engine != null && engine.driver.hasFeature(DynamicSamplerIndex);
		defaultForwardShader.USE_BINDLESS = useBindless;
		defaultForwardShader.DYNAMIC_SAMPLER_INDEX = useDynamicSamplerIndex;
		createBuffers();
	}

	function createBuffers() {
		lightInfos = new hxd.FloatBuffer(BUFFER_MAX_SIZE << 2);
		defaultForwardShader.lightInfos = new h3d.Buffer(BUFFER_MAX_SIZE, hxd.BufferFormat.make([{ name : "uniformData", type : DVec4 }]), [UniformBuffer, Dynamic]);
	}

	public function setBuffers( s : h3d.shader.pbr.DefaultForward ) {
		s.cameraPosition = defaultForwardShader.cameraPosition;
		s.emissivePower = defaultForwardShader.emissivePower;
		s.lightInfos = defaultForwardShader.lightInfos;

		s.dirLightCount = defaultForwardShader.dirLightCount;
		s.dirLightOffset = defaultForwardShader.dirLightOffset;
		s.dirShadowCount = defaultForwardShader.dirShadowCount;
		s.dirShadowOffset = defaultForwardShader.dirShadowOffset;

		s.pointLightOffset = defaultForwardShader.pointLightOffset;
		s.pointLightCount = defaultForwardShader.pointLightCount;
		s.pointShadowCount = defaultForwardShader.pointShadowCount;
		s.pointShadowOffset = defaultForwardShader.pointShadowOffset;

		s.spotLightCount = defaultForwardShader.spotLightCount;
		s.spotLightOffset = defaultForwardShader.spotLightOffset;
		s.spotShadowCount = defaultForwardShader.spotShadowCount;
		s.spotShadowOffset = defaultForwardShader.spotShadowOffset;

		s.capsuleLightCount = defaultForwardShader.capsuleLightCount;
		s.capsuleLightOffset = defaultForwardShader.capsuleLightOffset;
		s.capsuleShadowCount = defaultForwardShader.capsuleShadowCount;
		s.capsuleShadowOffset = defaultForwardShader.capsuleShadowOffset;

		s.rectLightCount = defaultForwardShader.rectLightCount;
		s.rectLightOffset = defaultForwardShader.rectLightOffset;
		s.rectShadowCount = defaultForwardShader.rectShadowCount;
		s.rectShadowOffset = defaultForwardShader.rectShadowOffset;

		s.USE_BINDLESS = defaultForwardShader.USE_BINDLESS;
		s.DYNAMIC_SAMPLER_INDEX = defaultForwardShader.DYNAMIC_SAMPLER_INDEX;
		s.CLUSTERED = defaultForwardShader.CLUSTERED;
		if( s.CLUSTERED ) {
			s.clusterData = defaultForwardShader.clusterData;
			s.clusterZParams = defaultForwardShader.clusterZParams;
		}
		s.MAX_DIR_SHADOW_COUNT = defaultForwardShader.MAX_DIR_SHADOW_COUNT;
		s.MAX_POINT_SHADOW_COUNT = defaultForwardShader.MAX_POINT_SHADOW_COUNT;
		s.MAX_SPOT_SHADOW_COUNT = defaultForwardShader.MAX_SPOT_SHADOW_COUNT;
		s.MAX_CAPSULE_SHADOW_COUNT = defaultForwardShader.MAX_CAPSULE_SHADOW_COUNT;
		s.MAX_RECT_SHADOW_COUNT = defaultForwardShader.MAX_RECT_SHADOW_COUNT;
		s.CASCADE_COUNT = defaultForwardShader.CASCADE_COUNT;

		for( i in 0 ... defaultForwardShader.MAX_POINT_SHADOW_COUNT )
			s.pointShadowMaps[i] = defaultForwardShader.pointShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_SPOT_SHADOW_COUNT )
			s.spotShadowMaps[i] = defaultForwardShader.spotShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_DIR_SHADOW_COUNT )
			s.dirShadowMaps[i] = defaultForwardShader.dirShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_CAPSULE_SHADOW_COUNT )
			s.capsuleShadowMaps[i] = defaultForwardShader.capsuleShadowMaps[i];
		for( i in 0 ... defaultForwardShader.MAX_RECT_SHADOW_COUNT )
			s.rectShadowMaps[i] = defaultForwardShader.rectShadowMaps[i];
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
		tmpLights.resize(pos);
		tmpLights.sort(function(l1,l2) { return sortingCriteria(l1, l2, ctx.camera.target); });
		return tmpLights;
	}

	public function fillLights (lights : Array<Light>, shadows : Bool) {
		if (lights == null)
			return;
		cascadeLight = null;

		var reserved = useBindless ? CASCADE_SHADOW_STRIDE
			: CASCADE_SHADOW_STRIDE + MAX_DIR_SHADOW * DIR_SHADOW_STRIDE
			+ (MAX_POINT_SHADOW + MAX_CAPSULE_SHADOW) * CUBE_SHADOW_STRIDE
			+ (MAX_SPOT_SHADOW + MAX_RECT_SHADOW) * SPOT_SHADOW_STRIDE;
		var budget = BUFFER_MAX_SIZE - reserved;

		var curSize = 0;

		inline function hasShadow( l : Light ) {
			return l.shadows != null && l.shadows.enabled && l.shadows.mode != None && shadows;
		}

		inline function addLight<T:Light>( l : T, list : Array<T>, shadowList : Array<T>, maxShadow : Int, stride : Int, shadowStride : Int ) {
			var shadowed = hasShadow(l) && (useBindless || shadowList.length < maxShadow);
			var need = stride + (useBindless && shadowed ? shadowStride : 0);
			if( curSize + need <= budget ) {
				curSize += need;
				if( shadowed )
					shadowList.push(l);
				else
					list.push(l);
			}
		}

		for (l in lights) {
			var dl = Std.downcast(l, DirLight);
			if(dl != null) {
				var cascade = hasShadow(dl) ? Std.downcast(dl.shadows, CascadeShadowMap) : null;
				if( cascade != null ) {
					if( cascadeLight == null )
						cascadeLight = dl;
				} else
					addLight(dl, dirLights, dirLightsShadow, MAX_DIR_SHADOW, DIR_LIGHT_STRIDE, DIR_SHADOW_STRIDE);
				continue;
			}

			var pl = Std.downcast(l, PointLight);
			if (pl != null) {
				addLight(pl, pointLights, pointLightsShadow, MAX_POINT_SHADOW, POINT_LIGHT_STRIDE, CUBE_SHADOW_STRIDE);
				continue;
			}

			var sl = Std.downcast(l, SpotLight);
			if (sl != null) {
				addLight(sl, spotLights, spotLightsShadow, MAX_SPOT_SHADOW, SPOT_LIGHT_STRIDE, SPOT_SHADOW_STRIDE);
				continue;
			}

			var cl = Std.downcast(l, CapsuleLight);
			if (cl != null) {
				addLight(cl, capsuleLights, capsuleLightsShadow, MAX_CAPSULE_SHADOW, CAPSULE_LIGHT_STRIDE, CUBE_SHADOW_STRIDE);
				continue;
			}

			var rl = Std.downcast(l, RectangleLight);
			if (rl != null) {
				addLight(rl, rectLights, rectLightsShadow, MAX_RECT_SHADOW, RECT_LIGHT_STRIDE, SPOT_SHADOW_STRIDE);
				continue;
			}
		}
	}

	public function sync( ctx : h3d.scene.RenderContext ) {
		shadowHandles.resize(0);

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
		s.CLUSTERED = false;

		inline function shadowParam( shadows : h3d.pass.Shadows ) {
			return shadows.samplingKind == PCF ? shadows.pcfScale / shadows.size : shadows.power;
		}

		inline function fillColor( i : Int, color : h3d.Vector, intensity : Float ) {
			// drop toColor()'s alpha byte so the value stays exact as a float
			lightInfos[i+0] = color.toColor() & 0xFFFFFF;
			lightInfos[i+1] = intensity;
		}

		inline function fillShadowTex( si : Int, handleOffset : Int, tex : h3d.mat.Texture ) : Bool {
			if( tex == null ) {
				lightInfos[si+3] = -1;
				return false;
			}
			if( useBindless ) {
				var h = tex.getHandle();
				shadowHandles.push(h);
				lightInfos[si+handleOffset+0] = h.handle.low;
				lightInfos[si+handleOffset+1] = h.handle.high;
			}
			return true;
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

		var dirShadowCount = dirLightsShadow.length;
		var pointShadowCount = pointLightsShadow.length;
		var spotShadowCount = spotLightsShadow.length;
		var dirLightOffset = cascadeLight != null ? CASCADE_SHADOW_STRIDE : 0;
		var pointLightOffset = dirLightOffset + (dirLightsShadow.length + dirLights.length) * DIR_LIGHT_STRIDE;
		var spotLightOffset = pointLightOffset + (pointShadowCount + pointLights.length) * POINT_LIGHT_STRIDE;
		var capsuleShadowCount = capsuleLightsShadow.length;
		var rectShadowCount = rectLightsShadow.length;
		var capsuleLightOffset = spotLightOffset + (spotShadowCount + spotLights.length) * SPOT_LIGHT_STRIDE;
		var rectLightOffset = capsuleLightOffset + (capsuleShadowCount + capsuleLights.length) * CAPSULE_LIGHT_STRIDE;
		var dirShadowOffset = rectLightOffset + (rectShadowCount + rectLights.length) * RECT_LIGHT_STRIDE;
		var pointShadowOffset = dirShadowOffset + dirShadowCount * DIR_SHADOW_STRIDE;
		var capsuleShadowOffset = pointShadowOffset + pointShadowCount * CUBE_SHADOW_STRIDE;
		var spotShadowOffset = capsuleShadowOffset + capsuleShadowCount * CUBE_SHADOW_STRIDE;
		var rectShadowOffset = spotShadowOffset + spotShadowCount * SPOT_SHADOW_STRIDE;

		s.dirLightOffset = dirLightOffset;
		s.pointLightOffset = pointLightOffset;
		s.spotLightOffset = spotLightOffset;
		s.capsuleLightOffset = capsuleLightOffset;
		s.rectLightOffset = rectLightOffset;
		s.dirShadowOffset = dirShadowOffset;
		s.pointShadowOffset = pointShadowOffset;
		s.spotShadowOffset = spotShadowOffset;
		s.capsuleShadowOffset = capsuleShadowOffset;
		s.rectShadowOffset = rectShadowOffset;

		// Dir Light
		inline function fillDir(i : Int, dl : DirLight) {
			var pbr = @:privateAccess dl.pbr;
			fillColor(i, dl.color, dl.getIntensity());
			fillVector(lightInfos, pbr.lightDir, i+4);
		}

		for (li in 0...dirLightsShadow.length) {
			var dl = dirLightsShadow[li];
			fillDir((dirLightOffset + li * DIR_LIGHT_STRIDE) << 2, dl);
			var si = (dirShadowOffset + li * DIR_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, dl.shadows, 0.0);
			var tex = dl.shadows.getShadowTex();
			if( !fillShadowTex(si, 16, tex) ) continue;
			if( !useBindless ) s.dirShadowMaps[li] = tex;
			var mat = dl.shadows.getShadowViewProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, si+4);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, si+8);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, si+12);
		}

		for (li in 0...dirLights.length)
			fillDir((dirLightOffset + (dirLightsShadow.length + li) * DIR_LIGHT_STRIDE) << 2, dirLights[li]);

		// Point Light
		inline function fillPoint(i : Int, pl : PointLight) {
			var pbr = @:privateAccess pl.pbr;
			fillColor(i, pl.color, pl.getIntensity());
			lightInfos[i+2] = pbr.pointSize;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
		}

		for (li in 0...pointLightsShadow.length) {
			var pl = pointLightsShadow[li];
			fillPoint((pointLightOffset + li * POINT_LIGHT_STRIDE) << 2, pl);
			var si = (pointShadowOffset + li * CUBE_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, pl.shadows, pl.range);
			var tex = pl.shadows.getShadowTex();
			if( !fillShadowTex(si, 4, tex) ) continue;
			if( !useBindless ) s.pointShadowMaps[li] = tex;
		}

		for (li in 0...pointLights.length)
			fillPoint((pointLightOffset + (pointShadowCount + li) * POINT_LIGHT_STRIDE) << 2, pointLights[li]);

		// Spot Light
		inline function fillSpot( i : Int, sl : SpotLight ) {
			var pbr = @:privateAccess sl.pbr;
			fillColor(i, sl.color, sl.getIntensity());
			lightInfos[i+2] = pbr.angle;
			lightInfos[i+3] = pbr.fallOff;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.spotDir, i+8);
			lightInfos[i+11] = pbr.range;
		}

		for (li in 0...spotLightsShadow.length) {
			var sl = spotLightsShadow[li];
			fillSpot((spotLightOffset + li * SPOT_LIGHT_STRIDE) << 2, sl);
			var si = (spotShadowOffset + li * SPOT_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, sl.shadows, 0.0);
			var tex = sl.shadows.getShadowTex();
			if( !fillShadowTex(si, 20, tex) ) continue;
			var mat = sl.shadows.getShadowViewProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, si+4);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, si+8);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, si+12);
			fillFloats(lightInfos, mat._14, mat._24, mat._34, mat._44, si+16);
			if( !useBindless ) s.spotShadowMaps[li] = tex;
		}

		for (li in 0...spotLights.length)
			fillSpot((spotLightOffset + (spotShadowCount + li) * SPOT_LIGHT_STRIDE) << 2, spotLights[li]);

		// Capsule Light
		inline function fillCapsule( i : Int, cl : CapsuleLight ) {
			var pbr = @:privateAccess cl.pbr;
			fillColor(i, cl.color, cl.getIntensity());
			lightInfos[i+2] = pbr.radius;
			lightInfos[i+3] = pbr.halfLength;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invRange4;
			fillVector(lightInfos, pbr.left, i+8);
		}

		for (li in 0...capsuleLightsShadow.length) {
			var cl = capsuleLightsShadow[li];
			fillCapsule((capsuleLightOffset + li * CAPSULE_LIGHT_STRIDE) << 2, cl);
			var si = (capsuleShadowOffset + li * CUBE_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, cl.shadows, cl.range + cl.length);
			var tex = cl.shadows.getShadowTex();
			if( !fillShadowTex(si, 4, tex) ) continue;
			if( !useBindless ) s.capsuleShadowMaps[li] = tex;
		}

		for (li in 0...capsuleLights.length)
			fillCapsule((capsuleLightOffset + (capsuleShadowCount + li) * CAPSULE_LIGHT_STRIDE) << 2, capsuleLights[li]);

		// Rectangle Light
		inline function fillRect( i : Int, rl : RectangleLight ) {
			var pbr = @:privateAccess rl.pbr;
			fillColor(i, rl.color, rl.getIntensity());
			lightInfos[i+2] = pbr.halfSize.x;
			lightInfos[i+3] = pbr.halfSize.y;
			fillVector(lightInfos, pbr.lightPos, i+4);
			lightInfos[i+7] = pbr.invLightRange4;
			fillVector(lightInfos, pbr.lightDir, i+8);
			lightInfos[i+11] = pbr.range;
			fillVector(lightInfos, pbr.right, i+12);
			lightInfos[i+15] = pbr.horizontalAngle;
			fillVector(lightInfos, pbr.up, i+16);
			lightInfos[i+19] = pbr.horizontalFallOff;
			lightInfos[i+20] = pbr.verticalAngle;
			lightInfos[i+21] = pbr.verticalFallOff;
		}

		for (li in 0...rectLightsShadow.length) {
			var rl = rectLightsShadow[li];
			fillRect((rectLightOffset + li * RECT_LIGHT_STRIDE) << 2, rl);
			var si = (rectShadowOffset + li * SPOT_SHADOW_STRIDE) << 2;
			fillShadowCommon(si, rl.shadows, 0.0);
			var tex = rl.shadows.getShadowTex();
			if( !fillShadowTex(si, 20, tex) ) continue;
			var mat = rl.shadows.getShadowViewProj();
			fillFloats(lightInfos, mat._11, mat._21, mat._31, mat._41, si+4);
			fillFloats(lightInfos, mat._12, mat._22, mat._32, mat._42, si+8);
			fillFloats(lightInfos, mat._13, mat._23, mat._33, mat._43, si+12);
			fillFloats(lightInfos, mat._14, mat._24, mat._34, mat._44, si+16);
			if( !useBindless ) s.rectShadowMaps[li] = tex;
		}

		for (li in 0...rectLights.length)
			fillRect((rectLightOffset + (rectShadowCount + li) * RECT_LIGHT_STRIDE) << 2, rectLights[li]);

		// Cascade shadows
		if ( cascadeLight != null ) {
			var i = 0;
			var pbr = @:privateAccess cascadeLight.pbr;
			var cascadeShadow = cast(cascadeLight.shadows, CascadeShadowMap);
			fillColor(i, cascadeLight.color, cascadeLight.getIntensity());
			lightInfos[i+2] = shadowParam(cascadeShadow);
			lightInfos[i+3] = cascadeShadow.samplingKind;
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
		s.capsuleLightCount = capsuleLights.length;
		s.rectLightCount = rectLights.length;
		s.MAX_DIR_SHADOW_COUNT = MAX_DIR_SHADOW;
		s.MAX_POINT_SHADOW_COUNT = MAX_POINT_SHADOW;
		s.MAX_SPOT_SHADOW_COUNT = MAX_SPOT_SHADOW;
		s.MAX_CAPSULE_SHADOW_COUNT = MAX_CAPSULE_SHADOW;
		s.MAX_RECT_SHADOW_COUNT = MAX_RECT_SHADOW;
		s.dirShadowCount = dirLightsShadow.length;
		s.pointShadowCount = pointLightsShadow.length;
		s.spotShadowCount = spotLightsShadow.length;
		s.capsuleShadowCount = capsuleLightsShadow.length;
		s.rectShadowCount = rectLightsShadow.length;
		s.lightInfos.uploadFloats(lightInfos, 0, s.lightInfos.vertices, 0);
		cull(ctx);
		pointLights.resize(0);
		spotLights.resize(0);
		dirLights.resize(0);
		pointLightsShadow.resize(0);
		spotLightsShadow.resize(0);
		dirLightsShadow.resize(0);
		capsuleLights.resize(0);
		capsuleLightsShadow.resize(0);
		rectLights.resize(0);
		rectLightsShadow.resize(0);
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

	function cull( ctx : h3d.scene.RenderContext ) {
		var engine = h3d.Engine.getCurrent();
		if( !enableClustering || !engine.driver.hasFeature(ComputeShaders) )
			return;
		var s = defaultForwardShader;
		var total = s.pointLightCount + s.pointShadowCount + s.spotLightCount + s.spotShadowCount
			+ s.capsuleLightCount + s.capsuleShadowCount + s.rectLightCount + s.rectShadowCount;
		if( total == 0 )
			return;

		if( clusterBuffer == null || clusterBuffer.isDisposed() )
			clusterBuffer = new h3d.Buffer(CLUSTER_COUNT * CLUSTER_STRIDE, hxd.BufferFormat.INDEX32, [UniformBuffer, ReadWriteBuffer]);
		if( cullShader == null )
			cullShader = new h3d.shader.pbr.ClusterCull();

		var cam = ctx.camera;
		var near = cam.zNear;
		var far = clusterMaxDistance > 0 ? clusterMaxDistance : cam.zFar;
		if( far <= near ) far = near * 2;
		clusterInvView.load(cam.getInverseView());
		clusterInvProj.load(cam.getInverseProj());
		clusterNear = near;
		clusterFar = far;
		hasClusterCamera = true;

		var c = cullShader;
		c.lightInfos = s.lightInfos;
		c.clusterData = clusterBuffer;
		c.clusterNear = near;
		c.clusterFarOverNear = far / near;
		c.clusterLastSliceFar = clusterMaxDistance > 0 ? 1e30 : far;
		c.pointLightOffset = s.pointLightOffset;
		c.pointStart = useBindless ? 0 : s.pointShadowCount;
		c.pointEnd = s.pointShadowCount + s.pointLightCount;
		c.spotLightOffset = s.spotLightOffset;
		c.spotStart = useBindless ? 0 : s.spotShadowCount;
		c.spotEnd = s.spotShadowCount + s.spotLightCount;
		c.capsuleLightOffset = s.capsuleLightOffset;
		c.capsuleStart = useBindless ? 0 : s.capsuleShadowCount;
		c.capsuleEnd = s.capsuleShadowCount + s.capsuleLightCount;
		c.rectLightOffset = s.rectLightOffset;
		c.rectStart = useBindless ? 0 : s.rectShadowCount;
		c.rectEnd = s.rectShadowCount + s.rectLightCount;
		ctx.computeDispatch(c, Math.ceil(CLUSTER_COUNT / 64));

		var zScale = CLUSTER_Z / Math.log(far / near);
		s.clusterData = clusterBuffer;
		s.clusterZParams.set(zScale, -Math.log(near) * zScale);
		s.CLUSTERED = true;
	}

	public function createClusterDebug( ?parent : h3d.scene.Object ) : h3d.scene.Graphics {
		if( clusterBuffer == null || clusterBuffer.isDisposed() || !hasClusterCamera )
			return null;
		var clusterX = 16, clusterY = 9;
		var heatMax = 32.;
		var bytes = haxe.io.Bytes.alloc(CLUSTER_COUNT * CLUSTER_STRIDE * 4);
		clusterBuffer.readBytes(bytes, 0, CLUSTER_COUNT * CLUSTER_STRIDE);

		inline function unproject( x : Float, y : Float, z : Float ) {
			var v = new h3d.Vector4(x, y, z, 1);
			v.transform(clusterInvProj);
			return new h3d.Vector(v.x / v.w, v.y / v.w, v.z / v.w);
		}
		function corner( tx : Int, ty : Int, z : Float ) {
			var x = tx / clusterX * 2 - 1, y = ty / clusterY * 2 - 1;
			var a = unproject(x, y, 0), b = unproject(x, y, 0.5);
			var t = (z - a.z) / (b.z - a.z);
			var p = new h3d.Vector(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, z);
			return p.transformed(clusterInvView);
		}
		inline function sliceDepth( z : Int ) {
			return z == 0 ? clusterNear : clusterNear * Math.pow(clusterFar / clusterNear, z / CLUSTER_Z);
		}
		inline function channel( v : Float ) {
			return Std.int(hxd.Math.clamp(v) * 255);
		}
		function heat( t : Float ) {
			var j = 0.125 + hxd.Math.clamp(t) * 0.75;
			return (channel(1.5 - Math.abs(4 * j - 3)) << 16) | (channel(1.5 - Math.abs(4 * j - 2)) << 8) | channel(1.5 - Math.abs(4 * j - 1));
		}

		var g = new h3d.scene.Graphics(parent);
		g.name = "clusterDebug";
		g.material.mainPass.setPassName("overlay");
		g.ignoreBounds = true;

		function box( x0 : Int, y0 : Int, x1 : Int, y1 : Int, z0 : Float, z1 : Float, color : Int ) {
			var n = [corner(x0, y0, z0), corner(x1, y0, z0), corner(x1, y1, z0), corner(x0, y1, z0)];
			var f = [corner(x0, y0, z1), corner(x1, y0, z1), corner(x1, y1, z1), corner(x0, y1, z1)];
			g.lineStyle(1, color);
			for( i in 0...4 ) {
				var j = (i + 1) % 4;
				g.moveTo(n[i].x, n[i].y, n[i].z); g.lineTo(n[j].x, n[j].y, n[j].z);
				g.moveTo(f[i].x, f[i].y, f[i].z); g.lineTo(f[j].x, f[j].y, f[j].z);
				g.moveTo(n[i].x, n[i].y, n[i].z); g.lineTo(f[i].x, f[i].y, f[i].z);
			}
		}

		for( z in 0...CLUSTER_Z )
			for( y in 0...clusterY )
				for( x in 0...clusterX ) {
					var counts = bytes.getInt32(((z * clusterY + y) * clusterX + x) * CLUSTER_STRIDE * 4);
					var count = (counts & 0xFF) + ((counts >> 8) & 0xFF) + ((counts >> 16) & 0xFF) + ((counts >>> 24) & 0xFF);
					if( count == 0 )
						continue;
					box(x, y, x + 1, y + 1, sliceDepth(z), sliceDepth(z + 1), count >= CLUSTER_STRIDE - 1 ? 0xFF00FF : heat(count / heatMax));
				}
		box(0, 0, clusterX, clusterY, clusterNear, clusterFar, 0xFFFFFF);
		return g;
	}

	public function dispose() {
		defaultForwardShader.lightInfos.dispose();
		if( clusterBuffer != null ) {
			clusterBuffer.dispose();
			clusterBuffer = null;
		}
	}
}
