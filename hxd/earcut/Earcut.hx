package hxd.earcut;

class EarNode {
	public var next : EarNode;
	public var prev : EarNode;
	public var nextZ : EarNode;
	public var prevZ : EarNode;
	public var allocNext : EarNode;
	public var x : Float;
	public var y : Float;
	public var i : Int;
	public var z : Int;
	public var steiner : Bool;
	public function new() {
	}
}

/**
	Ported from https://github.com/mapbox/earcut by @ncannasse
**/
class Earcut {

	var triangles : Array<Int>;
	var cache : EarNode;
	var allocated : EarNode;
	var minX : Float;
	var minY : Float;
	var size : Float;
	var hasSize : Bool;

	public function new() {
	}

	@:generic public function triangulate < T: { x:Float, y:Float } > ( points : Array<T>, ?holes : Array<Int> ) : Array<Int> {

		var hasHoles = holes != null && holes.length > 0;
        var outerLen = hasHoles ? holes[0] : points.length;
		if( outerLen < 3 ) return [];

		var root = setLinkedList(points, 0, outerLen, true);
		//eliminate holes
		if(holes != null)
			root = eliminateHoles(points, holes, root);

		return triangulateNode(root, points.length > 80);
	}

	public function triangulateNode( root : EarNode, useZOrder ) {
		triangles = [];
		root = filterPoints(root);
		if( useZOrder && root != null ) {
			var maxX, maxY;
			minX = maxX = root.x;
			minY = maxY = root.y;
			var p = root.next;
			while( p != root ) {
				var x = p.x;
				var y = p.y;
				if (x < minX) minX = x;
				if (y < minY) minY = y;
				if (x > maxX) maxX = x;
				if (y > maxY) maxY = y;
				p = p.next;
			}
			// minX, minY and size are later used to transform coords into integers for z-order calculation
			size = Math.max(maxX - minX, maxY - minY);
			hasSize = true;
		} else
			hasSize = false;
		earcutLinked(root);
		var result = triangles;
		triangles = null;

		// recycle allocated into cache
		var n = allocated;
		if( cache != null ) {
			while( n != cache )
				n = n.allocNext;
			n = n.allocNext;
		}
		while( n != null ) {
			n.next = cache;
			cache = n;
			n = n.allocNext;
		}

		return result;
	}

	@:generic function setLinkedList < T: { x:Float, y:Float } > (points : Array<T>, start : Int, end : Int, clockwise : Bool) {

		// check polygon winding
		var sum = 0.;
		var j = end - 1;
		for (i in start...end) {
			sum += (points[j].x - points[i].x) * (points[i].y + points[j].y);
			j = i;
		}

		// link points into circular doubly-linked list in the specified winding order
		var node = allocNode(-1, 0, 0, null);
		var first = node;
		if (clockwise == (sum > 0)) {
			for (i in start...end) {
				var p = points[i];
				node = allocNode(i, p.x, p.y, node);
			}
		}
		else {
			var i = end - 1;
			while(i >= start) {
				var p = points[i];
				node = allocNode(i, p.x, p.y, node);
				i--;
			}
		}

		node.next = first.next;
		node.next.prev = node;
		return node;
	}

	// link every hole into the outer loop, producing a single-ring polygon without holes
	@:generic function eliminateHoles < T: { x:Float, y:Float } > (points : Array<T>, holes : Array<Int>, root : EarNode) {
		var queue = [];

		for(i in 0...holes.length) {
			var s = holes[i];
			var e = i == holes.length - 1 ? points.length : holes[i + 1];
			var node = setLinkedList(points, s, e, false);
			if (node == node.next) node.steiner = true;
			queue.push(getLeftmost(node));
		}

		queue.sort(compareX);

		// process holes from left to right
		for( q in queue) {
			eliminateHole(q, root);
			root = filterPoints(root, root.next);
		}

		return root;
	}

	// find a bridge between vertices that connects hole with an outer ring and and link it
	function eliminateHole(hole, root) {
		root = findHoleBridge(hole, root);
		if (root != null) {
			var b = splitPolygon(root, hole);
			filterPoints(b, b.next);
		}
	}

