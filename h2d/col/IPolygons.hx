package h2d.col;
import hxd.Math;

@:forward(push,remove)
abstract IPolygons(Array<IPolygon>) from Array<IPolygon> to Array<IPolygon> {

	public var polygons(get, never) : Array<IPolygon>;
	public var length(get, never) : Int;
	inline function get_length() return this.length;

	inline function get_polygons() return this;

	public inline function new( ?polygons ) {
		this = polygons == null ? [] : polygons;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	public function toPolygons( scale = 1. ) : Polygons {
		return [for( p in polygons ) p.toPolygon(scale)];
	}

	public function getBounds( ?b : IBounds ) {
		if( b == null ) b = new IBounds();
		for( p in polygons )
			p.getBounds(b);
		return b;
	}

	public function union( ?p : IPolygons, withHoles = true ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygons(this, Clip);
		if(p != null) c.addPolygons(p, Clip);
		return c.execute(Union, NonZero, NonZero);
	}

	public inline function intersection( p : IPolygons, withHoles = true ) : IPolygons {
		return clipperOp(p, Intersection, withHoles);
	}

	public inline function subtraction( p : IPolygons, withHoles = true ) : IPolygons {
		return clipperOp(p, Difference, withHoles);
	}

	public function offset( delta : Float, kind : IPolygon.OffsetKind, withHoles = true ) : IPolygons {
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

	public function contains( p : Point, isConvex ) {
		for( pl in polygons )
			if( pl.contains(p, isConvex) )
				return true;
		return false;
	}

	public function optimize( epsilon : Float ) : IPolygons {
		return [for( p in polygons ) p.optimize(epsilon)];
	}

}
