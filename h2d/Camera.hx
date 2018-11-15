package h2d;

/**
	A 2D camera object allowing for robust and easy camera access.
	Camera automatically compensates it's position to remain on the anchoring point when scene is resized.
	Note that while it is "scalable" it does not mask the objects that are outside of camera boundaries.
**/
@:allow(h2d.Scene)
class Camera extends h2d.Object {

	/** X position of the camera anchor point. **/
	public var viewX(get, set) : Float;
	/** Y position of the camera anchor point. **/
	public var viewY(get, set) : Float;

	/** Current camera width. Cannot be set directly, please use `horizontalRatio`. **/
	public var width(default, null) : Int;
	/** Current camera height. Cannot be set directly, please use `verticalRatio`. **/
	public var height(default, null) : Int;
	/** Percent value of horizontal camera size relative to s2d size. (default : 1) **/
	public var horizontalRatio(default, set) : Float;
	/** Percent value of vertical camera size relative to s2d size. (default : 1) **/
	public var verticalRatio(default, set) : Float;
	/** Horizontal anchor position inside ratio boundaries used for anchoring and resize compensation. ( default : 0.5 ) **/
	public var anchorX(default, set) : Float;
	/** Vertical anchor position inside ratio boundaries used for anchoring and resize compensation. ( default : 0.5 ) **/
	public var anchorY(default, set) : Float;

	/**
		Object, which position camera should follow.
	**/
	public var follow : Object;

	var ratioChanged : Bool;
	var sceneWidth : Int;
	var sceneHeight : Int;
	var anchorWidth : Float;
	var anchorHeight : Float;
	var scene : Scene;

	var camA : Float;
	var camB : Float;
	var camC : Float;
	var camD : Float;
	var camX : Float;
	var camY : Float;
	var invDet : Float;

	public function new( ?parent : h2d.Object, horizontalRatio : Float = 1, verticalRatio : Float = 1, anchorX : Float = 0.5, anchorY : Float = 0.5 ) {
		super(parent);
		this.horizontalRatio = horizontalRatio;
		this.verticalRatio = verticalRatio;
		this.anchorX = anchorX;
		this.anchorY = anchorY;
		this.width = 0; this.height = 0;
		this.anchorWidth = 0; this.anchorHeight = 0;
		this.sceneWidth = 0; this.sceneHeight = 0;
		ratioChanged = true;
		if ( parent != null ) {
			initScene();
		}
	}

	inline function get_viewX() { return this.x + anchorWidth; }
	inline function get_viewY() { return this.y + anchorHeight; }

	inline function set_viewX( v : Float ) {
		this.x = v - anchorWidth;
		return v;
	}
	inline function set_viewY( v : Float ) {
		this.y = v - anchorHeight;
		return v;
	}

	inline function set_horizontalRatio( v ) {
		ratioChanged = true;
		return horizontalRatio = hxd.Math.clamp(v, 0, 1);
	}
	
	inline function set_verticalRatio( v ) {
		ratioChanged = true;
		return verticalRatio = hxd.Math.clamp(v, 0, 1);
	}

	inline function set_anchorX( v ) {
		anchorX = hxd.Math.clamp(v, 0, 1);
		anchorWidth = sceneWidth * anchorX;
		return anchorX;
	}

	inline function set_anchorY( v ) {
		anchorY = hxd.Math.clamp(v, 0, 1);
		anchorHeight = sceneHeight * anchorY;
		return anchorY;
	}

	override private function onAdd()
	{
		initScene();
		super.onAdd();
	}

	override private function onRemove()
	{
		this.scene = null;
		super.onRemove();
	}

