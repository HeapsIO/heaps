package h2d;

class CachedBitmap extends Drawable {

	var tex : h3d.mat.Texture;
	public var width(default, set) : Int;
	public var height(default, set) : Int;
	public var freezed : Bool;
	
	var renderDone : Bool;
	var realWidth : Int;
	var realHeight : Int;
	var tile : Tile;
	
	public function new( ?parent, width = -1, height = -1 ) {
		super(parent);
		this.width = width;
		this.height = height;
	}
	
	override function onDelete() {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		super.onDelete();
	}
	
	function set_width(w) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		width = w;
		return w;
	}

	function set_height(h) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		height = h;
		return h;
	}

	override function draw( engine : h3d.Engine ) {
		drawTile(engine, tile);
	}
	
	override function render( engine : h3d.Engine ) {
		updatePos();
		if( tex != null && ((width < 0 && tex.width < engine.width) || (height < 0 && tex.height < engine.height)) ) {
			tex.dispose();
			tex = null;
		}
		if( tex == null ) {
			var tw = 1, th = 1;
			realWidth = width < 0 ? engine.width : width;
			realHeight = height < 0 ? engine.height : height;
			while( tw < realWidth ) tw <<= 1;
			while( th < realHeight ) th <<= 1;
			tex = engine.mem.allocTargetTexture(tw, th);
			renderDone = false;
			tile = new Tile(tex,0, 0, realWidth, realHeight);
		}
		if( !freezed || !renderDone ) {
			var oldA = matA, oldB = matB, oldC = matC, oldD = matD, oldX = absX, oldY = absY;
			
			// init matrix without rotation
			matA = 1;
			matB = 0;
			matC = 0;
			matD = 1;
			absX = 0;
			absY = 0;
			
			// adds a pixels-to-viewport transform
			var w = 2 / tex.width;
			var h = -2 / tex.height;
			absX = absX * w - 1;
			absY = absY * h + 1;
			matA *= w;
			matB *= h;
			matC *= w;
			matD *= h;
			
			engine.setTarget(tex);
			engine.setRenderZone(0, 0, realWidth, realHeight);
			for( c in childs )
				c.render(engine);
			engine.setTarget(null);
			engine.setRenderZone();
			
			// restore
			matA = oldA;
			matB = oldB;
			matC = oldC;
			matD = oldD;
			absX = oldX;
			absY = oldY;
			
			renderDone = true;
		}

		draw(engine);
		posChanged = false;
	}
	
}