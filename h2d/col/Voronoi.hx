/*
	Port by Nicolas Cannasse
	Copyright (C) 2010-2013 Raymond Hill
	MIT License: See https://github.com/gorhill/Javascript-Voronoi/LICENSE.md

	Author: Raymond Hill (rhill@raymondhill.net)
	Contributor: Jesse Morgan (morgajel@gmail.com)
	File: rhill-voronoi-core.js
	Version: 0.98
	Date: January 21, 2013
	Description: This is my personal Javascript implementation of
	Steven Fortune's algorithm to compute Voronoi diagrams.

	License: See https://github.com/gorhill/Javascript-Voronoi/LICENSE.md
	Credits: See https://github.com/gorhill/Javascript-Voronoi/CREDITS.md
	History: See https://github.com/gorhill/Javascript-Voronoi/CHANGELOG.md
*/
package h2d.col;
import hxd.Math;

// ---------------------------------------------------------------------------
// Red-Black tree code (based on C version of "rbtree" by Franck Bui-Huu
// https://github.com/fbuihuu/libtree/blob/master/rb.c

private class RBNode<T:RBNode<T>> {
	public var rbRed : Bool;
	public var rbLeft : T;
	public var rbRight : T;
	public var rbParent : T;
	public var rbNext : T;
	public var rbPrevious : T;
}

@:generic private class RBTree<T:RBNode<T>> {

	public var root : T;

	public function new() {
		this.root = null;
	}

	public function rbInsertSuccessor(node : T, successor : T) {
		var parent;
		if (node != null) {
			// >>> rhill 2011-05-27: Performance: cache previous/next nodes
			successor.rbPrevious = node;
			successor.rbNext = node.rbNext;
			if (node.rbNext != null ) {
				node.rbNext.rbPrevious = successor;
				}
			node.rbNext = successor;
			// <<<
			if (node.rbRight != null) {
				// in-place expansion of node.rbRight.getFirst();
				node = node.rbRight;
				while (node.rbLeft != null) {node = node.rbLeft;}
				node.rbLeft = successor;
				}
			else {
				node.rbRight = successor;
				}
			parent = node;
			}
		// rhill 2011-06-07: if node is null, successor must be inserted
		// to the left-most part of the tree
		else if (this.root != null) {
			node = this.getFirst(this.root);
			// >>> Performance: cache previous/next nodes
			successor.rbPrevious = null;
			successor.rbNext = node;
			node.rbPrevious = successor;
			// <<<
			node.rbLeft = successor;
			parent = node;
			}
		else {
			// >>> Performance: cache previous/next nodes
			successor.rbPrevious = successor.rbNext = null;
			// <<<
			this.root = successor;
			parent = null;
			}
		successor.rbLeft = successor.rbRight = null;
		successor.rbParent = parent;
		successor.rbRed = true;
		// Fixup the modified tree by recoloring nodes and performing
		// rotations (2 at most) hence the red-black tree properties are
		// preserved.
		var grandpa, uncle;
		node = successor;
		while (parent != null && parent.rbRed) {
			grandpa = parent.rbParent;
			if (parent == grandpa.rbLeft) {
				uncle = grandpa.rbRight;
				if (uncle != null && uncle.rbRed) {
					parent.rbRed = uncle.rbRed = false;
					grandpa.rbRed = true;
					node = grandpa;
					}
				else {
					if (node == parent.rbRight) {
						this.rbRotateLeft(parent);
						node = parent;
						parent = node.rbParent;
						}
					parent.rbRed = false;
					grandpa.rbRed = true;
					this.rbRotateRight(grandpa);
					}
				}
			else {
				uncle = grandpa.rbLeft;
				if (uncle != null && uncle.rbRed) {
					parent.rbRed = uncle.rbRed = false;
					grandpa.rbRed = true;
					node = grandpa;
					}
				else {
					if (node == parent.rbLeft) {
						this.rbRotateRight(parent);
						node = parent;
						parent = node.rbParent;
						}
					parent.rbRed = false;
					grandpa.rbRed = true;
					this.rbRotateLeft(grandpa);
					}
				}
			parent = node.rbParent;
			}
		this.root.rbRed = false;
	}

	public function rbRemoveNode(node:T) {
		// >>> rhill 2011-05-27: Performance: cache previous/next nodes
		if (node.rbNext != null) {
			node.rbNext.rbPrevious = node.rbPrevious;
			}
		if (node.rbPrevious != null) {
			node.rbPrevious.rbNext = node.rbNext;
			}
		node.rbNext = node.rbPrevious = null;
		// <<<
		var parent = node.rbParent,
			left = node.rbLeft,
			right = node.rbRight,
			next;
		if (left == null) {
			next = right;
			}
		else if (right == null) {
			next = left;
			}
		else {
			next = this.getFirst(right);
			}
		if (parent != null) {
			if (parent.rbLeft == node) {
				parent.rbLeft = next;
				}
			else {
				parent.rbRight = next;
				}
			}
		else {
			this.root = next;
			}
		// enforce red-black rules
		var isRed;
		if (left != null && right != null) {
			isRed = next.rbRed;
			next.rbRed = node.rbRed;
			next.rbLeft = left;
			left.rbParent = next;
			if (next != right) {
				parent = next.rbParent;
				next.rbParent = node.rbParent;
				node = next.rbRight;
				parent.rbLeft = node;
				next.rbRight = right;
				right.rbParent = next;
				}
			else {
				next.rbParent = parent;
				parent = next;
				node = next.rbRight;
				}
			}
		else {
			isRed = node.rbRed;
			node = next;
			}
		// 'node' is now the sole successor's child and 'parent' its
		// new parent (since the successor can have been moved)
		if (node != null) {
			node.rbParent = parent;
			}
		// the 'easy' cases
		if (isRed) {return;}
		if (node != null && node.rbRed) {
			node.rbRed = false;
			return;
			}
		// the other cases
		var sibling;
		do {
			if (node == this.root) {
				break;
				}
			if (node == parent.rbLeft) {
				sibling = parent.rbRight;
				if (sibling.rbRed) {
					sibling.rbRed = false;
					parent.rbRed = true;
					this.rbRotateLeft(parent);
					sibling = parent.rbRight;
					}
				if ((sibling.rbLeft != null && sibling.rbLeft.rbRed) || (sibling.rbRight != null && sibling.rbRight.rbRed)) {
					if (sibling.rbRight == null || !sibling.rbRight.rbRed) {
						sibling.rbLeft.rbRed = false;
						sibling.rbRed = true;
						this.rbRotateRight(sibling);
						sibling = parent.rbRight;
						}
					sibling.rbRed = parent.rbRed;
					parent.rbRed = sibling.rbRight.rbRed = false;
					this.rbRotateLeft(parent);
					node = this.root;
					break;
					}
				}
			else {
				sibling = parent.rbLeft;
				if (sibling.rbRed) {
					sibling.rbRed = false;
					parent.rbRed = true;
					this.rbRotateRight(parent);
					sibling = parent.rbLeft;
					}
				if ((sibling.rbLeft != null && sibling.rbLeft.rbRed) || (sibling.rbRight != null && sibling.rbRight.rbRed)) {
					if (sibling.rbLeft == null || !sibling.rbLeft.rbRed) {
						sibling.rbRight.rbRed = false;
						sibling.rbRed = true;
						this.rbRotateLeft(sibling);
						sibling = parent.rbLeft;
						}
					sibling.rbRed = parent.rbRed;
					parent.rbRed = sibling.rbLeft.rbRed = false;
					this.rbRotateRight(parent);
					node = this.root;
					break;
					}
				}
			sibling.rbRed = true;
			node = parent;
			parent = parent.rbParent;
		} while (!node.rbRed);
		if (node != null) {node.rbRed = false;}
	}

	function rbRotateLeft(node:T) {
		var p = node,
			q = node.rbRight, // can't be null
			parent = p.rbParent;
		if (parent != null) {
			if (parent.rbLeft == p) {
				parent.rbLeft = q;
				}
			else {
				parent.rbRight = q;
				}
			}
		else {
			this.root = q;
			}
		q.rbParent = parent;
		p.rbParent = q;
		p.rbRight = q.rbLeft;
		if (p.rbRight != null) {
			p.rbRight.rbParent = p;
			}
		q.rbLeft = p;
	}

	function rbRotateRight(node:T) {
		var p = node,
			q = node.rbLeft, // can't be null
			parent = p.rbParent;
		if (parent != null) {
			if (parent.rbLeft == p) {
				parent.rbLeft = q;
				}
			else {
				parent.rbRight = q;
				}
			}
		else {
			this.root = q;
			}
		q.rbParent = parent;
		p.rbParent = q;
		p.rbLeft = q.rbRight;
		if (p.rbLeft != null) {
			p.rbLeft.rbParent = p;
			}
		q.rbRight = p;
	}

	public function getFirst(node:T) {
		while(node.rbLeft != null)
			node = node.rbLeft;
		return node;
	}

	public function getLast(node:T) {
		while( node.rbRight != null )
			node = node.rbRight;
		return node;
	}
}

