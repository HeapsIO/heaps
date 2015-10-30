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

	public function getTile( ?ctx : RenderContext ) {
		if( tile == null ) {
			var scene = ctx == null ? getScene() : ctx.scene;
			if( scene == null ) return null;
			var tw = width < 0 ? scene.width : width;
			var th = height < 0 ? scene.height : height;
			var tex = new h3d.mat.Texture(tw, th, [Target]);
			renderDone = false;
			tile = Tile.fromTexture(tex);
		}
		return tile;
	}

	function syncPosRec( s : Sprite ) {
		s.calcAbsPos();
		s.posChanged = true;
		for( c in s.childs )
			syncPosRec(c);
	}

	override function draw( ctx : RenderContext ) {
		emitTile(ctx, tile);
	}

	override function drawRec( ctx : RenderContext ) {
		var scene = ctx.scene;
		if( tile != null && ((width < 0 && scene.width != tile.width) || (height < 0 && scene.height != tile.height)) )
			clean();
		var tile = getTile(ctx);
		if( !freezed || !renderDone ) {
			var oldA = matA, oldB = matB, oldC = matC, oldD = matD, oldX = absX, oldY = absY;

			// init matrix without transformation
			matA = 1;
			matB = 0;
			matC = 0;
			matD = 1;
			absX = 0;
			absY = 0;

			// force full resync
			for( c in childs )
				syncPosRec(c);

			ctx.pushTarget(tile.getTexture());
			ctx.engine.clear(0);
			var old = ctx.globalAlpha;
			ctx.globalAlpha = 1;
			for( c in childs )
				c.drawRec(ctx);
			ctx.globalAlpha = old;
			ctx.popTarget();

			// restore
			matA = oldA;
			matB = oldB;
			matC = oldC;
			matD = oldD;
			absX = oldX;
			absY = oldY;

			renderDone = true;
		}

		draw(ctx);
	}

}