package h3d.pass;

typedef CascadeParams = {
	var depthBias : Float;
	var slopeBias : Float;
}

typedef CascadeCamera = {
	var viewProj : h3d.Matrix;
	var orthoBounds : h3d.col.Bounds;
}

class CascadeShadowMap extends DirShadowMap {

	var cshader : h3d.shader.CascadeShadow;
	var lightCameras : Array<CascadeCamera> = [];
	var currentCascadeIndex = 0;
	var tmpCorners : Array<h3d.Vector> = [for (i in 0...8) new h3d.Vector()];
	var tmpView = new h3d.Matrix();
	var tmpProj = new h3d.Matrix();
	var tmpFrustum = new h3d.col.Frustum();

	public var params : Array<CascadeParams> = [];
	public var pow : Float = 1.0;
	// minimum count of pixels in ratio of texture width for an object to be drawn in cascade
	public var minPixelRatio : Float = 0.05;
	public var firstCascadeSize : Float = 10.0;
	public var castingMaxDist : Float = 0.0;
	public var cascade(default, set) = 1;
	public var highPrecision : Bool = false;
	public function set_cascade(v) {
		cascade = v;
		lightCameras = [];
		for ( i in 0...cascade )
			lightCameras.push({ viewProj : new h3d.Matrix(), orthoBounds : new h3d.col.Bounds() });
		return cascade;
	}
	public var debugShader : Bool = false;

