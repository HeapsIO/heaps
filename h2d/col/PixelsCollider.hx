package h2d.col;

/**
	A Pixels collider. Checks for pixel color value under point to be above the cutoff value.
	Note that it checks as `channel > cutoff`, not `channel >= cutoff`, hence value of 255 will always be considered below cutoff.
**/
class PixelsCollider implements Collider {

	public var pixels : hxd.Pixels;

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
		Horizontal stretch of pixels to check for collision. (default : 1)
	**/
	public var scaleX : Float = 1;
	/**
		Vertical stretch of pixels to check for collision. (default : 1)
	**/
	public var scaleY : Float = 1;

	/**
		Create new BitmapCollider with specified bitmap, channel cutoff values and check mode.
	**/
	public function new(pixels: hxd.Pixels, alphaCutoff:Int = 127, redCutoff:Int = 255, greenCutoff = 255, blueCutoff = 255, collideOnAny = true) {
		this.pixels = pixels;
		this.alphaCutoff = alphaCutoff;
		this.redCutoff = redCutoff;
		this.greenCutoff = greenCutoff;
		this.blueCutoff = blueCutoff;
		this.collideOnAny = collideOnAny;
	}

	public function contains( p : Point ) {
		var ix : Int = Math.floor(p.x / scaleX);
		var iy : Int = Math.floor(p.y / scaleY);
		if ( pixels == null || ix < 0 || iy < 0 || ix >= pixels.width || iy >= pixels.height ) return false;
		var pixel = pixels.getPixel(ix, iy);
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