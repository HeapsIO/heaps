package h2d;

/**
	h2d.Bitmap is used to display a single bitmap Tile on the screen.
**/
class Bitmap extends Drawable {

	/**
		The tile to display see `h2d.Tile` documentation for details.
		If the tile is null, a pink 5x5 bitmap will be displayed instead. Use remove() or visible=false to hide a h2d.Bitmap
	**/
	public var tile : Tile;

	/**
		Create a Bitmap with specified tile and parent object.
	**/
	public function new( ?tile : Tile, ?parent : h2d.Object ) {
		super(parent);
		this.tile = tile;
	}

	override function set_tileWrap(b) {
		if( b && tile != null && tile.getTexture().flags.has(IsNPOT) )
			throw "Cannot set tileWrap on a non power-of-two texture";
		return tileWrap = b;
	}

	override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
		super.getBoundsRec(relativeTo, out, forSize);
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function draw( ctx : RenderContext ) {
		emitTile(ctx,tile);
	}

}
