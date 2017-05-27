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
* "IPolygon Offsetting by Computing Winding Numbers"							*
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
import h2d.col.Point;
import h2d.col.IPoint;
import h2d.col.IPolygon;
import h2d.col.IPolygons;

private enum EdgeSide {
	Left;
	Right;
}

private enum Direction {
	RightToLeft;
	LeftToRight;
}

@:allow(hxd.clipper)
private class PolyNode {

	public var parent(default,null) : PolyNode;
	public var childs(default, null) : Array<PolyNode>;
	var polygon : IPolygon;
	var index : Int;
	var jointype : JoinType;
	var endtype : EndType;

	public function new() {
		polygon = new IPolygon([]);
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

	public var contour(get, never) : IPolygon;

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

	public function toPolygons(polygons:IPolygons) {
		polygons = [];
		addRec(this, polygons);
	}

	function addRec(polynode:PolyNode,polygons:IPolygons) {
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
		var result = allPolys.length;
		if( result > 0 && childs[0] != allPolys[0] ) result--;
		return result;
    }

}

@:generic
private class Ref<T> {
	public var val : T;
	public inline function new(?v:T) {
		val = v;
	}
}

private class TEdge {
	public var botX : Int;
	public var botY : Int;
	public var currX : Int;
	public var currY : Int;
	public var topX : Int;
	public var topY : Int;
	public var deltaX : Int;
	public var deltaY : Int;
	public var dx : Float;
	public var polyType : PolyType;
	public var side : EdgeSide;
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

	public var top(get, set) : IPoint;
	public var bot(get, set) : IPoint;
	public var curr(get, set) : IPoint;

	inline function get_top() return new IPoint(topX, topY);
	inline function get_bot() return new IPoint(botX, botY);
	inline function get_curr() return new IPoint(currX, currY);

	inline function set_top(p:IPoint) {
		topX = p.x;
		topY = p.y;
		return p;
	}
	inline function set_bot(p:IPoint) {
		botX = p.x;
		botY = p.y;
		return p;
	}
	inline function set_curr(p:IPoint) {
		currX = p.x;
		currY = p.y;
		return p;
	}

	public function new() {
	}
}

private class IntersectNode {
	public var edge1 : TEdge;
	public var edge2 : TEdge;
	public var pt : IPoint;
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
	public var pt : IPoint;
	public var next : OutPt;
	public var prev : OutPt;
	public function new() {
	}
}

private class Join {
	public var outPt1 : OutPt;
	public var outPt2 : OutPt;
	public var offPt : IPoint;
	public function new() {
	}
}


//------------------------------------------------------------------------------

@:noDebug
@:allow(hxd.clipper)
private class ClipperBase
{
	static inline var HORIZONTAL = -9007199254740992.; // -2^53, big enough for JS
	static inline var TOLERANCE = 1E-20;
	static inline var SKIP = -2;
	static inline var UNASSIGNED = -1;

	public var preserveCollinear : Bool;

	var m_MinimaList : LocalMinima;
	var m_CurrentLM : LocalMinima;
	var m_edges : Array<Array<TEdge>>;

	//------------------------------------------------------------------------------
	public inline function isHorizontal(e : TEdge) {
		return e.deltaY == 0;
	}

	inline function abs(i:Int):Int {
		return i < 0 ? -i : i;
	}

	public static inline function nearZero (v : Float) : Bool {
		return v > -TOLERANCE && v < TOLERANCE;
	}

	//------------------------------------------------------------------------------

	function PointIsVertex(pt:IPoint, pp:OutPt) {
		var pp2 = pp;
		do {
			if( equals(pp2.pt, pt) ) return true;
			pp2 = pp2.next;
		} while (pp2 != pp);
		return false;
	}
	//------------------------------------------------------------------------------

	function PointOnLineSegment(pt:IPoint, linePt1:IPoint, linePt2:IPoint) {
		return ((pt.x == linePt1.x) && (pt.y == linePt1.y)) ||
			((pt.x == linePt2.x) && (pt.y == linePt2.y)) ||
			(((pt.x > linePt1.x) == (pt.x < linePt2.x)) &&
			((pt.y > linePt1.y) == (pt.y < linePt2.y)) &&
			((pt.x - linePt1.x) * (linePt2.y - linePt1.y) == (linePt2.x - linePt1.x) * (pt.y - linePt1.y)));
	}
	//------------------------------------------------------------------------------

	function PointOnPolygon(pt:IPoint, pp:OutPt)
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

	inline function SlopesEqual(e1:TEdge, e2:TEdge) {
		return e1.deltaY * e2.deltaX == e1.deltaX * e2.deltaY;
	}
	//------------------------------------------------------------------------------

	inline function SlopesEqual3(pt1:IPoint, pt2:IPoint, pt3:IPoint) {
		return (pt1.y - pt2.y) * (pt2.x - pt3.x) - (pt1.x - pt2.x) * (pt2.y - pt3.y) == 0;
	}

	//------------------------------------------------------------------------------

	function new()
	{
		m_edges = [];
		m_MinimaList = null;
		m_CurrentLM = null;
	}

	//------------------------------------------------------------------------------

	public function clear()
	{
		disposeLocalMinimaList();
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

	public function addPolygons(ppg:IPolygons, polyType:PolyType)
	{
		var result = false;
		for ( p in ppg)
			if (addPolygon(p, polyType)) result = true;
		return result;
	}
	//------------------------------------------------------------------------------

	public function addPolygon(pg:IPolygon, polyType:PolyType)
	{
		var highI = pg.length - 1;
		while(highI > 0 && pg[highI] == pg[0]) highI--;
		while(highI > 0 && pg[highI] == pg[highI - 1]) highI--;
		if(highI < 2) return false;

		//create a new edge array
		var edges = [];
		for( i in 0...highI + 1)
			edges.push(new TEdge());

		//basic edge initialization
		var isFlat = true;
		edges[1].curr = pg[1];
		InitEdge(edges[0], edges[1], edges[highI], pg[0]);
		InitEdge(edges[highI], edges[0], edges[highI - 1], pg[highI]);
		var i = highI - 1;
		while(i > 0) {
			InitEdge(edges[i], edges[i + 1], edges[i - 1], pg[i]);
			i--;
		}

		//remove duplicate vertices and collinear edges
		var eStart = edges[0];
		var eStop = eStart;
		var e = eStart;
		while(true) {
			if(e.currX == e.next.currX && e.currY == e.next.currY) {
				if(e == e.next) break;
				if(e == eStart)	eStart = e.next;
				e = RemoveEdge(e);
				eStop = e;
				continue;
			}

			if(e.prev == e.next) break; //only two vertices
			if(SlopesEqual3(e.prev.curr, e.curr, e.next.curr) && (!preserveCollinear || !Pt2IsBetweenPt1AndPt3(e.prev.curr, e.curr, e.next.curr))) {
				//the default is to merge adjacent collinear edges into a single edge.
				//However, if the PreserveCollinear property is enabled, only overlapping
				//collinear edges (ie spikes) will be removed from polygons.
				if(e == eStart) eStart = e.next;
				e = RemoveEdge(e);
				e = e.prev;
				eStop = e;
				continue;
			}

			e = e.next;
			if(e == eStop) break;
		}

		if(e.prev == e.next)
			return false;

		//do second part of edge initialization
		e = eStart;
		do {
			InitEdge2(e, polyType);
			e = e.next;
			if(e.currY != eStart.currY)
				isFlat = false;
		}
		while(e != eStart);

		if(isFlat)
			return false;

		//add edge bounds to LocalMinima list ...
		m_edges.push(edges);
		var leftBoundIsForward : Bool;
		var eMin = null;

		//workaround to avoid an endless loop in the while loop below when
		//open paths have matching start and end points ...
		if (e.prev.botX == e.prev.topX && e.prev.botY == e.prev.topY) e = e.next;

		var old = null;
		while(true) {
			e = FindNextLocMin(e);
			if(e == eMin) break;
			else if (eMin == null) eMin = e;

			if(e == old) throw("!");
			old = e;

			//e and e.prev now share a local minima (left aligned if horizontal).
			//Compare their slopes to find which starts which bound ...
			var locMin = new LocalMinima();
			locMin.next = null;
			locMin.y = e.botY;
			if(e.dx < e.prev.dx) {
				locMin.leftBound = e.prev;
				locMin.rightBound = e;
				leftBoundIsForward = false;
			}
			else {
				locMin.leftBound = e;
				locMin.rightBound = e.prev;
				leftBoundIsForward = true;
			}

			locMin.leftBound.side = EdgeSide.Left;
			locMin.rightBound.side = EdgeSide.Right;
			if (locMin.leftBound.next == locMin.rightBound)
			  locMin.leftBound.windDelta = -1;
			else locMin.leftBound.windDelta = 1;
			locMin.rightBound.windDelta = -locMin.leftBound.windDelta;

			e = ProcessBound(locMin.leftBound, leftBoundIsForward);
			if(e.outIdx == SKIP) e = ProcessBound(e, leftBoundIsForward);

			var e2 = ProcessBound(locMin.rightBound, !leftBoundIsForward);
			if(e2.outIdx == SKIP) e2 = ProcessBound(e2, !leftBoundIsForward);

			if(locMin.leftBound.outIdx == SKIP)
				locMin.leftBound = null;
			else if(locMin.rightBound.outIdx == SKIP)
				locMin.rightBound = null;
			InsertLocalMinima(locMin);
			if(!leftBoundIsForward)
				e = e2;
		}

		return true;
	}
	//------------------------------------------------------------------------------

	inline function InitEdge(e:TEdge, eNext:TEdge, ePrev:TEdge, pt:IPoint) {
      e.next = eNext;
      e.prev = ePrev;
      e.currX = pt.x;
	  e.currY = pt.y;
      e.outIdx = UNASSIGNED;
	}

	inline function InitEdge2(e:TEdge, polyType : PolyType ) {
      if (e.currY >= e.next.currY) {
        e.botX = e.currX;
		e.botY = e.currY;
        e.topX = e.next.currX;
		e.topY = e.next.currY;
      }
      else {
        e.topX = e.currX;
		e.topY = e.currY;
        e.botX = e.next.currX;
		e.botY = e.next.currY;
      }
      SetDx(e);
      e.polyType = polyType;
    }

	//------------------------------------------------------------------------------

	function RemoveEdge(e : TEdge) {
      //removes e from double_linked_list (but without removing from memory)
      e.prev.next = e.next;
      e.next.prev = e.prev;
      var result = e.next;
      e.prev = null; //flag as removed (see ClipperBase.Clear)
      return result;
    }

    //------------------------------------------------------------------------------

    function FindNextLocMin(e : TEdge)  {
		var e2 : TEdge;

		while(true) {
			while (e.botX != e.prev.botX || e.botY != e.prev.botY || (e.currX == e.topX && e.currY == e.topY)) e = e.next;
			if (e.dx != HORIZONTAL && e.prev.dx != HORIZONTAL) break;
			while (e.prev.dx == HORIZONTAL) e = e.prev;
			e2 = e;
			while (e.dx == HORIZONTAL) e = e.next;
			if (e.topY == e.prev.botY) continue; //ie just an intermediate horz.
			if (e2.prev.botX < e.botX) e = e2;
			break;
		}
		return e;
    }

	//------------------------------------------------------------------------------

	function ProcessBound(E : TEdge, LeftBoundIsForward : Bool) {
		var EStart : TEdge;
		var Horz : TEdge;
		var Result = E;

		if (Result.outIdx == SKIP)
		{
			//check if there are edges beyond the skip edge in the bound and if so
			//create another LocMin and calling ProcessBound once more ...
			E = Result;
			if (LeftBoundIsForward) {
				while (E.topY == E.next.botY) E = E.next;
				while (E != Result && E.dx == HORIZONTAL) E = E.prev;
			}
			else {
				while (E.topY == E.prev.botY) E = E.prev;
				while (E != Result && E.dx == HORIZONTAL) E = E.next;
			}
			if (E == Result)
			{
				if (LeftBoundIsForward) Result = E.next;
				else Result = E.prev;
			}
			else
			{
				//there are more edges in the bound beyond result starting with E
				if (LeftBoundIsForward)
					E = Result.next;
				else E = Result.prev;
				var locMin = new LocalMinima();
				locMin.next = null;
				locMin.y = E.botY;
				locMin.leftBound = null;
				locMin.rightBound = E;
				E.windDelta = 0;
				Result = ProcessBound(E, LeftBoundIsForward);
				InsertLocalMinima(locMin);
			}
			return Result;
		}

		if (E.dx == HORIZONTAL)
		{
			//We need to be careful with open paths because this may not be a
			//true local minima (ie E may be following a skip edge).
			//Also, consecutive horz. edges may start heading left before going right.
			if (LeftBoundIsForward) EStart = E.prev;
			else EStart = E.next;
			if (EStart.outIdx != SKIP)
			{
				if (EStart.dx == HORIZONTAL) //ie an adjoining horizontal skip edge
				{
					if (EStart.botX != E.botX && EStart.topX != E.botX)
						ReverseHorizontal(E);
				}
				else if (EStart.botX != E.botX)
					ReverseHorizontal(E);
			}
		}

		EStart = E;
		if (LeftBoundIsForward)
		{
			while (Result.topY == Result.next.botY && Result.next.outIdx != SKIP)
				Result = Result.next;
			if (Result.dx == HORIZONTAL && Result.next.outIdx != SKIP)
			{
				//nb: at the top of a bound, horizontals are added to the bound
				//only when the preceding edge attaches to the horizontal's left vertex
				//unless a Skip edge is encountered when that becomes the top divide
				Horz = Result;
				while (Horz.prev.dx == HORIZONTAL) Horz = Horz.prev;
				if (Horz.prev.topX == Result.next.topX)
				{
					if (!LeftBoundIsForward) Result = Horz.prev;
				}
				else if (Horz.prev.topX > Result.next.topX) Result = Horz.prev;
			}
			while (E != Result)
			{
				E.nextInLML = E.next;
				if (E.dx == HORIZONTAL && E != EStart && E.botX != E.prev.topX)
					ReverseHorizontal(E);
				E = E.next;
			}
			if (E.dx == HORIZONTAL && E != EStart && E.botX != E.prev.topX)
				ReverseHorizontal(E);
			Result = Result.next; //move to the edge just beyond current bound
		}
		else
		{
		while (Result.topY == Result.prev.botY && Result.prev.outIdx != SKIP)
		  Result = Result.prev;
		if (Result.dx == HORIZONTAL && Result.prev.outIdx != SKIP)
		{
		  Horz = Result;
		  while (Horz.next.dx == HORIZONTAL) Horz = Horz.next;
		  if (Horz.next.topX == Result.prev.topX)
		  {
			if (!LeftBoundIsForward) Result = Horz.next;
		  }
		  else if (Horz.next.topX > Result.prev.topX) Result = Horz.next;
		}

		while (E != Result)
		{
		  E.nextInLML = E.prev;
		  if (E.dx == HORIZONTAL && E != EStart && E.botX != E.next.topX)
			ReverseHorizontal(E);
		  E = E.prev;
		}
		if (E.dx == HORIZONTAL && E != EStart && E.botX != E.next.topX)
			ReverseHorizontal(E);
		Result = Result.prev; //move to the edge just beyond current bound
		}
		return Result;
    }

	//------------------------------------------------------------------------------

	function ReverseHorizontal(e : TEdge)
    {
		//swap horizontal edges' top and bottom x's so they follow the natural
		//progression of the bounds - ie so their xbots will align with the
		//adjoining lower edge. [Helpful in the ProcessHorizontal() method.]
		var tmp = e.topX;
		e.topX = e.botX;
		e.botX = tmp;
	}

    //------------------------------------------------------------------------------

    function Pt2IsBetweenPt1AndPt3(pt1 : IPoint, pt2 : IPoint, pt3 : IPoint) {
      if (equals(pt1, pt3) || equals(pt1, pt2) || equals(pt3,  pt2)) return false;
      else if (pt1.x != pt3.x) return (pt2.x > pt1.x) == (pt2.x < pt3.x);
      else return (pt2.y > pt1.y) == (pt2.y < pt3.y);
    }

    //------------------------------------------------------------------------------

	private function SetDx(e:TEdge)
	{
		e.deltaX = (e.topX - e.botX);
		e.deltaY = (e.topY - e.botY);
		if (e.deltaY == 0) e.dx = HORIZONTAL;
		else e.dx = e.deltaX / e.deltaY;
	}
	//---------------------------------------------------------------------------


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
			while( tmpLm.next != null && ( newLm.y < tmpLm.next.y ) )
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

	private inline function SwapX(e:TEdge)
	{
		//swap ClipperBase.HORIZONTAL edges' top and bottom x's so they follow the natural
		//progression of the bounds - ie so their xbots will align with the
		//adjoining lower edge. [Helpful in the ProcessHorizontal() method.]
		e.currX = e.topX;
		e.topX = e.botX;
		e.botX = e.currX;
	}
	//------------------------------------------------------------------------------


	inline function equals(pt1 : IPoint, pt2 : IPoint) {
		return pt1.x == pt2.x && pt1.y == pt2.y;
	}

	function Reset()
	{
		m_CurrentLM = m_MinimaList;

		//reset all edges
		var lm = m_MinimaList;
		while (lm != null)
		{
			var e = lm.leftBound;
			if (e != null)
			{
				e.currX = e.botX;
				e.currY = e.botY;
				e.side = EdgeSide.Left;
				e.outIdx = UNASSIGNED;
				e = e.nextInLML;
			}
			e = lm.rightBound;
			if (e != null)
			{
				e.currX = e.botX;
				e.currY = e.botY;
				e.side = EdgeSide.Right;
				e.outIdx = UNASSIGNED;
				e = e.nextInLML;
			}
			lm = lm.next;
		}
		return;
	}
	//------------------------------------------------------------------------------

	public static function getBounds(pols : IPolygons) {
		var result = new Rect();
		var i = 0;
		var count = pols.length;
		while(i < count && pols[i].length == 0) i++;
		if(i == count) result;

		result.left = result.right = pols[i][0].x;
		result.top = result.bottom = pols[i][0].y;
		for( i in 0...count)
			for(p in pols[i]) {
				if(p.x < result.left) result.left = p.x;
				else if(p.x > result.right) result.right = p.x;
				if(p.y < result.top) result.top = p.y;
				else if(p.y > result.bottom) result.bottom = p.y;
			}

		return result;
	}

} //ClipperBase




enum NodeType {
	Any;
	Open;
	Closed;
}

enum ResultKind {
	All;
	NoHoles;
	HolesOnly;
}

@:noDebug
@:allow(hxd.clipper)
class Clipper extends ClipperBase {

