package h2d;

/**
	Restricts rendering area within the `[width, height]` rectangle.
	For more advanced masking, see `h2d.filter.AbstractMask`.

	Rotation of the mask does not rotate the masked area and instead causes it to cover the bounding box of the mask.

	The `Mask.maskWidth` and `Mask.unmask` can be used to mask out rendering area without direct usage of Mask instance in-between.
**/
class Mask extends Object {

	/**
		Masks render zone based off object position and given dimensions.
		Should call `Mask.unmask()` afterwards.
		@param ctx The render context to mask.
		@param object An Object which transform will be used as mask origin.
		@param width The width of the mask in scene coordinate space.
		@param height The height of the mask in scene coordinate space.
		@param scrollX Additional horizontal offset of the masked area.
		@param scrollY Additional vertical offset of the masked area.
	**/
	@:access(h2d.RenderContext)
	public static function maskWith( ctx : RenderContext, object : Object, width : Int, height : Int, scrollX : Float = 0, scrollY : Float = 0) {

		var x1 = object.absX + scrollX;
		var y1 = object.absY + scrollY;

		var x2 = width * object.matA + height * object.matC + x1;
		var y2 = width * object.matB + height * object.matD + y1;

		var tmp;
		if (x1 > x2) {
			tmp = x1;
			x1 = x2;
			x2 = tmp;
		}

		if (y1 > y2) {
			tmp = y1;
			y1 = y2;
			y2 = tmp;
		}

		ctx.flush();
		ctx.clipRenderZone(x1, y1, x2-x1, y2-y1);
	}

	/**
		Unmasks the previously masked area from `Mask.maskWith`.
		@param ctx The render context to unmask.
	**/
	public static function unmask( ctx : RenderContext ) {
		ctx.flush();
		ctx.popRenderZone();
	}

	/**
		The width of the masked area.
	**/
	public var width : Int;
	/**
		The height of the masked area.
	**/
	public var height : Int;

	/**
		Horizontal scroll offset of the Mask content in pixels. Can be clamped by `Mask.scrollBounds`.
	**/
	public var scrollX(default, set) : Float = 0;
	/**
		Vertical scroll offset of the Mask content in pixels. Can be clamped by `Mask.scrollBounds`.
	**/
	public var scrollY(default, set) : Float = 0;

	/**
		Optional scroll boundaries that prevent content from overscroll.
	**/
	public var scrollBounds : h2d.col.Bounds;

	/**
		Create a new Mask instance.
		@param width The width of the masked area.
		@param height The height of the masked area.
		@param parent An optional parent `h2d.Object` instance to which Mask adds itself if set.
	**/
	public function new(width, height, ?parent) {
		super(parent);
		this.width = width;
		this.height = height;
	}

	/**
		Scroll the Mask content to the specified offset.
	**/
	public function scrollTo( x : Float, y : Float ) {
		scrollX = x;
		scrollY = y;
	}

	/**
		Scroll the Mask content by the specified offset relative to the current scroll offset.
	**/
	public function scrollBy( x : Float, y : Float ) {
		scrollX += x;
		scrollY += y;
	}

	function set_scrollX( v : Float ) : Float {
		if ( scrollBounds != null ) v = hxd.Math.clamp(v, scrollBounds.xMin, scrollBounds.xMax - width);
		posChanged = true;
		return scrollX = v;
	}

	function set_scrollY( v : Float ) : Float {
		if ( scrollBounds != null ) v = hxd.Math.clamp(v, scrollBounds.yMin, scrollBounds.yMax - height);
		posChanged = true;
		return scrollY = v;
	}

	override function calcAbsPos() {
		super.calcAbsPos();
		absX -= scrollX;
		absY -= scrollY;
	}

	override function getBoundsRec( relativeTo, out:h2d.col.Bounds, forSize ) {
		var xMin = out.xMin, yMin = out.yMin, xMax = out.xMax, yMax = out.yMax;
		out.empty();
		if( posChanged ) {
			calcAbsPos();
			for( c in children )
				c.posChanged = true;
			posChanged = false;
		}
		addBounds(relativeTo, out, scrollX, scrollY, width, height);
		var bxMin = out.xMin, byMin = out.yMin, bxMax = out.xMax, byMax = out.yMax;
		out.xMin = xMin;
		out.xMax = xMax;
		out.yMin = yMin;
		out.yMax = yMax;
		super.getBoundsRec(relativeTo, out, forSize);
		if( out.xMin < bxMin ) out.xMin = hxd.Math.min(xMin, bxMin);
		if( out.yMin < byMin ) out.yMin = hxd.Math.min(yMin, byMin);
		if( out.xMax > bxMax ) out.xMax = hxd.Math.max(xMax, bxMax);
		if( out.yMax > byMax ) out.yMax = hxd.Math.max(yMax, byMax);
	}

	override function drawRec( ctx : h2d.RenderContext ) @:privateAccess {
		maskWith(ctx, this, width, height, scrollX, scrollY);
		super.drawRec(ctx);
		unmask(ctx);
	}

}