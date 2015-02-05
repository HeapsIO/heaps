package h3d.scene;

@:enum abstract ObjectFlags(Int) {
	public var FPosChanged = 1;
	public var FVisible = 2;
	public var FCulled = 4;
	public var FFollowPosition = 8;
	public var FLightCameraCenter = 16;
	public inline function toInt() return this;
}

class Object {

	static inline var ROT2RAD = -0.017453292519943295769236907684886;

	var flags : Int;
	var childs : Array<Object>;
	public var parent(default, null) : Object;
	public var numChildren(get, never) : Int;

	public var name : Null<String>;
	public var x(default,set) : Float;
	public var y(default, set) : Float;
	public var z(default, set) : Float;
	public var scaleX(default,set) : Float;
	public var scaleY(default, set) : Float;
	public var scaleZ(default,set) : Float;
	public var visible(get,set) : Bool;

	/**
		Follow a given object or joint as if it was our parent. Ignore defaultTransform when set.
	**/
	public var follow(default, set) : Object;
	public var followPositionOnly(get, set) : Bool;

	/**
		This is an additional optional transformation that is performed before other local transformations.
		It is used by the animation system.
	**/
	public var defaultTransform(default, set) : h3d.Matrix;
	public var currentAnimation(default, null) : h3d.anim.Animation;

	/**
		When selecting the lights to apply to this object, we will use the camera target as reference
		instead of the object absolute position. This is useful for very large objects so they can get good lighting.
	**/
	public var lightCameraCenter(get, set) : Bool;

	// internal flag to inform that the object is not to be displayed
	var culled(get,set) : Bool;

	var absPos : h3d.Matrix;
	var invPos : h3d.Matrix;
	var qRot : h3d.Quat;
	var posChanged(get,set) : Bool;
	var lastFrame : Int;

	public function new( ?parent : Object ) {
		flags = 0;
		absPos = new h3d.Matrix();
		absPos.identity();
		x = 0; y = 0; z = 0; scaleX = 1; scaleY = 1; scaleZ = 1;
		qRot = new h3d.Quat();
		posChanged = false;
		visible = true;
		childs = [];
		if( parent != null )
			parent.addChild(this);
	}

	inline function get_visible() return (flags & FVisible.toInt()) != 0;
	inline function get_posChanged() return (flags & FPosChanged.toInt()) != 0;
	inline function get_culled() return (flags & FCulled.toInt()) != 0;
	inline function get_followPositionOnly() return (flags & FFollowPosition.toInt()) != 0;
	inline function get_lightCameraCenter() return (flags & FLightCameraCenter.toInt()) != 0;
	inline function set_posChanged(b) { if( b ) flags |= FPosChanged.toInt() else flags &= ~FPosChanged.toInt(); return b; }
	inline function set_culled(b) { if( b ) flags |= FCulled.toInt() else flags &= ~FCulled.toInt(); return b; }
	inline function set_visible(b) { culled = !b; if( b ) flags |= FVisible.toInt() else flags &= ~FVisible.toInt(); return b; }
	inline function set_followPositionOnly(b) { if( b ) flags |= FFollowPosition.toInt() else flags &= ~FFollowPosition.toInt(); return b; }
	inline function set_lightCameraCenter(b) { if( b ) flags |= FLightCameraCenter.toInt() else flags &= ~FLightCameraCenter.toInt(); return b; }

	public function playAnimation( a : h3d.anim.Animation ) {
		return currentAnimation = a.createInstance(this);
	}

	/**
		Changes the current animation. This animation should be an instance that was created by playAnimation!
	**/
	public function switchToAnimation( a : h3d.anim.Animation ) {
		return currentAnimation = a;
	}

	public function stopAnimation() {
		currentAnimation = null;
	}

	public function getObjectsCount() {
		var k = 0;
		for( c in childs )
			k += c.getObjectsCount() + 1;
		return k;
	}

