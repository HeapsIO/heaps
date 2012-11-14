package h2d;

@:allow(h2d.Tools)
class Sprite {

	static inline var ROT2RAD = -0.017453292519943295769236907684886;
	
	var childs : Array<Sprite>;
	public var parent(default,null) : Sprite;
	
	public var x(default,set) : Float;
	public var y(default, set) : Float;
	public var scaleX(default,set) : Float;
	public var scaleY(default,set) : Float;
	public var rotation(default,set) : Float;
	public var blendMode(default,set) : BlendMode;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;
	
	var posChanged : Bool;
	var allocated : Bool;
	
	public function new( ?parent : Sprite ) {
		matA = 1; matB = 0; matC = 0; matD = 1; absX = 0; absY = 0;
		x = 0; y = 0; scaleX = 1; scaleY = 1; rotation = 0;
		posChanged = false;
		childs = [];
		blendMode = Normal;
		if( parent != null )
			parent.addChild(this);
	}
	
	function set_blendMode(b) {
		this.blendMode = b;
		return b;
	}
	
	public function getAbsolutePos( x = 0., y = 0. ) {
		updatePos();
		return { x : x * matA + y * matC + absX, y : x * matB + y * matD + absY };
	}
	
	public function addChild( s : Sprite ) {
		addChildAt(s, childs.length);
	}
	
	public function addChildAt( s : Sprite, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > childs.length ) pos = childs.length;
		var p = this;
		while( p != null ) {
			if( p == s ) throw "Recursive addChild";
			p = p.parent;
		}
		if( s.parent != null )
			s.parent.childs.remove(s);
		childs.insert(pos,s);
		s.parent = this;
		s.posChanged = true;
		// ensure that proper alloc/delete is done if we change parent
		if( allocated ) {
			if( !s.allocated )
				s.onAlloc();
		} else if( s.allocated )
			s.onDelete();
	}
	
	// kept for internal init
	function onAlloc() {
		allocated = true;
		for( c in childs )
			c.onAlloc();
	}
		
	// kept for internal cleanup
	function onDelete() {
		allocated = false;
		for( c in childs )
			c.onDelete();
	}
	
	public function removeChild( s : Sprite ) {
		if( childs.remove(s) ) {
			s.parent = null;
			if( s.allocated ) s.onDelete();
		}
	}
	
	// shortcut for parent.removeChild
	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
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