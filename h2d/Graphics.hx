package h2d;

#if flash
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

class Graphics extends Drawable {

	var tile : Tile;
	var ctx : GraphicsContext;
	
	public function new(?parent) {
		super(parent);
	}
		
	public function beginDraw() {
		return (ctx = new GraphicsContext(this));
	}
	
	override function onDelete() {
		if( tile != null ) {
			tile.dispose();
			tile = null;
		}
		super.onDelete();
	}
	
	public function endDraw( restoreOnContextLost = false, ?allocPos : h3d.impl.AllocPos ) {
		if( ctx == null ) return;
		if( tile != null ) tile.dispose();
		tile = Tile.fromSprites([ctx.mc], allocPos)[0];
		if( restoreOnContextLost ) {
			var ctx = ctx;
			tile.getTexture().onContextLost = function() {
				this.ctx = ctx;
				endDraw();
			};
		}
	}
	
	override function draw(ctx:RenderContext) {
		if( tile == null ) endDraw();
		if( tile == null ) return;
		drawTile(ctx.engine, tile);
	}

}

#end
