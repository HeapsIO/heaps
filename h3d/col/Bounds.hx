package h3d.col;

class Bounds {
	
	public var xMin : Float;
	public var yMin : Float;
	public var zMin : Float;

	public var xMax : Float;
	public var yMax : Float;
	public var zMax : Float;
	
	public inline function new() {
		empty();
	}
	
	public function inFrustum( m : Matrix ) {

		// left
		if( testPlane(new Plane(m._14 + m._11, m._24 + m._21 , m._34 + m._31, m._44 + m._41)) < 0 )
			return false;
		
		// right
		if( testPlane(new Plane(m._14 - m._11, m._24 - m._21 , m._34 - m._31, m._44 - m._41)) < 0 )
			return false;

		// bottom
		if( testPlane(new Plane(m._14 + m._12, m._24 + m._22 , m._34 + m._32, m._44 + m._42)) < 0 )
			return false;

		// top
		if( testPlane(new Plane(m._14 - m._12, m._24 - m._22 , m._34 - m._32, m._44 - m._42)) < 0 )
			return false;

		// near
		if( testPlane(new Plane(m._13, m._23, m._33, m._43)) < 0 )
			return false;

		// far
		if( testPlane(new Plane(m._14 - m._13, m._24 - m._23, m._34 - m._33, m._44 - m._43)) < 0 )
			return false;
			
		return true;
	}
	
	inline function testPlane( p : Plane ) {
		var a = p.nx;
		var b = p.ny;
		var c = p.nz;
		var dd = a * (xMax + xMin) + b * (yMax + yMin) + c * (zMax + zMin);
		if( a < 0 ) a = -a;
		if( b < 0 ) b = -b;
		if( c < 0 ) c = -c;
		var rr = a * (xMax - xMin) + b * (yMax - yMin) + c * (zMax - zMin);
		return dd + rr + p.d*2;
	}
	
	public inline function collide( b : Bounds ) {
		return !(xMin > b.xMax || yMin > b.yMax || zMin > b.zMax || xMax < b.xMin || yMax < b.yMin || zMax < b.zMin);
	}
	
	public inline function add( b : Bounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
		if( b.zMin < zMin ) zMin = b.zMin;
		if( b.zMax > zMax ) zMax = b.zMax;
	}

	public inline function addPoint( p : Vector ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
		if( p.z < zMin ) zMin = p.z;
		if( p.z > zMax ) zMax = p.z;
	}
	
	public inline function setMin( p : Vector ) {
		xMin = p.x;
		yMin = p.y;
		zMin = p.z;
	}

	public inline function setMax( p : Vector ) {
		xMax = p.x;
		yMax = p.y;
		zMax = p.z;
	}
	
	public function load( b : Bounds ) {
		xMin = b.xMin;
		yMin = b.yMin;
		zMin = b.zMin;
		xMax = b.xMax;
		yMax = b.yMax;
		zMax = b.zMax;
	}
	
	public function scaleCenter( v : Float ) {
		var dx = (xMax - xMin) * 0.5 * v;
		var dy = (yMax - yMin) * 0.5 * v;
		var dz = (zMax - zMin) * 0.5 * v;
		var mx = (xMax + xMin) * 0.5;
		var my = (yMax + yMin) * 0.5;
		var mz = (zMax + zMin) * 0.5;
		xMin = mx - dx * v;
		yMin = my - dy * v;
		zMin = mz - dz * v;
		xMax = mx + dx * v;
		yMax = my + dy * v;
		zMax = mz + dz * v;
	}
	
	public inline function getMin() {
		return new Vector(xMin, yMin, zMin);
	}
	
	public inline function getCenter() {
		return new Vector((xMin + xMax) * 0.5, (yMin + yMax) * 0.5, (zMin + zMax) * 0.5);
	}

	public inline function getSize() {
		return new Vector(xMax - xMin, yMax - yMin, zMax - zMin);
	}
	
	public inline function getMax() {
		return new Vector(xMax, yMax, zMax);
	}
	
	public inline function empty() {
		xMin = 1e20;
		yMin = 1e20;
		zMin = 1e20;
		xMax = -1e20;
		yMax = -1e20;
		zMax = -1e20;
	}

	public inline function all() {
		xMin = -1e20;
		yMin = -1e20;
		zMin = -1e20;
		xMax = 1e20;
		yMax = 1e20;
		zMax = 1e20;
	}
	
	public inline function clone() {
		var b = new Bounds();
		b.xMin = xMin;
		b.yMin = yMin;
		b.zMin = zMin;
		b.xMax = xMax;
		b.yMax = yMax;
		b.zMax = zMax;
		return b;
	}
	
	public function toString() {
		return "{" + getMin() + "," + getMax() + "}";
	}
	
	public static inline function fromPoints( min : Vector, max : Vector ) {
		var b = new Bounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}
	
}