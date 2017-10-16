package h2d.col;
import hxd.Math;

class IBounds {

	public var xMin : Int;
	public var yMin : Int;

	public var xMax : Int;
	public var yMax : Int;


	public var x(get, set) : Int;
	public var y(get, set) : Int;
	public var width(get, set) : Int;
	public var height(get, set) : Int;

	public inline function new() {
		empty();
	}

	public inline function toBounds( scale = 1. ) {
		return Bounds.fromValues(x * scale, y * scale, width * scale, height * scale);
	}

	public inline function intersects( b : IBounds ) {
		return !(xMin > b.xMax || yMin > b.yMax || xMax < b.xMin || yMax < b.yMin);
	}

	public inline function contains( p : IPoint ) {
		return p.x >= xMin && p.x < xMax && p.y >= yMin && p.y < yMax;
	}

	public inline function addBounds( b : IBounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
	}

	public inline function addPoint( p : IPoint ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
	}

	public inline function addPos( x : Int, y : Int ) {
		if( x < xMin ) xMin = x;
		if( x > xMax ) xMax = x;
		if( y < yMin ) yMin = y;
		if( y > yMax ) yMax = y;
	}

	public inline function set(x, y, width, height) {
		this.xMin = x;
		this.yMin = y;
		this.xMax = x + width;
		this.yMax = y + height;
	}

	public inline function setMin( p : IPoint ) {
		xMin = p.x;
		yMin = p.y;
	}

	public inline function setMax( p : IPoint ) {
		xMax = p.x;
		yMax = p.y;
	}

	public inline function doIntersect( b : IBounds ) {
		xMin = Math.imax(xMin, b.xMin);
		yMin = Math.imax(yMin, b.yMin);
		xMax = Math.imin(xMax, b.xMax);
		yMax = Math.imin(yMax, b.yMax);
	}

	public inline function doUnion( b : IBounds ) {
		xMin = Math.imin(xMin, b.xMin);
		yMin = Math.imin(yMin, b.yMin);
		xMax = Math.imax(xMax, b.xMax);
		yMax = Math.imax(yMax, b.yMax);
	}

	public function intersection( b : IBounds ) {
		var i = new Bounds();
		i.xMin = Math.imax(xMin, b.xMin);
		i.yMin = Math.imax(yMin, b.yMin);
		i.xMax = Math.imin(xMax, b.xMax);
		i.yMax = Math.imin(yMax, b.yMax);
		if( i.xMax < i.xMin ) i.xMax = i.xMin;
		if( i.yMax < i.yMin ) i.yMax = i.yMin;
		return i;
	}

	public function union( b : IBounds ) {
		var i = new Bounds();
		i.xMin = Math.imin(xMin, b.xMin);
		i.yMin = Math.imin(yMin, b.yMin);
		i.xMax = Math.imax(xMax, b.xMax);
		i.yMax = Math.imax(yMax, b.yMax);
		return i;
	}

	public function load( b : IBounds ) {
		xMin = b.xMin;
		yMin = b.yMin;
		xMax = b.xMax;
		yMax = b.yMax;
	}

	public inline function offset( dx : Int, dy : Int ) {
		xMin += dx;
		xMax += dx;
		yMin += dy;
		yMax += dy;
	}

	public inline function getMin() {
		return new IPoint(xMin, yMin);
	}

	public inline function getCenter() {
		return new IPoint((xMin + xMax) >> 1, (yMin + yMax) >> 1);
	}

	public inline function getSize() {
		return new IPoint(xMax - xMin, yMax - yMin);
	}

	public inline function getMax() {
		return new IPoint(xMax, yMax);
	}

	public inline function isEmpty() {
		return xMax <= xMin || yMax <= yMin;
	}

	public inline function empty() {
		xMin = 0x7FFFFFFF;
		yMin = 0x7FFFFFFF;
		xMax = -2147483648;
		yMax = -2147483648;
	}

	public inline function all() {
		xMin = -2147483648;
		yMin = -2147483648;
		xMax = 0x7FFFFFFF;
		yMax = 0x7FFFFFFF;
	}

	public inline function clone() {
		var b = new IBounds();
		b.xMin = xMin;
		b.yMin = yMin;
		b.xMax = xMax;
		b.yMax = yMax;
		return b;
	}

	inline function get_x() {
		return xMin;
	}

	inline function get_y() {
		return yMin;
	}

	inline function set_x(x:Int) {
		xMax += x - xMin;
		return xMin = x;
	}

	inline function set_y(y:Int) {
		yMax += y - yMin;
		return yMin = y;
	}

	inline function get_width() {
		return xMax - xMin;
	}

	inline function get_height() {
		return yMax - yMin;
	}

	inline function set_width(w) {
		xMax = xMin + w;
		return w;
	}

	inline function set_height(h) {
		yMax = yMin + h;
		return h;
	}

	public function toString() {
		return "{" + getMin() + "," + getSize() + "}";
	}

	public static inline function fromValues( x0 : Int, y0 : Int, width : Int, height : Int ) {
		var b = new IBounds();
		b.xMin = x0;
		b.yMin = y0;
		b.xMax = x0 + width;
		b.yMax = y0 + height;
		return b;
	}

	public static inline function fromPoints( min : IPoint, max : IPoint ) {
		var b = new IBounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}

}
