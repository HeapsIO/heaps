package h2d;

enum PartSortMode {
	/**
		Particles are not sorted.
	**/
	None;
	/**
		Particles are sorted back-to-front every frame based on their current position.
	**/
	Dynamic;
}

enum PartEmitMode {
	/**
		A single Point, emit in all directions
	**/
	Point;
	/**
		A cone, parametrized with emitAngle and emitDistance
	**/
	Cone;
	/**
		A box, parametrized with emitDist and emitDistY
	**/
	Box;
	/**
		A box, parametrized with emitAngle and emitDistance
	**/
	Direction;
}

private class ParticleShader extends hxsl.Shader {
	static var SRC = {

		@input var input : { color : Vec4 };

		@const var hasGradient : Bool;
		@const var has2DGradient : Bool;
		@param var gradient : Sampler2D;

		var pixelColor : Vec4;
		var textureColor : Vec4;

		function fragment() {
			pixelColor = textureColor; // ignore input.color RGB
			pixelColor.a *= input.color.a;
			if( has2DGradient ) {
				var g = gradient.get(vec2(input.color.r, textureColor.r));
				pixelColor.rgb = g.rgb;
				pixelColor.a *= g.a;
			} else if( hasGradient )
				pixelColor *= gradient.get(input.color.rg);
		}

	}
}

@:access(h2d.ParticleGroup)
private class Particle extends h2d.SpriteBatch.BatchElement {

	var group : ParticleGroup;
	public var vx : Float;
	public var vy : Float;
	public var vSize : Float;
	public var vr : Float;
	public var maxLife : Float;
	public var life : Float;
	public var delay : Float;

	public function new(group) {
		super(null);
		this.group = group;
	}

	override function update(et:Float) {
		if( delay > 0 ) {
			delay -= et;
			if( delay <= 0 )
				visible = true;
			else {
				visible = false;
				return true;
			}
		}

		var dv = Math.pow(1 + group.speedIncr, et);
		vx *= dv;
		vy *= dv;
		vx += group.gravity * et * group.sinGravityAngle;
		vy += group.gravity * et * group.cosGravityAngle;

		x += vx * et;
		y += vy * et;
		life += et;

		if( group.rotAuto )
			rotation = Math.atan2(vy, vx) + life * vr + group.rotInit * Math.PI;
		else
			rotation += vr * et;

		if (group.incrX)
			scaleX *= Math.pow(1 + vSize, et);
		if (group.incrY)
			scaleY *= Math.pow(1 + vSize, et);

		var t = life / maxLife;
		if( t < group.fadeIn )
			alpha = Math.pow(t / group.fadeIn, group.fadePower);
		else if( t > group.fadeOut )
			alpha = Math.pow((1 - t) / (1 - group.fadeOut), group.fadePower);
		else
			alpha = 1;

		r = t; // pass to pshader for colorGradient

		if( group.animationRepeat > 0 )
			this.t = group.tiles[Std.int(t * group.tiles.length * group.animationRepeat) % group.tiles.length];

		if( t > 1 ) {
			if( group.emitLoop ) {
				@:privateAccess group.init(this);
				delay = 0;
			} else
				return false;
		}
		return true;
	}

}

@:access(h2d.SpriteBatch)
@:access(h2d.Object)
class ParticleGroup {

	static var FIELDS = null;
	@:keep
	static function getFields( inst : ParticleGroup ) {
		if( FIELDS != null )
			return FIELDS;
		FIELDS = Type.getInstanceFields(ParticleGroup);
		for( f in ["parts", "pshader", "batch", "needRebuild", "emitMode", "sortMode", "blendMode", "texture", "colorGradient", "tiles"] )
			FIELDS.remove(f);
		for( f in FIELDS.copy() )
			if( Reflect.isFunction(Reflect.field(inst, f)) )
				FIELDS.remove(f);
		FIELDS.sort(Reflect.compare);
		return FIELDS;
	}

	var parts : Particles;
	var batch : SpriteBatch;
	var needRebuild = true;
	var tiles : Array<h2d.Tile>;

