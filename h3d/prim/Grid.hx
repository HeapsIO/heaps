package h3d.prim;

class Grid extends Polygon {

	public var width (default, null) : Int;
	public var height (default, null)  : Int;
	public var cellWidth (default, null) : Float;
	public var cellHeight (default, null)  : Float;

	public function new( width : Int, height : Int, cellWidth = 1., cellHeight = 1. ) {
		this.width = width;
		this.height = height;
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;

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

	override function addUVs() {
		uvs = [];
		for(i in 0 ... points.length){
			var y = hxd.Math.floor(i / (width + 1));
			var x = i - y * (width + 1);
			uvs.push(new UV(x/width,y/height));
		}
	}

}