/**
	The resulting cell inside the Voronoi diagram.
**/
class Cell {

	/**
		The unique ID/Index of the cell.
	**/
	public var id : Int;
	/**
		The source seed point of the cell.
	**/
	public var point : Point;
	/**
		The list of the edges of the cell.
	**/
	public var halfedges : Array<Halfedge>;
	public var closeMe : Bool;

	@:dox(hide) @:noCompletion
	public function new(id, point) {
		this.id = id;
		this.point = point;
		this.halfedges = [];
		this.closeMe = false;
	}

	/**
		Returns an enclosing circle collider of the Cell.

		_Implementation note_: Not the best possible solution and may produce artifacts.
	**/
	public function getCircle() {
		// still not the best enclosing circle
		// would require implementing http://www.personal.kent.edu/~rmuhamma/Compgeometry/MyCG/CG-Applets/Center/centercli.htm for complete solution
		var p = new Point(), ec = 0;
		for( e in halfedges ) {
			var ep = e.getStartpoint();
			p.x += ep.x;
			p.y += ep.y;
			ec++;
		}
		p.x /= ec;
		p.y /= ec;
		var r = 0.;
		for( e in halfedges ) {
			var d = p.distanceSq(e.getStartpoint());
			if( d > r ) r = d;
		}
		return new Circle(p.x, p.y, Math.sqrt(r));
	}

	@:dox(hide) @:noCompletion
	public function prepare() {
		var halfedges = this.halfedges, iHalfedge = halfedges.length, edge;
		// get rid of unused halfedges
		// rhill 2011-05-27: Keep it simple, no point here in trying
		// to be fancy: dangling edges are a typically a minority.
		while (iHalfedge-- != 0) {
			edge = halfedges[iHalfedge].edge;
			if (edge.vb == null || edge.va == null) {
				halfedges.splice(iHalfedge,1);
				}
			}

		// rhill 2011-05-26: I tried to use a binary search at insertion
		// time to keep the array sorted on-the-fly (in Cell.addHalfedge()).
		// There was no real benefits in doing so, performance on
		// Firefox 3.6 was improved marginally, while performance on
		// Opera 11 was penalized marginally.
		halfedges.sort(sortByAngle);
		return halfedges.length;
	}

	static function sortByAngle(a:Halfedge, b:Halfedge) {
		return b.angle > a.angle ? 1 : (b.angle < a.angle ? -1 : 0);
	}

	/**
		Returns a list of the neighboring cells.
	**/
	public function getNeighbors() {
		var neighbors = [],
			iHalfedge = this.halfedges.length,
			edge;
		while (iHalfedge-- != 0){
			edge = this.halfedges[iHalfedge].edge;
			// NC : changes pointId check to object == check
			if (edge.lPoint != null && edge.lPoint != this.point) {
				neighbors.push(edge.lPoint);
				}
			else if (edge.rPoint != null && edge.rPoint != this.point){
				neighbors.push(edge.rPoint);
				}
			}
		return neighbors;
	}

	/**
		Returns a list of the neighbor Cell indexes.
	**/
	public function getNeighborIndexes() {
		var neighbors = [],
			iHalfedge = this.halfedges.length,
			edge;
		while (iHalfedge-- != 0){
			edge = this.halfedges[iHalfedge].edge;
			// NC : changes pointId check to object == check
			if (edge.lPoint != null && edge.lPoint != this.point) {
				neighbors.push(edge.lCell.id);
				}
			else if (edge.rPoint != null && edge.rPoint != this.point){
				neighbors.push(edge.rCell.id);
				}
			}
		return neighbors;
	}

	/**
		Returns a bounding box of the Cell.
	**/
	public function getBbox() {
		var halfedges = this.halfedges,
			iHalfedge = halfedges.length,
			xmin = Math.POSITIVE_INFINITY,
			ymin = Math.POSITIVE_INFINITY,
			xmax = Math.NEGATIVE_INFINITY,
			ymax = Math.NEGATIVE_INFINITY;
		while (iHalfedge-- != 0) {
			var v = halfedges[iHalfedge].getStartpoint();
			var vx = v.x;
			var vy = v.y;
			if (vx < xmin) {xmin = vx;}
			if (vy < ymin) {ymin = vy;}
			if (vx > xmax) {xmax = vx;}
			if (vy > ymax) {ymax = vy;}
			// we dont need to take into account end point,
			// since each end point matches a start point
			}
		return {
			x: xmin,
			y: ymin,
			width: xmax-xmin,
			height: ymax-ymin
		};
	}

