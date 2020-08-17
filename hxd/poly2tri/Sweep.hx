package hxd.poly2tri;

class Sweep
{
	var context:SweepContext;

	public function new(context)
	{
		this.context = context;
	}

	public function triangulate()
	{
		context.initTriangulation();
		context.createAdvancingFront();
		sweepPoints();// Sweep points; build mesh
		finalizationPolygon();            // Clean up
	}

	public function sweepPoints()
	{
		for (i in 1...context.points.length)
		{
			// trace("i"+i);
			var point = this.context.points[i];
			var node  = this.pointEvent(point);
			for (j in 0...point.edge_list.length)
			{
				// trace("j"+j);
				this.edgeEventByEdge(point.edge_list[j], node);
			}
		}
	}

	public function finalizationPolygon()
	{
		// Get an Internal triangle to start with
		var t:Triangle = this.context.front.head.next.triangle;
		var p:Point    = this.context.front.head.next.point;
		while (!t.getConstrainedEdgeCW(p)) t = t.neighborCCW(p);

		// Collect interior triangles constrained by edges
		this.context.meshClean(t);
	}

	/**
	 * Find closes node to the left of the new point and
	 * create a new triangle. If needed new holes and basins
	 * will be filled to.
	 */
	public function pointEvent(point:Point) :Node
	{
		// trace(point);
		var node = this.context.locateNode(point);
		var new_node = null;
		try	new_node = newFrontTriangle(point, node)
		catch(e: Dynamic) { }

		if(new_node == null) {
			#if release
			new_node = node;
			#else
			throw 'Failed to add point (${point.x}, ${point.y})';
			#end
		}

		// Only need to check +epsilon since point never have smaller
		// x value than node due to how we fetch nodes from the front
		if (point.x <= (node.point.x + Constants.EPSILON)) fill(node);

		fillAdvancingFront(new_node);
		return new_node;
	}


	public function edgeEventByEdge(edge:Edge, node:Node)
	{
		this.context.edge_event.constrained_edge = edge;
		this.context.edge_event.right = (edge.p.x > edge.q.x);

		if (node.triangle.isEdgeSide(edge.p, edge.q)) return;

		// For now we will do all needed filling
		// TODO: integrate with flip process might give some better performance
		//       but for now this avoid the issue with cases that needs both flips and fills
		this.fillEdgeEvent(edge, node);

		this.edgeEventByPoints(edge.p, edge.q, node.triangle, edge.q);
	}

	public function edgeEventByPoints(ep:Point, eq:Point, triangle:Triangle, point:Point)
	{
		if (triangle.isEdgeSide(ep, eq)) return;

		var p1:Point = triangle.pointCCW(point);
		var o1:Int   = Orientation.orient2d(eq, p1, ep);
		if (o1 == Orientation.COLLINEAR) throw 'Sweep.edgeEvent: Collinear not supported (${p1.x}, ${p1.y})';

		var p2:Point = triangle.pointCW(point);
		var o2:Int   = Orientation.orient2d(eq, p2, ep);
		if (o2 == Orientation.COLLINEAR) throw'Sweep.edgeEvent: Collinear not supported (${p2.x}, ${p2.y})';

		if (o1 == o2)
		{
			// Need to decide if we are rotating CW or CCW to get to a triangle
			// that will cross edge
			triangle = ((o1 == Orientation.CW)
				? triangle.neighborCCW(point)
				: triangle.neighborCW(point)
			);
			edgeEventByPoints(ep, eq, triangle, point);
		}
		else
		{
			// This triangle crosses constraint so lets flippin start!
			flipEdgeEvent(ep, eq, triangle, point);
		}
	}



	public function newFrontTriangle(point:Point, node:Node) :Node
	{
		var triangle = new Triangle(point, node.point, node.next.point);

		// trace(node.id);
		// trace(node.triangle);
		triangle.markNeighborTriangle(node.triangle);
		this.context.addToMap(triangle);

		var new_node = new Node(point);
		new_node.next  = node.next;
		new_node.prev  = node;
		node.next.prev = new_node;
		node.next      = new_node;

		if (!legalize(triangle)) this.context.mapTriangleToNodes(triangle);

		return new_node;

	}


