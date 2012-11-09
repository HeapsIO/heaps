package h2d;

@:allow(h2d.Graphics)
class GraphicsContext {
	
	var g : Graphics;
	var mc : flash.display.Sprite;
	var mcg : flash.display.Graphics;
	
	function new(g) {
		this.g = g;
		this.mc = new flash.display.Sprite();
		mcg = mc.graphics;
	}
	
	public inline function beginFill( color : Int, alpha = 1. ) {
		mcg.beginFill(color, alpha);
	}
	
	public inline function drawCircle(cx, cy, radius) {
		mcg.drawCircle(cx, cy, radius);
	}
	
	public inline function drawRect(x,y,width,height) {
		mcg.drawRect(x, y, width, height);
	}
	
	public inline function endFill() {
		mcg.endFill();
	}
	
}

class Graphics extends Sprite {

	var tile : Tile;
	var ctx : GraphicsContext;
		
	public function beginDraw() {
		return (ctx = new GraphicsContext(this));
	}
	
	override function onDelete() {
		if( tile != null ) {
			tile.tex.dispose();
			tile = null;
		}
		super.onDelete();
	}
	
	public function endDraw() {
		if( ctx == null ) return;
		if( tile != null ) tile.tex.dispose();
		tile = Tile.fromSprites([ctx.mc])[0];
	}
	
	override function draw(engine) {
		if( tile == null ) endDraw();
		if( tile == null ) return;
		Tools.drawTile(engine, this, tile, null, blendMode);
	}

}