	public var name : String;
	public var enable(default, set) : Bool = true;
	public var sortMode(default, set) : PartSortMode = None;
	public var blendMode(default, set) : BlendMode = Alpha;

	public var nparts(default, set) : Int 		= 100;
	public var dx(default, set) : Int 			= 0;
	public var dy(default, set) : Int 			= 0;

	public var emitLoop(default, set) : Bool 	= true;
	public var emitMode(default, set):PartEmitMode = Point;
	public var emitStartDist(default, set) : Float = 0.;
	public var emitDist(default, set) : Float	= 50.;
	public var emitDistY(default, set) : Float	= 50.;
	public var emitAngle(default, set) : Float 	= -0.5;
	public var emitDirectionAsAngle(default, set) : Bool = false;
	public var emitSync(default, set) : Float	= 0;
	public var emitDelay(default, set) : Float	= 0;

	public var size(default, set) : Float		= 1;
	public var sizeIncr(default, set) : Float	= 0;
	public var incrX(default, set) : Bool		= true;
	public var incrY(default, set) : Bool		= true;
	public var sizeRand(default, set) : Float	= 0;

	public var life(default, set) : Float		= 1;
	public var lifeRand(default, set) : Float	= 0;

	public var speed(default, set) : Float			= 50.;
	public var speedRand(default, set) : Float		= 0;
	public var speedIncr(default, set) : Float		= 0;
	public var gravity(default, set) : Float		= 0;
	public var gravityAngle(default, set) : Float 	= 0;
	public var cosGravityAngle : Float;
	public var sinGravityAngle : Float;

	public var rotInit(default, set) : Float	= 0;
	public var rotSpeed(default, set) : Float	= 0;
	public var rotSpeedRand(default, set):Float = 0;
	public var rotAuto							= false;

	public var fadeIn : Float					= 0.2;
	public var fadeOut : Float					= 0.8;
	public var fadePower : Float				= 1;

	public var frameCount(default,set) : Int		= 0;
	public var frameDivisionX(default,set) : Int	= 1;
	public var frameDivisionY(default,set) : Int	= 1;
	public var animationRepeat(default,set) : Float	= 1;
	public var texture(default,set) : h3d.mat.Texture;
	public var colorGradient(default,set) : h3d.mat.Texture;
	
	/** Should partcles follow the emitter or stay in place? **/
	public var isRelative(default, set) : Bool = true;
	/** Should group rebuild on parameters change.
		Note that some parameters take immediate effect on the existing particles, and some would force rebuild reagrdless.
		Parameters that take immediate effect:
		speedIncr, gravity, gravityAngle, fadeIn, fadeOut, fadePower, rotAuto, rotInit, incrX, incrY, emitLoop, blendMode
		Parameters that will always force rebuild:
		enable, sortMode, isRelative, texture, frameCount, frameDivisionX, frameDivisionY, nparts
		Parameters that newer cause rebuild:
		blendMode, colorGradient, animationRepeat
	**/
	public var rebuildOnChange : Bool = true;

	inline function set_enable(v) { enable = v; if( !v ) { batch.clear(); needRebuild = true; }; return v; }
	inline function set_sortMode(v) { needRebuild = true; return sortMode = v; }
	inline function set_blendMode(v) { batch.blendMode = v; return blendMode = v; }
	inline function set_size(v) { if (rebuildOnChange) needRebuild = true; return size = v; }
	inline function set_sizeRand(v) { if (rebuildOnChange) needRebuild = true; return sizeRand = v; }
	inline function set_sizeIncr(v) { if (rebuildOnChange) needRebuild = true; return sizeIncr = v; }
	inline function set_incrX(v) { if (rebuildOnChange) needRebuild = true; return incrX = v; }
	inline function set_incrY(v) { if (rebuildOnChange) needRebuild = true; return incrY = v; }
	inline function set_speed(v) { if (rebuildOnChange) needRebuild = true; return speed = v; }
	inline function set_speedIncr(v) { if (rebuildOnChange) needRebuild = true; return speedIncr = v; }
	inline function set_gravity(v) { if (rebuildOnChange) needRebuild = true; return gravity = v; }
	inline function set_gravityAngle(v : Float) {
		if (rebuildOnChange) needRebuild = true;
		cosGravityAngle = Math.cos(v * Math.PI * 0.5);
		sinGravityAngle = Math.sin(v * Math.PI * 0.5);
		return gravityAngle = v;
	}

