package h3d.parts;
import hxd.Math;

private typedef GpuSave = {
	var version : Int;
	var bounds : Array<Float>;
	var groups : Array<Dynamic>;
}

enum GpuSortMode {
	/**
		Particles are not sorted.
	**/
	None;
	/**
		Particles are sorted back-to-front every frame based on their current position.
	**/
	Dynamic;
}

enum GpuEmitMode {
	/**
		A single Point, emit in all directions
	**/
	Point;
	/**
		A cone, parametrized with emitAngle and emitDistance
	**/
	Cone;
	/**
		The GpuParticles specified volumeBounds
	**/
	VolumeBounds;
	/**
		The GpuParticles parent.getBounds()
	**/
	ParentBounds;
	/**
		Same as VolumeBounds, but in Camera space, not world space.
	**/
	CameraBounds;
}

private class GpuPart {

	public var index : Int;

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;

	// params
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;

	public var vx : Float;
	public var vy : Float;
	public var vz : Float;

	public var time : Float;
	public var life : Float;

	public var initX : Float;
	public var initY : Float;
	public var deltaX : Float;
	public var deltaY : Float;

	public var next : GpuPart;

	public function new() {
	}

	public function updatePos( time : Float, gravity : Float ) {
		var t = (time + this.time) % this.life;
		x = sx + vx * t;
		y = sy + vy * t;
		z = sz + (vz - gravity * t) * t;
	}

}

@:allow(h3d.parts.GpuParticles)
class GpuPartGroup {

	static var FIELDS = null;
	static function getFields( inst : GpuPartGroup ) {
		if( FIELDS != null )
			return FIELDS;
		FIELDS = Type.getInstanceFields(GpuPartGroup);
		for( f in ["material", "sortMode", "emitMode", "needRebuild", "pshader", "partIndex", "particles", "texture", "colorGradient","displayedParts"] )
			FIELDS.remove(f);
		for( f in FIELDS.copy() )
			if( Reflect.isFunction(Reflect.field(inst, f)) )
				FIELDS.remove(f);
		FIELDS.sort(Reflect.compare);
		return FIELDS;
	}

	var needRebuild = true;
	var pshader = new h3d.shader.GpuParticle();
	var partIndex = 0;
	var particles : GpuPart;

	/**
		Tells how many particles to display. This can be used to progressively display a particle effect.
		A negative value mean that all particles are displayed.
	**/
	public var displayedParts = -1;

	public var name : String;
	public var enable = true;
	public var material : h3d.mat.MaterialProps = h3d.mat.MaterialProps.particlesDefault();
	public var sortMode(default, set) : GpuSortMode = None;

	public var nparts(default, set) : Int 		= 100;
	public var emitLoop(default, set) : Bool 	= true;
	public var emitMode(default, set):GpuEmitMode = Point;
	public var emitStartDist(default, set) : Float = 0.;
	public var emitDist(default, set) : Float	= 1.;
	public var emitAngle(default,set) : Float 	= 1.5;
	public var emitSync(default, set) : Float	= 0;
	public var emitDelay(default, set) : Float	= 0;


	public var clipBounds : Bool				= false;
	public var transform3D : Bool				= false;

	public var size(default, set) : Float		= 1;
	public var sizeIncr(default, set) : Float	= 0;
	public var sizeRand(default, set) : Float	= 0;

	public var life(default, set) : Float		= 1;
	public var lifeRand(default, set) : Float	= 0;

	public var speed(default, set) : Float		= 1;
	public var speedRand(default, set) : Float	= 0;
	public var speedIncr : Float				= 0;
	public var gravity : Float					= 0;

	public var rotInit(default, set) : Float	= 0;
	public var rotSpeed(default, set) : Float	= 0;
	public var rotSpeedRand(default, set):Float = 0;

	public var fadeIn : Float					= 0.2;
	public var fadeOut : Float					= 0.2;
	public var fadePower : Float				= 1;

	public var frameCount : Int					= 0;
	public var frameDivisionX : Int				= 1;
	public var frameDivisionY : Int				= 1;
	public var animationRepeat : Float			= 1;
	public var texture : h3d.mat.Texture		= null;
	public var colorGradient : h3d.mat.Texture	= null;

