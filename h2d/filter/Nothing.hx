package h2d.filter;

class Nothing extends Filter {

	public function new() {
		super();
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		return t;
	}

}