package h3d.scene;

@:enum abstract ObjectFlags(Int) {
	public var FPosChanged = 0x01;
	public var FVisible = 0x02;
	public var FCulled = 0x04;
	public var FFollowPositionOnly = 0x08;
	public var FLightCameraCenter = 0x10;
	public var FAllocated = 0x20;
	public var FAlwaysSync = 0x40;
	public var FInheritCulled = 0x80;
	public var FNoSerialize = 0x100;
	public var FIgnoreBounds = 0x200;
	public inline function new() {
		this = 0;
	}
	public inline function toInt() return this;
	public inline function has(f:ObjectFlags) return this & f.toInt() != 0;
	public inline function set(f:ObjectFlags, b) {
		if( b ) this |= f.toInt() else this &= ~f.toInt();
		return b;
	}
}

class Object implements h3d.impl.Serializable {

	static inline var ROT2RAD = -0.017453292519943295769236907684886;

	@:s var flags : ObjectFlags;
	var children : Array<Object>;
	public var parent(default, null) : Object;
	public var numChildren(get, never) : Int;

	@:s public var name : Null<String>;
	@:s public var x(default,set) : Float;
	@:s public var y(default, set) : Float;
	@:s public var z(default, set) : Float;
	@:s public var scaleX(default,set) : Float;
	@:s public var scaleY(default, set) : Float;
	@:s public var scaleZ(default,set) : Float;
	public var visible(get, set) : Bool;
	var allocated(get,set) : Bool;

	/**
		Follow a given object or joint as if it was our parent. Ignore defaultTransform when set.
	**/
	@:s public var follow(default, set) : Object;
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

	/**
		Inform that the object is not to be displayed and his animation doesn't have to be sync. Unlike visible, this doesn't apply to children unless inheritCulled is set to true.
	**/
	public var culled(get, set) : Bool;

	/**
		When an object is not visible or culled, its animation does not get synchronized unless you set alwaysSync=true
	**/
	public var alwaysSync(get, set) : Bool;

	/**
		When enable, the culled flag is inherited by children objects.
	**/
	public var inheritCulled(get, set) : Bool;


	var absPos : h3d.Matrix;
	var invPos : h3d.Matrix;
	var qRot : h3d.Quat;
	var posChanged(get,set) : Bool;
	var lastFrame : Int;

	public function new( ?parent : Object ) {
		flags = new ObjectFlags();
		absPos = new h3d.Matrix();
		absPos.identity();
		x = 0; y = 0; z = 0; scaleX = 1; scaleY = 1; scaleZ = 1;
		qRot = new h3d.Quat();
		posChanged = false;
		visible = true;
		children = [];
		if( parent != null )
			parent.addChild(this);
	}

	inline function get_visible() return flags.has(FVisible);
	inline function get_allocated() return flags.has(FAllocated);
	inline function get_posChanged() return flags.has(FPosChanged);
	inline function get_culled() return flags.has(FCulled);
	inline function get_followPositionOnly() return flags.has(FFollowPositionOnly);
	inline function get_lightCameraCenter() return flags.has(FLightCameraCenter);
	inline function get_alwaysSync() return flags.has(FAlwaysSync);
	inline function get_inheritCulled() return flags.has(FInheritCulled);
	inline function set_posChanged(b) return flags.set(FPosChanged, b || follow != null);
	inline function set_culled(b) return flags.set(FCulled, b);
	inline function set_visible(b) return flags.set(FVisible,b);
	inline function set_allocated(b) return flags.set(FAllocated, b);
	inline function set_followPositionOnly(b) return flags.set(FFollowPositionOnly, b);
	inline function set_lightCameraCenter(b) return flags.set(FLightCameraCenter, b);
	inline function set_alwaysSync(b) return flags.set(FAlwaysSync, b);
	inline function set_inheritCulled(b) return flags.set(FInheritCulled, b);

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