	inline function set_sortMode(v) { needRebuild = true; return sortMode = v; }
	inline function set_size(v) { needRebuild = true; return size = v; }
	inline function set_sizeRand(v) { needRebuild = true; return sizeRand = v; }
	inline function set_sizeIncr(v) { needRebuild = true; return sizeIncr = v; }
	inline function set_speed(v) { needRebuild = true; return speed = v; }
	inline function set_speedRand(v) { needRebuild = true; return speedRand = v; }
	inline function set_life(v) { needRebuild = true; return life = v; }
	inline function set_lifeRand(v) { needRebuild = true; return lifeRand = v; }
	inline function set_nparts(n) { if( n > nparts ) needRebuild = true; return nparts = n; }
	inline function set_emitLoop(v) { needRebuild = true; return emitLoop = v; }
	inline function set_emitMode(v) { needRebuild = true; return emitMode = v; }
	inline function set_emitStartDist(v) { needRebuild = true; return emitStartDist = v; }
	inline function set_emitDist(v) { needRebuild = true; return emitDist = v; }
	inline function set_emitAngle(v) { needRebuild = true; return emitAngle = v; }
	inline function set_emitSync(v) { needRebuild = true; return emitSync = v; }
	inline function set_emitDelay(v) { needRebuild = true; return emitDelay = v; }
	inline function set_rotInit(v) { needRebuild = true; return rotInit = v; }
	inline function set_rotSpeed(v) { needRebuild = true; return rotSpeed = v; }
	inline function set_rotSpeedRand(v) { needRebuild = true; return rotSpeedRand = v; }

	public function new() {
	}

	public function syncParams() {
		pshader.speedIncr = speedIncr;
		pshader.fadeIn = fadeIn;
		pshader.fadeOut = fadeOut;
		pshader.fadePower = fadePower;
		pshader.gravity = gravity;
		pshader.loopCounter = emitLoop ? 1 : 1000000;
		pshader.color = colorGradient == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : colorGradient;
		pshader.texture = texture == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : texture;
		var frameCount = frameCount == 0 ? frameDivisionX * frameDivisionY : frameCount;
		pshader.animationRepeat = animationRepeat == 0 ? 0 : animationRepeat * frameCount - 1;
		pshader.animationFixedFrame = animationRepeat == 0 ? frameCount : 0;
		pshader.totalFrames = frameCount;
		pshader.frameDivision.set(frameDivisionX, 1 / frameDivisionX, 1 / frameDivisionY);
		pshader.clipBounds = emitMode == CameraBounds || clipBounds;
		pshader.transform3D = transform3D;
	}

	public function save() : Dynamic {
		var o = {
			material : material.getData(),
			sortMode : sortMode.getIndex(),
			emitMode : emitMode.getIndex(),
			texture : texture == null ? null : texture.name,
			colorGradient : colorGradient == null ? null : colorGradient.name,
		};
		for( f in getFields(this) )
			Reflect.setField(o, f, Reflect.field(this, f));
		return o;
	}

	function loadTexture( path : String ) {
		if( path == null )
			return null;
		try	{
			return hxd.res.Loader.currentInstance.load(path).toTexture();
		} catch( e : hxd.res.NotFound ) {
			return h3d.mat.Texture.fromColor(0xFF00FF);
		}
	}

	public function load( version : Int, o : Dynamic ) {
		for( f in getFields(this) )
			Reflect.setField(this, f, Reflect.field(o, f));
		if( o.material != null ) material.loadData(o.material);
		sortMode = GpuSortMode.createByIndex(o.sortMode);
		emitMode = GpuEmitMode.createByIndex(o.emitMode);
		texture = loadTexture(o.texture);
		colorGradient = loadTexture(o.colorGradient);
		if( Math.isNaN(emitStartDist) ) emitStartDist = 0;
	}