	inline function set_speedRand(v) { if (rebuildOnChange) needRebuild = true; return speedRand = v; }
	inline function set_life(v) { if (rebuildOnChange) needRebuild = true; return life = v; }
	inline function set_lifeRand(v) { if (rebuildOnChange) needRebuild = true; return lifeRand = v; }
	inline function set_nparts(n) { needRebuild = true; return nparts = n; }
	inline function set_dx(v) { if (rebuildOnChange) needRebuild = true; return dx = v; }
	inline function set_dy(v) { if (rebuildOnChange) needRebuild = true; return dy = v; }
	inline function set_emitLoop(v) { if (rebuildOnChange) needRebuild = true; return emitLoop = v; }
	inline function set_emitMode(v) { if (rebuildOnChange) needRebuild = true; return emitMode = v; }
	inline function set_emitStartDist(v) { if (rebuildOnChange) needRebuild = true; return emitStartDist = v; }
	inline function set_emitDist(v) { if (rebuildOnChange) needRebuild = true; return emitDist = v; }
	inline function set_emitDistY(v) { if (rebuildOnChange) needRebuild = true; return emitDistY = v; }
	inline function set_emitAngle(v) { if (rebuildOnChange) needRebuild = true; return emitAngle = v; }
	inline function set_emitDirectionAsAngle(v) { if (rebuildOnChange) needRebuild = true; return emitDirectionAsAngle = v; }
	inline function set_emitSync(v) { if (rebuildOnChange) needRebuild = true; return emitSync = v; }
	inline function set_emitDelay(v) { if (rebuildOnChange) needRebuild = true; return emitDelay = v; }
	inline function set_rotInit(v) { if (rebuildOnChange) needRebuild = true; return rotInit = v; }
	inline function set_rotSpeed(v) { if (rebuildOnChange) needRebuild = true; return rotSpeed = v; }
	inline function set_rotSpeedRand(v) { if (rebuildOnChange) needRebuild = true; return rotSpeedRand = v; }
	inline function set_texture(t) { texture = t; makeTiles(); return t; }
	inline function set_colorGradient(t) { colorGradient = t; return t; }
	inline function set_frameCount(v) { frameCount = v; makeTiles(); return v; }
	inline function set_frameDivisionX(v) { frameDivisionX = v; makeTiles(); return v; }
	inline function set_frameDivisionY(v) { frameDivisionY = v; makeTiles(); return v; }
	inline function set_animationRepeat(v) return animationRepeat = v;
	inline function set_isRelative(v) { needRebuild = true; return isRelative = v; }
	
	public function new(p) {
		this.parts = p;
		batch = new SpriteBatch(null, p);
		batch.visible = false;
		batch.hasRotationScale = true;
		batch.hasUpdate = true;
		this.texture = null;
	}

	function makeTiles() {
		var t : h2d.Tile;

		// hide : create default particle
		if( h3d.Engine.getCurrent() == null ) {
			tiles = [];
			needRebuild = true;
			return;
		}

		if( texture == null )
			t = h2d.Tile.fromColor(0xFFFFFF, 16, 16);
		else
			t = h2d.Tile.fromTexture(texture);
		batch.tile = t;
		var dx = Std.int(t.width / frameDivisionX);
		var dy = Std.int(t.height / frameDivisionY);
		tiles = [for( y in 0...frameDivisionY ) for( x in 0...frameDivisionX ) if( frameCount == 0 || y * frameDivisionX + x < frameCount ) t.sub(x * dx, y * dy, dx, dy, -dx >> 1, -dy >> 1)];
		needRebuild = true;
	}

	public function rebuild() {
		needRebuild = false;
		batch.clear();
		for( i in 0...nparts ) {
			var p = new Particle(this);
			batch.add(p);
			init(p);
		}
	}

