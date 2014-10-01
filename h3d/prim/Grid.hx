package h3d.prim;

class Grid extends Polygon {

	public function new( width : Int, height : Int, cellWidth = 1., cellHeight = 1. ) {
		var idx = new hxd.IndexBuffer();
		for( y in 0...height )
			for( x in 0...width ) {
				var s = x + y * (width + 1);
				idx.push(s);
				idx.push(s + 1);
				idx.push(s + width + 1);
				idx.push(s + 1);
				idx.push(s + width + 2);
				idx.push(s + width + 1);
			}
		super(
			[for( y in 0...height + 1 ) for( x in 0...width + 1 ) new h3d.col.Point(x * cellWidth, y * cellHeight, 0)],
			idx
		);
	}

}