	// David Eberly's algorithm for finding a bridge between hole and outer polygon
	function findHoleBridge(hole : EarNode, root : EarNode) {
		var p = root;
		var hx = hole.x;
		var hy = hole.y;
		var qx = Math.NEGATIVE_INFINITY;
		var m = null;

		// find a segment intersected by a ray from the hole's leftmost point to the left;
		// segment's endpoint with lesser x will be potential connection point
		do {
			if (hy <= p.y && hy >= p.next.y) {
				var x = p.x + (hy - p.y) * (p.next.x - p.x) / (p.next.y - p.y);
				if (x <= hx && x > qx) {
					qx = x;
					m = p.x < p.next.x ? p : p.next;
				}
			}
			p = p.next;
		} while (p != root);

		if (m == null) return null;

		// look for points inside the triangle of hole point, segment intersection and endpoint;
		// if there are no points found, we have a valid connection;
		// otherwise choose the point of the minimum angle with the ray as connection point
		var stop = m;
		var tanMin = Math.POSITIVE_INFINITY;
		var tan;

		p = m.next;
		while (p != stop) {
			if (hx >= p.x && p.x >= m.x && pointInTriangle(hy < m.y ? hx : qx, hy, m.x, m.y, hy < m.y ? qx : hx, hy, p.x, p.y)) {
				tan = Math.abs(hy - p.y) / (hx - p.x); // tangential
				if ((tan < tanMin || (tan == tanMin && p.x > m.x)) && locallyInside(p, hole)) {
					m = p;
					tanMin = tan;
				}
			}
			p = p.next;
		}

		return m;
	}

	// find the leftmost node of a polygon ring
	function getLeftmost(node : EarNode) {
		var p = node, leftmost = node;
		do {
			if (p.x < leftmost.x) leftmost = p;
			p = p.next;
		} while (p != node);

		return leftmost;
	}


	inline function compareX(a : EarNode, b : EarNode) {
		return a.x - b.x > 0 ? 1 : -1;
	}

	inline function equals(p1:EarNode, p2:EarNode) {
		return p1.x == p2.x && p1.y == p2.y;
	}

	inline function area(p:EarNode, q:EarNode, r:EarNode) {
		return (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
	}

	inline function intersects(p1, q1, p2, q2) {
		return (area(p1, q1, p2) > 0) != (area(p1, q1, q2) > 0) && (area(p2, q2, p1) > 0) != (area(p2, q2, q1) > 0);
	}

	// check if a polygon diagonal is locally inside the polygon
	inline function locallyInside(a:EarNode, b:EarNode) {
		return area(a.prev, a, a.next) < 0 ?
			area(a, b, a.next) >= 0 && area(a, a.prev, b) >= 0 :
			area(a, b, a.prev) < 0 || area(a, a.next, b) < 0;
	}

	function filterPoints(start:EarNode, end:EarNode=null) {
		if( start == null ) return start;
		if( end == null ) end = start;
		var p = start, again;
		do {
			again = false;
			if( !p.steiner && (equals(p, p.next) || area(p.prev, p, p.next) == 0) ) {
				removeNode(p);
				p = end = p.prev;
				if (p == p.next) return null;
				again = true;
			} else {
				p = p.next;
			}
		} while (again || p != end);
		return end;
	}

	inline function removeNode(p:EarNode) {
		p.next.prev = p.prev;
		p.prev.next = p.next;
		if (p.prevZ != null) p.prevZ.nextZ = p.nextZ;
		if (p.nextZ != null) p.nextZ.prevZ = p.prevZ;
	}

	inline function allocNode(i, x, y, last=null) {
		var n = cache;
		if( n == null ) {
			n = new EarNode();
			n.allocNext = allocated;
			allocated = n;
		} else
			cache = n.next;
		n.i = i;
		n.z = -1;
		n.x = x;
		n.y = y;
		n.next = null;
		n.prev = last;
		n.steiner = false;
		n.prevZ = null;
		n.nextZ = null;
		if( last != null )
			last.next = n;
		return n;
	}

	function earcutLinked(ear:EarNode, pass = 0) {
		if ( ear == null ) return;

		// interlink polygon nodes in z-order
		if( pass == 0 && hasSize ) indexCurve(ear);

		var stop = ear,
			prev, next;

		// iterate through ears, slicing them one by one
		while (ear.prev != ear.next) {
			prev = ear.prev;
			next = ear.next;

			if ( hasSize ? isEarHashed(ear) : isEar(ear)) {
				// cut off the triangle
				triangles.push(prev.i);
				triangles.push(ear.i);
				triangles.push(next.i);

				removeNode(ear);

				// skipping the next vertice leads to less sliver triangles
				ear = next.next;
				stop = next.next;

				continue;
			}

			ear = next;

			// if we looped through the whole remaining polygon and can't find any more ears
			if (ear == stop) {
				// try filtering points and slicing again
				switch( pass ) {
				case 0:
					earcutLinked(filterPoints(ear), 1);
				// if this didn't work, try curing all small self-intersections locally
				case 1:
					ear = cureLocalIntersections(ear);
					earcutLinked(ear, 2);
				// as a last resort, try splitting the remaining polygon into two
				case 2:
					splitEarcut(ear);
				}
				break;
			}
		}
	}

	// check whether a polygon node forms a valid ear with adjacent nodes
	function isEar(ear:EarNode) {
		var a = ear.prev,
			b = ear,
			c = ear.next;

		if (area(a, b, c) >= 0) return false; // reflex, can't be an ear

		// now make sure we don't have other points inside the potential ear
		var p = ear.next.next;

		while (p != ear.prev) {
			if (pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y) &&
				area(p.prev, p, p.next) >= 0) return false;
			p = p.next;
		}

		return true;
	}

