package hxd.clipper;

abstract Polygon(Array<Point>) {

	public var length(get, never): Int;
	public var points(get, never) : Array<Point>;

	public inline function new(?pts) {
		this = pts == null ? [] : pts;
	}

	public inline function add(x, y) {
		this.push(new Point(x, y));
	}

	public inline function addPoint(p) {
		this.push(p);
	}

	inline function get_points() : Array<Point> {
		return this;
	}

	inline function get_length() {
		return this.length;
	}

	public inline function reverse() {
		this.reverse();
	}

	public function getArea() {
		var highI = this.length - 1;
		if (highI < 2) return 0.;
		/*if (FullRangeNeeded(poly))
		{
			var a:Int128 = new Int128(0);
			a = Int128.Int128Mul(poly[highI].x + poly[0].x, poly[0].y - poly[highI].y);
			for ( i in 1...highI+1 )
				a += Int128.Int128Mul(poly[i - 1].x + poly[i].x, poly[i].y - poly[i - 1].y);
			return a.ToDouble() / 2;
		}
		else
		*/
		{
			var area:Float = (this[highI].x + this[0].x) * 1.0 * (this[0].y * 1.0 - this[highI].y);
			for ( i in 1...highI+1 )
				area += (this[i - 1].x + this[i].x) * 1.0 * (this[i].y - this[i -1].y);
			return area * 0.5;
		}
	}

	public inline function clean(?distance) {
		return Clipper.cleanPolygon(this, distance);
	}

	public inline function simplify(?fillType) {
		return Clipper.simplifyPolygon(this, fillType);
	}

	public inline function getOrientation() : Bool {
		return getArea() >= 0;
	}

	public inline function removeAt(i:Int) {
		this.splice(i, 1);
	}

	@:arrayAccess function arrayGet(i:Int) : Point {
		return this[i];
	}

	@:arrayAccess function arraySet(i:Int, v : Point) : Point {
		return this[i] = v;
	}

	@:to public function toArray() : Array<Point> {
		return this;
	}

	@:from public static function fromArray( pts : Array<Point> ) {
		return new Polygon(pts);
	}

}

