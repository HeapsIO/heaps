package h2d;

class Camera extends h2d.Object {

	/** X position of the camera screen center point. **/
	public var centerX(get, set) : Float;
	/** Y position of the camera screen center point. **/
	public var centerY(get, set) : Float;

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	var halfWidth : Float;
	var halfHeight : Float;
	var scene : Scene;

	var camA : Float;
	var camB : Float;
	var camC : Float;
	var camD : Float;
	var camX : Float;
	var camY : Float;

	public function new( ?scene : h2d.Scene ) {
		super(scene);
		this.scene = scene;
		if ( scene != null ) {
			this.width = scene.width;
			this.height = scene.height;
			this.halfWidth = width * 0.5;
			this.halfHeight = height * 0.5;
		} else {
			this.width = 0; this.height = 0;
			this.halfWidth = 0; this.halfHeight = 0;
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

	override private function onAdd()
	{
		if ( !Std.is(parent, h2d.Scene) ) throw "Camera can be added only to h2d.Scene!";
		this.scene = cast parent;
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
		if ( scene.width != width || scene.height != height ) {
			// TODO: Anchor point
			var oldX = this.x + halfWidth;
			var oldY = this.y + halfHeight;
			this.width = scene.width;
			this.height = scene.height;
			this.halfWidth = width * 0.5;
			this.halfHeight = height * 0.5;
			this.x = oldX - halfWidth;
			this.y = oldY - halfHeight;
		}
		checkPosChanged();
		super.sync(ctx);
	}

	// Camera never triggers `posChanged` on children if it's `posChanged` is true.
	// Hence it have to intercept all cases `hxd.Object` would do that.
	inline function checkPosChanged() {
		if (posChanged) {
			calcAbsPos();
			posChanged = false;
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
}