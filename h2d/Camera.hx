package h2d;

class Camera extends h2d.Object {

	/** X position of the camera screen center point. **/
	public var centerX(get, set) : Float;
	/** Y position of the camera screen center point. **/
	public var centerY(get, set) : Float;

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var horizontalRatio(default, set) : Float;
	public var verticalRatio(default, set) : Float;
	var ratioChanged : Bool;

	var halfWidth : Float;
	var halfHeight : Float;
	var scene : Scene;

	var camA : Float;
	var camB : Float;
	var camC : Float;
	var camD : Float;
	var camX : Float;
	var camY : Float;

	public function new( ?parent : h2d.Object, horizontalRatio : Float = 1, verticalRatio : Float = 1 ) {
		super(parent);
		this.horizontalRatio = horizontalRatio;
		this.verticalRatio = verticalRatio;
		this.width = 0; this.height = 0;
		this.halfWidth = 0; this.halfHeight = 0;
		ratioChanged = true;
		if ( parent != null ) {
			this.scene = parent.getScene();
			if (scene != parent && !Std.is(parent, MultiCamera)) throw "Camera can be added only to Scene or MultiCamera!";
		}
	}

	inline function get_centerX() { return this.x + halfWidth; }
	inline function get_centerY() { return this.y + halfHeight; }

	inline function set_centerX( v : Float ) {
		this.x = v - halfWidth;
		return v;
	}
	inline function set_centerY( v : Float ) {
		this.y = v - halfHeight;
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

	override private function onAdd()
	{
		this.scene = parent.getScene();
		if (parent != scene && !Std.is(parent, MultiCamera)) throw "Camera can be added only to Scene or MultiCamera!";
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
			} else {
				cr = Math.cos(rotation);
				sr = Math.sin(rotation);
				camA = scaleX * cr;
				camB = scaleX * sr;
				camC = scaleY * -sr;
				camD = scaleY * cr;
			}
			camX = x;
			camY = y;
		} else {
			if( rotation == 0 ) {
				camA = scaleX * scene.matA;
				camB = scaleX * scene.matB;
				camC = scaleY * scene.matC;
				camD = scaleY * scene.matD;
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
			}
			camX = -x * scene.matA + -y * scene.matC + scene.absX;
			camY = -x * scene.matB + -y * scene.matD + scene.absY;
		}
	}

	override private function sync( ctx : RenderContext )
	{
		if ( scene != null && (ratioChanged || scene.width != width || scene.height != height) ) {
			// TODO: Anchor point
			var oldX = this.x + halfWidth;
			var oldY = this.y + halfHeight;
			this.width = Math.round(scene.width * horizontalRatio);
			this.height = Math.round(scene.height * verticalRatio);
			this.halfWidth = width * 0.5;
			this.halfHeight = height * 0.5;
			this.x = oldX - halfWidth;
			this.y = oldY - halfHeight;
			this.ratioChanged = false;
		}
		checkPosChanged();
		super.sync(ctx);
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

}