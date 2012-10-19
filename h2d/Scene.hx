package h2d;

class Scene extends Sprite {

	var savedWidth : Int;
	var savedHeight : Int;
	
	public function new() {
		super(null);
	}

	override function updatePos() {
		// don't take the parent into account
		if( !posChanged )
			return;
			
		// init matrix without rotation
		matA = scaleX;
		matB = 0;
		matC = 0;
		matD = scaleY;
		absX = x;
		absY = y;
		
		// adds a pixels-to-viewport transform
		var w = 2 / savedWidth;
		var h = -2 / savedHeight;
		absX = absX * w - 1;
		absY = absY * h + 1;
		matA *= w;
		matB *= h;
		matC *= w;
		matD *= h;
		
		// perform final rotation around center
		if( rotation != 0 ) {
			var cr = Math.cos(rotation * Sprite.ROT2RAD);
			var sr = Math.sin(rotation * Sprite.ROT2RAD);
			var tmpA = matA * cr + matB * sr;
			var tmpB = matA * -sr + matB * cr;
			var tmpC = matC * cr + matD * sr;
			var tmpD = matC * -sr + matD * cr;
			var tmpX = absX * cr + absY * sr;
			var tmpY = absX * -sr + absY * cr;
			matA = tmpA;
			matB = tmpB;
			matC = tmpC;
			matD = tmpD;
			absX = tmpX;
			absY = tmpY;
		}
	}
	
	override public function render( engine : h3d.Engine ) {
		if( savedWidth != engine.width || savedHeight != engine.height ) {
			savedWidth = engine.width;
			savedHeight = engine.height;
			posChanged = true;
		}
		super.render(engine);
	}
	
	
}