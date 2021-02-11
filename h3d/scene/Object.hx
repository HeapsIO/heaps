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
	public var FIgnoreCollide = 0x400;
	public var FIgnoreParentTransform = 0x800;
	public var FCullingColliderInherited = 0x1000;
	public inline function new(value) {
		this = value;
	}
	public inline function toInt() return this;
	public inline function has(f:ObjectFlags) return this & f.toInt() != 0;
	public inline function set(f:ObjectFlags, b) {
		if( b ) this |= f.toInt() else this &= ~f.toInt();
		return b;
	}
}

/**
	h3d.scene.Object is the base 3D class that all scene tree elements inherit from.
	It can be used to create a virtual container that does not display anything but can contain other objects
	so the various transforms are inherited to its children.
**/
class Object implements hxd.impl.Serializable {

	static inline var ROT2RAD = -0.017453292519943295769236907684886;

	@:s var flags : ObjectFlags;
	var children : Array<Object>;

	/**
		The parent object in the scene tree.
	**/
	public var parent(default, null) : Object;

	/**
		How many immediate children this object has.
	**/
	public var numChildren(get, never) : Int;

	/**
		The name of the object, can be used to retrieve an object within a tree by using `getObjectByName` (default null)
	**/
	@:s public var name : Null<String>;

	/**
		The x position of the object relative to its parent.
	**/
	@:s public var x(default,set) : Float;

	/**
		The y position of the object relative to its parent.
	**/
	@:s public var y(default, set) : Float;

	/**
		The z position of the object relative to its parent.
	**/
	@:s public var z(default, set) : Float;

	/**
		The amount of scaling along the X axis of this object (default 1.0)
	**/
	@:s public var scaleX(default,set) : Float;

	/**
		The amount of scaling along the Y axis of this object (default 1.0)
	**/
	@:s public var scaleY(default, set) : Float;

	/**
		The amount of scaling along the Z axis of this object (default 1.0)
	**/
	@:s public var scaleZ(default,set) : Float;


	/**
		Is the object and its children are displayed on screen (default true).
	**/
	public var visible(get, set) : Bool;

	var allocated(get,set) : Bool;

	/**
		Follow a given object or joint as if it was our parent. Ignore defaultTransform when set.
	**/
	@:s public var follow(default, set) : Object;

	/**
		When follow is set, only follow the position and ignore both scale and rotation.
	**/
	public var followPositionOnly(get, set) : Bool;

	/**
		This is an additional optional transformation that is performed before other local transformations.
		It is used by the animation system.
	**/
	public var defaultTransform(default, set) : h3d.Matrix;
	@:s public var currentAnimation(default, null) : h3d.anim.Animation;

	/**
		Inform that the object is not to be displayed and his animation doesn't have to be sync. Unlike visible, this doesn't apply to children unless inheritCulled is set to true.
	**/
	public var culled(get, set) : Bool;

	/**
		When an object is not visible or culled, its animation does not get synchronized unless you set alwaysSync=true
	**/
	public var alwaysSync(get, set) : Bool;

	/**
		When enabled, the culled flag and culling collider is inherited by children objects.
	**/
	public var inheritCulled(get, set) : Bool;

	/**
		When enabled, the object bounds are ignored when using getBounds()
	**/
	public var ignoreBounds(get, set) : Bool;

	/**
		When enabled, the object is ignored when using getCollider()
	**/
	public var ignoreCollide(get, set) : Bool;

	/**
		When enabled, the object can be serialized (default : true)
	**/
	public var allowSerialize(get, set) : Bool;

	/**
		When enabled, the object will not follow its parent transform
	**/
	public var ignoreParentTransform(get, set) : Bool;

	/**
		When selecting the lights to apply to this object, we will use the camera target as reference
		instead of the object absolute position. This is useful for very large objects so they can get good lighting.
	**/
	public var lightCameraCenter(get, set) : Bool;

	/**
		When set, collider shape will be used for automatic frustum culling.
		If `inheritCulled` is true, collider will be inherited to children unless they have their own collider set.
	**/
	public var cullingCollider(default, set) : h3d.col.Collider;
	function set_cullingCollider(c) {
		this.cullingCollider = c;
		this.cullingColliderInherited = false;
		return c;
	}

	/**
		Indicates that current cullingCollider is currently inherited from a parent object
	**/
	var cullingColliderInherited(get, set) : Bool;

