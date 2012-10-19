package h2d;

class Scene extends Sprite {

	var savedWidth : Int;
	var savedHeight : Int;
	
	public function new() {
		super(null);
	}
	
	override function render( engine : h3d.Engine ) {
		if( savedWidth != engine.width || savedHeight != engine.height )
			posChanged = true;
		updatePos();
		if( posChanged ) {
			// adds a pixels-to-viewport transform
			var w = 2 / engine.width;
			var h = -2 / engine.height;
			absX = absX * w - 1;
			absY = absY * h + 1;
			matA *= w;
			matB *= w;
			matC *= h;
			matD *= h;
			savedWidth = engine.width;
			savedHeight = engine.height;
		}
		draw(engine);
		for( c in childs )
			c.render(engine);
		posChanged = false;
	}
	
	
}