	public function emitPart( rnd : hxd.Rand, pt : GpuPart, ebounds : h3d.col.Bounds, absPos : h3d.Matrix ) {
		var g = this;
		inline function rand() return rnd.rand();
		inline function srand() return rnd.srand();

		var size = g.size * (1 + srand() * g.sizeRand), rot = srand() * Math.PI * g.rotInit;
		var vsize = g.sizeIncr, vrot = g.rotSpeed * (1 + rand() * g.rotSpeedRand) * (srand() < 0 ? -1 : 1);


		var life = g.life * (1 + srand() * g.lifeRand), time = -rand() * life * (1 - g.emitSync) - g.emitDelay;

		var p = new h3d.col.Point();
		var v = new h3d.col.Point();

		switch( g.emitMode ) {
		case Point:

			v.x = srand();
			v.y = srand();
			v.z = srand();
			v.normalizeFast();
			var r = g.emitStartDist + g.emitDist * rand();
			p.x = v.x * r;
			p.y = v.y * r;
			p.z = v.z * r;

		case Cone:
			var theta = rand() * Math.PI * 2;
			var phi = g.emitAngle * srand();
			if( g.emitAngle < 0 ) phi += Math.PI;
			var r = g.emitStartDist + g.emitDist * rand();
			v.x = Math.sin(phi) * Math.cos(theta);
			v.y = Math.sin(phi) * Math.sin(theta);
			v.z = Math.cos(phi);
			p.x = v.x * r;
			p.y = v.y * r;
			p.z = v.z * r;

		case ParentBounds, VolumeBounds, CameraBounds:

			var max = 1 + g.emitDist;
			if( max < 0 ) max = 0;

			if( g.emitStartDist > 0 ) {

				var min = g.emitStartDist * 0.5;

				// prevent too low volume
				if( min > 0.49 ) min = 0.49;

				// inner volume check

				do {
					p.x = rand() - 0.5;
					p.y = rand() - 0.5;
					p.z = rand() - 0.5;
				} while( (p.x > -min && p.x < min) && (p.y > -min && p.y < min) && (p.z > -min && p.z < min) );

				p.x *= max;
				p.y *= max;
				p.z *= max;

			} else {

				p.x = (rand() - 0.5) * max;
				p.y = (rand() - 0.5) * max;
				p.z = (rand() - 0.5) * max;

			}


			var c = ebounds.getCenter();
			p.x = p.x * ebounds.xSize + c.x;
			p.y = p.y * ebounds.xSize + c.y;
			p.z = p.z * ebounds.zSize + c.z;

			v.x = srand();
			v.y = srand();
			v.z = srand();
			v.normalizeFast();

		}


		var speed = g.speed * (1 + srand() * g.speedRand);

		v.x *= speed;
		v.y *= speed;
		v.z *= speed;


		// when sorted/progressive, use absolute coordinates
		if( absPos != null ) {
			p.transform(absPos);
			v.transform3x3(absPos);
		}

		pt.sx = p.x;
		pt.sy = p.y;
		pt.sz = p.z;
		pt.vx = v.x;
		pt.vy = v.y;
		pt.vz = v.z;
		pt.time = time;
		pt.life = life;
		pt.initX = rot;
		pt.initY = size;
		pt.deltaX = vrot;
		pt.deltaY = vsize;
	}

}

class GpuParticles extends h3d.scene.MultiMaterial {

	static inline var VERSION = 1;
	static inline var STRIDE = 14;

	var groups : Array<GpuPartGroup>;
	var bounds : h3d.col.Bounds;
	var primitiveBuffer : hxd.FloatBuffer;
	var resourcePath : String;
	public var seed(default, set) : Int	= Std.random(0x1000000);
	public var volumeBounds(default, set) : h3d.col.Bounds;
	public var currentTime : Float = 0.;
	public var duration : Float = 0.;

	public function new( ?parent ) {
		super(null, [], parent);
		bounds = new h3d.col.Bounds();
		bounds.addPos(0, 0, 0);
		groups = [];
	}

	public dynamic function onEnd() {
		currentTime = -1;
	}

	public function save() : Dynamic {
		var bounds = null;
		for( g in groups )
			switch( g.emitMode ) {
			case CameraBounds, VolumeBounds:
				if( volumeBounds != null ) {
					var c = volumeBounds.getCenter();
					bounds = [c.x, c.y, c.z, volumeBounds.xSize, volumeBounds.ySize, volumeBounds.zSize];
					break;
				}
			default:
			}
		return ({ version : VERSION, groups : [for( g in groups ) g.save()], bounds : bounds } : GpuSave);
	}

	public function load( _o : Dynamic, ?resourcePath : String ) {
		this.resourcePath = resourcePath;
		var o : GpuSave = _o;
		if( o.version == 0 || o.version > VERSION ) throw "Unsupported version " + _o.version;
		for( g in o.groups )
			addGroup().load(o.version, g);
		if( o.bounds != null )
			volumeBounds = h3d.col.Bounds.fromValues(o.bounds[0] - o.bounds[3] * 0.5, o.bounds[1] - o.bounds[4] * 0.5, o.bounds[2] - o.bounds[5] * 0.5, o.bounds[3], o.bounds[4], o.bounds[5]);
	}

