package h2d.filter;

/**
	The base filter class, you can extend it in order to define your own filters, although ShaderFilter will be the most straightforward way to define simple custom filter.
**/
class Filter {

	public var autoBounds = true;
	public var boundsExtend : Float = 0.;
	public var smooth = false;
	@:isVar public var enable(get,set) = true;

	function new() {
	}
	
	function get_enable() return enable;
	function set_enable(v) return enable = v;

	public function sync( ctx : RenderContext, s : Object ) {
	}

	public function bind( s : Object ) {
	}

	public function unbind( s : Object ) {
	}

	public function getBounds( s : Object, bounds : h2d.col.Bounds ) {
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