package h2d;

/**
	See `ParticleGroup.sortMode` - not used anywhere.
**/
@:dox(hide)
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

/**
	The particle emission pattern modes. See `ParticleGroup.emitMode`.
**/
enum PartEmitMode {
	/**
		A single Point, that emits in all directions.
	**/
	Point;
	/**
		A cone, parametrized with `emitAngle` and `emitDistance`.
	**/
	Cone;
	/**
		A box, parametrized with `emitDist` and `emitDistY`.
	**/
	Box;
	/**
		A box, parametrized with `emitAngle` and `emitDistance`.
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

/**
	An emitter of a single particle group. Part of `Particles` simulation system.
**/
@:access(h2d.SpriteBatch)
@:access(h2d.Object)
class ParticleGroup {

	static var FIELDS = null;
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

	/**
		The group name.
	**/
	public var name : String;
	/**
		Disabling the group immediately removes it from rendering and resets it's state.
	**/
	public var enable(default, set) : Bool = true;
	/**
		Does nothing.
	**/
	public var sortMode(default, set) : PartSortMode = None;
	/**
		Configures blending mode for this group.
	**/
	public var blendMode(default, set) : BlendMode = Alpha;

	/**
		Maximum number of particles alive at a time.
	**/
	public var nparts(default, set) : Int 		= 100;
	/**
		Initial particle X offset.
	**/
	public var dx(default, set) : Int 			= 0;
	/**
		Initial particle Y offset.
	**/
	public var dy(default, set) : Int 			= 0;

	/**
		If enabled, group will emit new particles indefinitely maintaining number of particles at `ParticleGroup.nparts`.
	**/
	public var emitLoop(default, set) : Bool 	= true;
	/**
		The pattern in which particles are emitted. See individual `PartEmitMode` values for more details.
	**/
	public var emitMode(default, set):PartEmitMode = Point;
	/**
		Initial particle position distance from emission point.
	**/
	public var emitStartDist(default, set) : Float = 0.;
	/**
		Additional random particle position distance from emission point.
	**/
	public var emitDist(default, set) : Float	= 50.;
	/**
		Secondary random position distance modifier (used by `Box` emitMode)
	**/
	public var emitDistY(default, set) : Float	= 50.;
	/**
		Normalized particle emission direction angle.
	**/
	public var emitAngle(default, set) : Float 	= -0.5;
	/**
		When enabled, particle rotation will match the particle movement direction angle.
	**/
	public var emitDirectionAsAngle(default, set) : Bool = false;
	/**
		Randomized synchronization delay before particle appears after being emitted.

		Usage note for non-relative mode: Particle will use configuration that was happened at time of emission, not when delay timer runs out.
	**/
	public var emitSync(default, set) : Float	= 0;
	/**
		Fixed delay before particle appears after being emitted.

		Usage note for non-relative mode: Particle will use configuration that was happened at time of emission, not when delay timer runs out.
	**/
	public var emitDelay(default, set) : Float	= 0;

	/**
		Initial particle size.
	**/
	public var size(default, set) : Float		= 1;
	/**
		If set, particle will change it's size with time.
	**/
	public var sizeIncr(default, set) : Float	= 0;
	/**
		If enabled, particle will increase on X-axis with `sizeIncr`.
	**/
	public var incrX(default, set) : Bool		= true;
	/**
		If enabled, particle will increase on Y-axis with `sizeIncr`.
	**/
	public var incrY(default, set) : Bool		= true;
	/**
		Additional random size increase when particle is created.
	**/
	public var sizeRand(default, set) : Float	= 0;

	/**
		Initial particle lifetime.
	**/
	public var life(default, set) : Float		= 1;
	/**
		Additional random lifetime increase when particle is created.
	**/
	public var lifeRand(default, set) : Float	= 0;

	/**
		Initial particle velocity.
	**/
	public var speed(default, set) : Float			= 50.;
	/**
		Additional random velocity increase when particle is created.
	**/
	public var speedRand(default, set) : Float		= 0;
	/**
		If set, particle velocity will change over time.
	**/
	public var speedIncr(default, set) : Float		= 0;
	/**
		Gravity applied to the particle.
	**/
	public var gravity(default, set) : Float		= 0;
	/**
		The gravity angle in radians. `0` points down.
	**/
	public var gravityAngle(default, set) : Float 	= 0;
	@:noCompletion @:dox(hide) public var cosGravityAngle : Float;
	@:noCompletion @:dox(hide) public var sinGravityAngle : Float;

	/**
		Initial particle rotation.
	**/
	public var rotInit(default, set) : Float	= 0;
	/**
		Initial rotation speed of the particle.
	**/
	public var rotSpeed(default, set) : Float	= 0;
	/**
		Additional random rotation speed when particle is created.
	**/
	public var rotSpeedRand(default, set):Float = 0;
	/**
		If enabled, particles will be automatically rotated in the direction of particle velocity.
	**/
	public var rotAuto							= false;

	/**
		The time in seconds during which particle alpha fades in after being emitted.
	**/
	public var fadeIn : Float					= 0.2;
	/**
		The time in seconds at which particle will start to fade out before dying. Fade out time can be calculated with `lifetime - fadeOut`.
	**/
	public var fadeOut : Float					= 0.8;
	/**
		The exponent of the alpha transition speed on fade in and fade out.
	**/
	public var fadePower : Float				= 1;