	static var debugColors = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xff00ff, 0x000000];

	public function new( light : h3d.scene.Light ) {
		super(light);
		format = R32F;
		shader = dshader = cshader = new h3d.shader.CascadeShadow();
	}

	public override function getShadowTex() {
		return cshader.shadowMap;
	}

	public function getShadowTextures() {
		return cshader.cascadeShadowMaps;
	}

	function computeNearFar( i : Int ) {
		if ( i == 0 )
			return {near : 0.0, far : firstCascadeSize};

		var max = maxDist < 0.0 ? ctx.camera.zFar : maxDist;
		var step = (max - firstCascadeSize) / (cascade - 1);
		var near = firstCascadeSize + hxd.Math.pow((i - 1) / (cascade - 1), pow) * step;
		var far = firstCascadeSize + hxd.Math.pow(i / (cascade - 1), pow) * step;
		return {near : near, far : far};
	}

	public function calcCascadeMatrices() {
		var invCamera = ctx.camera.getInverseView();
		var invG = hxd.Math.tan(ctx.camera.fovY / 2.0);
		var sInvG = ctx.camera.screenRatio * invG;
		var invLight = lightCamera.getInverseView();

		for ( i in 0...cascade ) {
			var cascadeBounds = lightCameras[i].orthoBounds;
			cascadeBounds.empty();

			inline function addCorner(x : Float, y : Float, d : Float, i : Int) {
				var pt = tmpCorners[i];
				pt.set( x * (d * sInvG), y * ( d * invG ), d );
				pt.transform( invCamera );
				pt.transform( lightCamera.mcam );
				cascadeBounds.addPos(pt.x, pt.y, pt.z);
			}
			inline function addCorners(d, i) {
				addCorner(-1.0, -1.0, d, i);
				addCorner(-1.0,  1.0, d, i + 1);
				addCorner( 1.0, -1.0, d, i + 2);
				addCorner( 1.0,  1.0, d, i + 3);
			}

			var nearFar = computeNearFar(i);
			addCorners(nearFar.near, 0);
			addCorners(nearFar.far, 4);
			cascadeBounds.zMin = cascadeBounds.zMax - maxDist;

			var d = hxd.Math.ceil( hxd.Math.max( tmpCorners[0].distance(tmpCorners[7]), tmpCorners[4].distance(tmpCorners[7]) ) );
			var t = d / size;
			var t2 = t * 2.0;
			var lightPos = new h3d.Vector(
				hxd.Math.floor((cascadeBounds.xMax + cascadeBounds.xMin) / t2) * t,
				hxd.Math.floor((cascadeBounds.yMax + cascadeBounds.yMin) / t2) * t,
				cascadeBounds.zMin
			);

			var view = tmpView;
			view._11 = invLight._11;
			view._12 = invLight._21;
			view._13 = invLight._31;
			view._14 = 0;
			view._21 = invLight._12;
			view._22 = invLight._22;
			view._23 = invLight._32;
			view._24 = 0;
			view._31 = invLight._13;
			view._32 = invLight._23;
			view._33 = invLight._33;
			view._34 = 0;
			view._41 = -lightPos.x;
			view._42 = -lightPos.y;
			view._43 = -lightPos.z;
			view._44 = 1;

			var proj = tmpProj;
			proj.zero();
			var invD = 1 / d;
			proj._11 = 2 * invD;
			proj._22 = 2 * invD;
			proj._33 = 1 / (cascadeBounds.zMax - cascadeBounds.zMin);
			proj._34 = -0.00000190734; // 2^-19 depth offset;
			proj._44 = 1;

			lightCameras[i].viewProj.multiply(view, proj);
		}
	}

	public function getCascadeProj(i:Int) {
		var i = hxd.Math.imin(i, lightCameras.length - 1);
		return lightCameras[i].viewProj;
	}

	function syncCascadeShader(textures : Array<h3d.mat.Texture>) {
		cshader.DEBUG = debugShader;
		for ( i in 0...cascade ) {
			var c = cascade - 1 - i;
			cshader.cascadeShadowMaps[c] = textures[i];
			cshader.cascadeProjs[c] = lightCameras[i].viewProj;
			if ( debugShader )
				cshader.cascadeDebugs[c] = h3d.Vector4.fromColor(debugColors[i]);
		}
		cshader.CASCADE_COUNT = cascade;
		cshader.shadowBias = bias;
		cshader.shadowPower = power;
		cshader.shadowProj = getShadowProj();

		//ESM
		cshader.USE_ESM = samplingKind == ESM;
		cshader.shadowPower = power;

		// PCF
		cshader.USE_PCF = samplingKind == PCF;
		cshader.shadowRes.set(textures[0].width,textures[0].height);
		cshader.pcfScale = pcfScale;
		cshader.pcfQuality = pcfQuality;
	}

	override function getShadowProj():Matrix {
		return getCascadeProj(currentCascadeIndex);
	}

	inline function cullPassesSize( passes : h3d.pass.PassList, frustum : h3d.col.Frustum, minSize : Float ) {
		passes.filter(function(p) {
			var mb = Std.downcast(p.obj, h3d.scene.MeshBatch);
			if ( mb != null ) {
				if ( @:privateAccess mb.instanced.getBounds().dimension() < minSize )
					return false;
			}
			var col = p.obj.cullingCollider;
			if( col == null )
				return true;
			if ( col.dimension() < minSize )
				return false;
			return col.inFrustum(frustum);
		});
	}

	override function draw( passes, ?sort ) {
		if( !enabled )
			return;

		if( !filterPasses(passes) )
			return;

		if( mode != Mixed || ctx.computingStatic ) {
			var slight = light == null ? ctx.lightSystem.shadowLight : light;
			var ldir = slight == null ? null : @:privateAccess slight.getShadowDirection();
			if( ldir == null )
				lightCamera.target.set(0, 0, -1);
			else {
				lightCamera.target.set(ldir.x, ldir.y, ldir.z);
				lightCamera.target.normalize();
			}
			lightCamera.pos.set();
			lightCamera.orthoBounds.empty();
			if( !passes.isEmpty() ) calcShadowBounds(lightCamera);
			var pt = ctx.camera.pos.clone();
			pt.transform(lightCamera.mcam);
			lightCamera.orthoBounds.zMax = pt.z + (castingMaxDist > 0.0 ? castingMaxDist : maxDist < 0.0 ? ctx.camera.zFar : maxDist);
			lightCamera.orthoBounds.zMin = pt.z - (castingMaxDist > 0.0 ? castingMaxDist : maxDist < 0.0 ? ctx.camera.zFar : maxDist);
			lightCamera.update();
		}

		cullPasses(passes,function(col) return col.inFrustum(lightCamera.frustum));

		calcCascadeMatrices();

		var textures = [];
		for (i in 0...cascade) {
			currentCascadeIndex = i;

			var texture = ctx.textures.allocTarget("cascadeShadowMap_"+i, size, size, false, #if js Depth24Stencil8 #else highPrecision ? Depth32 : Depth16 #end );

			// Bilinear depth only make sense if we use sample compare to get weighted shadow occlusion which we doesn't support yet.
			texture.filter = Nearest;

			var param = params[cascade - 1 - i];
			texture.depthBias = (param != null) ? param.depthBias : 0;
			texture.slopeScaledBias = (param != null) ? param.slopeBias : 0;

			var lc = lightCameras[i];
			var dimension = Math.max(lc.orthoBounds.xMax - lc.orthoBounds.xMin,	lc.orthoBounds.yMax - lc.orthoBounds.yMin);
			dimension = ( dimension * hxd.Math.clamp(minPixelRatio * size, 1, size) ) / size;
			// first cascade draw all objects
			if ( i == 0 )
				dimension = 0.0;
			var p = passes.save();
			tmpFrustum.loadMatrix(lc.viewProj);
			if ( dimension > 0.0 )
				cullPassesSize(passes, tmpFrustum, dimension);
			else
				cullPasses(passes, function(col) return col.inFrustum(tmpFrustum));
			textures[i] = processShadowMap( passes, texture, sort);
			passes.load(p);
		}
		syncCascadeShader(textures);

		#if editor
		drawDebug();
		#end
	}

	override function drawDebug() {
		super.drawDebug();

		if ( !debug )
			return;

		for ( i in 0...cascade ) {
			drawBounds(lightCameras[i].viewProj.getInverse(), debugColors[i]);
		}
	}
}