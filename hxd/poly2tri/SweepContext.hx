package hxd.poly2tri;

class SweepContext
{
	public var triangles:Array<Triangle>;
	public var points:Array<Point>;
	public var edge_list:Array<Edge>;

	public var front:AdvancingFront;
	public var head:Point;
	public var tail:Point;

	public var basin:Basin;
	public var edge_event:EdgeEvent;



	public function new()
	{
		triangles = new Array();
		points = new Array();
		edge_list = new Array();

		basin = new Basin();
		edge_event = new EdgeEvent();
	}


	function addPoints(points:Array<Point>)
	{
		for (point in points)
		{
			//OPT use concat instead
			this.points.push( point );
		}
	}


	public function addPolyline(polyline:Array<Point>)
	{
		initEdges(polyline);
		addPoints(polyline);
	}


	function initEdges(polyline:Array<Point>)
	{

		for (n in 0...polyline.length)
		{

			var nx = polyline[(n + 1) % polyline.length];
			edge_list.push ( new Edge(polyline[n], nx) );

		}
	}


	public function addToMap(triangle:Triangle)
	{
		//map.set( triangle.toString(), triangle );
	}


	public function initTriangulation()
	{
		//OPT
		var xmin = points[0].x;
		var xmax = points[0].x;
		var ymin = points[0].y;
		var ymax = points[0].y;

		// Calculate bounds
		for (p in points)
		{
			if (p.x > xmax) xmax = p.x;
			if (p.x < xmin) xmin = p.x;
			if (p.y > ymax) ymax = p.y;
			if (p.y < ymin) ymin = p.y;
		}

		var dx = Constants.kAlpha * (xmax - xmin);
		var dy = Constants.kAlpha * (ymax - ymin);

		#if fastPoly2tri
		var dx = Math.ceil(dx);
		var dy = Math.ceil(dy);
		#end

		this.head = new Point(xmax + dx, ymin - dy);
		this.tail = new Point(xmin - dy, ymin - dy);


		// Sort points along y-axis
		Point.sortPoints(points);

	}

	public function locateNode(point:Point):Node
	{
		return this.front.locateNode(point.x);
	}

	public function createAdvancingFront()
	{
		// Initial triangle
		var triangle = new Triangle(points[0], this.tail, this.head);

		var head = new Node( triangle.points[1], triangle );
		var middle = new Node( triangle.points[0], triangle );
		var tail = new Node( triangle.points[2] );

		this.front = new AdvancingFront(head, tail);

		head.next   = middle;
		middle.next = tail;
		middle.prev = head;
		tail.prev   = middle;

	}

	public function removeNode(node:Node)
	{
		// do nothing
	}

	public function mapTriangleToNodes(triangle:Triangle)
	{
		for (n in 0...3)
		{
			if (triangle.neighbors[n] == null)
			{
				var neighbor = this.front.locatePoint(triangle.pointCW(triangle.points[n]));
				if (neighbor != null) neighbor.triangle = triangle;
			}
		}
	}

	public function meshClean(t:Triangle)
	{
		var tmp = [t];
		while( true ) {
			var t = tmp.pop();
			if( t == null ) break;
			if( t.id >= 0 ) continue;
			t.id = this.triangles.length;
			this.triangles.push(t);
			for (n in 0...3)
				if (!t.constrained_edge[n])
					tmp.push(t.neighbors[n]);
		}
	}
}