package h2d;

/**
	2D camera instance. Allows for positioning, scaling and rotation of 2D objects on the scene.
	Per-layer visibility can be configured by overriding `layerVisible` method.
	Camera can clip out contents outside of it's viewport by setting `clipViewport` to `true`.
	Due to Heaps event handling structure, only one camera can handle scene events, and can be set with `h2d.Scene.interactiveCamera`.
	When handling events, assigned camera isn't checked for it's nor layers visibiilty.
	Camera system is circumvented if Scene would get any filter assigned to it.
**/
@:access(h2d.Scene)
@:allow(h2d.Scene)
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
		Horizontal scale factor of the camera. Scaling applied, using anchored position as pivot.
	**/
	public var scaleX(default, set) : Float;
	/**
		Vertical scale factor of the camera. Scaling applied, using anchored position as pivot.
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
		Horizontal viewport offset of the camera relative to internal scene viewport (see h2d.Scene.scaleMode) in scene coordinates. ( default : 0 )  
		Internally stored as 0..1 percentile and automatically adapts on scene resize.
	**/
	public var viewportX(get, set) : Float;
	/**
		Vertical viewport offset of the camera relative to internal scene viewport (see h2d.Scene.scaleMode) in scene coordinates. ( default : 0 )  
		Internally stored as 0..1 percentile and automatically adapts on scene resize.
	**/
	public var viewportY(get, set) : Float;
	/**
		Camera viewport width in scene coordinates. ( default : scene.width )  
		Internally stored as 0..1 percentile and automatically adapts on scene resize.
	**/
	public var viewportWidth(get, set) : Float;
	/**
		Camera viewport height in scene coordinates. ( default: scene.height )  
		Internally stored as 0..1 percentile and automatically adapts on scene resize.
	**/
	public var viewportHeight(get, set) : Float;

	/**
		Horizontal anchor position inside viewport boundaries used for anchoring and resize compensation. ( default : 0 )  
		Value is a percentile (0..1) from left viewport edge to right viewport edge with 0.5 being center.
	**/
	public var anchorX(default, set) : Float;
	/**
		Vertical anchor position inside viewport boundaries used for anchoring and resize compensation. ( default : 0 )  
		Value is apercentile (0..1) from top viewport edge to bottom viewport edge with 0.5 being center.
	**/
	public var anchorY(default, set) : Float;

	/** Camera visibility. Does not affect event handling for interactive camera. **/
	public var visible : Bool;

	/** Set to enable primitive position sync between camera and target Object. **/
	public var follow : h2d.Object;
	/** Syncs camera rotation to follow object rotation. **/
	public var followRotation : Bool;

	var posChanged : Bool;

	var viewX : Float;
	var viewY : Float;
	var viewW : Float;
	var viewH : Float;

	var matA : Float;
	var matB : Float;
	var matC : Float;
	var matD : Float;
	var absX : Float;
	var absY : Float;
	var invDet : Float;

	var scene : Scene;

	public function new( scene : Scene, anchorX : Float = 0, anchorY : Float = 0 ) {
		this.scene = scene;
		this.x = 0; this.y = 0;
		this.scaleX = 1; this.scaleY = 1;
		this.rotation = 0;
		this.anchorX = anchorX;
		this.anchorY = anchorY;
		this.viewX = 0; this.viewY = 0;
		this.viewW = 1; this.viewH = 1;
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
			ctx.setRenderZone(viewX * scene.width, viewY * scene.height, viewW * scene.width, viewH * scene.height);
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
			absX = Math.round(-(x * matA + y * matC) + (scene.width * anchorX * viewW) + scene.width * viewX);
			absY = Math.round(-(x * matB + y * matD) + (scene.height * anchorY * viewH) + scene.height * viewY);
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

	/**
		Sets camera viewport dimensions. If `w` or `h` arguments are 0 - scene size is used (width or height respectively).
	**/
	public inline function setViewport( x : Float = 0, y : Float = 0, w : Float = 0, h : Float = 0 ) {
		this.viewportX = x;
		this.viewportY = y;
		this.viewportWidth = w == 0 ? scene.width : w;
		this.viewportHeight = h == 0 ? scene.height : h;
	}

	/**
		Sets camera viewport dimensions in raw format of 0..1 percentiles.
	**/
	public inline function setRawViewport( x : Float = 0, y : Float = 0, w : Float = 1, h : Float = 1 ) {
		this.viewX = x;
		this.viewY = y;
		this.viewW = w;
		this.viewH = h;
		posChanged = true;
	}

	// Scren <-> Camera
	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	inline function screenXToCamera( mx : Float, my : Float ) : Float {
		return sceneXToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	inline function screenYToCamera( mx : Float, my : Float ) : Float {
		return sceneYToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	inline function cameraXToScreen( mx : Float, my : Float ) : Float {
		return cameraXToScene(mx, my) * scene.viewportScaleX + scene.offsetX;
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	inline function cameraYToScreen( mx : Float, my : Float ) : Float {
		return cameraYToScene(mx, my) * scene.viewportScaleY + scene.offsetY;
	}

	// Scene <-> Camera
	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenXToCamera` to convert position with accounting of `scaleMode`.
	**/
	inline function sceneXToCamera( mx : Float, my : Float ) : Float {
		return ((mx - absX) * matD - (my - absY) * matC) * invDet;
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenYToCamera` to convert position with accounting of `scaleMode`.
	**/
	inline function sceneYToCamera( mx : Float, my : Float ) : Float {
		return (-(mx - absX) * matB + (my - absY) * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraXToScreen` to convert position with accounting of `scaleMode`.
	**/
	inline function cameraXToScene( mx : Float, my : Float ) : Float {
		return mx * matA + my * matC + absX;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraYToScreen` to convert position with accounting of `scaleMode`.
	**/
	inline function cameraYToScene( mx : Float, my : Float ) : Float {
		return mx * matB + my * matD + absY;
	}

	// Point/event

	@:noCompletion public function eventToCamera( e : hxd.Event ) {
		var x = (e.relX - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (e.relY - scene.offsetY) / scene.viewportScaleY - absY;
		e.relX = (x * matD - y * matC) * invDet;
		e.relY = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert screen position into a local camera position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function screenToCamera( pt : h2d.col.Point ) {
		var x = (pt.x - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (pt.y - scene.offsetY) / scene.viewportScaleY - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position to absolute screen position.
		Requires Scene as a reference to viewport of `scaleMode`.
	**/
	public function cameraToScreen( pt : h2d.col.Point ) {
		var x = pt.x;
		var y = pt.y;
		pt.x = cameraXToScreen(x, y);
		pt.y = cameraYToScreen(x, y);
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `screenToCamera` to convert position with accounting of `scaleMode`.
	**/
	public function sceneToCamera( pt : h2d.col.Point ) {
		var x = pt.x - absX;
		var y = pt.y - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `cameraToScreen` to convert position with accounting of `scaleMode`.
	**/
	public function cameraToScene( pt : h2d.col.Point ) {
		var x = pt.x;
		var y = pt.y;
		pt.x = cameraXToScene(x, y);
		pt.y = cameraYToScene(x, y);
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

	inline function get_viewportX() { return viewX * scene.width; }
	inline function set_viewportX( v ) {
		posChanged = true;
		this.viewX = Math.floor(v) / scene.width;
		return v;
	}

	inline function get_viewportY() { return viewY * scene.height; }
	inline function set_viewportY( v ) {
		posChanged = true;
		this.viewY = Math.floor(v) / scene.height;
		return v;
	}

	inline function get_viewportWidth() { return viewW * scene.width; }
	inline function set_viewportWidth( v ) {
		posChanged = true;
		this.viewW = Math.ceil(v) / scene.width;
		return v;
	}

	inline function get_viewportHeight() { return viewH * scene.height; }
	inline function set_viewportHeight( v ) {
		posChanged = true;
		this.viewH = Math.ceil(v) / scene.height;
		return v;
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