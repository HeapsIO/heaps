package hxd.poly2tri;

class Point
{
	public var id:Int;

	#if fastPoly2tri
	public var x:Int;
	public var y:Int;
	#else
	public var x:Float;
	public var y:Float;
	#end

	/// The edges this point constitutes an upper ending point
	#if haxe3
	public var edge_list(get, null):Array<Edge>;
	#else
	public var edge_list(get_edge_list, null):Array<Edge>;
	#end

	public function new(x,y)
	{
		this.x = x;
		this.y = y;

		id = C_ID;
		C_ID++;

	}


	function get_edge_list()
	{
		if (edge_list==null) edge_list = new Array();
		return edge_list;
	}



	public inline function equals(that:Point):Bool
	{
		#if fastPoly2Tri
		return this == that;
		#else
		return (this.x == that.x) && (this.y == that.y);
		#end
	}

	public static function sortPoints(points:Array<Point>)
	{
		points.sort( cmpPoints );
	}

	public static function cmpPoints(l:Point,r:Point)
	{
		var ret = l.y - r.y;
		if (ret == 0) ret = l.x - r.x;
		if (ret <  0) return -1;
		if (ret >  0) return 1;
		return 0;
	}

	public function toString()
	{
		return "Point(" + x + ", " + y + ")";
	}

	public static var C_ID = 0;




}

