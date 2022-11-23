package h2d.filter;

/**
	Applies an array of Filters to a single Object with several limitations.

	* If all filters in the Group are disabled - `Filter.enable` will report `false` even if Group itself is enabled.  
	* `Filter.boundsExtend` and `Filter.autoBounds` are automatically managed by Group instance.
	* `boundsExtend` is a sum of all filter extends and `autoBounds` enabled only when all filters have it enabled.

	When `autoBounds` is disabled, bounds are a result of calling `Filter.getBounds` on children filters, but most likely
	will contain only the bounds filled by last filter, because `Object.getBounds` clears the `Bounds` instance.

	Ensure that all relevant filters are added to Group prior binding it to any Object. Behavior is undefined otherwise.
**/
class Group extends Filter {

	var filters : Array<Filter>;

	/**
		Create a new filter Group.
		@param filters Optional list of the Filters bound to the group.
	**/
	public function new( ?filters : Array<Filter> ) {
		super();
		this.filters = filters == null ? [] : filters;
	}

	override function get_enable() {
		if( !enable ) return false;
		for( f in filters ) if( enable ) return true;
		return false;
	}

	/**
		Adds new Filter `f` to the Group.  
		Due to implementation specifics, if Group was already bound, new filters won't receive a `bind` call.
	**/
	public function add( f : Filter ) {
		filters.push(f);
	}

	/**
		Removes the Filter `f` from the Group.
		Due to implementation specifics, removed filter won't receive an `unbind` call even if it was bound previously.
	**/
	public function remove( f : Filter ) {
		return filters.remove(f);
	}

	override function bind(s:Object) {
		for( f in filters )
			if( f.enable )
				f.bind(s);
	}

	override function unbind(s:Object) {
		for( f in filters )
			if( f.enable )
				f.unbind(s);
	}

	override function sync( ctx:RenderContext, s : Object ) {
		this.autoBounds = true;
		this.boundsExtend = 0;
		for( f in filters ) {
			if (!f.enable) continue;
			f.sync(ctx, s);
			if(f.boundsExtend > 0) {
				boundsExtend += f.boundsExtend;
			}
			if( !f.autoBounds ) autoBounds = false;
		}
	}

	override function getBounds(s:Object, bounds:h2d.col.Bounds, scale:h2d.col.Point) {
		for( f in filters )
			if( f.enable && !f.autoBounds )
				f.getBounds(s, bounds, scale);
	}

	override function draw( ctx : RenderContext, input : h2d.Tile ) {
		var xMin = input.dx;
		var yMin = input.dy;
		var start = input;
		for( f in filters ) {
			if (!f.enable) continue;
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
