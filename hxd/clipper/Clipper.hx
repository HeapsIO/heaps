/*******************************************************************************
*																				*
* Author	:	Angus Johnson													*
* Version	 :	5.1.6															*
* Date		:	23 May 2013													 	*
* Website	 :	http://www.angusj.com											*
* Copyright :	Angus Johnson 2010-2013										 	*
*																				*
* License:																	 	*
* Use, modification & distribution is subject to Boost Software License Ver 1. 	*
* http://www.boost.org/LICENSE_1_0.txt										 	*
*																				*
* Attributions:																	*
* The code in this library is an extension of Bala Vatti's clipping algorithm: 	*
* "A generic solution to polygon clipping"									 	*
* Communications of the ACM, Vol 35, Issue 7 (July 1992) pp 56-63.			 	*
* http://portal.acm.org/citation.cfm?id=129906								 	*
*																				*
* Computer graphics and geometric modeling: implementation and algorithms		*
* By Max K. Agoston																*
* Springer; 1 edition (January 4, 2005)											*
* http://books.google.com/books?q=vatti+clipping+agoston						*
*																				*
* See also:																		*
* "Polygon Offsetting by Computing Winding Numbers"								*
* Paper no. DETC2005-85513 pp. 565-575										 	*
* ASME 2005 International Design Engineering Technical Conferences			 	*
* and Computers and Information in Engineering Conference (IDETC/CIE2005)		*
* September 24-28, 2005 , Long Beach, California, USA							*
* http://www.me.berkeley.edu/~mcmains/pubs/DAC05OffsetPolygon.pdf				*
*																				*
*******************************************************************************/
// Ported from C# by @ncannasse
//		original version uses 64 bits integer and 128 bit "bigint", we use 32 bit integer instead
// 		so valid range should be limited to [-32768,32767] in order to prevent overflow while multiplying

package hxd.clipper;

@:allow(hxd.clipper)
private class PolyNode {

	public var parent(default,null) : PolyNode;
	public var childs(default,null) : Array<PolyNode>;
	var polygon : Polygon;
	var index : Int;

	public function new() {
		polygon = new Polygon([]);
		childs = [];
	}

	private function isHoleNode() {
		var result = true;
		var node = parent;
		while( node != null ) {
			result = !result;
			node = node.parent;
		}
		return result;
	}

	public var childCount(get, never) : Int;

	inline function get_childCount() {
		return childs.length;
	}

	public var contour(get, never) : Polygon;

	inline function get_contour() {
		return polygon;
	}

	function addChild(child:PolyNode) {
		var cnt = childs.length;
		childs.push(child);
		child.parent = this;
		child.index = cnt;
	}

	public function getNext()
	{
		if (childs.length > 0)
			return childs[0];
		else
			return getNextSiblingUp();
	}

	function getNextSiblingUp()
	{
		if (parent == null)
			return null;
		else if (index == parent.childs.length - 1)
			return parent.getNextSiblingUp();
		else
			return parent.childs[index + 1];
	}

	public inline function isHole() {
		return isHoleNode();
	}

}


private class PolyTree extends PolyNode {

	public var allPolys : Array<PolyNode>;

	public function new() {
		super();
		allPolys = [];
	}

	public function toPolygons(polygons:Polygons) {
		polygons.splice(0,polygons.length);
		addRec(this, polygons);
	}

	static function addRec(polynode:PolyNode,polygons:Polygons) {
		if (polynode.contour.length > 0)
			polygons.push(polynode.contour);
		for(pn in polynode.childs)
			addRec(pn, polygons);
	}

	public function clear() {
		allPolys = [];
		childs = [];
	}

	public function getFirst() {
		if( childs.length > 0)
			return childs[0];
		return null;
    }

	public var total(get, never) : Int;

	inline function get_total() {
		return allPolys.length;
    }

}

@:generic
private class Ref<T> {
	public var val : T;
	public inline function new(?v:T) {
		val = v;
	}
}

private class EdgeSide {
	public static inline var Left = 1;
	public static inline var Right = 2;
}

private class Protects {
	public static inline var None = 0;
	public static inline var Left = 1;
	public static inline var Right = 1;
	public static inline var Both = 3;
}

private class Direction {
	public static inline var RightToLeft = 0;
	public static inline var LeftToRight = 1;
}

private class TEdge {
	public var xbot : Int;
	public var ybot : Int;
	public var xcurr : Int;
	public var ycurr : Int;
	public var xtop : Int;
	public var ytop : Int;
	public var dx : Float;
	public var deltaX : Int;
	public var deltaY : Int;
	public var polyType : PolyType;
	public var side : Int;
	public var windDelta : Int; //1 or -1 depending on winding direction
	public var windCnt : Int;
	public var windCnt2 : Int; //winding count of the opposite polytype
	public var outIdx : Int;
	public var next : TEdge;
	public var prev : TEdge;
	public var nextInLML : TEdge;
	public var nextInAEL : TEdge;
	public var prevInAEL : TEdge;
	public var nextInSEL : TEdge;
	public var prevInSEL : TEdge;
	public function new() {
	}
}

private class IntersectNode {
	public var edge1 : TEdge;
	public var edge2 : TEdge;
	public var pt : Point;
	public var next : IntersectNode;
	public function new() {
	}
}

private class LocalMinima {
	public var y : Int;
	public var leftBound : TEdge;
	public var rightBound : TEdge;
	public var next : LocalMinima;
	public function new() {
	}
}

private class Scanbeam {
	public var y : Int;
	public var next : Scanbeam;
	public function new() {
	}
}

private class OutRec {
	public var idx : Int;
	public var isHole : Bool;
	public var firstLeft : OutRec;
	public var pts : OutPt;
	public var bottomPt : OutPt;
	public var polyNode : PolyNode;
	public function new() {
	}
}

private class OutPt {
	public var idx : Int;
	public var pt : Point;
	public var next : OutPt;
	public var prev : OutPt;
	public function new() {
	}
}

private class JoinRec {
	public var pt1a : Point;
	public var pt1b : Point;
	public var poly1Idx : Int;
	public var pt2a : Point;
	public var pt2b : Point;
	public var poly2Idx : Int;
	public function new() {
	}
}

private class HorzJoinRec {
	public var edge : TEdge;
	public var savedIdx : Int;
	public function new() {
	}
}

private typedef DoublePoint = h2d.col.Point;

//------------------------------------------------------------------------------

private class PolyOffsetBuilder
{
	private var m_p : Polygons;
	private var currentPoly : Polygon;
	private var normals : Array<DoublePoint>;
	private var m_delta : Float;
	private var m_r : Float;
	private var m_rmin : Float;
	private var m_i : Int;
	private var m_j : Int;
	private var m_k : Int;
	private static inline var m_buffLength = 128;

	function OffsetPoint(jointype:JoinType,limit:Float)
	{
		switch (jointype)
		{
			case JoinType.Miter:
				{
					m_r = 1 + (normals[m_j].x * normals[m_k].x +
						normals[m_j].y * normals[m_k].y);
					if (m_r >= m_rmin) DoMiter(); else DoSquare();
				}
			case JoinType.Square: DoSquare();
			case JoinType.Round: DoRound(limit);
		}
		m_k = m_j;
	}
	//------------------------------------------------------------------------------

	public function new(pts:Polygons, solution:Polygons, isPolygon:Bool, delta:Float,jointype:JoinType, endtype:EndType, limit:Float = 0)
	{
		//precondition: solution != pts
		normals = [];

		if (delta == 0) {solution = pts; return; }
		m_p = pts;
		m_delta = delta;
		m_rmin = 0.5;

		if (jointype == JoinType.Miter)
		{
			if (limit > 2) m_rmin = 2.0 / (limit * limit);
			limit = 0.25; //just in case endtype == etRound
		}
		else
		{
			if (limit <= 0) limit = 0.25;
			else if (limit > Math.abs(delta)) limit = Math.abs(delta);
		}

		var deltaSq = delta * delta;
		solution.splice(0,solution.length);
		var m_i = -1;
		while( ++m_i < pts.length )
		{
			var len:Int = pts[m_i].length;
			if (len == 0 || (len < 3 && delta <= 0))
				continue;
			else if (len == 1)
			{
				currentPoly = new Polygon();
				currentPoly = Clipper.BuildArc(pts[m_i][0], 0, 2*Math.PI, delta, limit);
				solution.push(currentPoly);
				continue;
			}

			var forceClose = ClipperBase.PointsEqual(pts[m_i][0], pts[m_i][len - 1]);
			if (forceClose) len--;

			//build normals
			normals = [];

			for( j in 0...len-1 )
				normals.push(Clipper.GetUnitNormal(pts[m_i][j], pts[m_i][j+1]));
			if (isPolygon || forceClose)
				normals.push(Clipper.GetUnitNormal(pts[m_i][len - 1], pts[m_i][0]));
			else {
				var n = normals[len - 2];
				normals.push(new DoublePoint(n.x,n.y));
			}

			currentPoly = new Polygon();
			if (isPolygon || forceClose)
			{
				m_k = len - 1;
				m_j = 0;
				while( m_j < len ) {
					OffsetPoint(jointype, limit);
					m_j++;
				}
				solution.push(currentPoly);
				if (!isPolygon)
				{
					currentPoly = new Polygon();
					m_delta = -m_delta;
					m_k = len - 1;
					m_j = 0;
					while( m_j < len ) {
						OffsetPoint(jointype, limit);
						m_j++;
					}
					m_delta = -m_delta;
					currentPoly.reverse();
					solution.push(currentPoly);
				}
			}
			else
			{
				m_k = 0;
				m_j = 1;
				while( m_j < len - 1 ) {
					OffsetPoint(jointype, limit);
					m_j++;
				}

				var pt1;
				if (endtype == EndType.Butt)
				{
					m_j = len - 1;
					pt1 = new Point(Round(pts[m_i][m_j].x + normals[m_j].x *
						delta), Round(pts[m_i][m_j].y + normals[m_j].y * delta));
					AddPoint(pt1);
					pt1 = new Point(Round(pts[m_i][m_j].x - normals[m_j].x *
						delta), Round(pts[m_i][m_j].y - normals[m_j].y * delta));
					AddPoint(pt1);
				}
				else
				{
					m_j = len - 1;
					m_k = len - 2;
					normals[m_j].x = -normals[m_j].x;
					normals[m_j].y = -normals[m_j].y;
					if (endtype == EndType.Square) DoSquare();
					else DoRound(limit);
				}

				//re-build Normals
				var j = len - 1;
				while( j > 0 ) {
					normals[j].x = -normals[j - 1].x;
					normals[j].y = -normals[j - 1].y;
					j--;
				}
				normals[0].x = -normals[1].x;
				normals[0].y = -normals[1].y;

				m_k = len - 1;
				m_j = m_k - 1;
				while( m_j > 0 ) {
					OffsetPoint(jointype, limit);
					m_j--;
				}

				if (endtype == EndType.Butt)
				{
					pt1 = new Point(Round(pts[m_i][0].x - normals[0].x * delta),
						Round(pts[m_i][0].y - normals[0].y * delta));
					AddPoint(pt1);
					pt1 = new Point(Round(pts[m_i][0].x + normals[0].x * delta),
						Round(pts[m_i][0].y + normals[0].y * delta));
					AddPoint(pt1);
				}
				else
				{
					m_k = 1;
					if (endtype == EndType.Square) DoSquare();
					else DoRound(limit);
				}
				solution.push(currentPoly);
			}
		}

		//finally, clean up untidy corners
		var clpr:Clipper = new Clipper();
		clpr.addPolygons(solution, PolyType.Subject);
		if (delta > 0)
		{
			clpr.execute(ClipType.Union, solution, PolyFillType.Positive, PolyFillType.Positive);
		}
		else
		{
			var r:Rect = clpr.GetBounds();
			var outer:Polygon = new Polygon();

			outer.add(r.left - 10, r.bottom + 10);
			outer.add(r.right + 10, r.bottom + 10);
			outer.add(r.right + 10, r.top - 10);
			outer.add(r.left - 10, r.top - 10);

			clpr.addPolygon(outer, PolyType.Subject);
			clpr.reverseSolution = true;
			clpr.execute(ClipType.Union, solution, PolyFillType.Negative, PolyFillType.Negative);
			if (solution.length > 0) solution.shift();
		}
	}
	//------------------------------------------------------------------------------

	inline function AddPoint(pt:Point)
	{
		currentPoly.addPoint(pt);
	}
	//------------------------------------------------------------------------------

	function DoSquare()
	{
		var pt1 = new Point(Round(m_p[m_i][m_j].x + normals[m_k].x * m_delta),
			Round(m_p[m_i][m_j].y + normals[m_k].y * m_delta));
		var pt2 = new Point(Round(m_p[m_i][m_j].x + normals[m_j].x * m_delta),
			Round(m_p[m_i][m_j].y + normals[m_j].y * m_delta));
		if ((normals[m_k].x * normals[m_j].y - normals[m_j].x * normals[m_k].y) * m_delta >= 0)
		{
			var a1 = Math.atan2(normals[m_k].y, normals[m_k].x);
			var a2 = Math.atan2(-normals[m_j].y, -normals[m_j].x);
			a1 = Math.abs(a2 - a1);
			if (a1 > Math.PI) a1 = Math.PI * 2 - a1;
			var dx:Float = Math.tan((Math.PI - a1) / 4) * Math.abs(m_delta);
			pt1 = new Point(Std.int(pt1.x - normals[m_k].y * dx),
				Std.int(pt1.y + normals[m_k].x * dx));
			AddPoint(pt1);
			pt2 = new Point(Std.int(pt2.x + normals[m_j].y * dx),
				Std.int(pt2.y - normals[m_j].x * dx));
			AddPoint(pt2);
		}
		else
		{
			AddPoint(pt1);
			AddPoint(m_p[m_i][m_j]);
			AddPoint(pt2);
		}
	}
	//------------------------------------------------------------------------------


	inline function Round(v:Float) {
		return Math.round(v);
	}

	function DoMiter()
	{
		if ((normals[m_k].x * normals[m_j].y - normals[m_j].x * normals[m_k].y) * m_delta >= 0)
		{
			var q:Float = m_delta / m_r;
			AddPoint(new Point(Round(m_p[m_i][m_j].x +
				(normals[m_k].x + normals[m_j].x) * q),
				Round(m_p[m_i][m_j].y + (normals[m_k].y + normals[m_j].y) * q)));
		}
		else
		{
			var pt1 = new Point(Round(m_p[m_i][m_j].x + normals[m_k].x * m_delta),
				Round(m_p[m_i][m_j].y + normals[m_k].y * m_delta));
			var pt2 = new Point(Round(m_p[m_i][m_j].x + normals[m_j].x * m_delta),
				Round(m_p[m_i][m_j].y + normals[m_j].y * m_delta));
			AddPoint(pt1);
			AddPoint(m_p[m_i][m_j]);
			AddPoint(pt2);
		}
	}
	//------------------------------------------------------------------------------

