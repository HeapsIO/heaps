package h2d.col;

/**
	The resulting triangle of a Delaunay triangulation operation.
	@see `Delaunay.triangulate`
**/
class DelaunayTriangle  {
	/** First vertex of the triangle. **/
	public var p1:Point;
	/** Second vertex of the triangle. **/
	public var p2:Point;
	/** Third vertex of the triangle. **/
	public var p3:Point;
	/** Create a new Delaunay result triangle. **/
	public function new(p1,p2,p3) {
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
	}
}

private class DelaunayEdge  {
	public var p1:Point;
	public var p2:Point;
	public function new(p1, p2) {
		this.p1 = p1;
		this.p2 = p2;
	}
	public inline function equals(e:DelaunayEdge) {
		return (p1 == e.p1 && p2 == e.p2) || (p1 == e.p2 && p2 == e.p1);
	}
}

/**
	A Delaunay triangulation utility. See `Delaunay.triangulate`.
**/
class Delaunay {
	/**
		Performs a Delaunay triangulation on a given set of Points and returns a list of calculated triangles.
		See here for more information: https://en.wikipedia.org/wiki/Delaunay_triangulation
	**/
	public static function triangulate( points:Array<Point> ) : Array<DelaunayTriangle> {

		//those will be used quite everywhere so I am storing them here not to declare them x times
		var i;
		var j;
		var nv = points.length;

		if( nv < 3 ) return null;

		var trimax = 4 * nv;

		// Find the maximum and minimum vertex bounds.
		// This is to allow calculation of the bounding supertriangle

		var xmin = points[0].x;
		var ymin = points[0].y;
		var xmax = xmin;
		var ymax = ymin;

		for( pt in points ) {
			if (pt.x < xmin) xmin = pt.x;
			if (pt.x > xmax) xmax = pt.x;
			if (pt.y < ymin) ymin = pt.y;
			if (pt.y > ymax) ymax = pt.y;
		}

		var dx = xmax - xmin;
		var dy = ymax - ymin;
		var dmax = (dx > dy) ? dx : dy;

		var xmid = (xmax + xmin) * 0.5;
		var ymid = (ymax + ymin) * 0.5;


		// Set up the supertriangle
		// This is a triangle which encompasses all the sample points.
		// The supertriangle coordinates are added to the end of the
		// vertex list. The supertriangle is the first triangle in
		// the triangle list.


		var p0 = new Point( xmid - 2 * dmax, ymid - dmax );
		var p1 = new Point( xmid, ymid + 2 * dmax );
		var p2 = new Point(xmid + 2 * dmax, ymid - dmax);
		points.push(p0);
		points.push(p1);
		points.push(p2);

		var triangles = [];
		triangles.push( new DelaunayTriangle( points[ nv ], points[ nv + 1 ], points[ nv + 2 ] ) ); //SuperTriangle placed at index 0

		// Include each point one at a time into the existing mesh
		for( i in 0...nv ) {

			var DelaunayEdges = [];

			// Set up the DelaunayEdge buffer.
			// If the point (vertex(i).x,vertex(i).y) lies inside the circumcircle then the
			// three DelaunayEdges of that triangle are added to the DelaunayEdge buffer and the triangle is removed from list.
			var j = -1;
			while( ++j < triangles.length ) {
				if ( InCircle( points[i], triangles[j].p1, triangles[j].p2, triangles[j].p3 ) ) {
					DelaunayEdges.push(new DelaunayEdge(triangles[j].p1, triangles[j].p2) );
					DelaunayEdges.push(new DelaunayEdge(triangles[j].p2, triangles[j].p3) );
					DelaunayEdges.push(new DelaunayEdge(triangles[j].p3, triangles[j].p1) );
					triangles.splice( j,1 );
					j--;
				}
			}

			if( i >= nv ) continue; //In case we the last duplicate point we removed was the last in the array



			// Remove duplicate DelaunayEdges
			// Note: if all triangles are specified anticlockwise then all
			// interior DelaunayEdges are opposite pointing in direction.

			var j = DelaunayEdges.length - 2;
			while( j >= 0 ) {
				var k = DelaunayEdges.length;
				while( --k >= j + 1 ) {
					if ( DelaunayEdges[ j ].equals( DelaunayEdges[ k ] ) )
					{
						DelaunayEdges.splice( k, 1 );
						DelaunayEdges.splice( j, 1 );
						k--;
					}
				}
				j--;
			}

			// Form new triangles for the current point
			// Skipping over any tagged DelaunayEdges.
			// All DelaunayEdges are arranged in clockwise order.
			j = -1;
			while( ++j < DelaunayEdges.length ) {
				if (triangles.length >= trimax )
					return null;
				triangles.push( new DelaunayTriangle( DelaunayEdges[ j ].p1, DelaunayEdges[ j ].p2, points[ i ] ));
			}

			DelaunayEdges = null;

		}

		// Remove triangles with supertriangle vertices
		// These are triangles which have a vertex number greater than nv

		i = triangles.length - 1;
		inline function isOut(p) {
			return p == p0 || p == p1 || p == p2;
		}
		while( i >= 0 ) {
			if ( isOut(triangles[ i ].p1) || isOut(triangles[ i ].p2) || isOut(triangles[ i ].p3) )
			{
				triangles.splice(i, 1);
			}
			i--;
		}

		//Remove SuperTriangle vertices
		points.pop();
		points.pop();
		points.pop();
		return triangles;
	}


	static inline var Epsilon = 1e-10;

	static inline function fabs(a:Float) {
		return a < 0 ? -a : a;
	}

	static inline function InCircle( p:Point, p1:Point, p2:Point, p3:Point ){
		if( fabs( p1.y - p2.y ) < Epsilon && fabs( p2.y - p3.y) < Epsilon )
			return false;
		else {
			var m1;
			var m2;

			var mx1;
			var mx2;

			var my1;
			var my2;

			var xc;
			var yc;

			if ( fabs(p2.y - p1.y) < Epsilon) {
				m2 = -(p3.x - p2.x) / (p3.y - p2.y);
				mx2 = (p2.x + p3.x) * 0.5;
				my2 = (p2.y + p3.y) * 0.5;
				//Calculate CircumCircle center (xc,yc)
				xc = (p2.x + p1.x) * 0.5;
				yc = m2 * (xc - mx2) + my2;
			} else if ( fabs(p3.y - p2.y) < Epsilon ) {
				m1 = -(p2.x - p1.x) / (p2.y - p1.y);
				mx1 = (p1.x + p2.x) * 0.5;
				my1 = (p1.y + p2.y) * 0.5;
				//Calculate CircumCircle center (xc,yc)
				xc = (p3.x + p2.x) * 0.5;
				yc = m1 * (xc - mx1) + my1;
			} else {
				m1 = -(p2.x - p1.x) / (p2.y - p1.y);
				m2 = -(p3.x - p2.x) / (p3.y - p2.y);
				mx1 = (p1.x + p2.x) * 0.5;
				mx2 = (p2.x + p3.x) * 0.5;
				my1 = (p1.y + p2.y) * 0.5;
				my2 = (p2.y + p3.y) * 0.5;
				//Calculate CircumCircle center (xc,yc)
				xc = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
				yc = m1 * (xc - mx1) + my1;
			}
			var dx = p2.x - xc;
			var dy = p2.y - yc;
			var rsqr = dx * dx + dy * dy;
			dx = p.x - xc;
			dy = p.y - yc;
			var drsqr = dx * dx + dy * dy;
			return drsqr <= rsqr;
		}
	}

}

