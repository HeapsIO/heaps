package h3d.col;
import hxd.Math;

class Bounds implements Collider {

	public var xMin : Float;
	public var xMax : Float;
	public var yMin : Float;
	public var yMax : Float;
	public var zMin : Float;
	public var zMax : Float;

	public var xSize(get,set) : Float;
	public var ySize(get,set) : Float;
	public var zSize(get,set) : Float;

	public inline function new() {
		empty();
	}

	public inline function inFrustum( f : Frustum, ?m: h3d.Matrix ) {
		if( m != null )
			throw "Not implemented";
		return f.hasBounds(this);
	}

	public inline function inSphere( s : Sphere ) {
		var c = new Point(s.x,s.y,s.z);
		var p = new Point(Math.max(xMin, Math.min(s.x, xMax)), Math.max(yMin, Math.min(s.y, yMax)), Math.max(zMin, Math.min(s.z, zMax)));
		return c.distanceSq(p) < s.r*s.r;
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
		return dd + rr - p.d*2;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var minTx = (xMin - r.px) / r.lx;
		var minTy = (yMin - r.py) / r.ly;
		var minTz = (zMin - r.pz) / r.lz;
		var maxTx = (xMax - r.px) / r.lx;
		var maxTy = (yMax - r.py) / r.ly;
		var maxTz = (zMax - r.pz) / r.lz;

		var realMinTx = Math.min(minTx, maxTx);
		var realMinTy = Math.min(minTy, maxTy);
		var realMinTz = Math.min(minTz, maxTz);
		var realMaxTx = Math.max(minTx, maxTx);
		var realMaxTy = Math.max(minTy, maxTy);
		var realMaxTz = Math.max(minTz, maxTz);

		var minmax = Math.min( Math.min(realMaxTx, realMaxTy), realMaxTz);
		var maxmin = Math.max( Math.max(realMinTx, realMinTy), realMinTz);

		if(minmax < maxmin)	return -1;

		return maxmin;
	}

	/**
	 * Check if the camera model-view-projection Matrix intersects with the Bounds. Returns -1 if outside, 0 if intersects and 1 if fully inside.
	 * @param	mvp : the model-view-projection matrix to test against
	 * @param	checkZ : tells if we will check against the near/far plane
	 */
	public function inFrustumDetails( mvp : Matrix, checkZ = true ) {
		var ret = 1;

		// left
		var p = new Plane(mvp._14 + mvp._11, mvp._24 + mvp._21 , mvp._34 + mvp._31, mvp._44 + mvp._41);
		var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
		if( m + p.d < 0 )
			return -1;
		var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
		if( n + p.d < 0 ) ret = 0;
		// right
		var p = new Plane(mvp._14 - mvp._11, mvp._24 - mvp._21 , mvp._34 - mvp._31, mvp._44 - mvp._41);
		var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
		if( m + p.d < 0 )
			return -1;
		var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
		if( n + p.d < 0 ) ret = 0;
		// bottom
		var p = new Plane(mvp._14 + mvp._12, mvp._24 + mvp._22 , mvp._34 + mvp._32, mvp._44 + mvp._42);
		var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
		if( m + p.d < 0 )
			return -1;
		var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
		if( n + p.d < 0 ) ret = 0;

		// top
		var p = new Plane(mvp._14 - mvp._12, mvp._24 - mvp._22 , mvp._34 - mvp._32, mvp._44 - mvp._42);
		var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
		if( m + p.d < 0 )
			return -1;
		var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
		if( n + p.d < 0 ) ret = 0;

		if( checkZ ) {
			// nea
			var p = new Plane(mvp._13, mvp._23, mvp._33, mvp._43);
			var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
			if( m + p.d < 0 )
				return -1;
			var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
			if( n + p.d < 0 ) ret = 0;

			var p = new Plane(mvp._14 - mvp._13, mvp._24 - mvp._23, mvp._34 - mvp._33, mvp._44 - mvp._43);
			var m = p.nx * (p.nx > 0 ? xMax : xMin) + p.ny * (p.ny > 0 ? yMax : yMin) + p.nz * (p.nz > 0 ? zMax : zMin);
			if( m + p.d < 0 )
				return -1;
			var n = p.nx * (p.nx > 0 ? xMin : xMax) + p.ny * (p.ny > 0 ? yMin : yMax) + p.nz * (p.nz > 0 ? zMin : zMax);
			if( n + p.d < 0 ) ret = 0;
		}

		return ret;
	}

