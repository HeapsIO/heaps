package h2d;

class Slider extends h2d.Interactive {

	public var tile : h2d.Tile;
	public var cursorTile : h2d.Tile;
	public var minValue(default, set) : Float = 0;
	public var maxValue(default, set) : Float = 1;
	public var value(default, set) : Float = 0;

	public function new(?width:Int = 50, ?height:Int = 10, ?parent) {
		super(width, height, parent);

		tile = h2d.Tile.fromColor(0x808080, width, 4);
		tile.dy = (height - 4) >> 1;

		cursorTile = h2d.Tile.fromColor(0xCCCCCC, 5, height);
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
		if( cursorTile != null ) addBounds(relativeTo, out, cursorTile.dx + getDx(), cursorTile.dy, cursorTile.width, cursorTile.height);
	}

	override function draw(ctx:RenderContext) {
		super.draw(ctx);
		if( tile.width != Std.int(width) )
			tile.setSize(Std.int(width), tile.height);
		emitTile(ctx, tile);
		var px = getDx();
		cursorTile.dx += px;
		emitTile(ctx, cursorTile);
		cursorTile.dx -= px;
	}

	var handleDX = 0.0;
	inline function getDx() {
		return Math.round( (value - minValue) * (width - cursorTile.width) / (maxValue - minValue) );
	}

	inline function getValue(cursorX : Float) : Float {
		return ((cursorX - handleDX) / (width - cursorTile.width)) * (maxValue - minValue) + minValue;
	}

	override function handleEvent(e:hxd.Event) {
		super.handleEvent(e);
		if( e.cancel ) return;
		switch( e.kind ) {
		case EPush:
			var dx = getDx();
		   	handleDX = e.relX - dx;

			// If clicking the slider outside the handle, drag the handle
			// by the center of it.
			if (handleDX - cursorTile.dx < 0 || handleDX - cursorTile.dx > cursorTile.width) {
			  handleDX = cursorTile.width * 0.5;
			}

			value = getValue(e.relX);

			onChange();
			var scene = scene;
			startCapture(function(e) {
				if( this.scene != scene || e.kind == ERelease ) {
					scene.stopCapture();
					return;
				}
				value = getValue(e.relX);
				onChange();
			});
		default:
		}
	}

	public dynamic function onChange() {
	}

}
