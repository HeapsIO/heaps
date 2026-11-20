package h3d.scene.pbr;

class Froxels {

	public var debugMode = 0;
	public var raymarchBlend = false;
	public var pointLights = true;
	public var spotLights = true;
	public var temporal = true;
	public var temporalBlend = 0.05;
	public var near(default, null) = 1.0;
	public var far(default, null) = 200.0;
	public var cellPixelSize = 12;
	public var sizeZ = 64;
	public var sizeX(default, null) = 160;
	public var sizeY(default, null) = 90;
	public var lightingVolume(default, null) : h3d.mat.Texture3D;
	public var historyVolume(default, null) : h3d.mat.Texture3D;
	public var integratedVolume(default, null) : h3d.mat.Texture3D;

	var size = new h3d.Vector(160, 90, 64);
	var store = new h3d.shader.pbr.Froxels.FroxelStore();
	var lighting = new h3d.shader.pbr.Froxels.FroxelLighting();
	var integrate = new h3d.shader.pbr.Froxels.FroxelIntegrate();
	var mediumList = new hxsl.ShaderList(null);
	var lightingList : hxsl.ShaderList;
	var storeList : hxsl.ShaderList;
	var debugPass : h3d.pass.ScreenFx<h3d.shader.pbr.Froxels.FroxelDebug>;
	var applyPass : h3d.pass.ScreenFx<h3d.shader.pbr.Froxels.FroxelApply>;
	var updateFrame = -1;
	var jitterIndex = 0;

	public function new() {
		lightingList = new hxsl.ShaderList(lighting);
		storeList = new hxsl.ShaderList(store, lightingList);
	}

	static function halton( index : Int, base : Int ) : Float {
		var f = 1.0;
		var r = 0.0;
		while( index > 0 ) {
			f /= base;
			r += f * (index % base);
			index = Std.int(index / base);
		}
		return r;
	}

	public function update( r : Renderer, near : Float, far : Float, ?medium : hxsl.Shader ) {
		var ctx = @:privateAccess r.ctx;
		near = Math.max(near, 0.01);
		far = Math.max(far, near * 2);
		var cell = hxd.Math.imax(cellPixelSize, 1);
		sizeX = hxd.Math.imax(Math.ceil(ctx.renderResolutionWidth / cell), 1);
		sizeY = hxd.Math.imax(Math.ceil(ctx.renderResolutionHeight / cell), 1);
		sizeZ = hxd.Math.imax(sizeZ, 1);
		if( lightingVolume != null && (lightingVolume.width != sizeX || lightingVolume.height != sizeY || lightingVolume.layerCount != sizeZ) )
			disposeVolumes();
		size.set(sizeX, sizeY, sizeZ);
		var historyValid = lightingVolume != null && updateFrame == ctx.frame - 1 && near == this.near && far == this.far;
		this.near = near;
		this.far = far;

		if( lightingVolume == null ) {
			lightingVolume = new h3d.mat.Texture3D(sizeX, sizeY, sizeZ, [Writable], RGBA16F);
			lightingVolume.setName("froxelLighting0");
			historyVolume = new h3d.mat.Texture3D(sizeX, sizeY, sizeZ, [Writable], RGBA16F);
			historyVolume.setName("froxelLighting1");
			integratedVolume = new h3d.mat.Texture3D(sizeX, sizeY, sizeZ, [Writable], RGBA16F);
			integratedVolume.setName("froxelIntegrated");
		} else {
			var tmp = historyVolume;
			historyVolume = lightingVolume;
			lightingVolume = tmp;
		}

		if( temporal ) {
			jitterIndex = (jitterIndex % 16) + 1;
			store.jitter.set(halton(jitterIndex, 2), halton(jitterIndex, 3), halton(jitterIndex, 5));
			store.temporalBlend = historyValid ? temporalBlend : 1.0;
		} else {
			store.jitter.set(0.5, 0.5, 0.5);
			store.temporalBlend = 1.0;
		}
		store.historyVolume = historyVolume;

		updateFrame = ctx.frame;
		ctx.setGlobal("froxels.size", size);
		ctx.setGlobal("froxels.near", this.near);
		ctx.setGlobal("froxels.far", this.far);

		@:privateAccess r.mark("Froxels");
		ctx.engine.driver.beginEvent("Froxels");
		store.lightingVolume = lightingVolume;
		var ls = Std.downcast(@:privateAccess r.getLightSystem(), LightSystem);
		if( ls != null )
			ls.lightBuffer.setBuffers(lighting);
		lighting.POINT_LIGHTS = pointLights;
		lighting.SPOT_LIGHTS = spotLights;
		mediumList.s = medium;
		lightingList.next = medium == null ? null : mediumList;
		ctx.computeList(storeList);
		ctx.computeDispatch(null, Math.ceil(sizeX / 8), Math.ceil(sizeY / 8), sizeZ);
		integrate.lightingVolume = lightingVolume;
		integrate.integratedVolume = integratedVolume;
		ctx.computeDispatch(integrate, Math.ceil(sizeX / 8), Math.ceil(sizeY / 8), 1);
		ctx.setGlobal("froxelIntegratedVolume", integratedVolume);
		ctx.engine.driver.endEvent();
	}