	function isEarHashed(ear:EarNode) {
		var a = ear.prev,
			b = ear,
			c = ear.next;

		if (area(a, b, c) >= 0) return false; // reflex, can't be an ear

		// triangle bbox; min & max are calculated like this for speed
		var minTX = a.x < b.x ? (a.x < c.x ? a.x : c.x) : (b.x < c.x ? b.x : c.x),
			minTY = a.y < b.y ? (a.y < c.y ? a.y : c.y) : (b.y < c.y ? b.y : c.y),
			maxTX = a.x > b.x ? (a.x > c.x ? a.x : c.x) : (b.x > c.x ? b.x : c.x),
			maxTY = a.y > b.y ? (a.y > c.y ? a.y : c.y) : (b.y > c.y ? b.y : c.y);

		// z-order range for the current triangle bbox;
		var minZ = zOrder(minTX, minTY),
			maxZ = zOrder(maxTX, maxTY);

		// first look for points inside the triangle in increasing z-order
		var p = ear.nextZ;

		while (p != null && p.z <= maxZ) {
			if (p != ear.prev && p != ear.next &&
				pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y) &&
				area(p.prev, p, p.next) >= 0) return false;
			p = p.nextZ;
		}

		// then look for points in decreasing z-order
		p = ear.prevZ;