	function init( p : Particle ) {
		inline function srand() return hxd.Math.srand();
		inline function rand() return hxd.Math.random();
		inline function getAngleFromNormalized(a : Float, rand : Float = 1.) : Float {
			var newAngle = a * 0.5 * Math.PI * rand;
			if (a < 0) newAngle += Math.PI;
			return newAngle;
		};

		var g = this;
		var size = g.size * (1 + srand() * g.sizeRand);
		var rot = srand() * Math.PI * g.rotInit;
		var vrot = g.rotSpeed * (1 + rand() * g.rotSpeedRand) * (srand() < 0 ? -1 : 1);
		var life = g.life * (1 + srand() * g.lifeRand);
		var delay = rand() * life * (1 - g.emitSync) + g.emitDelay;
		var speed = g.speed * (1 + srand() * g.speedRand);
		if( g.life == 0 )
			life = 1e10;
		p.x = dx;
		p.y = dy;

		switch( g.emitMode ) {
			case Point:
				p.vx = srand();
				p.vy = srand();
				speed *= 1 / hxd.Math.sqrt(p.vx * p.vx + p.vy * p.vy);

				var r = g.emitStartDist + g.emitDist * rand();
				p.x += p.vx * r;
				p.y += p.vy * r;

			case Cone:
				if (g.emitAngle == 0) {
					p.vx = 0.;
					p.vy = 0.;
				}
				else {
					var theta = rand() * Math.PI * 2;
					var phi = getAngleFromNormalized(g.emitAngle, srand());
					p.vx = Math.sin(phi) * Math.cos(theta);
					p.vy = Math.cos(phi);
				}
				var r = g.emitStartDist + g.emitDist * rand();
				p.x += p.vx * r;
				p.y += p.vy * r;

			case Box:
				p.vx = srand();
				p.vy = srand();
				p.x += g.emitDist * srand();
				p.y += g.emitDistY * srand();

				var a = getAngleFromNormalized(g.emitAngle);
				var cosA = Math.cos(a);
				var sinA = Math.sin(a);
				var xx = cosA * (p.x - dx) - sinA * (p.y - dy) + dx;
				var yy = sinA * (p.x - dx) + cosA * (p.y - dy) + dy;
				p.x = xx;
				p.y = yy;

			case Direction:
				speed = Math.abs(speed);
				p.vx = Math.cos(g.emitAngle);
				p.vy = Math.sin(g.emitAngle);
				
				var r = g.emitStartDist + g.emitDist * rand();
				p.x += r * Math.cos(g.emitAngle - Math.PI / 2);
				p.y += r * Math.sin(g.emitAngle - Math.PI / 2);
		}

		p.scale = size;
		p.rotation = rot;
		p.vSize = g.sizeIncr;
		p.vr = vrot;
		p.t = animationRepeat == 0 ? tiles[Std.random(tiles.length)] : tiles[0];
		p.delay = delay;
		p.vx *= speed;
		p.vy *= speed;
		p.life = 0;
		p.maxLife = life;

		var rot = emitDirectionAsAngle ? Math.atan2(p.vy, p.vx) : srand() * Math.PI * g.rotInit;
		p.rotation = rot;

		if ( !isRelative ) {
			// Less this.parts access
			var parts = this.parts;
			// calcAbsPos() was already called, because during both rebuild() and Particle.update()
			// called during sync() call which calls this function if required before any of this happens.
			//parts.syncPos();

			var px = p.x;
			p.x = px * parts.matA + p.y * parts.matC + parts.absX;
			p.y = px * parts.matB + p.y * parts.matD + parts.absY;
			p.scaleX = Math.sqrt((parts.matA * parts.matA) + (parts.matC * parts.matC)) * size;
			p.scaleY = Math.sqrt((parts.matB * parts.matB) + (parts.matD * parts.matD)) * size;
			var rot = Math.atan2(parts.matB / p.scaleY, parts.matA / p.scaleX);
			p.rotation += rot;
			
			// Also rotate velocity.
			var cos = Math.cos(rot);
			var sin = Math.sin(rot);
			px = p.vx;
			p.vx = px * cos - p.vy * sin;
			p.vy = px * sin + p.vy * cos;
		}

	}

