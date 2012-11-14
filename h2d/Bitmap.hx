package h2d;

class Bitmap extends Sprite {

	public var tile : Tile;
	public var color : h3d.Color;
	public var alpha(get, set) : Float;
	
	public function new( ?tile, ?parent ) {
		super(parent);
		color = new h3d.Color(1, 1, 1, 1);
		this.tile = tile;
	}
	
	override function draw( engine : h3d.Engine ) {
		Tools.drawTile(engine, this, tile, color, blendMode);
	}
	
	inline function get_alpha() {
		return color.a;
	}

	inline function set_alpha(v) {
		return color.a = v;
	}
		
	public static function create( bmp : flash.display.BitmapData, freeBitmap = true ) {
		return new Bitmap(Tile.fromBitmap(bmp,freeBitmap));
	}
	
}