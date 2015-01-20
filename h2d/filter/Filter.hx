package h2d.filter;

class Filter {

	public var autoBounds = true;
	public var boundsExtend : Float = 0.;
	public var filter = false;

	function new() {
	}

	public function sync( ctx : RenderContext, s : Sprite ) {
	}

	public function getBounds( s : Sprite, bounds : h2d.col.Bounds ) {
		s.getBounds(s, bounds);
		bounds.xMin -= boundsExtend;
		bounds.yMin -= boundsExtend;
		bounds.xMax += boundsExtend;
		bounds.yMax += boundsExtend;
	}

	public function draw( ctx : RenderContext, input : h2d.Tile ) {
		return input;
	}

}