	public function getMaterialByName( name : String ) : h3d.mat.Material {
		for( o in childs ) {
			var m = o.getMaterialByName(name);
			if( m != null ) return m;
		}
		return null;
	}

	public function getMaterials( ?a : Array<h3d.mat.Material> ) {
		if( a == null ) a = [];
		for( o in childs )
			o.getMaterials(a);
		return a;
	}

	/**
		Transform a point from the local object coordinates to the global ones. The point is modified and returned.
	**/
	public function localToGlobal( ?pt : h3d.Vector ) {
		syncPos();
		if( pt == null ) pt = new h3d.Vector();
		pt.transform3x4(absPos);
		return pt;
	}

	/**
		Transform a point from the global coordinates to the object local ones. The point is modified and returned.
	**/
	public function globalToLocal( pt : h3d.Vector ) {
		syncPos();
		pt.transform3x4(getInvPos());
		return pt;
	}

	function getInvPos() {
		if( invPos == null ) {
			invPos = new h3d.Matrix();
			invPos._44 = 0;
		}
		if( invPos._44 == 0 )
			invPos.inverse3x4(absPos);
		return invPos;
	}

	/**
		Return the bounds of this object, in absolute position.
	**/
	public function getBounds( ?b : h3d.col.Bounds, rec = false ) {
		if( !rec )
			syncPos();
		if( b == null )
			b = new h3d.col.Bounds();
		if( posChanged ) {
			for( c in childs )
				c.posChanged = true;
			posChanged = false;
			calcAbsPos();
		}
		for( c in childs )
			c.getBounds(b, true);
		return b;
	}

	public function getObjectByName( name : String ) {
		if( this.name == name )
			return this;
		for( c in childs ) {
			var o = c.getObjectByName(name);
			if( o != null ) return o;
		}
		return null;
	}

	public function clone( ?o : Object ) : Object {
		if( o == null ) o = new Object();
		#if debug
		if( Type.getClass(o) != Type.getClass(this) ) throw this + " is missing clone()";
		#end
		o.x = x;
		o.y = y;
		o.z = z;
		o.scaleX = scaleX;
		o.scaleY = scaleY;
		o.scaleZ = scaleZ;
		o.name = name;
		o.follow = follow;
		o.followPositionOnly = followPositionOnly;
		o.visible = visible;
		if( defaultTransform != null )
			o.defaultTransform = defaultTransform.clone();
		for( c in childs ) {
			var c = c.clone();
			c.parent = o;
			o.childs.push(c);
		}
		return o;
	}

	public function addChild( o : Object ) {
		addChildAt(o, childs.length);
	}