	var absPos : h3d.Matrix;
	var invPos : h3d.Matrix;
	var qRot : h3d.Quat;
	var posChanged(get,set) : Bool;
	var lastFrame : Int;

	/**
		Create a new empty object, and adds it to the parent object if not null.
	**/
	public function new( ?parent : Object ) {
		flags = new ObjectFlags(0);
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
	inline function get_ignoreBounds() return flags.has(FIgnoreBounds);
	inline function get_ignoreCollide() return flags.has(FIgnoreCollide);
	inline function get_allowSerialize() return !flags.has(FNoSerialize);
	inline function get_ignoreParentTransform() return flags.has(FIgnoreParentTransform);
	inline function get_cullingColliderInherited() return flags.has(FCullingColliderInherited);
	inline function set_posChanged(b) return flags.set(FPosChanged, b || follow != null);
	inline function set_culled(b) return flags.set(FCulled, b);
	inline function set_visible(b) return flags.set(FVisible,b);
	inline function set_allocated(b) return flags.set(FAllocated, b);
	inline function set_followPositionOnly(b) return flags.set(FFollowPositionOnly, b);
	inline function set_lightCameraCenter(b) return flags.set(FLightCameraCenter, b);
	inline function set_alwaysSync(b) return flags.set(FAlwaysSync, b);
	inline function set_ignoreBounds(b) return flags.set(FIgnoreBounds, b);
	inline function set_inheritCulled(b) return flags.set(FInheritCulled, b);
	inline function set_ignoreCollide(b) return flags.set(FIgnoreCollide, b);
	inline function set_allowSerialize(b) return !flags.set(FNoSerialize, !b);
	inline function set_ignoreParentTransform(b) return flags.set(FIgnoreParentTransform, b);
	inline function set_cullingColliderInherited(b) return flags.set(FCullingColliderInherited, b);

	/**
		Create an animation instance bound to the object, set it as currentAnimation and play it.
	**/
	public function playAnimation( a : h3d.anim.Animation ) {
		return currentAnimation = a.createInstance(this);
	}

	/**
		Change the current animation. This animation should be an instance that was previously created by playAnimation.
	**/
	public function switchToAnimation( a : h3d.anim.Animation ) {
		return currentAnimation = a;
	}

	/**
		Stop the current animation. If recursive is set to true, all children will also stop their animation
	**/
	public function stopAnimation( ?recursive = false ) {
		currentAnimation = null;
		if(recursive) {
			for(c in children)
				c.stopAnimation(true);
		}
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

	/**
		Return the total number of children, recursively.
	**/
	public function getObjectsCount() {
		var k = 0;
		for( c in children )
			k += c.getObjectsCount() + 1;
		return k;
	}

	/**
		Search for a material recursively by name, return it or null if not found.
	**/
	public function getMaterialByName( name : String ) : h3d.mat.Material {
		for( o in children ) {
			var m = o.getMaterialByName(name);
			if( m != null ) return m;
		}
		return null;
	}

	/**
		Tells if the object is contained into this object children, recursively.
	**/
	public function contains( o : Object ) {
		while( o != null ) {
			o = o.parent;
			if( o == this ) return true;
		}
		return false;
	}

	/**
		Find a single object in the tree by calling `f` on each and returning the first not-null value returned, or null if not found.
	**/
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

	/**
		Find several objects in the tree by calling `f` on each and returning all the not-null values returned.
	**/
	public function findAll<T>( f : Object -> Null<T>, ?arr : Array<T> ) : Array<T> {
		if( arr == null ) arr = [];
		var v = f(this);
		if( v != null )
			arr.push(v);
		for( o in children )
			o.findAll(f,arr);
		return arr;
	}

	/**
		Return all materials in the tree.
	**/
	public function getMaterials( ?a : Array<h3d.mat.Material> ) {
		if( a == null ) a = [];
		for( o in children )
			o.getMaterials(a);
		return a;
	}

	/**
		Convert a local position (or [0,0] if pt is null) relative to the object origin into an absolute global position, applying all the inherited transforms.
	**/
	public function localToGlobal( ?pt : h3d.col.Point ) {
		syncPos();
		if( pt == null ) pt = new h3d.col.Point();
		pt.transform(absPos);
		return pt;
	}

	/**
		Convert an absolute global position into a local position relative to the object origin, applying all the inherited transforms.
	**/
	public function globalToLocal( pt : h3d.col.Point ) {
		pt.transform(getInvPos());
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
		Return the bounds of this object and all its children, in absolute global coordinates.
	**/
	@:final public function getBounds( ?b : h3d.col.Bounds ) {
		if( b == null )
			b = new h3d.col.Bounds();
		if( parent != null )
			parent.syncPos();
		return getBoundsRec(b);
	}

	function getBoundsRec( b : h3d.col.Bounds ) {
		if( posChanged ) {
			for( c in children )
				c.posChanged = true;
			posChanged = false;
			calcAbsPos();
		}
		for( c in children )
			c.getBoundsRec(b);
		return b;
	}

	/**
		Return all meshes part of this tree
	**/
	public function getMeshes( ?out : Array<Mesh> ) {
		if( out == null ) out = [];
		var m = hxd.impl.Api.downcast(this, Mesh);
		if( m != null ) out.push(m);
		for( c in children )
			c.getMeshes(out);
		return out;
	}

	/**
		Search for an mesh recursively by name, return null if not found.
	**/
	public function getMeshByName( name : String) {
		return hxd.impl.Api.downcast(getObjectByName(name), Mesh);
	}

	/**
		Search for an object recursively by name, return null if not found.
	**/
	public function getObjectByName( name : String ) {
		if( this.name == name )
			return this;
		for( c in children ) {
			var o = c.getObjectByName(name);
			if( o != null ) return o;
		}
		return null;
	}

	/**
		Make a copy of the object and all its children.
	**/
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
		o.qRot.load(qRot);
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

	/**
		Add a child object at the end of the children list.
	**/
	public function addChild( o : Object ) {
		addChildAt(o, children.length);
	}

	/**
		Insert a child object at the specified position of the children list.
	**/
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

	/**
		Iterate on all mesh that are currently visible and not culled in the tree. Call `callb` for each mesh found.
	**/
	public function iterVisibleMeshes( callb : Mesh -> Void ) {
		if( !visible || (culled && inheritCulled) )
			return;
		if( !culled ) {
			var m = hxd.impl.Api.downcast(this, Mesh);
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

	/**
		Remove the given object from our immediate children list if it's part of it.
	**/
	public function removeChild( o : Object ) {
		if( children.remove(o) ) {
			if( o.allocated ) o.onRemove();
			o.parent = null;
			o.posChanged = true;
		}
	}

	/**
		Remove all children from our immediate children list
	**/
	public function removeChildren() {
		while( numChildren>0 )
			removeChild( getChildAt(0) );
	}

	/**
		Same as parent.removeChild(this), but does nothing if parent is null.
		In order to capture add/removal from scene, you can override onAdd/onRemove/onParentChanged
	**/
	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
	}

	/**
		Return the Scene this object is part of, or null if not added to a Scene.
	**/
	public function getScene() {
		var p = this;
		while( p.parent != null ) p = p.parent;
		return hxd.impl.Api.downcast(p, Scene);
	}

	/**
		Returns the updated absolute position matrix. Please note that this is not a copy so it should not be modified.
	**/
	public function getAbsPos() {
		syncPos();
		return absPos;
	}

	/**
		Returns the position matrix relative to another scene object
	**/
	public function getRelPos( obj : Object ) {
		if( obj == null )
			return getAbsPos();
		syncPos();
		var m = new h3d.Matrix();
		m.multiply(absPos, obj.getInvPos());
		return m;
	}

	/**
		Tell if the object is a Mesh.
	**/
	public inline function isMesh() {
		return hxd.impl.Api.downcast(this, Mesh) != null;
	}

	/**
		If the object is a Mesh, return the corresponding Mesh. If not, throw an exception.
	**/
	public function toMesh() : Mesh {
		var m = hxd.impl.Api.downcast(this, Mesh);
		if( m != null )
			return m;
		throw this + " is not a Mesh";
	}

	/**
		Build and return the global absolute recursive collider for the object.
		Returns null if no collider was found or if ignoreCollide was set to true.
	**/
	@:final public function getCollider() : h3d.col.Collider {
		if( ignoreCollide )
			return null;
		var colliders = [];
		var col = getGlobalCollider();
		if( col != null )
			colliders.push(col);
		for( obj in children ) {
			var c = obj.getCollider();
			if( c == null ) continue;
			var cgrp = hxd.impl.Api.downcast(c, h3d.col.Collider.GroupCollider);
			if( cgrp != null ) {
				for( c in cgrp.colliders )
					colliders.push(c);
			} else
				colliders.push(c);
		}
		if( colliders.length == 0 )
			return null;
		if( colliders.length == 1 )
			return colliders[0];
		return new h3d.col.Collider.GroupCollider(colliders);
	}

	/**
		Same as getLocalCollider, but returns an absolute collider instead of a local one.
	**/
	public function getGlobalCollider() : h3d.col.Collider {
		if(ignoreCollide)
			return null;
		var col = getLocalCollider();
		return col == null ? null : new h3d.col.ObjectCollider(this, col);
	}

	/**
		Build and returns the local relative not-recursive collider for the object, or null if this object does not have a collider.
		Does not check for ignoreCollide.
	**/
	public function getLocalCollider() : h3d.col.Collider {
		return null;
	}

	function draw( ctx : RenderContext ) {
	}

	function set_follow(v) {
		posChanged = true;
		return follow = v;
	}

	function calcAbsPos() {
		qRot.toMatrix(absPos);
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
				absPos.multiply3x4inline(absPos, parent.absPos);
				absPos.tx = x + follow.absPos.tx;
				absPos.ty = y + follow.absPos.ty;
				absPos.tz = z + follow.absPos.tz;
			} else
				absPos.multiply3x4(absPos, follow.absPos);
		} else if( parent != null && !ignoreParentTransform )
			absPos.multiply3x4inline(absPos, parent.absPos);
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

		if(ctx.cullingCollider != null && (cullingCollider == null || cullingColliderInherited)) {
			cullingCollider = ctx.cullingCollider;
			cullingColliderInherited = true;
		}
		else if(cullingColliderInherited)
			cullingCollider = null;

		var prevCollider = ctx.cullingCollider;
		if(inheritCulled)
			ctx.cullingCollider = cullingCollider;

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
		ctx.cullingCollider = prevCollider;
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

		if( !visible || (culled && inheritCulled && !ctx.computingStatic) )
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
		if( !culled || ctx.computingStatic )
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

	/**
		Set the position of the object relative to its parent.
	**/
	public inline function setPosition( x : Float, y : Float, z : Float ) {
		this.x = x;
		this.y = y;
		this.z = z;
		posChanged = true;
	}

	/**
		Set the position, scale and rotation of the object relative to its parent based on the specified transform matrix.
	**/
	static var tmpMat = new h3d.Matrix();
	static var tmpVec = new h3d.Vector();
	public function setTransform( mat : h3d.Matrix ) {
		var s = mat.getScale(tmpVec);
		this.x = mat.tx;
		this.y = mat.ty;
		this.z = mat.tz;
		this.scaleX = s.x;
		this.scaleY = s.y;
		this.scaleZ = s.z;
		tmpMat.load(mat);
		tmpMat.prependScale(1.0 / s.x, 1.0 / s.y, 1.0 / s.z);
		qRot.initRotateMatrix(tmpMat);
		posChanged = true;
	}

	/**
		Returns the local position, scale and rotation of the object relative to its parent.
	**/
	public function getTransform( ?mat : h3d.Matrix ) : h3d.Matrix {
		if( mat == null ) mat = new h3d.Matrix();
		mat.initScale(scaleX, scaleY, scaleZ);
		qRot.toMatrix(tmpMat);
		mat.multiply3x4(mat, tmpMat);
		mat.tx = x;
		mat.ty = y;
		mat.tz = z;
		return mat;
	}

	/**
		Rotate around the current rotation axis by the specified angles (in radian).
	**/
	public function rotate( rx : Float, ry : Float, rz : Float ) {
		var qTmp = new h3d.Quat();
		qTmp.initRotation(rx, ry, rz);
		qRot.multiply(qTmp,qRot);
		posChanged = true;
	}

	/**
		Set the rotation using the specified angles (in radian).
	**/
	public function setRotation( rx : Float, ry : Float, rz : Float ) {
		qRot.initRotation(rx, ry, rz);
		posChanged = true;
	}

	/**
		Set the rotation using the specified axis and angle of rotation around it (in radian).
	**/
	public function setRotationAxis( ax : Float, ay : Float, az : Float, angle : Float ) {
		qRot.initRotateAxis(ax, ay, az, angle);
		posChanged = true;
	}

	/**
		Set the rotation using the specified look at direction
	**/
	public function setDirection( v : h3d.Vector ) {
		qRot.initDirection(v);
		posChanged = true;
	}

	/**
		Return the direction in which the object rotation is currently oriented to
	**/
	public function getLocalDirection() {
		return qRot.getDirection();
	}

	/**
		Return the quaternion representing the current object rotation.
		Dot not modify as it's not a copy.
	**/
	public function getRotationQuat() {
		return qRot;
	}

	/**
		Set the quaternion representing the current object rotation.
		Dot not modify the value afterwards as no copy is made.
	**/
	public function setRotationQuat(q) {
		qRot = q;
		posChanged = true;
	}

	/**
		Scale uniformly the object by the given factor.
	**/
	public inline function scale( v : Float ) {
		scaleX *= v;
		scaleY *= v;
		scaleZ *= v;
		posChanged = true;
	}

	/**
		Set the uniform scale for the object.
	**/
	public inline function setScale( v : Float ) {
		scaleX = v;
		scaleY = v;
		scaleZ = v;
		posChanged = true;
	}

	/**
		Return both class name and object name if any.
	**/
	public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop() + (name == null ? "" : "(" + name + ")");
	}

	/**
		Return the `n`th element among our immediate children list, or null if there is no.
	**/
	public inline function getChildAt( n ) {
		return children[n];
	}

	/**
		Return the index of the object `o` within our immediate children list, or `-1` if it is not part of our children list.
	**/
	public function getChildIndex( o ) {
		for( i in 0...children.length )
			if( children[i] == o )
				return i;
		return -1;
	}

	inline function get_numChildren() {
		return children.length;
	}

	/**
		Return an iterator over this object immediate children
	**/
	public inline function iterator() : hxd.impl.ArrayIterator<Object> {
		return new hxd.impl.ArrayIterator(children);
	}

	#if (hxbit && !macro && heaps_enable_serialize)
	function customSerialize( ctx : hxbit.Serializer ) {

		var children = [for( o in children ) if( o.allowSerialize ) o];
		ctx.addInt(children.length);
		for( o in children )
			ctx.addKnownRef(o);
		ctx.addDouble(qRot.x);
		ctx.addDouble(qRot.y);
		ctx.addDouble(qRot.z);
		ctx.addDouble(qRot.w);

		ctx.addBool(defaultTransform != null);
		if( defaultTransform != null ) {
			ctx.addFloat(defaultTransform._11);
			ctx.addFloat(defaultTransform._12);
			ctx.addFloat(defaultTransform._13);
			ctx.addFloat(defaultTransform._21);
			ctx.addFloat(defaultTransform._22);
			ctx.addFloat(defaultTransform._23);
			ctx.addFloat(defaultTransform._31);
			ctx.addFloat(defaultTransform._32);
			ctx.addFloat(defaultTransform._33);
			ctx.addFloat(defaultTransform._41);
			ctx.addFloat(defaultTransform._42);
			ctx.addFloat(defaultTransform._43);
		}

	}

	static var COUNT = 0;

	function customUnserialize( ctx : hxbit.Serializer ) {
		children = [for( i in 0...ctx.getInt() ) ctx.getKnownRef(Object)];
		qRot = new h3d.Quat(ctx.getDouble(), ctx.getDouble(), ctx.getDouble(), ctx.getDouble());

		if( ctx.getBool() ) {
			defaultTransform = new h3d.Matrix();
			defaultTransform.loadValues([
				ctx.getFloat(),
				ctx.getFloat(),
				ctx.getFloat(),
				0,
				ctx.getFloat(),
				ctx.getFloat(),
				ctx.getFloat(),
				0,
				ctx.getFloat(),
				ctx.getFloat(),
				ctx.getFloat(),
				0,
				ctx.getFloat(),
				ctx.getFloat(),
				ctx.getFloat(),
				1
			]);
		}

		// init
		for( c in children )
			c.parent = this;
		allocated = false;
		posChanged = true;
		absPos = new h3d.Matrix();
		absPos.identity();
		if( currentAnimation != null )
			@:privateAccess currentAnimation.initAndBind(this);
	}
	#end

}
