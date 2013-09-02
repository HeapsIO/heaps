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
		var adx    = pa.x - pd.x;
		var ady    = pa.y - pd.y;
		var bdx    = pb.x - pd.x;
		var bdy    = pb.y - pd.y;

		var adxbdy = adx * bdy;
		var bdxady = bdx * ady;
		var oabd   = adxbdy - bdxady;

		if (oabd <= 0) return false;

		var cdx = pc.x - pd.x;
		var cdy = pc.y - pd.y;

		var cdxady = cdx * ady;
		var adxcdy = adx * cdy;
		var ocad = cdxady - adxcdy;

		if (ocad <= 0) return false;

		var bdxcdy = bdx * cdy;
		var cdxbdy = cdx * bdy;

		var alift = adx * adx + ady * ady;
		var blift = bdx * bdx + bdy * bdy;
		var clift = cdx * cdx + cdy * cdy;

		var det = alift * (bdxcdy - cdxbdy) + blift * ocad + clift * oabd;
		return det > 0;
	}

	static public function inScanArea(pa:Point, pb:Point, pc:Point, pd:Point):Bool
	{
		var pdx = pd.x;
		var pdy = pd.y;
		var adx = pa.x - pdx;
		var ady = pa.y - pdy;
		var bdx = pb.x - pdx;
		var bdy = pb.y - pdy;

		var adxbdy= adx * bdy;
		var bdxady = bdx * ady;
		var oabd = adxbdy - bdxady;

		if (oabd <= Constants.EPSILON) return false;

		var cdx = pc.x - pdx;
		var cdy = pc.y - pdy;

		var cdxady = cdx * ady;
		var adxcdy = adx * cdy;
		var ocad = cdxady - adxcdy;

		if (ocad <= Constants.EPSILON) return false;

		return true;
	}


}