	/**
	 * Adds a triangle to the advancing front to fill a hole.
	 * @param tcx
	 * @param node - middle node, that is the bottom of the hole
	 */
	public function fill(node:Node)
	{
		var triangle = new Triangle(node.prev.point, node.point, node.next.point);

		// TODO: should copy the constrained_edge value from neighbor triangles
		//       for now constrained_edge values are copied during the legalize
		triangle.markNeighborTriangle(node.prev.triangle);
		triangle.markNeighborTriangle(node.triangle);

		this.context.addToMap(triangle);

		// Update the advancing front
		node.prev.next = node.next;
		node.next.prev = node.prev;

		// If it was legalized the triangle has already been mapped
		if (!legalize(triangle))
		{
			this.context.mapTriangleToNodes(triangle);
		}

		this.context.removeNode(node);
	}

	/**
	 * Fills holes in the Advancing Front
	 */
	public function fillAdvancingFront(n:Node)
	{
		var node:Node;
		var angle:Float;

		// Fill right holes
		node = n.next;
		while (node.next != null)
		{
			angle = node.getHoleAngle();
			if ((angle > Constants.PI_2) || (angle < -Constants.PI_2)) break;
			this.fill(node);
			node = node.next;
		}

		// Fill left holes
		node = n.prev;
		while (node.prev != null)
		{
			angle = node.getHoleAngle();
			if ((angle > Constants.PI_2) || (angle < -Constants.PI_2)) break;
			this.fill(node);
			node = node.prev;
		}

		// Fill right basins
		if ((n.next != null) && (n.next.next != null))
		{
			angle = n.getBasinAngle();
			if (angle < Constants.PI_3div4) this.fillBasin(n);
		}
	}


	/**
	 * Returns true if triangle was legalized
	 */
	public function legalize(t:Triangle):Bool
	{
		for (i in 0...3)
		{
			if (t.delaunay_edge[i]) continue;

			var ot:Triangle = t.neighbors[i];
			if (ot != null)
			{
				var p:Point  = t.points[i];
				var op:Point = ot.oppositePoint(t, p);
				var oi:Int = ot.index(op);

				// If this is a Constrained Edge or a Delaunay Edge(only during recursive legalization)
				// then we should not try to legalize
				if (ot.constrained_edge[oi] || ot.delaunay_edge[oi])
				{
					t.constrained_edge[i] = ot.constrained_edge[oi];
					continue;
				}


				if (Utils.insideIncircle(p, t.pointCCW(p), t.pointCW(p), op))
				{
					// Lets mark this shared edge as Delaunay
					t.delaunay_edge[i]   = true;
					ot.delaunay_edge[oi] = true;

					// Lets rotate shared edge one vertex CW to legalize it
					Triangle.rotateTrianglePair(t, p, ot, op);

					// We now got one valid Delaunay Edge shared by two triangles
					// This gives us 4 new edges to check for Delaunay

					var not_legalized:Bool;

					// Make sure that triangle to node mapping is done only one time for a specific triangle
					not_legalized = !this.legalize(t);
					if (not_legalized) this.context.mapTriangleToNodes(t);

					not_legalized = !this.legalize(ot);
					if (not_legalized) this.context.mapTriangleToNodes(ot);

					// Reset the Delaunay edges, since they only are valid Delaunay edges
					// until we add a new triangle or point.
					// XXX: need to think about this. Can these edges be tried after we
					//      return to previous recursive level?
					t.delaunay_edge[i]   = false;
					ot.delaunay_edge[oi] = false;

					// If triangle have been legalized no need to check the other edges since
					// the recursive legalization will handles those so we can end here.
					return true;
				}

			}
		}

		return false;
	}

