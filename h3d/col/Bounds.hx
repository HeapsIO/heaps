package h3d.col;

class Bounds {
	
	public var xMin : Float;
	public var yMin : Float;
	public var zMin : Float;

	public var xMax : Float;
	public var yMax : Float;
	public var zMax : Float;
	
	public inline function new() {
		xMin = 1e20;
		yMin = 1e20;
		zMin = 1e20;
		xMax = -1e20;
		yMax = -1e20;
		zMax = -1e20;
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
	
	public inline function getMin() {
		return new Vector(xMin, yMin, zMin);
	}

	public inline function getMax() {
		return new Vector(xMax, yMax, zMax);
	}
	
	public inline function reset() {
		xMin = 1e20;
		yMin = 1e20;
		zMin = 1e20;
		xMax = -1e20;
		yMax = -1e20;
		zMax = -1e20;
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
}