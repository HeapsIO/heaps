package h2d.col;
import hxd.Math;

/**
	An integer-based bounding box.
	@see `h2d.col.Bounds`
**/
class IBounds {

	/** X-axis left-most bounding box point. **/
	public var xMin : Int;
	/** Y-axis top-most bounding box point. **/
	public var yMin : Int;

	/** X-axis right-most bounds box point. **/
	public var xMax : Int;
	/** Y-axis bottom-most bounding box point. **/
	public var yMax : Int;


	/**
		X-axis position of the bounding-box top-left corner. Modifying it alters both `xMin` and `xMax`.
	**/
	public var x(get, set) : Int;
	/**
		Y-axis position of the bounding-box top-left corner. Modifying it alters both `xMin` and `xMax`.
	**/
	public var y(get, set) : Int;
	/**
		Width of the bounding box. Equivalent of `xMax - xMin`.
	**/
	public var width(get, set) : Int;
	/**
		Height of the bounding box. Equivalent of `yMax - yMin`.
	**/
	public var height(get, set) : Int;

	/**
		Create new empty IBounds instance.
	**/
	public inline function new() {
		empty();
	}

	/**
		Converts `IBounds` to regular `Bounds` scaled by provided scalar `scale`.
	**/
	public inline function toBounds( scale = 1. ) : Bounds {
		return Bounds.fromValues(x * scale, y * scale, width * scale, height * scale);
	}

	/**
		Tests if this IBounds instances intersects given `b` IBounds.
	**/
	public inline function intersects( b : IBounds ) : Bool {
		return !(xMin > b.xMax || yMin > b.yMax || xMax < b.xMin || yMax < b.yMin);
	}

	/**
		Tests if IPoint `p` is inside the IBounds.
	**/
	public inline function contains( p : IPoint ) : Bool {
		return p.x >= xMin && p.x < xMax && p.y >= yMin && p.y < yMax;
	}

	/**
		Adds IBounds `b` to the IBounds, expanding min/max when necessary.
	**/
	public inline function addBounds( b : IBounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
	}

	/**
		Adds IPoint `p` to the IBounds, expanding min/max when necessary.
	**/
	public inline function addPoint( p : IPoint ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
	}

	/**
		Adds position `x` and `y` to the IBounds, expanding min/max when necessary.
	**/
	public inline function addPos( x : Int, y : Int ) {
		if( x < xMin ) xMin = x;
		if( x > xMax ) xMax = x;
		if( y < yMin ) yMin = y;
		if( y > yMax ) yMax = y;
	}

	/**
		Sets bounds from given rectangle.
		@param x Rectangle horizontal position.
		@param y Rectangle vertical position.
		@param width Rectangle width.
		@param height Rectangle height.
	**/
	public inline function set(x : Int, y : Int, width : Int, height : Int) {
		this.xMin = x;
		this.yMin = y;
		this.xMax = x + width;
		this.yMax = y + height;
	}

	/**
		Sets `xMin` and `yMin` to values in given IPoint `p`.
	**/
	public inline function setMin( p : IPoint ) {
		xMin = p.x;
		yMin = p.y;
	}

	/**
		Sets `xMax` and `yMax` to values in given IPoint `p`.
	**/
	public inline function setMax( p : IPoint ) {
		xMax = p.x;
		yMax = p.y;
	}

	/**
		Sets this IBounds min/max values to a result of intersection between this IBounds and given IBounds `b`.
		See `intersection` to get new instance of IBounds as intersection result.
	**/
	public inline function doIntersect( b : IBounds ) {
		xMin = Math.imax(xMin, b.xMin);
		yMin = Math.imax(yMin, b.yMin);
		xMax = Math.imin(xMax, b.xMax);
		yMax = Math.imin(yMax, b.yMax);
	}

	/**
		Sets this IBounds min/max values to a result of combining this IBounds and given IBounds `b`. Equivalent of `addBounds`.
	**/
	public inline function doUnion( b : IBounds ) {
		xMin = Math.imin(xMin, b.xMin);
		yMin = Math.imin(yMin, b.yMin);
		xMax = Math.imax(xMax, b.xMax);
		yMax = Math.imax(yMax, b.yMax);
	}

