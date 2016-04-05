package h3d.parts;
import hxd.Math;

enum GpuEmitMode {
	Point;
	Cone;
	VolumeBounds;
	ParentBounds;
}

@:allow(h3d.parts.GpuParticles)
class GpuPartGroup {

	static var FIELDS = null;
	static function getFields( inst : GpuPartGroup ) {
		if( FIELDS != null )
			return FIELDS;
		FIELDS = Type.getInstanceFields(GpuPartGroup);
		for( f in ["blendMode", "emitMode", "needRebuild", "pshader", "partIndex", "texture", "colorGradient"] )
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

	public var name : String;
	public var enable = true;
	public var blendMode : h3d.mat.BlendMode = Alpha;

	public var nparts(default, set) : Int 		= 100;
	public var emitLoop(default, set) : Bool 	= true;
	public var emitMode(default,set):GpuEmitMode= Point;
	public var emitDist(default, set) : Float	= 1.;
	public var emitAngle(default,set) : Float 	= 1.5;
	public var emitSync(default, set) : Float	= 0;
	public var emitDelay(default, set) : Float	= 0;

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
	inline function set_emitDist(v) { needRebuild = true; return emitDist = v; }
	inline function set_emitAngle(v) { needRebuild = true; return emitAngle = v; }
	inline function set_emitSync(v) { needRebuild = true; return emitSync = v; }
	inline function set_emitDelay(v) { needRebuild = true; return emitDelay = v; }
	inline function set_rotInit(v) { needRebuild = true; return rotInit = v; }
	inline function set_rotSpeed(v) { needRebuild = true; return rotSpeed = v; }
	inline function set_rotSpeedRand(v) { needRebuild = true; return rotSpeedRand = v; }

	public function new() {
	}

	public function syncParams(time) {
		pshader.speedIncr = speedIncr;
		pshader.fadeIn = fadeIn;
		pshader.fadeOut = fadeOut;
		pshader.fadePower = fadePower;
		pshader.gravity = gravity;
		pshader.color = colorGradient == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : colorGradient;
		pshader.loopCounter = emitLoop ? 1 : 100000;
		pshader.time = time;
		pshader.texture = texture == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : texture;
		var frameCount = frameCount == 0 ? frameDivisionX * frameDivisionY : frameCount;
		pshader.animationRepeat = animationRepeat == 0 ? 0 : animationRepeat * frameCount - 1;
		pshader.animationFixedFrame = animationRepeat == 0 ? frameCount : 0;
		pshader.totalFrames = frameCount;
		pshader.frameDivision.set(frameDivisionX, 1 / frameDivisionX, 1 / frameDivisionY);
	}

	public function save() : Dynamic {
		var o = {
			blendMode : blendMode.getIndex(),
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
		blendMode = h3d.mat.BlendMode.createByIndex(o.blendMode);
		emitMode = GpuEmitMode.createByIndex(o.emitMode);
		texture = loadTexture(o.texture);
		colorGradient = loadTexture(o.colorGradient);
	}

}

class GpuParticles extends h3d.scene.MultiMaterial {

	static inline var VERSION = 1;
	var groups : Array<GpuPartGroup>;
	var bounds : h3d.col.Bounds;
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
		return { v : VERSION, g : [for( g in groups ) g.save()] };
	}

	public function load( o : Dynamic ) {
		var ver : Int = o.v;
		if( ver == 0 || ver > VERSION ) throw "Unsupported version " + o.v;
		for( g in (o.g:Array<Dynamic>) )
			addGroup().load(ver, g);
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
	}

	public inline function getGroups() {
		return groups.iterator();
	}

	function rebuild() {
		if( primitive != null ) {
			primitive.dispose();
			primitive = null;
		}
		var vbuf = new hxd.FloatBuffer();
		var uvs = [new h3d.prim.UV(0, 0), new h3d.prim.UV(1, 0), new h3d.prim.UV(0, 1), new h3d.prim.UV(1, 1)];
		var rnd = new hxd.Rand(0);
		var ebounds = null, calcEmit = null, partCount = 0;
		bounds.empty();
		duration = 0.;
		for( gid in 0...groups.length ) {
			var g = groups[gid];
			rnd.init(seed + gid);
			g.partIndex = partCount;
			g.needRebuild = false;
			g.syncParams(currentTime);
			partCount += g.nparts;
			if( g.emitLoop )
				duration = Math.POSITIVE_INFINITY;
			for( i in 0...g.nparts ) {

				inline function rand() return rnd.rand();
				inline function srand() return rnd.srand();

				var size = g.size * (1 + srand() * g.sizeRand), rot = srand() * Math.PI * g.rotInit;
				var vsize = g.sizeIncr, vrot = g.rotSpeed * (1 + rand() * g.rotSpeedRand) * (srand() < 0 ? -1 : 1);


				var life = g.life * (1 + srand() * g.lifeRand), time = -rand() * life * (1 - g.emitSync) - g.emitDelay;

				var totalLife = life - time;
				if( totalLife > duration ) duration = totalLife;

				var p = new h3d.col.Point();
				var v = new h3d.col.Point();

				switch( g.emitMode ) {
				case Point:

					v.x = srand();
					v.y = srand();
					v.z = srand();
					v.normalizeFast();

				case Cone:
					var theta = rand() * Math.PI * 2;
					var phi = g.emitAngle * srand();
					if( g.emitAngle < 0 ) phi += Math.PI;
					var r = g.emitDist * rand();
					v.x = Math.sin(phi) * Math.cos(theta);
					v.y = Math.sin(phi) * Math.sin(theta);
					v.z = Math.cos(phi);
					p.x = v.x * r;
					p.y = v.y * r;
					p.z = v.z * r;

				case ParentBounds, VolumeBounds:

					if( calcEmit != g.emitMode ) {
						calcEmit = g.emitMode;
						if( g.emitMode == ParentBounds ) {
							ebounds = parent.getBounds();
							ebounds.transform3x4(getInvPos());
						} else {
							ebounds = volumeBounds;
							if( ebounds == null ) ebounds = h3d.col.Bounds.fromValues( -1, -1, -1, 2, 2, 2 );
						}
					}

					p.x = rand() * ebounds.xSize + ebounds.xMin;
					p.y = rand() * ebounds.ySize + ebounds.yMin;
					p.z = rand() * ebounds.zSize + ebounds.zMin;

					v.x = srand();
					v.y = srand();
					v.z = srand();
					v.normalizeFast();

				}


				var speed = g.speed * (1 + srand() * g.speedRand);

				v.x *= speed;
				v.y *= speed;
				v.z *= speed;

				bounds.addPos(p.x, p.y, p.z);
				// todo : add end-of-life pos ?

				inline function add(v) vbuf.push(v);
				for( u in uvs ) {
					add(p.x);
					add(p.y);
					add(p.z);

					add(v.x);
					add(v.y);
					add(v.z);

					add(u.u);
					add(u.v);
					add(time);
					add(life);

					add(rot);
					add(size);
					add(vrot);
					add(vsize);
				}
			}
		}
		primitive = new h3d.prim.RawPrimitive( { vbuf : vbuf, stride : 14, quads : true, bounds:bounds }, true);
		primitive.buffer.flags.set(RawFormat);
		if( currentTime > duration )
			currentTime = duration;
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		for( i in 0...materials.length ) {
			var m = materials[i];
			var g = groups[i];
			if( m != null && g.enable ) {
				m.blendMode = g.blendMode;
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
		for( g in groups )
			if( g.needRebuild ) {
				rebuild();
				break;
			}
	}

	override function draw( ctx : h3d.scene.RenderContext ) {
		var g = groups[ctx.drawPass.index];
		g.syncParams(currentTime); // one frame late, but ok
		@:privateAccess if( primitive.buffer == null || primitive.buffer.isDisposed() ) primitive.alloc(ctx.engine);
		@:privateAccess ctx.engine.renderQuadBuffer(primitive.buffer,g.partIndex*2,g.nparts*2);
	}


}