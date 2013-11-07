package h3d.parts;

enum Value {
	VConst( v : Float );
	VLinear( start : Float, len : Float );
	VPow( start : Float, len : Float, pow : Float );
	VRandom( start : Float, len : Float );
	VCustom( lifeToValue : Float -> Float -> Float ); // time -> random -> value
}

enum Shape {
	SDir( x : Float, y : Float, z : Float );
	SSphere( radius : Float );
	SHemiSphere( radius : Float );
	SCustom( initPartPosDir : Emiter -> Particle -> Void ); // Bool = on shell
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
	public var a : Float;
	public var next : ColorKey;
	
	public function new(time, r, g, b, a) {
		this.time = time;
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
}

enum BlendMode {
	Add;
	Alpha;
	SoftAdd;
}

class State {
	
	// material
	public var textureName : String;
	public var texture : h3d.mat.Texture;
	public var blendMode : BlendMode;
	
	// emit
	public var loop	: Bool;
	public var emitRate : Value;
	public var bursts : Array<{ time : Float, count : Int }>;
	public var maxParts : Int;
	public var shape : Shape;
	public var emitFromShell : Bool;
	public var randomDir : Bool;

	// system globals
	public var globalLife : Float;
	public var globalSpeed : Value;
	public var globalSize : Value;
	
	// particle globals
	public var startLife : Value;
	public var startSize : Value;
	public var startRotation : Value;
	public var speed : Value;
	public var gravity : Value;
	
	// effects
	public var force : Null<ValueXYZ>;
	public var colors : Null<Array<{ time : Float, rgba : h3d.Vector }>>;
	
	public function new() {
	}
	
	public function setDefaults() {
		// material
		textureName = null;
		texture = null;
		blendMode = SoftAdd;
		// emit
		loop = true;
		emitRate = VConst(100);
		bursts = [];
		maxParts = 1000;
		shape = SSphere(1);
		emitFromShell = false;
		randomDir = false;
		// system globals
		globalLife = 1;
		globalSpeed = VConst(1);
		globalSize = VConst(1);
		// particles globals
		startLife = VConst(1);
		startSize = VConst(1);
		startRotation = VConst(0);
		speed = VConst(0.1);
		gravity = VConst(0);
		// effects
		force = null;
		colors = null;
	}
	
	public /*inline*/ function eval( v : Value, time : Float, rnd : Float ) : Float {
		return switch( v ) {
		case VConst(c): c;
		case VRandom(s, l): s + l * rnd;
		case VLinear(s, l): s + l * time;
		case VPow(s, l, p): s + Math.pow(time, p) * l;
		case VCustom(f): f(time, rnd);
		}
	}
	
}