package h2d;

class CachedBitmap extends Drawable {

	public var width(default, set) : Int;
	public var height(default, set) : Int;
	public var freezed : Bool;

	var renderDone : Bool;
	var tile : Tile;

	public function new( ?parent, width = -1, height = -1 ) {
		super(parent);
		this.width = width;
		this.height = height;
	}

	function clean() {
		if( tile != null ) {
			tile.dispose();
			tile = null;
		}
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
		clean();
		height = h;
		return h;
	}

	public function getTile() {
		if( tile == null ) {
			var scene = getScene();
			if( scene == null ) return null;
			var tw = width < 0 ? scene.width : width;
			var th = height < 0 ? scene.height : height;
			var tex = new h3d.mat.Texture(tw, th, [Target]);
			renderDone = false;
			tile = Tile.fromTexture(tex);
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
		var scene = getScene();
		if( tile != null && ((width < 0 && scene.width != tile.width) || (height < 0 && scene.height != tile.height)) )
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
			var w = 2 / tile.width;
			var h = -2 / tile.height;
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
			ctx.engine.setTarget(tile.getTexture());
			for( c in childs )
				c.drawRec(ctx);
			ctx.engine.setTarget(null);

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