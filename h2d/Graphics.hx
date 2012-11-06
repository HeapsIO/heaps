package h2d;

@:allow(h2d.Graphics)
class GraphicsContext {
	
	var g : Graphics;
	var mc : flash.display.Sprite;
	
	function new(g) {
		this.g = g;
		this.mc = new flash.display.Sprite();
	}
	
	public inline function beginFill( color : Int, alpha = 1. ) {
		mc.graphics.beginFill(color, alpha);
	}
	
	public inline function drawRect(x,y,width,height) {
		mc.graphics.drawRect(x, y, width, height);
	}
	
	public inline function endFill() {
		mc.graphics.endFill();
	}
	
}

class Graphics extends Sprite {

	var tile : TilePos;
	var ctx : GraphicsContext;
	
	public function beginDraw() {
		return (ctx = new GraphicsContext(this));
	}
	
	override function onDelete() {
		if( tile != null ) {
			tile.tiles.dispose();
			tile = null;
		}
		super.onDelete();
	}
	
	public function endDraw() {
		if( ctx == null ) return;
		if( tile != null ) tile.tiles.dispose();
		tile = Tiles.fromSprites([ctx.mc]).get(0);
	}
	
	override function draw(engine) {
		if( tile == null ) endDraw();
		if( tile == null ) return;
		Bitmap.drawTile(engine, this, tile, null);
	}

}