	/**
		Returns new Bounds instance containing intersection results of this IBounds and given IBounds `b`.
	**/
	public function intersection( b : IBounds ) : IBounds {
		var i = new IBounds();
		i.xMin = Math.imax(xMin, b.xMin);
		i.yMin = Math.imax(yMin, b.yMin);
		i.xMax = Math.imin(xMax, b.xMax);
		i.yMax = Math.imin(yMax, b.yMax);
		if( i.xMax < i.xMin ) i.xMax = i.xMin;
		if( i.yMax < i.yMin ) i.yMax = i.yMin;
		return i;
	}

	/**
		Returns new Bounds instance containing union of this IBounds and given IBounds `b`.
	**/
	public function union( b : IBounds ) : IBounds {
		var i = new IBounds();
		i.xMin = Math.imin(xMin, b.xMin);
		i.yMin = Math.imin(yMin, b.yMin);
		i.xMax = Math.imax(xMax, b.xMax);
		i.yMax = Math.imax(yMax, b.yMax);
		return i;
	}

	/**
		Copies min/max values from given IBounds `b` to this IBounds.
	**/
	public function load( b : IBounds ) {
		xMin = b.xMin;
		yMin = b.yMin;
		xMax = b.xMax;
		yMax = b.yMax;
	}

	/**
		Moves entire bounding box by `dx,dy`.
	**/
	public inline function offset( dx : Int, dy : Int ) {
		xMin += dx;
		xMax += dx;
		yMin += dy;
		yMax += dy;
	}

	/**
		Returns a new IPoint containing `xMin` and `yMin`.
	**/
	public inline function getMin() : IPoint {
		return new IPoint(xMin, yMin);
	}

	/**
		Returns a new IPoint containing center coordinate of the IBounds.
	**/
	public inline function getCenter() : IPoint {
		return new IPoint((xMin + xMax) >> 1, (yMin + yMax) >> 1);
	}

	/**
		Returns a new IPoint containing size of the IBounds.
	**/
	public inline function getSize() : IPoint {
		return new IPoint(xMax - xMin, yMax - yMin);
	}

	/**
		Returns a new IPoint containing `xMax` and `yMax`.
	**/
	public inline function getMax() : IPoint {
		return new IPoint(xMax, yMax);
	}

	/**
		Tests if bounding box is empty.
		IBounds are considered empty when either `xMax` is less than or equals to `xMin` or `yMax` is less than or equals to `yMin`.
	**/
	public inline function isEmpty() : Bool {
		return xMax <= xMin || yMax <= yMin;
	}

	/**
		Clears IBounds into an empty state.
	**/
	public inline function empty() {
		xMin = 0x7FFFFFFF;
		yMin = 0x7FFFFFFF;
		xMax = -2147483648;
		yMax = -2147483648;
	}

	/**
		Sets bounds to cover maximum area (`-2147483648...0x7FFFFFFF`).
	**/
	public inline function all() {
		xMin = -2147483648;
		yMin = -2147483648;
		xMax = 0x7FFFFFFF;
		yMax = 0x7FFFFFFF;
	}

	/**
		Returns new copy of this IBounds instance.
	**/
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

	@:dox(hide)
	public function toString() {
		return "{" + getMin() + "," + getSize() + "}";
	}

	/**
		Returns a new IBounds instance from given rectangle.
		@param x Rectangle horizontal position.
		@param y Rectangle vertical position.
		@param width Rectangle width.
		@param height Rectangle height.
	**/
	public static inline function fromValues( x0 : Int, y0 : Int, width : Int, height : Int ) : IBounds {
		var b = new IBounds();
		b.xMin = x0;
		b.yMin = y0;
		b.xMax = x0 + width;
		b.yMax = y0 + height;
		return b;
	}

	/**
		Returns a new IBounds instance from given min/max IPoints.
	**/
	public static inline function fromPoints( min : IPoint, max : IPoint ) : IBounds {
		var b = new IBounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}

}