	public function transform3x3( m : Matrix ) {
		var xMin = xMin, yMin = yMin, zMin = zMin, xMax = xMax, yMax = yMax, zMax = zMax;
		empty();
		var v = new h3d.col.Point();
		v.set(xMin, yMin, zMin);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMin, yMin, zMax);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMin, yMax, zMin);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMin, yMax, zMax);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMax, yMin, zMin);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMax, yMin, zMax);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMax, yMax, zMin);
		v.transform3x3(m);
		addPoint(v);
		v.set(xMax, yMax, zMax);
		v.transform3x3(m);
		addPoint(v);
	}

	public function transform( m : Matrix ) {
		var xMin = xMin, yMin = yMin, zMin = zMin, xMax = xMax, yMax = yMax, zMax = zMax;
		empty();
		// if empty, keep empty
		if( xMax < xMin && yMax < yMin && zMax < zMin )
			return;
		var v = new h3d.col.Point();
		v.set(xMin, yMin, zMin);
		v.transform(m);
		addPoint(v);
		v.set(xMin, yMin, zMax);
		v.transform(m);
		addPoint(v);
		v.set(xMin, yMax, zMin);
		v.transform(m);
		addPoint(v);
		v.set(xMin, yMax, zMax);
		v.transform(m);
		addPoint(v);
		v.set(xMax, yMin, zMin);
		v.transform(m);
		addPoint(v);
		v.set(xMax, yMin, zMax);
		v.transform(m);
		addPoint(v);
		v.set(xMax, yMax, zMin);
		v.transform(m);
		addPoint(v);
		v.set(xMax, yMax, zMax);
		v.transform(m);
		addPoint(v);
	}

	public inline function collide( b : Bounds ) {
		return !(xMin > b.xMax || yMin > b.yMax || zMin > b.zMax || xMax < b.xMin || yMax < b.yMin || zMax < b.zMin);
	}

	public inline function contains( p : Point ) {
		return p.x >= xMin && p.x < xMax && p.y >= yMin && p.y < yMax && p.z >= zMin && p.z < zMax;
	}

	public inline function containsBounds( b : Bounds ) {
		return xMin <= b.xMin && yMin <= b.yMin && zMin <= b.zMin && xMax >= b.xMax && yMax >= b.yMax && zMax >= b.zMax;
	}

	public inline function containsSphere( s : Sphere ) {
		return xMin <= s.x - s.r  && yMin <= s.y - s.r && zMin <= s.z - s.r && xMax >= s.x + s.r && yMax >= s.y + s.r && zMax >= s.z + s.r;
	}

	public inline function add( b : Bounds ) {
		if( b.xMin < xMin ) xMin = b.xMin;
		if( b.xMax > xMax ) xMax = b.xMax;
		if( b.yMin < yMin ) yMin = b.yMin;
		if( b.yMax > yMax ) yMax = b.yMax;
		if( b.zMin < zMin ) zMin = b.zMin;
		if( b.zMax > zMax ) zMax = b.zMax;
	}

	public inline function addPoint( p : Point ) {
		if( p.x < xMin ) xMin = p.x;
		if( p.x > xMax ) xMax = p.x;
		if( p.y < yMin ) yMin = p.y;
		if( p.y > yMax ) yMax = p.y;
		if( p.z < zMin ) zMin = p.z;
		if( p.z > zMax ) zMax = p.z;
	}

	public inline function addPos( x : Float, y : Float, z : Float ) {
		if( x < xMin ) xMin = x;
		if( x > xMax ) xMax = x;
		if( y < yMin ) yMin = y;
		if( y > yMax ) yMax = y;
		if( z < zMin ) zMin = z;
		if( z > zMax ) zMax = z;
	}

	public inline function addSphere( s : Sphere ) {
		addSpherePos(s.x, s.y, s.z, s.r);
	}

	public inline function addSpherePos( x : Float, y : Float, z : Float, r : Float ) {
		if( x - r < xMin ) xMin = x - r;
		if( x + r > xMax ) xMax = x + r;
		if( y - r < yMin ) yMin = y - r;
		if( y + r > yMax ) yMax = y + r;
		if( z - r < zMin ) zMin = z - r;
		if( z + r > zMax ) zMax = z + r;
	}

	public function intersection( a : Bounds, b : Bounds ) {
		var xMin = Math.max(a.xMin, b.xMin);
		var yMin = Math.max(a.yMin, b.yMin);
		var zMin = Math.max(a.zMin, b.zMin);
		var xMax = Math.min(a.xMax, b.xMax);
		var yMax = Math.min(a.yMax, b.yMax);
		var zMax = Math.min(a.zMax, b.zMax);
		this.xMin = xMin;
		this.xMax = xMax;
		this.yMin = yMin;
		this.yMax = yMax;
		this.zMin = zMin;
		this.zMax = zMax;
	}

	public inline function offset( dx : Float, dy : Float, dz : Float ) {
		xMin += dx;
		xMax += dx;
		yMin += dy;
		yMax += dy;
		zMin += dz;
		zMax += dz;
	}

	public inline function setMin( p : Point ) {
		xMin = p.x;
		yMin = p.y;
		zMin = p.z;
	}

	public inline function setMax( p : Point ) {
		xMax = p.x;
		yMax = p.y;
		zMax = p.z;
	}

	public function load( b : Bounds ) {
		xMin = b.xMin;
		xMax = b.xMax;
		yMin = b.yMin;
		yMax = b.yMax;
		zMin = b.zMin;
		zMax = b.zMax;
	}

	public inline function scalePivot( v : Float ) {
		xMin *= v;
		yMin *= v;
		zMin *= v;
		xMax *= v;
		yMax *= v;
		zMax *= v;
	}


	public function scaleCenter( v : Float ) {
		var dx = (xMax - xMin) * 0.5 * v;
		var dy = (yMax - yMin) * 0.5 * v;
		var dz = (zMax - zMin) * 0.5 * v;
		var mx = (xMax + xMin) * 0.5;
		var my = (yMax + yMin) * 0.5;
		var mz = (zMax + zMin) * 0.5;
		xMin = mx - dx;
		yMin = my - dy;
		zMin = mz - dz;
		xMax = mx + dx;
		yMax = my + dy;
		zMax = mz + dz;
	}

	public inline function getMin() {
		return new Point(xMin, yMin, zMin);
	}

	public inline function getCenter() {
		return new Point((xMin + xMax) * 0.5, (yMin + yMax) * 0.5, (zMin + zMax) * 0.5);
	}

	public inline function getSize() {
		return new Point(xMax - xMin, yMax - yMin, zMax - zMin);
	}

	public inline function getMax() {
		return new Point(xMax, yMax, zMax);
	}

	public inline function getVolume() {
		return xSize * ySize * zSize;
	}

	inline function get_xSize() return xMax - xMin;
	inline function get_ySize() return yMax - yMin;
	inline function get_zSize() return zMax - zMin;
	inline function set_xSize(v) { xMax = xMin + v; return v; }
	inline function set_ySize(v) { yMax = yMin + v; return v; }
	inline function set_zSize(v) { zMax = zMin + v; return v; }

	public inline function isEmpty() {
		return xMax < xMin || yMax < yMin || zMax < zMin;
	}

	public inline function empty() {
		xMin = 1e20;
		xMax = -1e20;
		yMin = 1e20;
		yMax = -1e20;
		zMin = 1e20;
		zMax = -1e20;
	}

	public inline function all() {
		xMin = -1e20;
		xMax = 1e20;
		yMin = -1e20;
		yMax = 1e20;
		zMin = -1e20;
		zMax = 1e20;
	}

	public inline function clone() {
		var b = new Bounds();
		b.xMin = xMin;
		b.xMax = xMax;
		b.yMin = yMin;
		b.yMax = yMax;
		b.zMin = zMin;
		b.zMax = zMax;
		return b;
	}

	public function toString() {
		return "Bounds{" + getMin() + "," + getSize() + "}";
	}

	public inline function toSphere() {
		var dx = xMax - xMin;
		var dy = yMax - yMin;
		var dz = zMax - zMin;
		return new Sphere((xMin + xMax) * 0.5, (yMin + yMax) * 0.5, (zMin + zMax) * 0.5, Math.sqrt(dx * dx + dy * dy + dz * dz) * 0.5);
	}

	public static inline function fromPoints( min : Point, max : Point ) {
		var b = new Bounds();
		b.setMin(min);
		b.setMax(max);
		return b;
	}

	public static inline function fromValues( x : Float, y : Float, z : Float, dx : Float, dy : Float, dz : Float ) {
		var b = new Bounds();
		b.xMin = x;
		b.yMin = y;
		b.zMin = z;
		b.xMax = x + dx;
		b.yMax = y + dy;
		b.zMax = z + dz;
		return b;
	}

	#if (hxbit && !macro)
	function customSerialize( ctx : hxbit.Serializer ) {
		ctx.addFloat(xMin);
		ctx.addFloat(xMax);
		ctx.addFloat(yMin);
		ctx.addFloat(yMax);
		ctx.addFloat(zMin);
		ctx.addFloat(zMax);
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		xMin = ctx.getFloat();
		xMax = ctx.getFloat();
		yMin = ctx.getFloat();
		yMax = ctx.getFloat();
		zMin = ctx.getFloat();
		zMax = ctx.getFloat();
	}
	#end

}