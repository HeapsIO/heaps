package h3d.scene;

class CameraController extends h3d.scene.Object {

	public var distance(get, never) : Float;
	public var theta(get, never) : Float;
	public var phi(get, never) : Float;

	public var friction = 0.8;
	public var rotateSpeed = 1.;
	public var zoomAmount = 1.15;

	var scene : h3d.scene.Scene;
	var pushing = -1;
	var pushX = 0.;
	var pushY = 0.;
	var moveX = 0.;
	var moveY = 0.;
	var curPos = new h3d.Vector();
	var curOffset = new h3d.Vector();
	var targetPos = new h3d.Vector(10., Math.PI / 4, Math.PI * 5 / 13);
	var targetOffset = new h3d.Vector();

	public function new(?distance,?parent) {
		super(parent);
		set(distance);
		toTarget();
	}

	inline function get_distance() return curPos.x;
	inline function get_theta() return curPos.y;
	inline function get_phi() return curPos.z;

	public function set(?distance, ?theta, ?phi, ?offsetX, ?offsetY) {
		if( distance != null )
			targetPos.x = distance;
		if( theta != null )
			targetPos.y = theta;
		if( phi != null )
			targetPos.z = phi;
		if( offsetX != null )
			targetOffset.x = offsetX;
		if( offsetY != null )
			targetOffset.y = offsetY;
	}

	public function toTarget() {
		curPos.load(targetPos);
		curOffset.load(targetOffset);
	}

	override function onAlloc() {
		super.onAlloc();
		scene = getScene();
		scene.addEventListener(onEvent);
		targetPos.load(curPos);
		targetOffset.load(curOffset);
	}

	override function onDelete() {
		super.onDelete();
		scene.removeEventListener(onEvent);
		scene = null;
	}

	function onEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EWheel:
			targetPos.x *= Math.pow(zoomAmount, e.wheelDelta);
		case EPush:
			@:privateAccess scene.events.startDrag(onEvent, function() pushing = -1, e);
			pushing = e.button;
			pushX = e.relX;
			pushY = e.relY;
		case ERelease, EReleaseOutside:
			if( pushing == e.button ) {
				pushing = -1;
				@:privateAccess scene.events.stopDrag();
			}
		case EMove:
			switch( pushing ) {
			case 0:
				moveX += e.relX - pushX;
				moveY += e.relY - pushY;
				pushX = e.relX;
				pushY = e.relY;
			case 1:
				var v = new h3d.Vector( (e.relX - pushX) * 0.001 * distance, -(e.relY - pushY) * 0.001 * distance );
				scene.camera.update();
				v.transform3x3(scene.camera.getInverseView());
				targetOffset = targetOffset.add(v);
				pushX = e.relX;
				pushY = e.relY;
			default:
			}
		default:
		}
	}

	override function sync(ctx:RenderContext) {

		if( moveX != 0 ) {
			targetPos.y += moveX * 0.002 * rotateSpeed;
			moveX *= friction;
			if( Math.abs(moveX) < 1 ) moveX = 0;
		}

		if( moveY != 0 ) {
			targetPos.z -= moveY * 0.002 * rotateSpeed;
			var E = 1e-8;
			var bound = Math.PI - E;
			if( targetPos.z < E ) targetPos.z = E;
			if( targetPos.z > bound ) targetPos.z = bound;
			moveY *= friction;
			if( Math.abs(moveY) < 1 ) moveY = 0;
		}

		var dt = hxd.Math.min(1, 1 - Math.pow(0.9, ctx.elapsedTime * 60));
		var cam = scene.camera;
		curOffset.lerp(curOffset, targetOffset, dt);
		curPos.lerp(curPos, targetPos, dt );

		cam.target.load(curOffset);
		cam.pos.set( distance * Math.cos(theta) * Math.sin(phi) + cam.target.x, distance * Math.sin(theta) * Math.sin(phi) + cam.target.y, distance * Math.cos(phi) + cam.target.z );
		cam.zNear = distance * 0.01;
		cam.zFar = distance * 100;

		super.sync(ctx);
	}

}