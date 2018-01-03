package h2d;

class Bitmap extends Drawable {

	public var tile : Tile;

	public function new( ?tile : Tile, ?parent : h2d.Sprite ) {
		super(parent);
		this.tile = tile;
	}

	override function set_tileWrap(b) {
		if( b && tile != null && tile.getTexture().flags.has(IsNPOT) )
			throw "Cannot set tileWrap on a non power-of-two texture";
		return tileWrap = b;
	}

	override function getBoundsRec( relativeTo : Sprite, out : h2d.col.Bounds, forSize : Bool ) {
		super.getBoundsRec(relativeTo, out, forSize);
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function draw( ctx : RenderContext ) {
		emitTile(ctx,tile);
	}

}
