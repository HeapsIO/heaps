package h2d.filter;

class Group extends Filter {

	var filters : Array<Filter>;

	public function new( filters : Array<Filter> ) {
		super();
		this.filters = filters.copy();
	}

	override function bind(s:Sprite) {
		for( f in filters )
			f.bind(s);
	}

	override function unbind(s:Sprite) {
		for( f in filters )
			f.unbind(s);
	}

	override function sync( ctx:RenderContext, s : Sprite ) {
		this.autoBounds = true;
		this.boundsExtend = 0;
		for( f in filters ) {
			f.sync(ctx, s);
			if(f.boundsExtend > 0) {
				boundsExtend += f.boundsExtend;
			}
			if( !f.autoBounds ) autoBounds = false;
		}
	}

	override function getBounds(s:Sprite, bounds:h2d.col.Bounds) {
		for( f in filters )
			if( !f.autoBounds )
				f.getBounds(s, bounds);
	}

	override function draw( ctx : RenderContext, input : h2d.Tile ) {
		var xMin = input.dx;
		var yMin = input.dy;
		var start = input;
		for( f in filters ) {
			var prev = input;
			input = f.draw(ctx, input);
			if( input == null )
				return null;
			if( input != prev ) {
				input.dx += xMin;
				input.dy += yMin;
			}
		}
		if( start != input ) {
			input.dx -= xMin;
			input.dy -= yMin;
		}
		return input;
	}


}