	public function addGroup( ?g : GpuPartGroup, ?material : h3d.mat.MeshMaterial, ?index ) {
		if( g == null )
			g = new GpuPartGroup();
		if( material == null ) {
			material = new h3d.mat.MeshMaterial();
			material.mainPass.culling = None;
			material.mainPass.depthWrite = false;
			material.blendMode = Alpha;
			if( this.material == null ) this.material = material;
		}
		if( g.name == null ) g.name = "Group#" + (groups.length + 1);
		material.mainPass.addShader(g.pshader);
		material.mainPass.dynamicParameters = true;
		if( index == null )
			index = groups.length;
		materials.insert(index, material);
		groups.insert(index, g);
		g.needRebuild = true;
		return g;
	}

	function set_seed(s) {
		for( g in groups ) g.needRebuild = true;
		return seed = s;
	}

	function set_volumeBounds(v) {
		for( g in groups ) g.needRebuild = true;
		return volumeBounds = v;
	}

	public function removeGroup( g : GpuPartGroup ) {
		var idx = groups.indexOf(g);
		if( idx < 0 ) return;
		groups.splice(idx,1);
		materials.splice(idx, 1);
		if( materials.length == 0 ) material = null;
	}

	public function getGroup( name : String ) {
		for( g in groups )
			if( g.name == name )
				return g;
		return null;
	}

	public inline function getGroups() {
		return groups.iterator();
	}

	static var PUVS = [new h3d.prim.UV(0, 0), new h3d.prim.UV(1, 0), new h3d.prim.UV(0, 1), new h3d.prim.UV(1, 1)];

	function rebuild(cam) {
		if( primitive != null ) {
			primitive.dispose();
			primitive = null;
		}
		var vbuf = new hxd.FloatBuffer();
		var uvs = PUVS;
		var rnd = new hxd.Rand(0);
		var ebounds = null, calcEmit = null, partCount = 0;
		bounds.empty();
		duration = 0.;
		for( gid in 0...groups.length ) {
			var g = groups[gid];
			rnd.init(seed + gid);
			g.partIndex = partCount;
			g.syncParams();
			partCount += g.nparts;
			if( g.emitLoop )
				duration = Math.POSITIVE_INFINITY;

			var needPart = g.sortMode != None;
			var partAlloc = g.particles;
			var useAbsPos = needPart;
			g.particles = null;
			var pt = needPart ? null : new GpuPart();

			if( calcEmit != g.emitMode ) {
				calcEmit = g.emitMode;
				switch( g.emitMode ) {
				case ParentBounds:
					ebounds = parent.getBounds();
					ebounds.transform(getInvPos());
				case VolumeBounds, CameraBounds:
					ebounds = volumeBounds;
					if( ebounds == null ) ebounds = volumeBounds = h3d.col.Bounds.fromValues( -1, -1, -1, 2, 2, 2 );
				default:
				}
			}

			for( i in 0...g.nparts ) {

				if( needPart ) {
					pt = partAlloc;
					if( pt == null )
						pt = new GpuPart();
					else
						partAlloc = partAlloc.next;
					pt.index = i;
					pt.next = g.particles;
					g.particles = pt;
				}

				g.emitPart(rnd, pt, ebounds, useAbsPos ? absPos : null);


				// total : also add end of life pos ?
				bounds.addPos(pt.sx, pt.sy, pt.sz);

				var totalLife = pt.life - pt.time;
				if( totalLife > duration ) duration = totalLife;

				inline function add(v) vbuf.push(v);
				for( u in uvs ) {
					add(pt.sx);
					add(pt.sy);
					add(pt.sz);

					add(pt.vx);
					add(pt.vy);
					add(pt.vz);

					add(u.u);
					add(u.v);
					add(pt.time);
					add(pt.life);

					add(pt.initX);
					add(pt.initY);
					add(pt.deltaX);
					add(pt.deltaY);
				}
			}
		}
		primitive = new h3d.prim.RawPrimitive( { vbuf : vbuf, stride : STRIDE, quads : true, bounds:bounds }, true);
		primitive.buffer.flags.set(RawFormat);
		primitiveBuffer = vbuf;
		if( currentTime > duration )
			currentTime = duration;
		for( g in groups )
			g.needRebuild = false;
	}

