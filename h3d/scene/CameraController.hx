package h3d.scene;

class CameraController extends h3d.scene.Object {

	public var distance(get, never) : Float;
	public var theta(get, never) : Float;
	public var phi(get, never) : Float;
	public var fovY(get, never) : Float;
	public var target(get, never) : h3d.col.Point;

	public var friction = 0.4;
	public var rotateSpeed = 1.;
	public var zoomAmount = 1.15;
	public var fovZoomAmount = 1.1;
	public var panSpeed = 1.;
	public var smooth = 0.6;

	public var lockZPlanes = false;

	var scene : h3d.scene.Scene;
	var pushing = -1;
	var pushX = 0.;
	var pushY = 0.;
	var pushStartX = 0.;
	var pushStartY = 0.;
	var moveX = 0.;
	var moveY = 0.;
	var pushTime : Float;
	var curPos = new h3d.Vector();
	var curOffset = new h3d.Vector();
	var targetPos = new h3d.Vector(10. / 25., Math.PI / 4, Math.PI * 5 / 13);
	var targetOffset = new h3d.Vector(0, 0, 0, 0);

	public function new(?distance,?parent) {
		super(parent);
		name = "CameraController";
		set(distance);
		flags.set(FNoSerialize,true);
		curPos.load(targetPos);
		curOffset.load(targetOffset);
	}

	inline function get_distance() return curPos.x / curOffset.w;
	inline function get_theta() return curPos.y;
	inline function get_phi() return curPos.z;
	inline function get_fovY() return curOffset.w;
	inline function get_target() return curOffset.toPoint();

	/**
		Set the controller parameters.
		Distance is ray distance from target.
		Theta and Phi are the two spherical angles
		Target is the target position
	**/
	public function set(?distance:Float, ?theta:Float, ?phi:Float, ?target:h3d.col.Point, ?fovY:Float) {
		if( theta != null )
			targetPos.y = theta;
		if( phi != null )
			targetPos.z = phi;
		if( target != null )
			targetOffset.set(target.x, target.y, target.z, targetOffset.w);
		if( fovY != null )
			targetOffset.w = fovY;
		if( distance != null )
			targetPos.x = distance * (targetOffset.w == 0 ? 1 : targetOffset.w);
	}

	/**
		Load current position from current camera position and target.
		Call if you want to modify manually the camera.
	**/
	public function loadFromCamera( animate = false ) {
		var scene = if( scene == null ) getScene() else scene;
		if( scene == null ) throw "Not in scene";
		targetOffset.load(scene.camera.target);
		targetOffset.w = scene.camera.fovY;

		var pos = scene.camera.pos.sub(scene.camera.target);
		var r = pos.length();
		targetPos.set(r, Math.atan2(pos.y, pos.x), Math.acos(pos.z / r));
		targetPos.x *= targetOffset.w;

		curOffset.w = scene.camera.fovY;

		if( !animate )
			toTarget();
		else
			syncCamera(); // reset camera to current
	}

	/**
		Initialize to look at the whole scene, based on reported scene bounds.
	**/
	public function initFromScene() {
		var scene = getScene();
		if( scene == null ) throw "Not in scene";
		var bounds = scene.getBounds();
		var center = bounds.getCenter();
		scene.camera.target.load(center.toVector());
		var d = bounds.getMax().sub(center);
		d.scale(5);
		d.z *= 0.5;
		d = d.add(center);
		scene.camera.pos.load(d.toVector());
		loadFromCamera();
	}

	/**
		Stop animation by directly moving to end position.
		Call after set() if you don't want to animate the change
	**/
	public function toTarget() {
		curPos.load(targetPos);
		curOffset.load(targetOffset);
		syncCamera();
	}

	override function onAdd() {
		super.onAdd();
		scene = getScene();
		scene.addEventListener(onEvent);
		if( curOffset.w == 0 )
			curPos.x *= scene.camera.fovY;
		curOffset.w = scene.camera.fovY; // load
		targetPos.load(curPos);
		targetOffset.load(curOffset);
	}

	override function onRemove() {
		super.onRemove();
		scene.removeEventListener(onEvent);
		scene = null;
	}

	public dynamic function onClick( e : hxd.Event ) {
	}