	function DoRound(Limit:Float)
	{
		var pt1 = new Point(Round(m_p[m_i][m_j].x + normals[m_k].x * m_delta),
			Round(m_p[m_i][m_j].y + normals[m_k].y * m_delta));
		var pt2 = new Point(Round(m_p[m_i][m_j].x + normals[m_j].x * m_delta),
			Round(m_p[m_i][m_j].y + normals[m_j].y * m_delta));
		AddPoint(pt1);
		//round off reflex angles (ie > 180 deg) unless almost flat (ie < 10deg).
		//cross product normals < 0 . angle > 180 deg.
		//dot product normals == 1 . no angle
		if ((normals[m_k].x * normals[m_j].y - normals[m_j].x * normals[m_k].y) * m_delta >= 0)
		{
			if ((normals[m_j].x * normals[m_k].x + normals[m_j].y * normals[m_k].y) < 0.985)
			{
				var a1 = Math.atan2(normals[m_k].y, normals[m_k].x);
				var a2 = Math.atan2(normals[m_j].y, normals[m_j].x);
				if (m_delta > 0 && a2 < a1) a2 += Math.PI * 2;
				else if (m_delta < 0 && a2 > a1) a2 -= Math.PI * 2;
				var arc:Polygon = Clipper.BuildArc(m_p[m_i][m_j], a1, a2, m_delta, Limit);
				for ( pt in arc.points )
					AddPoint(pt);
			}
		}
		else
			AddPoint(m_p[m_i][m_j]);
		AddPoint(pt2);
	}
	//------------------------------------------------------------------------------

}

@:allow(hxd.clipper)
private class ClipperBase
{
	static inline var HORIZONTAL = -9007199254740992.; // -2^53, big enough for JS

	var m_MinimaList : LocalMinima;
	var m_CurrentLM : LocalMinima;
	var m_edges : Array<Array<TEdge>>;

	//------------------------------------------------------------------------------

	inline static function PointsEqual(pt1:Point, pt2:Point) {
		return pt1.x == pt2.x && pt1.y == pt2.y;
	}

	inline function abs(i:Int):Int {
		return i < 0 ? -i : i;
	}

	//------------------------------------------------------------------------------

	function PointIsVertex(pt:Point, pp:OutPt) {
		var pp2 = pp;
		do {
			if( ClipperBase.PointsEqual(pp2.pt, pt) ) return true;
			pp2 = pp2.next;
		} while (pp2 != pp);
		return false;
	}
	//------------------------------------------------------------------------------

	function PointOnLineSegment(pt:Point, linePt1:Point, linePt2:Point) {
		return ((pt.x == linePt1.x) && (pt.y == linePt1.y)) ||
			((pt.x == linePt2.x) && (pt.y == linePt2.y)) ||
			(((pt.x > linePt1.x) == (pt.x < linePt2.x)) &&
			((pt.y > linePt1.y) == (pt.y < linePt2.y)) &&
			((pt.x - linePt1.x) * (linePt2.y - linePt1.y) ==
			(linePt2.x - linePt1.x) * (pt.y - linePt1.y)));
	}
	//------------------------------------------------------------------------------

	function PointOnPolygon(pt:Point, pp:OutPt)
	{
		var pp2 = pp;
		while (true) {
			if (PointOnLineSegment(pt, pp2.pt, pp2.next.pt))
				return true;
			pp2 = pp2.next;
			if (pp2 == pp) break;
		}
		return false;
	}

	//------------------------------------------------------------------------------

	function PointInPolygon(pt:Point, pp:OutPt)
	{
		var pp2 = pp;
		var result = false;
		/*
		if (useFulllongRange)
		{
			do
			{
				if ((((pp2.pt.y <= pt.y) && (pt.y < pp2.prev.pt.y)) ||
					((pp2.prev.pt.y <= pt.y) && (pt.y < pp2.pt.y))) &&
					new Int128(pt.x - pp2.pt.x) <
					Int128.Int128Mul(pp2.prev.pt.x - pp2.pt.x,	pt.y - pp2.pt.y) /
					new Int128(pp2.prev.pt.y - pp2.pt.y))
					result = !result;
				pp2 = pp2.next;
			}
			while (pp2 != pp);
		}
		else
		*/
		{
			do
			{
				if ((((pp2.pt.y <= pt.y) && (pt.y < pp2.prev.pt.y)) ||
				((pp2.prev.pt.y <= pt.y) && (pt.y < pp2.pt.y))) &&
				(pt.x - pp2.pt.x < (pp2.prev.pt.x - pp2.pt.x) * (pt.y - pp2.pt.y) /
				(pp2.prev.pt.y - pp2.pt.y))) result = !result;
				pp2 = pp2.next;
			}
			while (pp2 != pp);
		}
		return result;
	}
	//------------------------------------------------------------------------------

	static inline function SlopesEqual(e1:TEdge, e2:TEdge) {
		/*
		if (useFullRange)
			return Int128.Int128Mul(e1.deltaY, e2.deltaX) ==
				Int128.Int128Mul(e1.deltaX, e2.deltaY);
		else
		*/
		return e1.deltaY * e2.deltaX == e1.deltaX * e2.deltaY;
	}
	//------------------------------------------------------------------------------

	static inline function SlopesEqual3(pt1:Point, pt2:Point,pt3:Point) {
		/*if (useFullRange)
			return Int128.Int128Mul(pt1.y - pt2.y, pt2.x - pt3.x) ==
				Int128.Int128Mul(pt1.x - pt2.x, pt2.y - pt3.y);
		else*/ return
			(pt1.y - pt2.y) * (pt2.x - pt3.x) - (pt1.x - pt2.x) * (pt2.y - pt3.y) == 0;
	}
	//------------------------------------------------------------------------------

	static inline function SlopesEqual4(pt1:Point, pt2:Point, pt3:Point, pt4:Point) {
		/*if (useFullRange)
			return Int128.Int128Mul(pt1.y - pt2.y, pt3.x - pt4.x) ==
				Int128.Int128Mul(pt1.x - pt2.x, pt3.y - pt4.y);
		else*/ return
			(pt1.y - pt2.y) * (pt3.x - pt4.x) - (pt1.x - pt2.x) * (pt3.y - pt4.y) == 0;
	}

	//------------------------------------------------------------------------------

	function new()
	{
		m_edges = [];
		m_MinimaList = null;
		m_CurrentLM = null;
	}
	//------------------------------------------------------------------------------

	//destructor - commented out since I gather this impedes the GC
	//~ClipperBase()
	//{
	//	Clear();
	//}
	//------------------------------------------------------------------------------

	public function clear()
	{
		disposeLocalMinimaList();
		/*
		for (var i:Int = 0; i < m_edges.length; ++i)
		{
			for (var j:Int = 0; j < m_edges[i].Count; ++j) m_edges[i][j] = null;
			m_edges[i] = [];
		}
		*/
		m_edges = [];
	}
	//------------------------------------------------------------------------------

	function disposeLocalMinimaList()
	{
		while( m_MinimaList != null )
		{
			var tmpLm = m_MinimaList.next;
			m_MinimaList = null;
			m_MinimaList = tmpLm;
		}
		m_CurrentLM = null;
	}
	//------------------------------------------------------------------------------

	public function addPolygons(ppg:Polygons, polyType:PolyType)
	{
		var result = false;
		for ( p in ppg)
			if (addPolygon(p, polyType)) result = true;
		return result;
	}
	//------------------------------------------------------------------------------

	public function addPolygon(pg:Polygon, polyType:PolyType)
	{
		var len = pg.length;
		if (len < 3) return false;

		var p = new Polygon();
		p.add(pg[0].x, pg[0].y);
		var j = 0;
		for( i in 1...len )
		{
			if (ClipperBase.PointsEqual(p[j], pg[i])) continue;
			else if (j > 0 && SlopesEqual3(p[j-1], p[j], pg[i]))
			{
				if (ClipperBase.PointsEqual(p[j-1], pg[i])) j--;
			} else j++;
			if (j < p.length)
				p[j] = pg[i]; else
				p.add(pg[i].x, pg[i].y);
		}
		if (j < 2) return false;

		len = j+1;
		while (len > 2)
		{
			//nb: test for point equality before testing slopes
			if (ClipperBase.PointsEqual(p[j], p[0])) j--;
			else if (ClipperBase.PointsEqual(p[0], p[1]) || SlopesEqual3(p[j], p[0], p[1]))
				p[0] = p[j--];
			else if (SlopesEqual3(p[j - 1], p[j], p[0])) j--;
			else if (SlopesEqual3(p[0], p[1], p[2]))
			{
				for ( i in 2...j+1 ) p[i - 1] = p[i];
				j--;
			}
			else break;
			len--;
		}
		if (len < 3) return false;

		//create a new edge array
		var edges = [];
		for ( i in 0...len ) edges.push(new TEdge());
		m_edges.push(edges);

		//convert vertices to a Float-linked-list of edges and initialize
		edges[0].xcurr = p[0].x;
		edges[0].ycurr = p[0].y;
		InitEdge(edges[len - 1], edges[0], edges[len - 2], p[len - 1], polyType);
		var i = len - 2;
		while( i > 0 ) {
			InitEdge(edges[i], edges[i + 1], edges[i - 1], p[i], polyType);
			i--;
		}
		InitEdge(edges[0], edges[1], edges[len-1], p[0], polyType);

		//reset xcurr & ycurr and find 'eHighest' (given the y axis coordinates
		//increase downward so the 'highest' edge will have the smallest ytop)
		var e = edges[0];
		var eHighest = e;
		do
		{
			e.xcurr = e.xbot;
			e.ycurr = e.ybot;
			if (e.ytop < eHighest.ytop) eHighest = e;
			e = e.next;
		} while ( e != edges[0]);

		//make sure eHighest is positioned so the following loop works safely
		if (eHighest.windDelta > 0) eHighest = eHighest.next;
		if (eHighest.dx == ClipperBase.HORIZONTAL) eHighest = eHighest.next;

		//finally insert each local minima
		e = eHighest;
		do {
		e = AddBoundsToLML(e);
		}
		while( e != eHighest );


		return true;
	}
	//------------------------------------------------------------------------------

	private function InitEdge(e:TEdge, eNext:TEdge,ePrev:TEdge, pt:Point, polyType:PolyType) {
		e.next = eNext;
		e.prev = ePrev;
		e.xcurr = pt.x;
		e.ycurr = pt.y;
		if (e.ycurr >= e.next.ycurr)
		{
			e.xbot = e.xcurr;
			e.ybot = e.ycurr;
			e.xtop = e.next.xcurr;
			e.ytop = e.next.ycurr;
			e.windDelta = 1;
		} else {
			e.xtop = e.xcurr;
			e.ytop = e.ycurr;
			e.xbot = e.next.xcurr;
			e.ybot = e.next.ycurr;
			e.windDelta = -1;
		}
		SetDx(e);
		e.polyType = polyType;
		e.outIdx = -1;
	}
	//------------------------------------------------------------------------------

	private function SetDx(e:TEdge)
	{
		e.deltaX = (e.xtop - e.xbot);
		e.deltaY = (e.ytop - e.ybot);
		if (e.deltaY == 0) e.dx = ClipperBase.HORIZONTAL;
		else e.dx = e.deltaX / e.deltaY;
	}
	//---------------------------------------------------------------------------

	function AddBoundsToLML(e:TEdge)
	{
		//Starting at the top of one bound we progress to the bottom where there's
		//a local minima. We then go to the top of the next bound. These two bounds
		//form the left and right (or right and left) bounds of the local minima.
		e.nextInLML = null;
		e = e.next;
		while( true )
		{
		if ( e.dx == ClipperBase.HORIZONTAL )
		{
			//nb: proceed through horizontals when approaching from their right,
			//	but break on ClipperBase.HORIZONTAL minima if approaching from their left.
			//	This ensures 'local minima' are always on the left of horizontals.
			if (e.next.ytop < e.ytop && e.next.xbot > e.prev.xbot) break;
			if (e.xtop != e.prev.xbot) SwapX(e);
			e.nextInLML = e.prev;
		}
		else if (e.ycurr == e.prev.ycurr) break;
		else e.nextInLML = e.prev;
		e = e.next;
		}

		//e and e.prev are now at a local minima
		var newLm = new LocalMinima();
		newLm.next = null;
		newLm.y = e.prev.ybot;

		if ( e.dx == ClipperBase.HORIZONTAL ) //ClipperBase.HORIZONTAL edges never start a left bound
		{
		if (e.xbot != e.prev.xbot) SwapX(e);
		newLm.leftBound = e.prev;
		newLm.rightBound = e;
		} else if (e.dx < e.prev.dx)
		{
		newLm.leftBound = e.prev;
		newLm.rightBound = e;
		} else
		{
		newLm.leftBound = e;
		newLm.rightBound = e.prev;
		}
		newLm.leftBound.side = EdgeSide.Left;
		newLm.rightBound.side = EdgeSide.Right;
		InsertLocalMinima( newLm );

		while( true )
		{
		if ( e.next.ytop == e.ytop && e.next.dx != ClipperBase.HORIZONTAL ) break;
		e.nextInLML = e.next;
		e = e.next;
		if ( e.dx == ClipperBase.HORIZONTAL && e.xbot != e.prev.xtop) SwapX(e);
		}
		return e.next;
	}
	//------------------------------------------------------------------------------

	private function InsertLocalMinima(newLm:LocalMinima)
	{
		if( m_MinimaList == null )
		{
		m_MinimaList = newLm;
		}
		else if( newLm.y >= m_MinimaList.y )
		{
		newLm.next = m_MinimaList;
		m_MinimaList = newLm;
		} else
		{
		var tmpLm = m_MinimaList;
		while( tmpLm.next != null	&& ( newLm.y < tmpLm.next.y ) )
			tmpLm = tmpLm.next;
		newLm.next = tmpLm.next;
		tmpLm.next = newLm;
		}
	}
	//------------------------------------------------------------------------------

	function PopLocalMinima() {
		if (m_CurrentLM == null) return;
		m_CurrentLM = m_CurrentLM.next;
	}
	//------------------------------------------------------------------------------

	private function SwapX(e:TEdge)
	{
		//swap ClipperBase.HORIZONTAL edges' top and bottom x's so they follow the natural
		//progression of the bounds - ie so their xbots will align with the
		//adjoining lower edge. [Helpful in the ProcessHorizontal() method.]
		e.xcurr = e.xtop;
		e.xtop = e.xbot;
		e.xbot = e.xcurr;
	}
	//------------------------------------------------------------------------------

	function Reset()
	{
		m_CurrentLM = m_MinimaList;

		//reset all edges
		var lm = m_MinimaList;
		while (lm != null)
		{
			var e = lm.leftBound;
			while (e != null)
			{
				e.xcurr = e.xbot;
				e.ycurr = e.ybot;
				e.side = EdgeSide.Left;
				e.outIdx = -1;
				e = e.nextInLML;
			}
			e = lm.rightBound;
			while (e != null)
			{
				e.xcurr = e.xbot;
				e.ycurr = e.ybot;
				e.side = EdgeSide.Right;
				e.outIdx = -1;
				e = e.nextInLML;
			}
			lm = lm.next;
		}
		return;
	}
	//------------------------------------------------------------------------------

