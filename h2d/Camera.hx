package h2d;

/**
	2D camera instance. Allows for positioning, scaling and rotation of 2D objects on the scene.
	Per-layer visibility can be configured by overriding `layerVisible` method.
	Camera can clip out contents outside of it's viewport by setting `clipViewport` to `true`.
	Due to Heaps event handling structure, only one camera can handle scene events, and can be set with `h2d.Scene.interactiveCamera`.
	When handling events, assigned camera isn't checked for it's nor layers visibiilty.
	Camera system is circumvented if Scene would get any filter assigned to it.
**/
class Camera {

	/**
		X position of the camera in world space based on anchorX.
	**/
	public var x(default, set) : Float;
	/**
		Y position of the camera in world space based on anchorY.
	**/
	public var y(default, set) : Float;

	/**
		Horizontal scale factor of the camera. Scaling applied relative to anchored position.
	**/
	public var scaleX(default, set) : Float;
	/**
		Vertical scale factor of the camera. Scalid applied relative to anchored position.
	**/
	public var scaleY(default, set) : Float;

	/**
		Rotation of the camera in radians. Camera is rotated around anchored position.
	**/
	public var rotation(default, set) : Float;

	/**
		Enables viewport clipping. Allow to restrict rendering area of the camera.
	**/
	public var clipViewport : Bool;
	/**
		Horizontal viewport offset of the camera relative to the Scene. Set in 0..1 range percentile. ( default : 0 )
	**/
	public var viewportX(default, set) : Float;
	/**
		Vertical viewport offset of the camera relative to the Scene. Set in 0..1 range percentile. ( default : 0 )
	**/
	public var viewportY(default, set) : Float;
	/**
		Camera viewport width relative to the Scene size.
	**/
	public var viewportWidth(default, set) : Float;
	/**
		Camera viewport height relative to the Scene size.
	**/
	public var viewportHeight(default, set) : Float;

	/** Horizontal anchor position inside viewport boundaries used for anchoring and resize compensation. ( default : 0 ) **/
	public var anchorX(default, set) : Float;
	/** Vertical anchor position inside viewport boundaries used for anchoring and resize compensation. ( default : 0 ) **/
	public var anchorY(default, set) : Float;

	/** Camera visibility. Does not affect event handling for interactive camera. **/
	public var visible : Bool;

	/** Set to enable primitive position sync between camera and target Object. **/
	public var follow : h2d.Object;
	/** Syncs camera rotation to follow object rotation. **/
	public var followRotation : Bool;

	var posChanged : Bool;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;
	var invDet : Float;

	public function new( anchorX : Float = 0, anchorY : Float = 0 ) {
		this.x = 0; this.y = 0;
		this.scaleX = 1; this.scaleY = 1;
		this.rotation = 0;
		this.anchorX = anchorX;
		this.anchorY = anchorY;
		this.viewportX = 0;
		this.viewportY = 0;
		this.viewportWidth = 1;
		this.viewportHeight = 1;
		this.visible = true;
	}

	/**
		Override this method to set visibility only to specific layers. Renders all layers by default.
		Layer visibility is not checked during Interactive event handling.
	**/
	public dynamic function layerVisible( layer : Int ) : Bool {
		return true;
	}

	@:noCompletion public function enter( ctx : RenderContext ) {
		ctx.pushCamera(this);
		if ( clipViewport )
			ctx.setRenderZone(viewportX * ctx.scene.width, viewportY * ctx.scene.height, viewportWidth * ctx.scene.width, viewportHeight * ctx.scene.height);
	}

	@:noCompletion public function exit( ctx : RenderContext ) {
		if ( clipViewport )
			ctx.clearRenderZone();
		ctx.popCamera();
	}

	@:access(h2d.Object)
	public function sync( ctx : RenderContext, force : Bool = false )
	{
		if ( follow != null ) {
			this.x = follow.absX;
			this.y = follow.absY;
			if ( followRotation ) this.rotation = -follow.rotation;
		}
		if ( posChanged || force ) {
			var scene = ctx.scene;
			if ( rotation == 0 ) {
				matA = scaleX;
				matB = 0;
				matC = 0;
				matD = scaleY;
			} else {
				var cr = Math.cos(rotation);
				var sr = Math.sin(rotation);
				matA = scaleX * cr;
				matB = scaleX * sr;
				matC = scaleY * -sr;
				matD = scaleY * cr;
			}
			absX = -(x * matA + y * matC) + (scene.width * anchorX * viewportHeight) + scene.width * viewportX;
			absY = -(x * matB + y * matD) + (scene.height * anchorY * viewportHeight) + scene.height * viewportY;
			invDet = 1 / (matA * matD - matB * matC);
			posChanged = false;
		}
	}