	/**
		Tests if given position is inside, on, or outside of the cell.
		@returns
		* -1: point is outside the perimeter of the cell
		* 0: point is on the perimeter of the cell
		* 1: point is inside the perimeter of the cell
	**/
	public function pointIntersection(x:Float, y:Float) {
		// Check if point in polygon. Since all polygons of a Voronoi
		// diagram are convex, then:
		// http://paulbourke.net/geometry/polygonmesh/
		// Solution 3 (2D):
		//   "If the polygon is convex then one can consider the polygon
		//   "as a 'path' from the first vertex. A point is on the interior
		//   "of this polygons if it is always on the same side of all the
		//   "line segments making up the path. ...
		//   "(y - y0) (x1 - x0) - (x - x0) (y1 - y0)
		//   "if it is less than 0 then P is to the right of the line segment,
		//   "if greater than 0 it is to the left, if equal to 0 then it lies
		//   "on the line segment"
		var halfedges = this.halfedges,
			iHalfedge = halfedges.length,
			p0, p1, r;
		while (iHalfedge-- != 0) {
			var halfedge = halfedges[iHalfedge];
			p0 = halfedge.getStartpoint();
			p1 = halfedge.getEndpoint();
			r = (y-p0.y)*(p1.x-p0.x)-(x-p0.x)*(p1.y-p0.y);
			if (r == 0) {
				return 0;
				}
			if (r > 0) {
				return -1;
				}
			}
		return 1;
	}

}

/**
	The resulting edge inside the Voronoi diagram.
**/
class Edge {
	/**
		The unique ID/Index of the edge.
	**/
	public var id : Int;
	/**
		The left-hand seed point.
	**/
	public var lPoint : Point;
	/**
		The right-hand seed point.
	**/
	public var rPoint : Point;
	/**
		The left-hand cell along the edge.
	**/
	public var lCell : Null<Cell>;
	/**
		The right-hand cell along the edge.
	**/
	public var rCell : Null<Cell>;
	/**
		The first position of the edge segment.
	**/
	public var va : Null<Point>;
	/**
		The second position of the edge segment.
	**/
	public var vb : Null<Point>;

	@:dox(hide) @:noCompletion
	public function new(lPoint, rPoint) {
		this.lPoint = lPoint;
		this.rPoint = rPoint;
		this.va = this.vb = null;
	}
}

/**
	The edge attached to a Voronoi `Cell`.
**/
class Halfedge {

	/**
		The seed Point of the Cell this edge is attached to.
	**/
	public var point : Point;
	/**
		The Edge this half-edge is attached to.
	**/
	public var edge : Edge;
	/**
		The perpendicular angle to the edge segment pointing in the direction of either neighboring Cell of the border.
	**/
	public var angle : Float;

	@:dox(hide) @:noCompletion
	public function new(edge, lPoint:Point, rPoint:Point) {
		this.point = lPoint;
		this.edge = edge;
		// 'angle' is a value to be used for properly sorting the
		// halfsegments counterclockwise. By convention, we will
		// use the angle of the line defined by the 'point to the left'
		// to the 'point to the right'.
		// However, border edges have no 'point to the right': thus we
		// use the angle of line perpendicular to the halfsegment (the
		// edge should have both end points defined in such case.)
		if (rPoint != null) {
			this.angle = Math.atan2(rPoint.y-lPoint.y, rPoint.x-lPoint.x);
		} else {
			var va = edge.va,
				vb = edge.vb;
			// rhill 2011-05-31: used to call getStartpoint()/getEndpoint(),
			// but for performance purpose, these are expanded in place here.
			this.angle = edge.lPoint == lPoint
				? Math.atan2(vb.x-va.x, va.y-vb.y)
				: Math.atan2(va.x-vb.x, vb.y-va.y);
		}
	}

	/**
		Returns the starting point of the edge segment.
	**/
	public inline function getStartpoint() {
		return this.edge.lPoint == this.point ? this.edge.va : this.edge.vb;
	}

	/**
		Returns the end point of the edge segment.
	**/
	public inline function getEndpoint() {
		return this.edge.lPoint == this.point ? this.edge.vb : this.edge.va;
	}

	/**
		Returns the neighboring Cell of this half-edge or null if it's a border edge.
	**/
	public inline function getTarget() {
		return this.edge.lCell != null && this.edge.lCell.point != point ? this.edge.lCell : this.edge.rCell;
	}

}

/**
	The resulting diagram of the `Voronoi.compute`.
**/
class Diagram {
	/**
		The list of the generated cells.
	**/
	public var cells : Array<Cell>;
	/**
		The list of the diagram seed points.
	**/
	public var points : Array<Point>;
	/**
		The list of edges between diagram cells.
	**/
	public var edges : Array<Edge>;
	/**
		The duration it took to compute this diagram.
	**/
	public var execTime : Float;

	@:dox(hide) @:noCompletion
	public function new() {
	}
}

private class Beachsection extends RBNode<Beachsection> {
	public var point : Point;
	public var edge : Edge;
	public var circleEvent : CircleEvent;
	public function new() {
	}
}

private class CircleEvent extends RBNode<CircleEvent> {
	public var point : Point;
	public var arc : Beachsection;
	public var x : Float;
	public var y : Float;
	public var ycenter : Float;
	public function new() {
	}
}

/**
	A Steven Fortune's algorithm to compute Voronoi diagram from given set of Points and a bounding box.

	The implementation is a port from JS library: https://github.com/gorhill/Javascript-Voronoi
**/
class Voronoi {

	var epsilon : Float;
	var beachline : RBTree<Beachsection>;
	var vertices : Array<Point>;
	var edges : Array<Edge>;
	var cells : Array<Cell>;
	var beachsectionJunkyard : Array<Beachsection>;
	var circleEventJunkyard : Array<CircleEvent>;
	var circleEvents : RBTree<CircleEvent>;
	var firstCircleEvent : CircleEvent;
	var pointCell : Map<Point,Cell>;

	/**
		Create a new Voronoi algorithm calculator.
	**/
	public function new( epsilon = 1e-9 ) {
		this.epsilon = epsilon;
		this.vertices = null;
		this.edges = null;
		this.cells = null;
		this.beachsectionJunkyard = [];
		this.circleEventJunkyard = [];
	}

