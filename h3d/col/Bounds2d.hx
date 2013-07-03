package h3d.col;

class Bounds2d {
	
	public var xMin : Float;
	public var yMin : Float;

	public var xMax : Float;
	public var yMax : Float;
	
	public inline function new() {
		empty();
	}
	
	public inline function collide( b : Bounds2d ) {
		return !(xMin > b.xMax || yMin > b.yMax || xMax < b.xMin || yMax < b.yMin);
	}
	
	public inline function add( b : Bounds2d ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
	}

	public inline function addPoint( p : Point2d ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
	}
	
	public inline function setMin( p : Point2d ) {
		xMin = p.x;
		yMin = p.y;
	}

	public inline function setMax( p : Point2d ) {
		xMax = p.x;
		yMax = p.y;
	}
	
	public function load( b : Bounds2d ) {
		xMin = b.xMin;
		yMin = b.yMin;
		xMax = b.xMax;
		yMax = b.yMax;
	}
	
	public function scaleCenter( v : Float ) {
		var dx = (xMax - xMin) * 0.5 * v;
		var dy = (yMax - yMin) * 0.5 * v;
		var mx = (xMax + xMin) * 0.5;
		var my = (yMax + yMin) * 0.5;
		xMin = mx - dx * v;
		yMin = my - dy * v;
		xMax = mx + dx * v;
		yMax = my + dy * v;
	}
	
	public inline function getMin() {
		return new Point2d(xMin, yMin);
	}
	
	public inline function getCenter() {
		return new Point2d((xMin + xMax) * 0.5, (yMin + yMax) * 0.5);
	}

	public inline function getSize() {
		return new Point2d(xMax - xMin, yMax - yMin);
	}
	
	public inline function getMax() {
		return new Point2d(xMax, yMax);
	}
	
	public inline function empty() {
		xMin = 1e20;
		yMin = 1e20;
		xMax = -1e20;
		yMax = -1e20;
	}

	public inline function all() {
		xMin = -1e20;
		yMin = -1e20;
		xMax = 1e20;
		yMax = 1e20;
	}
	
	public inline function clone() {
		var b = new Bounds2d();
		b.xMin = xMin;
		b.yMin = yMin;
		b.xMax = xMax;
		b.yMax = yMax;
		return b;
	}
	
	public function toString() {
		return "{" + getMin() + "," + getMax() + "}";
	}
	
	public static inline function fromPoints( min : Point2d, max : Point2d ) {
		var b = new Bounds2d();
		b.setMin(min);
		b.setMax(max);
		return b;
	}
	
}