package h3d.prim;

class Cube extends Polygon {

	public function new( x = 1., y = 1., z = 1. )
	{
		var p = [
			new Point(0, 0, 0),
			new Point(x, 0, 0),
			new Point(0, y, 0),
			new Point(0, 0, z),
			new Point(x, y, 0),
			new Point(x, 0, z),
			new Point(0, y, z),
			new Point(x, y, z),
		];
		var idx = [
			0, 1, 5,
			0, 5, 3,
			1, 4, 7,
			1, 7, 5,
			3, 5, 7,
			3, 7, 6,
			0, 6, 2,
			0, 3, 6,
			2, 7, 4,
			2, 6, 7,
			0, 4, 1,
			0, 2, 4,
		];
		super(p, idx);
	}
	
	override function addUVs() {
		unindex();
		
		var z = new UV(0, 0);
		var x = new UV(1, 0);
		var y = new UV(0, 1);
		var o = new UV(1, 1);
		
		tcoords = [
			z, x, o,
			z, o, y,
			x, z, y,
			x, y, o,
			z, x, o,
			z, o, y,
			z, o, x,
			z, y, o,
			x, y, z,
			x, o, y,
			z, o, x,
			z, y, o,
		];
	}
	
}