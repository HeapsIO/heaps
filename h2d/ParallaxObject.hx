package h2d;

class ParallaxObject extends Object {

	/**
		Horizontal scroll factor of Object relative to camera. (default 1.0)
		Note that this is only a visual change and does not affect actual position,
		use case of this variable is to allow parallaxing of objects.
		This limitation is due to how cameras works in Heaps.
	**/
	public var camScrollX(default, set) : Float;
	/**
		Vertical scroll factor of Object relative to camera. (default 1.0)
		Note that this is only a visual change and does not affect actual position,
		use case of this variable is to allow parallaxing of objects.
		This limitation is due to how cameras works in Heaps.
	**/
	public var camScrollY(default, set) : Float;

	public function new( scrollX : Float = 1, scrollY : Float = 1, ?parent : Object ) {
		super(parent);
	}

	override private function calcAbsPos()
	{
		super.calcAbsPos();
	}

	inline function set_camScrollX(v) {
		posChanged = true;
		return camScrollX = v;
	}

	inline function set_camScrollY(v) {
		posChanged = true;
		return camScrollY = v;
	}

	override private function drawRec(ctx:RenderContext)
	{
		ctx.setParallax(camScrollX, camScrollY);
		super.drawRec(ctx);
	}

}