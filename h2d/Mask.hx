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
		super.onParentChanged();
		updateMask();
	}

	override function onAdd() {
		super.onAdd();
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

	override function getBoundsRec( relativeTo, out:h2d.col.Bounds, forSize ) {
		var xMin = out.xMin, yMin = out.yMin, xMax = out.xMax, yMax = out.yMax;
		out.empty();
		if( posChanged ) {
			calcAbsPos();
			for( c in children )
				c.posChanged = true;
			posChanged = false;
		}
		addBounds(relativeTo, out, 0, 0, width, height);
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
		var x1 = absX;
		var y1 = absY;

		var x2 = width * matA + height * matC + absX;
		var y2 = width * matB + height * matD + absY;

		ctx.flush();
		if( ctx.hasRenderZone ) {
			var oldX = ctx.renderX, oldY = ctx.renderY, oldW = ctx.renderW, oldH = ctx.renderH;
			ctx.setRenderZone(x1, y1, x2-x1, y2-y1);
			super.drawRec(ctx);
			ctx.flush();
			ctx.setRenderZone(oldX, oldY, oldW, oldH);
		} else {
			ctx.setRenderZone(x1, y1, x2-x1, y2-y1);
			super.drawRec(ctx);
			ctx.flush();
			ctx.clearRenderZone();
		}
	}

}