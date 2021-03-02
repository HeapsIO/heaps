package h2d.col;
import hxd.Math;
/**
	A 2D bounding box often used for determining Object bounding area.

	Bounds holds min/max coordinates of bounding box instead of it's position and size.
	@see `Object.getBounds`
	@see `Object.getSize`
**/
class Bounds {

	/** X-axis left-most bounding box point. **/
	public var xMin : Float;
	/** Y-axis top-most bounding box point. **/
	public var yMin : Float;

	/** X-axis right-most bounding box point. **/
	public var xMax : Float;
	/** Y-axis bottom-most bounding box point. **/
	public var yMax : Float;

	/**
		X-axis position of the bounding box top-left corner. Modifying it alters both `Bounds.xMin` and `Bounds.xMax`.
	**/
	public var x(get, set) : Float;
	/**
		Y-axis position of the bounding box top-left corner. Modifying it alters both `Bounds.yMin` and `Bounds.yMax`.
	**/
	public var y(get, set) : Float;
	/**
		Width of the bounding box. Equivalent of `xMax - xMin`.
	**/
	public var width(get, set) : Float;
	/**
		Height of the bounding box. Equivalent of `yMax - yMin`.
	**/
	public var height(get, set) : Float;

	/**
		Create new empty Bounds instance.
	**/
	public inline function new() {
		empty();
	}

	/**
		Converts bounding box to integer bounding box scaled by provided scalar `scale` (rounded down for `min` and up for `max`).
	**/
	public inline function toIBounds( scale = 1. ) : IBounds {
		var ix = Math.floor(x * scale);
		var iy = Math.floor(y * scale);
		return IBounds.fromValues(ix, iy, Math.ceil(xMax * scale) - ix, Math.ceil(yMax * scale) - iy);
	}

	/**
		Tests if this Bounds instance intersects with given `b` Bounds.
	**/
	public inline function intersects( b : Bounds ) : Bool {
		return !(xMin > b.xMax || yMin > b.yMax || xMax < b.xMin || yMax < b.yMin);
	}

	/**
		Tests if the Point `p` is inside the bounding box.
	**/
	public inline function contains( p : Point ) : Bool {
		return p.x >= xMin && p.x < xMax && p.y >= yMin && p.y < yMax;
	}

	/**
	 * Same as distance but does not perform sqrt
	 */
	 public inline function distanceSq( p : Point ) {
		var dx = p.x < xMin ? xMin - p.x : p.x > xMax ? p.x - xMax : 0.;
		var dy = p.y < yMin ? yMin - p.y : p.y > yMax ? p.y - yMax : 0.;
		return dx * dx + dy * dy;
	}

	/**
	 * Returns the distance betwen the point and the bounds. Or 0 if the point is inside the bounds.
	 */
	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

	/**
		Adds Bounds `b` to the Bounds, expanding min/max when necessary.
	**/
	public inline function addBounds( b : Bounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
	}

	/**
		Adds the Point `p` to the bounding box, expanding min/max when necessary.
	**/
	public inline function addPoint( p : Point ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
	}

	/**
		Adds the `x` and `y` position to the bounding box, expanding min/max when necessary.
	**/
	public inline function addPos( x : Float, y : Float ) {
		if( x < xMin ) xMin = x;
		if( x > xMax ) xMax = x;
		if( y < yMin ) yMin = y;
		if( y > yMax ) yMax = y;
	}

	/**
		Sets the bounding box from the given rectangle.
		@param x Rectangle top-left corner horizontal position.
		@param y Rectangle top-left corner vertical position.
		@param width Rectangle width.
		@param height Rectangle height.
	**/
	public inline function set( x : Float, y : Float, width : Float, height : Float ) {
		this.xMin = x;
		this.yMin = y;
		this.xMax = x + width;
		this.yMax = y + height;
	}

	/**
		Sets the `Bounds.xMin` and `Bounds.yMin` to values in the given Point `p`.
	**/
	public inline function setMin( p : Point ) {
		xMin = p.x;
		yMin = p.y;
	}

	/**
		Sets the `Bounds.xMax` and `Bounds.yMax` to values in the given Point `p`.
	**/
	public inline function setMax( p : Point ) {
		xMax = p.x;
		yMax = p.y;
	}

	/**
		Sets the bounding box min/max values to a result of the intersection between this Bounds and the given Bounds `b`.

		See `Bounds.intersection` to get new instance of Bounds as intersection result.
	**/
	public inline function doIntersect( b : Bounds ) {
		xMin = Math.max(xMin, b.xMin);
		yMin = Math.max(yMin, b.yMin);
		xMax = Math.min(xMax, b.xMax);
		yMax = Math.min(yMax, b.yMax);
	}

