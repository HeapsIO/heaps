package h2d.filter;

class Group extends Filter {

	var filters : Array<Filter>;

	public function new( ?filters : Array<Filter> ) {
		super();
		this.filters = filters == null ? [] : filters;
	}
	
	override function get_enable() {
		if( !enable ) return false;
		for( f in filters ) if( enable ) return true;
		return false;
	}
	
	public function add( f : Filter ) {
		filters.push(f);
	}

	public function remove( f : Filter ) {
		return filters.remove(f);
	}

	override function bind(s:Object) {
		for( f in filters )
			f.bind(s);
	}

	override function unbind(s:Object) {
		for( f in filters )
			f.unbind(s);
	}

	override function sync( ctx:RenderContext, s : Object ) {
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

	override function getBounds(s:Object, bounds:h2d.col.Bounds) {
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