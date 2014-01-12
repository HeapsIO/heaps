package hxd.poly2tri;

class Orientation
{
	inline public static var CW = 1;
	inline public static var CCW = -1;
	inline public static var COLLINEAR = 0;

	public static function orient2d(pa:Point, pb:Point, pc:Point):Int
	{
		var detleft  = (pa.x - pc.x) * (pb.y - pc.y);
		var detright = (pa.y - pc.y) * (pb.x - pc.x);
		var val = detleft - detright;

		#if fastPoly2tri
		if( val == 0 ) return COLLINEAR;
		#else
		if ((val > -Constants.EPSILON) && (val < Constants.EPSILON)) return Orientation.COLLINEAR;
		#end
		if (val > 0) return Orientation.CCW;
		return Orientation.CW;
	}
}