	/**
		Clean up the calculator from previous operation, and prepare for a new one.

		Not required to be called manually, as it's invoked by `Voronoi.compute`.
	**/
	public function reset() {
		if( this.beachline == null )
			this.beachline = new RBTree<Beachsection>();
		// Move leftover beachsections to the beachsection junkyard.
		if (this.beachline.root != null) {
			var beachsection = this.beachline.getFirst(this.beachline.root);
			while (beachsection != null) {
				this.beachsectionJunkyard.push(beachsection); // mark for reuse
				beachsection = beachsection.rbNext;
				}
			}
		this.beachline.root = null;
		if (this.circleEvents == null) {
			this.circleEvents = new RBTree<CircleEvent>();
			}
		pointCell = new Map();
		this.circleEvents.root = this.firstCircleEvent = null;
		this.vertices = [];
		this.edges = [];
		this.cells = [];
	}

	static inline function abs(x:Float) return x < 0 ? -x : x;
	inline function equalWithepsilon(a:Float,b:Float) return abs(a-b)<epsilon;
	inline function greaterThanWithepsilon(a:Float,b:Float) return a-b>epsilon;
	inline function greaterThanOrEqualWithepsilon(a:Float,b:Float) return b-a<epsilon;
	inline function lessThanWithepsilon(a:Float,b:Float) return b-a>epsilon;
	inline function lessThanOrEqualWithepsilon(a:Float,b:Float) return a-b<epsilon;

	function createVertex(x, y) {
		var v = new Point(x, y);
		this.vertices.push(v);
		return v;
	}

	// this create and add an edge to internal collection, and also create
	// two halfedges which are added to each point's counterclockwise array
	// of halfedges.

	function createEdge(lPoint, rPoint, va = null, vb = null) {
		var edge = new Edge(lPoint, rPoint);
		this.edges.push(edge);
		if (va != null) {
			this.setEdgeStartpoint(edge, lPoint, rPoint, va);
			}
		if (vb != null) {
			this.setEdgeEndpoint(edge, lPoint, rPoint, vb);
			}
		pointCell.get(lPoint).halfedges.push(new Halfedge(edge, lPoint, rPoint));
		pointCell.get(rPoint).halfedges.push(new Halfedge(edge, rPoint, lPoint));
		return edge;
	}

	function createBorderEdge(lPoint, va, vb) {
		var edge = new Edge(lPoint, null);
		edge.va = va;
		edge.vb = vb;
		this.edges.push(edge);
		return edge;
	}

	function setEdgeStartpoint(edge:Edge, lPoint, rPoint, vertex) {
		if (edge.va == null && edge.vb == null) {
			edge.va = vertex;
			edge.lPoint = lPoint;
			edge.rPoint = rPoint;
			}
		else if (edge.lPoint == rPoint) {
			edge.vb = vertex;
			}
		else {
			edge.va = vertex;
			}
	}

	function setEdgeEndpoint(edge, lPoint, rPoint, vertex) {
		this.setEdgeStartpoint(edge, rPoint, lPoint, vertex);
	}


	// rhill 2011-06-02: A lot of Beachsection instanciations
	// occur during the computation of the Voronoi diagram,
	// somewhere between the number of points and twice the
	// number of points, while the number of Beachsections on the
	// beachline at any given time is comparatively low. For this
	// reason, we reuse already created Beachsections, in order
	// to avoid new memory allocation. This resulted in a measurable
	// performance gain.

	function createBeachsection(point:Point) {
		var beachsection = this.beachsectionJunkyard.pop();
		if ( beachsection == null )
			beachsection = new Beachsection();
		beachsection.point = point;
		return beachsection;
	}

	// calculate the left break point of a particular beach section,
	// given a particular sweep line
	function leftBreakPoint(arc:Beachsection, directrix:Float) {
		// http://en.wikipedia.org/wiki/Parabola
		// http://en.wikipedia.org/wiki/Quadratic_equation
		// h1 = x1,
		// k1 = (y1+directrix)/2,
		// h2 = x2,
		// k2 = (y2+directrix)/2,
		// p1 = k1-directrix,
		// a1 = 1/(4*p1),
		// b1 = -h1/(2*p1),
		// c1 = h1*h1/(4*p1)+k1,
		// p2 = k2-directrix,
		// a2 = 1/(4*p2),
		// b2 = -h2/(2*p2),
		// c2 = h2*h2/(4*p2)+k2,
		// x = (-(b2-b1) + Math.sqrt((b2-b1)*(b2-b1) - 4*(a2-a1)*(c2-c1))) / (2*(a2-a1))
		// When x1 become the x-origin:
		// h1 = 0,
		// k1 = (y1+directrix)/2,
		// h2 = x2-x1,
		// k2 = (y2+directrix)/2,
		// p1 = k1-directrix,
		// a1 = 1/(4*p1),
		// b1 = 0,
		// c1 = k1,
		// p2 = k2-directrix,
		// a2 = 1/(4*p2),
		// b2 = -h2/(2*p2),
		// c2 = h2*h2/(4*p2)+k2,
		// x = (-b2 + Math.sqrt(b2*b2 - 4*(a2-a1)*(c2-k1))) / (2*(a2-a1)) + x1

		// change code below at your own risk: care has been taken to
		// reduce errors due to computers' finite arithmetic precision.
		// Maybe can still be improved, will see if any more of this
		// kind of errors pop up again.
		var point = arc.point,
			rfocx = point.x,
			rfocy = point.y,
			pby2 = rfocy-directrix;
		// parabola in degenerate case where focus is on directrix
		if (pby2 == 0) {
			return rfocx;
			}
		var lArc = arc.rbPrevious;
		if (lArc == null) {
			return Math.NEGATIVE_INFINITY;
			}
		point = lArc.point;
		var lfocx = point.x,
			lfocy = point.y,
			plby2 = lfocy-directrix;
		// parabola in degenerate case where focus is on directrix
		if (plby2 == 0) {
			return lfocx;
			}
		var    hl = lfocx-rfocx,
			aby2 = 1/pby2-1/plby2,
			b = hl/plby2;
		if (aby2 != 0) {
			return (-b+Math.sqrt(b*b-2*aby2*(hl*hl/(-2*plby2)-lfocy+plby2/2+rfocy-pby2/2)))/aby2+rfocx;
			}
		// both parabolas have same distance to directrix, thus break point is midway
		return (rfocx+lfocx)/2;
	}

	// calculate the right break point of a particular beach section,
	// given a particular directrix
	function rightBreakPoint(arc:Beachsection, directrix) {
		var rArc = arc.rbNext;
		if (rArc != null) {
			return this.leftBreakPoint(rArc, directrix);
			}
		var point = arc.point;
		return point.y == directrix ? point.x : Math.POSITIVE_INFINITY;
	}

