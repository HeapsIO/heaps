package hxd.poly2tri;

class Node
{


	public var point:Point;
	public var triangle:Triangle;
	public var prev:Node;
	public var next:Node;
	public var value:Float;

	public function new(point:Point = null, triangle:Triangle = null)
	{

		this.point = point;
		this.triangle = triangle;
		this.value = this.point.x;
	}

	/**
	 *
	 * @param node - middle node
	 * @return the angle between 3 front nodes
	 */
	public function getHoleAngle():Float
	{
		/* Complex plane
		 * ab = cosA +i*sinA
		 * ab = (ax + ay*i)(bx + by*i) = (ax*bx + ay*by) + i(ax*by-ay*bx)
		 * atan2(y,x) computes the principal value of the argument function
		 * applied to the complex number x+iy
		 * Where x = ax*bx + ay*by
		 *       y = ax*by - ay*bx
		 */
		var ax = this.next.point.x - this.point.x;
		var ay = this.next.point.y - this.point.y;
		var bx = this.prev.point.x - this.point.x;
		var by = this.prev.point.y - this.point.y;
		return Math.atan2(
			ax * by - ay * bx,
			ax * bx + ay * by
		);
	}

	public function getBasinAngle():Float
	{
		return Math.atan2(
			this.point.y - this.next.next.point.y, // ay
			this.point.x - this.next.next.point.x  // ax
		);
	}




}