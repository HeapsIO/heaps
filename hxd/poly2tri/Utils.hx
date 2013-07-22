package hxd.poly2tri;

class Utils
{
	/**
	 * <b>Requirement</b>:<br>
	 * 1. a, b and c form a triangle.<br>
	 * 2. a and d is know to be on opposite side of bc<br>
	 * <pre>
	 *                a
	 *                +
	 *               / \
	 *              /   \
	 *            b/     \c
	 *            +-------+
	 *           /    d    \
	 *          /           \
	 * </pre>
	 * <b>Fact</b>: d has to be in area B to have a chance to be inside the circle formed by
	 *  a,b and c<br>
	 *  d is outside B if orient2d(a,b,d) or orient2d(c,a,d) is CW<br>
	 *  This preknowledge gives us a way to optimize the incircle test
	 * @param pa - triangle point, opposite d
	 * @param pb - triangle point
	 * @param pc - triangle point
	 * @param pd - point opposite a
	 * @return true if d is inside circle, false if on circle edge
	 */
	static public function insideIncircle(pa:Point, pb:Point, pc:Point, pd:Point):Bool
	{
		var adx:Float    = pa.x - pd.x;
		var ady:Float    = pa.y - pd.y;
		var bdx:Float    = pb.x - pd.x;
		var bdy:Float    = pb.y - pd.y;

		var adxbdy:Float = adx * bdy;
		var bdxady:Float = bdx * ady;
		var oabd:Float   = adxbdy - bdxady;

		if (oabd <= 0) return false;

		var cdx:Float    = pc.x - pd.x;
		var cdy:Float    = pc.y - pd.y;

		var cdxady:Float = cdx * ady;
		var adxcdy:Float = adx * cdy;
		var ocad:Float   = cdxady - adxcdy;

		if (ocad <= 0) return false;

		var bdxcdy:Float = bdx * cdy;
		var cdxbdy:Float = cdx * bdy;

		var alift:Float  = adx * adx + ady * ady;
		var blift:Float  = bdx * bdx + bdy * bdy;
		var clift:Float  = cdx * cdx + cdy * cdy;

		var det:Float = alift * (bdxcdy - cdxbdy) + blift * ocad + clift * oabd;
		return det > 0;
	}

	static public function inScanArea(pa:Point, pb:Point, pc:Point, pd:Point):Bool
	{
		var pdx:Float = pd.x;
		var pdy:Float = pd.y;
		var adx:Float = pa.x - pdx;
		var ady:Float = pa.y - pdy;
		var bdx:Float = pb.x - pdx;
		var bdy:Float = pb.y - pdy;

		var adxbdy:Float = adx * bdy;
		var bdxady:Float = bdx * ady;
		var oabd:Float = adxbdy - bdxady;

		if (oabd <= Constants.EPSILON) return false;

		var cdx:Float = pc.x - pdx;
		var cdy:Float = pc.y - pdy;

		var cdxady:Float = cdx * ady;
		var adxcdy:Float = adx * cdy;
		var ocad:Float = cdxady - adxcdy;

		if (ocad <= Constants.EPSILON) return false;

		return true;
	}


}