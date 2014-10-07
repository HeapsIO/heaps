package h3d.parts;

enum Value {
	VConst( v : Float );
	VLinear( start : Float, len : Float );
	VPow( start : Float, len : Float, pow : Float );
	VSin( freq : Float, ampl :  Float, offset : Float );
	VCos( freq : Float, ampl :  Float, offset : Float );
	VPoly( values : Array<Float>, points : Array<Float> );
	VRandom( start : Float, len : Float, converge : Converge );
	VCustom( p : Particle -> Float );
}

enum Converge {
	No;
	Start;
	End;
}

enum Shape {
	SLine( size : Value );
	SSphere( radius : Value );
	SCone( radius : Value, angle : Value  );
	SDisc( radius : Value );
	SCustom( initPartPosDir : Emitter -> Particle -> Void ); // Bool = on shell
}

class ValueXYZ {

	public var vx : Value;
	public var vy : Value;
	public var vz : Value;

	public function new(x, y, z) {
		this.vx = x;
		this.vy = y;
		this.vz = z;
	}

}

class ColorKey {

	public var time : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var next : ColorKey;

	public function new(time, r, g, b) {
		this.time = time;
		this.r = r;
		this.g = g;
		this.b = b;
	}

}

enum BlendMode {
	Add;
	Alpha;
	SoftAdd;
}

enum SortMode {
	Front;
	Back;
	Sort;
	InvSort;
}

interface Randomized {
	public function rand() : Float;
}

class State {

	// material
	public var textureName : String;
	public var frames : Array<h2d.Tile>;
	public var blendMode : BlendMode;
	public var sortMode : SortMode;
	public var is3D : Bool;
	public var isAlphaMap : Bool;

	// emit
	public var loop	: Bool;
	public var emitRate : Value;
	public var bursts : Array<{ time : Float, count : Int }>;
	public var maxParts : Int;
	public var shape : Shape;
	public var emitFromShell : Bool;
	public var emitLocal : Bool;
	public var emitTrail : Bool;
	public var randomDir : Bool;

	// system globals
	public var globalLife : Float;
	public var globalSpeed : Value;
	public var globalSize : Value;

	// particle globals
	public var life : Value;
	public var size : Value;
	public var ratio : Value;
	public var rotation : Value;
	public var speed : Value;
	public var gravity : Value;

	// effects
	public var force : Null<ValueXYZ>;
	public var colors : Null<Array<{ time : Float, color : Int }>>;
	public var light : Value;
	public var alpha : Value;

	// collide
	public var collide : Bool;
	public var collideKill : Bool;
	public var bounce : Float;

	// animation
	public var frame : Null<Value>;

	// extra
	public var delay : Float;
	public var update : Particle -> Void;

	public function new() {
	}

	public function setDefaults() {
		// material
		textureName = null;
		frames = null;
		blendMode = SoftAdd;
		sortMode = Back;
		is3D = false;
		isAlphaMap = false;
		// emit
		loop = true;
		emitRate = VConst(100);
		bursts = [];
		maxParts = 1000;
		shape = SCone(VConst(1),VConst(Math.PI/4));
		emitFromShell = false;
		emitLocal = false;
		randomDir = false;
		// system globals
		globalLife = 1;
		globalSpeed = VConst(1);
		globalSize = VConst(1);
		// particles globals
		life = VConst(1);
		size = VConst(1);
		ratio = VConst(1);
		rotation = VConst(0);
		speed = VConst(0.1);
		gravity = VConst(0);
		// effects
		force = null;
		colors = null;
		light = VConst(1);
		alpha = VConst(1);
		// collide
		collide = false;
		collideKill = false;
		bounce = 0;
		// extra
		delay = 0.;
	}

	@:noDebug public function scale( val : Value, v : Float ) {
		return switch( val ) {
		case VConst(c): VConst(c * v);
		case VRandom(start, len, c): VRandom(start * v, len * v, c);
		case VLinear(start, len): VLinear(start * v, len * v);
		case VPow(start, len, p): VPow(start * v, len * v, p);
		case VSin(f, a, o): VSin(f, a * v, o * v);
		case VCos(f, a, o): VCos(f, a * v, o * v);
		case VPoly(values, points): VPoly([for( v2 in values ) v * v2], [for( i in 0...points.length ) { var p = points[i]; if( i & 1 == 0 ) p else p * v; } ]);
		case VCustom(f): VCustom(function(p) return f(p) * v);
		}
	}

	public static inline function eval( v : Value, time : Float, r : Randomized, p : Particle ) : Float {
		return switch( v ) {
		case VConst(c): c;
		case VRandom(s, l, c): s + (switch( c ) { case No: l; case Start: l * time; case End: l * (1 - time); }) * r.rand();
		case VLinear(s, l): s + l * time;
		case VPow(s, l, p): s + Math.pow(time, p) * l;
		case VSin(f, a, o): Math.sin(time * f) * a + o;
		case VCos(f, a, o): Math.cos(time * f) * a + o;
		case VPoly(values,_):
			var y = 0.0;
			var j = values.length - 1;
			while( j >= 0 ) {
				y = values[j] + (time * y);
				j--;
			}
			y;
		case VCustom(f): f(p);
		}
	}

	public static var defPartAlpha = hxd.res.Embed.getResource("h3d/parts/defaultAlpha.png");
	public static var defPart = hxd.res.Embed.getResource("h3d/parts/default.png");

	public function initFrames() {
		if( textureName == null ) {
			var t = switch( blendMode ) {
			case Alpha: defPartAlpha.toTile();
			default: defPart.toTile();
			}
			frames = [t];
		} else if( frame != null && frames.length == 1 ) {
			var t = frames[0];
			var nw = Std.int(t.width / t.height);
			var nh = Std.int(t.height / t.width);
			if( nw > 1 ) {
				frames = [];
				for( i in 0...nw )
					frames.push(t.sub(i * t.height, 0, t.height, t.height));
			} else if( nh > 1 ) {
				frames = [];
				for( i in 0...nh )
					frames.push(t.sub(0, i * t.width, t.width, t.width));
			}
		}
	}

	public static function load( b : haxe.io.Bytes, loadTexture : String -> h2d.Tile ) {
		var state : State = haxe.Unserializer.run(b.toString());
		if( state.textureName != null ) {
			var t = loadTexture(state.textureName);
			if( t == null ) throw "Could not load " + state.textureName;
			state.frames = [t];
		}
		state.initFrames();
		return state;
	}

}