	/**
	 * Fills a basin that has formed on the Advancing Front to the right
	 * of given node.<br>
	 * First we decide a left,bottom and right node that forms the
	 * boundaries of the basin. Then we do a reqursive fill.
	 *
	 * @param tcx
	 * @param node - starting node, this or next node will be left node
	 */
	public function fillBasin(node:Node)
	{
		this.context.basin.left_node = ((Orientation.orient2d(node.point, node.next.point, node.next.next.point) == Orientation.CCW)
			? node.next.next
			: node.next
		);

		// Find the bottom and right node
		this.context.basin.bottom_node = this.context.basin.left_node;
		while ((this.context.basin.bottom_node.next != null) && (this.context.basin.bottom_node.point.y >= this.context.basin.bottom_node.next.point.y))
		{
			this.context.basin.bottom_node = this.context.basin.bottom_node.next;
		}

		// No valid basin
		if (this.context.basin.bottom_node == this.context.basin.left_node) return;

		this.context.basin.right_node = this.context.basin.bottom_node;
		while ((this.context.basin.right_node.next != null) && (this.context.basin.right_node.point.y < this.context.basin.right_node.next.point.y))
		{
			this.context.basin.right_node = this.context.basin.right_node.next;
		}

		// No valid basins
		if (this.context.basin.right_node == this.context.basin.bottom_node) return;

		this.context.basin.width        = (this.context.basin.right_node.point.x - this.context.basin.left_node.point.x);
		this.context.basin.left_highest = (this.context.basin.left_node.point.y > this.context.basin.right_node.point.y);

		this.fillBasinReq(this.context.basin.bottom_node);
	}

	/**
	 * Recursive algorithm to fill a Basin with triangles
	 *
	 * @param tcx
	 * @param node - bottom_node
	 */
	public function fillBasinReq(node:Node)
	{
		// if shallow stop filling
		if (this.isShallow(node)) return;

		this.fill(node);

		if (node.prev == this.context.basin.left_node && node.next == this.context.basin.right_node)
		{
			return;
		}
		else if (node.prev == this.context.basin.left_node)
		{
			if (Orientation.orient2d(node.point, node.next.point, node.next.next.point) == Orientation.CW) return;
			node = node.next;
		}
		else if (node.next == this.context.basin.right_node)
		{
			if (Orientation.orient2d(node.point, node.prev.point, node.prev.prev.point) == Orientation.CCW) return;
			node = node.prev;
		}
		else
		{
			// Continue with the neighbor node with lowest Y value
			node = ((node.prev.point.y < node.next.point.y)
				? node.prev
				: node.next
			);
		}

		this.fillBasinReq(node);
	}


	public inline function isShallow(node:Node):Bool
	{
		var height = ( (this.context.basin.left_highest)
			? this.context.basin.left_node.point.y - node.point.y
			: this.context.basin.right_node.point.y - node.point.y
		);

		// if shallow stop filling
		return (this.context.basin.width > height);
	}

	public function fillEdgeEvent(edge:Edge, node:Node)
	{
		if (this.context.edge_event.right)
		{
			this.fillRightAboveEdgeEvent(edge, node);
		}
		else
		{
			this.fillLeftAboveEdgeEvent(edge, node);
		}
	}

	public function fillRightAboveEdgeEvent(edge:Edge, node:Node)
	{
		while (node.next.point.x < edge.p.x)
		{
			// Check if next node is below the edge
			if (Orientation.orient2d(edge.q, node.next.point, edge.p) == Orientation.CCW)
			{
				this.fillRightBelowEdgeEvent(edge, node);
			}
			else
			{
				node = node.next;
			}
		}
	}