	public var strictlySimple : Bool;
	public var reverseSolution : Bool;
	public var resultKind : ResultKind;

	var m_PolyOuts : Array<OutRec>;
	var m_ClipType : ClipType;
	var m_Scanbeam : Scanbeam;
	var m_ActiveEdges : TEdge;
	var m_SortedEdges : TEdge;
	var m_IntersectList : Array<IntersectNode>;
	var m_ExecuteLocked : Bool;
	var m_ClipFillType : PolyFillType;
	var m_SubjFillType : PolyFillType;
	var m_Joins : Array<Join>;
	var m_GhostJoins : Array<Join>;
	var m_UsingPolyTree : Bool;

	public function new()
	{
		super();
		m_Scanbeam = null;
		m_ActiveEdges = null;
		m_SortedEdges = null;
		m_IntersectList = [];
		m_ExecuteLocked = false;
		m_UsingPolyTree = false;
		m_PolyOuts = [];
		m_Joins = [];
		m_GhostJoins = [];

		reverseSolution = false;
		strictlySimple = false;
		preserveCollinear = false;
		resultKind = All;
	}

	inline function xor(a, b) {
		return if( a ) !b else b;
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

		var lm = m_MinimaList;
		while (lm != null)
		{
			InsertScanbeam(lm.y);
			lm = lm.next;
		}
	}

	//------------------------------------------------------------------------------

	private function InsertScanbeam(y:Int)
	{
		if( m_Scanbeam == null ) {
			m_Scanbeam = new Scanbeam();
			m_Scanbeam.next = null;
			m_Scanbeam.y = y;
		}
		else if( y > m_Scanbeam.y )	{
			var newSb = new Scanbeam();
			newSb.y = y;
			newSb.next = m_Scanbeam;
			m_Scanbeam = newSb;
		} else {
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

	public function execute(clipType:ClipType, ?subjFillType, ?clipFillType)
	{
		if( subjFillType == null ) subjFillType = PolyFillType.EvenOdd;
		if( clipFillType == null ) clipFillType = PolyFillType.EvenOdd;
		if (m_ExecuteLocked) return [];

		m_ExecuteLocked = true;
		var solution = [];

		m_SubjFillType = subjFillType;
		m_ClipFillType = clipFillType;
		m_ClipType = clipType;
		m_UsingPolyTree = false;

		var succeeded = ExecuteInternal();
		if (succeeded) solution = BuildResult();

		DisposeAllPolyPts();
		m_ExecuteLocked = false;

		return solution;
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

	private function ExecuteInternal() {
		Reset();
		if (m_CurrentLM == null) return false;
		var botY = PopScanbeam();
		do
		{
			InsertLocalMinimaIntoAEL(botY);
			if( m_GhostJoins.length > 0 ) m_GhostJoins = [];
			ProcessHorizontals(false);
			if(m_Scanbeam == null) break;

			var topY = PopScanbeam();
			if(!ProcessIntersections(topY)) return false;
			ProcessEdgesAtTopOfScanbeam(topY);
			botY = topY;

		} while (m_Scanbeam != null || m_CurrentLM != null);

		//fix orientations ...
		for( outRec in m_PolyOuts ) {
			if(outRec.pts == null) continue;
			if (xor(outRec.isHole, reverseSolution) == (Area(outRec) > 0))
				ReversePolyPtLinks(outRec.pts);
		}

		JoinCommonEdges();

		for( outRec in m_PolyOuts )
			if(outRec.pts != null)
				FixupOutPolygon(outRec);

		if(strictlySimple)
			DoSimplePolygons();


		m_Joins = [];
		m_GhostJoins = [];

		return true;
	}
	//------------------------------------------------------------------------------

	private function PopScanbeam() : Int
	{
		var y = m_Scanbeam.y;
		m_Scanbeam = m_Scanbeam.next;
		return y;
	}
	//------------------------------------------------------------------------------

	private function DisposeAllPolyPts() {
		for ( i in 0...m_PolyOuts.length )
			DisposeOutRec(i);
		m_PolyOuts = [];
	}

	//------------------------------------------------------------------------------

	function DisposeOutRec(index:Int) {
		var outRec = m_PolyOuts[index];
		outRec.pts = null;
		outRec = null;
		m_PolyOuts[index] = null;
	}

	//------------------------------------------------------------------------------

	private function AddJoin(op1:OutPt, op2:OutPt, offPt:IPoint) {
		var j = new Join();
		j.outPt1 = op1;
		j.outPt2 = op2;
		j.offPt = offPt;
		m_Joins.push(j);
	}

	//------------------------------------------------------------------------------

	private function AddGhostJoin(op : OutPt, offPt : IPoint) {
		var j = new Join();
		j.outPt1 = op;
		j.offPt = offPt;
		m_GhostJoins.push(j);
	}

	//------------------------------------------------------------------------------

	private function InsertLocalMinimaIntoAEL(botY:Int) {

		while(	m_CurrentLM != null	&& ( m_CurrentLM.y == botY ) )
		{
			var lb:TEdge = m_CurrentLM.leftBound;
			var rb:TEdge = m_CurrentLM.rightBound;
			PopLocalMinima();

			var op1 = null;

			if(lb == null) {
				InsertEdgeIntoAEL(rb);
				SetWindingCount(rb);
				if(IsContributing(rb))
					op1 = AddOutPt(rb, rb.bot);
			}
			else if(rb == null) {
				InsertEdgeIntoAEL(lb);
				SetWindingCount(lb);
				if(IsContributing(lb))
					op1 = AddOutPt(lb, lb.bot);
				InsertScanbeam(lb.topY);
			}
			else {
				InsertEdgeIntoAEL(lb);
				InsertEdgeIntoAEL(rb, lb);

				SetWindingCount(lb);

				rb.windCnt = lb.windCnt;
				rb.windCnt2 = lb.windCnt2;

				if(IsContributing(lb))
					op1 = AddLocalMinPoly(lb, rb, lb.bot);

				InsertScanbeam(lb.topY);
			}

			if(rb != null) {
				if(isHorizontal(rb))
					AddEdgeToSEL(rb);
				else InsertScanbeam(rb.topY);
			}

			if(lb == null || rb == null) continue;

			//if output polygons share an Edge with a horizontal rb, they'll need joining later ...
			if(op1 != null && isHorizontal(rb) && m_GhostJoins.length > 0 && rb.windDelta != 0) {
				for(j in m_GhostJoins) {
					//if the horizontal Rb and a 'ghost' horizontal overlap, then convert
					//the 'ghost' join to a real join ready for later ...
					if(HorzSegmentsOverlap(j.outPt1.pt.x, j.offPt.x, rb.botX, rb.topX))
						AddJoin(j.outPt1, op1, j.offPt);
				}
			}

			if(lb.outIdx >= 0 && lb.prevInAEL != null && lb.prevInAEL.currX == lb.botX && lb.prevInAEL.outIdx >= 0 && SlopesEqual(lb.prevInAEL, lb) && lb.windDelta != 0 && lb.prevInAEL.windDelta != 0) {
				var op2 = AddOutPt(lb.prevInAEL, lb.bot);
				AddJoin(op1, op2, lb.top);
			}

			if(lb.nextInAEL != rb) {
				if(rb.outIdx >= 0 && rb.prevInAEL.outIdx >= 0 && SlopesEqual(rb.prevInAEL, rb) && rb.windDelta != 0 && rb.prevInAEL.windDelta != 0) {
					var op2 = AddOutPt(rb.prevInAEL, rb.bot);
					AddJoin(op1, op2, rb.top);
				}

				var e = lb.nextInAEL;
				if(e != null)
					while(e != rb) {
						//nb: For calculating winding counts etc, IntersectEdges() assumes
						//that param1 will be to the right of param2 ABOVE the intersection ...
						IntersectEdges(rb, e, lb.curr); //order important here
						e = e.nextInAEL;
					}
			}
		}
	}
	//------------------------------------------------------------------------------

	private function InsertEdgeIntoAEL(edge:TEdge, startEdge : TEdge = null)
	{
		if (m_ActiveEdges == null)
		{
			edge.prevInAEL = null;
			edge.nextInAEL = null;
			m_ActiveEdges = edge;
		}
		else if( startEdge == null && E2InsertsBeforeE1(m_ActiveEdges, edge) ) {
			edge.prevInAEL = null;
			edge.nextInAEL = m_ActiveEdges;
			m_ActiveEdges.prevInAEL = edge;
			m_ActiveEdges = edge;
		}
		else {
			if(startEdge == null)
				startEdge = m_ActiveEdges;
			while (startEdge.nextInAEL != null && !E2InsertsBeforeE1(startEdge.nextInAEL, edge))
				startEdge = startEdge.nextInAEL;

			edge.nextInAEL = startEdge.nextInAEL;
			if (startEdge.nextInAEL != null) startEdge.nextInAEL.prevInAEL = edge;
			edge.prevInAEL = startEdge;
			startEdge.nextInAEL = edge;
		}
	}
	//----------------------------------------------------------------------

	private function E2InsertsBeforeE1(e1:TEdge,e2:TEdge) : Bool
	{
		if (e2.currX == e1.currX)
		{
			if (e2.topY > e1.topY)
				return e2.topX < TopX(e1, e2.topY);
			else return e1.topX > TopX(e2, e1.topY);
		}
		else return e2.currX < e1.currX;
	}
	//------------------------------------------------------------------------------

	private inline function IsEvenOddFillType(edge:TEdge) : Bool
	{
		if (edge.polyType == PolyType.Subject)
			return m_SubjFillType == PolyFillType.EvenOdd;
		else
			return m_ClipFillType == PolyFillType.EvenOdd;
	}
	//------------------------------------------------------------------------------

	private inline function IsEvenOddAltFillType(edge:TEdge) : Bool
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
				if (edge.windDelta == 0 && edge.windCnt != 1) return false;
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
					case PolyFillType.EvenOdd, PolyFillType.NonZero:
						return (edge.windCnt2 != 0);
					case PolyFillType.Positive:
						return (edge.windCnt2 > 0);
					default:
						return (edge.windCnt2 < 0);
				}
			case ClipType.Union:
				switch (pft2)
				{
					case PolyFillType.EvenOdd, PolyFillType.NonZero:
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
						case PolyFillType.EvenOdd, PolyFillType.NonZero:
							return (edge.windCnt2 == 0);
						case PolyFillType.Positive:
							return (edge.windCnt2 <= 0);
						default:
							return (edge.windCnt2 >= 0);
					}
				else
					switch (pft2)
					{
						case PolyFillType.EvenOdd, PolyFillType.NonZero:
							return (edge.windCnt2 != 0);
						case PolyFillType.Positive:
							return (edge.windCnt2 > 0);
						default:
							return (edge.windCnt2 < 0);
					}
			case ClipType.Xor:
				if (edge.windDelta == 0) //XOr always contributing unless open
                  switch (pft2)
                  {
                    case PolyFillType.EvenOdd, PolyFillType.NonZero:
                      return (edge.windCnt2 == 0);
                    case PolyFillType.Positive:
                      return (edge.windCnt2 <= 0);
                    default:
                      return (edge.windCnt2 >= 0);
                  }
                else
                  return true;
		}
		return true;
	}
	//------------------------------------------------------------------------------

