package h3d;
using hxd.Math;

/**
	A 4 floats vector. Everytime a Vector is returned, it means a copy is created.
**/
class Vector4Impl /*#if apicheck implements h2d.impl.PointApi<Vector4,Matrix> #end*/ {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;

	// -- gen api

	public inline function new( x = 0., y = 0., z = 0., w = 1. ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	/*
	
	// disable "length" based functions for now (
	
	public inline function distance( v : Vector4 ) {
		return Math.sqrt(distanceSq(v));
	}

	public inline function distanceSq( v : Vector4 ) {
		var dx = v.x - x;
		var dy = v.y - y;
		var dz = v.z - z;
		return dx * dx + dy * dy + dz * dz;
	}
	
	public inline function scaled( v : Float ) {
		// see scale
		return new Vector(x * v, y * v, z * v, w * v);
	}
	
	public inline function lengthSq() {
		return x * x + y * y + z * z;
	}

	public inline function length() {
		return lengthSq().sqrt();
	}

	public inline function normalize() {
		var k = lengthSq();
		if( k < hxd.Math.EPSILON2 ) k = 0 else k = k.invSqrt();
		x *= k;
		y *= k;
		z *= k;
	}

	public inline function normalized() {
		var k = lengthSq();
		if( k < hxd.Math.EPSILON2 ) k = 0 else k = k.invSqrt();
		return new Vector(x * k, y * k, z * k);
	}
	
	*/

	public inline function dot4( v : Vector4 ) {
		return x * v.x + y * v.y + z * v.z + w * v.w;
	}

	public inline function dot3( v : Vector4 ) {
		return x * v.x + y * v.y + z * v.z;
	}

	public inline function scale3( f : Float ) {
		x *= f;
		y *= f;
		z *= f;
	}
	
	public inline function sub( v : Vector4 ) {
		return new Vector4(x - v.x, y - v.y, z - v.z, w - v.w);
	}

	public inline function add( v : Vector4 ) {
		return new Vector4(x + v.x, y + v.y, z + v.z, w + v.w);
	}

	public inline function equals( v : Vector4 ) {
		return x == v.x && y == v.y && z == v.z && w == v.w;
	}

	public inline function cross( v : Vector4 ) {
		// note : cross product is left-handed
		return new Vector4(y * v.z - z * v.y, z * v.x - x * v.z,  x * v.y - y * v.x, 1);
	}

	public inline function set(x=0.,y=0.,z=0.,w=1.) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function load(v : Vector4 ) {
		this.x = v.x;
		this.y = v.y;
		this.z = v.z;
		this.w = v.w;
	}

	public inline function lerp( v1 : Vector4, v2 : Vector4, k : Float ) {
		this.x = Math.lerp(v1.x, v2.x, k);
		this.y = Math.lerp(v1.y, v2.y, k);
		this.z = Math.lerp(v1.z, v2.z, k);
		this.w = Math.lerp(v1.w, v2.w, k);
	}

	public inline function transform( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		var pw = x * m._14 + y * m._24 + z * m._34 + w * m._44;
		x = px;
		y = py;
		z = pz;
		w = pw;
	}

	public inline function transformed( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		var pw = x * m._14 + y * m._24 + z * m._34 + w * m._44;
		return new Vector4(px,py,pz,pw);
	}

	public inline function transform3x4( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		x = px;
		y = py;
		z = pz;
	}

	public inline function transformed3x4( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		return new Vector4(px,py,pz);
	}

	public inline function transform3x3( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31;
		var py = x * m._12 + y * m._22 + z * m._32;
		var pz = x * m._13 + y * m._23 + z * m._33;
		x = px;
		y = py;
		z = pz;
	}

	public inline function transformed3x3( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31;
		var py = x * m._12 + y * m._22 + z * m._32;
		var pz = x * m._13 + y * m._23 + z * m._33;
		return new Vector4(px,py,pz);
	}

	public inline function clone() {
		return new Vector4(x,y,z,w);
	}

	public inline function toVector() {
		return new h3d.Vector(x, y, z);
	}

	public function toString() {
		return '{${x.fmt()},${y.fmt()},${z.fmt()},${w.fmt()}}';
	}

	public inline function project( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		var iw = 1 / (x * m._14 + y * m._24 + z * m._34 + w * m._44);
		x = px * iw;
		y = py * iw;
		z = pz * iw;
		w = 1;
	}

	/// ----- COLOR FUNCTIONS

	public var r(get, set) : Float;
	public var g(get, set) : Float;
	public var b(get, set) : Float;
	public var a(get, set) : Float;

	inline function get_r() return x;
	inline function get_g() return y;
	inline function get_b() return z;
	inline function get_a() return w;
	inline function set_r(v) return x = v;
	inline function set_g(v) return y = v;
	inline function set_b(v) return z = v;
	inline function set_a(v) return w = v;

	public inline function setColor( c : Int ) {
		r = ((c >> 16) & 0xFF) / 255;
		g = ((c >> 8) & 0xFF) / 255;
		b = (c & 0xFF) / 255;
		a = (c >>> 24) / 255;
	}

	public function makeColor( hue : Float, saturation : Float = 1., brightness : Float = 0.5 ) {
		hue = Math.ufmod(hue, Math.PI * 2);
		var c = (1 - Math.abs(2 * brightness - 1)) * saturation;
		var x = c * (1 - Math.abs((hue * 3 / Math.PI) % 2. - 1));
		var m = brightness - c / 2;
		if( hue < Math.PI / 3 ) {
			r = c;
			g = x;
			b = 0;
		} else if( hue < Math.PI * 2 / 3 ) {
			r = x;
			g = c;
			b = 0;
		} else if( hue < Math.PI ) {
			r = 0;
			g = c;
			b = x;
		} else if( hue < Math.PI * 4 / 3 ) {
			r = 0;
			g = x;
			b = c;
		} else if( hue < Math.PI * 5 / 3 ) {
			r = x;
			g = 0;
			b = c;
		} else {
			r = c;
			g = 0;
			b = x;
		}
		r += m;
		g += m;
		b += m;
		a = 1;
	}

	public inline function toColor() {
		return (Std.int(a.clamp() * 255 + 0.499) << 24) | (Std.int(r.clamp() * 255 + 0.499) << 16) | (Std.int(g.clamp() * 255 + 0.499) << 8) | Std.int(b.clamp() * 255 + 0.499);
	}

	public function toColorHSL() {
	    var max = hxd.Math.max(hxd.Math.max(r, g), b);
		var min = hxd.Math.min(hxd.Math.min(r, g), b);
		var h, s, l = (max + min) / 2.0;

		if(max == min)
			h = s = 0.0; // achromatic
		else {
			var d = max - min;
			s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
			if(max == r)
				h = (g - b) / d + (g < b ? 6.0 : 0.0);
			else if(max == g)
				h = (b - r) / d + 2.0;
			else
				h = (r - g) / d + 4.0;
			h *= Math.PI / 3.0;
		}

		return new h3d.Vector4(h, s, l, a);
	}

}



/**
	A 4 floats vector. Everytime a Vector is returned, it means a copy is created.
	For function manipulating the length (length, normalize, dot, scale, etc.), the Vector
	acts like a Point in the sense only the X/Y/Z components will be affected.
**/
@:forward abstract Vector4(Vector4Impl) from Vector4Impl to Vector4Impl {

	public inline function new( x = 0., y = 0., z = 0., w = 1. ) {
		this = new Vector4Impl(x,y,z,w);
	}

	@:op(a - b) public inline function sub(v:Vector4) return this.sub(v);
	@:op(a + b) public inline function add(v:Vector4) return this.add(v);
	@:op(a *= b) public inline function transform(m:Matrix) this.transform(m);
	@:op(a * b) public inline function transformed(m:Matrix) return this.transformed(m);

	//@:op(a *= b) public inline function scale(v:Float) this.scale(v);
	//@:op(a * b) public inline function scaled(v:Float) return this.scaled(v);
	//@:op(a * b) static inline function scaledInv( f : Float, v : Vector4 ) return v.scaled(f);

	public static inline function fromColor( c : Int, scale : Float = 1.0 ) {
		var s = scale / 255;
		return new Vector4(((c>>16)&0xFF)*s,((c>>8)&0xFF)*s,(c&0xFF)*s,(c >>> 24)*s);
	}

	public static inline function fromArray(a : Array<Float>) {
		var r = new Vector4();
		if(a.length > 0) r.x = a[0];
		if(a.length > 1) r.y = a[1];
		if(a.length > 2) r.z = a[2];
		if(a.length > 3) r.w = a[3];
		return r;
	}

}