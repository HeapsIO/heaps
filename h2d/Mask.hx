package h2d;

class Mask extends Sprite {

	public var width : Int;
	public var height : Int;
	
	public function new(width, height, ?parent) {
		super(parent);
		this.width = width;
		this.height = height;
	}

	override function drawRec( ctx : h2d.RenderContext ) {
				
		var x1 = (absX + 1) * 0.5 * ctx.engine.width;
		var y1 = (1 - absY) * 0.5 * ctx.engine.height;
		
		var x2 = ((width * matA + height * matC + absX) + 1) * 0.5 * ctx.engine.width;
		var y2 = (1 - (width * matB + height * matD + absY)) * 0.5 * ctx.engine.height;
		
		ctx.engine.setRenderZone(Std.int(x1+1e-10), Std.int(y1+1e-10), Std.int(x2-x1+1e-10), Std.int(y2-y1+1e-10));
		super.drawRec(ctx);
		ctx.engine.setRenderZone();
	}
	
}