package h3d.pass;

typedef CascadeParams = {
	var depthBias : Float;
	var slopeBias : Float;
}

typedef CascadeCamera = {
	var viewProj : h3d.Matrix;
	var scale : h3d.Vector4;
	var offset : h3d.Vector4;
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

	public var cascadeViewProj = new h3d.Matrix();
	public var params : Array<CascadeParams> = [];
	public var pow : Float = 1.0;
	// minimum count of pixels for an object to be drawn in cascade
	public var minPixelSize : Int = 1;
	public var firstCascadeSize : Float = 10.0;
	public var castingMaxDist : Float = 0.0;
	public var transitionFraction : Float = 0.15;
	public var cascade(default, set) = 1;
	public var highPrecision : Bool = false;
	public function set_cascade(v) {
		cascade = v;
		lightCameras = [];
		for ( i in 0...cascade )
			lightCameras.push({ viewProj : new h3d.Matrix(), scale : new h3d.Vector4(), offset : new h3d.Vector4(), orthoBounds : new h3d.col.Bounds() });
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

	override function needStaticUpdate() { }

	function computeNearFar( i : Int, previousFar : Float ) {
		var max = maxDist < 0.0 ? ctx.camera.zFar : maxDist;
		var step = max - firstCascadeSize;
		var near = ( i == 0 ) ? 0.0 : previousFar - previousFar * transitionFraction;
		var far = ( i == 0 ) ? firstCascadeSize : firstCascadeSize + hxd.Math.pow(i / (cascade - 1), pow) * step;

		// Not related to scale but let's pack it here to save memory
		lightCameras[i].scale.w = far;

		return {near : near, far : far};
	}

	public function calcCascadeMatrices() {
		var invCamera = ctx.camera.getInverseView();
		var invG = hxd.Math.tan(hxd.Math.degToRad( ctx.camera.fovY ) / 2.0);
		var sInvG = ctx.camera.screenRatio * invG;
		var invLight = lightCamera.getInverseView();
		var camToLight = invCamera.multiplied( lightCamera.mcam );

		inline function computeLightPos( bounds : h3d.col.Bounds, d : Float ) {
			var t = d / size;
			var t2 = t * 2.0;
			return new h3d.Vector(
				hxd.Math.floor((bounds.xMax + bounds.xMin) / t2) * t,
				hxd.Math.floor((bounds.yMax + bounds.yMin) / t2) * t,
				bounds.zMin
			);
		}

		inline function computeCorner(x : Float, y : Float, d : Float, pt : h3d.Vector) {
			pt.set( x * (d * sInvG), y * ( d * invG ), d );
		}

		inline function computeCorners(d, i) {
			computeCorner(-1.0, -1.0, d, tmpCorners[i]);
			computeCorner(-1.0,  1.0, d, tmpCorners[i + 1]);
			computeCorner( 1.0, -1.0, d, tmpCorners[i + 2]);
			computeCorner( 1.0,  1.0, d, tmpCorners[i + 3]);
		}

		inline function computeBounds( bounds : h3d.col.Bounds ) {
			bounds.empty();
			for ( pt in tmpCorners ) {
				pt.transform( camToLight );
				bounds.addPos(pt.x, pt.y, pt.z);
			}
		}

		var nearFar = computeNearFar(0, 0);
		computeCorners(nearFar.near, 0);
		computeCorners(nearFar.far, 4);

		var d0 = hxd.Math.ceil( hxd.Math.max( tmpCorners[0].distance(tmpCorners[7]), tmpCorners[4].distance(tmpCorners[7]) ) );
		var cascadeBounds0 = lightCameras[0].orthoBounds;
		computeBounds( cascadeBounds0 );
		var lightPos0 = computeLightPos(cascadeBounds0, d0);

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
		view._41 = -lightPos0.x;
		view._42 = -lightPos0.y;
		view._43 = -lightPos0.z;
		view._44 = 1;

		var invD0 = 1 / d0;
		var zDist0 = cascadeBounds0.zMax - cascadeBounds0.zMin;

		inline function getBias( i : Int ) {
			var depthBiasFactor = (params[i] != null ) ? params[i].depthBias : 1.0;
			return 0.00000190734 * depthBiasFactor; // 2^-19 depth offset;
		}

		var proj = tmpProj;
		proj.zero();
		proj._11 = invD0;
		proj._22 = invD0;
		proj._33 = 1.0 / (zDist0);
		proj._41 = 0.5;
		proj._42 = 0.5;
		proj._44 = 1.0;

		cascadeViewProj.multiply(view, proj);

		var invD02 = 2.0 * invD0;
		proj._11 = invD02;
		proj._22 = invD02;
		proj._41 = 0.0;
		proj._42 = 0.0;
		proj._43 = getBias(0);

		lightCameras[0].viewProj.multiply(view, proj);

		for ( i in 1...cascade ) {
			nearFar = computeNearFar(i, nearFar.far);
			computeCorners(nearFar.near, 0);
			computeCorners(nearFar.far, 4);

			var d = hxd.Math.ceil( hxd.Math.max( tmpCorners[0].distance(tmpCorners[7]), tmpCorners[4].distance(tmpCorners[7]) ) );
			var cascadeBounds = lightCameras[i].orthoBounds;
			computeBounds( cascadeBounds );
			var lightPos = computeLightPos(cascadeBounds, d);

			var invD = 1.0 / d;
			var d0InvD = d0 * invD;
			var zDist = ( cascadeBounds.zMax - cascadeBounds.zMin );
			var invZDist = 1.0 / zDist;
			var halfMinusD0Inv2D = 0.5 - ( d0 / ( 2.0 * d ) );

			lightCameras[i].scale.x = d0InvD;
			lightCameras[i].scale.y = d0InvD;
			lightCameras[i].scale.z = zDist0 * invZDist;

			lightCameras[i].offset.x = ( lightPos0.x - lightPos.x ) * invD + halfMinusD0Inv2D;
			lightCameras[i].offset.y = ( lightPos0.y - lightPos.y ) * invD + halfMinusD0Inv2D;
			lightCameras[i].offset.z = ( lightPos0.z - lightPos.z ) * invZDist;

			var view = tmpView;
			view._41 = -lightPos.x;
			view._42 = -lightPos.y;
			view._43 = -lightPos.z;

			var proj = tmpProj;
			proj.zero();
			var invD2 = 2.0 * invD;

			proj._11 = invD2;
			proj._22 = invD2;
			proj._33 = invZDist;
			proj._43 = getBias(i);
			proj._44 = 1.0;

			lightCameras[i].viewProj.multiply(view, proj);
		}
	}

	public function getCascadeProj(i:Int) {
		var i = hxd.Math.imin(i, lightCameras.length - 1);
		return lightCameras[i].viewProj;
	}

	public function getCascadeOffset(i:Int) {
		var i = hxd.Math.imin(i, lightCameras.length - 1);
		return lightCameras[i].offset;
	}

	public function getCascadeScale(i:Int) {
		var i = hxd.Math.imin(i, lightCameras.length - 1);
		return lightCameras[i].scale;
	}

	function syncCascadeShader(textures : Array<h3d.mat.Texture>) {
		cshader.DEBUG = debugShader;
		cshader.cascadeViewProj = cascadeViewProj;
		cshader.cascadeTransitionFraction = transitionFraction;
		for ( i in 0...cascade ) {
			cshader.cascadeShadowMaps[i] = textures[i];
			cshader.cascadeOffsets[i] = lightCameras[i].offset;
			cshader.cascadeScales[i] = lightCameras[i].scale;
			if ( debugShader )
				cshader.cascadeDebugs[i] = h3d.Vector4.fromColor(debugColors[i]);
		}
		cshader.CASCADE_COUNT = cascade;
		cshader.BLEND = transitionFraction > 0.0;
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
			var col = p.obj.cullingCollider;
			return if( mb != null && @:privateAccess mb.instanced.primitive.getBounds().dimension() < minSize ) false;
				else if( col == null ) true;
				else if ( col.dimension() < minSize ) false;
				else col.inFrustum(frustum);
		});
	}

	override function draw( passes, ?sort ) {
		if( !enabled )
			return;

		if( !filterPasses(passes) )
			return;

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
		lightCamera.update();

		calcCascadeMatrices();

		for (i in 0...cascade)
			lightCamera.orthoBounds.add(lightCameras[i].orthoBounds);
		var zDist = (castingMaxDist > 0.0 ? castingMaxDist : maxDist < 0.0 ? ctx.camera.zFar : maxDist);
		lightCamera.orthoBounds.zMax += zDist;
		lightCamera.orthoBounds.zMin -= zDist;
		lightCamera.update();

		cullPasses(passes, function(col) return col.inFrustum(lightCamera.frustum));
		var p = passes.save();

		var prevCheckNearFar = lightCamera.frustum.checkNearFar;
		lightCamera.frustum.checkNearFar = false;
		var textures = [];
		for (i in 0...cascade) {
			currentCascadeIndex = i;

			var texture = ctx.textures.allocTarget("cascadeShadowMap_"+i, size, size, false, #if js Depth24Stencil8 #else highPrecision ? Depth32 : Depth16 #end );

			// Bilinear depth only make sense if we use sample compare to get weighted shadow occlusion which we doesn't support yet.
			texture.filter = Nearest;

			var param = params[i];
			texture.slopeScaledBias = (param != null) ? param.slopeBias : 0;
			texture.depthClamp = true;

			var lc = lightCameras[i];
			var dimension = Math.max(lc.orthoBounds.xMax - lc.orthoBounds.xMin,	lc.orthoBounds.yMax - lc.orthoBounds.yMin);
			dimension = ( dimension * hxd.Math.clamp(minPixelSize, 0, size) ) / size;
			// first cascade draw all objects
			if ( i == 0 )
				dimension = 0.0;
			lightCamera.orthoBounds = lc.orthoBounds;
			lightCamera.update();
			if ( dimension > 0.0 )
				cullPassesSize(passes, lightCamera.frustum, dimension);
			else
				cullPasses(passes, function(col) return col.inFrustum(lightCamera.frustum));
			textures[i] = processShadowMap( passes, texture, sort);
			passes.load(p);
		}
		syncCascadeShader(textures);
		lightCamera.frustum.checkNearFar = prevCheckNearFar;

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