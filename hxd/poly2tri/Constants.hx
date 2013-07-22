package hxd.poly2tri;

class Constants {
	/*
	 * Inital triangle factor, seed triangle will extend 30% of
	 * PointSet width to both left and right.
	 */
	static public var kAlpha:Float   = 0.3;
	static public var EPSILON:Float  = 1e-12;
	static public var PI_2:Float     = Math.PI / 2;
	static public var PI_3div4:Float = 3 * Math.PI / 4;
}