	public function GetBounds()
	{
		var result = new Rect();
		var lm = m_MinimaList;
		if (lm == null) return result;
		result.left = lm.leftBound.xbot;
		result.top = lm.leftBound.ybot;
		result.right = lm.leftBound.xbot;
		result.bottom = lm.leftBound.ybot;
		while (lm != null)
		{
			if (lm.leftBound.ybot > result.bottom)
				result.bottom = lm.leftBound.ybot;
			var e = lm.leftBound;
			while( true )
			{
				var bottomE = e;
				while (e.nextInLML != null)
				{
					if (e.xbot < result.left) result.left = e.xbot;
					if (e.xbot > result.right) result.right = e.xbot;
					e = e.nextInLML;
				}
				if (e.xbot < result.left) result.left = e.xbot;
				if (e.xbot > result.right) result.right = e.xbot;
				if (e.xtop < result.left) result.left = e.xtop;
				if (e.xtop > result.right) result.right = e.xtop;
				if (e.ytop < result.top) result.top = e.ytop;

				if (bottomE == lm.leftBound) e = lm.rightBound;
				else break;
			}
			lm = lm.next;
		}
		return result;
	}

} //ClipperBase

@:allow(hxd.clipper)
class Clipper extends ClipperBase {

	var m_PolyOuts : Array<OutRec>;
	var m_ClipType : ClipType;
	var m_Scanbeam : Scanbeam;
	var m_ActiveEdges : TEdge;
	var m_SortedEdges : TEdge;
	var m_IntersectNodes : IntersectNode;
	var m_ExecuteLocked : Bool;
	var m_ClipFillType : PolyFillType;
	var m_SubjFillType : PolyFillType;
	var m_Joins : Array<JoinRec>;
	var m_HorizJoins : Array<HorzJoinRec>;
	var m_ReverseOutput : Bool;
	var m_UsingPolyTree : Bool;
	public var forceSimple: Bool;

	public function new()
	{
		super();
		m_Scanbeam = null;
		m_ActiveEdges = null;
		m_SortedEdges = null;
		m_IntersectNodes = null;
		m_ExecuteLocked = false;
		m_UsingPolyTree = false;
		m_PolyOuts = new Array();
		m_Joins = new Array();
		m_HorizJoins = new Array();
		m_ReverseOutput = false;
		forceSimple = false;
	}

	inline function xor(a, b) {
		return if( a ) !b else b;
	}

	//------------------------------------------------------------------------------

	public override function clear()
	{
		if (m_edges.length == 0) return; //avoids problems with ClipperBase destructor
		DisposeAllPolyPts();
		super.clear();
	}
	//------------------------------------------------------------------------------

	function DisposeScanbeamList()
	{
		while ( m_Scanbeam != null ) {
			var sb2 = m_Scanbeam.next;
			m_Scanbeam = null;
			m_Scanbeam = sb2;
		}
	}
	//------------------------------------------------------------------------------

	override function Reset()
	{
		super.Reset();
		m_Scanbeam = null;
		m_ActiveEdges = null;
		m_SortedEdges = null;
		DisposeAllPolyPts();
		var lm = m_MinimaList;
		while (lm != null)
		{
			InsertScanbeam(lm.y);
			lm = lm.next;
		}
	}

	//------------------------------------------------------------------------------

	public var reverseSolution(get, set) : Bool;

	function get_reverseSolution() {
		return m_ReverseOutput;
	}
	function set_reverseSolution(v) {
		return m_ReverseOutput = v;
	}

	//------------------------------------------------------------------------------

	private function InsertScanbeam(y:Int)
	{
		if( m_Scanbeam == null )
		{
		m_Scanbeam = new Scanbeam();
		m_Scanbeam.next = null;
		m_Scanbeam.y = y;
		}
		else if(	y > m_Scanbeam.y )
		{
		var newSb = new Scanbeam();
		newSb.y = y;
		newSb.next = m_Scanbeam;
		m_Scanbeam = newSb;
		} else
		{
		var sb2 = m_Scanbeam;
		while( sb2.next != null	&& ( y <= sb2.next.y ) ) sb2 = sb2.next;
		if(	y == sb2.y ) return; //ie ignores duplicates
		var newSb = new Scanbeam();
		newSb.y = y;
		newSb.next = sb2.next;
		sb2.next = newSb;
		}
	}
	//------------------------------------------------------------------------------

	public function execute(clipType:ClipType,solution:Polygons,?subjFillType,?clipFillType) : Bool
	{
		if( subjFillType == null ) subjFillType = PolyFillType.EvenOdd;
		if( clipFillType == null ) clipFillType = PolyFillType.EvenOdd;
		if (m_ExecuteLocked) return false;
		m_ExecuteLocked = true;
		solution.splice(0,solution.length);
		m_SubjFillType = subjFillType;
		m_ClipFillType = clipFillType;
		m_ClipType = clipType;
		m_UsingPolyTree = false;
		var succeeded = ExecuteInternal();
		//build the return polygons
		if (succeeded) BuildResult(solution);
		m_ExecuteLocked = false;
		return succeeded;
	}
	//------------------------------------------------------------------------------

	public function ExecuteTree(clipType:ClipType, polytree:PolyTree, ?subjFillType, ?clipFillType ) {
		if( subjFillType == null ) subjFillType = PolyFillType.EvenOdd;
		if( clipFillType == null ) clipFillType = PolyFillType.EvenOdd;
		if (m_ExecuteLocked) return false;
		m_ExecuteLocked = true;
		m_SubjFillType = subjFillType;
		m_ClipFillType = clipFillType;
		m_ClipType = clipType;
		m_UsingPolyTree = true;
		var succeeded = ExecuteInternal();
		//build the return polygons
		if (succeeded) BuildResult2(polytree);
		m_ExecuteLocked = false;
		return succeeded;
	}

	//------------------------------------------------------------------------------

	function FixHoleLinkage(outRec:OutRec) {
		//skip if an outermost polygon or
		//already already points to the correct firstLeft
		if (outRec.firstLeft == null ||
				(outRec.isHole != outRec.firstLeft.isHole &&
				outRec.firstLeft.pts != null)) return;

		var orfl:OutRec = outRec.firstLeft;
		while (orfl != null && ((orfl.isHole == outRec.isHole) || orfl.pts == null))
			orfl = orfl.firstLeft;
		outRec.firstLeft = orfl;
	}
	//------------------------------------------------------------------------------

	private function ExecuteInternal() : Bool
	{
		var succeeded;
//		try
		{
			Reset();
			if (m_CurrentLM == null) return true;
			var botY = PopScanbeam();
			do
			{
				InsertLocalMinimaIntoAEL(botY);
				m_HorizJoins = [];
				ProcessHorizontals();
				var topY = PopScanbeam();
				succeeded = ProcessIntersections(botY, topY);
				if (!succeeded) break;
				ProcessEdgesAtTopOfScanbeam(topY);
				botY = topY;
			} while (m_Scanbeam != null || m_CurrentLM != null);
		}
//		catch { succeeded = false; }

		if (succeeded)
		{
			//tidy up output polygons and fix orientations where necessary
			for ( outRec in m_PolyOuts)
			{
				if (outRec.pts == null) continue;
				FixupOutPolygon(outRec);
				if (outRec.pts == null) continue;
				if (xor(outRec.isHole,m_ReverseOutput) == (Area(outRec) > 0))
					ReversePolyPtLinks(outRec.pts);
			}
			JoinCommonEdges();
			if (forceSimple) DoSimplePolygons();
		}
		m_Joins = [] /*clear*/;
		m_HorizJoins = [] /*clear*/;
		return succeeded;
	}
	//------------------------------------------------------------------------------

	private function PopScanbeam() : Int
	{
		var y = m_Scanbeam.y;
		var sb2 = m_Scanbeam;
		m_Scanbeam = m_Scanbeam.next;
		sb2 = null;
		return y;
	}
	//------------------------------------------------------------------------------

	private function DisposeAllPolyPts(){
		for ( i in 0...m_PolyOuts.length ) DisposeOutRec(i);
		m_PolyOuts = [];
	}
	//------------------------------------------------------------------------------

	function DisposeOutRec(index:Int)
	{
		var outRec = m_PolyOuts[index];
		if (outRec.pts != null) DisposeOutPts(outRec.pts);
		outRec = null;
		m_PolyOuts[index] = null;
	}
	//------------------------------------------------------------------------------

	private function DisposeOutPts(pp:OutPt)
	{
		if (pp == null) return;
		var tmpPp = null;
		pp.prev.next = null;
		while (pp != null)
		{
			tmpPp = pp;
			pp = pp.next;
			tmpPp = null;
		}
	}
	//------------------------------------------------------------------------------

	private function AddJoin(e1:TEdge,e2:TEdge,e1OutIdx:Int,e2OutIdx:Int)
	{
		var jr:JoinRec = new JoinRec();
		if (e1OutIdx >= 0)
			jr.poly1Idx = e1OutIdx; else
		jr.poly1Idx = e1.outIdx;
		jr.pt1a = new Point(e1.xcurr, e1.ycurr);
		jr.pt1b = new Point(e1.xtop, e1.ytop);
		if (e2OutIdx >= 0)
			jr.poly2Idx = e2OutIdx; else
			jr.poly2Idx = e2.outIdx;
		jr.pt2a = new Point(e2.xcurr, e2.ycurr);
		jr.pt2b = new Point(e2.xtop, e2.ytop);
		m_Joins.push(jr);
	}
	//------------------------------------------------------------------------------

	private function AddHorzJoin(e:TEdge,idx:Int)
	{
		var hj:HorzJoinRec = new HorzJoinRec();
		hj.edge = e;
		hj.savedIdx = idx;
		m_HorizJoins.push(hj);
	}
	//------------------------------------------------------------------------------

	private function InsertLocalMinimaIntoAEL(botY:Int)
	{
		while(	m_CurrentLM != null	&& ( m_CurrentLM.y == botY ) )
		{
		var lb:TEdge = m_CurrentLM.leftBound;
		var rb:TEdge = m_CurrentLM.rightBound;

		InsertEdgeIntoAEL( lb );
		InsertScanbeam( lb.ytop );
		InsertEdgeIntoAEL( rb );

		if (IsEvenOddFillType(lb))
		{
			lb.windDelta = 1;
			rb.windDelta = 1;
		}
		else
		{
			rb.windDelta = -lb.windDelta;
		}
		SetWindingCount(lb);
		rb.windCnt = lb.windCnt;
		rb.windCnt2 = lb.windCnt2;

		if(	rb.dx == ClipperBase.HORIZONTAL )
		{
			//nb: only rightbounds can have a ClipperBase.HORIZONTAL bottom edge
			AddEdgeToSEL( rb );
			InsertScanbeam( rb.nextInLML.ytop );
		}
		else
			InsertScanbeam( rb.ytop );

		if( IsContributing(lb) )
			AddLocalMinPoly(lb, rb, new Point(lb.xcurr, m_CurrentLM.y));

		//if any output polygons share an edge, they'll need joining later
		if (rb.outIdx >= 0 && rb.dx == ClipperBase.HORIZONTAL)
		{
			var i = -1;
			while( ++i < m_HorizJoins.length )
			{
				var hj:HorzJoinRec = m_HorizJoins[i];
				//if horizontals rb and hj.edge overlap, flag for joining later
				if (HasOverlapSegment(new Point(hj.edge.xbot, hj.edge.ybot),
					new Point(hj.edge.xtop, hj.edge.ytop),
					new Point(rb.xbot, rb.ybot),
					new Point(rb.xtop, rb.ytop)))
					AddJoin(hj.edge, rb, hj.savedIdx, -1);
			}
		}


		if( lb.nextInAEL != rb )
		{
			if (rb.outIdx >= 0 && rb.prevInAEL.outIdx >= 0 &&
				ClipperBase.SlopesEqual(rb.prevInAEL, rb))
				AddJoin(rb, rb.prevInAEL, -1, -1);

			var e:TEdge = lb.nextInAEL;
			var pt:Point = new Point(lb.xcurr, lb.ycurr);
			while( e != rb )
			{
			if(e == null)
				throw "InsertLocalMinimaIntoAEL: missing rightbound!";
			//nb: For calculating winding counts etc, IntersectEdges() assumes
			//that param1 will be to the right of param2 ABOVE the intersection
			IntersectEdges( rb , e , pt , Protects.None); //order important here
			e = e.nextInAEL;
			}
		}
		PopLocalMinima();
		}
	}
	//------------------------------------------------------------------------------

	private function InsertEdgeIntoAEL(edge:TEdge)
	{
		edge.prevInAEL = null;
		edge.nextInAEL = null;
		if (m_ActiveEdges == null)
		{
		m_ActiveEdges = edge;
		}
		else if( E2InsertsBeforeE1(m_ActiveEdges, edge) )
		{
		edge.nextInAEL = m_ActiveEdges;
		m_ActiveEdges.prevInAEL = edge;
		m_ActiveEdges = edge;
		} else
		{
		var e:TEdge = m_ActiveEdges;
		while (e.nextInAEL != null && !E2InsertsBeforeE1(e.nextInAEL, edge))
			e = e.nextInAEL;
		edge.nextInAEL = e.nextInAEL;
		if (e.nextInAEL != null) e.nextInAEL.prevInAEL = edge;
		edge.prevInAEL = e;
		e.nextInAEL = edge;
		}
	}
	//----------------------------------------------------------------------

	private function E2InsertsBeforeE1(e1:TEdge,e2:TEdge) : Bool
	{
		if (e2.xcurr == e1.xcurr)
		{
			if (e2.ytop > e1.ytop)
				return e2.xtop < TopX(e1, e2.ytop);
			else return e1.xtop > TopX(e2, e1.ytop);
		}
		else return e2.xcurr < e1.xcurr;
	}
	//------------------------------------------------------------------------------

	private function IsEvenOddFillType(edge:TEdge) : Bool
	{
		if (edge.polyType == PolyType.Subject)
			return m_SubjFillType == PolyFillType.EvenOdd;
		else
			return m_ClipFillType == PolyFillType.EvenOdd;
	}
	//------------------------------------------------------------------------------

	private function IsEvenOddAltFillType(edge:TEdge) : Bool
	{
		if (edge.polyType == PolyType.Subject)
			return m_ClipFillType == PolyFillType.EvenOdd;
		else
			return m_SubjFillType == PolyFillType.EvenOdd;
	}
	//------------------------------------------------------------------------------

