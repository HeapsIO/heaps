package h2d;

class Slider extends h2d.Interactive {

	public var tile : h2d.Tile;
	public var cursorTile : h2d.Tile;
	public var minValue(default, set) : Float = 0;
	public var maxValue(default, set) : Float = 1;
	public var value(default, set) : Float = 0;

	public function new(?width:Int, ?height:Int, ?parent) {
		super(width, height, parent);

		tile = h2d.Tile.fromColor(0x808080, width, 4);
		tile.dy = (height - 4) >> 1;

		cursorTile = h2d.Tile.fromColor(0xCCCCCC, 5, height);
		cursorTile.dx = -2;
	}

	function set_minValue(v) {
		if( value < v ) value = v;
		return minValue = v;
	}

	function set_maxValue(v) {
		if( value > v ) value = v;
		return maxValue = v;
	}

	function set_value(v) {
		if( v < minValue ) v = minValue;
		if( v > maxValue ) v = maxValue;
		return value = v;
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		if( forSize ) addBounds(relativeTo, out, 0, 0, width, height);
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function draw(ctx:RenderContext) {
		super.draw(ctx);
		emitTile(ctx, tile);
		var px = Math.round( (value - minValue) * (width - cursorTile.width) / (maxValue - minValue) ) - cursorTile.dx;
		cursorTile.dx += px;
		emitTile(ctx, cursorTile);
		cursorTile.dx -= px;
	}

	override function handleEvent(e:hxd.Event) {
		super.handleEvent(e);
		if( e.cancel ) return;
		switch( e.kind ) {
		case EPush:
			value = (e.relX / width) * (maxValue - minValue) + minValue;
			onChange();
			var scene = scene;
			startDrag(function(e) {
				if( this.scene != scene || e.kind == ERelease ) {
					scene.stopDrag();
					return;
				}
				value = (e.relX / width) * (maxValue - minValue) + minValue;
				onChange();
			});
		default:
		}
	}

	public dynamic function onChange() {
	}

}