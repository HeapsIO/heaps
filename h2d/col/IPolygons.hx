package h2d.col;
import hxd.Math;

/**
	An abstract over an Array of `IPolygon` instances that define multiple polygonal shapes that can be collision-tested against.
	@see `h2d.Polygons`
**/
@:forward(push,remove)
abstract IPolygons(Array<IPolygon>) from Array<IPolygon> to Array<IPolygon> {
	/**
		An underlying IPolygon array.
	**/
	public var polygons(get, never) : Array<IPolygon>;
	/**
		The amount of polygons in the IPolygons instance.
	**/
	public var length(get, never) : Int;
	inline function get_length() return this.length;

	inline function get_polygons() return this;

	/**
		Create a new IPolygons instance.
		@param polygons An optional list of polygons to use.
	**/
	public inline function new( ?polygons ) {
		this = polygons == null ? [] : polygons;
	}

	@:dox(hide)
	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	/**
		Converts the IPolygons instance to the floating point-based Polygons.
	**/
	public function toPolygons( scale = 1. ) : Polygons {
		return [for( p in polygons ) p.toPolygon(scale)];
	}

	/**
		Returns bounding box of all IPolygon instances in IPolygons.
		@param b Optional Bounds instance to be filled. Returns new Bounds instance if `null`.
	**/
	public function getBounds( ?b : IBounds ) {
		if( b == null ) b = new IBounds();
		for( p in polygons )
			p.getBounds(b);
		return b;
	}

	/**
		Combines this IPolygons and given IPolygons `p` and returns resulting IPolygons.
		@param p Optional IPolygons to union with. When not set, unions all polygons in this IPolygons.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon.
	**/
	public function union( ?p : IPolygons, withHoles = true ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygons(this, Clip);
		if(p != null) c.addPolygons(p, Clip);
		return c.execute(Union, NonZero, NonZero);
	}

	/**
		Calculates an intersection areas between this IPolygons and given IPolygons `p` and returns resulting IPolygons.
		@param p The IPolygons to intersect with.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
	public inline function intersection( p : IPolygons, withHoles = true ) : IPolygons {
		return clipperOp(p, Intersection, withHoles);
	}

	/**
		Subtracts the area of given IPolygons `p` from this IPolygons and returns resulting IPolygons.
		@param p The IPolygons to subtract with.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
	public inline function subtraction( p : IPolygons, withHoles = true ) : IPolygons {
		return clipperOp(p, Difference, withHoles);
	}

	/**
		Offsets polygon edges by specified amount and returns resulting IPolygons.
		@param delta The offset amount.
		@param kind The corner rounding method.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
	public function offset( delta : Float, kind : IPolygon.OffsetKind, withHoles = true ) : IPolygons {
		if( this.length == 0 )
			return new IPolygons();
		var c = new hxd.clipper.Clipper.ClipperOffset();
		switch( kind ) {
		case Square:
			c.addPolygons(this, Square, ClosedPol);
		case Miter:
			c.addPolygons(this, Miter, ClosedPol);
		case Round(arc):
			c.ArcTolerance = arc;
			c.addPolygons(this, Round, ClosedPol);
		}
		if( !withHoles ) c.resultKind = NoHoles;
		return c.execute(delta);
	}

	function clipperOp( p : IPolygons, op, withHoles ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygons(this, Subject);
		c.addPolygons(p, Clip);
		return c.execute(op, NonZero, NonZero);
	}

	/**
		Tests if Point `p` is inside this IPolygons.
		@param p The point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function contains( p : Point, isConvex = false ) {
		for( pl in polygons )
			if( pl.contains(p, isConvex) )
				return true;
		return false;
	}

	/**
		Creates a set of new optimized polygons by eliminating almost colinear edges according to the epsilon distance.
	**/
	public function optimize( epsilon : Float ) : IPolygons {
		return [for( p in polygons ) p.optimize(epsilon)];
	}

}
