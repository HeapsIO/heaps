package h2d;

/**
	A simple interactive horizontal numerical slider.
**/
class Slider extends h2d.Interactive {
	/**
		The slider background tile.

		If Tile width does not match with Slider width, it will be resized through `Tile.setSize` to match the Slider width.

		Defaults to the monocolor 0x808080 Tile with the size of `Slider.width x 4` and centered vertically within `Slider.height`.
	**/
	public var tile : h2d.Tile;
	/**
		Tile of the slider current position caret.

		Defaults to the monocolor #CCCCCC Tile with the size of `5 x Slider.height`.
	**/
	public var cursorTile : h2d.Tile;
	/**
		The minimum value the Slider can allow.
	**/
	public var minValue(default, set) : Float = 0;
	/**
		The maximum value the Slider can allow.
	**/
	public var maxValue(default, set) : Float = 1;
	/**
		Current value of the Slider.
		When set, will be clamped to `minValue <= value <= maxValue`.
	**/
	public var value(default, set) : Float = 0;

	/**
		Create a new Slider width specified dimensions and parent.
		@param width The width of the Slider interactive area.
		@param height The height of the Slider interactive area.
		@param parent An optional parent `h2d.Object` instance to which Sliders adds itself if set.
	**/
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

	/**
		Sent when slider value is changed by user.

		Not sent if value is set manually from software side.
	**/
	public dynamic function onChange() {
	}

}