	function detachBeachsection(beachsection) {
		this.detachCircleEvent(beachsection); // detach potentially attached circle event
		this.beachline.rbRemoveNode(beachsection); // remove from RB-tree
		this.beachsectionJunkyard.push(beachsection); // mark for reuse
	}

	function removeBeachsection(beachsection:Beachsection) {
		var circle = beachsection.circleEvent,
			x = circle.x,
			y = circle.ycenter,
			vertex = this.createVertex(x, y),
			previous = beachsection.rbPrevious,
			next = beachsection.rbNext,
			disappearingTransitions = [beachsection];

		// remove collapsed beachsection from beachline
		this.detachBeachsection(beachsection);

		// there could be more than one empty arc at the deletion point, this
		// happens when more than two edges are linked by the same vertex,
		// so we will collect all those edges by looking up both sides of
		// the deletion point.
		// by the way, there is *always* a predecessor/successor to any collapsed
		// beach section, it's just impossible to have a collapsing first/last
		// beach sections on the beachline, since they obviously are unconstrained
		// on their left/right side.

		// look left
		var lArc = previous;
		while (lArc.circleEvent != null && abs(x-lArc.circleEvent.x)<epsilon && abs(y-lArc.circleEvent.ycenter)<epsilon) {
			previous = lArc.rbPrevious;
			disappearingTransitions.unshift(lArc);
			this.detachBeachsection(lArc); // mark for reuse
			lArc = previous;
			}
		// even though it is not disappearing, I will also add the beach section
		// immediately to the left of the left-most collapsed beach section, for
		// convenience, since we need to refer to it later as this beach section
		// is the 'left' point of an edge for which a start point is set.
		disappearingTransitions.unshift(lArc);
		this.detachCircleEvent(lArc);

		// look right
		var rArc = next;
		while (rArc.circleEvent != null && abs(x-rArc.circleEvent.x)<epsilon && abs(y-rArc.circleEvent.ycenter)<epsilon) {
			next = rArc.rbNext;
			disappearingTransitions.push(rArc);
			this.detachBeachsection(rArc); // mark for reuse
			rArc = next;
			}
		// we also have to add the beach section immediately to the right of the
		// right-most collapsed beach section, since there is also a disappearing
		// transition representing an edge's start point on its left.
		disappearingTransitions.push(rArc);
		this.detachCircleEvent(rArc);

		// walk through all the disappearing transitions between beach sections and
		// set the start point of their (implied) edge.
		var nArcs = disappearingTransitions.length,
			iArc;
		for( iArc in 1...nArcs ) {
			rArc = disappearingTransitions[iArc];
			lArc = disappearingTransitions[iArc-1];
			this.setEdgeStartpoint(rArc.edge, lArc.point, rArc.point, vertex);
		}

		// create a new edge as we have now a new transition between
		// two beach sections which were previously not adjacent.
		// since this edge appears as a new vertex is defined, the vertex
		// actually define an end point of the edge (relative to the point
		// on the left)
		lArc = disappearingTransitions[0];
		rArc = disappearingTransitions[nArcs-1];
		rArc.edge = this.createEdge(lArc.point, rArc.point, null, vertex);

		// create circle events if any for beach sections left in the beachline
		// adjacent to collapsed sections
		this.attachCircleEvent(lArc);
		this.attachCircleEvent(rArc);
	}

	function addBeachsection(point:Point) {
		var x = point.x,
			directrix = point.y;

		// find the left and right beach sections which will surround the newly
		// created beach section.
		// rhill 2011-06-01: This loop is one of the most often executed,
		// hence we expand in-place the comparison-against-epsilon calls.
		var lArc = null, rArc = null,
			dxl, dxr,
			node = this.beachline.root;

		while (node != null) {
			dxl = this.leftBreakPoint(node,directrix)-x;
			// x lessThanWithepsilon xl => falls somewhere before the left edge of the beachsection
			if (dxl > epsilon) {
				// this case should never happen
				// if (!node.rbLeft) {
				//    rArc = node.rbLeft;
				//    break;
				//    }
				node = node.rbLeft;
				}
			else {
				dxr = x-this.rightBreakPoint(node,directrix);
				// x greaterThanWithepsilon xr => falls somewhere after the right edge of the beachsection
				if (dxr > epsilon) {
					if (node.rbRight == null) {
						lArc = node;
						break;
						}
					node = node.rbRight;
					}
				else {
					// x equalWithepsilon xl => falls exactly on the left edge of the beachsection
					if (dxl > -epsilon) {
						lArc = node.rbPrevious;
						rArc = node;
						}
					// x equalWithepsilon xr => falls exactly on the right edge of the beachsection
					else if (dxr > -epsilon) {
						lArc = node;
						rArc = node.rbNext;
						}
					// falls exactly somewhere in the middle of the beachsection
					else {
						lArc = rArc = node;
						}
					break;
					}
				}
			}
		// at this point, keep in mind that lArc and/or rArc could be
		// undefined or null.

		// create a new beach section object for the point and add it to RB-tree
		var newArc = this.createBeachsection(point);
		this.beachline.rbInsertSuccessor(lArc, newArc);

		// cases:
		//

		// [null,null]
		// least likely case: new beach section is the first beach section on the
		// beachline.
		// This case means:
		//   no new transition appears
		//   no collapsing beach section
		//   new beachsection become root of the RB-tree
		if (lArc == null && rArc == null) {
			return;
			}

		// [lArc,rArc] where lArc == rArc
		// most likely case: new beach section split an existing beach
		// section.
		// This case means:
		//   one new transition appears
		//   the left and right beach section might be collapsing as a result
		//   two new nodes added to the RB-tree
		if (lArc == rArc) {
			// invalidate circle event of split beach section
			this.detachCircleEvent(lArc);

			// split the beach section into two separate beach sections
			rArc = this.createBeachsection(lArc.point);
			this.beachline.rbInsertSuccessor(newArc, rArc);

			// since we have a new transition between two beach sections,
			// a new edge is born
			newArc.edge = rArc.edge = this.createEdge(lArc.point, newArc.point);

			// check whether the left and right beach sections are collapsing
			// and if so create circle events, to be notified when the point of
			// collapse is reached.
			this.attachCircleEvent(lArc);
			this.attachCircleEvent(rArc);
			return;
			}

		// [lArc,null]
		// even less likely case: new beach section is the *last* beach section
		// on the beachline -- this can happen *only* if *all* the previous beach
		// sections currently on the beachline share the same y value as
		// the new beach section.
		// This case means:
		//   one new transition appears
		//   no collapsing beach section as a result
		//   new beach section become right-most node of the RB-tree
		if (lArc != null && rArc == null) {
			newArc.edge = this.createEdge(lArc.point,newArc.point);
			return;
			}

		// [null,rArc]
		// impossible case: because points are strictly processed from top to bottom,
		// and left to right, which guarantees that there will always be a beach section
		// on the left -- except of course when there are no beach section at all on
		// the beach line, which case was handled above.
		// rhill 2011-06-02: No point testing in non-debug version
		//if (!lArc && rArc) {
		//    throw "Voronoi.addBeachsection(): What is this I don't even";
		//    }

		// [lArc,rArc] where lArc != rArc
		// somewhat less likely case: new beach section falls *exactly* in between two
		// existing beach sections
		// This case means:
		//   one transition disappears
		//   two new transitions appear
		//   the left and right beach section might be collapsing as a result
		//   only one new node added to the RB-tree
		if (lArc != rArc) {
			// invalidate circle events of left and right points
			this.detachCircleEvent(lArc);
			this.detachCircleEvent(rArc);

			// an existing transition disappears, meaning a vertex is defined at
			// the disappearance point.
			// since the disappearance is caused by the new beachsection, the
			// vertex is at the center of the circumscribed circle of the left,
			// new and right beachsections.
			// http://mathforum.org/library/drmath/view/55002.html
			// Except that I bring the origin at A to simplify
			// calculation
			var lPoint = lArc.point,
				ax = lPoint.x,
				ay = lPoint.y,
				bx=point.x-ax,
				by=point.y-ay,
				rPoint = rArc.point,
				cx=rPoint.x-ax,
				cy=rPoint.y-ay,
				d=2*(bx*cy-by*cx),
				hb=bx*bx+by*by,
				hc=cx*cx+cy*cy,
				vertex = this.createVertex((cy*hb-by*hc)/d+ax, (bx*hc-cx*hb)/d+ay);

			// one transition disappear
			this.setEdgeStartpoint(rArc.edge, lPoint, rPoint, vertex);

			// two new transitions appear at the new vertex location
			newArc.edge = this.createEdge(lPoint, point, null, vertex);
			rArc.edge = this.createEdge(point, rPoint, null, vertex);

			// check whether the left and right beach sections are collapsing
			// and if so create circle events, to handle the point of collapse.
			this.attachCircleEvent(lArc);
			this.attachCircleEvent(rArc);
			return;
		}
	}