	/**
		Total count of frames used by the group.

		When 0, amount of frames in a group calculated by `frameDivisionX * frameDivisionY`.

		Otherwise it's `min(frameDivisionX * frameDivisionY, frameCount)`.
	**/
	public var frameCount(default,set) : Int		= 0;
	/**
		Horizontal frame divisor.
	**/
	public var frameDivisionX(default,set) : Int	= 1;
	/**
		Vertical frame divisor.
	**/
	public var frameDivisionY(default,set) : Int	= 1;
	/**
		The amount of times the animations will loop during lifetime.
		Settings it to 0 will stop the animation playback and each particle will have a random frame assigned at emission time.
	**/
	public var animationRepeat(default,set) : Float	= 1;
	/**
		The texture used to render particles.
	**/
	public var texture(default,set) : h3d.mat.Texture;
	/**
		Optional color gradient texture for tinting.
	**/
	public var colorGradient(default,set) : h3d.mat.Texture;

	/**
		When enabled, causes particles to always render relative to the emitter position, moving along with it.
		Otherwise, once emitted, particles won't follow the emitter, and will render relative to the scene origin.

		Non-relative mode is useful for simulating something like a smoke coming from a moving object,
		while relative mode things like jet flame that have to stick to its emission source.
	**/
	public var isRelative(default, set) : Bool = true;
	/**
		Should group rebuild on parameters change.

		Note that some parameters take immediate effect on the existing particles, and some would force rebuild regardless of this setting.

		Parameters that take immediate effect:
		`speedIncr`, `gravity`, `gravityAngle`, `fadeIn`, `fadeOut`, `fadePower`, `rotAuto`, `rotInit`, `incrX`, `incrY`, `emitLoop` and `blendMode`

		Parameters that will always force rebuild:
		`enable`, `sortMode`, `isRelative`, `texture`, `frameCount`, `frameDivisionX`, `frameDivisionY` and `nparts`

		Parameters that newer cause rebuild:
		`blendMode`, `colorGradient` and `animationRepeat`
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

	/**
		Create a new particle group instance.
		@param p The parent Particles instance. Group does not automatically adds itself to the Particles.
	**/
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

	/**
		Reset current state of particle group and re-emit all particles.
	**/
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

	/**
		Saves the particle group configuration into a `Dynamic` object.
	**/
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

	/**
		Loads the particle group configuration from a given object.

		@param version The version of Particles that were used to save the configuration.
		@param o The previously saved configuration data to load.
	**/
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

/**
	A 2D particle system with wide range of customizability.

	The Particles instance can contain multiple `ParticleGroup` instances - each of which works independently from one another.

	To simplify designing of the particles [HIDE](https://github.com/HeapsIO/hide/) contains a dedicated 2D particle editor and
	stores the particle data in a JSON format, which then can be loaded with the `Particles.load` method:
	```haxe
	var part = new h2d.Particles();
	part.load(haxe.Json.parse(hxd.Res.my_parts_file.entry.getText()), hxd.Res.my_parts_file.entry.path);
	```
**/
@:access(h2d.ParticleGroup)
class Particles extends Drawable {

	static inline var VERSION = 1;

	var groups : Array<ParticleGroup>;
	var resourcePath : String;
	var hideProps : Dynamic;
	var pshader : ParticleShader;

	/**
		Create a new Particles instance.
		@param parent An optional parent `h2d.Object` instance to which Particles adds itself if set.
	**/
	public function new( ?parent ) {
		super(parent);
		groups = [];
		pshader = new ParticleShader();
		addShader(pshader);
	}

	function loadTexture( path : String ) {
		return hxd.res.Loader.currentInstance.load(path).toTexture();
	}

	/**
		Sent when all particle groups stopped playback.
		Restarts all groups by default.
	**/
	public dynamic function onEnd() {
		for( g in groups )
			g.needRebuild = true;
	}

	/**
		Saves Particles settings and returns an object that can be saved into a file and then loaded with a `Particles.load` method.
	**/
	public function save() : Dynamic {
		var obj : Dynamic = { type : "particles2D", version : VERSION, groups : [for( g in groups ) g.save()] };
		if( hideProps != null ) obj.hide = hideProps;
		return obj;
	}

	/**
		Loads previously saved Particles settings.
		@param o The saved Particles settings.
		@param resourcePath An optional path of the configuration file. May be safely omitted.
	**/
	public function load( o : Dynamic, ?resourcePath : String ) {
		this.resourcePath = resourcePath;
		if( o.version == 0 || o.version > VERSION ) throw "Unsupported version " + o.version;
		for( g in (o.groups:Array<Dynamic>) )
			addGroup().load(o.version, g);
		hideProps = o.hide;
	}

	/**
		Add new particle group to the Particles.
		@param g Particle group to add. If null, will create an empty ParticleGroup.
		Note that when passing existing group, it should be created with this Particles instanceas the constructor argument,
		otherwise it may lead to undefined behavior.
		@param index Optional insertion index at which the group should be inserted.
		@returns Added ParticleGroup instance.
	**/
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

	/**
		Removes the group from the Particles.
	**/
	public function removeGroup( g : ParticleGroup ) {
		var idx = groups.indexOf(g);
		if( idx < 0 ) return;
		groups.splice(idx,1);
	}

	/**
		Returns a group with a specified name or `null` if none found.
	**/
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

	/**
		Returns an Iterator of particle groups within Particles.
	**/
	public inline function getGroups() {
		return groups.iterator();
	}

}