	function syncGroup( g : GpuPartGroup, camera : h3d.Camera ) {
		var p = g.particles;
		var m = camera.m;
		var needSort = g.sortMode != None;
		while( p != null ) {
			var t = p.time + currentTime;
			if( g.emitLoop ) t %= p.life;

			var acc = (1 + g.speedIncr * t) * t;
			p.x = p.sx + p.vx * acc;
			p.y = p.sy + p.vy * acc;
			p.z = p.sz + p.vz * acc - g.gravity * t * t;

			if( needSort ) {
				var cz = p.x * m._13 + p.y * m._23 + p.z * m._33 + m._43;
				var cw = p.x * m._14 + p.y * m._24 + p.z * m._34 + m._44;
				p.w = cz / cw;
			}

			p = p.next;
		}

		if( !needSort )
			return;

		g.particles = haxe.ds.ListSort.sortSingleLinked(g.particles, function(p1:GpuPart, p2:GpuPart) return p1.w < p2.w ? 1 : -1);

		var startIndex = g.partIndex * STRIDE * 4;
		var index = startIndex;
		var vbuf = primitiveBuffer;
		var p = g.particles;
		var uvs = PUVS;
		var pidx = 0;
		var firstPart = g.nparts;
		var lastPart = -1;
		while( p != null ) {

			if( p.index == pidx ) {
				pidx++;
				index += STRIDE * 4;
				p = p.next;
				continue;
			}

			inline function add(v) vbuf[index++] = v;
			for( u in uvs ) {
				add(p.sx);
				add(p.sy);
				add(p.sz);

				add(p.vx);
				add(p.vy);
				add(p.vz);

				add(u.u);
				add(u.v);
				add(p.time);
				add(p.life);

				add(p.initX);
				add(p.initY);
				add(p.deltaX);
				add(p.deltaY);
			}

			if( pidx < firstPart ) firstPart = pidx;
			if( pidx > lastPart ) lastPart = pidx;

			p.index = pidx++;
			p = p.next;
		}
		if( firstPart <= lastPart )
			primitive.buffer.uploadVector(vbuf, (g.partIndex + firstPart) * STRIDE * 4, (lastPart - firstPart + 1) * 4, (g.partIndex + firstPart) * 4);
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		for( i in 0...materials.length ) {
			var m = materials[i];
			var g = groups[i];
			if( m != null && g.enable && g.displayedParts != 0 ) {
				if( m.props != g.material ) {
					m.name = g.name;
					m.props = g.material;
				}
				ctx.emit(m, this, i);
			}
		}
	}

	override function sync(ctx) {
		super.sync(ctx);
		var prev = currentTime;
		currentTime += ctx.elapsedTime;
		if( prev < duration && currentTime >= duration )
			onEnd();
		if( primitive == null || primitive.buffer.isDisposed() )
			for( g in groups )
				g.needRebuild = true;
		for( g in groups )
			if( g.needRebuild ) {
				rebuild(ctx.camera);
				break;
			}
		for( g in groups )
			syncGroup(g, ctx.camera);
	}

	override function draw( ctx : h3d.scene.RenderContext ) {
		var g = groups[ctx.drawPass.index];
		g.syncParams();
		g.pshader.time = currentTime;
		if( g.pshader.clipBounds ) {
			g.pshader.volumeMin.set(volumeBounds.xMin, volumeBounds.yMin, volumeBounds.zMin);
			g.pshader.volumeSize.set(volumeBounds.xSize, volumeBounds.ySize, volumeBounds.zSize);
		}
		if( g.pshader.transform3D ) {
			var r = ctx.camera.target.sub(ctx.camera.pos);
			r.z = 0;
			r.normalize();
			var q = new h3d.Quat();
			q.initDirection(r);
			q.saveToMatrix(g.pshader.cameraRotation);
		}
		if( g.emitMode == CameraBounds ) {
			g.pshader.transform.loadFrom(ctx.camera.getInverseView());
			g.pshader.offset.set( -ctx.camera.pos.x * g.emitDist, -ctx.camera.pos.y * g.emitDist, -ctx.camera.pos.z * g.emitDist );
			g.pshader.offset.transform3x3( ctx.camera.mcam );
			g.pshader.offset.x %= volumeBounds.xSize;
			g.pshader.offset.y %= volumeBounds.ySize;
			g.pshader.offset.z %= volumeBounds.zSize;
		} else if( g.sortMode == None ) {
			g.pshader.transform.loadFrom(absPos);
			g.pshader.offset.set(0, 0, 0);
		} else {
			g.pshader.transform.identity();
			g.pshader.offset.set(0, 0, 0);
		}
		ctx.uploadParams();
		@:privateAccess if( primitive.buffer == null || primitive.buffer.isDisposed() ) primitive.alloc(ctx.engine);
		@:privateAccess ctx.engine.renderQuadBuffer(primitive.buffer,g.partIndex*2,(g.displayedParts < 0 || g.displayedParts >= g.nparts ? g.nparts : g.displayedParts)*2);
	}


}