	public function fillRightBelowEdgeEvent(edge:Edge, node:Node)
	{
		if (node.point.x >= edge.p.x) return;
		if (Orientation.orient2d(node.point, node.next.point, node.next.next.point) == Orientation.CCW)
		{
			// Concave
			this.fillRightConcaveEdgeEvent(edge, node);
		}
		else
		{
			this.fillRightConvexEdgeEvent(edge, node); // Convex
			this.fillRightBelowEdgeEvent(edge, node); // Retry this one
		}
	}

	public function fillRightConcaveEdgeEvent(edge:Edge, node:Node)
	{
		this.fill(node.next);
		if (node.next.point != edge.p)
		{
			// Next above or below edge?
			if (Orientation.orient2d(edge.q, node.next.point, edge.p) == Orientation.CCW)
			{
				// Below
				if (Orientation.orient2d(node.point, node.next.point, node.next.next.point) == Orientation.CCW)
				{
					// Next is concave
					this.fillRightConcaveEdgeEvent(edge, node);
				}
				else
				{
					// Next is convex
				}
			}
		}
	}

	public function fillRightConvexEdgeEvent(edge:Edge, node:Node)
	{
		// Next concave or convex?
		if (Orientation.orient2d(node.next.point, node.next.next.point, node.next.next.next.point) == Orientation.CCW)
		{
			// Concave
			this.fillRightConcaveEdgeEvent(edge, node.next);
		}
		else
		{
			// Convex
			// Next above or below edge?
			if (Orientation.orient2d(edge.q, node.next.next.point, edge.p) == Orientation.CCW)
			{
				// Below
				this.fillRightConvexEdgeEvent(edge, node.next);
			}
			else
			{
				// Above
			}
		}
	}

	public function fillLeftAboveEdgeEvent(edge:Edge, node:Node)
	{
		while (node.prev.point.x > edge.p.x)
		{
			// Check if next node is below the edge
			if (Orientation.orient2d(edge.q, node.prev.point, edge.p) == Orientation.CW)
			{
				this.fillLeftBelowEdgeEvent(edge, node);
			}
			else
			{
				node = node.prev;
			}
		}
	}

	public function fillLeftBelowEdgeEvent(edge:Edge, node:Node)
	{
		if (node.point.x > edge.p.x)
		{
			if (Orientation.orient2d(node.point, node.prev.point, node.prev.prev.point) == Orientation.CW)
			{
				// Concave
				this.fillLeftConcaveEdgeEvent(edge, node);
			}
			else
			{
				// Convex
				this.fillLeftConvexEdgeEvent(edge, node);
				// Retry this one
				this.fillLeftBelowEdgeEvent(edge, node);
			}
		}
	}

	public function fillLeftConvexEdgeEvent(edge:Edge, node:Node)
	{
		// Next concave or convex?
		if (Orientation.orient2d(node.prev.point, node.prev.prev.point, node.prev.prev.prev.point) == Orientation.CW)
		{
			// Concave
			this.fillLeftConcaveEdgeEvent(edge, node.prev);
		}
		else
		{
			// Convex
			// Next above or below edge?
			if (Orientation.orient2d(edge.q, node.prev.prev.point, edge.p) == Orientation.CW)
			{
				// Below
				this.fillLeftConvexEdgeEvent(edge, node.prev);
			}
			else
			{
				// Above
			}
		}
	}

	public function fillLeftConcaveEdgeEvent(edge:Edge, node:Node)
	{
		this.fill(node.prev);
		if (node.prev.point != edge.p)
		{
			// Next above or below edge?
			if (Orientation.orient2d(edge.q, node.prev.point, edge.p) == Orientation.CW)
			{
				// Below
				if (Orientation.orient2d(node.point, node.prev.point, node.prev.prev.point) == Orientation.CW)
				{
					// Next is concave
					this.fillLeftConcaveEdgeEvent(edge, node);
				}
				else
				{
					// Next is convex
				}
			}
		}
	}



