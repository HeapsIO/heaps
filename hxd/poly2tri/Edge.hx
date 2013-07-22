package hxd.poly2tri;

class Edge
{
	public var p:Point;
	public var q:Point;

	public function new(p1:Point, p2:Point)
	{
		if (p1==null || p2==null) throw "Edge::new p1 or p2 is null";

		var swap = false;

		if (p1.y > p2.y)
		{
			swap = true;
		}
		else if (p1.y == p2.y)
		{
			if (p1.x == p2.x) throw "Edge::repeat points " + p1;

			swap = (p1.x > p2.x);
		}


		if (swap)
		{
			q = p1;
			p = p2;
		}
		else
		{
			p = p1;
			q = p2;
		}

		q.edge_list.push( this );
	}



	public function toString()
	{
		return "Edge(" + this.p + ", " + this.q + ")";
	}

}