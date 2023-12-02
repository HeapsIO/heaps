package hxd.poly2tri;

class VisiblePolygon
{

	var sweepContext:SweepContext;
	var sweep:Sweep;
	var triangulated:Bool;

	public function new()
	{
		reset();
	}


	public function addPolyline(polyline:Array<Point>)
	{
		sweepContext.addPolyline(polyline);
	}

	public function reset()
	{
		sweepContext = new SweepContext();
		sweep = new Sweep(sweepContext);
		triangulated = false;
	}

	public function performTriangulationOnce()
	{
		if (this.triangulated) return;
		triangulated = true;
		sweep.triangulate();
	}

	//returns vertices in a 3D engine-friendly, XYZ format
	public function getVerticesAndTriangles()
	{
		if (!this.triangulated) return null;

		var vertices = new Array();
		var ids = new Map();

		for (i in 0...sweepContext.points.length)
		{
			var p = sweepContext.points[i];
			vertices.push(p.x);
			vertices.push(p.y);
			vertices.push(0);
			ids[p.id] = i;
		}

		var tris = new Array();
		for (t in sweepContext.triangles)
		{
			for (i in 0...3)
			{
				tris.push( ids[ t.points[i].id ] );
			}
		}

		return { vertices: vertices, triangles:tris };
	}

	public function getNumTriangles()
	{
		return sweepContext.triangles.length;
	}

}
