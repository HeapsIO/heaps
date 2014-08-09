package hxd.poly2tri;

class Triangle
{
	public var points:Array<Point>;

	// Neighbor list
	public var neighbors:Array<Triangle>;

	// Has this triangle been marked as an interior triangle?
	public var id:Int = -1;

	// Flags to determine if an edge is a Constrained edge
	public var constrained_edge:Array<Bool>;

	// Flags to determine if an edge is a Delauney edge
	public var delaunay_edge:Array<Bool>;



	public function new(p1:Point, p2:Point, p3:Point, fixOrientation = false, checkOrientation = true)
	{
		if (fixOrientation)
		{
			if (Orientation.orient2d(p1,p2,p3) == Orientation.CW)
			{
				var pt = p3;
				p3 = p2;
				p2 = pt;
			}
		}

		if (checkOrientation && Orientation.orient2d(p3,p2,p1) != Orientation.CW)
			throw "Triangle::Triangle must defined with Orientation.CW";

		points = [p1,p2,p3];



		neighbors = [null, null, null];
		constrained_edge = [false, false, false];
		delaunay_edge = [false, false, false];

	}

	/**
	 * Test if this Triangle contains the Point object given as parameter as its vertices.
	 *
	 * @return <code>True</code> if the Point objects are of the Triangle's vertices,
	 *         <code>false</code> otherwise.
	 */
	public function containsPoint(point:Point):Bool
	{
		return point.equals(points[0]) || point.equals(points[1]) || point.equals(points[2]);
	}

	public function containsEdgePoints(p1:Point, p2:Point):Bool
	{
		// In a triangle to check if contains and edge is enough to check if it contains the two vertices.
		return containsPoint(p1) && containsPoint(p2);
	}


	/**
	 * Update neighbor pointers.<br>
	 * This method takes either 3 parameters (<code>p1</code>, <code>p2</code> and
	 * <code>t</code>) or 1 parameter (<code>t</code>).
	 * @param   t   Triangle object.
	 * @param   p1  Point object.
	 * @param   p2  Point object.
	 */
	public function markNeighbor(t:Triangle, p1:Point, p2:Point)
	{
		if ((p1.equals(this.points[2]) && p2.equals(this.points[1])) || (p1.equals(this.points[1]) && p2.equals(this.points[2])))
		{
			this.neighbors[0] = t; return;
		}
		if ((p1.equals(this.points[0]) && p2.equals(this.points[2])) || (p1.equals(this.points[2]) && p2.equals(this.points[0])))
		{
			this.neighbors[1] = t; return;
		}
		if ((p1.equals(this.points[0]) && p2.equals(this.points[1])) || (p1.equals(this.points[1]) && p2.equals(this.points[0])))
		{
			this.neighbors[2] = t; return;
		}
		throw 'Invalid markNeighbor call (1)!';
	}


	public function markNeighborTriangle(that:Triangle)
	{
		// exhaustive search to update neighbor pointers
		if (that.containsEdgePoints( this.points[1], this.points[2]))
		{
			this.neighbors[0] = that;
			that.markNeighbor(this, this.points[1], this.points[2]);
			return;
		}

		if (that.containsEdgePoints(this.points[0], this.points[2])) {
			this.neighbors[1] = that;
			that.markNeighbor(this, this.points[0], this.points[2]);
			return;
		}

		if (that.containsEdgePoints(this.points[0], this.points[1])) {
			this.neighbors[2] = that;
			that.markNeighbor(this, this.points[0], this.points[1]);
			return;
		}
	}



	// Optimized?
	public function getPointIndexOffset(p:Point, offset:Int = 0):Int
	{
		var no:Int = offset;
		for (n in 0...3)
		{
			while (no < 0) no += 3;
			while (no > 2) no -= 3;
			if (p.equals(this.points[n])) return no;
			no++;
		}

		throw "Triangle::Point not in triangle";
		// for (var n:uint = 0; n < 3; n++, no++) {
		// 	while (no < 0) no += 3;
		// 	while (no > 2) no -= 3;
		// 	if (p.equals(this.points[n])) return no;
		// }
		// throw(new Error("Point not in triangle"));
	}




	/**
	 * Return the point clockwise to the given point.
	 * Return the point counter-clockwise to the given point.
	 *
	 * Return the neighbor clockwise to given point.
	 * Return the neighbor counter-clockwise to given point.
	 */

