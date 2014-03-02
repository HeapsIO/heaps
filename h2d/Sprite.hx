package h2d;
import hxd.Math;

@:allow(h2d.Tools)
class Sprite {

	var childs : Array<Sprite>;
	public var parent(default, null) : Sprite;
	public var numChildren(get, never) : Int;
	
	public var x(default,set) : Float;
	public var y(default, set) : Float;
	public var scaleX(default,set) : Float;
	public var scaleY(default,set) : Float;
	public var rotation(default, set) : Float;
	public var visible : Bool;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;
	
	var posChanged : Bool;
	var allocated : Bool;
	var lastFrame : Int;
	
	public function new( ?parent : Sprite ) {
		matA = 1; matB = 0; matC = 0; matD = 1; absX = 0; absY = 0;
		x = 0; y = 0; scaleX = 1; scaleY = 1; rotation = 0;
		posChanged = false;
		visible = true;
		childs = [];
		if( parent != null )
			parent.addChild(this);
	}
	
	public function getSpritesCount() {
		var k = 0;
		for( c in childs )
			k += c.getSpritesCount() + 1;
		return k;
	}
	
	public function localToGlobal( ?pt : h2d.col.Point ) {
		syncPos();
		if( pt == null ) pt = new h2d.col.Point();
		var px = pt.x * matA + pt.y * matC + absX;
		var py = pt.x * matB + pt.y * matD + absY;
		pt.x = (px + 1) * 0.5;
		pt.y = (1 - py) * 0.5;
		var scene = getScene();
		if( scene != null ) {
			pt.x *= scene.width;
			pt.y *= scene.height;
		} else {
			pt.x *= hxd.System.width;
			pt.y *= hxd.System.height;
		}
		return pt;
	}

	public function globalToLocal( pt : h2d.col.Point ) {
		syncPos();
		var scene = getScene();
		if( scene != null ) {
			pt.x /= scene.width;
			pt.y /= scene.height;
		} else {
			pt.x /= hxd.System.width;
			pt.y /= hxd.System.height;
		}
		pt.x = pt.x * 2 - 1;
		pt.y = 1 - pt.y * 2;
		pt.x -= absX;
		pt.y -= absY;
		var invDet = 1 / (matA * matD - matB * matC);
		var px = (pt.x * matD - pt.y * matC) * invDet;
		var py = (-pt.x * matB + pt.y * matA) * invDet;
		pt.x = px;
		pt.y = py;
		return pt;
	}
	
	function getScene() {
		var p = this;
		while( p.parent != null ) p = p.parent;
		return Std.instance(p, Scene);
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
		if( s.parent != null ) {
			// prevent calling onDelete
			var old = s.allocated;
			s.allocated = false;
			s.parent.removeChild(s);
			s.allocated = old;
		}
		childs.insert(pos, s);
		if( !allocated && s.allocated )
			s.onDelete();
		s.parent = this;
		s.posChanged = true;
		// ensure that proper alloc/delete is done if we change parent
		if( allocated ) {
			if( !s.allocated )
				s.onAlloc();
			else
				s.onParentChanged();
		}
	}
	
	// called when we're allocated already but moved in hierarchy
	function onParentChanged() {
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
			if( s.allocated ) s.onDelete();
			s.parent = null;
		}
	}
	
	// shortcut for parent.removeChild
	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
	}
	
	function draw( ctx : RenderContext ) {
	}
	
	function sync( ctx : RenderContext ) {
		/*
		if( currentAnimation != null ) {
			var old = parent;
			var dt = ctx.elapsedTime;
			while( dt > 0 && currentAnimation != null )
				dt = currentAnimation.update(dt);
			if( currentAnimation != null )
				currentAnimation.sync();
			if( parent == null && old != null ) return; // if we were removed by an animation event
		}
		*/
		var changed = posChanged;
		if( changed ) {
			calcAbsPos();
			posChanged = false;
		}
		
		lastFrame = ctx.frame;
		var p = 0, len = childs.length;
		while( p < len ) {
			var c = childs[p];
			if( c == null )
				break;
			if( c.lastFrame != ctx.frame ) {
				if( changed ) c.posChanged = true;
				c.sync(ctx);
			}
			// if the object was removed, let's restart again.
			// our lastFrame ensure that no object will get synched twice
			if( childs[p] != c ) {
				p = 0;
				len = childs.length;
			} else
				p++;
		}
	}
	
	function syncPos() {
		if( parent != null ) parent.syncPos();
		if( posChanged ) {
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
	}
	
	function calcAbsPos() {
		if( parent == null ) {
			var cr, sr;
			if( rotation == 0 ) {
				cr = 1.; sr = 0.;
				matA = scaleX;
				matB = 0;
				matC = 0;
				matD = scaleY;
			} else {
				cr = Math.cos(rotation);
				sr = Math.sin(rotation);
				matA = scaleX * cr;
				matB = scaleX * sr;
				matC = scaleY * -sr;
				matD = scaleY * cr;
			}
			absX = x;
			absY = y;
		} else {
			// M(rel) = S . R . T
			// M(abs) = M(rel) . P(abs)
			if( rotation == 0 ) {
				matA = scaleX * parent.matA;
				matB = scaleX * parent.matB;
				matC = scaleY * parent.matC;
				matD = scaleY * parent.matD;
			} else {
				var cr = Math.cos(rotation);
				var sr = Math.sin(rotation);
				var tmpA = scaleX * cr;
				var tmpB = scaleX * sr;
				var tmpC = scaleY * -sr;
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

	function drawRec( ctx : RenderContext ) {
		if( !visible ) return;
		// fallback in case the object was added during a sync() event and we somehow didn't update it
		if( posChanged ) {
			// only sync anim, don't update() (prevent any event from occuring during draw())
			// if( currentAnimation != null ) currentAnimation.sync();
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
		}
		draw(ctx);
		for( c in childs )
			c.drawRec(ctx);
	}

	inline function set_x(v) {
		posChanged = true;
		return x = v;
	}

	inline function set_y(v) {
		posChanged = true;
		return y = v;
	}
	
	inline function set_scaleX(v) {
		posChanged = true;
		return scaleX = v;
	}
	
	inline function set_scaleY(v) {
		posChanged = true;
		return scaleY = v;
	}
	
	inline function set_rotation(v) {
		posChanged = true;
		return rotation = v;
	}
	
	public function move( dx : Float, dy : Float ) {
		x += dx * Math.cos(rotation);
		y += dy * Math.sin(rotation);
	}

	public inline function setPos( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}
	
	public inline function rotate( v : Float ) {
		rotation += v;
	}
	
	public inline function scale( v : Float ) {
		scaleX *= v;
		scaleY *= v;
	}
	
	public inline function setScale( v : Float ) {
		scaleX = v;
		scaleY = v;
	}

	public inline function getChildAt( n ) {
		return childs[n];
	}

	public function getChildIndex( s ) {
		for( i in 0...childs.length )
			if( childs[i] == s )
				return i;
		return -1;
	}
	
	inline function get_numChildren() {
		return childs.length;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(childs);
	}

}