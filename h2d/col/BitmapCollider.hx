package h2d.col;

/**
	A BitmapData collider. Checks for pixel color value under point to be above the cutoff value.
	Note that it checks as `channel > cutoff`, not `channel >= cutoff`, hence value of 255 will always be considered below cutoff.
**/
class BitmapCollider implements Collider {

	public var bitmap : hxd.BitmapData;

	/**
		The red channel cutoff value in range of -1...255 (default : 255)
	**/
	public var redCutoff : Int;
	/**
		The green channel cutoff value in range of -1...255 (default : 255)
	**/
	public var greenCutoff : Int;
	/**
		The blue channel cutoff value in range of -1...255 (default : 255)
	**/
	public var blueCutoff : Int;

	/**
		The alpha channel cutoff value in range of -1...255 (default : 127)
	**/
	public var alphaCutoff : Int;

	/**
		If true, will collide if any channel is above cutoff. Otherwise will collide only if all channels above their cutoff values. (default : true)
	**/
	public var collideOnAny : Bool;

	/**
		Create new BitmapCollider with specified bitmap, channel cutoff values and check mode.
	**/
	public function new(bitmap: hxd.BitmapData, alphaCutoff:Int = 127, redCutoff:Int = 255, greenCutoff = 255, blueCutoff = 255, collideOnAny = true) {
		this.bitmap = bitmap;
		this.alphaCutoff = alphaCutoff;
		this.redCutoff = redCutoff;
		this.greenCutoff = greenCutoff;
		this.blueCutoff = blueCutoff;
		this.collideOnAny = collideOnAny;
	}

	public function contains( p : Point ) {
		var ix : Int = Math.round(p.x);
		var iy : Int = Math.round(p.y);
		if ( bitmap == null || ix < 0 || iy < 0 || ix >= bitmap.width || iy >= bitmap.height ) return false;
		var pixel = bitmap.getPixel(ix, iy);
		if ( collideOnAny ) {
			return (pixel >>> 24       ) > alphaCutoff ||
			       (pixel >>> 16 & 0xff) > blueCutoff ||
			       (pixel >>> 8  & 0xff) > greenCutoff ||
			       (pixel        & 0xff) > redCutoff;
		} else {
			return (pixel >>> 24       ) > alphaCutoff &&
			       (pixel >>> 16 & 0xff) > blueCutoff &&
			       (pixel >>> 8  & 0xff) > greenCutoff &&
			       (pixel        & 0xff) > redCutoff;
		}
	}

}