	public function isActive( r : Renderer ) {
		return integratedVolume != null && updateFrame == @:privateAccess r.ctx.frame;
	}

	public function apply( r : Renderer ) {
		if( !isActive(r) )
			return;
		if( applyPass == null ) {
			applyPass = new h3d.pass.ScreenFx(new h3d.shader.pbr.Froxels.FroxelApply());
		}
		if( raymarchBlend )
			applyPass.pass.blend(SrcAlpha, OneMinusSrcAlpha);
		else
			applyPass.pass.blend(One, SrcAlpha);
		applyPass.pass.blendAlphaSrc = Zero;
		applyPass.pass.blendAlphaDst = One;
		applyPass.shader.RAYMARCH_BLEND = raymarchBlend;
		@:privateAccess r.mark("FroxelApply");
		applyPass.shader.depthTexture = @:privateAccess r.textures.albedo.depthBuffer;
		applyPass.render();
	}

	public function drawDebug( r : Renderer ) {
		if( lightingVolume == null )
			return;
		if( debugPass == null ) {
			debugPass = new h3d.pass.ScreenFx(new h3d.shader.pbr.Froxels.FroxelDebug());
			debugPass.pass.blend(One, OneMinusSrcAlpha);
		}
		debugPass.shader.SHOW_INTEGRATED = debugMode == 2;
		debugPass.shader.depthTexture = r.getPbrDepth();
		debugPass.shader.lightingVolume = lightingVolume;
		debugPass.shader.integratedVolume = integratedVolume;
		debugPass.render();
	}

	public function sliceDepth( k : Float ) : Float {
		return k <= 0 ? 0 : near * Math.pow(far / near, k / sizeZ);
	}

	public function getInfos() : String {
		inline function fmt( v : Float ) return Std.string(Math.round(v * 100) / 100);
		var lines = ['Froxels ${sizeX}x${sizeY}x${sizeZ} near ${fmt(near)} far ${fmt(far)}' + (lightingVolume == null ? " (not allocated)" : "")];
		var k = 0;
		while( k < sizeZ ) {
			var z0 = sliceDepth(k);
			var z1 = sliceDepth(k + 1);
			lines.push('slice $k : ${fmt(z0)} - ${fmt(z1)} (${fmt(z1 - z0)})');
			k += 8;
		}
		lines.push('slice ${sizeZ - 1} : ${fmt(sliceDepth(sizeZ - 1))} - ${fmt(sliceDepth(sizeZ))} (${fmt(sliceDepth(sizeZ) - sliceDepth(sizeZ - 1))})');
		return lines.join("\n");
	}

	function disposeVolumes() {
		if( lightingVolume != null ) {
			lightingVolume.dispose();
			lightingVolume = null;
			historyVolume.dispose();
			historyVolume = null;
			integratedVolume.dispose();
			integratedVolume = null;
		}
	}

	public function dispose() {
		disposeVolumes();
		if( debugPass != null ) {
			debugPass.dispose();
			debugPass = null;
		}
		if( applyPass != null ) {
			applyPass.dispose();
			applyPass = null;
		}
	}
}