	function attachCircleEvent(arc:Beachsection) {
		var lArc = arc.rbPrevious,
			rArc = arc.rbNext;
		if (lArc == null || rArc == null) {return;} // does that ever happen?
		var lPoint = lArc.point,
			cPoint = arc.point,
			rPoint = rArc.point;

		// If point of left beachsection is same as point of
		// right beachsection, there can't be convergence
		if (lPoint==rPoint) {return;}

		// Find the circumscribed circle for the three points associated
		// with the beachsection triplet.
		// rhill 2011-05-26: It is more efficient to calculate in-place
		// rather than getting the resulting circumscribed circle from an
		// object returned by calling Voronoi.circumcircle()
		// http://mathforum.org/library/drmath/view/55002.html
		// Except that I bring the origin at cPoint to simplify calculations.
		// The bottom-most part of the circumcircle is our Fortune 'circle
		// event', and its center is a vertex potentially part of the final
		// Voronoi diagram.
		var bx = cPoint.x,
			by = cPoint.y,
			ax = lPoint.x-bx,
			ay = lPoint.y-by,
			cx = rPoint.x-bx,
			cy = rPoint.y-by;

		// If points l->c->r are clockwise, then center beach section does not
		// collapse, hence it can't end up as a vertex (we reuse 'd' here, which
		// sign is reverse of the orientation, hence we reverse the test.
		// http://en.wikipedia.org/wiki/Curve_orientation#Orientation_of_a_simple_polygon
		// rhill 2011-05-21: Nasty finite precision error which caused circumcircle() to
		// return infinites: 1e-12 seems to fix the problem.
		var d = 2*(ax*cy-ay*cx);
		if (d >= -2e-12){return;}

		var    ha = ax*ax+ay*ay,
			hc = cx*cx+cy*cy,
			x = (cy*ha-ay*hc)/d,
			y = (ax*hc-cx*ha)/d,
			ycenter = y+by;

		// Important: ybottom should always be under or at sweep, so no need
		// to waste CPU cycles by checking

		// recycle circle event object if possible
		var circleEvent = this.circleEventJunkyard.pop();
		if (circleEvent == null) {
			circleEvent = new CircleEvent();
			}
		circleEvent.arc = arc;
		circleEvent.point = cPoint;
		circleEvent.x = x+bx;
		circleEvent.y = ycenter+Math.sqrt(x*x+y*y); // y bottom
		circleEvent.ycenter = ycenter;
		arc.circleEvent = circleEvent;

		// find insertion point in RB-tree: circle events are ordered from
		// smallest to largest
		var predecessor = null,
			node = this.circleEvents.root;
		while (node != null) {
			if (circleEvent.y < node.y || (circleEvent.y == node.y && circleEvent.x <= node.x)) {
				if (node.rbLeft != null) {
					node = node.rbLeft;
					}
				else {
					predecessor = node.rbPrevious;
					break;
					}
				}
			else {
				if (node.rbRight != null) {
					node = node.rbRight;
					}
				else {
					predecessor = node;
					break;
					}
				}
			}
		this.circleEvents.rbInsertSuccessor(predecessor, circleEvent);
		if (predecessor == null) {
			this.firstCircleEvent = circleEvent;
			}
	}

	function detachCircleEvent(arc:Beachsection) {
		var circle = arc.circleEvent;
		if (circle != null) {
			if (circle.rbPrevious == null) {
				this.firstCircleEvent = circle.rbNext;
				}
			this.circleEvents.rbRemoveNode(circle); // remove from RB-tree
			this.circleEventJunkyard.push(circle);
			arc.circleEvent = null;
		}
	}

	// ---------------------------------------------------------------------------
	// Diagram completion methods