	private function IsContributing(edge:TEdge) : Bool
	{
		var pft, pft2;
		if (edge.polyType == PolyType.Subject)
		{
			pft = m_SubjFillType;
			pft2 = m_ClipFillType;
		}
		else
		{
			pft = m_ClipFillType;
			pft2 = m_SubjFillType;
		}

		switch (pft)
		{
			case PolyFillType.EvenOdd:
			case PolyFillType.NonZero:
				if (Math.abs(edge.windCnt) != 1) return false;
			case PolyFillType.Positive:
				if (edge.windCnt != 1) return false;
			default: //PolyFillType.Negative
				if (edge.windCnt != -1) return false;
		}

		switch (m_ClipType)
		{
			case ClipType.Intersection:
				switch (pft2)
				{
					case PolyFillType.EvenOdd:
					case PolyFillType.NonZero:
						return (edge.windCnt2 != 0);
					case PolyFillType.Positive:
						return (edge.windCnt2 > 0);
					default:
						return (edge.windCnt2 < 0);
				}
			case ClipType.Union:
				switch (pft2)
				{
					case PolyFillType.EvenOdd:
					case PolyFillType.NonZero:
						return (edge.windCnt2 == 0);
					case PolyFillType.Positive:
						return (edge.windCnt2 <= 0);
					default:
						return (edge.windCnt2 >= 0);
				}
			case ClipType.Difference:
				if (edge.polyType == PolyType.Subject)
					switch (pft2)
					{
						case PolyFillType.EvenOdd:
						case PolyFillType.NonZero:
							return (edge.windCnt2 == 0);
						case PolyFillType.Positive:
							return (edge.windCnt2 <= 0);
						default:
							return (edge.windCnt2 >= 0);
					}
				else
					switch (pft2)
					{
						case PolyFillType.EvenOdd:
						case PolyFillType.NonZero:
							return (edge.windCnt2 != 0);
						case PolyFillType.Positive:
							return (edge.windCnt2 > 0);
						default:
							return (edge.windCnt2 < 0);
					}
			case ClipType.Xor:
				// nothing
		}
		return true;
	}
	//------------------------------------------------------------------------------

	private function SetWindingCount(edge:TEdge)
	{
		var e:TEdge = edge.prevInAEL;
		//find the edge of the same polytype that immediately preceeds 'edge' in AEL
		while (e != null && e.polyType != edge.polyType)
			e = e.prevInAEL;
		if (e == null)
		{
			edge.windCnt = edge.windDelta;
			edge.windCnt2 = 0;
			e = m_ActiveEdges; //ie get ready to calc windCnt2
		}
		else if (IsEvenOddFillType(edge))
		{
			//even-odd filling
			edge.windCnt = 1;
			edge.windCnt2 = e.windCnt2;
			e = e.nextInAEL; //ie get ready to calc windCnt2
		}
		else
		{
			//nonZero filling
			if (e.windCnt * e.windDelta < 0)
			{
				if (Math.abs(e.windCnt) > 1)
				{
					if (e.windDelta * edge.windDelta < 0)
						edge.windCnt = e.windCnt;
					else
						edge.windCnt = e.windCnt + edge.windDelta;
				}
				else
					edge.windCnt = e.windCnt + e.windDelta + edge.windDelta;
			}
			else
			{
				if (Math.abs(e.windCnt) > 1 && e.windDelta * edge.windDelta < 0)
					edge.windCnt = e.windCnt;
				else if (e.windCnt + edge.windDelta == 0)
					edge.windCnt = e.windCnt;
				else
					edge.windCnt = e.windCnt + edge.windDelta;
			}
			edge.windCnt2 = e.windCnt2;
			e = e.nextInAEL; //ie get ready to calc windCnt2
		}

		//update windCnt2
		if (IsEvenOddAltFillType(edge))
		{
			//even-odd filling
			while (e != edge)
			{
				edge.windCnt2 = (edge.windCnt2 == 0) ? 1 : 0;
				e = e.nextInAEL;
			}
		}
		else
		{
			//nonZero filling
			while (e != edge)
			{
				edge.windCnt2 += e.windDelta;
				e = e.nextInAEL;
			}
		}
	}
	//------------------------------------------------------------------------------

	private function AddEdgeToSEL(edge:TEdge)
	{
		//SEL pointers in PEdge are reused to build a list of ClipperBase.HORIZONTAL edges.
		//However, we don't need to worry about order with ClipperBase.HORIZONTAL edge processing.
		if (m_SortedEdges == null)
		{
			m_SortedEdges = edge;
			edge.prevInSEL = null;
			edge.nextInSEL = null;
		}
		else
		{
			edge.nextInSEL = m_SortedEdges;
			edge.prevInSEL = null;
			m_SortedEdges.prevInSEL = edge;
			m_SortedEdges = edge;
		}
	}
	//------------------------------------------------------------------------------

	private function CopyAELToSEL()
	{
		var e:TEdge = m_ActiveEdges;
		m_SortedEdges = e;
		while (e != null)
		{
			e.prevInSEL = e.prevInAEL;
			e.nextInSEL = e.nextInAEL;
			e = e.nextInAEL;
		}
	}
	//------------------------------------------------------------------------------

	private function SwapPositionsInAEL(edge1:TEdge,edge2:TEdge)
	{
		if (edge1.nextInAEL == edge2)
		{
			var next:TEdge = edge2.nextInAEL;
			if (next != null)
				next.prevInAEL = edge1;
			var prev:TEdge = edge1.prevInAEL;
			if (prev != null)
				prev.nextInAEL = edge2;
			edge2.prevInAEL = prev;
			edge2.nextInAEL = edge1;
			edge1.prevInAEL = edge2;
			edge1.nextInAEL = next;
		}
		else if (edge2.nextInAEL == edge1)
		{
			var next:TEdge = edge1.nextInAEL;
			if (next != null)
				next.prevInAEL = edge2;
			var prev:TEdge = edge2.prevInAEL;
			if (prev != null)
				prev.nextInAEL = edge1;
			edge1.prevInAEL = prev;
			edge1.nextInAEL = edge2;
			edge2.prevInAEL = edge1;
			edge2.nextInAEL = next;
		}
		else
		{
			var next:TEdge = edge1.nextInAEL;
			var prev:TEdge = edge1.prevInAEL;
			edge1.nextInAEL = edge2.nextInAEL;
			if (edge1.nextInAEL != null)
				edge1.nextInAEL.prevInAEL = edge1;
			edge1.prevInAEL = edge2.prevInAEL;
			if (edge1.prevInAEL != null)
				edge1.prevInAEL.nextInAEL = edge1;
			edge2.nextInAEL = next;
			if (edge2.nextInAEL != null)
				edge2.nextInAEL.prevInAEL = edge2;
			edge2.prevInAEL = prev;
			if (edge2.prevInAEL != null)
				edge2.prevInAEL.nextInAEL = edge2;
		}

		if (edge1.prevInAEL == null)
			m_ActiveEdges = edge1;
		else if (edge2.prevInAEL == null)
			m_ActiveEdges = edge2;
	}
	//------------------------------------------------------------------------------

	private function SwapPositionsInSEL(edge1:TEdge,edge2:TEdge)
	{
		if (edge1.nextInSEL == null && edge1.prevInSEL == null)
			return;
		if (edge2.nextInSEL == null && edge2.prevInSEL == null)
			return;

		if (edge1.nextInSEL == edge2)
		{
			var next:TEdge = edge2.nextInSEL;
			if (next != null)
				next.prevInSEL = edge1;
			var prev:TEdge = edge1.prevInSEL;
			if (prev != null)
				prev.nextInSEL = edge2;
			edge2.prevInSEL = prev;
			edge2.nextInSEL = edge1;
			edge1.prevInSEL = edge2;
			edge1.nextInSEL = next;
		}
		else if (edge2.nextInSEL == edge1)
		{
			var next:TEdge = edge1.nextInSEL;
			if (next != null)
				next.prevInSEL = edge2;
			var prev:TEdge = edge2.prevInSEL;
			if (prev != null)
				prev.nextInSEL = edge1;
			edge1.prevInSEL = prev;
			edge1.nextInSEL = edge2;
			edge2.prevInSEL = edge1;
			edge2.nextInSEL = next;
		}
		else
		{
			var next:TEdge = edge1.nextInSEL;
			var prev:TEdge = edge1.prevInSEL;
			edge1.nextInSEL = edge2.nextInSEL;
			if (edge1.nextInSEL != null)
				edge1.nextInSEL.prevInSEL = edge1;
			edge1.prevInSEL = edge2.prevInSEL;
			if (edge1.prevInSEL != null)
				edge1.prevInSEL.nextInSEL = edge1;
			edge2.nextInSEL = next;
			if (edge2.nextInSEL != null)
				edge2.nextInSEL.prevInSEL = edge2;
			edge2.prevInSEL = prev;
			if (edge2.prevInSEL != null)
				edge2.prevInSEL.nextInSEL = edge2;
		}

		if (edge1.prevInSEL == null)
			m_SortedEdges = edge1;
		else if (edge2.prevInSEL == null)
			m_SortedEdges = edge2;
	}
	//------------------------------------------------------------------------------


	private function AddLocalMaxPoly(e1:TEdge,e2:TEdge,pt:Point)
	{
		AddOutPt(e1, pt);
		if (e1.outIdx == e2.outIdx)
		{
			e1.outIdx = -1;
			e2.outIdx = -1;
		}
		else if (e1.outIdx < e2.outIdx)
			AppendPolygon(e1, e2);
		else
			AppendPolygon(e2, e1);
	}
	//------------------------------------------------------------------------------

	private function AddLocalMinPoly(e1:TEdge,e2:TEdge,pt:Point)
	{
		var e, prevE;
		if (e2.dx == ClipperBase.HORIZONTAL || (e1.dx > e2.dx))
		{
			AddOutPt(e1, pt);
			e2.outIdx = e1.outIdx;
			e1.side = EdgeSide.Left;
			e2.side = EdgeSide.Right;
			e = e1;
			if (e.prevInAEL == e2)
				prevE = e2.prevInAEL;
			else
				prevE = e.prevInAEL;
		}
		else
		{
			AddOutPt(e2, pt);
			e1.outIdx = e2.outIdx;
			e1.side = EdgeSide.Right;
			e2.side = EdgeSide.Left;
			e = e2;
			if (e.prevInAEL == e1)
				prevE = e1.prevInAEL;
			else
				prevE = e.prevInAEL;
		}

		if (prevE != null && prevE.outIdx >= 0 &&
			(TopX(prevE, pt.y) == TopX(e, pt.y)) &&
			 ClipperBase.SlopesEqual(e, prevE))
				 AddJoin(e, prevE, -1, -1);

	}
	//------------------------------------------------------------------------------

	private function CreateOutRec() : OutRec
	{
		var result:OutRec = new OutRec();
		result.idx = -1;
		result.isHole = false;
		result.firstLeft = null;
		result.pts = null;
		result.bottomPt = null;
		result.polyNode = null;
		m_PolyOuts.push(result);
		result.idx = m_PolyOuts.length - 1;
		return result;
	}
	//------------------------------------------------------------------------------

	private function AddOutPt(e:TEdge,pt:Point)
	{
		var ToFront = (e.side == EdgeSide.Left);
		if(	e.outIdx < 0 )
		{
			var outRec = CreateOutRec();
			e.outIdx = outRec.idx;
			var op:OutPt = new OutPt();
			outRec.pts = op;
			op.pt = pt;
			op.idx = outRec.idx;
			op.next = op;
			op.prev = op;
			SetHoleState(e, outRec);
		} else
		{
			var outRec = m_PolyOuts[e.outIdx];
			var op:OutPt = outRec.pts, op2;
			if (ToFront && ClipperBase.PointsEqual(pt, op.pt) ||
				(!ToFront && ClipperBase.PointsEqual(pt, op.prev.pt))) return;

			op2 = new OutPt();
			op2.pt = pt;
			op2.idx = outRec.idx;
			op2.next = op;
			op2.prev = op.prev;
			op2.prev.next = op2;
			op.prev = op2;
			if (ToFront) outRec.pts = op2;
		}
	}
	//------------------------------------------------------------------------------
	/*
	function SwapPoints(ref Point pt1, ref Point pt2)
	{
		var tmp:Point = pt1;
		pt1 = pt2;
		pt2 = tmp;
	}
	*/
	//------------------------------------------------------------------------------

	private inline function HasOverlapSegment(pt1a:Point, pt1b:Point, pt2a:Point,pt2b:Point) : Bool {
		//precondition: segments are colinear.
		if (abs(pt1a.x - pt1b.x) > abs(pt1a.y - pt1b.y))
		{
			if (pt1a.x > pt1b.x) {
				var tmp = pt1a;
				pt1a = pt1b;
				pt1b = tmp;
			}
			if (pt2a.x > pt2b.x) {
				var tmp = pt2a;
				pt2a = pt2b;
				pt2b = tmp;
			}
			var pt1 = if (pt1a.x > pt2a.x) pt1a else pt2a;
			var pt2 = if (pt1b.x < pt2b.x) pt1b else pt2b;
			return pt1.x < pt2.x;
		} else {
			if (pt1a.y < pt1b.y) {
				var tmp = pt1a;
				pt1a = pt1b;
				pt1b = tmp;
			}
			if (pt2a.y < pt2b.y) {
				var tmp = pt2a;
				pt2a = pt2b;
				pt2b = tmp;
			}
			var pt1 = if (pt1a.y < pt2a.y) pt1a else pt2a;
			var pt2 = if (pt1b.y > pt2b.y) pt1b else pt2b;
			return pt1.y > pt2.y;
		}
	}


	private function GetOverlapSegment(pt1a:Point, pt1b:Point, pt2a:Point,pt2b:Point,pt1:Ref<Point>,pt2:Ref<Point>) : Bool {
		//precondition: segments are colinear.
		if (abs(pt1a.x - pt1b.x) > abs(pt1a.y - pt1b.y))
		{
			if (pt1a.x > pt1b.x) {
				var tmp = pt1a;
				pt1a = pt1b;
				pt1b = tmp;
			}
			if (pt2a.x > pt2b.x) {
				var tmp = pt2a;
				pt2a = pt2b;
				pt2b = tmp;
			}
			pt1.val = if (pt1a.x > pt2a.x) pt1a else pt2a;
			pt2.val = if (pt1b.x < pt2b.x) pt1b else pt2b;
			return pt1.val.x < pt2.val.x;
		} else {
			if (pt1a.y < pt1b.y) {
				var tmp = pt1a;
				pt1a = pt1b;
				pt1b = tmp;
			}
			if (pt2a.y < pt2b.y) {
				var tmp = pt2a;
				pt2a = pt2b;
				pt2b = tmp;
			}
			pt1.val = if (pt1a.y < pt2a.y) pt1a else pt2a;
			pt2.val = if (pt1b.y > pt2b.y) pt1b else pt2b;
			return pt1.val.y > pt2.val.y;
		}
	}

	//------------------------------------------------------------------------------

	private function FindSegment(pp : OutPt,  pt1 : Ref<Point>, pt2 : Ref<Point>) {
		if (pp == null) return null;
		var pp2 : OutPt = pp;
		var pt1a = pt1.val.clone();
		var pt2a = pt2.val.clone();
		do
		{
			if (ClipperBase.SlopesEqual4(pt1a, pt2a, pp.pt, pp.prev.pt) &&
				ClipperBase.SlopesEqual3(pt1a, pt2a, pp.pt) &&
				GetOverlapSegment(pt1a, pt2a, pp.pt, pp.prev.pt, pt1, pt2))
					return pp;
			pp = pp.next;
		}
		while (pp != pp2);
		return null;
	}
	//------------------------------------------------------------------------------