	public inline function setScale( x : Float, y : Float ) {
		this.scaleX = x;
		this.scaleY = y;
	}

	public inline function scale( x : Float, y : Float ) {
		this.scaleX *= x;
		this.scaleY *= y;
	}

	public inline function setPosition( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}

	public inline function move( dx : Float, dy : Float ) {
		this.x += dx;
		this.y += dy;
	}

	public inline function rotate( v : Float ) {
		this.rotation += v;
	}

	public inline function setAnchor( x : Float, y : Float ) {
		this.anchorX = x;
		this.anchorY = y;
	}

	public inline function setViewport( x : Float = 0, y : Float = 0, w : Float = 1, h : Float = 1 ) {
		this.viewportX = x;
		this.viewportY = y;
		this.viewportWidth = w;
		this.viewportHeight = h;
	}

	// Scren <-> Camera
	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function screenXToCamera( mx : Float, my : Float, scene : Scene ) : Float {
		return globalXToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function screenYToCamera( mx : Float, my : Float, scene : Scene ) : Float {
		return globalYToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function cameraXToScreen( mx : Float, my : Float, scene : Scene ) : Float {
		return inline cameraXToGlobal(mx, my) * scene.viewportScaleX + scene.offsetX;
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function cameraYToScreen( mx : Float, my : Float, scene : Scene ) : Float {
		return inline cameraYToGlobal(mx, my) * scene.viewportScaleY + scene.offsetY;
	}

	// Scene <-> Camera
	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenXToCamera` to convert position with accounting of `scaleMode`.
	**/
	public function globalXToCamera( mx : Float, my : Float ) : Float {
		return ((mx - absX) * matD - (my - absY) * matC) * invDet;
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenYToCamera` to convert position with accounting of `scaleMode`.
	**/
	public function globalYToCamera( mx : Float, my : Float ) : Float {
		return (-(mx - absX) * matB + (my - absY) * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraXToScreen` to convert position with accounting of `scaleMode`.
	**/
	public function cameraXToGlobal( mx : Float, my : Float ) : Float {
		return mx * matA + my * matC + absX;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraYToScreen` to convert position with accounting of `scaleMode`.
	**/
	public function cameraYToGlobal( mx : Float, my : Float ) : Float {
		return mx * matB + my * matD + absY;
	}

	// Point/event

	@:noCompletion public function eventToCamera( e : hxd.Event, scene : Scene ) {
		var x = (e.relX - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (e.relY - scene.offsetY) / scene.viewportScaleY - absY;
		e.relX = (x * matD - y * matC) * invDet;
		e.relY = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function screenToCamera( pt : h2d.col.Point, scene : Scene ) {
		var x = (pt.x - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (pt.y - scene.offsetY) / scene.viewportScaleY - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function cameraToScreen( pt : h2d.col.Point, scene : Scene ) {
		var x = pt.x;
		var y = pt.y;
		pt.x = inline cameraXToScreen(x, y, scene);
		pt.y = inline cameraYToScreen(x, y, scene);
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenToCamera` to convert position with accounting of `scaleMode`.
	**/
	public function globalToCamera( pt : h2d.col.Point ) {
		var x = pt.x - absX;
		var y = pt.y - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraToScreen` to convert position with accounting of `scaleMode`.
	**/
	public function cameraToGlobal( pt : h2d.col.Point ) {
		var x = pt.x;
		var y = pt.y;
		pt.x = inline cameraXToGlobal(x, y);
		pt.y = inline cameraYToGlobal(x, y);
	}

	// Setters

	inline function set_x( v ) {
		posChanged = true;
		return this.x = v;
	}

	inline function set_y( v ) {
		posChanged = true;
		return this.y = v;
	}

	inline function set_scaleX( v ) {
		posChanged = true;
		return this.scaleX = v;
	}

	inline function set_scaleY( v ) {
		posChanged = true;
		return this.scaleY = v;
	}

	inline function set_rotation( v ) {
		posChanged = true;
		return this.rotation = v;
	}

	inline function set_viewportX( v ) {
		posChanged = true;
		return this.viewportX = v;
	}

	inline function set_viewportY( v ) {
		posChanged = true;
		return this.viewportY = v;
	}

	inline function set_viewportWidth( v ) {
		posChanged = true;
		return this.viewportWidth = v;
	}

	inline function set_viewportHeight( v ) {
		posChanged = true;
		return this.viewportHeight = v;
	}

	inline function set_anchorX( v ) {
		posChanged = true;
		return anchorX = v;
	}

	inline function set_anchorY( v ) {
		posChanged = true;
		return anchorY = v;
	}

}