	inline static private var CW_OFFSET = 1;
	inline static private var CCW_OFFSET = -1;

	public inline function pointCW (p:Point):Point
	{
		return this.points[getPointIndexOffset(p, CCW_OFFSET)];
	}

	public inline function pointCCW(p:Point):Point
	{
		return this.points[getPointIndexOffset(p, CW_OFFSET)];
	}

	public inline function neighborCW(p:Point):Triangle
	{
	 	return this.neighbors[getPointIndexOffset(p, CW_OFFSET)];
	}

	public inline function neighborCCW(p:Point):Triangle
	{
		return this.neighbors[getPointIndexOffset(p, CCW_OFFSET)];
	}

	public inline function getConstrainedEdgeCW(p:Point):Bool              { return this.constrained_edge[getPointIndexOffset(p, CW_OFFSET)]; }
	public inline function setConstrainedEdgeCW(p:Point, ce:Bool):Bool  { return this.constrained_edge[getPointIndexOffset(p, CW_OFFSET)] = ce; }

	public inline function getConstrainedEdgeCCW(p:Point):Bool             { return this.constrained_edge[getPointIndexOffset(p, CCW_OFFSET)]; }
	public inline function setConstrainedEdgeCCW(p:Point, ce:Bool):Bool { return this.constrained_edge[getPointIndexOffset(p, CCW_OFFSET)] = ce; }

	public inline function getDelaunayEdgeCW(p:Point):Bool                 { return this.delaunay_edge[getPointIndexOffset(p, CW_OFFSET)]; }
	public inline function setDelaunayEdgeCW(p:Point, e:Bool):Bool      { return this.delaunay_edge[getPointIndexOffset(p, CW_OFFSET)] = e; }

	public inline function getDelaunayEdgeCCW(p:Point):Bool                { return this.delaunay_edge[getPointIndexOffset(p, CCW_OFFSET)]; }
	public inline function setDelaunayEdgeCCW(p:Point, e:Bool):Bool     { return this.delaunay_edge[getPointIndexOffset(p, CCW_OFFSET)] = e; }


	/**
	 * The neighbor across to given point.
	 */
	public inline function neighborAcross(p:Point):Triangle { return this.neighbors[getPointIndexOffset(p, 0)]; }

	public inline function oppositePoint(t:Triangle, p:Point):Point
	{
		return this.pointCW(t.pointCW(p));
	}

	/**
	 * Legalize triangle by rotating clockwise.<br>
	 * This method takes either 1 parameter (then the triangle is rotated around
	 * points(0)) or 2 parameters (then the triangle is rotated around the first
	 * parameter).
	 */
	public function legalize(opoint:Point, npoint:Point = null)
	{
		if (npoint == null)
		{
			this.legalize(this.points[0], opoint);
			return;
		}

		if (opoint.equals(this.points[0])) {
			this.points[1] = this.points[0];
			this.points[0] = this.points[2];
			this.points[2] = npoint;
		} else if (opoint.equals(this.points[1])) {
			this.points[2] = this.points[1];
			this.points[1] = this.points[0];
			this.points[0] = npoint;
		} else if (opoint.equals(this.points[2])) {
			this.points[0] = this.points[2];
			this.points[2] = this.points[1];
			this.points[1] = npoint;
		} else {
			throw 'Invalid js.poly2tri.Triangle.Legalize call!';
		}
	}


	/**
	 * Alias for getPointIndexOffset
	 *
	 * @param	p
	 */
	public inline function index(p:Point):Int
	{
		return this.getPointIndexOffset(p, 0);
	}


	public function edgeIndex(p1:Point, p2:Point):Int
	{
		if (p1.equals(this.points[0]))
		{
			if (p2.equals(this.points[1])) return 2;
			if (p2.equals(this.points[2])) return 1;
		}
		else if (p1.equals(this.points[1]))
		{
			if (p2.equals(this.points[2])) return 0;
			if (p2.equals(this.points[0])) return 2;
		}
		else if (p1.equals(this.points[2]))
		{
			if (p2.equals(this.points[0])) return 1;
			if (p2.equals(this.points[1])) return 0;
		}
		return -1;
	}


	public inline function markConstrainedEdgeByEdge(edge:Edge)
	{
		this.markConstrainedEdgeByPoints(edge.p, edge.q);
	}