	function Pt3IsBetweenPt1AndPt2(pt1:Point, pt2:Point, pt3:Point)
	{
		if (ClipperBase.PointsEqual(pt1, pt3) || ClipperBase.PointsEqual(pt2, pt3)) return true;
		else if (pt1.x != pt2.x) return (pt1.x < pt3.x) == (pt3.x < pt2.x);
		else return (pt1.y < pt3.y) == (pt3.y < pt2.y);
	}
	//------------------------------------------------------------------------------

	private function InsertPolyPtBetween(p1:OutPt,p2:OutPt,pt:Point) : OutPt
	{
		var result:OutPt = new OutPt();
		result.pt = pt;
		if (p2 == p1.next)
		{
			p1.next = result;
			p2.prev = result;
			result.next = p2;
			result.prev = p1;
		} else
		{
			p2.next = result;
			p1.prev = result;
			result.next = p1;
			result.prev = p2;
		}
		return result;
	}
	//------------------------------------------------------------------------------

	private function SetHoleState(e:TEdge,outRec:OutRec)
	{
		var isHole = false;
		var e2 = e.prevInAEL;
		while (e2 != null)
		{
			if (e2.outIdx >= 0)
			{
				isHole = !isHole;
				if (outRec.firstLeft == null)
					outRec.firstLeft = m_PolyOuts[e2.outIdx];
			}
			e2 = e2.prevInAEL;
		}
		if (isHole) outRec.isHole = true;
	}
	//------------------------------------------------------------------------------

	private function GetDx(pt1:Point,pt2:Point) : Float
	{
		if (pt1.y == pt2.y) return ClipperBase.HORIZONTAL;
		else return (pt2.x - pt1.x) / (pt2.y - pt1.y);
	}
	//---------------------------------------------------------------------------

	private function FirstIsBottomPt(btmPt1:OutPt,btmPt2:OutPt) : Bool
	{
		var p:OutPt = btmPt1.prev;
		while (ClipperBase.PointsEqual(p.pt, btmPt1.pt) && (p != btmPt1)) p = p.prev;
		var dx1p = Math.abs(GetDx(btmPt1.pt, p.pt));
		p = btmPt1.next;
		while (ClipperBase.PointsEqual(p.pt, btmPt1.pt) && (p != btmPt1)) p = p.next;
		var dx1n = Math.abs(GetDx(btmPt1.pt, p.pt));

		p = btmPt2.prev;
		while (ClipperBase.PointsEqual(p.pt, btmPt2.pt) && (p != btmPt2)) p = p.prev;
		var dx2p = Math.abs(GetDx(btmPt2.pt, p.pt));
		p = btmPt2.next;
		while (ClipperBase.PointsEqual(p.pt, btmPt2.pt) && (p != btmPt2)) p = p.next;
		var dx2n = Math.abs(GetDx(btmPt2.pt, p.pt));
		return (dx1p >= dx2p && dx1p >= dx2n) || (dx1n >= dx2p && dx1n >= dx2n);
	}
	//------------------------------------------------------------------------------

	private function GetBottomPt(pp:OutPt) : OutPt
	{
		var dups:OutPt = null;
		var p:OutPt = pp.next;
		while (p != pp)
		{
		if (p.pt.y > pp.pt.y)
		{
			pp = p;
			dups = null;
		}
		else if (p.pt.y == pp.pt.y && p.pt.x <= pp.pt.x)
		{
			if (p.pt.x < pp.pt.x)
			{
				dups = null;
				pp = p;
			} else
			{
			if (p.next != pp && p.prev != pp) dups = p;
			}
		}
		p = p.next;
		}
		if (dups != null)
		{
		//there appears to be at least 2 vertices at bottomPt so
		while (dups != p)
		{
			if (!FirstIsBottomPt(p, dups)) pp = dups;
			dups = dups.next;
			while (!ClipperBase.PointsEqual(dups.pt, pp.pt)) dups = dups.next;
		}
		}
		return pp;
	}
	//------------------------------------------------------------------------------

	private function GetLowermostRec(outRec1:OutRec,outRec2:OutRec) : OutRec
	{
		//work out which polygon fragment has the correct hole state
		if (outRec1.bottomPt == null)
			outRec1.bottomPt = GetBottomPt(outRec1.pts);
		if (outRec2.bottomPt == null)
			outRec2.bottomPt = GetBottomPt(outRec2.pts);
		var bPt1 = outRec1.bottomPt;
		var bPt2 = outRec2.bottomPt;
		if (bPt1.pt.y > bPt2.pt.y) return outRec1;
		else if (bPt1.pt.y < bPt2.pt.y) return outRec2;
		else if (bPt1.pt.x < bPt2.pt.x) return outRec1;
		else if (bPt1.pt.x > bPt2.pt.x) return outRec2;
		else if (bPt1.next == bPt1) return outRec2;
		else if (bPt2.next == bPt2) return outRec1;
		else if (FirstIsBottomPt(bPt1, bPt2)) return outRec1;
		else return outRec2;
	}
	//------------------------------------------------------------------------------

	function Param1RightOfParam2(outRec1:OutRec, outRec2:OutRec)
	{
		do
		{
			outRec1 = outRec1.firstLeft;
			if (outRec1 == outRec2) return true;
		} while (outRec1 != null);
		return false;
	}
	//------------------------------------------------------------------------------

	private function GetOutRec(idx:Int) : OutRec
	{
		var outrec:OutRec = m_PolyOuts[idx];
		while (outrec != m_PolyOuts[outrec.idx])
		outrec = m_PolyOuts[outrec.idx];
		return outrec;
	}
	//------------------------------------------------------------------------------

	private function AppendPolygon(e1:TEdge,e2:TEdge)
	{
		//get the start and ends of both output polygons
		var outRec1 = m_PolyOuts[e1.outIdx];
		var outRec2 = m_PolyOuts[e2.outIdx];

		var holeStateRec;
		if (Param1RightOfParam2(outRec1, outRec2))
			holeStateRec = outRec2;
		else if (Param1RightOfParam2(outRec2, outRec1))
			holeStateRec = outRec1;
		else
			holeStateRec = GetLowermostRec(outRec1, outRec2);

		var p1_lft = outRec1.pts;
		var p1_rt = p1_lft.prev;
		var p2_lft = outRec2.pts;
		var p2_rt = p2_lft.prev;

		var side : Int;
		//join e2 poly onto e1 poly and delete pointers to e2
		if(	e1.side == EdgeSide.Left )
		{
		if (e2.side == EdgeSide.Left)
		{
			//z y x a b c
			ReversePolyPtLinks(p2_lft);
			p2_lft.next = p1_lft;
			p1_lft.prev = p2_lft;
			p1_rt.next = p2_rt;
			p2_rt.prev = p1_rt;
			outRec1.pts = p2_rt;
		} else
		{
			//x y z a b c
			p2_rt.next = p1_lft;
			p1_lft.prev = p2_rt;
			p2_lft.prev = p1_rt;
			p1_rt.next = p2_lft;
			outRec1.pts = p2_lft;
		}
		side = EdgeSide.Left;
		} else
		{
		if (e2.side == EdgeSide.Right)
		{
			//a b c z y x
			ReversePolyPtLinks( p2_lft );
			p1_rt.next = p2_rt;
			p2_rt.prev = p1_rt;
			p2_lft.next = p1_lft;
			p1_lft.prev = p2_lft;
		} else
		{
			//a b c x y z
			p1_rt.next = p2_lft;
			p2_lft.prev = p1_rt;
			p1_lft.prev = p2_rt;
			p2_rt.next = p1_lft;
		}
		side = EdgeSide.Right;
		}

		outRec1.bottomPt = null;
		if (holeStateRec == outRec2)
		{
			if (outRec2.firstLeft != outRec1)
				outRec1.firstLeft = outRec2.firstLeft;
			outRec1.isHole = outRec2.isHole;
		}
		outRec2.pts = null;
		outRec2.bottomPt = null;

		outRec2.firstLeft = outRec1;

		var OKIdx = e1.outIdx;
		var ObsoleteIdx = e2.outIdx;

		e1.outIdx = -1; //nb: safe because we only get here via AddLocalMaxPoly
		e2.outIdx = -1;

		var e:TEdge = m_ActiveEdges;
		while( e != null )
		{
		if( e.outIdx == ObsoleteIdx )
		{
			e.outIdx = OKIdx;
			e.side = side;
			break;
		}
		e = e.nextInAEL;
		}
		outRec2.idx = outRec1.idx;
	}
	//------------------------------------------------------------------------------

	private function ReversePolyPtLinks(pp:OutPt)
	{
		if (pp == null) return;
		var pp1;
		var pp2;
		pp1 = pp;
		do
		{
			pp2 = pp1.next;
			pp1.next = pp1.prev;
			pp1.prev = pp2;
			pp1 = pp2;
		} while (pp1 != pp);
	}
	//------------------------------------------------------------------------------

	private static function SwapSides(edge1:TEdge,edge2:TEdge)
	{
		var side = edge1.side;
		edge1.side = edge2.side;
		edge2.side = side;
	}
	//------------------------------------------------------------------------------

	private static function SwapPolyIndexes(edge1:TEdge,edge2:TEdge)
	{
		var outIdx = edge1.outIdx;
		edge1.outIdx = edge2.outIdx;
		edge2.outIdx = outIdx;
	}
	//------------------------------------------------------------------------------

	private function IntersectEdges(e1:TEdge,e2:TEdge,pt:Point,protects:Int)
	{
		//e1 will be to the left of e2 BELOW the intersection. Therefore e1 is before
		//e2 in AEL except when e1 is being inserted at the intersection point

		var e1stops = (Protects.Left & protects) == 0 && e1.nextInLML == null &&
			e1.xtop == pt.x && e1.ytop == pt.y;
		var e2stops = (Protects.Right & protects) == 0 && e2.nextInLML == null &&
			e2.xtop == pt.x && e2.ytop == pt.y;
		var e1Contributing = (e1.outIdx >= 0);
		var e2contributing = (e2.outIdx >= 0);

		//update winding counts
		//assumes that e1 will be to the right of e2 ABOVE the intersection
		if (e1.polyType == e2.polyType)
		{
			if (IsEvenOddFillType(e1))
			{
				var oldE1WindCnt = e1.windCnt;
				e1.windCnt = e2.windCnt;
				e2.windCnt = oldE1WindCnt;
			}
			else
			{
				if (e1.windCnt + e2.windDelta == 0) e1.windCnt = -e1.windCnt;
				else e1.windCnt += e2.windDelta;
				if (e2.windCnt - e1.windDelta == 0) e2.windCnt = -e2.windCnt;
				else e2.windCnt -= e1.windDelta;
			}
		}
		else
		{
			if (!IsEvenOddFillType(e2)) e1.windCnt2 += e2.windDelta;
			else e1.windCnt2 = (e1.windCnt2 == 0) ? 1 : 0;
			if (!IsEvenOddFillType(e1)) e2.windCnt2 -= e1.windDelta;
			else e2.windCnt2 = (e2.windCnt2 == 0) ? 1 : 0;
		}

		var e1FillType, e2FillType, e1FillType2, e2FillType2;
		if (e1.polyType == PolyType.Subject)
		{
			e1FillType = m_SubjFillType;
			e1FillType2 = m_ClipFillType;
		}
		else
		{
			e1FillType = m_ClipFillType;
			e1FillType2 = m_SubjFillType;
		}
		if (e2.polyType == PolyType.Subject)
		{
			e2FillType = m_SubjFillType;
			e2FillType2 = m_ClipFillType;
		}
		else
		{
			e2FillType = m_ClipFillType;
			e2FillType2 = m_SubjFillType;
		}

		var e1Wc, e2Wc;
		switch (e1FillType)
		{
			case PolyFillType.Positive: e1Wc = e1.windCnt;
			case PolyFillType.Negative: e1Wc = -e1.windCnt;
			default: e1Wc = abs(e1.windCnt);
		}
		switch (e2FillType)
		{
			case PolyFillType.Positive: e2Wc = e2.windCnt;
			case PolyFillType.Negative: e2Wc = -e2.windCnt;
			default: e2Wc = abs(e2.windCnt);
		}

		if (e1Contributing && e2contributing)
		{
			if ( e1stops || e2stops ||
				(e1Wc != 0 && e1Wc != 1) || (e2Wc != 0 && e2Wc != 1) ||
				(e1.polyType != e2.polyType && m_ClipType != ClipType.Xor))
				AddLocalMaxPoly(e1, e2, pt);
			else
			{
				AddOutPt(e1, pt);
				AddOutPt(e2, pt);
				SwapSides(e1, e2);
				SwapPolyIndexes(e1, e2);
			}
		}
		else if (e1Contributing)
		{
			if (e2Wc == 0 || e2Wc == 1)
			{
				AddOutPt(e1, pt);
				SwapSides(e1, e2);
				SwapPolyIndexes(e1, e2);
			}

		}
		else if (e2contributing)
		{
			if (e1Wc == 0 || e1Wc == 1)
			{
				AddOutPt(e2, pt);
				SwapSides(e1, e2);
				SwapPolyIndexes(e1, e2);
			}
		}
		else if ( (e1Wc == 0 || e1Wc == 1) &&
			(e2Wc == 0 || e2Wc == 1) && !e1stops && !e2stops )
		{
			//neither edge is currently contributing
			var e1Wc2, e2Wc2;
			switch (e1FillType2)
			{
				case PolyFillType.Positive: e1Wc2 = e1.windCnt2;
				case PolyFillType.Negative: e1Wc2 = -e1.windCnt2;
				default: e1Wc2 = abs(e1.windCnt2);
			}
			switch (e2FillType2)
			{
				case PolyFillType.Positive: e2Wc2 = e2.windCnt2;
				case PolyFillType.Negative: e2Wc2 = -e2.windCnt2;
				default: e2Wc2 = abs(e2.windCnt2);
			}

			if (e1.polyType != e2.polyType)
				AddLocalMinPoly(e1, e2, pt);
			else if (e1Wc == 1 && e2Wc == 1)
				switch (m_ClipType)
				{
					case ClipType.Intersection:
						if (e1Wc2 > 0 && e2Wc2 > 0)
							AddLocalMinPoly(e1, e2, pt);
					case ClipType.Union:
						if (e1Wc2 <= 0 && e2Wc2 <= 0)
							AddLocalMinPoly(e1, e2, pt);
					case ClipType.Difference:
						if (((e1.polyType == PolyType.Clip) && (e1Wc2 > 0) && (e2Wc2 > 0)) ||
							((e1.polyType == PolyType.Subject) && (e1Wc2 <= 0) && (e2Wc2 <= 0)))
								AddLocalMinPoly(e1, e2, pt);
					case ClipType.Xor:
						AddLocalMinPoly(e1, e2, pt);
				}
			else
				SwapSides(e1, e2);
		}

		if ((e1stops != e2stops) &&
			((e1stops && (e1.outIdx >= 0)) || (e2stops && (e2.outIdx >= 0))))
		{
			SwapSides(e1, e2);
			SwapPolyIndexes(e1, e2);
		}

		//finally, delete any non-contributing maxima edges
		if (e1stops) DeleteFromAEL(e1);
		if (e2stops) DeleteFromAEL(e2);
	}
	//------------------------------------------------------------------------------

