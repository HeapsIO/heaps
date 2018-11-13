package h2d;

/**
	A camera-parallaxing object that can be used to change the speed at which
	object moves along camera.
	Parallaxing is only a visual change and does not affect actual position.
	Due to that please refrain from using Interactive objects with ParallaxObject.
	This limitation is due to how cameras works in Heaps.

	Additionally, using multiple parallax objects in single object tree branch
	will lead to undefined behavior. Higher-level object will override and reset the
	parallax value of lower-level object and will not return it to old values.
**/
class ParallaxObject extends Object {

	/**
		Horizontal scroll factor of Object relative to camera. (default 1.0)
	**/
	public var scrollX : Float;
	/**
		Vertical scroll factor of Object relative to camera. (default 1.0)
	**/
	public var scrollY : Float;

	/**
		Create new Parallaxing Object with specified scrollX, scrollY and parent.
	**/
	public function new( scrollX : Float = 1, scrollY : Float = 1, ?parent : Object ) {
		super(parent);
		this.scrollX = scrollX;
		this.scrollY = scrollY;
	}

	override private function drawRec( ctx : RenderContext ) {
		ctx.setParallax(scrollX, scrollY);
		super.drawRec(ctx);
		ctx.setParallax(1, 1);
	}

}