	/**
		When an object is loaded, its position scale and rotation will always be set to the default values (0 for position/rotation and 1 for scale).
		If it's part of a group/scene or if it's animated, then its position/rotation/scale will be stored into the defaultTransform matrix.
		Calling this function will reset the defaultTransform to null and instead initialize x/y/z/rotation/scale properties.
		This will not change the actual position of the object but allows you to move the object more freely on your own.
		Do not use on an object that is currently being animated, since it will set again defaultTransform and apply twice the transformation.
	**/
	public function applyAnimationTransform( recursive = true ) {
		if( defaultTransform != null ) {
			var s = defaultTransform.getScale();
			scaleX = s.x;
			scaleY = s.y;
			scaleZ = s.z;
			qRot.initRotateMatrix(defaultTransform);
			x = defaultTransform.tx;
			y = defaultTransform.ty;
			z = defaultTransform.tz;
			defaultTransform = null;
		}
		if( recursive )
			for( c in children )
				c.applyAnimationTransform();
	}

	public function getObjectsCount() {
		var k = 0;
		for( c in children )
			k += c.getObjectsCount() + 1;
		return k;
	}

	public function getMaterialByName( name : String ) : h3d.mat.Material {
		for( o in children ) {
			var m = o.getMaterialByName(name);
			if( m != null ) return m;
		}
		return null;
	}

	public function find<T>( f : Object -> Null<T> ) : Null<T> {
		var v = f(this);
		if( v != null )
			return v;
		for( o in children ) {
			var v = o.find(f);
			if( v != null ) return v;
		}
		return null;
	}

	public function findAll<T>( f : Object -> Null<T>, ?arr : Array<T> ) : Array<T> {
		if( arr == null ) arr = [];
		var v = f(this);
		if( v != null )
			arr.push(v);
		for( o in children )
			o.findAll(f,arr);
		return arr;
	}

	public function getMaterials( ?a : Array<h3d.mat.Material> ) {
		if( a == null ) a = [];
		for( o in children )
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
		pt.transform3x4(getInvPos());
		return pt;
	}