	private function DeleteFromAEL(e:TEdge)
	{
		var AelPrev = e.prevInAEL;
		var AelNext = e.nextInAEL;
		if (AelPrev == null && AelNext == null && (e != m_ActiveEdges))
			return; //already deleted
		if (AelPrev != null)
			AelPrev.nextInAEL = AelNext;
		else m_ActiveEdges = AelNext;
		if (AelNext != null)
			AelNext.prevInAEL = AelPrev;
		e.nextInAEL = null;
		e.prevInAEL = null;
	}
	//------------------------------------------------------------------------------

	private function DeleteFromSEL(e:TEdge)
	{
		var SelPrev = e.prevInSEL;
		var SelNext = e.nextInSEL;
		if (SelPrev == null && SelNext == null && (e != m_SortedEdges))
			return; //already deleted
		if (SelPrev != null)
			SelPrev.nextInSEL = SelNext;
		else m_SortedEdges = SelNext;
		if (SelNext != null)
			SelNext.prevInSEL = SelPrev;
		e.nextInSEL = null;
		e.prevInSEL = null;
	}
	//------------------------------------------------------------------------------

	private function UpdateEdgeIntoAEL(e : TEdge)
	{
		if (e.nextInLML == null)
			throw "UpdateEdgeIntoAEL: invalid call";
		var AelPrev = e.prevInAEL;
		var AelNext = e.nextInAEL;
		e.nextInLML.outIdx = e.outIdx;
		if (AelPrev != null)
			AelPrev.nextInAEL = e.nextInLML;
		else m_ActiveEdges = e.nextInLML;
		if (AelNext != null)
			AelNext.prevInAEL = e.nextInLML;
		e.nextInLML.side = e.side;
		e.nextInLML.windDelta = e.windDelta;
		e.nextInLML.windCnt = e.windCnt;
		e.nextInLML.windCnt2 = e.windCnt2;
		e = e.nextInLML;
		e.prevInAEL = AelPrev;
		e.nextInAEL = AelNext;
		if (e.dx != ClipperBase.HORIZONTAL) InsertScanbeam(e.ytop);
		return e;
	}
	//------------------------------------------------------------------------------

	private function ProcessHorizontals()
	{
		var horzEdge = m_SortedEdges;
		while (horzEdge != null)
		{
			DeleteFromSEL(horzEdge);
			ProcessHorizontal(horzEdge);
			horzEdge = m_SortedEdges;
		}
	}
	//------------------------------------------------------------------------------

	private function ProcessHorizontal(horzEdge:TEdge)
	{
		var dir;
		var horzLeft, horzRight;

		if (horzEdge.xcurr < horzEdge.xtop)
		{
			horzLeft = horzEdge.xcurr;
			horzRight = horzEdge.xtop;
			dir = Direction.LeftToRight;
		}
		else
		{
			horzLeft = horzEdge.xtop;
			horzRight = horzEdge.xcurr;
			dir = Direction.RightToLeft;
		}

		var eMaxPair;
		if (horzEdge.nextInLML != null)
			eMaxPair = null;
		else
			eMaxPair = GetMaximaPair(horzEdge);

		var e:TEdge = GetNextInAEL(horzEdge, dir);
		while (e != null)
		{
			if (e.xcurr == horzEdge.xtop && eMaxPair == null)
			{
				if (ClipperBase.SlopesEqual(e, horzEdge.nextInLML))
				{
					//if output polygons share an edge, they'll need joining later
					if (horzEdge.outIdx >= 0 && e.outIdx >= 0)
						AddJoin(horzEdge.nextInLML, e, horzEdge.outIdx, -1);
					break; //we've reached the end of the ClipperBase.HORIZONTAL line
				}
				else if (e.dx < horzEdge.nextInLML.dx)
					//we really have got to the end of the intermediate horz edge so quit.
					//nb: More -ve slopes follow more +ve slopes ABOVE the ClipperBase.HORIZONTAL.
					break;
			}

			var eNext = GetNextInAEL(e, dir);
			if (eMaxPair != null ||
				((dir == Direction.LeftToRight) && (e.xcurr < horzRight)) ||
				((dir == Direction.RightToLeft) && (e.xcurr > horzLeft)))
			{
				//so far we're still in range of the ClipperBase.HORIZONTAL edge

				if (e == eMaxPair)
				{
					//horzEdge is evidently a maxima ClipperBase.HORIZONTAL and we've arrived at its end.
					if (dir == Direction.LeftToRight)
						IntersectEdges(horzEdge, e, new Point(e.xcurr, horzEdge.ycurr), 0);
					else
						IntersectEdges(e, horzEdge, new Point(e.xcurr, horzEdge.ycurr), 0);
					if (eMaxPair.outIdx >= 0) throw "ProcessHorizontal error";
					return;
				}
				else if (e.dx == ClipperBase.HORIZONTAL && !IsMinima(e) && !(e.xcurr > e.xtop))
				{
					if (dir == Direction.LeftToRight)
						IntersectEdges(horzEdge, e, new Point(e.xcurr, horzEdge.ycurr),
							(IsTopHorz(horzEdge, e.xcurr)) ? Protects.Left : Protects.Both);
					else
						IntersectEdges(e, horzEdge, new Point(e.xcurr, horzEdge.ycurr),
							(IsTopHorz(horzEdge, e.xcurr)) ? Protects.Right : Protects.Both);
				}
				else if (dir == Direction.LeftToRight)
				{
					IntersectEdges(horzEdge, e, new Point(e.xcurr, horzEdge.ycurr),
						(IsTopHorz(horzEdge, e.xcurr)) ? Protects.Left : Protects.Both);
				}
				else
				{
					IntersectEdges(e, horzEdge, new Point(e.xcurr, horzEdge.ycurr),
						(IsTopHorz(horzEdge, e.xcurr)) ? Protects.Right : Protects.Both);
				}
				SwapPositionsInAEL(horzEdge, e);
			}
			else if ( (dir == Direction.LeftToRight && e.xcurr >= horzRight) ||
				(dir == Direction.RightToLeft && e.xcurr <= horzLeft) ) break;
			e = eNext;
		} //end while ( e )

		if (horzEdge.nextInLML != null)
		{
			if (horzEdge.outIdx >= 0)
				AddOutPt(horzEdge, new Point(horzEdge.xtop, horzEdge.ytop));
			horzEdge = UpdateEdgeIntoAEL(horzEdge);
		}
		else
		{
			if (horzEdge.outIdx >= 0)
				IntersectEdges(horzEdge, eMaxPair,
					new Point(horzEdge.xtop, horzEdge.ycurr), Protects.Both);
			DeleteFromAEL(eMaxPair);
			DeleteFromAEL(horzEdge);
		}
	}
	//------------------------------------------------------------------------------

	private function IsTopHorz(horzEdge:TEdge,XPos:Float) : Bool
	{
		var e:TEdge = m_SortedEdges;
		while (e != null)
		{
			if ((XPos >= Math.min(e.xcurr, e.xtop)) && (XPos <= Math.max(e.xcurr, e.xtop)))
				return false;
			e = e.nextInSEL;
		}
		return true;
	}
	//------------------------------------------------------------------------------

	private function GetNextInAEL(e:TEdge,dir:Int) : TEdge
	{
		return dir == Direction.LeftToRight ? e.nextInAEL: e.prevInAEL;
	}
	//------------------------------------------------------------------------------

	private function IsMinima(e:TEdge) : Bool
	{
		return e != null && (e.prev.nextInLML != e) && (e.next.nextInLML != e);
	}
	//------------------------------------------------------------------------------

	private function IsMaxima(e:TEdge,y:Float) : Bool
	{
		return (e != null && e.ytop == y && e.nextInLML == null);
	}
	//------------------------------------------------------------------------------

	private function IsIntermediate(e:TEdge,y:Float) : Bool
	{
		return (e.ytop == y && e.nextInLML != null);
	}
	//------------------------------------------------------------------------------

	private function GetMaximaPair(e:TEdge) : TEdge
	{
		if (!IsMaxima(e.next, e.ytop) || (e.next.xtop != e.xtop))
			return e.prev; else
			return e.next;
	}
	//------------------------------------------------------------------------------

	private function ProcessIntersections(botY:Int,topY:Int) : Bool
	{
		if( m_ActiveEdges == null ) return true;
		try {
			BuildIntersectList(botY, topY);
			if ( m_IntersectNodes == null) return true;
			if (m_IntersectNodes.next == null || FixupIntersectionOrder())
				ProcessIntersectList();
			else
				return false;
		} catch( e : Dynamic ) {
			m_SortedEdges = null;
			DisposeIntersectNodes();
			throw "ProcessIntersections error";
		}
		m_SortedEdges = null;
		return true;
	}
	//------------------------------------------------------------------------------

	private function BuildIntersectList(botY:Int,topY:Int)
	{
		if ( m_ActiveEdges == null ) return;

		//prepare for sorting
		var e:TEdge = m_ActiveEdges;
		m_SortedEdges = e;
		while( e != null )
		{
		e.prevInSEL = e.prevInAEL;
		e.nextInSEL = e.nextInAEL;
		e.xcurr = TopX( e, topY );
		e = e.nextInAEL;
		}

		//bubblesort
		var isModified = true;
		while( isModified && m_SortedEdges != null )
		{
		isModified = false;
		e = m_SortedEdges;
		while( e.nextInSEL != null )
		{
			var eNext = e.nextInSEL;
			var pt:Point = new Point();
			if (e.xcurr > eNext.xcurr)
			{
				if (!IntersectPoint(e, eNext, pt) && e.xcurr > eNext.xcurr +1)
					throw "Intersection error";
				if (pt.y > botY)
				{
					pt.y = botY;
					pt.x = TopX(e, pt.y);
				}
				InsertIntersectNode(e, eNext, pt);
				SwapPositionsInSEL(e, eNext);
				isModified = true;
			}
			else
			e = eNext;
		}
		if( e.prevInSEL != null ) e.prevInSEL.nextInSEL = null;
		else break;
		}
		m_SortedEdges = null;
	}
	//------------------------------------------------------------------------------

	private function EdgesAdjacent(inode:IntersectNode) : Bool
	{
		return (inode.edge1.nextInSEL == inode.edge2) ||
		(inode.edge1.prevInSEL == inode.edge2);
	}
	//------------------------------------------------------------------------------

	private function FixupIntersectionOrder() : Bool
	{
		//pre-condition: intersections are sorted bottom-most (then left-most) first.
		//Now it's crucial that intersections are made only between adjacent edges,
		//so to ensure this the order of intersections may need adjusting
		var inode:IntersectNode = m_IntersectNodes;
		CopyAELToSEL();
		while (inode != null)
		{
			if (!EdgesAdjacent(inode))
			{
				var nextNode = inode.next;
				while (nextNode != null && !EdgesAdjacent(nextNode))
					nextNode = nextNode.next;
				if (nextNode == null)
					return false;
				SwapIntersectNodes(inode, nextNode);
			}
			SwapPositionsInSEL(inode.edge1, inode.edge2);
			inode = inode.next;
		}
		return true;
	}
	//------------------------------------------------------------------------------

	private function ProcessIntersectList()
	{
		while (m_IntersectNodes != null)
		{
		var iNode = m_IntersectNodes.next;
		{
			IntersectEdges( m_IntersectNodes.edge1 ,
			m_IntersectNodes.edge2 , m_IntersectNodes.pt, Protects.Both );
			SwapPositionsInAEL( m_IntersectNodes.edge1 , m_IntersectNodes.edge2 );
		}
		m_IntersectNodes = null;
		m_IntersectNodes = iNode;
		}
	}
	//------------------------------------------------------------------------------

	private static function Round(value:Float) : Int
	{
		return value < 0 ? Std.int(value - 0.5) : Std.int(value + 0.5);
	}
	//------------------------------------------------------------------------------

	private static function TopX(edge:TEdge,currentY:Int) : Int
	{
		if (currentY == edge.ytop)
			return edge.xtop;
		return edge.xbot + Round(edge.dx *(currentY - edge.ybot));
	}
	//------------------------------------------------------------------------------

	private function InsertIntersectNode(e1:TEdge,e2:TEdge,pt:Point)
	{
		var newNode = new IntersectNode();
		newNode.edge1 = e1;
		newNode.edge2 = e2;
		newNode.pt = pt;
		newNode.next = null;
		if (m_IntersectNodes == null) m_IntersectNodes = newNode;
		else if (newNode.pt.y > m_IntersectNodes.pt.y)
		{
		newNode.next = m_IntersectNodes;
		m_IntersectNodes = newNode;
		}
		else
		{
		var iNode = m_IntersectNodes;
		while (iNode.next != null && newNode.pt.y < iNode.next.pt.y)
			iNode = iNode.next;
		newNode.next = iNode.next;
		iNode.next = newNode;
		}
	}
	//------------------------------------------------------------------------------

	private function SwapIntersectNodes(int1:IntersectNode,int2:IntersectNode)
	{
		var e1 = int1.edge1;
		var e2 = int1.edge2;
		var p:Point = int1.pt;
		int1.edge1 = int2.edge1;
		int1.edge2 = int2.edge2;
		int1.pt = int2.pt;
		int2.edge1 = e1;
		int2.edge2 = e2;
		int2.pt = p;
	}
	//------------------------------------------------------------------------------

	private function IntersectPoint(edge1:TEdge,edge2:TEdge,ip:Point)
	{
		var b1, b2;
		if (ClipperBase.SlopesEqual(edge1, edge2))
		{
			if (edge2.ybot > edge1.ybot)
			ip.y = edge2.ybot;
			else
			ip.y = edge1.ybot;
			return false;
		}
		else if (edge1.dx == 0)
		{
			ip.x = edge1.xbot;
			if (edge2.dx == ClipperBase.HORIZONTAL)
			{
				ip.y = edge2.ybot;
			}
			else
			{
				b2 = edge2.ybot - (edge2.xbot / edge2.dx);
				ip.y = Round(ip.x / edge2.dx + b2);
			}
		}
		else if (edge2.dx == 0)
		{
			ip.x = edge2.xbot;
			if (edge1.dx == ClipperBase.HORIZONTAL)
			{
				ip.y = edge1.ybot;
			}
			else
			{
				b1 = edge1.ybot - (edge1.xbot / edge1.dx);
				ip.y = Round(ip.x / edge1.dx + b1);
			}
		}
		else
		{
			b1 = edge1.xbot - edge1.ybot * edge1.dx;
			b2 = edge2.xbot - edge2.ybot * edge2.dx;
			var q:Float = (b2 - b1) / (edge1.dx - edge2.dx);
			ip.y = Round(q);
			if (Math.abs(edge1.dx) < Math.abs(edge2.dx))
				ip.x = Round(edge1.dx * q + b1);
			else
				ip.x = Round(edge2.dx * q + b2);
		}

		if (ip.y < edge1.ytop || ip.y < edge2.ytop)
		{
			if (edge1.ytop > edge2.ytop)
			{
				ip.x = edge1.xtop;
				ip.y = edge1.ytop;
				return TopX(edge2, edge1.ytop) < edge1.xtop;
			}
			else
			{
				ip.x = edge2.xtop;
				ip.y = edge2.ytop;
				return TopX(edge1, edge2.ytop) > edge2.xtop;
			}
		}
		else
			return true;
	}
	//------------------------------------------------------------------------------