	public function addChildAt( o : Object, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > childs.length ) pos = childs.length;
		var p = this;
		while( p != null ) {
			if( p == o ) throw "Recursive addChild";
			p = p.parent;
		}
		if( o.parent != null )
			o.parent.removeChild(o);
		childs.insert(pos,o);
		o.parent = this;
		o.lastFrame = -1;
		o.posChanged = true;
	}

	public function removeChild( o : Object ) {
		if( childs.remove(o) )
			o.parent = null;
	}

	public inline function isMesh() {
		return Std.instance(this, Mesh) != null;
	}

	public function toMesh() : Mesh {
		var m = Std.instance(this, Mesh);
		if( m != null )
			return m;
		throw this + " is not a Mesh";
	}

	// shortcut for parent.removeChild
	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
	}

	function draw( ctx : RenderContext ) {
	}

	function set_follow(v) {
		posChanged = true;
		return follow = v;
	}

	function calcAbsPos() {
		qRot.saveToMatrix(absPos);
		// prepend scale
		absPos._11 *= scaleX;
		absPos._12 *= scaleX;
		absPos._13 *= scaleX;
		absPos._21 *= scaleY;
		absPos._22 *= scaleY;
		absPos._23 *= scaleY;
		absPos._31 *= scaleZ;
		absPos._32 *= scaleZ;
		absPos._33 *= scaleZ;
		absPos._41 = x;
		absPos._42 = y;
		absPos._43 = z;
		if( follow != null ) {
			follow.syncPos();
			if( followPositionOnly ) {
				absPos.tx += follow.absPos.tx;
				absPos.ty += follow.absPos.ty;
				absPos.tz += follow.absPos.tz;
			} else
				absPos.multiply3x4(absPos, follow.absPos);
		} else {
			if( parent != null )
				absPos.multiply3x4inline(absPos, parent.absPos);
		}
		// animation is applied before every other transform
		if( defaultTransform != null )
			absPos.multiply3x4inline(defaultTransform, absPos);
		if( invPos != null )
			invPos._44 = 0; // mark as invalid
	}

	function sync( ctx : RenderContext ) {
	}

	function syncRec( ctx : RenderContext ) {
		if( currentAnimation != null ) {
			var old = parent;
			var dt = ctx.elapsedTime;
			while( dt > 0 && currentAnimation != null )
				dt = currentAnimation.update(dt);
			if( currentAnimation != null )
				currentAnimation.sync();
			if( parent == null && old != null ) return; // if we were removed by an animation event
		}
		var changed = posChanged;
		if( changed ) calcAbsPos();
		sync(ctx);
		posChanged = follow == null;
		lastFrame = ctx.frame;
		var p = 0, len = childs.length;
		while( p < len ) {
			var c = childs[p];
			if( c == null )
				break;
			if( c.lastFrame != ctx.frame ) {
				if( changed ) c.posChanged = true;
				c.syncRec(ctx);
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
			posChanged = false;
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
		}
	}

	function emit( ctx : RenderContext ) {
	}

	function emitRec( ctx : RenderContext ) {
		if( culled ) return;
		// fallback in case the object was added during a sync() event and we somehow didn't update it
		if( posChanged ) {
			// only sync anim, don't update() (prevent any event from occuring during draw())
			if( currentAnimation != null ) currentAnimation.sync();
			posChanged = false;
			calcAbsPos();
			for( c in childs )
				c.posChanged = true;
		}
		emit(ctx);
		for( c in childs )
			c.emitRec(ctx);
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

	inline function set_z(v) {
		z = v;
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

	inline function set_scaleZ(v) {
		scaleZ = v;
		posChanged = true;
		return v;
	}

	inline function set_defaultTransform(v) {
		defaultTransform = v;
		posChanged = true;
		return v;
	}

	public inline function setPos( x : Float, y : Float, z : Float ) {
		this.x = x;
		this.y = y;
		this.z = z;
		posChanged = true;
	}

	/*
		Rotate around the current rotation axis.
	*/
	public function rotate( rx : Float, ry : Float, rz : Float ) {
		var qTmp = new h3d.Quat();
		qTmp.initRotate(rx, ry, rz);
		qRot.multiply(qTmp,qRot);
		posChanged = true;
	}

	public function setRotate( rx : Float, ry : Float, rz : Float ) {
		qRot.initRotate(rx, ry, rz);
		posChanged = true;
	}

	public function setRotateAxis( ax : Float, ay : Float, az : Float, angle : Float ) {
		qRot.initRotateAxis(ax, ay, az, angle);
		posChanged = true;
	}

	public function getRotationQuat() {
		return qRot;
	}

	public function setRotationQuat(q) {
		qRot = q;
		posChanged = true;
	}

	public inline function scale( v : Float ) {
		scaleX *= v;
		scaleY *= v;
		scaleZ *= v;
		posChanged = true;
	}

	public inline function setScale( v : Float ) {
		scaleX = v;
		scaleY = v;
		scaleZ = v;
		posChanged = true;
	}

	public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop() + (name == null ? "" : "(" + name + ")");
	}

	public inline function getChildAt( n ) {
		return childs[n];
	}

	inline function get_numChildren() {
		return childs.length;
	}

	public inline function iterator() : hxd.impl.ArrayIterator<Object> {
		return new hxd.impl.ArrayIterator(childs);
	}

	public function dispose() {
		for( c in childs )
			c.dispose();
	}

}
