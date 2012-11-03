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
	
	public function endDraw() {
		if( ctx == null )
			return;
		tile = Tiles.fromSprites([ctx.mc]).get(0);
		ctx = null;
	}
	
	override function draw(engine) {
		if( ctx != null ) endDraw();
		Bitmap.drawTile(engine, this, tile, null);
	}

}