	public function flipEdgeEvent(ep:Point, eq:Point, t:Triangle, p:Point)
	{
		var ot:Triangle = t.neighborAcross(p);
		if (ot == null)
		{
			// If we want to integrate the fillEdgeEvent do it here
			// With current implementation we should never get here
			throw 'Sweep::[BUG:FIXME] FLIP failed due to missing triangle!';
		}
		var op:Point = ot.oppositePoint(t, p);

		if (Utils.inScanArea(p, t.pointCCW(p), t.pointCW(p), op))
		{
			// Lets rotate shared edge one vertex CW
			Triangle.rotateTrianglePair(t, p, ot, op);
			this.context.mapTriangleToNodes(t);
			this.context.mapTriangleToNodes(ot);

			// @TODO: equals?
			if ((p == eq) && (op == ep))
			{
				if ((eq == this.context.edge_event.constrained_edge.q) && (ep == this.context.edge_event.constrained_edge.p)) {
					 t.markConstrainedEdgeByPoints(ep, eq);
					ot.markConstrainedEdgeByPoints(ep, eq);
					this.legalize( t);
					this.legalize(ot);
				}
				else
				{
					// XXX: I think one of the triangles should be legalized here?
				}
			}
			else
			{
				var o:Int = Orientation.orient2d(eq, op, ep);
				t = this.nextFlipTriangle(o, t, ot, p, op);
				this.flipEdgeEvent(ep, eq, t, p);
			}
		}
		else
		{
			var newP:Point = Sweep.nextFlipPoint(ep, eq, ot, op);
			this.flipScanEdgeEvent(ep, eq, t, ot, newP);
			this.edgeEventByPoints(ep, eq, t, p);
		}
	}



	public function nextFlipTriangle(o:Int, t:Triangle, ot:Triangle, p:Point, op:Point):Triangle {
		var edge_index:Int;
		if (o == Orientation.CCW)
		{
			// ot is not crossing edge after flip
			edge_index = ot.edgeIndex(p, op);
			ot.delaunay_edge[edge_index] = true;
			this.legalize(ot);
			ot.clearDelunayEdges();
			return t;
		}

		// t is not crossing edge after flip
		edge_index = t.edgeIndex(p, op);

		t.delaunay_edge[edge_index] = true;
		this.legalize(t);
		t.clearDelunayEdges();
		return ot;
	}

	static public function nextFlipPoint(ep:Point, eq:Point, ot:Triangle, op:Point):Point
	{
		var o2d:Int = Orientation.orient2d(eq, op, ep);
		if (o2d == Orientation.CW)
		{
			// Right
			return ot.pointCCW(op);
		}
		else if (o2d == Orientation.CCW)
		{
			// Left
			return ot.pointCW(op);
		}
		else
		{
			throw 'Sweep:: [Unsupported] Sweep.NextFlipPoint: opposing point on constrained edge (${op.x}, ${op.y})';
		}
	}

	public function flipScanEdgeEvent(ep:Point, eq:Point, flip_triangle:Triangle, t:Triangle, p:Point)
	{
		var ot:Triangle = t.neighborAcross(p);

		// If we want to integrate the fillEdgeEvent do it here
		// With current implementation we should never get here
		if (ot == null) throw 'Sweep::[BUG:FIXME] FLIP failed due to missing triangle';
		var op:Point = ot.oppositePoint(t, p);

		if (Utils.inScanArea(eq, flip_triangle.pointCCW(eq), flip_triangle.pointCW(eq), op))
		{
			// flip with new edge op.eq
			this.flipEdgeEvent(eq, op, ot, op);
			// TODO: Actually I just figured out that it should be possible to
			//       improve this by getting the next ot and op before the the above
			//       flip and continue the flipScanEdgeEvent here
			// set new ot and op here and loop back to inScanArea test
			// also need to set a new flip_triangle first
			// Turns out at first glance that this is somewhat complicated
			// so it will have to wait.
		}
		else
		{
			var newP:Point = nextFlipPoint(ep, eq, ot, op);
			this.flipScanEdgeEvent(ep, eq, flip_triangle, ot, newP);
		}
	}



}