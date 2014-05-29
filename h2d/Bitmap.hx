package h2d;

class Bitmap extends Drawable {

	public var tile : Tile;

	public function new( ?tile, ?parent ) {
		super(parent);
		this.tile = tile;
	}

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function draw( ctx : RenderContext ) {
		emitTile(ctx,tile);
	}

	public static function create( bmp : hxd.BitmapData, ?allocPos : h3d.impl.AllocPos ) {
		return new Bitmap(Tile.fromBitmap(bmp,allocPos));
	}

}