	public function save() {
		var o : Dynamic = {};
		for( f in getFields(this) )
			Reflect.setField(o, f, Reflect.field(this, f));
		o.emitMode = emitMode.getName();
		o.sortMode = sortMode.getName();
		o.blendMode = blendMode.getName();
		if( texture != null ) o.texture = texture.name;
		if( colorGradient != null ) o.colorGradient = colorGradient.name;
		return o;
	}

	public function load( version : Int, o : Dynamic ) {
		for( f in getFields(this) )
			if( Reflect.hasField(o,f) )
				Reflect.setProperty(this, f, Reflect.field(o, f));
		emitMode = PartEmitMode.createByName(o.emitMode);
		sortMode = PartSortMode.createByName(o.sortMode);
		blendMode = BlendMode.createByName(o.blendMode);
		if( o.texture != null ) texture = @:privateAccess parts.loadTexture(o.texture);
		if( o.colorGradient != null ) colorGradient = @:privateAccess parts.loadTexture(o.colorGradient);
	}

}

@:access(h2d.ParticleGroup)
class Particles extends Drawable {

	static inline var VERSION = 1;

	var groups : Array<ParticleGroup>;
	var resourcePath : String;
	var hideProps : Dynamic;
	var pshader : ParticleShader;

	public function new( ?parent ) {
		super(parent);
		groups = [];
		pshader = new ParticleShader();
		addShader(pshader);
	}

	function loadTexture( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toTexture();
	}

	public dynamic function onEnd() {
		for( g in groups )
			g.needRebuild = true;
	}

	public function save() : Dynamic {
		var obj : Dynamic = { type : "particles2D", version : VERSION, groups : [for( g in groups ) g.save()] };
		if( hideProps != null ) obj.hide = hideProps;
		return obj;
	}

	public function load( o : Dynamic, ?resourcePath : String ) {
		this.resourcePath = resourcePath;
		if( o.version == 0 || o.version > VERSION ) throw "Unsupported version " + o.version;
		for( g in (o.groups:Array<Dynamic>) )
			addGroup().load(o.version, g);
		hideProps = o.hide;
	}

	public function addGroup( ?g : ParticleGroup, ?index ) {
		if( g == null )
			g = new ParticleGroup(this);
		if( g.name == null )
			g.name = "Group#" + (groups.length + 1);
		if( index == null )
			index = groups.length;
		groups.insert(index, g);
		return g;
	}

	public function removeGroup( g : ParticleGroup ) {
		var idx = groups.indexOf(g);
		if( idx < 0 ) return;
		groups.splice(idx,1);
	}

	public function getGroup( name : String ) {
		for( g in groups )
			if( g.name == name )
				return g;
		return null;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		var hasPart = false;
		for( g in groups ) {
			if ( g.needRebuild && g.enable )
				g.rebuild();
			if( @:privateAccess g.batch.first != null )
				hasPart = true;
		}
		if( !hasPart )
			onEnd();
	}

	override function draw(ctx:RenderContext) {
		var old = blendMode;
		var realX : Float = absX;
		var realY : Float = absY;
		var realA : Float = matA;
		var realB : Float = matB;
		var realC : Float = matC;
		var realD : Float = matD;

		for( g in groups )
			if( g.enable ) {
				pshader.gradient = g.colorGradient;
				pshader.hasGradient = g.colorGradient != null && g.colorGradient.height == 1;
				pshader.has2DGradient = g.colorGradient != null && g.colorGradient.height > 1;
				blendMode = g.batch.blendMode;
				if ( g.isRelative ) {
					g.batch.drawWith(ctx, this);
				} else {
					matA = 1;
					matB = 0;
					matC = 0;
					matD = 1;
					absX = 0;
					absY = 0;
					g.batch.drawWith(ctx, this);
					matA = realA;
					matB = realB;
					matC = realC;
					matD = realD;
					absX = realX;
					absY = realY;
				}
			}
		blendMode = old;
	}

	public inline function getGroups() {
		return groups.iterator();
	}

}