		while (p != null && p.z >= minZ) {
			if (p != ear.prev && p != ear.next &&
				pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y) &&
				area(p.prev, p, p.next) >= 0) return false;
			p = p.prevZ;
		}

		return true;
	}

	// go through all polygon nodes and cure small local self-intersections
	function cureLocalIntersections(start:EarNode) {
		var p = start;
		do {
			var a = p.prev,
				b = p.next.next;

			// a self-intersection where edge (v[i-1],v[i]) intersects (v[i+1],v[i+2])
			if (intersects(a, p, p.next, b) && locallyInside(a, b) && locallyInside(b, a)) {

				triangles.push(a.i);
				triangles.push(p.i);
				triangles.push(b.i);

				// remove two nodes involved
				removeNode(p);
				removeNode(p.next);

				p = start = b;
			}
			p = p.next;
		} while (p != start);

		return p;
	}

	// try splitting polygon into two and triangulate them independently
	function splitEarcut(start:EarNode) {
		// look for a valid diagonal that divides the polygon into two
		var a = start;
		do {
			var b = a.next.next;
			while (b != a.prev) {
				if (a.i != b.i && isValidDiagonal(a, b)) {
					// split the polygon in two by the diagonal
					var c = splitPolygon(a, b);

					// filter colinear points around the cuts
					a = filterPoints(a, a.next);
					c = filterPoints(c, c.next);

					// run earcut on each half
					earcutLinked(a);
					earcutLinked(c);
					return;
				}
				b = b.next;
			}
			a = a.next;
		} while (a != start);
	}

	// link two polygon vertices with a bridge; if the vertices belong to the same ring, it splits polygon into two;
	// if one belongs to the outer ring and another to a hole, it merges it into a single ring
	function splitPolygon(a : EarNode, b : EarNode) {
		var a2 = allocNode(a.i, a.x, a.y),
			b2 = allocNode(b.i, b.x, b.y),
			an = a.next,
			bp = b.prev;

		a.next = b;
		b.prev = a;

		a2.next = an;
		an.prev = a2;

		b2.next = a2;
		a2.prev = b2;

		bp.next = b2;
		b2.prev = bp;

		return b2;
	}

	inline function pointInTriangle(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, px:Float, py:Float) {
		return (cx - px) * (ay - py) - (ax - px) * (cy - py) >= 0 &&
			   (ax - px) * (by - py) - (bx - px) * (ay - py) >= 0 &&
			   (bx - px) * (cy - py) - (cx - px) * (by - py) >= 0;
	}

	// check if a diagonal between two polygon nodes is valid (lies in polygon interior)
	function isValidDiagonal(a:EarNode, b:EarNode) {
		return equals(a, b) || a.next.i != b.i && a.prev.i != b.i && !intersectsPolygon(a, b) &&
			   locallyInside(a, b) && locallyInside(b, a) && middleInside(a, b);
	}

	// check if the middle point of a polygon diagonal is inside the polygon
	function middleInside(a:EarNode, b:EarNode) {
		var p = a,
			inside = false,
			px = (a.x + b.x) / 2,
			py = (a.y + b.y) / 2;
		do {
			if (((p.y > py) != (p.next.y > py)) && (px < (p.next.x - p.x) * (py - p.y) / (p.next.y - p.y) + p.x))
				inside = !inside;
			p = p.next;
		} while (p != a);

		return inside;
	}

	// check if a polygon diagonal intersects any polygon segments
	function intersectsPolygon(a:EarNode, b:EarNode) {
		var p = a;
		do {
			if (p.i != a.i && p.next.i != a.i && p.i != b.i && p.next.i != b.i &&
					intersects(p, p.next, a, b)) return true;
			p = p.next;
		} while (p != a);
		return false;
	}

	inline function zOrder(px:Float, py:Float) {
		// coords are transformed into non-negative 15-bit integer range
		var x = Std.int(32767 * (px - minX) / size);
		var y = Std.int(32767 * (py - minY) / size);

		x = (x | (x << 8)) & 0x00FF00FF;
		x = (x | (x << 4)) & 0x0F0F0F0F;
		x = (x | (x << 2)) & 0x33333333;
		x = (x | (x << 1)) & 0x55555555;

		y = (y | (y << 8)) & 0x00FF00FF;
		y = (y | (y << 4)) & 0x0F0F0F0F;
		y = (y | (y << 2)) & 0x33333333;
		y = (y | (y << 1)) & 0x55555555;

		return x | (y << 1);
	}

	function indexCurve( start : EarNode ) {
		var p = start;
		do {
			if( p.z < 0 ) p.z = zOrder(p.x, p.y);
			p.prevZ = p.prev;
			p.nextZ = p.next;
			p = p.next;
		} while (p != start);

		p.prevZ.nextZ = null;
		p.prevZ = null;

		sortLinked(p);
	}

	function sortLinked(list:EarNode) {
		var p : EarNode, q : EarNode, e : EarNode, tail : EarNode, numMerges, pSize, qSize,
			inSize = 1;

		do {
			p = list;
			list = null;
			tail = null;
			numMerges = 0;

			while (p != null) {
				numMerges++;
				q = p;
				pSize = 0;
				for( i in 0...inSize ) {
					pSize++;
					q = q.nextZ;
					if (q == null) break;
				}

				qSize = inSize;

				while (pSize > 0 || (qSize > 0 && q != null)) {

					if (pSize == 0) {
						e = q;
						q = q.nextZ;
						qSize--;
					} else if (qSize == 0 || q == null) {
						e = p;
						p = p.nextZ;
						pSize--;
					} else if (p.z <= q.z) {
						e = p;
						p = p.nextZ;
						pSize--;
					} else {
						e = q;
						q = q.nextZ;
						qSize--;
					}

					if (tail != null) tail.nextZ = e;
					else list = e;

					e.prevZ = tail;
					tail = e;
				}

				p = q;
			}

			tail.nextZ = null;
			inSize *= 2;

		} while (numMerges > 1);

		return list;
	}

}