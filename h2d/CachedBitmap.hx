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

	function clean() {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		tile = null;
	}

	override function onDelete() {
		clean();
		super.onDelete();
	}
	
	function set_width(w) {
		clean();
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
	
	public function getTile() {
		if( tile == null ) {
			var tw = 1, th = 1;
			var engine = h3d.Engine.getCurrent();
			realWidth = width < 0 ? engine.width : width;
			realHeight = height < 0 ? engine.height : height;
			while( tw < realWidth ) tw <<= 1;
			while( th < realHeight ) th <<= 1;
			tex = engine.mem.allocTargetTexture(tw, th);
			renderDone = false;
			tile = new Tile(tex,0, 0, realWidth, realHeight);
		}
		return tile;
	}

	override function drawRec( ctx : RenderContext ) {
		emitTile(ctx, tile);
	}
	
	override function sync( ctx : RenderContext ) {
		if( posChanged ) {
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
		if( tex != null && ((width < 0 && tex.width < ctx.engine.width) || (height < 0 && tex.height < ctx.engine.height)) )
			clean();
		var tile = getTile();
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

			// force full resync
			for( c in childs ) {
				c.posChanged = true;
				c.sync(ctx);
			}

			throw "Should not draw in sync!";
			ctx.engine.setTarget(tex);
			ctx.engine.setRenderZone(0, 0, realWidth, realHeight);
			for( c in childs )
				c.drawRec(ctx);
			ctx.engine.setTarget(null);
			ctx.engine.setRenderZone();
			
			// restore
			matA = oldA;
			matB = oldB;
			matC = oldC;
			matD = oldD;
			absX = oldX;
			absY = oldY;
			
			renderDone = true;
		}

		super.sync(ctx);
	}
	
}