	/**
		Sets this bounding box min/max values to a result of combining this Bounds and the given Bounds `b`.

		Equivalent of `Bounds.addBounds`.
	**/
	public inline function doUnion( b : Bounds ) {
		xMin = Math.min(xMin, b.xMin);
		yMin = Math.min(yMin, b.yMin);
		xMax = Math.max(xMax, b.xMax);
		yMax = Math.max(yMax, b.yMax);
	}

	/**
		Returns a new Bounds instance containing intersection results of this Bounds and the given Bounds `b`.
	**/
	public function intersection( b : Bounds ) : Bounds {
		var i = new Bounds();
		i.xMin = Math.max(xMin, b.xMin);
		i.yMin = Math.max(yMin, b.yMin);
		i.xMax = Math.min(xMax, b.xMax);
		i.yMax = Math.min(yMax, b.yMax);
		if( i.xMax < i.xMin ) i.xMax = i.xMin;
		if( i.yMax < i.yMin ) i.yMax = i.yMin;
		return i;
	}

	/**
		Returns a new Bounds instance containing union of this Bounds and the given Bounds `b`.
	**/
	public function union( b : Bounds ) : Bounds {
		var i = new Bounds();
		i.xMin = Math.min(xMin, b.xMin);
		i.yMin = Math.min(yMin, b.yMin);
		i.xMax = Math.max(xMax, b.xMax);
		i.yMax = Math.max(yMax, b.yMax);
		return i;
	}

	/**
		Copies the min/max values from the given Bounds `b` to this Bounds.
	**/
	public function load( b : Bounds ) {
		xMin = b.xMin;
		yMin = b.yMin;
		xMax = b.xMax;
		yMax = b.yMax;
	}

	/**
		Scales the min/max values relative to `0,0` coordinate.
	**/
	public inline function scalePivot( v : Float ) {
		xMin *= v;
		yMin *= v;
		xMax *= v;
		yMax *= v;
	}

	/**
		Scales the min/max values relative the current bounding box center point.
	**/
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

	/**
		Rotates the bounding box around `0,0` point by given `angle` and sets min/max to the new rotated boundaries.
	**/
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

	/**
		Moves entire bounding box by `dx, dy`.
	**/
	public inline function offset( dx : Float, dy : Float ) {
		xMin += dx;
		xMax += dx;
		yMin += dy;
		yMax += dy;
	}

	/**
		Returns a new Point containing `Bounds.xMin` and `Bounds.yMin`.
	**/
	public inline function getMin() : Point {
		return new Point(xMin, yMin);
	}

	/**
		Returns a new Point containing the center coordinate of the bounding box.
	**/
	public inline function getCenter() : Point {
		return new Point((xMin + xMax) * 0.5, (yMin + yMax) * 0.5);
	}

	/**
		Returns a new Point containing size of the bounding box.
	**/
	public inline function getSize() : Point {
		return new Point(xMax - xMin, yMax - yMin);
	}

	/**
		Returns a new Point containing `Bounds.xMax` and `Bounds.yMax`.
	**/
	public inline function getMax() : Point {
		return new Point(xMax, yMax);
	}

	/**
		Tests if bounding box is empty.
		Bounds are considered empty when either `Bounds.xMax` is less than or equals to `Bounds.xMin` or `Bounds.yMax` is less than or equals to `Bounds.yMin`.
	**/
	public inline function isEmpty() : Bool {
		return xMax <= xMin || yMax <= yMin;
	}

	/**
		Clears bounding box into an empty state.
	**/
	public inline function empty() {
		xMin = 1e20;
		yMin = 1e20;
		xMax = -1e20;
		yMax = -1e20;
	}

	/**
		Sets the bounding box to cover maximum area (`-1e20...1e20`).
	**/
	public inline function all() {
		xMin = -1e20;
		yMin = -1e20;
		xMax = 1e20;
		yMax = 1e20;
	}

	/**
		Returns new copy of this Bounds instance.
	**/
	public inline function clone() : Bounds {
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

	@:dox(hide)
	public function toString() : String {
		return "{" + getMin() + "," + getSize() + "}";
	}

	/**
		Returns the bounding circle which includes all the bounds.
	**/
	public inline function toCircle() {
		var dx = xMax - xMin;
		var dy = yMax - yMin;
		return new Circle((xMin + xMax) * 0.5, (yMin + yMax) * 0.5, Math.sqrt(dx * dx + dy * dy) * 0.5);
	}

	/**
		Returns a new Bounds instance from given rectangle.
		@param x Rectangle horizontal position.
		@param y Rectangle vertical position.
		@param width Rectangle width.
		@param height Rectangle height.
	**/
	public static inline function fromValues( x0 : Float, y0 : Float, width : Float, height : Float ) : Bounds {
		var b = new Bounds();
		b.xMin = x0;
		b.yMin = y0;
		b.xMax = x0 + width;
		b.yMax = y0 + height;
		return b;
	}

	/**
		Returns a new Bounds instance from given `min`/`max` Points.
	**/
	public static inline function fromPoints( min : Point, max : Point ) : Bounds {
		var b = new Bounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}

}