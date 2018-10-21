package h2d.col;
import hxd.Math;

class Bounds {

	public var xMin : Float;
	public var yMin : Float;

	public var xMax : Float;
	public var yMax : Float;


	public var x(get, set) : Float;
	public var y(get, set) : Float;
	public var width(get, set) : Float;
	public var height(get, set) : Float;

	public inline function new() {
		empty();
	}

	public inline function toIBounds( scale = 1. ) {
		var ix = Math.floor(x * scale);
		var iy = Math.floor(y * scale);
		return IBounds.fromValues(ix, iy, Math.ceil(xMax * scale) - ix, Math.ceil(yMax * scale) - iy);
	}

	public inline function intersects( b : Bounds ) {
		return !(xMin > b.xMax || yMin > b.yMax || xMax < b.xMin || yMax < b.yMin);
	}

	public inline function contains( p : Point ) {
		return p.x >= xMin && p.x < xMax && p.y >= yMin && p.y < yMax;
	}

	public inline function addBounds( b : Bounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
	}

	public inline function addPoint( p : Point ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
	}

	public inline function addPos( x : Float, y : Float ) {
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

	public inline function setMin( p : Point ) {
		xMin = p.x;
		yMin = p.y;
	}

	public inline function setMax( p : Point ) {
		xMax = p.x;
		yMax = p.y;
	}

	public inline function doIntersect( b : Bounds ) {
		xMin = Math.max(xMin, b.xMin);
		yMin = Math.max(yMin, b.yMin);
		xMax = Math.min(xMax, b.xMax);
		yMax = Math.min(yMax, b.yMax);
	}

	public inline function doUnion( b : Bounds ) {
		xMin = Math.min(xMin, b.xMin);
		yMin = Math.min(yMin, b.yMin);
		xMax = Math.max(xMax, b.xMax);
		yMax = Math.max(yMax, b.yMax);
	}

	public function intersection( b : Bounds ) {
		var i = new Bounds();
		i.xMin = Math.max(xMin, b.xMin);
		i.yMin = Math.max(yMin, b.yMin);
		i.xMax = Math.min(xMax, b.xMax);
		i.yMax = Math.min(yMax, b.yMax);
		if( i.xMax < i.xMin ) i.xMax = i.xMin;
		if( i.yMax < i.yMin ) i.yMax = i.yMin;
		return i;
	}

	public function union( b : Bounds ) {
		var i = new Bounds();
		i.xMin = Math.min(xMin, b.xMin);
		i.yMin = Math.min(yMin, b.yMin);
		i.xMax = Math.max(xMax, b.xMax);
		i.yMax = Math.max(yMax, b.yMax);
		return i;
	}

	public function load( b : Bounds ) {
		xMin = b.xMin;
		yMin = b.yMin;
		xMax = b.xMax;
		yMax = b.yMax;
	}

	public inline function scalePivot( v : Float ) {
		xMin *= v;
		yMin *= v;
		xMax *= v;
		yMax *= v;
	}

	public function scaleCenter( v : Float ) {
		var dx = (xMax - xMin) * 0.5 * v;
		var dy = (yMax - yMin) * 0.5 * v;
		var mx = (xMax + xMin) * 0.5;
		var my = (yMax + yMin) * 0.5;
		xMin = mx - dx;
		yMin = my - dy;
		xMax = mx + dx;
		yMax = my + dy;
	}

	public function rotate( angle : Float ) {
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		var x0 = xMin, y0 = yMin, x1 = xMax, y1 = yMax;
		empty();
		addPos(x0 * cos - y0 * sin, x0 * sin + y0 * cos);
		addPos(x1 * cos - y0 * sin, x1 * sin + y0 * cos);
		addPos(x0 * cos - y1 * sin, x0 * sin + y1 * cos);
		addPos(x1 * cos - y1 * sin, x1 * sin + y1 * cos);
	}

	public inline function offset( dx : Float, dy : Float ) {
		xMin += dx;
		xMax += dx;
		yMin += dy;
		yMax += dy;
	}

	public inline function getMin() {
		return new Point(xMin, yMin);
	}

	public inline function getCenter() {
		return new Point((xMin + xMax) * 0.5, (yMin + yMax) * 0.5);
	}

	public inline function getSize() {
		return new Point(xMax - xMin, yMax - yMin);
	}

	public inline function getMax() {
		return new Point(xMax, yMax);
	}

	public inline function isEmpty() {
		return xMax <= xMin || yMax <= yMin;
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
		var b = new Bounds();
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

	inline function set_x(x:Float) {
		xMax += x - xMin;
		return xMin = x;
	}

	inline function set_y(y:Float) {
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

	public static inline function fromValues( x0 : Float, y0 : Float, width : Float, height : Float ) {
		var b = new Bounds();
		b.xMin = x0;
		b.yMin = y0;
		b.xMax = x0 + width;
		b.yMax = y0 + height;
		return b;
	}

	public static inline function fromPoints( min : Point, max : Point ) {
		var b = new Bounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}

}