	private function DisposeIntersectNodes()
	{
		while ( m_IntersectNodes != null )
		{
		var iNode = m_IntersectNodes.next;
		m_IntersectNodes = null;
		m_IntersectNodes = iNode;
		}
	}
	//------------------------------------------------------------------------------

	private function ProcessEdgesAtTopOfScanbeam(topY:Int)
	{
		var e:TEdge = m_ActiveEdges;
		while( e != null )
		{
		//1. process maxima, treating them as if they're 'bent' ClipperBase.HORIZONTAL edges,
		//	 but exclude maxima with ClipperBase.HORIZONTAL edges. nb: e can't be a ClipperBase.HORIZONTAL.
		if( IsMaxima(e, topY) && GetMaximaPair(e).dx != ClipperBase.HORIZONTAL )
		{
			//'e' might be removed from AEL, as may any following edges so
			var ePrev = e.prevInAEL;
			DoMaxima(e, topY);
			if( ePrev == null ) e = m_ActiveEdges;
			else e = ePrev.nextInAEL;
		}
		else
		{
			var intermediateVert = IsIntermediate(e, topY);
			//2. promote ClipperBase.HORIZONTAL edges, otherwise update xcurr and ycurr
			if (intermediateVert && e.nextInLML.dx == ClipperBase.HORIZONTAL)
			{
			if (e.outIdx >= 0)
			{
				AddOutPt(e, new Point(e.xtop, e.ytop));

				var i = -1;
				while( ++i < m_HorizJoins.length ) {
					var hj:HorzJoinRec = m_HorizJoins[i];
					if (HasOverlapSegment(new Point(hj.edge.xbot, hj.edge.ybot),
						new Point(hj.edge.xtop, hj.edge.ytop),
						new Point(e.nextInLML.xbot, e.nextInLML.ybot),
						new Point(e.nextInLML.xtop, e.nextInLML.ytop)))
							AddJoin(hj.edge, e.nextInLML, hj.savedIdx, e.outIdx);
				}

				AddHorzJoin(e.nextInLML, e.outIdx);
			}
			e = UpdateEdgeIntoAEL(e);
			AddEdgeToSEL(e);
			}
			else
			{
			e.xcurr = TopX( e, topY );
			e.ycurr = topY;
			if (forceSimple && e.prevInAEL != null &&
				e.prevInAEL.xcurr == e.xcurr &&
				e.outIdx >= 0 && e.prevInAEL.outIdx >= 0)
			{
				if (intermediateVert)
					AddOutPt(e.prevInAEL, new Point(e.xcurr, topY));
				else
					AddOutPt(e, new Point(e.xcurr, topY));
			}
			}
			e = e.nextInAEL;
		}
		}

		//3. Process horizontals at the top of the scanbeam
		ProcessHorizontals();

		//4. Promote intermediate vertices
		e = m_ActiveEdges;
		while( e != null )
		{
		if( IsIntermediate( e, topY ) )
		{
			if (e.outIdx >= 0) AddOutPt(e, new Point(e.xtop, e.ytop));
			e = UpdateEdgeIntoAEL(e);

			//if output polygons share an edge, they'll need joining later
			var ePrev = e.prevInAEL;
			var eNext = e.nextInAEL;
			if (ePrev != null && ePrev.xcurr == e.xbot &&
			ePrev.ycurr == e.ybot && e.outIdx >= 0 &&
			ePrev.outIdx >= 0 && ePrev.ycurr > ePrev.ytop &&
			ClipperBase.SlopesEqual(e, ePrev))
			{
				AddOutPt(ePrev, new Point(e.xbot, e.ybot));
				AddJoin(e, ePrev, -1, -1);
			}
			else if (eNext != null && eNext.xcurr == e.xbot &&
			eNext.ycurr == e.ybot && e.outIdx >= 0 &&
			eNext.outIdx >= 0 && eNext.ycurr > eNext.ytop &&
			ClipperBase.SlopesEqual(e, eNext))
			{
				AddOutPt(eNext, new Point(e.xbot, e.ybot));
				AddJoin(e, eNext, -1, -1);
			}
		}
		e = e.nextInAEL;
		}
	}
	//------------------------------------------------------------------------------

	private function DoMaxima(e:TEdge,topY:Int)
	{
		var eMaxPair = GetMaximaPair(e);
		var x:Int = e.xtop;
		var eNext = e.nextInAEL;
		while( eNext != eMaxPair )
		{
		if (eNext == null) throw "DoMaxima error";
		IntersectEdges( e, eNext, new Point(x, topY), Protects.Both );
		SwapPositionsInAEL(e, eNext);
		eNext = e.nextInAEL;
		}
		if( e.outIdx < 0 && eMaxPair.outIdx < 0 )
		{
		DeleteFromAEL( e );
		DeleteFromAEL( eMaxPair );
		}
		else if( e.outIdx >= 0 && eMaxPair.outIdx >= 0 )
		{
			IntersectEdges(e, eMaxPair, new Point(x, topY), Protects.None);
		}
		else throw "DoMaxima error";
	}
	//------------------------------------------------------------------------------

	static function reversePolygons(polys:Polygons)
	{
		for( p in polys ) p.reverse();
	}

	//------------------------------------------------------------------------------

	private function PointCount(pts:OutPt) : Int
	{
		if (pts == null) return 0;
		var result:Int = 0;
		var p:OutPt = pts;
		do
		{
			result++;
			p = p.next;
		}
		while (p != pts);
		return result;
	}
	//------------------------------------------------------------------------------

	private function BuildResult(polyg:Polygons)
	{
		polyg.splice(0,polyg.length);
		for( outRec in m_PolyOuts )
		{
			if (outRec.pts == null) continue;
			var p:OutPt = outRec.pts;
			var cnt:Int = PointCount(p);
			if (cnt < 3) continue;
			var pg:Polygon = new Polygon();
			for( j in 0...cnt )
			{
				pg.addPoint(p.pt);
				p = p.prev;
			}
			polyg.push(pg);
		}
	}
	//------------------------------------------------------------------------------

	private function BuildResult2(polytree:PolyTree)
	{
		polytree.clear();

		//add each output polygon/contour to polytree
		for ( outRec in m_PolyOuts )
		{
			var cnt:Int = PointCount(outRec.pts);
			if (cnt < 3) continue;
			FixHoleLinkage(outRec);
			var pn:PolyNode = new PolyNode();
			polytree.allPolys.push(pn);
			outRec.polyNode = pn;
			var op:OutPt = outRec.pts;
			for( j in 0...cnt )
			{
				pn.polygon.addPoint(op.pt);
				op = op.prev;
			}
		}

		//fixup PolyNode links etc
		for( outRec in m_PolyOuts )
		{
			if (outRec.polyNode == null) continue;
			if (outRec.firstLeft == null)
				polytree.addChild(outRec.polyNode);
			else
				outRec.firstLeft.polyNode.addChild(outRec.polyNode);
		}
	}
	//------------------------------------------------------------------------------

	private function FixupOutPolygon(outRec:OutRec)
	{
		//FixupOutPolygon() - removes duplicate points and simplifies consecutive
		//parallel edges by removing the middle vertex.
		var lastOK = null;
		outRec.bottomPt = null;
		var pp:OutPt = outRec.pts;
		while( true )
		{
			if (pp.prev == pp || pp.prev == pp.next)
			{
				DisposeOutPts(pp);
				outRec.pts = null;
				return;
			}
			//test for duplicate points and for same slope (cross-product)
			if (ClipperBase.PointsEqual(pp.pt, pp.next.pt) ||
				ClipperBase.SlopesEqual3(pp.prev.pt, pp.pt, pp.next.pt))
			{
				lastOK = null;
				var tmp:OutPt = pp;
				pp.prev.next = pp.next;
				pp.next.prev = pp.prev;
				pp = pp.prev;
				tmp = null;
			}
			else if (pp == lastOK) break;
			else
			{
				if (lastOK == null) lastOK = pp;
				pp = pp.next;
			}
		}
		outRec.pts = pp;
	}
	//------------------------------------------------------------------------------

	private function JoinPoints(j:JoinRec) : Null<{ p1 : OutPt, p2 : OutPt }>
	{
		var p1 = null, p2 = null;
		var outRec1 = m_PolyOuts[j.poly1Idx];
		var outRec2 = m_PolyOuts[j.poly2Idx];
		if (outRec1	== null || outRec2 == null)	return null;
		var pp1a = outRec1.pts;
		var pp2a = outRec2.pts;
		var pt1 = new Ref<Point>(j.pt2a), pt2 = new Ref<Point>(j.pt2b);
		var pt3 = new Ref<Point>(j.pt1a), pt4 = new Ref<Point>(j.pt1b);
		pp1a = FindSegment(pp1a, pt1, pt2);
		if( pp1a == null ) return null;
		if (outRec1 == outRec2)
		{
			//we're searching the same polygon for overlapping segments so
			//segment 2 mustn't be the same as segment 1
			pp2a = pp1a.next;
			pp2a = FindSegment(pp2a, pt3, pt4);
			if( pp2a == null || pp2a == pp1a )
				return null;
		}
		else {
			pp2a = FindSegment(pp2a, pt3, pt4);
			if( pp2a == null )
				return null;
		}

		if (!GetOverlapSegment(pt1.val, pt2.val, pt3.val, pt4.val, pt1, pt2)) return null;

		// unref
		var pt1 = pt1.val;
		var pt2 = pt2.val;
		var pt3 = pt3.val;
		var pt4 = pt4.val;

		var p3, p4, prev = pp1a.prev;
		//get p1 & p2 polypts - the overlap start & endpoints on poly1
		if (ClipperBase.PointsEqual(pp1a.pt, pt1)) p1 = pp1a;
		else if (ClipperBase.PointsEqual(prev.pt, pt1)) p1 = prev;
		else p1 = InsertPolyPtBetween(pp1a, prev, pt1);

		if (ClipperBase.PointsEqual(pp1a.pt, pt2)) p2 = pp1a;
		else if (ClipperBase.PointsEqual(prev.pt, pt2)) p2 = prev;
		else if ((p1 == pp1a) || (p1 == prev))
			p2 = InsertPolyPtBetween(pp1a, prev, pt2);
		else if (Pt3IsBetweenPt1AndPt2(pp1a.pt, p1.pt, pt2))
			p2 = InsertPolyPtBetween(pp1a, p1, pt2); else
			p2 = InsertPolyPtBetween(p1, prev, pt2);

		//get p3 & p4 polypts - the overlap start & endpoints on poly2
		prev = pp2a.prev;
		if (ClipperBase.PointsEqual(pp2a.pt, pt1)) p3 = pp2a;
		else if (ClipperBase.PointsEqual(prev.pt, pt1)) p3 = prev;
		else p3 = InsertPolyPtBetween(pp2a, prev, pt1);

		if (ClipperBase.PointsEqual(pp2a.pt, pt2)) p4 = pp2a;
		else if (ClipperBase.PointsEqual(prev.pt, pt2)) p4 = prev;
		else if ((p3 == pp2a) || (p3 == prev))
			p4 = InsertPolyPtBetween(pp2a, prev, pt2);
		else if (Pt3IsBetweenPt1AndPt2(pp2a.pt, p3.pt, pt2))
			p4 = InsertPolyPtBetween(pp2a, p3, pt2); else
			p4 = InsertPolyPtBetween(p3, prev, pt2);

		//p1.pt == p3.pt and p2.pt == p4.pt so join p1 to p3 and p2 to p4
		if (p1.next == p2 && p3.prev == p4)
		{
			p1.next = p3;
			p3.prev = p1;
			p2.prev = p4;
			p4.next = p2;
			return {p1:p1,p2:p2};
		}
		else if (p1.prev == p2 && p3.next == p4)
		{
			p1.prev = p3;
			p3.next = p1;
			p2.next = p4;
			p4.prev = p2;
			return {p1:p1,p2:p2};
		}
		else
			return null; //an orientation is probably wrong
	}
	//----------------------------------------------------------------------

	private function FixupJoinRecs(j:JoinRec,pt:OutPt,startIdx:Int)
	{
		for( j2 in m_Joins )
		{
			if (j2.poly1Idx == j.poly1Idx && PointIsVertex(j2.pt1a, pt))
			j2.poly1Idx = j.poly2Idx;
			if (j2.poly2Idx == j.poly1Idx && PointIsVertex(j2.pt2a, pt))
			j2.poly2Idx = j.poly2Idx;
		}
	}
	//----------------------------------------------------------------------

	private function Poly2ContainsPoly1(outPt1:OutPt,outPt2:OutPt) : Bool
	{
		var pt:OutPt = outPt1;
		//Because the polygons may be touching, we need to find a vertex that
		//isn't touching the other polygon
		if (PointOnPolygon(pt.pt, outPt2))
		{
			pt = pt.next;
			while (pt != outPt1 && PointOnPolygon(pt.pt, outPt2))
				pt = pt.next;
			if (pt == outPt1) return true;
		}
		return PointInPolygon(pt.pt, outPt2);
	}
	//----------------------------------------------------------------------

	private function FixupFirstLefts1(OldOutRec:OutRec,NewOutRec:OutRec)
	{
		for ( outRec in m_PolyOuts )
		{
			if (outRec.pts != null && outRec.firstLeft == OldOutRec)
			{
				if (Poly2ContainsPoly1(outRec.pts, NewOutRec.pts))
					outRec.firstLeft = NewOutRec;
			}
		}
	}
	//----------------------------------------------------------------------

	private function FixupFirstLefts2(OldOutRec:OutRec,NewOutRec:OutRec)
	{
		for( outRec in m_PolyOuts )
			if (outRec.firstLeft == OldOutRec) outRec.firstLeft = NewOutRec;
	}
	//----------------------------------------------------------------------

