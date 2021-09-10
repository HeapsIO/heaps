package h3d.parts;
import hxd.Math;

typedef GpuSave = {
	var type : String;
	var version : Int;
	var bounds : Array<Float>;
	var groups : Array<Dynamic>;
	@:optional var hide : Dynamic;
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

	/**
		A disc, emit in one direction
	**/
	Disc;
}

class GpuPart {

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
		for( f in ["parent", "sortMode", "emitMode", "needRebuild", "pshader", "partIndex", "particles", "texture", "colorGradient", "amount", "currentParts", "ebounds", "maxTime", "lastMove"] )
			FIELDS.remove(f);
		for( f in FIELDS.copy() )
			if( Reflect.isFunction(Reflect.field(inst, f)) )
				FIELDS.remove(f);
		FIELDS.sort(Reflect.compare);
		return FIELDS;
	}

	var parent : GpuParticles;
	var needRebuild = true;
	var pshader = new h3d.shader.GpuParticle();
	var partIndex = 0;
	var currentParts = 0;
	var particles : GpuPart;
	var ebounds : h3d.col.Bounds;
	var maxTime : Float = -1.;
	var lastMove : Float = 0;

	public var amount = 1.;

	public var name : String;
	public var enable = true;
	public var material = {};
	public var sortMode(default, set) : GpuSortMode = None;

	public var nparts(default, set) : Int 		= 100;
	public var emitLoop(default, set) : Bool 	= true;
	public var emitMode(default, set):GpuEmitMode = Point;
	public var emitStartDist(default, set) : Float = 0.;
	public var emitDist(default, set) : Float	= 1.;
	public var emitAngle(default,set) : Float 	= 1.5;
	public var emitSync(default, set) : Float	= 0;
	public var emitDelay(default, set) : Float	= 0;
	public var emitOnBorder(default, set) : Bool = false;


	public var clipBounds : Bool				= false;
	public var transform3D : Bool				= false;

	public var size(default, set) : Float		= 1;
	public var sizeIncr(default, set) : Float	= 0;
	public var sizeRand(default, set) : Float	= 0;

	public var life(default, set) : Float		= 1;
	public var lifeRand(default, set) : Float	= 0;

	public var speed(default, set) : Float		= 1;
	public var speedRand(default, set) : Float	= 0;
	public var speedIncr(default, set) : Float	= 0;
	public var gravity(default, set) : Float	= 0;

	public var rotInit(default, set) : Float	= 0;
	public var rotSpeed(default, set) : Float	= 0;
	public var rotSpeedRand(default, set):Float = 0;

	public var fadeIn : Float					= 0.2;
	public var fadeOut : Float					= 0.8;
	public var fadePower : Float				= 1;

	public var frameCount : Int					= 0;
	public var frameDivisionX : Int				= 1;
	public var frameDivisionY : Int				= 1;
	public var animationRepeat : Float			= 1;
	public var texture : h3d.mat.Texture		= null;
	public var colorGradient : h3d.mat.Texture	= null;

	public var isRelative(default, set) : Bool	= false;
	public var attachToCam(default, set) : Bool	= false;
	public var distanceToCam(default, set) : Float	= 0;

	inline function set_sortMode(v) { needRebuild = true; return sortMode = v; }
	inline function set_size(v) { needRebuild = true; return size = v; }
	inline function set_sizeRand(v) { needRebuild = true; return sizeRand = v; }
	inline function set_sizeIncr(v) { needRebuild = true; return sizeIncr = v; }
	inline function set_speed(v) { needRebuild = true; return speed = v; }
	inline function set_speedIncr(v) { needRebuild = true; return speedIncr = v; }
	inline function set_gravity(v) { needRebuild = true; return gravity = v; }
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
	inline function set_emitOnBorder(v) { needRebuild = true; return emitOnBorder = v; }
	inline function set_rotInit(v) { needRebuild = true; return rotInit = v; }
	inline function set_rotSpeed(v) { needRebuild = true; return rotSpeed = v; }
	inline function set_rotSpeedRand(v) { needRebuild = true; return rotSpeedRand = v; }
	inline function set_isRelative(v) { needRebuild = true; return isRelative = v; }
	inline function set_attachToCam(v) { needRebuild = true; return attachToCam = v; }
	inline function set_distanceToCam(v) { needRebuild = true; return distanceToCam = v; }

	public function new(parent) {
		this.parent = parent;
	}

	public function syncParams() {
		pshader.speedIncr = speedIncr;
		pshader.fadeIn = fadeIn;
		pshader.fadeOut = fadeOut;
		pshader.fadePower = fadePower;
		pshader.gravity = gravity;
		pshader.loopCounter = emitLoop ? 1 : 10000000;
		pshader.color = colorGradient == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : colorGradient;
		pshader.texture = texture == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : texture;
		var frameCount = frameCount == 0 ? frameDivisionX * frameDivisionY : frameCount;
		pshader.animationRepeat = animationRepeat == 0 ? 0 : animationRepeat * frameCount - 1;
		pshader.animationFixedFrame = animationRepeat == 0 ? frameCount : 0;
		pshader.totalFrames = frameCount;
		pshader.frameDivision.set(frameDivisionX, 1 / frameDivisionX, 1 / frameDivisionY);
		pshader.clipBounds = emitMode == CameraBounds || clipBounds;
		pshader.transform3D = transform3D;
		pshader.maxTime = maxTime < 0 ? 1e10 : maxTime;
	}

	public function getMaterialProps() {
		var name = h3d.mat.MaterialSetup.current.name;
		var p = Reflect.field(material, name);
		if( p == null ) {
			p = h3d.mat.MaterialSetup.current.getDefaults("particles3D");
			Reflect.setField(material, name, p);
		}
		return p;
	}

	public function save() : Dynamic {
		var o = {
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
		return @:privateAccess parent.loadTexture(path);
	}

	public function load( version : Int, o : Dynamic ) {
		for( f in getFields(this) )
			if( Reflect.hasField(o,f) )
				Reflect.setField(this, f, Reflect.field(o, f));
		sortMode = GpuSortMode.createByIndex(o.sortMode);
		emitMode = GpuEmitMode.createByIndex(o.emitMode);
		texture = loadTexture(o.texture);
		colorGradient = loadTexture(o.colorGradient);
		if( Math.isNaN(emitStartDist) ) emitStartDist = 0;
		if( version == 1 ) {
			fadeOut = 1 - fadeOut;
			material = {};
		}
		if( parent != null ) {
			var index = @:privateAccess parent.groups.indexOf(this);
			if( index >= 0 ) {
				var mat = parent.materials[index];
				mat.name = name;
				mat.props = getMaterialProps();
			}
		}
	}

	public function updateBounds( bounds : h3d.col.Bounds ) {
		var life = life * (1 + lifeRand);
		var speedMin = speed * hxd.Math.max(1 - speedRand, 0.);
		var speed = speed * (1 + speedRand);
		switch( emitMode ) {
		case Point, Cone:
			var start = emitStartDist + emitDist;
			var d = speed * (1 + speedIncr * life) * life + start;
			var zmin = emitStartDist + (speed * speed) / (4 * (gravity - speed * speedIncr)); // local minima
			if( !(zmin < d) )
				zmin = d;
			var zmax = speedMin * (1 + speedIncr * life) * life + start - gravity * life * life;

			if( emitMode == Cone ) {
				var phi = emitAngle;
				d *= Math.sin(phi);
			}

			bounds.addPos(0, 0, emitStartDist);
 			bounds.addPos(-d, -d, zmin);
			bounds.addPos(d, d, zmax);

			if( emitMode == Point ) {
				bounds.addPos(d, d, -zmax);
				bounds.addPos(d, d, -zmin);
			}

		case Disc:
			var start = emitStartDist + emitDist;
			var maxDist = speedMin * (1 + speedIncr * life) * life - gravity * life * life;
			var phi = emitAngle + Math.PI/2;
			var zMinMax = maxDist * Math.sin(phi);
			var xyMinMax = Math.abs(maxDist * Math.cos(phi)) + start;

			bounds.addPos(0, 0, zMinMax);
			bounds.addPos(xyMinMax, xyMinMax, 0);
			bounds.addPos(-xyMinMax, -xyMinMax, 0);

		case ParentBounds, VolumeBounds, CameraBounds:
			var d = speed * (1 + speedIncr * life) * life;
			var max = (1 + emitDist) * 0.5;
			if( max < 0 ) max = 0;
			var c = ebounds.getCenter();
			var size = ebounds.getSize();
			var dx = size.x * max + d;
			var dy = size.y * max + d;
			var dz = size.z * max + d;
			bounds.addPos(c.x - dx, c.y - dy, c.z - dz);
			bounds.addPos(c.x + dx, c.y + dy, c.z + dz);
		}
	}

	public function emitPart( rnd : hxd.Rand, pt : GpuPart, absPos : h3d.Matrix ) {
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
			v.normalize();
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

		case Disc:

			var phi = g.emitAngle;
			var theta = rand() * Math.PI * 2;
			if( g.emitAngle < 0 ) phi += Math.PI;

			v.x = Math.sin(phi) * Math.cos(theta);
			v.y = Math.sin(phi) * Math.sin(theta);
			v.z = Math.cos(phi);

			v.normalize();
			var r = g.emitStartDist + g.emitDist * (emitOnBorder ? 1 : Math.sqrt(rand()));
			p.x = Math.cos(theta) * r;
			p.y = Math.sin(theta) * r;
			p.z = 0;

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
			p.y = p.y * ebounds.ySize + c.y;
			p.z = p.z * ebounds.zSize + c.z;

			v.x = srand();
			v.y = srand();
			v.z = srand();
			v.normalize();

		}


		var speed = g.speed * (1 + srand() * g.speedRand);

		v.x *= speed;
		v.y *= speed;
		v.z *= speed;


		// when sorted/progressive, use absolute coordinates
		if( absPos != null && !isRelative ) {
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

	static inline var VERSION = 2;
	static inline var STRIDE = 14;

	var groups : Array<GpuPartGroup>;
	var primitiveBuffers : Array<hxd.FloatBuffer>;
	var primitives : Array<h3d.prim.Primitive>;
	var resourcePath : String;
	var partAlloc : GpuPart;
	var rnd = new hxd.Rand(0);
	var prevX : Float = 0;
	var prevY : Float = 0;
	var prevZ : Float = 0;
	var hideProps : Dynamic;

	public var seed(default, set) : Int	= Std.random(0x1000000);
	public var volumeBounds(default, set) : h3d.col.Bounds;
	public var currentTime : Float = 0.;
	public var duration(default, null) : Float = 0.;
	public var bounds(default, null) : h3d.col.Bounds;

	/**
		Tells how much percent of the particles to display. This can be used to progressively display a particle effect.
		This can also be done per group in GpuPartGroup.progress
	**/
	public var amount : Float = 1.;

	/**
		Tells how many particles were uploaded to GPU last frame (for performance tuning).
	**/
	public var uploadedCount(default,null) : Int;

	/**
		Tells how many particles are live actually
	**/
	public var count(get,never) : Int;

	public function new( ?parent ) {
		super(null, [], parent);
		bounds = new h3d.col.Bounds();
		bounds.addPos(0, 0, 0);
		groups = [];
		primitiveBuffers = [];
		primitives = [];
	}

	override function onRemove() {
		super.onRemove();
		for( p in primitives )
			if( p != null ) p.dispose();
	}

	override function getBoundsRec(b:h3d.col.Bounds) {
		if( flags.has(FIgnoreBounds) )
			return super.getBoundsRec(b);
		for( g in groups )
			if( g.needRebuild ) {
				var s = getScene();
				if( s != null ) {
					if( posChanged ) {
						calcAbsPos();
						posChanged = false;
					}
					sync(@:privateAccess s.renderer.ctx);
				}
				break;
			}
		return super.getBoundsRec(b);
	}

	public dynamic function onEnd() {
		if( duration > 0 ) currentTime = -1;
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
		var save : GpuSave = { type : "particles3D", version : VERSION, groups : [for( g in groups ) g.save()], bounds : bounds };
		if( hideProps != null ) save.hide = hideProps;
		return save;
	}

	public function load( _o : Dynamic, ?resourcePath : String ) {
		this.resourcePath = resourcePath;
		var o : GpuSave = _o;
		if( o.version == 0 || o.version > VERSION ) throw "Unsupported version " + _o.version;
		for( g in o.groups )
			addGroup().load(o.version, g);
		if( o.bounds != null )
			volumeBounds = h3d.col.Bounds.fromValues(o.bounds[0] - o.bounds[3] * 0.5, o.bounds[1] - o.bounds[4] * 0.5, o.bounds[2] - o.bounds[5] * 0.5, o.bounds[3], o.bounds[4], o.bounds[5]);
		hideProps = o.hide;
	}

	public function addGroup( ?g : GpuPartGroup, ?material : h3d.mat.Material, ?index ) {
		if( g == null )
			g = new GpuPartGroup(this);
		if( g.name == null )
			g.name = "Group#" + (groups.length + 1);
		if( material == null ) {
			material = h3d.mat.MaterialSetup.current.createMaterial();
			material.mainPass.culling = None;
			material.mainPass.depthWrite = false;
			material.blendMode = Alpha;
			if( g.material != null ) {
				material.props = g.getMaterialProps();
				material.name = g.name;
			}
		}
		if( this.material == null ) this.material = material;
		material.mainPass.addShader(g.pshader);
		if( index == null )
			index = groups.length;
		materials.insert(index, material);
		groups.insert(index, g);
		g.needRebuild = true;
		return g;
	}

	function set_seed(s) {
		if( groups != null )
			for( g in groups ) g.needRebuild = true;
		return seed = s;
	}

	function set_volumeBounds(v) {
		for( g in groups ) g.needRebuild = true;
		return volumeBounds = v;
	}

	public function rebuild() {
		for( g in groups ) g.needRebuild = true;
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

	override function calcAbsPos() {
		super.calcAbsPos();
		// should we check for pure rotation too ?
		if( prevX != absPos.tx || prevY != absPos.ty || prevZ != absPos.tz ) {
			prevX = absPos.tx;
			prevY = absPos.ty;
			prevZ = absPos.tz;
			for( g in groups )
				if( g.emitLoop )
					g.lastMove = currentTime;
		}
	}

	function rebuildAll(cam) {

		var ebounds = null, calcEmit = null, partCount = 0, partAlloc = this.partAlloc;
		bounds.empty();
		duration = 0.;

		var hasLoop = false;
		for( gid in 0...groups.length ) {
			var g = groups[gid];
			g.partIndex = partCount;
			partCount += g.nparts;

			var p = g.particles;
			while( p != null ) {
				var n = p.next;
				p.next = partAlloc;
				partAlloc = p;
				p = n;
			}
			g.particles = null;
			g.currentParts = 0;
			g.maxTime = g.emitLoop ? -1 : 0;
			if( calcEmit != g.emitMode ) {
				calcEmit = g.emitMode;
				switch( g.emitMode ) {
				case ParentBounds:
					var ignore = flags.has(FIgnoreBounds);
					flags.set(FIgnoreBounds, true);
					ebounds = parent.getBounds();
					flags.set(FIgnoreBounds, ignore);
					ebounds.transform(getInvPos());
				case VolumeBounds, CameraBounds:
					ebounds = volumeBounds;
					if( ebounds == null ) ebounds = volumeBounds = h3d.col.Bounds.fromValues( -1, -1, -1, 2, 2, 2 );
				case Cone, Point, Disc:
					ebounds = null;
				}
			}
			g.ebounds = ebounds;

			var maxLife = g.life * (1 + g.lifeRand + 1 - g.emitSync) + g.emitDelay;
			if( maxLife > duration )
				duration = maxLife;
			if( g.emitLoop )
				hasLoop = true;
			g.updateBounds(bounds);
		}

		this.partAlloc = partAlloc;

		for( p in primitives )
			if( p != null ) p.dispose();

		if( primitives.length != groups.length )
			primitives.resize(groups.length);

		if( primitiveBuffers.length != groups.length )
			primitiveBuffers.resize(groups.length);

		for( gid in 0...groups.length ) {
			if( primitiveBuffers[gid] == null ||  primitiveBuffers[gid].length > STRIDE * partCount * 4 )
				primitiveBuffers[gid] = new hxd.FloatBuffer();
			primitiveBuffers[gid].grow(STRIDE * groups[gid].nparts * 4);
			primitives[gid] = new h3d.prim.RawPrimitive( { vbuf : primitiveBuffers[gid], stride : STRIDE, quads : true, bounds:bounds }, true);
			primitives[gid].buffer.flags.set(RawFormat);
		}

		if( hasLoop ) {
			if( currentTime < duration )
				currentTime = duration;
			duration = 0;
		} else if( currentTime > duration )
			currentTime = duration;
		for( g in groups )
			g.needRebuild = false;
		rnd.init(seed);
	}

	static var PUVS = [new h3d.prim.UV(0, 0), new h3d.prim.UV(1, 0), new h3d.prim.UV(0, 1), new h3d.prim.UV(1, 1)];

	function cleanParts( g : GpuPartGroup, pneeded : Int, checkMove = false ) {
		if( g.maxTime < 0 )
			return;
		var p = g.particles;
		var prev = null;
		var ftime = g.maxTime;
		while( p != null && g.currentParts > pneeded ) {
			var t = p.time + currentTime;
			var st = t - (t % p.life);
			if( st > p.time + ftime && (!checkMove || -p.time < ftime) ) {
				var n = p.next;
				p.next = partAlloc;
				partAlloc = p;
				if( prev == null )
					g.particles = n;
				else
					prev.next = n;
				g.currentParts--;
				p = n;
				continue;
			}
			prev = p;
			p = p.next;
		}
		g.maxTime = -1;
	}

	function syncGroup( g : GpuPartGroup, camera : h3d.Camera, prevTime : Float, visible : Bool ) {

		// emit
		var needSync = false;
		var pneeded = Math.ceil(hxd.Math.clamp(g.amount * amount) * g.nparts);

		if( g.lastMove != 0 ) {
			var p = g.particles;
			while( p != null ) {
				if( p.time > -g.lastMove ) break;
				p = p.next;
			}
			if( p == null ) {
				g.lastMove = 0;
			} else {
				var old = g.maxTime;
				g.maxTime = g.lastMove;
				var count = g.currentParts;
				cleanParts(g, 0, true);
				if( g.currentParts < count ) needSync = true;
				g.maxTime = old;
			}
		}

		if( g.currentParts != pneeded ) {

			if( g.currentParts < pneeded ) {

				if( g.lastMove == 0 )
					cleanParts(g, pneeded);

				var partAlloc = partAlloc;
				while( g.currentParts < pneeded ) {
					var pt = partAlloc;
					if( pt == null )
						pt = new GpuPart();
					else
						partAlloc = pt.next;
					g.emitPart(rnd, pt, absPos);
					if( g.lastMove != 0 ) pt.time = -prevTime /* no delay */ else pt.time -= prevTime;
					pt.index = -1;
					pt.next = g.particles;
					g.particles = pt;
					g.currentParts++;
				}
				this.partAlloc = partAlloc;
				needSync = true;
			}

			if( g.currentParts > pneeded && g.lastMove == 0 ) {
				var ftime = g.maxTime;
				if( ftime < 0 )
					g.maxTime = ftime = currentTime;
				// count how many particles life has ended
				var p = g.particles;
				var count = 0;
				while( p != null ) {
					if( currentTime - ((p.time + currentTime) % p.life) > ftime ) count++;
					p = p.next;
				}
				// remove at once
				if( g.currentParts - count <= pneeded || count > 1000 ) {
					cleanParts(g, pneeded);
					if( g.currentParts > pneeded ) g.maxTime = ftime;
					needSync = true;
				}
			}

		}

		// sort
		var needSort = g.sortMode != None && visible;
		if( needSort ) {
			var p = g.particles;
			var m = camera.m;
			while( p != null ) {
				var t = p.time + currentTime;
				if( g.emitLoop ) t %= p.life;

				var acc = (1 + g.speedIncr * t) * t;
				p.x = p.sx + p.vx * acc;
				p.y = p.sy + p.vy * acc;
				p.z = p.sz + p.vz * acc - g.gravity * t * t;

				var cz = p.x * m._13 + p.y * m._23 + p.z * m._33 + m._43;
				var cw = p.x * m._14 + p.y * m._24 + p.z * m._34 + m._44;
				p.w = cz / cw;

				p = p.next;
			}
			g.particles = haxe.ds.ListSort.sortSingleLinked(g.particles, function(p1:GpuPart, p2:GpuPart) return p1.w < p2.w ? 1 : -1);
			needSync = true;
		}

		if( !needSync )
			return;

		// sync buffer
		var startIndex = 0;
		var index = startIndex;
		var vbuf = primitiveBuffers[groups.indexOf(g)];
		var p = g.particles;
		var uvs = PUVS;
		var pidx = 0;
		var firstPart = g.nparts;
		var lastPart = -1;
		while( p != null ) {

			#if !(hlnx || hlps)
            if( p.index == pidx ) {
                pidx++;
                index += STRIDE * 4;
                p = p.next;
                continue;
            }
            #end

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
		if( firstPart <= lastPart ) {
			uploadedCount += lastPart - firstPart + 1;
			var primitive = primitives[groups.indexOf(g)];
			primitive.buffer.uploadVector(vbuf, (firstPart) * 4 * STRIDE, (lastPart - firstPart + 1) * 4, (firstPart) * 4);
		}
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		for( i in 0...materials.length ) {
			var m = materials[i];
			var g = groups[i];
			if( m != null && g.enable && g.currentParts > 0 )
				ctx.emit(m, this, i);
		}
	}

	override function sync(ctx) {
		super.sync(ctx);

		// free memory
		if( partAlloc != null )
			partAlloc = partAlloc.next;

		var prev = currentTime;
		currentTime += ctx.elapsedTime;
		if( prev < duration && currentTime >= duration ) {
			onEnd();
			if( !allocated )
				return; // was removed
		}

		if( !ctx.visibleFlag && !alwaysSync )
			return;

		for( g in groups ) {
			var gid = groups.indexOf(g);
			if( primitives[gid] != null ) {
				if( g.needRebuild ) {
					prev = 0;
					currentTime = 0;
					primitives[gid].dispose();
					primitives[gid] = null;
					break;
				}
			}
		}

		var camera = ctx.camera;
		if( camera == null )
			camera = new h3d.Camera();

		for( gid in 0 ... groups.length ) {
			var primitive = gid < primitives.length ? primitives[gid] : null;
			if( primitive == null || primitive.buffer == null || primitive.buffer.isDisposed() ) {
				rebuildAll(camera);
				break;
			}
		}

		uploadedCount = 0;
		var hasPart = false;
		for( g in groups ) {
			syncGroup(g, camera, prev, ctx.visibleFlag);
			if( g.currentParts == 0 )
				continue;
			// sync shader params
			hasPart = true;
			g.syncParams();
			g.pshader.time = currentTime;
			if( g.pshader.clipBounds ) {
				g.pshader.volumeMin.set(volumeBounds.xMin, volumeBounds.yMin, volumeBounds.zMin);
				g.pshader.volumeSize.set(volumeBounds.xSize, volumeBounds.ySize, volumeBounds.zSize);
			}
			if( g.pshader.transform3D ) {
				var r = camera.target.sub(camera.pos);
				r.z = 0;
				r.normalize();
				var q = new h3d.Quat();
				q.initDirection(r);
				q.toMatrix(g.pshader.cameraRotation);
			}
			if( g.emitMode == CameraBounds ) {
				g.pshader.transform.load(camera.getInverseView());
				g.pshader.offset.set( -camera.pos.x * g.emitDist, -camera.pos.y * g.emitDist, -camera.pos.z * g.emitDist );
				g.pshader.offset.transform3x3( camera.mcam );
				g.pshader.offset.x %= volumeBounds.xSize;
				g.pshader.offset.y %= volumeBounds.ySize;
				g.pshader.offset.z %= volumeBounds.zSize;
			} else {
				if( g.isRelative )
					g.pshader.transform.load(absPos);
				else
					g.pshader.transform.identity();
				if ( g.attachToCam ) {
					ignoreParentTransform = true;
					var camPos = ctx.camera.pos;
					var camDir = ctx.camera.target.sub(ctx.camera.pos).normalized().clone();
					var offset = camDir;
					offset.scale(g.distanceToCam);
					var emitterPos = camPos.add(offset);
					g.pshader.offset.set( getAbsPos().getPosition().x + emitterPos.x, getAbsPos().getPosition().y + emitterPos.y, getAbsPos().getPosition().z + emitterPos.z );
				}
				else
					g.pshader.offset.set(0, 0, 0);
			}
		}

		if( duration == 0 && !hasPart )
			onEnd();
	}

	function get_count() {
		var n = 0;
		for( g in groups )
			n += g.currentParts;
		return n;
	}

	override function draw( ctx : h3d.scene.RenderContext ) {
		var primitive = primitives[ctx.drawPass.index];
		if( primitive == null || primitive.buffer.isDisposed() )
			return; // wait next sync()
		var g = groups[ctx.drawPass.index];
		@:privateAccess if( primitive.buffer == null || primitive.buffer.isDisposed() ) primitive.alloc(ctx.engine);
		@:privateAccess ctx.engine.renderQuadBuffer(primitive.buffer,0,g.currentParts*2);
	}

	function loadTexture( path : String ) {
		try	{
			return hxd.res.Loader.currentInstance.load(path).toTexture();
		} catch( e : hxd.res.NotFound ) {
			return h3d.mat.Texture.fromColor(0xFF00FF);
		}
	}

}