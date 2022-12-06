package h3d.pass;

class CascadeShadowMap extends DirShadowMap {

	var cshader : h3d.shader.CascadeShadow;
	var lightCameras : Array<h3d.Camera> = [];
	var currentCascadeIndex = 0;

	public var pow : Float = 1.0;
	public var firstCascadeSize : Float = 10.0;
	public var cascade(default, set) = 1;
	public var debug : Bool = false;
	public function set_cascade(v) {
		cascade = v;
		lightCameras = [];
		for ( i in 0...cascade ) {
			lightCameras.push(new h3d.Camera());
			lightCameras[i].orthoBounds = new h3d.col.Bounds();
		}
		return cascade;
	}

	public function new( light : h3d.scene.Light ) {
		super(light);
		shader = dshader = cshader = new h3d.shader.CascadeShadow();
	}

	public override function getShadowTex() {
		return cshader.shadowMap;
	}

	public function getShadowTextures() {
		return cshader.cascadeShadowMaps;
	}

	public dynamic function calcBounds( camera : h3d.Camera, ?limits : h3d.col.Bounds) {
		var bounds = camera.orthoBounds;
		var zMax = -1e9, zMin = 1e9;
		// add visible casters in light camera position
		var mtmp = new h3d.Matrix();
		var btmp = autoZPlanes ? new h3d.col.Bounds() : null;
		var obj = boundingObject != null ? boundingObject : ctx.scene;
		obj.iterVisibleMeshes(function(m) {
			if( m.primitive == null || !m.material.castShadows ) return;
			var b = m.primitive.getBounds();
			if( b.xMin > b.xMax ) return;

			var absPos = Std.isOfType(m.primitive, h3d.prim.Instanced) ? h3d.Matrix.I() : m.getAbsPos();
			if( autoZPlanes ) {
				btmp.load(b);
				btmp.transform(absPos);
				if( btmp.zMax > zMax ) zMax = btmp.zMax;
				if( btmp.zMin < zMin ) zMin = btmp.zMin;
			}

			var points = [];
			mtmp.multiply3x4(absPos, camera.mcam);

			var p = new h3d.col.Point(b.xMin, b.yMin, b.zMin);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMin, b.yMin, b.zMax);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMin, b.yMax, b.zMin);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMin, b.yMax, b.zMax);
			p.transform(mtmp);
			points.push(p);				