	private function JoinCommonEdges()
	{
		var i = -1;
		while( ++i < m_Joins.length )
		{
			var j = m_Joins[i];

		var outRec1 = GetOutRec(j.poly1Idx);
		var outRec2 = GetOutRec(j.poly2Idx);

		if (outRec1.pts == null || outRec2.pts == null) continue;

		//get the polygon fragment with the correct hole state (firstLeft)
		//before calling JoinPoints()
		var holeStateRec;
		if (outRec1 == outRec2) holeStateRec = outRec1;
		else if (Param1RightOfParam2(outRec1, outRec2)) holeStateRec = outRec2;
		else if (Param1RightOfParam2(outRec2, outRec1)) holeStateRec = outRec1;
		else holeStateRec = GetLowermostRec(outRec1, outRec2);

		var r = JoinPoints(j);
		if( r == null ) continue;
		var p1 = r.p1, p2 = r.p2;

		if (outRec1 == outRec2)
		{
			//instead of joining two polygons, we've just created a new one by
			//splitting one polygon into two.
			outRec1.pts = p1;
			outRec1.bottomPt = null;
			outRec2 = CreateOutRec();
			outRec2.pts = p2;

			if (Poly2ContainsPoly1(outRec2.pts, outRec1.pts))
			{
				//outRec2 is contained by outRec1
				outRec2.isHole = !outRec1.isHole;
				outRec2.firstLeft = outRec1;

				FixupJoinRecs(j, p2, i + 1);

				//fixup firstLeft pointers that may need reassigning to OutRec1
				if (m_UsingPolyTree) FixupFirstLefts2(outRec2, outRec1);

				FixupOutPolygon(outRec1); //nb: do this BEFORE testing orientation
				FixupOutPolygon(outRec2); //	but AFTER calling FixupJoinRecs()

				if (xor(outRec2.isHole,m_ReverseOutput) == (Area(outRec2) > 0))
					ReversePolyPtLinks(outRec2.pts);

			}
			else if (Poly2ContainsPoly1(outRec1.pts, outRec2.pts))
			{
				//outRec1 is contained by outRec2
				outRec2.isHole = outRec1.isHole;
				outRec1.isHole = !outRec2.isHole;
				outRec2.firstLeft = outRec1.firstLeft;
				outRec1.firstLeft = outRec2;

				FixupJoinRecs(j, p2, i + 1);

				//fixup firstLeft pointers that may need reassigning to OutRec1
				if (m_UsingPolyTree) FixupFirstLefts2(outRec1, outRec2);

				FixupOutPolygon(outRec1); //nb: do this BEFORE testing orientation
				FixupOutPolygon(outRec2); //	but AFTER calling FixupJoinRecs()

				if (xor(outRec1.isHole,m_ReverseOutput) == (Area(outRec1) > 0))
					ReversePolyPtLinks(outRec1.pts);
			}
			else
			{
				//the 2 polygons are completely separate
				outRec2.isHole = outRec1.isHole;
				outRec2.firstLeft = outRec1.firstLeft;

				FixupJoinRecs(j, p2, i + 1);

				//fixup firstLeft pointers that may need reassigning to OutRec2
				if (m_UsingPolyTree) FixupFirstLefts1(outRec1, outRec2);

				FixupOutPolygon(outRec1); //nb: do this BEFORE testing orientation
				FixupOutPolygon(outRec2); //	but AFTER calling FixupJoinRecs()
			}
		}
		else
		{
			//joined 2 polygons together

			//cleanup redundant edges
			FixupOutPolygon(outRec1);

			outRec2.pts = null;
			outRec2.bottomPt = null;
			outRec2.idx = outRec1.idx;

			outRec1.isHole = holeStateRec.isHole;
			if (holeStateRec == outRec2)
				outRec1.firstLeft = outRec2.firstLeft;
			outRec2.firstLeft = outRec1;

			//fixup firstLeft pointers that may need reassigning to OutRec1
			if (m_UsingPolyTree) FixupFirstLefts2(outRec2, outRec1);
		}
		}
	}
	//------------------------------------------------------------------------------

	private function UpdateOutPtIdxs(outrec:OutRec)
	{
		var op:OutPt = outrec.pts;
		do
		{
		op.idx = outrec.idx;
		op = op.prev;
		}
		while(op != outrec.pts);
	}
	//------------------------------------------------------------------------------

	private function DoSimplePolygons()
	{
		var i:Int = 0;
		while (i < m_PolyOuts.length)
		{
		var outrec:OutRec = m_PolyOuts[i++];
		var op:OutPt = outrec.pts;
		if (op == null) continue;
		do //for each Pt in Polygon until duplicate found do
		{
			var op2 = op.next;
			while (op2 != outrec.pts)
			{
			if (ClipperBase.PointsEqual(op.pt, op2.pt) && op2.next != op && op2.prev != op)
			{
				//split the polygon into two
				var op3 = op.prev;
				var op4 = op2.prev;
				op.prev = op4;
				op4.next = op;
				op2.prev = op3;
				op3.next = op2;

				outrec.pts = op;
				var outrec2 = CreateOutRec();
				outrec2.pts = op2;
				UpdateOutPtIdxs(outrec2);
				if (Poly2ContainsPoly1(outrec2.pts, outrec.pts))
				{
				//OutRec2 is contained by OutRec1
				outrec2.isHole = !outrec.isHole;
				outrec2.firstLeft = outrec;
				}
				else
				if (Poly2ContainsPoly1(outrec.pts, outrec2.pts))
				{
				//OutRec1 is contained by OutRec2
				outrec2.isHole = outrec.isHole;
				outrec.isHole = !outrec2.isHole;
				outrec2.firstLeft = outrec.firstLeft;
				outrec.firstLeft = outrec2;
				} else
				{
				//the 2 polygons are separate
				outrec2.isHole = outrec.isHole;
				outrec2.firstLeft = outrec.firstLeft;
				}
				op2 = op; //ie get ready for the next iteration
			}
			op2 = op2.next;
			}
			op = op.next;
		}
		while (op != outrec.pts);
		}
	}

	//------------------------------------------------------------------------------

	static function Area(outRec:OutRec) {
		var op:OutPt = outRec.pts;
		if (op == null) return 0.;
		var a:Float = 0;
		do {
			a = a + (op.pt.x + op.prev.pt.x) * (op.prev.pt.y - op.pt.y);
			op = op.next;
		} while (op != outRec.pts);
		return a/2;
	}

	//------------------------------------------------------------------------------
	// OffsetPolygon functions
	//------------------------------------------------------------------------------

	static function BuildArc(pt:Point , a1:Float , a2:Float , r:Float , limit:Float) : Polygon
	{
		//see notes in clipper.pas regarding steps
		var arcFrac = Math.abs(a2 - a1) / (2 * Math.PI);
		var steps:Int = Std.int(arcFrac * Math.PI / Math.acos(1 - limit / Math.abs(r)));
		if (steps < 2)
			steps = 2;
		else if (steps > Std.int(222.0 * arcFrac))
			steps = Std.int(222.0 * arcFrac);

		var x:Float = Math.cos(a1);
		var y:Float = Math.sin(a1);
		var c:Float = Math.cos((a2 - a1) / steps);
		var s:Float = Math.sin((a2 - a1) / steps);
		var result:Polygon = new Polygon();
		for ( i in 0...steps+1 )
		{
			result.add(pt.x + Round(x * r), pt.y + Round(y * r));
			var x2 = x;
			x = x * c - s * y;	//cross product
			y = x2 * s + y * c; //dot product
		}
		return result;
	}
	//------------------------------------------------------------------------------

	static function GetUnitNormal(pt1:Point, pt2:Point)
	{
		var dx:Float = (pt2.x - pt1.x);
		var dy:Float = (pt2.y - pt1.y);
		if ((dx == 0) && (dy == 0)) return new DoublePoint();

		var f:Float = 1 * 1.0 / Math.sqrt(dx * dx + dy * dy);
		dx *= f;
		dy *= f;

		return new DoublePoint(dy, -dx);
	}
	//------------------------------------------------------------------------------

	static inline function UpdateBotPt(pt:Point, botPt:Point)
	{
		return if (pt.y > botPt.y || (pt.y == botPt.y && pt.x < botPt.x)) pt else null;
	}
	//------------------------------------------------------------------------------

	public static function offsetPolygons(poly:Polygons, delta:Float, ?jointype:JoinType, MiterLimit:Float=0, AutoFix:Bool=true) : Polygons
	{
		if( jointype == null )
			jointype = JoinType.Square;
		var result:Polygons = new Polygons();

		//AutoFix - fixes polygon orientation if necessary and removes
		//duplicate vertices. Can be set false when you're sure that polygon
		//orientation is correct and that there are no duplicate vertices.
		if (AutoFix)
		{
			var Len = poly.length, botI = 0;
			while (botI < Len && poly[botI].length == 0) botI++;
			if (botI == Len) return result;

			//botPt: used to find the lowermost (in inverted y-axis) & leftmost point
			//This point (on pts[botI]) must be on an outer polygon ring and if
			//its orientation is false (counterclockwise) then assume all polygons
			//need reversing
			var botPt = poly[botI][0];
			for ( i in botI...Len )
			{
				if (poly[i].length == 0) continue;
				var tmp = UpdateBotPt(poly[i][0], botPt);
				if( tmp != null ) {
					botPt = tmp;
					botI = i;
				}
				var j = poly[i].length - 1;
				while( j > 0 )
				{
					if (ClipperBase.PointsEqual(poly[i][j], poly[i][j - 1]))
						poly[i].removeAt(j);
					else {
						var tmp = UpdateBotPt(poly[i][j], botPt);
						if (tmp != null) {
							botPt = tmp;
							botI = i;
						}
					}
					j--;
				}
			}
			if (!poly[botI].getOrientation())
				reversePolygons(poly);
		}

		new PolyOffsetBuilder(poly, result, true, delta, jointype, EndType.Closed, MiterLimit);
		return result;
	}

	//------------------------------------------------------------------------------

	public static function offsetPolyLines(lines:Polygons, delta:Float, jointype:JoinType, endtype:EndType, limit:Float) {
		var result:Polygons = new Polygons();

		//automatically strip duplicate points because it gets complicated with
		//open and closed lines and when to strip duplicates across begin-end
		var pts:Polygons = lines.copy();
		for( poly in pts ) {
			var j = poly.length - 1;
			while( j > 0 ) {
				if (ClipperBase.PointsEqual(poly[j], poly[j - 1]))
					poly.removeAt(j);
				j--;
			}
		}

		if (endtype == EndType.Closed)
		{
			var sz:Int = pts.length;
			for ( i in 0...sz )
			{
				var line:Polygon = new Polygon(pts[i].points.copy());
				line.reverse();
				pts.push(line);
			}
			new PolyOffsetBuilder(pts, result, true, delta, jointype, endtype, limit);
		}
		else
			new PolyOffsetBuilder(pts, result, false, delta, jointype, endtype, limit);

		return result;
	}
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	// SimplifyPolygon functions
	// Convert self-intersecting polygons into simple polygons
	//------------------------------------------------------------------------------

	public static function simplifyPolygon(poly:Polygon, ?fillType ) : Polygons {
		if( fillType == null ) fillType = PolyFillType.EvenOdd;
		var result:Polygons = new Polygons();
		var c:Clipper = new Clipper();
		c.forceSimple = true;
		c.addPolygon(poly, PolyType.Subject);
		c.execute(ClipType.Union, result, fillType, fillType);
		return result;
	}
	//------------------------------------------------------------------------------

	public static function simplifyPolygons(polys:Polygons, ?fillType) : Polygons {
		if( fillType == null ) fillType = PolyFillType.EvenOdd;
		var result:Polygons = new Polygons();
		var c:Clipper = new Clipper();
		c.forceSimple = true;
		c.addPolygons(polys, PolyType.Subject);
		c.execute(ClipType.Union, result, fillType, fillType);
		return result;
	}
	//------------------------------------------------------------------------------

	private static function DistanceSqrd(pt1:Point,pt2:Point) : Float
	{
		var dx:Float = (pt1.x*1.0 - pt2.x);
		var dy:Float = (pt1.y*1.0 - pt2.y);
		return (dx*dx + dy*dy);
	}
	//------------------------------------------------------------------------------

	private static function ClosestPointOnLine(pt:Point,linePt1:Point,linePt2:Point) : DoublePoint
	{
		var dx:Float = (linePt2.x*1.0 - linePt1.x);
		var dy:Float = (linePt2.y*1.0 - linePt1.y);
		if (dx == 0 && dy == 0)
			return new DoublePoint(linePt1.x, linePt1.y);
		var q:Float = ((pt.x-linePt1.x)*dx + (pt.y-linePt1.y)*dy) / (dx*dx + dy*dy);
		return new DoublePoint(
			(1-q)*linePt1.x + q*linePt2.x,
			(1-q)*linePt1.y + q*linePt2.y);
	}
	//------------------------------------------------------------------------------

	private static function SlopesNearColinear(pt1:Point,pt2:Point,pt3:Point,distSqrd:Float) : Bool {
		if (DistanceSqrd(pt1, pt2) > DistanceSqrd(pt1, pt3)) return false;
		var cpol:DoublePoint = ClosestPointOnLine(pt2, pt1, pt3);
		var dx:Float = pt2.x - cpol.x;
		var dy:Float = pt2.y - cpol.y;
		return (dx*dx + dy*dy) < distSqrd;
	}
	//------------------------------------------------------------------------------

	private static function PointsAreClose(pt1:Point,pt2:Point,distSqrd:Float) : Bool
	{
		var dx:Float = pt1.x*1.0 - pt2.x;
		var dy:Float = pt1.y*1.0 - pt2.y;
		return ((dx * dx) + (dy * dy) <= distSqrd);
	}
	//------------------------------------------------------------------------------

	public static function cleanPolygon(poly:Polygon, distance:Float = 1.415) {
		//distance = proximity in units/pixels below which vertices
		//will be stripped. Default ~= sqrt(2) so when adjacent
		//vertices have both x & y coords within 1 unit, then
		//the second vertex will be stripped.
		var distSqrd = (distance * distance);
		var highI = poly.length -1;
		var result:Polygon = new Polygon();
		while (highI > 0 && PointsAreClose(poly[highI], poly[0], distSqrd)) highI--;
		if (highI < 2) return result;
		var pt:Point = poly[highI];
		var i:Int = 0;
		while( true )
		{
			while (i < highI && PointsAreClose(pt, poly[i], distSqrd)) i+=2;
			var i2 = i;
			while (i < highI && (PointsAreClose(poly[i], poly[i + 1], distSqrd) ||
				SlopesNearColinear(pt, poly[i], poly[i + 1], distSqrd))) i++;
			if (i >= highI) break;
			else if (i != i2) continue;
			pt = poly[i++];
			result.addPoint(pt);
		}
		if (i <= highI) result.addPoint(poly[i]);
		i = result.length;
		if (i > 2 && SlopesNearColinear(result[i - 2], result[i - 1], result[0], distSqrd))
			result.removeAt(i -  1);
		if (result.length < 3) result = new Polygon([]) /*clear*/;
		return result;
	}
	//------------------------------------------------------------------------------

	public static function cleanPolygons(polys:Polygons, ?distance:Float = 1.415)
	{
		return [for( p in polys ) cleanPolygon(p,distance)];
	}

}

//------------------------------------------------------------------------------


