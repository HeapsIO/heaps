package h2d;

class Bitmap extends Sprite {

	public var data : TilePos;
	public var color : h3d.Color;
	public var alpha(get, set) : Float;
	
	public function new( ?data : TilePos, ?parent ) {
		super(parent);
		color = new h3d.Color(1, 1, 1, 1);
		this.data = data;
	}
	
	override function draw( engine : h3d.Engine ) {
		Tools.drawTile(engine, this, data, color, blendMode);
	}
	
	inline function get_alpha() {
		return color.a;
	}

	inline function set_alpha(v) {
		return color.a = v;
	}
		
	public static function ofBitmap( bmp : flash.display.BitmapData ) {
		return new Bitmap(Tiles.fromBitmap(bmp).get(0));
	}
	
}