	// connect dangling edges (not if a cursory test tells us
	// it is not going to be visible.
	// return value:
	//   false: the dangling endpoint couldn't be connected
	//   true: the dangling endpoint could be connected
	function connectEdge(edge:Edge, bbox:Bounds) {
		// skip if end point already connected
		var vb = edge.vb;
		if (vb != null) {return true;}

		// make local copy for performance purpose
		var va = edge.va,
			xl = bbox.xMin,
			xr = bbox.xMax,
			yt = bbox.yMin,
			yb = bbox.yMax,
			lPoint = edge.lPoint,
			rPoint = edge.rPoint,
			lx = lPoint.x,
			ly = lPoint.y,
			rx = rPoint.x,
			ry = rPoint.y,
			fx = (lx+rx)/2,
			fy = (ly+ry)/2,
			fm = 0., fb = 0.;

		pointCell.get(lPoint).closeMe = true;
		pointCell.get(rPoint).closeMe = true;

		// get the line equation of the bisector if line is not vertical
		if (ry != ly) {
			fm = (lx-rx)/(ry-ly);
			fb = fy-fm*fx;
			}

		// remember, direction of line (relative to left point):
		// upward: left.x < right.x
		// downward: left.x > right.x
		// horizontal: left.x == right.x
		// upward: left.x < right.x
		// rightward: left.y < right.y
		// leftward: left.y > right.y
		// vertical: left.y == right.y

		// depending on the direction, find the best side of the
		// bounding box to use to determine a reasonable start point

		// special case: vertical line
		if (ry == ly) {
			// doesn't intersect with viewport
			if (fx < xl || fx >= xr) {return false;}
			// downward
			if (lx > rx) {
				if (va == null || va.y < yt) {
					va = this.createVertex(fx, yt);
					}
				else if (va.y >= yb) {
					return false;
					}
				vb = this.createVertex(fx, yb);
				}
			// upward
			else {
				if (va == null || va.y > yb) {
					va = this.createVertex(fx, yb);
					}
				else if (va.y < yt) {
					return false;
					}
				vb = this.createVertex(fx, yt);
				}
			}
		// closer to vertical than horizontal, connect start point to the
		// top or bottom side of the bounding box
		else if (fm < -1 || fm > 1) {
			// downward
			if (lx > rx) {
				if (va == null || va.y < yt) {
					va = this.createVertex((yt-fb)/fm, yt);
					}
				else if (va.y >= yb) {
					return false;
					}
				vb = this.createVertex((yb-fb)/fm, yb);
				}
			// upward
			else {
				if (va == null || va.y > yb) {
					va = this.createVertex((yb-fb)/fm, yb);
					}
				else if (va.y < yt) {
					return false;
					}
				vb = this.createVertex((yt-fb)/fm, yt);
				}
			}
		// closer to horizontal than vertical, connect start point to the
		// left or right side of the bounding box
		else {
			// rightward
			if (ly < ry) {
				if (va == null || va.x < xl) {
					va = this.createVertex(xl, fm*xl+fb);
					}
				else if (va.x >= xr) {
					return false;
					}
				vb = this.createVertex(xr, fm*xr+fb);
				}
			// leftward
			else {
				if (va == null || va.x > xr) {
					va = this.createVertex(xr, fm*xr+fb);
					}
				else if (va.x < xl) {
					return false;
					}
				vb = this.createVertex(xl, fm*xl+fb);
				}
			}
		edge.va = va;
		edge.vb = vb;
		return true;
	}

	// line-clipping code taken from:
	//   Liang-Barsky function by Daniel White
	//   http://www.skytopia.com/project/articles/compsci/clipping.html
	// Thanks!
	// A bit modified to minimize code paths
	function clipEdge(edge:Edge, bbox:Bounds) {
		var ax = edge.va.x,
			ay = edge.va.y,
			bx = edge.vb.x,
			by = edge.vb.y,
			t0 = 0.,
			t1 = 1.,
			dx = bx-ax,
			dy = by-ay;
		// left
		var q = ax-bbox.xMin;
		if (dx==0 && q<0) {return false;}
		var r = -q/dx;
		if (dx<0) {
			if (r<t0) {return false;}
			if (r<t1) {t1=r;}
			}
		else if (dx>0) {
			if (r>t1) {return false;}
			if (r>t0) {t0=r;}
			}
		// right
		q = bbox.xMax-ax;
		if (dx==0 && q<0) {return false;}
		r = q/dx;
		if (dx<0) {
			if (r>t1) {return false;}
			if (r>t0) {t0=r;}
			}
		else if (dx>0) {
			if (r<t0) {return false;}
			if (r<t1) {t1=r;}
			}
		// top
		q = ay-bbox.yMin;
		if (dy==0 && q<0) {return false;}
		r = -q/dy;
		if (dy<0) {
			if (r<t0) {return false;}
			if (r<t1) {t1=r;}
			}
		else if (dy>0) {
			if (r>t1) {return false;}
			if (r>t0) {t0=r;}
			}
		// bottom
		q = bbox.yMax-ay;
		if (dy==0 && q<0) {return false;}
		r = q/dy;
		if (dy<0) {
			if (r>t1) {return false;}
			if (r>t0) {t0=r;}
			}
		else if (dy>0) {
			if (r<t0) {return false;}
			if (r<t1) {t1=r;}
			}

		// if we reach this point, Voronoi edge is within bbox

		// if t0 > 0, va needs to change
		// rhill 2011-06-03: we need to create a new vertex rather
		// than modifying the existing one, since the existing
		// one is likely shared with at least another edge
		if (t0 > 0) {
			edge.va = this.createVertex(ax+t0*dx, ay+t0*dy);
			}

		// if t1 < 1, vb needs to change
		// rhill 2011-06-03: we need to create a new vertex rather
		// than modifying the existing one, since the existing
		// one is likely shared with at least another edge
		if (t1 < 1) {
			edge.vb = this.createVertex(ax+t1*dx, ay+t1*dy);
			}

		// va and/or vb were clipped, thus we will need to close
		// cells which use this edge.
		if ( t0 > 0 || t1 < 1 ) {
			pointCell.get(edge.lPoint).closeMe = true;
			pointCell.get(edge.rPoint).closeMe = true;
		}

		return true;
	}

	// Connect/cut edges at bounding box
	function clipEdges(bbox:Bounds) {
		// connect all dangling edges to bounding box
		// or get rid of them if it can't be done
		var edges = this.edges,
			iEdge = edges.length,
			edge;

		// iterate backward so we can splice safely
		while (iEdge-- != 0) {
			edge = edges[iEdge];
			// edge is removed if:
			//   it is wholly outside the bounding box
			//   it is actually a point rather than a line
			if (!this.connectEdge(edge, bbox) || !this.clipEdge(edge, bbox) || (abs(edge.va.x-edge.vb.x)<epsilon && abs(edge.va.y-edge.vb.y)<epsilon)) {
				edge.va = edge.vb = null;
				edges.splice(iEdge,1);
			}
		}
	}

