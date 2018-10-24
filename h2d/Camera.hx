package h2d;

class Camera {

	public var x(default, set) : Float = 0;
	public var y(default, set) : Float = 0;
	public var scaleX(default, set) : Float = 1;
	public var scaleY(default, set) : Float = 1;
	public var rotation(default, set) : Float = 0;

	/** X position of the camera screen center point. **/
	public var centerX(get, set) : Float;
	/** Y position of the camera screen center point. **/
	public var centerY(get, set) : Float;

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	private var halfWidth : Float;
	private var halfHeight : Float;
	private var scene : Scene;
	private var posChanged : Bool;

	private var matA : Float;
	private var matB : Float;
	private var matC : Float;
	private var matD : Float;
	private var absX : Float;
	private var absY : Float;

	/** Should camera X/Y coordinates be rounded?
		Note: This only applies on matrix and does not reflect on x/y/centerX/centerY.
		**/
	public var pixelSnap : Bool;

	public function new(pixelSnap:Bool = true, scene:Scene) {
		halfWidth = halfHeight = height = width = 0;
		this.pixelSnap = pixelSnap;
		this.scene = scene;
	}

	inline function get_centerX() : Float {
		return this.x + halfWidth;
	}

	inline function get_centerY() : Float {
		return this.y + halfHeight;
	}

	inline function set_centerX(v : Float) : Float {
		return this.x = v - halfWidth;
	}

	inline function set_centerY(v : Float) : Float {
		return this.y = v - halfHeight;
	}

	inline function set_x(v : Float) : Float { posChanged = true; return x = v; }
	inline function set_y(v : Float) : Float { posChanged = true; return y = v; }
	inline function set_scaleX(v : Float) : Float { posChanged = true; return scaleX = v; }
	inline function set_scaleY(v : Float) : Float { posChanged = true; return scaleY = v; }
	inline function set_rotation(v : Float) : Float { posChanged = true; return rotation = v; }

	@:access(h2d.Scene)
	private function sync(ctx:RenderContext)
	{
		if (width != scene.width || height != scene.height) {
			var newX = this.x + halfWidth;
			var newY = this.y + halfHeight;
			this.width = scene.width;
			this.height = scene.height;
			this.halfWidth = width * 0.5;
			this.halfHeight = height * 0.5;
			this.x = newX - halfWidth;
			this.y = newY - halfHeight;
		}
		if (posChanged) {
			if( rotation == 0 ) {
				matA = scaleX * scene.matA;
				matB = scaleX * scene.matB;
				matC = scaleY * scene.matC;
				matD = scaleY * scene.matD;
			} else {
				var cr = Math.cos(rotation);
				var sr = Math.sin(rotation);
				var tmpA = scaleX * cr;
				var tmpB = scaleX * sr;
				var tmpC = scaleY * -sr;
				var tmpD = scaleY * cr;
				matA = tmpA * scene.matA + tmpB * scene.matC;
				matB = tmpA * scene.matB + tmpB * scene.matD;
				matC = tmpC * scene.matA + tmpD * scene.matC;
				matD = tmpC * scene.matB + tmpD * scene.matD;
			}
			absX = -x * scene.matA + -y * scene.matC + scene.absX;
			absY = -x * scene.matB + -y * scene.matD + scene.absY;
		}
	}

}