package h2d;

/**
	A 2D camera representation attached to `h2d.Scene`.

	Enables ability to move, scale and rotate the scene viewport.

	Scene supports usage of multiple Camera instances.
	To configure which layers each Camera renders - `Camera.layerVisible` method should be overridden.
	By default, camera does not clip out the contents that are outside camera bounding box, which can be enabled through `Camera.clipViewport`.

	Due to Heaps event handling structure, only one Camera instance can handle the mouse/touch input, and can be set through `h2d.Scene.interactiveCamera` variable.
	Note that during even handing, interactive camera does not check if the Camera itself is visible nor the layers filters as well as `clipViewport` is not applied.
**/
@:access(h2d.RenderContext)
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
		Enables viewport clipping. Allow to restrict rendering area of the camera to the viewport boundaries.

		Does not affect the user input when Camera is set as interactive camera.
	**/
	public var clipViewport : Bool;
	/**
		Horizontal viewport offset of the camera relative to internal scene viewport (see `h2d.Scene.scaleMode`) in scene coordinates. ( default : 0 )  
		Automatically scales on scene resize.
	**/
	public var viewportX(get, set) : Float;
	/**
		Vertical viewport offset of the camera relative to internal scene viewport (see `h2d.Scene.scaleMode`) in scene coordinates. ( default : 0 )  
		Automatically scales on scene resize.
	**/
	public var viewportY(get, set) : Float;
	/**
		Camera viewport width in scene coordinates. ( default : scene.width )  
		Automatically scales on scene resize.
	**/
	public var viewportWidth(get, set) : Float;
	/**
		Camera viewport height in scene coordinates. ( default: scene.height )  
		Automatically scales on scene resize.
	**/
	public var viewportHeight(get, set) : Float;

	/**
		Horizontal anchor position inside viewport boundaries used for positioning and resize compensation. ( default : 0 )  
		Value is a percentile (0..1) from left viewport edge to right viewport edge with 0.5 being center.
	**/
	public var anchorX(default, set) : Float;
	/**
		Vertical anchor position inside viewport boundaries used for positioning and resize compensation. ( default : 0 )  
		Value is a percentile (0..1) from top viewport edge to bottom viewport edge with 0.5 being center.
	**/
	public var anchorY(default, set) : Float;

	/**
		Camera visibility.

		Does not affect the user input when Camera is set as interactive camera.
	**/
	public var visible : Bool;

	/**
		Makes camera to follow the referenced Object position.
	**/
	public var follow : h2d.Object;
	/**
		Enables `h2d.Object.rotation` sync between `Camera.follow` object and Camera.
	**/
	public var followRotation : Bool = false;

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

	/**
		Create a new Camera instance and attach to the given `scene`.
		@param scene Optional owner Scene to which camera auto-attaches to.
		Note that when Camera is not attached to the Scene, a number of methods would lead to an error if called.
	**/
	public function new( ?scene : Scene ) {
		this.x = 0; this.y = 0;
		this.scaleX = 1; this.scaleY = 1;
		this.rotation = 0;
		this.anchorX = 0;
		this.anchorY = 0;
		this.viewX = 0; this.viewY = 0;
		this.viewW = 1; this.viewH = 1;
		this.visible = true;
		if (scene != null) scene.addCamera(this);
	}

	/**
		Detaches Camera from the Scene it currently attached to.
	**/
	public inline function remove() {
		if (scene != null) scene.removeCamera(this);
	}

	/**
		Override this method to set visibility only to specific layers. Renders all layers by default.

		Does not affect the user input when Camera is set as interactive camera.

		Usage example:

		```haxe
		final LAYER_SHARED = 0;
		final LAYER_PLAYER_1 = 2;
		final LAYER_PLAYER_2 = 3;
		final LAYER_UI = 4;
		// Set first camera to only render shared layer and one that only visible to player 1.
		s2d.camera.layerVisible = (layer) -> layer == LAYER_SHARED || layer == LAYER_PLAYER_1;
		var player2 = new h2d.Camera(s2d);
		// Set second camera to only render shared layer and one that only visible to player 2.
		player2.layerVisible = (layer) -> layer == LAYER_SHARED || layer == LAYER_PLAYER_2;
		var ui = new h2d.Camera(s2d);
		// Set last camera to only render UI layer.
		ui.layerVisible = (layer) -> layer == LAYER_UI;
		```

		@param layer The rendered layer index in `h2d.Scene`.
		@returns `true` if layer can be rendered, `false` otherwise.

	**/
	public dynamic function layerVisible( layer : Int ) : Bool {
		return true;
	}

	/**
		<span class="label">Internal usage</span>

		Prepares RenderContext to render the camera contents and clips viewport if necessary. Should call `Camera.exit` afterwards.
	**/
	@:dox(hide) @:noCompletion public function enter( ctx : RenderContext ) {
		ctx.pushCamera(this);
		if ( clipViewport ) {
			var old = ctx.inFilter;
			ctx.inFilter = null;
			ctx.pushRenderZone(viewX * scene.width, viewY * scene.height, viewW * scene.width, viewH * scene.height);
			ctx.inFilter = old;
		}
	}

	/**
		<span class="label">Internal usage</span>

		Causes RenderContext to restore the state prior to camera rendering. Should be called after `Camera.enter` when rendering is finished.
	**/
	@:dox(hide) @:noCompletion public function exit( ctx : RenderContext ) {
		if ( clipViewport ) {
			var old = ctx.inFilter;
			ctx.inFilter = null;
			ctx.popRenderZone();
			ctx.inFilter = old;
		}
		ctx.popCamera();
	}

	/**
		<span class="label">Internal usage</span>

		Synchronizes the camera transform matrix.
	**/
	@:access(h2d.Object) @:dox(hide) @:noCompletion
	public function sync( ctx : RenderContext, force : Bool = false )
	{
		if (scene == null) return;

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

	/**
		Sets the `Camera.scaleX` and `Camera.scaleY` to given `x` and `y`.
	**/
	public inline function setScale( x : Float, y : Float ) {
		this.scaleX = x;
		this.scaleY = y;
	}

	/**
		Multiplies the `Camera.scaleX` by `x` and `Camera.scaleY` by `y`.
	**/
	public inline function scale( x : Float, y : Float ) {
		this.scaleX *= x;
		this.scaleY *= y;
	}

	/**
		Sets the camera position to given `x` and `y`.
	**/
	public inline function setPosition( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}

	/**
		Moves the camera position by given `dx` and `dy`.
	**/
	public inline function move( dx : Float, dy : Float ) {
		this.x += dx;
		this.y += dy;
	}

	/**
		Rotates the camera relative to current rotation by given `angle` in radians.
	**/
	public inline function rotate( angle : Float ) {
		this.rotation += angle;
	}

	/**
		Sets the `Camera.anchorX` and `Camera.anchorY` to given `x` and `y`.
	**/
	public inline function setAnchor( x : Float, y : Float ) {
		this.anchorX = x;
		this.anchorY = y;
	}

	/**
		Sets camera viewport dimensions. If `w` or `h` arguments are 0 - scene size is used (width or height respectively).

		Requires Camera being attached to a Scene.
	**/
	public inline function setViewport( x : Float = 0, y : Float = 0, w : Float = 0, h : Float = 0 ) {
		checkScene();
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

	// Screen <-> Camera
	/**
		Convert screen position into a local camera position.

		Requires Camera being attached to a Scene.
	**/
	inline function screenXToCamera( mx : Float, my : Float ) : Float {
		return sceneXToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert screen position into a local camera position.

		Requires Camera being attached to a Scene.
	**/
	inline function screenYToCamera( mx : Float, my : Float ) : Float {
		return sceneYToCamera((mx - scene.offsetX) / scene.viewportScaleX, (my - scene.offsetY) / scene.viewportScaleY);
	}

	/**
		Convert local camera position to absolute screen position.

		Requires Camera being attached to a Scene.
	**/
	inline function cameraXToScreen( mx : Float, my : Float ) : Float {
		return cameraXToScene(mx, my) * scene.viewportScaleX + scene.offsetX;
	}

	/**
		Convert local camera position to absolute screen position.

		Requires Camera being attached to a Scene.
	**/
	inline function cameraYToScreen( mx : Float, my : Float ) : Float {
		return cameraYToScene(mx, my) * scene.viewportScaleY + scene.offsetY;
	}

	// Scene <-> Camera
	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `Camera.screenXToCamera` to convert position with accounting of `scaleMode`.
	**/
	inline function sceneXToCamera( mx : Float, my : Float ) : Float {
		return ((mx - absX) * matD - (my - absY) * matC) * invDet;
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `Camera.screenYToCamera` to convert position with accounting of `scaleMode`.
	**/
	inline function sceneYToCamera( mx : Float, my : Float ) : Float {
		return (-(mx - absX) * matB + (my - absY) * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `Camera.cameraXToScreen` to convert position with accounting of `scaleMode`.
	**/
	inline function cameraXToScene( mx : Float, my : Float ) : Float {
		return mx * matA + my * matC + absX;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `Camera.cameraYToScreen` to convert position with accounting of `scaleMode`.
	**/
	inline function cameraYToScene( mx : Float, my : Float ) : Float {
		return mx * matB + my * matD + absY;
	}

	// Point/event
	/**
		<span class="label">Internal usage</span>
		Convert `Event.relX` and `Event.relY` to local camera position.
	**/
	@:dox(hide) @:noCompletion public function eventToCamera( e : hxd.Event ) {
		var x = (e.relX - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (e.relY - scene.offsetY) / scene.viewportScaleY - absY;
		e.relX = (x * matD - y * matC) * invDet;
		e.relY = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert screen position into a local camera position.

		Requires Camera being attached to a Scene.
	**/
	public function screenToCamera( pt : h2d.col.Point ) {
		checkScene();
		var x = (pt.x - scene.offsetX) / scene.viewportScaleX - absX;
		var y = (pt.y - scene.offsetY) / scene.viewportScaleY - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position to absolute screen position.

		Requires Camera being attached to a Scene.
	**/
	public function cameraToScreen( pt : h2d.col.Point ) {
		checkScene();
		var x = pt.x;
		var y = pt.y;
		pt.x = cameraXToScreen(x, y);
		pt.y = cameraYToScreen(x, y);
	}

	/**
		Convert an absolute scene position into a local camera position.
		Does not represent screen position, see `Camera.screenToCamera` to convert position with accounting of `scaleMode`.

		Requires Camera being attached to a Scene.
	**/
	public function sceneToCamera( pt : h2d.col.Point ) {
		checkScene();
		var x = pt.x - absX;
		var y = pt.y - absY;
		pt.x = (x * matD - y * matC) * invDet;
		pt.y = (-x * matB + y * matA) * invDet;
	}

	/**
		Convert local camera position into absolute scene position.
		Does not represent screen position, see `Camera.cameraToScreen` to convert position with accounting of `scaleMode`.

		Requires Camera being attached to a Scene.
	**/
	public function cameraToScene( pt : h2d.col.Point ) {
		checkScene();
		var x = pt.x;
		var y = pt.y;
		pt.x = cameraXToScene(x, y);
		pt.y = cameraYToScene(x, y);
	}

	inline function checkScene() {
		if (scene == null) throw "This method requires Camera to be added to the Scene";
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

	inline function get_viewportX() { checkScene(); return viewX * scene.width; }
	inline function set_viewportX( v ) {
		checkScene();
		posChanged = true;
		this.viewX = Math.floor(v) / scene.width;
		return v;
	}

	inline function get_viewportY() { checkScene(); return viewY * scene.height; }
	inline function set_viewportY( v ) {
		checkScene();
		posChanged = true;
		this.viewY = Math.floor(v) / scene.height;
		return v;
	}

	inline function get_viewportWidth() { checkScene(); return viewW * scene.width; }
	inline function set_viewportWidth( v ) {
		checkScene();
		posChanged = true;
		this.viewW = Math.ceil(v) / scene.width;
		return v;
	}

	inline function get_viewportHeight() { checkScene(); return viewH * scene.height; }
	inline function set_viewportHeight( v ) {
		checkScene();
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