			var p = new h3d.col.Point(b.xMax, b.yMin, b.zMin);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMax, b.yMin, b.zMax);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMax, b.yMax, b.zMin);
			p.transform(mtmp);
			points.push(p);

			var p = new h3d.col.Point(b.xMax, b.yMax, b.zMax);
			p.transform(mtmp);
			points.push(p);

			var add = true;
			if ( limits != null ) {
				add = false;
				for ( p in points ) {
					if ( limits.contains(p) ) {
						add = true;
						break;
					}
				}
			}
			if ( add ) {
				for ( p in points ) {
					bounds.addPoint(p);
				}
			}

		});

		if( mode == Dynamic ) {

			// Intersect with frustum bounds
			var cameraBounds = new h3d.col.Bounds();
			var minDist = minDist < 0 ? ctx.camera.zNear : minDist;
			var maxDist = maxDist < 0 ? ctx.camera.zFar : maxDist;

			inline function addCorner(x,y,d) {
				var dist = d?minDist:maxDist;
				var pt = ctx.camera.unproject(x,y,ctx.camera.distanceToDepth(dist)).toPoint();
				if( autoZPlanes ) {
					// let's auto limit our frustrum to our zMin/Max planes
					var r = h3d.col.Ray.fromPoints(ctx.camera.pos.toPoint(), pt);
					var d2 = r.distance(h3d.col.Plane.Z(d?zMax:zMin));
					var k = d ? 1 : -1;
					if( d2 > 0 && d2*k > dist*k )
						pt.load(r.getPoint(d2));
				}
				pt.transform(camera.mcam);
				cameraBounds.addPos(pt.x, pt.y, pt.z);
			}

			inline function addCorners(d) {
				addCorner(-1,-1,d);
				addCorner(-1,1,d);
				addCorner(1,-1,d);
				addCorner(1,1,d);
			}

			addCorners(true);
			addCorners(false);

			// Keep the zMin from the bounds of visible objects
			// Prevent shadows inside frustum from objects outside frustum being clipped
			cameraBounds.zMin = bounds.zMin;
			bounds.intersection(bounds, cameraBounds);
			if( autoZPlanes ) {
				/*
					Let's intersect again our light camera bounds with our scene zMax plane
					so we can tighten the zMin, which will give us better precision
					for our depth map.
				*/
				var v = camera.target.sub(camera.pos).normalized();
				var dMin = 1e9;
				for( dx in 0...2 )
					for( dy in 0...2 ) {
						var px = dx > 0 ? bounds.xMax : bounds.xMin;
						var py = dy > 0 ? bounds.yMax : bounds.yMin;
						var r0 = new h3d.col.Point(px,py,bounds.zMin).transformed(camera.getInverseView());
						var r = h3d.col.Ray.fromValues(r0.x, r0.y, r0.z, v.x, v.y, v.z);
						var d = r.distance(h3d.col.Plane.Z(zMax));
						if( d < dMin ) dMin = d;
					}
				bounds.zMin += dMin;
			}
		}
		bounds.scaleCenter(1.01);
	}

	public function calcCascadeShadowBounds( camera : h3d.Camera ) {
		calcBounds(camera);
		var bounds = camera.orthoBounds;

		lightCamera.update();
		var shadowNear = hxd.Math.POSITIVE_INFINITY;
		var shadowFar = hxd.Math.NEGATIVE_INFINITY;
		var corners = lightCamera.getFrustumCorners();
		for ( corner in corners ) {
			corner.transform(ctx.camera.mcam);
			shadowNear = hxd.Math.min(shadowNear, corner.z / corner.w);
			shadowFar = hxd.Math.max(shadowFar, corner.z / corner.w);
		}
		var near = shadowNear;
		var far = shadowNear + firstCascadeSize;
		for ( i in 0...cascade - 1 ) {
			var cascadeBounds = new h3d.col.Bounds();
			function addCorner(x,y,d) {
				var pt = ctx.camera.unproject(x,y,ctx.camera.distanceToDepth(d)).toPoint();
				pt.transform(camera.mcam);
				cascadeBounds.addPos(pt.x, pt.y, pt.z);
			}
			function addCorners(d) {
				addCorner(-1,-1,d);
				addCorner(-1,1,d);
				addCorner(1,-1,d);
				addCorner(1,1,d);
			}

			if ( i == cascade - 1 )
				far = shadowFar;
			addCorners(near);
			addCorners(hxd.Math.min(far, shadowFar));
			lightCameras[i].orthoBounds = cascadeBounds;
			var limits = lightCameras[i].orthoBounds.clone();
			lightCameras[i].orthoBounds.empty();
			calcBounds(lightCameras[i], limits);

			near += firstCascadeSize * hxd.Math.pow(pow, i);
			far += firstCascadeSize * hxd.Math.pow(pow, i+1);
		}
		lightCameras[cascade - 1].orthoBounds = lightCamera.orthoBounds.clone();
	}

	override function setGlobals() {
		super.setGlobals();
		cameraViewProj = getCascadeProj(currentCascadeIndex);
	}

	function getCascadeProj(i:Int) {
		return lightCameras[i].m;
	}

	function syncCascadeShader(textures : Array<h3d.mat.Texture>) {
		for ( i in 0...cascade ) {
			cshader.cascadeShadowMaps[i] = textures[i];
			cshader.cascadeProjs[i] = lightCameras[i].m;
		}
		for ( i in 0...cascade-1 ) {
			var pt = lightCameras[i].unproject(0,0,1);
			pt.transform(ctx.camera.m);
			cshader.cascadeLimits[i] = pt.z;
		}
		var pt = lightCamera.unproject(0,0,1);
		pt.transform(ctx.camera.m);
		cshader.cascadeLimits[cascade-1] = pt.z;
		cshader.camViewProj = ctx.camera.m;
		cshader.CASCADE_COUNT = cascade;
		cshader.shadowBias = bias * 2.0; // experimental value for consistency with/without cascades
		cshader.shadowPower = power;
		cshader.shadowProj = getShadowProj();

		//ESM
		cshader.USE_ESM = samplingKind == ESM;
		cshader.shadowPower = power;

		// PCF
		cshader.USE_PCF = samplingKind == PCF;
		cshader.shadowRes.set(textures[0].width,textures[0].height);
		cshader.pcfScale = pcfScale * 5.0; // experimental value for consistency with/without cascades
		cshader.pcfQuality = pcfQuality;
	}

	override function draw( passes, ?sort ) {
		if ( g != null )
			g.clear();

		if( !enabled )
			return;

		if( !filterPasses(passes) )
			return;

		if( mode != Mixed || ctx.computingStatic ) {
			var ct = ctx.camera.target;
			var slight = light == null ? ctx.lightSystem.shadowLight : light;
			var ldir = slight == null ? null : @:privateAccess slight.getShadowDirection();
			if( ldir == null )
				lightCamera.target.set(0, 0, -1);
			else {
				lightCamera.target.set(ldir.x, ldir.y, ldir.z);
				lightCamera.target.normalize();
			}
			lightCamera.target.x += ct.x;
			lightCamera.target.y += ct.y;
			lightCamera.target.z += ct.z;
			lightCamera.pos.load(ct);
			lightCamera.update();
			for ( i in 0...lightCameras.length) {
				if( ldir == null )
					lightCameras[i].target.set(0, 0, -1);
				else {
					lightCameras[i].target.set(ldir.x, ldir.y, ldir.z);
					lightCameras[i].target.normalize();
				}
				lightCameras[i].target.x += ct.x;
				lightCameras[i].target.y += ct.y;
				lightCameras[i].target.z += ct.z;
				lightCameras[i].pos.load(ct);
				lightCameras[i].update();
			}

			lightCamera.orthoBounds.empty();
			for ( lC in lightCameras ) lC.orthoBounds.empty();
			if( !passes.isEmpty() ) calcCascadeShadowBounds(lightCamera);
			lightCamera.update();
			for ( lC in lightCameras ) lC.update();
		}

		cullPasses(passes,function(col) return col.inFrustum(lightCamera.frustum));

		var textures = [];
		if ( g != null )
			g.clear();
		for (i in 0...cascade) {
			var texture = ctx.textures.allocTarget("cascadeShadowMap", size, size, false, format);
			if( customDepth && (depth == null || depth.width != size || depth.height != size || depth.isDisposed()) ) {
				if( depth != null ) depth.dispose();
				depth = new h3d.mat.DepthBuffer(size, size);
			}
			texture.depthBuffer = depth;
			textures.push(texture);

			currentCascadeIndex = i;
			var p = passes.save();
			cullPasses(passes,function(col) return col.inFrustum(lightCameras[i].frustum));
			processShadowMap( passes, texture, sort);
			passes.load(p);
			drawCascade(lightCameras[i], i);

		}
		drawCascade(lightCamera);
		syncCascadeShader(textures);
	}

	var g : h3d.scene.Graphics;
	function drawCascade( c : h3d.Camera, cascade=-1 ) {
		if ( !debug )
			return;

		if( g == null ) {
			g = new h3d.scene.Graphics(ctx.scene);
			g.name = "frustumDebug";
			g.material.mainPass.setPassName("overlay");
			g.ignoreBounds = true;
		}

		var nearPlaneCorner = [c.unproject(-1, 1, 0), c.unproject(1, 1, 0), c.unproject(1, -1, 0), c.unproject(-1, -1, 0)];
		var farPlaneCorner = [c.unproject(-1, 1, 1), c.unproject(1, 1, 1), c.unproject(1, -1, 1), c.unproject(-1, -1, 1)];

		var colors = [0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xff00ff, 0x000000];
		g.lineStyle(1, colors[cascade+1]);

		// Near Plane
		var last = nearPlaneCorner[nearPlaneCorner.length - 1];
		g.moveTo(last.x,last.y,last.z);
		for( fc in nearPlaneCorner ) {
			g.lineTo(fc.x, fc.y, fc.z);
		}

		// Far Plane
		var last = farPlaneCorner[farPlaneCorner.length - 1];
		g.moveTo(last.x,last.y,last.z);
		for( fc in farPlaneCorner ) {
			g.lineTo(fc.x, fc.y, fc.z);
		}

		// Connections
		for( i in 0 ... 4 ) {
			var np = nearPlaneCorner[i];
			var fp = farPlaneCorner[i];
			g.moveTo(np.x, np.y, np.z);
			g.lineTo(fp.x, fp.y, fp.z);
		}
	}
}