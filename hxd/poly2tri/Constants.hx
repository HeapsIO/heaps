package hxd.poly2tri;

#if fastPoly2tri
typedef Unit = Int;
#else
typedef Unit = Float;
#end

class Constants {
	/*
	 * Inital triangle factor, seed triangle will extend 30% of
	 * PointSet width to both left and right.
	 */
	static public var kAlpha:Float   = 0.3;
	#if fastPoly2tri
	static public var EPSILON = 0;
	#else
	static public var EPSILON:Float  = 1e-24;
	#end
	static public var PI_2:Float     = Math.PI / 2;
	static public var PI_3div4:Float = 3 * Math.PI / 4;
}
