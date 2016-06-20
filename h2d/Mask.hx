package h2d;

class Mask extends Sprite {

	public var width : Int;
	public var height : Int;
	var parentMask : Mask;

	public function new(width, height, ?parent) {
		super(parent);
		this.width = width;
		this.height = height;
	}

	override function onParentChanged() {
		updateMask();
	}

	override function onAlloc() {
		super.onAlloc();
		updateMask();
	}

	function updateMask() {
		parentMask = null;
		var p = parent;
		while( p != null ) {
			var m = Std.instance(p, Mask);
			if( m != null ) {
				parentMask = m;
				break;
			}
			p = p.parent;
		}
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		var xMin = out.xMin, yMin = out.yMin, xMax = out.xMax, yMax = out.yMax;
		out.empty();
		addBounds(relativeTo, out, 0, 0, width, height);
		if( xMin > out.xMin ) out.xMin = xMin;
		if( yMin > out.yMin ) out.yMin = yMin;
		if( xMax < out.xMax ) out.xMax = xMax;
		if( yMax < out.yMax ) out.yMax = yMax;
	}

	override function drawRec( ctx : h2d.RenderContext ) {

		var x1 = absX;
		var y1 = absY;

		var x2 = width * matA + height * matC + absX;
		var y2 = width * matB + height * matD + absY;

		var s = ctx.scene;
		x1 *= ctx.engine.width / s.width;
		x2 *= ctx.engine.width / s.width;
		y1 *= ctx.engine.height / s.height;
		y2 *= ctx.engine.height / s.height;

		ctx.flush();
		ctx.engine.setRenderZone(Std.int(x1+1e-10), Std.int(y1+1e-10), Std.int(x2-x1+1e-10), Std.int(y2-y1+1e-10));
		super.drawRec(ctx);
		ctx.flush();
		ctx.engine.setRenderZone();
	}

}