	public function markConstrainedEdgeByPoints(p:Point, q:Point)
	{
		if ((q.equals(this.points[0]) && p.equals(this.points[1])) || (q.equals(this.points[1]) && p.equals(this.points[0]))) {
			this.constrained_edge[2] = true;
			return;
		}

		if ((q.equals(this.points[0]) && p.equals(this.points[2])) || (q.equals(this.points[2]) && p.equals(this.points[0]))) {
			this.constrained_edge[1] = true;
			return;
		}

		if ((q.equals(this.points[1]) && p.equals(this.points[2])) || (q.equals(this.points[2]) && p.equals(this.points[1]))) {
			this.constrained_edge[0] = true;
			return;
		}
	}



	/**
	 * Checks if a side from this triangle is an edge side.
	 * If sides are not marked they will be marked.
	 *
	 * @param	ep
	 * @param	eq
	 * @return
	 */
	public function isEdgeSide(ep:Point, eq:Point):Bool
	{
		var index:Int = this.edgeIndex(ep, eq);
		if (index == -1) return false;

		/**
		 * Mark an edge of this triangle as constrained.<br>
		 * This method takes either 1 parameter (an edge index or an Edge instance) or
		 * 2 parameters (two Point instances defining the edge of the triangle).
		 */
		this.constrained_edge[index] = true;

		var that:Triangle = this.neighbors[index];
		if (that != null) that.markConstrainedEdgeByPoints(ep, eq);
		return true;
	}


	/**
	 * Rotates a triangle pair one vertex CW
	 *<pre>
	 *       n2                    n2
	 *  P +-----+             P +-----+
	 *    | t  /|               |\  t |
	 *    |   / |               | \   |
	 *  n1|  /  |n3           n1|  \  |n3
	 *    | /   |    after CW   |   \ |
	 *    |/ oT |               | oT \|
	 *    +-----+ oP            +-----+
	 *       n4                    n4
	 * </pre>
	 */
	static public function rotateTrianglePair(t:Triangle, p:Point, ot:Triangle, op:Point)
	{
		var n1:Triangle =  t.neighborCCW( p);
		var n2:Triangle =  t.neighborCW ( p);
		var n3:Triangle = ot.neighborCCW(op);
		var n4:Triangle = ot.neighborCW (op);

		var ce1:Bool =  t.getConstrainedEdgeCCW( p);
		var ce2:Bool =  t.getConstrainedEdgeCW ( p);
		var ce3:Bool = ot.getConstrainedEdgeCCW(op);
		var ce4:Bool = ot.getConstrainedEdgeCW (op);

		var de1:Bool =  t.getDelaunayEdgeCCW( p);
		var de2:Bool =  t.getDelaunayEdgeCW ( p);
		var de3:Bool = ot.getDelaunayEdgeCCW(op);
		var de4:Bool = ot.getDelaunayEdgeCW (op);

		t.legalize( p, op);
		ot.legalize(op,  p);

		// Remap delaunay_edge
		ot.setDelaunayEdgeCCW( p, de1);
		 t.setDelaunayEdgeCW ( p, de2);
		 t.setDelaunayEdgeCCW(op, de3);
		ot.setDelaunayEdgeCW (op, de4);

		// Remap constrained_edge
		ot.setConstrainedEdgeCCW( p, ce1);
		 t.setConstrainedEdgeCW ( p, ce2);
		 t.setConstrainedEdgeCCW(op, ce3);
		ot.setConstrainedEdgeCW (op, ce4);

		// Remap neighbors
		// XXX: might optimize the markNeighbor by keeping track of
		//      what side should be assigned to what neighbor after the
		//      rotation. Now mark neighbor does lots of testing to find
		//      the right side.
		 t.clearNeigbors();
		ot.clearNeigbors();
		if (n1 != null) ot.markNeighborTriangle(n1);
		if (n2 != null)  t.markNeighborTriangle(n2);
		if (n3 != null)  t.markNeighborTriangle(n3);
		if (n4 != null) ot.markNeighborTriangle(n4);
		t.markNeighborTriangle(ot);
	}

	public function clearNeigbors()
	{
		this.neighbors[0] = null;
		this.neighbors[1] = null;
		this.neighbors[2] = null;
	}

	public function clearDelunayEdges()
	{
		this.delaunay_edge[0] = false;
		this.delaunay_edge[1] = false;
		this.delaunay_edge[2] = false;
	}


	public function toString():String
	{
		return "Triangle(" + this.points[0] + ", " + this.points[1] + ", " + this.points[2] + ")";
	}
}