	/**
		Returns the updated inverse position matrix. Please note that this is not a copy and should not be modified.
	**/
	public function getInvPos() {
		syncPos();
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
			for( c in children )
				c.posChanged = true;
			posChanged = false;
			calcAbsPos();
		}
		for( c in children )
			c.getBounds(b, true);
		return b;
	}

	public function getMeshes( ?out : Array<Mesh> ) {
		if( out == null ) out = [];
		var m = Std.instance(this, Mesh);
		if( m != null ) out.push(m);
		for( c in children )
			c.getMeshes(out);
		return out;
	}

	public function getObjectByName( name : String ) {
		if( this.name == name )
			return this;
		for( c in children ) {
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
		for( c in children ) {
			var c = c.clone();
			c.parent = o;
			o.children.push(c);
		}
		return o;
	}

	public function addChild( o : Object ) {
		addChildAt(o, children.length);
	}

	public function addChildAt( o : Object, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > children.length ) pos = children.length;
		var p = this;
		while( p != null ) {
			if( p == o ) throw "Recursive addChild";
			p = p.parent;
		}
		if( o.parent != null ) {
			// prevent calling onDelete
			var old = o.allocated;
			o.allocated = false;
			o.parent.removeChild(o);
			o.allocated = old;
		}
		children.insert(pos, o);
		if( !allocated && o.allocated )
			o.onRemove();
		o.parent = this;
		o.posChanged = true;
		// ensure that proper alloc/delete is done if we change parent
		if( allocated ) {
			if( !o.allocated )
				o.onAdd();
			else
				o.onParentChanged();
		}
	}

	public function iterVisibleMeshes( callb : Mesh -> Void ) {
		if( !visible || (culled && inheritCulled) )
			return;
		if( !culled ) {
			var m = Std.instance(this, Mesh);
			if( m != null ) callb(m);
		}
		for( o in children )
			o.iterVisibleMeshes(callb);
	}

	function onParentChanged() {
		for( c in children )
			c.onParentChanged();
	}

	// kept for internal init
	function onAdd() {
		allocated = true;
		for( c in children )
			c.onAdd();
	}

	// kept for internal cleanup
	function onRemove() {
		allocated = false;
		for( c in children )
			c.onRemove();
	}

	public function removeChild( o : Object ) {
		if( children.remove(o) ) {
			if( o.allocated ) o.onRemove();
			o.parent = null;
			o.posChanged = true;
		}
	}

	function getScene() {
		var p = this;
		while( p.parent != null ) p = p.parent;
		return Std.instance(p, Scene);
	}

	/**
		Returns the updated absolute position matrix. Please note that this is not a copy so it should not be modified.
	**/
	public function getAbsPos() {
		syncPos();
		return absPos;
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

	public function getCollider() : h3d.col.Collider {
		var colliders = [];
		for( obj in children ) {
			var c = obj.getCollider();
			var cgrp = Std.instance(c, h3d.col.Collider.GroupCollider);
			if( cgrp != null ) {
				for( c in cgrp.colliders )
					colliders.push(c);
			} else
				colliders.push(c);
		}
		return new h3d.col.Collider.GroupCollider(colliders);
	}

	/**
		Same as parent.removeChild(this), but does nothing if parent is null.
		In order to capture add/removal from scene, you can override onAdd/onRemove/onParentChanged
	**/
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
			if( currentAnimation != null && ((ctx.visibleFlag && visible && !culled) || alwaysSync)  )
				currentAnimation.sync();
			if( parent == null && old != null )
				return; // if we were removed by an animation event
		}
		var old = ctx.visibleFlag;
		if( !visible || (culled && inheritCulled) )
			ctx.visibleFlag = false;
		var changed = posChanged;
		if( changed ) calcAbsPos();
		sync(ctx);
		posChanged = false;
		lastFrame = ctx.frame;
		var p = 0, len = children.length;
		while( p < len ) {
			var c = children[p];
			if( c == null )
				break;
			if( c.lastFrame != ctx.frame ) {
				if( changed ) c.posChanged = true;
				c.syncRec(ctx);
			}
			// if the object was removed, let's restart again.
			// our lastFrame ensure that no object will get synched twice
			if( children[p] != c ) {
				p = 0;
				len = children.length;
			} else
				p++;
		}
		ctx.visibleFlag = old;
	}

	function syncPos() {
		if( parent != null ) parent.syncPos();
		if( posChanged ) {
			posChanged = false;
			calcAbsPos();
			for( c in children )
				c.posChanged = true;
		}
	}

	function emit( ctx : RenderContext ) {
	}

	function emitRec( ctx : RenderContext ) {
		if( !visible || (culled && inheritCulled) )
			return;

		// fallback in case the object was added during a sync() event and we somehow didn't update it
		if( posChanged ) {
			// only sync anim, don't update() (prevent any event from occuring during draw())
			if( currentAnimation != null ) currentAnimation.sync();
			posChanged = false;
			calcAbsPos();
			for( c in children )
				c.posChanged = true;
		}
		if( !culled )
			emit(ctx);
		for( c in children )
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
		return children[n];
	}

	inline function get_numChildren() {
		return children.length;
	}

	public inline function iterator() : hxd.impl.ArrayIterator<Object> {
		return new hxd.impl.ArrayIterator(children);
	}

	public function dispose() {
		for( c in children )
			c.dispose();
	}

	#if hxbit
	function customSerialize( ctx : hxbit.Serializer ) {

		var children = [for( o in children ) if( !o.flags.has(FNoSerialize) ) o];
		ctx.addInt(children.length);
		for( o in children )
			ctx.addKnownRef(o);

		ctx.addDouble(qRot.x);
		ctx.addDouble(qRot.y);
		ctx.addDouble(qRot.z);
		ctx.addDouble(qRot.w);
		// defaultTransform
		// currentAnimation
	}

	function customUnserialize( ctx : hxbit.Serializer ) {
		children = [for( i in 0...ctx.getInt() ) ctx.getKnownRef(Object)];
		qRot = new h3d.Quat(ctx.getDouble(),ctx.getDouble(),ctx.getDouble(),ctx.getDouble());
		for( c in children )
			c.parent = this;
		allocated = false;
		posChanged = true;
		absPos = new h3d.Matrix();
		absPos.identity();
	}
	#end

}
