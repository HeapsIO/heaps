package h2d;

class Sprite {

	static inline var ROT2RAD = -0.017453292519943295769236907684886;
	
	var childs : Array<Sprite>;
	public var parent(default,null) : Sprite;
	
	public var x(default,set_x) : Float;
	public var y(default, set_y) : Float;
	public var scaleX(default,set_scaleX) : Float;
	public var scaleY(default,set_scaleY) : Float;
	public var rotation(default,set_rotation) : Float;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;
	
	var posChanged : Bool;
	
	public function new( ?parent : Sprite ) {
		matA = 1; matB = 0; matC = 0; matD = 1; absX = 0; absY = 0;
		x = 0; y = 0; scaleX = 1; scaleY = 1; rotation = 0;
		posChanged = false;
		childs = [];
		if( parent != null )
			parent.addChild(this);
	}
	
	public function getAbsolutePos( x = 0., y = 0. ) {
		updatePos();
		return { x : x * matA + y * matC + absX, y : x * matB + y * matD + absY };
	}
	
	public function addChild( s : Sprite ) {
		if( s.parent != null )
			s.remove();
		childs.push(s);
		s.parent = this;
	}
	
	public function removeChild( s : Sprite ) {
		if( childs.remove(s) )
			s.parent = null;
	}
	
	public inline function remove() {
		if( this != null && parent != null )
			parent.removeChild(this);
	}
	
	function draw( engine : h3d.Engine ) {
	}
	
	function updatePos() {
		if( parent == null ) {
			if( posChanged ) {
				var cr, sr;
				if( rotation == 0 ) {
					cr = 1.; sr = 0.;
					matA = scaleX;
					matB = 0;
					matC = 0;
					matD = scaleY;
				} else {
					cr = Math.cos(rotation * ROT2RAD);
					sr = Math.sin(rotation * ROT2RAD);
					matA = scaleX * cr;
					matB = scaleX * -sr;
					matC = scaleY * sr;
					matD = scaleY * cr;
				}
				absX = x;
				absY = y;
			}
		} else {
			if( parent.posChanged )
				posChanged = true;
			if( posChanged ) {
				// M(rel) = S . R . T
				// M(abs) = M(rel) . P(abs)
				if( rotation == 0 ) {
					matA = scaleX * parent.matA;
					matB = scaleX * parent.matB;
					matC = scaleY * parent.matC;
					matD = scaleY * parent.matD;
				} else {
					var cr = Math.cos(rotation * ROT2RAD);
					var sr = Math.sin(rotation * ROT2RAD);
					var tmpA = scaleX * cr;
					var tmpB = scaleX * -sr;
					var tmpC = scaleY * sr;
					var tmpD = scaleY * cr;
					matA = tmpA * parent.matA + tmpB * parent.matC;
					matB = tmpA * parent.matB + tmpB * parent.matD;
					matC = tmpC * parent.matA + tmpD * parent.matC;
					matD = tmpC * parent.matB + tmpD * parent.matD;
				}
				absX = x * parent.matA + y * parent.matC + parent.absX;
				absY = x * parent.matB + y * parent.matD + parent.absY;
			}
		}
	}
	
	function render( engine : h3d.Engine ) {
		updatePos();
		draw(engine);
		for( c in childs )
			c.render(engine);
		posChanged = false;
	}
	
	inline function set_x(v) {
		x = v;
		posChanged = true;
		return v;
	}

	inline function set_y(v) {
		y = v;
		posChanged = true;
		return v;
	}
	
	inline function set_scaleX(v) {
		scaleX = v;
		posChanged = true;
		return v;
	}
	
	inline function set_scaleY(v) {
		scaleY = v;
		posChanged = true;
		return v;
	}
	
	inline function set_rotation(v) {
		rotation = v;
		posChanged = true;
		return v;
	}
	
}