	override private function calcAbsPos()
	{
		if ( scene == null ) {
			var cr, sr;
			if( rotation == 0 ) {
				cr = 1.; sr = 0.;
				camA = scaleX;
				camB = 0;
				camC = 0;
				camD = scaleY;
				camX = x - anchorWidth + anchorWidth * scaleX;
				camY = y - anchorHeight + anchorHeight * scaleY;
			} else {
				cr = Math.cos(rotation);
				sr = Math.sin(rotation);
				camA = scaleX * cr;
				camB = scaleX * sr;
				camC = scaleY * -sr;
				camD = scaleY * cr;
				camX = x - anchorWidth + (anchorWidth * camA + anchorHeight * camC);
				camY = y - anchorHeight + (anchorWidth * camB + anchorHeight * camD);
			}
		} else {
			if( rotation == 0 ) {
				camA = scaleX * scene.matA;
				camB = scaleX * scene.matB;
				camC = scaleY * scene.matC;
				camD = scaleY * scene.matD;

				var cx = x - anchorWidth + anchorWidth * scaleX;
				var cy = y - anchorHeight + anchorHeight * scaleY;
				camX = cx * scene.matA + cy * scene.matC + scene.absX;
				camY = cx * scene.matB + cy * scene.matD + scene.absY;
			} else {
				var cr = Math.cos(rotation);
				var sr = Math.sin(rotation);
				var tmpA = scaleX * cr;
				var tmpB = scaleX * sr;
				var tmpC = scaleY * -sr;
				var tmpD = scaleY * cr;
				camA = tmpA * scene.matA + tmpB * scene.matC;
				camB = tmpA * scene.matB + tmpB * scene.matD;
				camC = tmpC * scene.matA + tmpD * scene.matC;
				camD = tmpC * scene.matB + tmpD * scene.matD;

				var cx = x - anchorWidth + (anchorWidth * tmpA + anchorHeight * tmpC);
				var cy = y - anchorHeight + (anchorWidth * tmpB + anchorHeight * tmpD);
				camX = cx * scene.matA + cy * scene.matC + scene.absX;
				camY = cx * scene.matB + cy * scene.matD + scene.absY;
			}
		}
		invDet = 1 / (camA * camD - camB * camC);
	}

	override private function sync( ctx : RenderContext )
	{
		if ( scene != null && (ratioChanged || scene.width != sceneWidth || scene.height != sceneHeight) ) {
			var oldX = this.x + anchorWidth;
			var oldY = this.y + anchorHeight;
			this.sceneWidth = scene.width;
			this.sceneHeight = scene.height;
			this.width = Math.round(scene.width * horizontalRatio);
			this.height = Math.round(scene.height * verticalRatio);
			this.anchorWidth = width * anchorX;
			this.anchorHeight = height * anchorY;
			this.x = oldX - anchorWidth;
			this.y = oldY - anchorHeight;
			this.ratioChanged = false;
		}
		checkPosChanged();
		super.sync(ctx);

		if ( follow != null ) {
			var fx = follow.x - anchorWidth;
			var fy = follow.y - anchorHeight;
			viewX = fx * camA + fy * camC + anchorWidth;
			viewY = fx * camB + fy * camD + anchorHeight;
		}
	}

	override private function drawRec( ctx : RenderContext )
	{
		if ( !visible ) return;

		checkPosChanged();
		ctx.setCamera(this);
		super.drawRec(ctx);
		ctx.clearCamera();
	}

	override private function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool )
	{
		checkPosChanged();
		super.getBoundsRec(relativeTo, out, forSize);
	}

	override private function syncPos()
	{
		if ( parent != null ) parent.syncPos();
		checkPosChanged();
	}

	// Camera never triggers `posChanged` on children if it's `posChanged` is true.
	// Hence it have to intercept all cases `hxd.Object` would do that.
	inline function checkPosChanged() {
		if (posChanged) {
			calcAbsPos();
			posChanged = false;
		}
	}

	inline function initScene() {
		this.scene = parent.getScene();
		if ( scene != parent && !Std.is(parent, MultiCamera) ) throw "Camera can be added only to Scene or MultiCamera!";
		if ( sceneWidth == 0 )
		{
			sceneWidth = scene.width;
			sceneHeight = scene.height;
			anchorWidth = sceneWidth * anchorX;
			anchorHeight = sceneHeight * anchorY;
		}
	}

}