	// Close the cells.
	// The cells are bound by the supplied bounding box.
	// Each cell refers to its associated point, and a list
	// of halfedges ordered counterclockwise.
	function closeCells(bbox:Bounds) {
		// prune, order halfedges, then add missing ones
		// required to close cells
		var xl = bbox.xMin,
			xr = bbox.xMax,
			yt = bbox.yMin,
			yb = bbox.yMax,
			cells = this.cells,
			iCell = cells.length,
			cell,
			iLeft,
			halfedges, nHalfedges,
			edge,
			lastBorderSegment,
			va, vb, vz = null;

		while (iCell-- != 0) {
			cell = cells[iCell];
			// trim non fully-defined halfedges and sort them counterclockwise
			if (cell.prepare() == 0) continue;
			if (!cell.closeMe) continue;

			// close open cells
			// step 1: find first 'unclosed' point, if any.
			// an 'unclosed' point will be the end point of a halfedge which
			// does not match the start point of the following halfedge
			halfedges = cell.halfedges;
			nHalfedges = halfedges.length;
			// special case: only one point, in which case, the viewport is the cell
			// ...

			// all other cases
			iLeft = 0;
			while (iLeft < nHalfedges) {
				va = halfedges[iLeft].getEndpoint();
				vz = halfedges[(iLeft+1) % nHalfedges].getStartpoint();
				// if end point is not equal to start point, we need to add the missing
				// halfedge(s) to close the cell
				if (abs(va.x-vz.x)>=epsilon || abs(va.y-vz.y)>=epsilon) {
					// rhill 2013-12-02:
					// "Holes" in the halfedges are not necessarily always adjacent.
					// https://github.com/gorhill/Javascript-Voronoi/issues/16

					// find entry point:
					do {

						// walk downward along left side
						if (this.equalWithepsilon(va.x,xl) && this.lessThanWithepsilon(va.y,yb)) {
							lastBorderSegment = this.equalWithepsilon(vz.x,xl);
							vb = this.createVertex(xl, lastBorderSegment ? vz.y : yb);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through
						} 

						if (this.equalWithepsilon(va.y,yb) && this.lessThanWithepsilon(va.x,xr)) {
							lastBorderSegment = this.equalWithepsilon(vz.y,yb);
							vb = this.createVertex(lastBorderSegment ? vz.x : xr, yb);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through
						} 

						if (this.equalWithepsilon(va.x,xr) && this.greaterThanWithepsilon(va.y,yt)) {
							lastBorderSegment = this.equalWithepsilon(vz.x,xr);
							vb = this.createVertex(xr, lastBorderSegment ? vz.y : yt);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through
						} 

						if (this.equalWithepsilon(va.y,yt) && this.greaterThanWithepsilon(va.x,xl)) {
							lastBorderSegment = this.equalWithepsilon(vz.y,yt);
							vb = this.createVertex(lastBorderSegment ? vz.x : xl, yt);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through

							// walk downward along left side
							lastBorderSegment = this.equalWithepsilon(vz.x,xl);
							vb = this.createVertex(xl, lastBorderSegment ? vz.y : yb);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through

							// walk rightward along bottom side
							lastBorderSegment = this.equalWithepsilon(vz.y,yb);
							vb = this.createVertex(lastBorderSegment ? vz.x : xr, yb);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							va = vb;
							// fall through

							// walk upward along right side
							lastBorderSegment = this.equalWithepsilon(vz.x,xr);
							vb = this.createVertex(xr, lastBorderSegment ? vz.y : yt);
							edge = this.createBorderEdge(cell.point, va, vb);
							iLeft++;
							halfedges.insert(iLeft, new Halfedge(edge, cell.point, null));
							nHalfedges++;
							if ( lastBorderSegment ) { break; }
							// fall through
						}
						throw "Voronoi.closeCells() > this makes no sense!";
					} while (false);
				}
				iLeft++;
			}
			cell.closeMe = false;
		}
	}

	// ---------------------------------------------------------------------------
	// Top-level Fortune loop

	static function sortByXY(a:Point, b:Point) {
		var r = b.y - a.y;
		return r < 0 ? -1 : (r > 0 ? 1 : (b.x > a.x ? 1 : b.x < a.x ? -1 : 0));
	}

	// rhill 2011-05-19:
	//   Voronoi points are kept client-side now, to allow
	//   user to freely modify content. At compute time,
	//   *references* to points are copied locally.
	/**
		Compute the Voronoi diagram based on given list of points and bounding box.
	**/
	public function compute(points:Array<Point>, bbox:Bounds) {
		// to measure execution time
		var startTime = haxe.Timer.stamp();

		// init internal state
		this.reset();

		// Initialize point event queue
		var pointEvents = points.slice(0);
		pointEvents.sort(sortByXY);

		// process queue
		var point = pointEvents.pop(),
			pointid = 0,
			xpointx = Math.NEGATIVE_INFINITY, // to avoid duplicate points
			xpointy = Math.NEGATIVE_INFINITY,
			cells = this.cells,
			circle;

		// main loop
		while( true ) {
			// we need to figure whether we handle a point or circle event
			// for this we find out if there is a point event and it is
			// 'earlier' than the circle event
			circle = this.firstCircleEvent;

			// add beach section
			if (point != null && (circle == null || point.y < circle.y || (point.y == circle.y && point.x < circle.x))) {
				// only if point is not a duplicate
				if (point.x != xpointx || point.y != xpointy) {
					// first create cell for new point
					var c = new Cell(pointid, point);
					cells[pointid] = c;
					pointCell.set(point, c);
					pointid++;
					// then create a beachsection for that point
					this.addBeachsection(point);
					// remember last point coords to detect duplicate
					xpointy = point.y;
					xpointx = point.x;
					}
				point = pointEvents.pop();
				}

			// remove beach section
			else if (circle != null) {
				this.removeBeachsection(circle.arc);
				}

			// all done, quit
			else
				break;

		}

		// wrapping-up:
		//   connect dangling edges to bounding box
		//   cut edges as per bounding box
		//   discard edges completely outside bounding box
		//   discard edges which are point-like
		this.clipEdges(bbox);

		//   add missing edges in order to close opened cells
		this.closeCells(bbox);

		var eid = 0;
		for( e in edges ) {
			e.id = eid++;
			e.lCell = e.lPoint == null ? null : pointCell.get(e.lPoint);
			e.rCell = e.rPoint == null ? null : pointCell.get(e.rPoint);
		}

		// to measure execution time
		var stopTime = haxe.Timer.stamp();

		// prepare return values
		var diagram = new Diagram();
		diagram.cells = this.cells;
		diagram.edges = this.edges;
		diagram.points = this.vertices;
		diagram.execTime = stopTime - startTime;

		// clean up
		this.reset();

		return diagram;
	}

}
