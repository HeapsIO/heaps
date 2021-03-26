package h3d.col;
using hxd.Math;

class IPoint #if apicheck implements h2d.impl.PointApi.IPointApi<IPoint> #end {

	public var x : Int;
	public var y : Int;
	public var z : Int;

	// -- gen api

	public inline function new(x=0,y=0,z=0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function toString() {
		return 'IPoint{$x,$y,$z}';
	}

	public inline function multiply( v : Int ) {
		return new IPoint(x * v, y * v, z * v);
	}

	public inline function set(x=0, y=0, z=0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function equals( other : IPoint ) : Bool {
		return x == other.x && y == other.y && z == other.z;
	}

	public inline function load( p : IPoint ) {
		this.x = p.x;
		this.y = p.y;
		this.z = p.z;
	}

	public inline function distanceSq( p : IPoint ) {
		var dx = p.x - x;
		var dy = p.y - y;
		var dz = p.z - z;
		return dx * dx + dy * dy + dz * dz;
	}

	public inline function distance( p : IPoint ) {
		return Math.sqrt(distanceSq(p));
	}

	public inline function lengthSq() {
		return x * x + y * y + z * z;
	}

	public inline function length() {
		return Math.sqrt(x * x + y * y + z * z);
	}

	public inline function clone() {
		return new IPoint(x,y,z);
	}

	public inline function scale( v : Int ) {
		x *= v;
		y *= v;
		z *= v;
	}

	public inline function add( p : IPoint ) {
		return new IPoint(x + p.x, y + p.y, z + p.z);
	}

	public inline function sub( p : IPoint ) {
		return new IPoint(x - p.x, y - p.y, z - p.z);
	}

	public inline function dot( p : IPoint ) {
		return x * p.x + y * p.y + z * p.z;
	}

	public inline function cross( p : IPoint ) {
		return new IPoint(y * p.z - z * p.y, z * p.x - x * p.z,  x * p.y - y * p.x);
	}

}