	function onEvent( e : hxd.Event ) {

		var p : Object = this;
		while( p != null ) {
			if( !p.visible ) {
				e.propagate = true;
				return;
			}
			p = p.parent;
		}

		switch( e.kind ) {
		case EWheel:
			if( hxd.Key.isDown(hxd.Key.CTRL) )
				fov(e.wheelDelta * fovZoomAmount * 2);
			else
				zoom(e.wheelDelta);
		case EPush:
			@:privateAccess scene.events.startCapture(onEvent, function() pushing = -1, e.touchId);
			pushing = e.button;
			pushTime = haxe.Timer.stamp();
			pushStartX = pushX = e.relX;
			pushStartY = pushY = e.relY;
		case ERelease, EReleaseOutside:
			if( pushing == e.button ) {
				pushing = -1;
				@:privateAccess scene.events.stopCapture();
				if( e.kind == ERelease && haxe.Timer.stamp() - pushTime < 0.2 && hxd.Math.distance(e.relX - pushStartX,e.relY - pushStartY) < 5 )
					onClick(e);
			}
		case EMove:
			switch( pushing ) {
			case 0:
				if( hxd.Key.isDown(hxd.Key.ALT) )
					zoom(-((e.relX - pushX) +  (e.relY - pushY)) * 0.03);
				else
					rot(e.relX - pushX, e.relY - pushY);
				pushX = e.relX;
				pushY = e.relY;
			case 1:
				var m = 0.001 * curPos.x * panSpeed / 25;
				pan(-(e.relX - pushX) * m, (e.relY - pushY) * m);
				pushX = e.relX;
				pushY = e.relY;
			case 2:
				rot(e.relX - pushX, e.relY - pushY);
				pushX = e.relX;
				pushY = e.relY;
			default:
			}
		default:
		}
	}

	function fov(delta) {
		targetOffset.w += delta;
		if( targetOffset.w >= 179 )
			targetOffset.w = 179;
		if( targetOffset.w < 1 )
			targetOffset.w = 1;
	}

	function zoom(delta) {
		targetPos.x *= Math.pow(zoomAmount, delta);
	}

	function rot(dx, dy) {
		moveX += dx;
		moveY += dy;
	}

	function pan(dx, dy) {
		var v = new h3d.Vector(dx, dy);
		scene.camera.update();
		v.transform3x3(scene.camera.getInverseView());
		v.w = 0;
		targetOffset = targetOffset.add(v);
	}

	function syncCamera() {
		var cam = getScene().camera;
		var distance = distance;
		cam.target.load(curOffset);
		cam.target.w = 1;
		cam.pos.set( distance * Math.cos(theta) * Math.sin(phi) + cam.target.x, distance * Math.sin(theta) * Math.sin(phi) + cam.target.y, distance * Math.cos(phi) + cam.target.z );
		if( !lockZPlanes ) {
			cam.zNear = distance * 0.01;
			cam.zFar = distance * 100;
		}
		cam.fovY = curOffset.w;
	}

	override function sync(ctx:RenderContext) {

		// Disable Camera Sync during bake
		if( ctx.scene.renderer.renderMode == LightProbe )
			return;

		if( !ctx.visibleFlag && !alwaysSync ) {
			super.sync(ctx);
			return;
		}

		if( moveX != 0 ) {
			targetPos.y += moveX * 0.003 * rotateSpeed;
			moveX *= 1 - friction;
			if( Math.abs(moveX) < 1 ) moveX = 0;
		}

		if( moveY != 0 ) {
			targetPos.z -= moveY * 0.003 * rotateSpeed;
			var E = 2e-5;
			var bound = Math.PI - E;
			if( targetPos.z < E ) targetPos.z = E;
			if( targetPos.z > bound ) targetPos.z = bound;
			moveY *= 1 - friction;
			if( Math.abs(moveY) < 1 ) moveY = 0;
		}

		var dt = hxd.Math.min(1, 1 - Math.pow(smooth, ctx.elapsedTime * 60));
		var cam = scene.camera;
		curOffset.lerp(curOffset, targetOffset, dt);
		curPos.lerp(curPos, targetPos, dt );

		syncCamera();

		super.sync(ctx);
	}

}