	private function SetWindingCount(edge:TEdge) {
		var e = edge.prevInAEL;
		//find the edge of the same polytype that immediately preceeds 'edge' in AEL
		while (e != null && ((e.polyType != edge.polyType) || (e.windDelta == 0))) e = e.prevInAEL;
		if (e == null) {
			edge.windCnt = (edge.windDelta == 0 ? 1 : edge.windDelta);
			edge.windCnt2 = 0;
			e = m_ActiveEdges; //ie get ready to calc windCnt2
		} else if (edge.windDelta == 0 && m_ClipType != ClipType.Union) {
			edge.windCnt = 1;
			edge.windCnt2 = e.windCnt2;
			e = e.nextInAEL; //ie get ready to calc windCnt2
		} else if (IsEvenOddFillType(edge)) {
			//EvenOdd filling ...
			if (edge.windDelta == 0) {
				//are we inside a subj polygon ...
				var Inside = true;
				var e2 = e.prevInAEL;
				while (e2 != null) {
					if (e2.polyType == e.polyType && e2.windDelta != 0)
						Inside = !Inside;
					e2 = e2.prevInAEL;
				}
				edge.windCnt = (Inside ? 0 : 1);
			} else
				edge.windCnt = edge.windDelta;
			edge.windCnt2 = e.windCnt2;
			e = e.nextInAEL; //ie get ready to calc windCnt2
		} else {
			//nonZero, Positive or Negative filling ...
			if (e.windCnt * e.windDelta < 0) {
				//prev edge is 'decreasing' WindCount (WC) toward zero
				//so we're outside the previous polygon ...
				if (e.windCnt > 1 || e.windCnt < -1) {
					//outside prev poly but still inside another.
					//when reversing direction of prev poly use the same WC
					if (e.windDelta * edge.windDelta < 0) edge.windCnt = e.windCnt;
					//otherwise continue to 'decrease' WC ...
					else edge.windCnt = e.windCnt + edge.windDelta;
				} else
					//now outside all polys of same polytype so set own WC ...
					edge.windCnt = (edge.windDelta == 0 ? 1 : edge.windDelta);
			} else {
				//prev edge is 'increasing' WindCount (WC) away from zero
				//so we're inside the previous polygon ...
				if (edge.windDelta == 0)
					edge.windCnt = (e.windCnt < 0 ? e.windCnt - 1 : e.windCnt + 1);
				//if wind direction is reversing prev then use same WC
				else if (e.windDelta * edge.windDelta < 0)
					edge.windCnt = e.windCnt;
				//otherwise add to WC ...
				else edge.windCnt = e.windCnt + edge.windDelta;
			}
			edge.windCnt2 = e.windCnt2;
			e = e.nextInAEL; //ie get ready to calc windCnt2
		}

		//update windCnt2 ...
		if (IsEvenOddAltFillType(edge)) {
			//EvenOdd filling ...
			while (e != edge) {
				if (e.windDelta != 0)
					edge.windCnt2 = (edge.windCnt2 == 0 ? 1 : 0);
				e = e.nextInAEL;
			}
		} else {
			//nonZero, Positive or Negative filling ...
			while (e != edge) {
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

	private inline function CopyAELToSEL()
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

	private function SwapPositionsInAEL(edge1:TEdge, edge2:TEdge) {
        //check that one or other edge hasn't already been removed from AEL ...
          if (edge1.nextInAEL == edge1.prevInAEL ||
            edge2.nextInAEL == edge2.prevInAEL) return;

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


	private function AddLocalMaxPoly(e1:TEdge,e2:TEdge,pt:IPoint)
	{
		AddOutPt(e1, pt);
		if (e2.windDelta == 0) AddOutPt(e2, pt);
		if (e1.outIdx == e2.outIdx)
		{
			e1.outIdx = ClipperBase.UNASSIGNED;
			e2.outIdx = ClipperBase.UNASSIGNED;
		}
		else if (e1.outIdx < e2.outIdx)
			AppendPolygon(e1, e2);
		else AppendPolygon(e2, e1);
	}
	//------------------------------------------------------------------------------

	private function AddLocalMinPoly(e1:TEdge,e2:TEdge,pt:IPoint)
	{
		var result : OutPt;
		var e, prevE : TEdge;

		if( isHorizontal(e2) || (e1.dx > e2.dx))
		{
			result = AddOutPt(e1, pt);
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
			result = AddOutPt(e2, pt);
			e1.outIdx = e2.outIdx;
			e1.side = EdgeSide.Right;
			e2.side = EdgeSide.Left;
			e = e2;
			if (e.prevInAEL == e1)
				prevE = e1.prevInAEL;
			else
				prevE = e.prevInAEL;
		}

		if (prevE != null && prevE.outIdx >= 0 && (TopX(prevE, pt.y) == TopX(e, pt.y)) && SlopesEqual(e, prevE) && (e.windDelta != 0) && (prevE.windDelta != 0)) {
			var out = AddOutPt(prevE, pt);
			AddJoin(result, out, e.top);
		}
		return result;
	}
	//------------------------------------------------------------------------------

	private function CreateOutRec() : OutRec
	{
		var result:OutRec = new OutRec();
		result.idx = ClipperBase.UNASSIGNED;
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

	private function AddOutPt(e:TEdge,pt:IPoint)
	{
		var ToFront = (e.side == EdgeSide.Left);

		if(	e.outIdx < 0 )
		{
			var outRec = CreateOutRec();
			var op = new OutPt();
			outRec.pts = op;
			op.idx = outRec.idx;
			op.pt = pt.clone();
			op.next = op;
			op.prev = op;
			SetHoleState(e, outRec);
			e.outIdx = outRec.idx; //nb: do this after SetZ !
			return op;
		} else
		{
			var outRec = m_PolyOuts[e.outIdx];
			var op:OutPt = outRec.pts;
			if (ToFront && equals(pt, op.pt)) return op;
			else if(!ToFront && equals(pt, op.prev.pt)) return op.prev;

			var op2 = new OutPt();
			op2.idx = outRec.idx;
			op2.pt = pt.clone();
			op2.next = op;
			op2.prev = op.prev;
			op2.prev.next = op2;
			op.prev = op2;
			if (ToFront) outRec.pts = op2;
			return op2;
		}
	}

	//------------------------------------------------------------------------------
	function HorzSegmentsOverlap(seg1a : Int, seg1b : Int, seg2a : Int, seg2b : Int) {
		if (seg1a > seg1b) {
			var tmp = seg1a;
			seg1a = seg1b;
			seg1b = tmp;
		}
        if (seg2a > seg2b) {
			var tmp = seg2a;
			seg2a = seg2b;
			seg2b = tmp;
		}

		return seg1a < seg2b && seg2a < seg1b;
	}
	//------------------------------------------------------------------------------

	private function SetHoleState(e:TEdge,outRec:OutRec)
	{
		var isHole = false;
		var e2 = e.prevInAEL;
		while (e2 != null)
		{
			if (e2.outIdx >= 0 && e2.windDelta != 0)
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

	private function GetDx(pt1:IPoint,pt2:IPoint) : Float
	{
		if (pt1.y == pt2.y) return ClipperBase.HORIZONTAL;
		else return (pt2.x - pt1.x) / (pt2.y - pt1.y);
	}
	//---------------------------------------------------------------------------

	private function FirstIsBottomPt(btmPt1:OutPt,btmPt2:OutPt) : Bool
	{
		var p:OutPt = btmPt1.prev;
		while (equals(p.pt, btmPt1.pt) && (p != btmPt1)) p = p.prev;
		var dx1p = Math.abs(GetDx(btmPt1.pt, p.pt));
		p = btmPt1.next;
		while (equals(p.pt, btmPt1.pt) && (p != btmPt1)) p = p.next;
		var dx1n = Math.abs(GetDx(btmPt1.pt, p.pt));

		p = btmPt2.prev;
		while (equals(p.pt, btmPt2.pt) && (p != btmPt2)) p = p.prev;
		var dx2p = Math.abs(GetDx(btmPt2.pt, p.pt));
		p = btmPt2.next;
		while (equals(p.pt, btmPt2.pt) && (p != btmPt2)) p = p.next;
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
				} else if (p.next != pp && p.prev != pp) dups = p;
			}
			p = p.next;
		}

		if (dups != null)
		{
			var n = 0;
			//there appears to be at least 2 vertices at bottomPt so
			while (dups != p)
			{
				if (!FirstIsBottomPt(p, dups)) pp = dups;
				dups = dups.next;
				while (!equals(dups.pt, pp.pt)) dups = dups.next;
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

		var side : EdgeSide;
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

		e1.outIdx = ClipperBase.UNASSIGNED; //nb: safe because we only get here via AddLocalMaxPoly
		e2.outIdx = ClipperBase.UNASSIGNED;

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

	private inline function SwapSides(edge1:TEdge,edge2:TEdge)
	{
		var side = edge1.side;
		edge1.side = edge2.side;
		edge2.side = side;
	}
	//------------------------------------------------------------------------------

	private function SwapPolyIndexes(edge1:TEdge,edge2:TEdge)
	{
		var outIdx = edge1.outIdx;
		edge1.outIdx = edge2.outIdx;
		edge2.outIdx = outIdx;
	}
	//------------------------------------------------------------------------------

	private function IntersectEdges(e1:TEdge, e2:TEdge, pt:IPoint) {
		//e1 will be to the left of e2 BELOW the intersection. Therefore e1 is before
		//e2 in AEL except when e1 is being inserted at the intersection point

		var e1Contributing = (e1.outIdx >= 0);
		var e2Contributing = (e2.outIdx >= 0);

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

		if (e1Contributing && e2Contributing)
		{
			if ((e1Wc != 0 && e1Wc != 1) || (e2Wc != 0 && e2Wc != 1) ||	(e1.polyType != e2.polyType && m_ClipType != ClipType.Xor))
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
		else if (e2Contributing)
		{
			if (e1Wc == 0 || e1Wc == 1)
			{
				AddOutPt(e2, pt);
				SwapSides(e1, e2);
				SwapPolyIndexes(e1, e2);
			}
		}
		else if ((e1Wc == 0 || e1Wc == 1) && (e2Wc == 0 || e2Wc == 1) )
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
						if (((e1.polyType == PolyType.Clip) && (e1Wc2 > 0) && (e2Wc2 > 0)) || ((e1.polyType == PolyType.Subject) && (e1Wc2 <= 0) && (e2Wc2 <= 0)))
								AddLocalMinPoly(e1, e2, pt);
					case ClipType.Xor:
						AddLocalMinPoly(e1, e2, pt);
				}
			else
				SwapSides(e1, e2);
		}
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
		e.currX = e.botX;
		e.currY = e.botY;
		e.prevInAEL = AelPrev;
		e.nextInAEL = AelNext;
		if (!isHorizontal(e))
			InsertScanbeam(e.topY);
		return e;
	}

    //------------------------------------------------------------------------------

	function GetHorzDirection(HorzEdge : TEdge) {
		if (HorzEdge.botX < HorzEdge.topX)
			return { left : HorzEdge.botX, right : HorzEdge.topX, dir : Direction.LeftToRight };
		else return { left : HorzEdge.topX, right : HorzEdge.botX, dir : Direction.RightToLeft };
	}

	//------------------------------------------------------------------------------

	private function ProcessHorizontals(isTopOfScanbeam : Bool)
	{
		var horzEdge = m_SortedEdges;
		while (horzEdge != null)
		{
			DeleteFromSEL(horzEdge);
			ProcessHorizontal(horzEdge, isTopOfScanbeam);
			horzEdge = m_SortedEdges;
		}
	}
	//------------------------------------------------------------------------------

	function ProcessHorizontal(horzEdge : TEdge, isTopOfScanbeam : Bool ) {
		var res = GetHorzDirection(horzEdge);
		var dir : Direction = res.dir;
		var horzLeft : Int = res.left;
		var horzRight : Int = res.right;

		var eLastHorz = horzEdge;
		var eMaxPair = null;
		while (eLastHorz.nextInLML != null && isHorizontal(eLastHorz.nextInLML))
			eLastHorz = eLastHorz.nextInLML;
		if (eLastHorz.nextInLML == null)
			eMaxPair = GetMaximaPair(eLastHorz);

		while(true) {
			var IsLastHorz = (horzEdge == eLastHorz);
			var e = GetNextInAEL(horzEdge, dir);

			while(e != null) {
				//Break if we've got to the end of an intermediate horizontal edge ...
				//nb: Smaller Dx's are to the right of larger Dx's ABOVE the horizontal.
				if (e.currX == horzEdge.topX && horzEdge.nextInLML != null &&	e.dx < horzEdge.nextInLML.dx) break;

				var eNext = GetNextInAEL(e, dir); //saves eNext for later

				if ((dir == Direction.LeftToRight && e.currX <= horzRight) || (dir == Direction.RightToLeft && e.currX >= horzLeft))
				{
					//so far we're still in range of the horizontal Edge  but make sure
					//we're at the last of consec. horizontals when matching with eMaxPair
					if(e == eMaxPair && IsLastHorz)
					{
						if (horzEdge.outIdx >= 0)
						{
							var op1 = AddOutPt(horzEdge, horzEdge.top);
							var eNextHorz = m_SortedEdges;
							while (eNextHorz != null)
							{
								if (eNextHorz.outIdx >= 0 && HorzSegmentsOverlap(horzEdge.botX, horzEdge.topX, eNextHorz.botX, eNextHorz.topX))	{
									var op2 = AddOutPt(eNextHorz, eNextHorz.bot);
									AddJoin(op2, op1, eNextHorz.top);
								}
								eNextHorz = eNextHorz.nextInSEL;
							}
							AddGhostJoin(op1, horzEdge.bot);
							AddLocalMaxPoly(horzEdge, eMaxPair, horzEdge.top);
						}
						DeleteFromAEL(horzEdge);
						DeleteFromAEL(eMaxPair);
						return;
					}
					else if(dir == Direction.LeftToRight)
					{
						var Pt = new IPoint(e.currX, horzEdge.currY);
						IntersectEdges(horzEdge, e, Pt);
					}
					else
					{
						var Pt = new IPoint(e.currX, horzEdge.currY);
						IntersectEdges(e, horzEdge, Pt);
					}
					SwapPositionsInAEL(horzEdge, e);
				}
				else if ((dir == Direction.LeftToRight && e.currX >= horzRight) ||
				(dir == Direction.RightToLeft && e.currX <= horzLeft))
					break;
				e = eNext;
			} //end while

			if (horzEdge.nextInLML != null && isHorizontal(horzEdge.nextInLML)) {
				horzEdge = UpdateEdgeIntoAEL(horzEdge);
				if (horzEdge.outIdx >= 0) AddOutPt(horzEdge, horzEdge.bot);
				var out = GetHorzDirection(horzEdge);
				dir = out.dir;
				horzLeft = out.left;
				horzRight = out.right;
			} else break;
		}

		if(horzEdge.nextInLML != null)
		{
			if(horzEdge.outIdx >= 0)
			{
				var op1 = AddOutPt( horzEdge, horzEdge.top);
				if (isTopOfScanbeam) AddGhostJoin(op1, horzEdge.bot);

				horzEdge = UpdateEdgeIntoAEL(horzEdge);
				if (horzEdge.windDelta == 0) return;
				//nb: HorzEdge is no longer horizontal here
				var ePrev = horzEdge.prevInAEL;
				var eNext = horzEdge.nextInAEL;
				if (ePrev != null && ePrev.currX == horzEdge.botX && ePrev.currY == horzEdge.botY && ePrev.windDelta != 0 && (ePrev.outIdx >= 0 && ePrev.currY > ePrev.topY && SlopesEqual(horzEdge, ePrev)))
				{
					var op2 = AddOutPt(ePrev, horzEdge.bot);
					AddJoin(op1, op2, horzEdge.top);
				}
				else if (eNext != null && eNext.currX == horzEdge.botX &&	eNext.currY == horzEdge.botY && eNext.windDelta != 0 && eNext.outIdx >= 0 && eNext.currY > eNext.topY && SlopesEqual(horzEdge, eNext))
				{
					var op2 = AddOutPt(eNext, horzEdge.bot);
					AddJoin(op1, op2, horzEdge.top);
				}
			}
			else horzEdge = UpdateEdgeIntoAEL(horzEdge);
		}
		else
		{
			if (horzEdge.outIdx >= 0) AddOutPt(horzEdge, horzEdge.top);
			DeleteFromAEL(horzEdge);
		}
	}

	//------------------------------------------------------------------------------

	private inline function GetNextInAEL(e:TEdge,dir:Direction) : TEdge
	{
		return dir == Direction.LeftToRight ? e.nextInAEL: e.prevInAEL;
	}
	//------------------------------------------------------------------------------

	private inline function IsMinima(e:TEdge) : Bool
	{
		return e != null && (e.prev.nextInLML != e) && (e.next.nextInLML != e);
	}
	//------------------------------------------------------------------------------

	private inline function IsMaxima(e:TEdge,y:Float) : Bool
	{
		return (e != null && e.topY == y && e.nextInLML == null);
	}
	//------------------------------------------------------------------------------

	private inline function IsIntermediate(e:TEdge,y:Float) : Bool
	{
		return (e.topY == y && e.nextInLML != null);
	}
	//------------------------------------------------------------------------------

	private function GetMaximaPair(e:TEdge) : TEdge
	{
		var result = null;
        if ((e.next.topX == e.topX && e.next.topY == e.topY) && e.next.nextInLML == null)
			result = e.next;
        else if ((e.prev.topX == e.topX && e.prev.topY == e.topY) && e.prev.nextInLML == null)
			result = e.prev;
        if (result != null && (result.outIdx == ClipperBase.SKIP || (result.nextInAEL == result.prevInAEL && !isHorizontal(result))))
			return null;
        return result;
	}
	//------------------------------------------------------------------------------

	private function ProcessIntersections(topY:Int) : Bool
	{
		if( m_ActiveEdges == null ) return true;
        //try {
			BuildIntersectList(topY);
			if ( m_IntersectList.length == 0) return true;
			if (m_IntersectList.length == 1 || FixupIntersectionOrder())
				ProcessIntersectList();
			else
				return false;
        /*}
        catch (e : Dynamic) {
			m_SortedEdges = null;
			m_IntersectList = [];
			throw "ProcessIntersections error";
        }*/
        m_SortedEdges = null;
        return true;
	}
	//------------------------------------------------------------------------------

	private function BuildIntersectList(topY:Int)
	{
		if ( m_ActiveEdges == null ) return;



		//prepare for sorting
		var e:TEdge = m_ActiveEdges;
		m_SortedEdges = e;
		while( e != null )
		{
			e.prevInSEL = e.prevInAEL;
			e.nextInSEL = e.nextInAEL;
			e.currX = TopX( e, topY );
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
				var pt;
				if (e.currX > eNext.currX)
				{
					pt = IntersectPoint(e, eNext);
					var newNode = new IntersectNode();
					newNode.edge1 = e;
					newNode.edge2 = eNext;
					newNode.pt = pt;

					m_IntersectList.push(newNode);
					SwapPositionsInSEL(e, eNext);
					isModified = true;
				}
				else e = eNext;
			}
			if( e.prevInSEL != null ) e.prevInSEL.nextInSEL = null;
			else break;
		}
		m_SortedEdges = null;
	}
	//------------------------------------------------------------------------------

	private inline function EdgesAdjacent(inode:IntersectNode) : Bool
	{
		return (inode.edge1.nextInSEL == inode.edge2) ||
		(inode.edge1.prevInSEL == inode.edge2);
	}
	//------------------------------------------------------------------------------

	inline function IntersectNodeSort(node1 : IntersectNode, node2 : IntersectNode)
	{
		//the following typecast is safe because the differences in Pt.y will
		//be limited to the height of the scanbeam.
		return Std.int(node2.pt.y - node1.pt.y);
	}

    //------------------------------------------------------------------------------

	static function compareY(n1:IntersectNode, n2:IntersectNode) return n2.pt.y - n1.pt.y >= 0 ? 1 : -1;

	private function FixupIntersectionOrder() : Bool
	{
		//pre-condition: intersections are sorted bottom-most first.
        //Now it's crucial that intersections are made only between adjacent edges,
        //so to ensure this the order of intersections may need adjusting ...
		m_IntersectList.sort(compareY);

        CopyAELToSEL();
        var cnt = m_IntersectList.length;
        for (i in 0...cnt)
        {
		  if (!EdgesAdjacent(m_IntersectList[i]))
          {
			var j = i + 1;
            while (j < cnt && !EdgesAdjacent(m_IntersectList[j])) j++;
            if (j == cnt) return false;

            var tmp = m_IntersectList[i];
            m_IntersectList[i] = m_IntersectList[j];
            m_IntersectList[j] = tmp;
          }

          SwapPositionsInSEL(m_IntersectList[i].edge1, m_IntersectList[i].edge2);
        }
		return true;
	}
	//------------------------------------------------------------------------------

	private function ProcessIntersectList()
	{
		for (i in 0...m_IntersectList.length) {
			var iNode = m_IntersectList[i];
			{
				IntersectEdges(iNode.edge1, iNode.edge2, iNode.pt);
				SwapPositionsInAEL(iNode.edge1, iNode.edge2);
			}
        }
        m_IntersectList = [];
	}

	//------------------------------------------------------------------------------

	private inline function Round(value:Float) : Int
	{
		return value < 0 ? Std.int(value - 0.5) : Std.int(value + 0.5);
	}
	//------------------------------------------------------------------------------

	private inline function TopX(edge:TEdge,currentY:Int) : Int
	{
		if (currentY == edge.topY)
			return edge.topX;
		return edge.botX + Round(edge.dx *(currentY - edge.botY));
	}

	//------------------------------------------------------------------------------

	inline function IntersectPoint(edge1 : TEdge, edge2 : TEdge)
	{
		var ipx, ipy;
		var b1, b2;
		//nb: with very large coordinate values, it's possible for SlopesEqual() to
		//return false but for the edge.Dx value be equal due to double precision rounding.
		if (edge1.dx == edge2.dx)
		{
			ipy = edge1.currY;
			ipx = TopX(edge1, ipy);
			return new IPoint(ipx,ipy);
		}

		if (edge1.deltaX == 0)
		{
			ipx = edge1.botX;
			if (isHorizontal(edge2))
			{
				ipy = edge2.botY;
			}
			else
			{
				b2 = edge2.botY - (edge2.botX / edge2.dx);
				ipy = Round(ipx / edge2.dx + b2);
			}
		}
		else if (edge2.deltaX == 0)
		{
			ipx = edge2.botX;
			if (isHorizontal(edge1))
			{
				ipy = edge1.botY;
			}
			else
			{
				b1 = edge1.botY - (edge1.botX / edge1.dx);
				ipy = Round(ipx / edge1.dx + b1);
			}
		}
		else
		{
			b1 = edge1.botX - edge1.botY * edge1.dx;
			b2 = edge2.botX - edge2.botY * edge2.dx;
			var q = (b2 - b1) / (edge1.dx - edge2.dx);
			ipy = Round(q);
			if (Math.abs(edge1.dx) < Math.abs(edge2.dx))
				ipx = Round(edge1.dx * q + b1);
			else
				ipx = Round(edge2.dx * q + b2);
		}

		if (ipy < edge1.topY || ipy < edge2.topY)
		{
			if (edge1.topY > edge2.topY)
				ipy = edge1.topY;
			else
				ipy = edge2.topY;
			if (Math.abs(edge1.dx) < Math.abs(edge2.dx))
				ipx = TopX(edge1, ipy);
			else
				ipx = TopX(edge2, ipy);
		}
		//finally, don't allow 'ip' to be BELOW curr.y (ie bottom of scanbeam) ...
		if (ipy > edge1.currY)
		{
			ipy = edge1.currY;
			//better to use the more vertical edge to derive X ...
			if (Math.abs(edge1.dx) > Math.abs(edge2.dx))
				ipx = TopX(edge2, ipy);
			else
				ipx = TopX(edge1, ipy);
		}

		return new IPoint(ipx,ipy);
	}
	//------------------------------------------------------------------------------

	function ProcessEdgesAtTopOfScanbeam(topY : Int) {
		var e = m_ActiveEdges;

		while(e != null)
		{
			//1. process maxima, treating them as if they're 'bent' horizontal edges,
			//   but exclude maxima with horizontal edges. nb: e can't be a horizontal.
			var IsMaximaEdge = IsMaxima(e, topY);

			if(IsMaximaEdge)
			{
				var eMaxPair = GetMaximaPair(e);
				IsMaximaEdge = (eMaxPair == null || !isHorizontal(eMaxPair));
			}

			if(IsMaximaEdge)
			{
				var ePrev = e.prevInAEL;
				DoMaxima(e);
				if( ePrev == null) e = m_ActiveEdges;
				else e = ePrev.nextInAEL;
			}
			else
			{
				//2. promote horizontal edges, otherwise update Curr.x and Curr.y ...
				if (IsIntermediate(e, topY) && isHorizontal(e.nextInLML))
				{
					e = UpdateEdgeIntoAEL(e);
					if (e.outIdx >= 0)
						AddOutPt(e, e.bot);
					AddEdgeToSEL(e);
				}
				else
				{
					e.currX = TopX( e, topY );
					e.currY = topY;
				}

				if (strictlySimple)
				{
					var ePrev = e.prevInAEL;
					if ((e.outIdx >= 0) && (e.windDelta != 0) && ePrev != null && (ePrev.outIdx >= 0) && (ePrev.currX == e.currX) && (ePrev.windDelta != 0))
					{
						var ip = new IPoint(e.currX, e.currY);
						var op = AddOutPt(ePrev, ip);
						var op2 = AddOutPt(e, ip);
						AddJoin(op, op2, ip); //StrictlySimple (type-3) join
					}
				}

				e = e.nextInAEL;
			}
		}

		//3. Process horizontals at the Top of the scanbeam ...
		ProcessHorizontals(true);

		//4. Promote intermediate vertices ...
		e = m_ActiveEdges;
		while (e != null)
		{
			if(IsIntermediate(e, topY))
			{
				var op = null;
				if( e.outIdx >= 0 )
					op = AddOutPt(e, e.top);
				e = UpdateEdgeIntoAEL(e);

				//if output polygons share an edge, they'll need joining later ...
				var ePrev = e.prevInAEL;
				var eNext = e.nextInAEL;
				if (ePrev != null && ePrev.currX == e.botX &&	ePrev.currY == e.botY && op != null && ePrev.outIdx >= 0 && ePrev.currY > ePrev.topY &&	SlopesEqual(e, ePrev) && (e.windDelta != 0) && (ePrev.windDelta != 0))
				{
					var op2 = AddOutPt(ePrev, e.bot);
					AddJoin(op, op2, e.top);
				}
				else if (eNext != null && eNext.currX == e.botX && eNext.currY == e.botY && op != null && eNext.outIdx >= 0 && eNext.currY > eNext.topY && SlopesEqual(e, eNext) && (e.windDelta != 0) && (eNext.windDelta != 0))
				{
					var op2 = AddOutPt(eNext, e.bot);
					AddJoin(op, op2, e.top);
				}
			}
			e = e.nextInAEL;
		}
	}
	//------------------------------------------------------------------------------

	private function DoMaxima(e:TEdge)
	{
		var eMaxPair = GetMaximaPair(e);
        if (eMaxPair == null)
        {
			if (e.outIdx >= 0)
				AddOutPt(e, e.top);
			DeleteFromAEL(e);
			return;
        }

        var eNext = e.nextInAEL;
        while(eNext != null && eNext != eMaxPair)
        {
			IntersectEdges(e, eNext, e.top);
			SwapPositionsInAEL(e, eNext);
			eNext = e.nextInAEL;
        }

        if(e.outIdx == ClipperBase.UNASSIGNED && eMaxPair.outIdx == ClipperBase.UNASSIGNED)
        {
			DeleteFromAEL(e);
			DeleteFromAEL(eMaxPair);
        }
        else if( e.outIdx >= 0 && eMaxPair.outIdx >= 0 )
        {
			if (e.outIdx >= 0) AddLocalMaxPoly(e, eMaxPair, e.top);
			DeleteFromAEL(e);
			DeleteFromAEL(eMaxPair);
        }
        else throw "DoMaxima error";
	}
	//------------------------------------------------------------------------------

	function reversePolygons(polys:IPolygons)
	{
		for( p in polys ) p.reverse();
	}

	public static inline function Orientation(poly : IPolygon )
	{
		return polArea(poly) >= 0;
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

	private function BuildResult()
	{
		var solution = [];
		for( outRec in m_PolyOuts )
		{
			if (outRec.pts == null) continue;
			if (resultKind == NoHoles && outRec.isHole) continue;
			if (resultKind == HolesOnly && !outRec.isHole) continue;
			var p:OutPt = outRec.pts.prev;
			var cnt:Int = PointCount(p);
			if (cnt < 2) continue;
			var pg:IPolygon = new IPolygon();
			for( j in 0...cnt )
			{
				pg.push(p.pt);
				p = p.prev;
			}
			solution.push(pg);
		}
		return solution;
	}
	//------------------------------------------------------------------------------

	private function BuildResult2(polytree:PolyTree)
	{
		polytree.clear();

		//add each output polygon/contour to polytree
		for ( outRec in m_PolyOuts )
		{
			var cnt = PointCount(outRec.pts);
			if (cnt < 3) continue;
            FixHoleLinkage(outRec);
			var pn:PolyNode = new PolyNode();
			polytree.allPolys.push(pn);
			outRec.polyNode = pn;
			var op:OutPt = outRec.pts.prev;
			for( j in 0...cnt )
			{
				pn.polygon.push(op.pt);
				op = op.prev;
			}
		}

		//fixup PolyNode links etc
		for( outRec in m_PolyOuts )
		{
		  if (outRec.polyNode == null) continue;
		  else if (outRec.firstLeft != null && outRec.firstLeft.polyNode != null)
			  outRec.firstLeft.polyNode.addChild(outRec.polyNode);
		  else
			polytree.addChild(outRec.polyNode);
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
				outRec.pts = null;
				return;
			}
			//test for duplicate points and for same slope (cross-product)
			if (equals(pp.pt, pp.next.pt) || equals(pp.pt, pp.prev.pt) || (SlopesEqual3(pp.prev.pt, pp.pt, pp.next.pt) && (!preserveCollinear || !Pt2IsBetweenPt1AndPt3(pp.prev.pt, pp.pt, pp.next.pt))))
             {
				lastOK = null;
				var tmp:OutPt = pp;
				pp.prev.next = pp.next;
				pp.next.prev = pp.prev;
				pp = pp.prev;
				tmp = null;
			}
			else if (pp == lastOK)
				break;
			else
			{
				if (lastOK == null) lastOK = pp;
				pp = pp.next;
			}
		}
		outRec.pts = pp;
	}
	//------------------------------------------------------------------------------

	function DupOutPt(outPt : OutPt, InsertAfter : Bool)
	{
		var result = new OutPt();
		result.pt = outPt.pt;
		result.idx = outPt.idx;
		if (InsertAfter)
		{
			result.next = outPt.next;
			result.prev = outPt;
			outPt.next.prev = result;
			outPt.next = result;
		}
		else
		{
			result.prev = outPt.prev;
			result.next = outPt;
			outPt.prev.next = result;
			outPt.prev = result;
		}
		return result;
	}
	//------------------------------------------------------------------------------

	function GetOverlap(a1 : Int, a2 : Int, b1 : Int, b2 : Int)
	{
		var Left : Int;
		var Right : Int;

		if (a1 < a2)
		{
			if (b1 < b2) {
				Left = Math.imax(a1, b1);
				Right = Math.imin(a2, b2);
			}
			else {
				Left = Math.imax(a1, b2);
				Right = Math.imin(a2, b1);
			}
		}
		else
		{
			if (b1 < b2) {
				Left = Math.imax(a2, b1);
				Right = Math.imin(a1, b2);
			}
			else {
				Left = Math.imax(a2, b2);
				Right = Math.imin(a1, b1);
			}
		}
		return { left : Left, right : Right,  done : Left < Right };
	}

	//------------------------------------------------------------------------------
	function JoinHorz(op1 : OutPt, op1b : OutPt, op2 : OutPt, op2b : OutPt, pt : IPoint, DiscardLeft : Bool) {
		var Dir1 = (op1.pt.x > op1b.pt.x ? Direction.RightToLeft : Direction.LeftToRight);
		var Dir2 = (op2.pt.x > op2b.pt.x ? Direction.RightToLeft : Direction.LeftToRight);
		if (Dir1 == Dir2) return false;

		//When DiscardLeft, we want Op1b to be on the Left of Op1, otherwise we
		//want Op1b to be on the Right. (And likewise with Op2 and Op2b.)
		//So, to facilitate this while inserting Op1b and Op2b ...
		//when DiscardLeft, make sure we're AT or RIGHT of Pt before adding Op1b,
		//otherwise make sure we're AT or LEFT of Pt. (Likewise with Op2b.)
		if (Dir1 == Direction.LeftToRight)
		{
			while (op1.next.pt.x <= pt.x &&	op1.next.pt.x >= op1.pt.x && op1.next.pt.y == pt.y)
				op1 = op1.next;
			if (DiscardLeft && (op1.pt.x != pt.x))
				op1 = op1.next;
			op1b = DupOutPt(op1, !DiscardLeft);
			if (op1b.pt != pt)
			{
				op1 = op1b;
				op1.pt = pt;
				op1b = DupOutPt(op1, !DiscardLeft);
			}
		}
		else
		{
			while (op1.next.pt.x >= pt.x &&
				op1.next.pt.x <= op1.pt.x && op1.next.pt.y == pt.y)
			op1 = op1.next;
			if (!DiscardLeft && (op1.pt.x != pt.x)) op1 = op1.next;
				op1b = DupOutPt(op1, DiscardLeft);
			if (op1b.pt != pt)
			{
				op1 = op1b;
				op1.pt = pt;
				op1b = DupOutPt(op1, DiscardLeft);
			}
		}

		if (Dir2 == Direction.LeftToRight)
		{
			while (op2.next.pt.x <= pt.x &&
				op2.next.pt.x >= op2.pt.x && op2.next.pt.y == pt.y)
			op2 = op2.next;
			if (DiscardLeft && (op2.pt.x != pt.x)) op2 = op2.next;
				op2b = DupOutPt(op2, !DiscardLeft);
			if (op2b.pt != pt)
			{
				op2 = op2b;
				op2.pt = pt;
				op2b = DupOutPt(op2, !DiscardLeft);
			};
		} else
		{
			while (op2.next.pt.x >= pt.x &&	op2.next.pt.x <= op2.pt.x && op2.next.pt.y == pt.y)
			op2 = op2.next;
			if (!DiscardLeft && (op2.pt.x != pt.x)) op2 = op2.next;
			op2b = DupOutPt(op2, DiscardLeft);
			if (op2b.pt != pt)
			{
				op2 = op2b;
				op2.pt = pt;
				op2b = DupOutPt(op2, DiscardLeft);
			};
		};

		if ((Dir1 == Direction.LeftToRight) == DiscardLeft)
		{
			op1.prev = op2;
			op2.next = op1;
			op1b.next = op2b;
			op2b.prev = op1b;
		}
		else
		{
			op1.next = op2;
			op2.prev = op1;
			op1b.prev = op2b;
			op2b.next = op1b;
		}

		return true;
	}
    //------------------------------------------------------------------------------


	function JoinPoints(j : Join, outRec1 : OutRec, outRec2 : OutRec)
	{
		var op1 = j.outPt1, op1b;
		var op2 = j.outPt2, op2b;

		//There are 3 kinds of joins for output polygons ...
		//1. Horizontal joins where Join.OutPt1 & Join.OutPt2 are a vertices anywhere
		//along (horizontal) collinear edges (& Join.OffPt is on the same horizontal).
		//2. Non-horizontal joins where Join.OutPt1 & Join.OutPt2 are at the same
		//location at the Bottom of the overlapping segment (& Join.OffPt is above).
		//3. StrictlySimple joins where edges touch but are not collinear and where
		//Join.OutPt1, Join.OutPt2 & Join.OffPt all share the same point.
		var isHorizontal = (j.outPt1.pt.y == j.offPt.y);
		if (isHorizontal && equals(j.offPt, j.outPt1.pt) && equals(j.offPt, j.outPt2.pt))
		{
			//Strictly Simple join ...
			if (outRec1 != outRec2) return false;
			op1b = j.outPt1.next;
			while (op1b != op1 && equals(op1b.pt, j.offPt))
				op1b = op1b.next;
			var reverse1 = (op1b.pt.y > j.offPt.y);
			op2b = j.outPt2.next;
			while (op2b != op2 && equals(op2b.pt, j.offPt))
				op2b = op2b.next;
			var reverse2 = (op2b.pt.y > j.offPt.y);
			if (reverse1 == reverse2) return false;
			if (reverse1)
			{
				op1b = DupOutPt(op1, false);
				op2b = DupOutPt(op2, true);
				op1.prev = op2;
				op2.next = op1;
				op1b.next = op2b;
				op2b.prev = op1b;
				j.outPt1 = op1;
				j.outPt2 = op1b;
				return true;
				} else
				{
				op1b = DupOutPt(op1, true);
				op2b = DupOutPt(op2, false);
				op1.next = op2;
				op2.prev = op1;
				op1b.prev = op2b;
				op2b.next = op1b;
				j.outPt1 = op1;
				j.outPt2 = op1b;
				return true;
			}
		}
		else if (isHorizontal)
		{
			//treat horizontal joins differently to non-horizontal joins since with
			//them we're not yet sure where the overlapping is. OutPt1.Pt & OutPt2.Pt
			//may be anywhere along the horizontal edge.
			op1b = op1;
			while (op1.prev.pt.y == op1.pt.y && op1.prev != op1b && op1.prev != op2)
			op1 = op1.prev;
			while (op1b.next.pt.y == op1b.pt.y && op1b.next != op1 && op1b.next != op2)
			op1b = op1b.next;
			if (op1b.next == op1 || op1b.next == op2) return false; //a flat 'polygon'

			op2b = op2;
			while (op2.prev.pt.y == op2.pt.y && op2.prev != op2b && op2.prev != op1b)
			op2 = op2.prev;
			while (op2b.next.pt.y == op2b.pt.y && op2b.next != op2 && op2b.next != op1)
			op2b = op2b.next;
			if (op2b.next == op2 || op2b.next == op1) return false; //a flat 'polygon'

			//Op1 -. Op1b & Op2 -. Op2b are the extremites of the horizontal edges
			var out = GetOverlap(op1.pt.x, op1b.pt.x, op2.pt.x, op2b.pt.x);
			if(!out.done)
				return false;
			var Left = out.left;
			var Right = out.right;

			//DiscardLeftSide: when overlapping edges are joined, a spike will created
			//which needs to be cleaned up. However, we don't want Op1 or Op2 caught up
			//on the discard Side as either may still be needed for other joins ...
			var  Pt;
			var DiscardLeftSide;
			if (op1.pt.x >= Left && op1.pt.x <= Right)
			{
				Pt = op1.pt; DiscardLeftSide = (op1.pt.x > op1b.pt.x);
			}
			else if (op2.pt.x >= Left&& op2.pt.x <= Right)
			{
				Pt = op2.pt; DiscardLeftSide = (op2.pt.x > op2b.pt.x);
			}
			else if (op1b.pt.x >= Left && op1b.pt.x <= Right)
			{
				Pt = op1b.pt; DiscardLeftSide = op1b.pt.x > op1.pt.x;
			}
			else
			{
				Pt = op2b.pt; DiscardLeftSide = (op2b.pt.x > op2.pt.x);
			}
			j.outPt1 = op1;
			j.outPt2 = op2;
			return JoinHorz(op1, op1b, op2, op2b, Pt, DiscardLeftSide);
		} else
		{
			//nb: For non-horizontal joins ...
			//    1. Jr.OutPt1.Pt.y == Jr.OutPt2.Pt.y
			//    2. Jr.OutPt1.Pt > Jr.OffPt.y

			//make sure the polygons are correctly oriented ...
			op1b = op1.next;
			while (equals(op1b.pt, op1.pt) && (op1b != op1)) op1b = op1b.next;
			var Reverse1 = ((op1b.pt.y > op1.pt.y) || !SlopesEqual3(op1.pt, op1b.pt, j.offPt));
			if (Reverse1)
			{
				op1b = op1.prev;
				while (equals(op1b.pt, op1.pt) && (op1b != op1)) op1b = op1b.prev;
				if ((op1b.pt.y > op1.pt.y) ||
				!SlopesEqual3(op1.pt, op1b.pt, j.offPt)) return false;
			};

			op2b = op2.next;
			while (equals(op2b.pt, op2.pt) && (op2b != op2)) op2b = op2b.next;
			var Reverse2 = ((op2b.pt.y > op2.pt.y) ||
			!SlopesEqual3(op2.pt, op2b.pt, j.offPt));
			if (Reverse2)
			{
				op2b = op2.prev;
				while (equals(op2b.pt, op2.pt) && (op2b != op2)) op2b = op2b.prev;
				if ((op2b.pt.y > op2.pt.y) ||
				!SlopesEqual3(op2.pt, op2b.pt, j.offPt)) return false;
			}

			if ((op1b == op1) || (op2b == op2) || (op1b == op2b) || ((outRec1 == outRec2) && (Reverse1 == Reverse2))) return false;

			if (Reverse1)
			{
				op1b = DupOutPt(op1, false);
				op2b = DupOutPt(op2, true);
				op1.prev = op2;
				op2.next = op1;
				op1b.next = op2b;
				op2b.prev = op1b;
				j.outPt1 = op1;
				j.outPt2 = op1b;
				return true;
			} else
			{
				op1b = DupOutPt(op1, true);
				op2b = DupOutPt(op2, false);
				op1.next = op2;
				op2.prev = op1;
				op1b.prev = op2b;
				op2b.next = op1b;
				j.outPt1 = op1;
				j.outPt2 = op1b;
				return true;
			}
		}
	}

	//----------------------------------------------------------------------
	public function PointInPolygon(pt : IPoint, pol : IPolygon)
    {
        //returns 0 if false, +1 if true, -1 if pt ON polygon boundary
        //See "The IPoint in IPolygon Problem for Arbitrary IPolygons" by Hormann & Agathos
        //http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.88.5498&rep=rep1&type=pdf
        var result = 0;
		var cnt = pol.length;
        if (cnt < 3) return 0;
        var ip = pol[0];

		for (i in 1...cnt + 1)
        {
          var ipNext = (i == cnt ? pol[0] : pol[i]);
          if (ipNext.y == pt.y)
          {
            if ((ipNext.x == pt.x) || (ip.y == pt.y && ((ipNext.x > pt.x) == (ip.x < pt.x)))) return -1;
          }
          if ((ip.y < pt.y) != (ipNext.y < pt.y))
          {
            if (ip.x >= pt.x)
            {
              if (ipNext.x > pt.x) result = 1 - result;
              else
              {
                var d = (ip.x - pt.x) * (ipNext.y - pt.y) - (ipNext.x - pt.x) * (ip.y - pt.y);
                if (d == 0) return -1;
                else if ((d > 0) == (ipNext.y > ip.y)) result = 1 - result;
              }
            }
            else
            {
              if (ipNext.x > pt.x)
              {
                var d = (ip.x - pt.x) * (ipNext.y - pt.y) - (ipNext.x - pt.x) * (ip.y - pt.y);
                if (d == 0) return -1;
                else if ((d > 0) == (ipNext.y > ip.y)) result = 1 - result;
              }
            }
          }
          ip = ipNext;
        }
        return result;
    }

    //------------------------------------------------------------------------------

    function PointInPolygon2(pt : IPoint, op : OutPt)
    {
        //returns 0 if false, +1 if true, -1 if pt ON polygon boundary
        //See "The IPoint in IPolygon Problem for Arbitrary IPolygons" by Hormann & Agathos
        //http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.88.5498&rep=rep1&type=pdf
        var result = 0;
        var startOp = op;
        var ptx = pt.x;
		var pty = pt.y;
        var poly0x = op.pt.x;
		var poly0y = op.pt.y;
        do
        {
          op = op.next;
          var poly1x = op.pt.x;
		  var poly1y = op.pt.y;

          if (poly1y == pty)
          {
            if ((poly1x == ptx) || (poly0y == pty &&
              ((poly1x > ptx) == (poly0x < ptx)))) return -1;
          }
          if ((poly0y < pty) != (poly1y < pty))
          {
            if (poly0x >= ptx)
            {
              if (poly1x > ptx) result = 1 - result;
              else
              {
                var d = (poly0x - ptx) * (poly1y - pty) - (poly1x - ptx) * (poly0y - pty);
                if (d == 0) return -1;
                if ((d > 0) == (poly1y > poly0y)) result = 1 - result;
              }
            }
            else
            {
              if (poly1x > ptx)
              {
                var d = (poly0x - ptx) * (poly1y - pty) - (poly1x - ptx) * (poly0y - pty);
                if (d == 0) return -1;
                if ((d > 0) == (poly1y > poly0y)) result = 1 - result;
              }
            }
          }
          poly0x = poly1x;
		  poly0y = poly1y;
        } while (startOp != op);
        return result;
    }
    //------------------------------------------------------------------------------


	private function Poly2ContainsPoly1(outPt1:OutPt, outPt2:OutPt) : Bool	{
		var op = outPt1;
        do
        {
          //nb: PointInPolygon returns 0 if false, +1 if true, -1 if pt on polygon
          var res = PointInPolygon2(op.pt, outPt2);
          if (res >= 0) return res > 0;
          op = op.next;
        }
        while (op != outPt1);
        return true;
	}
	//----------------------------------------------------------------------

	private function FixupFirstLefts1(OldOutRec:OutRec, NewOutRec:OutRec)
	{
		for ( outRec in m_PolyOuts )
		{
			if (outRec.pts == null || outRec.firstLeft == null) continue;
              var firstLeft = ParseFirstLeft(outRec.firstLeft);
              if (firstLeft == OldOutRec)
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

	function ParseFirstLeft(FirstLeft : OutRec)
	{
		while (FirstLeft != null && FirstLeft.pts == null)
		  FirstLeft = FirstLeft.firstLeft;
		return FirstLeft;
	}
	//------------------------------------------------------------------------------


	private function JoinCommonEdges() {
		for (i in 0...m_Joins.length)
        {
          var join = m_Joins[i];

          var outRec1 = GetOutRec(join.outPt1.idx);
          var outRec2 = GetOutRec(join.outPt2.idx);

          if (outRec1.pts == null || outRec2.pts == null) continue;

          //get the polygon fragment with the correct hole state (FirstLeft)
          //before calling JoinPoints() ...
          var holeStateRec;
          if (outRec1 == outRec2) holeStateRec = outRec1;
          else if (Param1RightOfParam2(outRec1, outRec2)) holeStateRec = outRec2;
          else if (Param1RightOfParam2(outRec2, outRec1)) holeStateRec = outRec1;
          else holeStateRec = GetLowermostRec(outRec1, outRec2);

          if (!JoinPoints(join, outRec1, outRec2)) continue;

          if (outRec1 == outRec2)
          {
            //instead of joining two polygons, we've just created a new one by
            //splitting one polygon into two.
            outRec1.pts = join.outPt1;
            outRec1.bottomPt = null;
            outRec2 = CreateOutRec();
            outRec2.pts = join.outPt2;

            //update all OutRec2.Pts Idx's ...
            UpdateOutPtIdxs(outRec2);

            //We now need to check every OutRec.FirstLeft pointer. If it points
            //to OutRec1 it may need to point to OutRec2 instead ...
            if (m_UsingPolyTree)
              for (j in 0...m_PolyOuts.length - 1)
              {
                var oRec = m_PolyOuts[j];
                if (oRec.pts == null || ParseFirstLeft(oRec.firstLeft) != outRec1 ||
                  oRec.isHole == outRec1.isHole) continue;
                if (Poly2ContainsPoly1(oRec.pts, join.outPt2))
                  oRec.firstLeft = outRec2;
              }

            if (Poly2ContainsPoly1(outRec2.pts, outRec1.pts))
            {
              //outRec2 is contained by outRec1 ...
              outRec2.isHole = !outRec1.isHole;
              outRec2.firstLeft = outRec1;

              //fixup FirstLeft pointers that may need reassigning to OutRec1
              if (m_UsingPolyTree) FixupFirstLefts2(outRec2, outRec1);

             if (xor(outRec2.isHole, reverseSolution) == (Area(outRec2) > 0))
                ReversePolyPtLinks(outRec2.pts);

            }
            else if (Poly2ContainsPoly1(outRec1.pts, outRec2.pts))
            {
              //outRec1 is contained by outRec2 ...
              outRec2.isHole = outRec1.isHole;
              outRec1.isHole = !outRec2.isHole;
              outRec2.firstLeft = outRec1.firstLeft;
              outRec1.firstLeft = outRec2;

              //fixup FirstLeft pointers that may need reassigning to OutRec1
              if (m_UsingPolyTree) FixupFirstLefts2(outRec1, outRec2);

              if (xor(outRec1.isHole, reverseSolution) == (Area(outRec1) > 0))
               ReversePolyPtLinks(outRec1.pts);
            }
            else
            {
              //the 2 polygons are completely separate ...
              outRec2.isHole = outRec1.isHole;
              outRec2.firstLeft = outRec1.firstLeft;

              //fixup FirstLeft pointers that may need reassigning to OutRec2
              if (m_UsingPolyTree) FixupFirstLefts1(outRec1, outRec2);
            }

          } else
          {
            //joined 2 polygons together ...

            outRec2.pts = null;
            outRec2.bottomPt = null;
            outRec2.idx = outRec1.idx;

            outRec1.isHole = holeStateRec.isHole;
            if (holeStateRec == outRec2)
              outRec1.firstLeft = outRec2.firstLeft;
            outRec2.firstLeft = outRec1;

            //fixup FirstLeft pointers that may need reassigning to OutRec1
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
			do //for each Pt in IPolygon until duplicate found do
			{
				var op2 = op.next;
				while (op2 != outrec.pts)
				{
					if (equals(op.pt, op2.pt) && op2.next != op && op2.prev != op)
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

	public static function polArea(poly:IPolygon) {
		var cnt = poly.length;
        if (cnt < 3) return 0.;
        var a = 0.;
		var j = cnt - 1;
		for (i in 0...cnt) {
          a += (poly[j].x + poly[i].x) * (poly[j].y - poly[i].y);
          j = i;
        }
        return -a * 0.5;
	}

	function Area(outRec:OutRec) {
		var op:OutPt = outRec.pts;
		if (op == null) return 0.;
		var a:Float = 0;
		do {
			a = a + (op.pt.x + op.prev.pt.x) * (op.prev.pt.y - op.pt.y);
			op = op.next;
		} while (op != outRec.pts);
		return a / 2;
	}


	//------------------------------------------------------------------------------
	// SimplifyPolygon functions
	// Convert self-intersecting polygons into simple polygons
	//------------------------------------------------------------------------------

	public static function SimplifyPolygon(poly : IPolygon, ?fillType)
      {
		  if(fillType == null) fillType = PolyFillType.EvenOdd;
          var c = new Clipper();
          c.strictlySimple = true;
          c.addPolygon(poly, PolyType.Subject);
          return c.execute(ClipType.Union, fillType, fillType);
      }
      //------------------------------------------------------------------------------

      public static function SimplifyPolygons(polys : IPolygons, ?fillType)
      {
		  if(fillType == null) fillType = PolyFillType.EvenOdd;
          var c = new Clipper();
          c.strictlySimple = true;
          c.addPolygons(polys, PolyType.Subject);
          return c.execute(ClipType.Union, fillType, fillType);
      }
      //------------------------------------------------------------------------------

      private function DistanceFromLineSqrd(pt : IPoint, ln1 : IPoint, ln2 : IPoint)
      {
        //The equation of a line in general form (Ax + By + C = 0)
        //given 2 points (x¹,y¹) & (x²,y²) is ...
        //(y¹ - y²)x + (x² - x¹)y + (y² - y¹)x¹ - (x² - x¹)y¹ = 0
        //A = (y¹ - y²); B = (x² - x¹); C = (y² - y¹)x¹ - (x² - x¹)y¹
        //perpendicular distance of point (x³,y³) = (Ax³ + By³ + C)/Sqrt(A² + B²)
        //see http://en.wikipedia.org/wiki/Perpendicular_distance
        var A = ln1.y - ln2.y;
        var B = ln2.x - ln1.x;
        var C = A * ln1.x  + B * ln1.y;
        C = A * pt.x + B * pt.y - C;
        return (C * C) / (A * A + B * B);
      }
      //---------------------------------------------------------------------------

      private function SlopesNearCollinear(pt1 : IPoint, pt2 : IPoint , pt3 : IPoint, distSqrd : Float)
      {
        //this function is more accurate when the point that's GEOMETRICALLY
        //between the other 2 points is the one that's tested for distance.
        //nb: with 'spikes', either pt1 or pt3 is geometrically between the other pts
        if (Math.abs(pt1.x - pt2.x) > Math.abs(pt1.y - pt2.y))
	      {
          if ((pt1.x > pt2.x) == (pt1.x < pt3.x))
            return DistanceFromLineSqrd(pt1, pt2, pt3) < distSqrd;
          else if ((pt2.x > pt1.x) == (pt2.x < pt3.x))
            return DistanceFromLineSqrd(pt2, pt1, pt3) < distSqrd;
		      else
	          return DistanceFromLineSqrd(pt3, pt1, pt2) < distSqrd;
	      }
	      else
	      {
          if ((pt1.y > pt2.y) == (pt1.y < pt3.y))
            return DistanceFromLineSqrd(pt1, pt2, pt3) < distSqrd;
          else if ((pt2.y > pt1.y) == (pt2.y < pt3.y))
            return DistanceFromLineSqrd(pt2, pt1, pt3) < distSqrd;
		      else
            return DistanceFromLineSqrd(pt3, pt1, pt2) < distSqrd;
	      }
      }

      //------------------------------------------------------------------------------

      private function PointsAreClose(pt1 : IPoint, pt2 : IPoint, distSqrd : Float)
      {
          var dx = pt1.x - pt2.x;
          var dy = pt1.y - pt2.y;
          return ((dx * dx) + (dy * dy) <= distSqrd);
      }
      //------------------------------------------------------------------------------

      private function ExcludeOp(op : OutPt)
      {
        var result = op.prev;
        result.next = op.next;
        op.next.prev = result;
        result.idx = 0;
        return result;
      }
      //------------------------------------------------------------------------------

      public function CleanPolygon(path : IPolygon, distance = 1.415)
      {
        //distance = proximity in units/pixels below which vertices will be stripped.
        //Default ~= sqrt(2) so when adjacent vertices or semi-adjacent vertices have
        //both x & y coords within 1 unit, then the second vertex will be stripped.

        var cnt = path.length;
        if (cnt == 0) return new IPolygon();

        var outPts = [];
        for (i in 0...cnt)
        {
		  outPts[i] = new OutPt();
          outPts[i].pt = path[i];
          outPts[i].next = outPts[(i + 1) % cnt];
          outPts[i].next.prev = outPts[i];
          outPts[i].idx = 0;
        }

        var distSqrd = distance * distance;
        var op = outPts[0];
        while (op.idx == 0 && op.next != op.prev)
        {
          if (PointsAreClose(op.pt, op.prev.pt, distSqrd))
          {
            op = ExcludeOp(op);
            cnt--;
          }
          else if (PointsAreClose(op.prev.pt, op.next.pt, distSqrd))
          {
            ExcludeOp(op.next);
            op = ExcludeOp(op);
            cnt -= 2;
          }
          else if (SlopesNearCollinear(op.prev.pt, op.pt, op.next.pt, distSqrd))
          {
            op = ExcludeOp(op);
            cnt--;
          }
          else
          {
            op.idx = 1;
            op = op.next;
          }
        }

        if (cnt < 3) cnt = 0;
        var result = new IPolygon();
        for (i in 0...cnt)
        {
          result.push(op.pt);
          op = op.next;
        }
        outPts = null;
        return result;
      }

      //------------------------------------------------------------------------------

      public function CleanPolygons(polys : IPolygons, distance = 1.415)
      {
        var result = new IPolygons();
        for (i in 0...polys.length)
          result.push(CleanPolygon(polys[i], distance));
        return result;
      }
      //------------------------------------------------------------------------------

      function Minkowski(pattern : IPolygon, path : IPolygon , IsSum : Bool)
      {
        var polyCnt = pattern.length;
        var pathCnt = path.length;
        var result = new IPolygons();

		for (i in 0...pathCnt) {
			var p = new IPolygon();
			for (ip in pattern) {
				if (IsSum)
					p.push(new IPoint(path[i].x + ip.x, path[i].y + ip.y));
				else
					p.push(new IPoint(path[i].x - ip.x, path[i].y - ip.y));
			}
			result.push(p);
		}

        var quads = new IPolygons();
        for (i in 0...pathCnt)
			for (j in 0...polyCnt)
			{
				var quad = new IPolygon();
				quad.push(result[i % pathCnt][j % polyCnt]);
				quad.push(result[(i + 1) % pathCnt][j % polyCnt]);
				quad.push(result[(i + 1) % pathCnt][(j + 1) % polyCnt]);
				quad.push(result[i % pathCnt][(j + 1) % polyCnt]);
				if (!Orientation(quad)) quad.reverse();
				quads.push(quad);
			}
        return quads;
      }

      //------------------------------------------------------------------------------

      public function MinkowskiSum(pattern : IPolygon, pol : IPolygon, ?kind : ResultKind)
      {
        var paths = Minkowski(pattern, pol, true);
        var c = new Clipper();
		c.resultKind = kind == null ? All : kind;
		c.addPolygons(paths, PolyType.Subject);
        return c.execute(ClipType.Union, PolyFillType.NonZero, PolyFillType.NonZero);
      }

      //------------------------------------------------------------------------------

      private function TranslatePath(path : IPolygon, delta : IPoint)
      {
        var outPath = new IPolygon();
        for (i in 0...path.length)
          outPath.push(new IPoint(path[i].x + delta.x, path[i].y + delta.y));
        return outPath;
      }
      //------------------------------------------------------------------------------

      public static function MinkowskiSums(pattern : IPolygon, pols : IPolygons, ?kind : ResultKind)
      {
        var c = new Clipper();
        c.resultKind = kind == null ? All : kind;
		for (i in 0...pols.length)
        {
          var tmp = c.Minkowski(pattern, pols[i], true);
          c.addPolygons(tmp, PolyType.Subject);
          var path = c.TranslatePath(pols[i], pattern[0]);
          c.addPolygon(path, PolyType.Clip);
        }
        return c.execute(ClipType.Union, PolyFillType.NonZero, PolyFillType.NonZero);
      }
      //------------------------------------------------------------------------------

      public static function MinkowskiDiff(pattern : IPolygon, pol : IPolygon, ?kind : ResultKind)
      {
        var c = new Clipper();
        var paths = c.Minkowski(pattern, pol, false);
        c.resultKind = kind == null ? All : kind;
		c.addPolygons(paths, PolyType.Subject);
		return c.execute(ClipType.Union, PolyFillType.NonZero, PolyFillType.NonZero);
      }


      //------------------------------------------------------------------------------


      public function PolyTreeToPaths(polytree : PolyTree)
      {
        var result = new IPolygons();
        AddPolyNodeToPaths(polytree, NodeType.Any, result);
        return result;
      }
      //------------------------------------------------------------------------------

      function AddPolyNodeToPaths(polynode : PolyNode, nt : NodeType, paths : IPolygons)
      {
        var match = true;
        switch (nt)
        {
          case NodeType.Open: return;
          default:
        }

        if (polynode.polygon.length > 0 && match)
          paths.push(polynode.polygon);
        for (pn in polynode.childs)
          AddPolyNodeToPaths(pn, nt, paths);
      }

      //------------------------------------------------------------------------------


}


@:allow(hxd.clipper)
class ClipperOffset
{
	private var m_destPolys : IPolygons;
	private var m_srcPoly : IPolygon;
	private var m_destPoly : IPolygon;
	private var m_normals : Array<Point>;
	private var m_delta : Float;
	private var m_sinA : Float;
	private var m_sin : Float;
	private var m_cos : Float;
	private var m_miterLim : Float;
	private var m_StepsPerRad : Float;

	private var m_lowest : IPoint;
	private var m_polyNodes : PolyNode;

	public var ArcTolerance : Float;
	public var MiterLimit : Float;
	public var resultKind : ResultKind;

	private var def_arc_tolerance = 0.25;
	private var two_pi = Math.PI * 2;

	public function new (miterLimit = 2.0, arcTolerance = 0.25) {
		MiterLimit = miterLimit;
		ArcTolerance = arcTolerance;
		m_lowest = new IPoint( -1, 0);
		m_normals = [];
		m_polyNodes = new PolyNode();
		resultKind = All;
	}
    //------------------------------------------------------------------------------

    public function clear() {
		m_polyNodes = new PolyNode();
		m_lowest = new IPoint( -1, 0);
    }

    //------------------------------------------------------------------------------

    public function addPolygon(pol : IPolygon, joinType : JoinType, endType : EndType) {
		var highI = pol.length - 1;
		if (highI < 0) return;
		var newNode = new PolyNode();
		newNode.jointype = joinType;
		newNode.endtype = endType;

		//strip duplicate points from path and also get index to the lowest point ...
		if (endType == EndType.ClosedLine || endType == EndType.ClosedPol)
			while (highI > 0 && pol[0] == pol[highI])
				highI--;
		newNode.polygon.push(pol[0]);
		var j = 0, k = 0;
		for (i in 1...highI + 1)
			if (newNode.polygon[j] != pol[i]) {
				j++;
				newNode.polygon.push(pol[i]);
				if (pol[i].y > newNode.polygon[k].y || (pol[i].y == newNode.polygon[k].y && pol[i].x < newNode.polygon[k].x))
					k = j;
			}
		if (endType == EndType.ClosedPol && j < 2) return;

		m_polyNodes.addChild(newNode);

		//if this path's lowest pt is lower than all the others then update m_lowest
		if (endType != EndType.ClosedPol) return;
		if (m_lowest.x < 0)
			m_lowest = new IPoint(m_polyNodes.childCount - 1, k);
		else
		{
			var ip = m_polyNodes.childs[m_lowest.x].polygon[m_lowest.y];
			if (newNode.polygon[k].y > ip.y || (newNode.polygon[k].y == ip.y && newNode.polygon[k].x < ip.x))
				m_lowest = new IPoint(m_polyNodes.childCount - 1, k);
		}
    }
    //------------------------------------------------------------------------------

    public function addPolygons(pols : IPolygons, joinType : JoinType, endType : EndType)
    {
		for( p in pols)
			addPolygon(p, joinType, endType);
    }

    //------------------------------------------------------------------------------

    function fixOrientations()
    {
		//fixup orientations of all closed paths if the orientation of the
		//closed path with the lowermost vertex is wrong ...
		if (m_lowest.x >= 0 && !Clipper.Orientation(m_polyNodes.childs[m_lowest.x].polygon)) {
			for (node in m_polyNodes.childs)
				if (node.endtype == EndType.ClosedPol || (node.endtype == EndType.ClosedLine && Clipper.Orientation(node.polygon)))
					node.polygon.reverse();
		}
		else
		{
			for (node in m_polyNodes.childs)
			{
				if (node.endtype == EndType.ClosedLine && !Clipper.Orientation(node.polygon))
					node.polygon.reverse();
			}
		}
    }
    //------------------------------------------------------------------------------

    function getUnitNormal(pt1 : IPoint, pt2 : IPoint)
    {
		var dx : Float = (pt2.x - pt1.x);
		var dy : Float = (pt2.y - pt1.y);
		if ((dx == 0) && (dy == 0)) return new Point();

		var f = 1 / Math.distance(dx, dy);
		dx *= f;
		dy *= f;

		return new Point(dy, -dx);
    }
    //------------------------------------------------------------------------------

	function doOffset(delta : Float) {
		m_destPolys = new IPolygons();
		m_delta = delta;

		//if Zero offset, just copy any CLOSED polygons to m_p and return ...
		if (ClipperBase.nearZero(delta)) {
			for (node in m_polyNodes.childs) {
				if (node.endtype == EndType.ClosedPol)
				m_destPolys.push(node.polygon);
			}
			return;
		}

		//see offset_triginometry3.svg in the documentation folder ...
		if (MiterLimit > 2) m_miterLim = 2 / (MiterLimit * MiterLimit);
		else m_miterLim = 0.5;

		var y : Float;
		if (ArcTolerance <= 0.0)
			y = def_arc_tolerance;
		else if (ArcTolerance > Math.abs(delta) * def_arc_tolerance)
			y = Math.abs(delta) * def_arc_tolerance;
		else
			y = ArcTolerance;
		//see offset_triginometry2.svg in the documentation folder ...
		var steps = Std.int(Math.PI / Math.acos(1 - y / Math.abs(delta)));
		m_sin = Math.sin(two_pi / steps);
		m_cos = Math.cos(two_pi / steps);
		m_StepsPerRad = steps / two_pi;
		if (delta < 0.) m_sin = -m_sin;

		for (node in m_polyNodes.childs)
		{
			m_srcPoly = node.polygon;
			var len = m_srcPoly.length;

			if (len == 0 || (delta <= 0 && (len < 3 || node.endtype != EndType.ClosedPol)))
				continue;

			m_destPoly = new IPolygon();

			if (len == 1) {
				if (node.jointype == JoinType.Round) {
					var X = 1., Y = 0.;
					for (j in 1...steps + 1) {
						m_destPoly.push(new IPoint( Math.round(m_srcPoly[0].x + X * delta), Math.round(m_srcPoly[0].y + Y * delta)));
						var X2 = X;
						X = X * m_cos - m_sin * Y;
						Y = X2 * m_sin + Y * m_cos;
					}
				}
				else {
					var X = -1., Y = -1.;
					for (j in 0...4) {
						m_destPoly.push(new IPoint( Math.round(m_srcPoly[0].x + X * delta), Math.round(m_srcPoly[0].y + Y * delta)));
						if (X < 0) X = 1;
						else if (Y < 0) Y = 1;
						else X = -1;
					}
				}
				m_destPolys.push(m_destPoly);
				continue;
			}

			//build m_normals ...
			m_normals = [];
			for (j in 0...len - 1)
				m_normals.push(getUnitNormal(m_srcPoly[j], m_srcPoly[j + 1]));
			if (node.endtype == EndType.ClosedLine || node.endtype == EndType.ClosedPol)
				m_normals.push(getUnitNormal(m_srcPoly[len - 1], m_srcPoly[0]));
			else
				m_normals.push(m_normals[len - 2]);

			if (node.endtype == EndType.ClosedPol)  {
				var k = len - 1;
				for (j in 0...len)
					k = offsetPoint(j, k, node.jointype);
				m_destPolys.push(m_destPoly);
			}
			else if (node.endtype == EndType.ClosedLine) {
				var k = len - 1;
				for (j in 0...len)
				k = offsetPoint(j, k, node.jointype);
				m_destPolys.push(m_destPoly);
				m_destPoly = new IPolygon();
				//re-build m_normals ...
				var n = m_normals[len - 1];
				var j = len - 1;
				while(j > 0) {
					m_normals[j] = new Point(-m_normals[j - 1].x, -m_normals[j - 1].y);
					j--;
				}
				m_normals[0] = new Point(-n.x, -n.y);
				k = 0;
				var j = len - 1;
				while(j > 0) {
					k = offsetPoint(j, k, node.jointype);
					j--;
				}
				m_destPolys.push(m_destPoly);
			}
			else {
				var k = 0;
				for (j in 1...len - 1)
					k = offsetPoint(j, k, node.jointype);

				var pt1 : IPoint;
				if (node.endtype == EndType.OpenButt) {
					var j = len - 1;
					pt1 = new IPoint(Math.round(m_srcPoly[j].x + m_normals[j].x * delta), Math.round(m_srcPoly[j].y + m_normals[j].y * delta));
					m_destPoly.push(pt1);
					pt1 = new IPoint(Math.round(m_srcPoly[j].x - m_normals[j].x * delta), Math.round(m_srcPoly[j].y - m_normals[j].y * delta));
					m_destPoly.push(pt1);
				}
				else {
					var j = len - 1;
					k = len - 2;
					m_sinA = 0;
					m_normals[j] = new Point(-m_normals[j].x, -m_normals[j].y);
					if (node.endtype == EndType.OpenSquare)
						doSquare(j, k);
					else
						doRound(j, k);
				}

				//re-build m_normals ...
				var j = len - 1;
				while(j > 0) {
					m_normals[j] = new Point( -m_normals[j - 1].x, -m_normals[j - 1].y);
					j--;
				}

				m_normals[0] = new Point(-m_normals[1].x, -m_normals[1].y);

				k = len - 1;
				var j = k - 1;
				while(j > 0) {
					k = offsetPoint(j, k, node.jointype);
					j--;
				}

				if (node.endtype == EndType.OpenButt) {
					pt1 = new IPoint(Math.round(m_srcPoly[0].x - m_normals[0].x * delta), Math.round(m_srcPoly[0].y - m_normals[0].y * delta));
					m_destPoly.push(pt1);
					pt1 = new IPoint(Math.round(m_srcPoly[0].x + m_normals[0].x * delta), Math.round(m_srcPoly[0].y + m_normals[0].y * delta));
					m_destPoly.push(pt1);
				}
				else {
					k = 1;
					m_sinA = 0;
					if (node.endtype == EndType.OpenSquare)
						doSquare(0, 1);
					else
						doRound(0, 1);
				}
				m_destPolys.push(m_destPoly);
			}
		}
    }
    //------------------------------------------------------------------------------

    public function execute(delta : Float) {
		fixOrientations();
		doOffset(delta);

		//now clean up 'corners' ...
		var clpr = new Clipper();
		clpr.resultKind = resultKind;
		clpr.addPolygons(m_destPolys, PolyType.Subject);
		if (delta > 0) return clpr.execute(ClipType.Union, PolyFillType.Positive, PolyFillType.Positive);
		else {
			var r = ClipperBase.getBounds(m_destPolys);
			var outer = new IPolygon();

			outer.push(new IPoint(r.left - 10, r.bottom + 10));
			outer.push(new IPoint(r.right + 10, r.bottom + 10));
			outer.push(new IPoint(r.right + 10, r.top - 10));
			outer.push(new IPoint(r.left - 10, r.top - 10));

			clpr.addPolygon(outer, PolyType.Subject);
			clpr.reverseSolution = true;
			var out = clpr.execute(ClipType.Union, PolyFillType.Negative, PolyFillType.Negative);
			if (out.length > 0) out.shift();
			return out;
		}
    }
    //------------------------------------------------------------------------------

    function offsetPoint(j : Int, k : Int, jointype : JoinType)
    {
		//cross product ...
		m_sinA = (m_normals[k].x * m_normals[j].y - m_normals[j].x * m_normals[k].y);

		if (Math.abs(m_sinA * m_delta) < 1.0)
		{
			//dot product ...
			var cosA = (m_normals[k].x * m_normals[j].x + m_normals[j].y * m_normals[k].y);
			if (cosA > 0) // angle ==> 0 degrees
			{
				m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + m_normals[k].x * m_delta), Math.round(m_srcPoly[j].y + m_normals[k].y * m_delta)));
				return k;
			}
			//else angle ==> 180 degrees
		}
		else if (m_sinA > 1.0) m_sinA = 1.0;
		else if (m_sinA < -1.0) m_sinA = -1.0;

		if (m_sinA * m_delta < 0)
		{
			var p1 = new IPoint(Math.round(m_srcPoly[j].x + m_normals[k].x * m_delta), Math.round(m_srcPoly[j].y + m_normals[k].y * m_delta));
			var p2 = new IPoint(Math.round(m_srcPoly[j].x + m_normals[j].x * m_delta), Math.round(m_srcPoly[j].y + m_normals[j].y * m_delta));
			m_destPoly.push(p1);
			if(hxd.Math.distanceSq(p1.x - p2.x, p1.y -p2.y ) > 1){
				m_destPoly.push(m_srcPoly[j]);
				m_destPoly.push(p2);
			}
		}
		else
		switch (jointype)
		{
			case JoinType.Miter:
				var r = 1 + (m_normals[j].x * m_normals[k].x + m_normals[j].y * m_normals[k].y);
				if (r >= m_miterLim)
					doMiter(j, k, r);
				else doSquare(j, k);
			case JoinType.Square: doSquare(j, k);
			case JoinType.Round: doRound(j, k);
		}

		return j;
    }
    //------------------------------------------------------------------------------

    inline function doSquare(j : Int, k : Int)
    {
		var dx = Math.tan(Math.atan2(m_sinA, m_normals[k].x * m_normals[j].x + m_normals[k].y * m_normals[j].y) * 0.25);
		m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + m_delta * (m_normals[k].x - m_normals[k].y * dx)), Math.round(m_srcPoly[j].y + m_delta * (m_normals[k].y + m_normals[k].x * dx))));
		m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + m_delta * (m_normals[j].x + m_normals[j].y * dx)), Math.round(m_srcPoly[j].y + m_delta * (m_normals[j].y - m_normals[j].x * dx))));
    }
    //------------------------------------------------------------------------------

   inline function doMiter(j : Int, k : Int, r : Float)
    {
		var q = m_delta / r;
		m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + (m_normals[k].x + m_normals[j].x) * q), Math.round(m_srcPoly[j].y + (m_normals[k].y + m_normals[j].y) * q)));
    }
    //------------------------------------------------------------------------------

   inline function doRound(j : Int, k : Int)
    {
		var a = Math.atan2(m_sinA, m_normals[k].x * m_normals[j].x + m_normals[k].y * m_normals[j].y);
		var steps = Math.imax(Math.round(m_StepsPerRad * Math.abs(a)), 1);

		var X = m_normals[k].x, Y = m_normals[k].y, X2;
		for (i in 0...steps) {
			m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + X * m_delta), Math.round(m_srcPoly[j].y + Y * m_delta)));
			X2 = X;
			X = X * m_cos - m_sin * Y;
			Y = X2 * m_sin + Y * m_cos;
		}
		m_destPoly.push(new IPoint(Math.round(m_srcPoly[j].x + m_normals[j].x * m_delta), Math.round(m_srcPoly[j].y + m_normals[j].y * m_delta)));
    }
}
