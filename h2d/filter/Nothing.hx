package h2d.filter;

/**
	A filter that renders nothing.
**/
class Nothing extends Filter {

	/**
		Create a new Nothing filter.
	**/
	public function new() {
		super();
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		return t;
	}

}