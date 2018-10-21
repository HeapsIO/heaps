package h3d.anim;

class SmoothedObject extends Animation.AnimatedObject {
	public var tmpMatrix : h3d.Matrix;
	public var outMatrix : h3d.Matrix;
	public var isAnim1 : Bool;
	public var isAnim2 : Bool;
	public var def : h3d.Matrix;
	public function new(name) {
		super(name);
		outMatrix = h3d.Matrix.I();
	}
}

class SmoothTransition extends Transition {

	static var MZERO = h3d.Matrix.L([
		1, 0, 0, 0,
		0, 1, 1, 0,
		0, 0, 1, 0,
		0, 0, 0, 1,
	]);

	public var blendFactor : Float;
	var tspeed : Float;

	public function new(current, target, speed) {
		super("smooth", current, target);
		blendFactor = 0.;
		this.tspeed = speed;
		if( !anim1.isInstance || !anim2.isInstance )
			throw "Both animations must be instances";
		this.isInstance = true;
		initObjects();
	}

	function initObjects() {
		var allObjects = new Map();
		var mzero = MZERO;
		for( o in anim1.objects ) {
			var so = new SmoothedObject(o.objectName);
			so.targetJoint = o.targetJoint;
			so.targetSkin = o.targetSkin;
			so.targetObject = o.targetObject;
			allObjects.set(o.objectName, so);
			objects.push(so);
			so.isAnim1 = true;
		}
		for( o in anim2.objects ) {
			var so = allObjects.get(o.objectName);
			if( so == null ) {
				so = new SmoothedObject(o.objectName);
				so.targetJoint = o.targetJoint;
				so.targetSkin = o.targetSkin;
				so.targetObject = o.targetObject;
				allObjects.set(o.objectName, so);
				objects.push(so);
			}
			so.isAnim2 = true;
		}
		for( so in allObjects ) {
			if( so.isAnim1 && so.isAnim2 )
				continue;
			if( so.targetSkin != null ) {
				var j = @:privateAccess so.targetSkin.skinData.allJoints[so.targetJoint];
				var q = new h3d.Quat();
				q.initRotateMatrix(j.defMat);
				q.normalize();
				so.def = j.defMat.clone();
				// todo : extract default scale from matrix
				so.def._11 = 1;
				so.def._22 = 1;
				so.def._33 = 1;
				so.def._12 = q.x;
				so.def._13 = q.y;
				so.def._21 = q.z;
				so.def._23 = q.w;
			} else
				so.def = mzero;
			if( !so.isAnim1 )
				so.tmpMatrix = so.def;
		}
	}

	override function bind( base ) {
		super.bind(base);
		this.objects = [];
		initObjects();
	}

	@:access(h3d.scene.Skin)
	override function sync( decompose = false ) {
		if( decompose ) throw "assert";
		var objects : Array<SmoothedObject> = cast objects;
		anim1.sync(true);
		for( o in objects ) {
			if( !o.isAnim1 )
				continue;
			o.tmpMatrix = if( o.targetSkin != null ) o.targetSkin.currentRelPose[o.targetJoint] else o.targetObject.defaultTransform;
		}
		anim2.sync(true);
		var a = 1 - blendFactor, b = blendFactor;
		var q1 = new h3d.Quat(), q2 = new h3d.Quat(), qout = new h3d.Quat();
		for( o in objects ) {
			var m1 = o.tmpMatrix;
			var m2 = if( !o.isAnim2 ) o.def else if( o.targetSkin != null ) o.targetSkin.currentRelPose[o.targetJoint] else o.targetObject.defaultTransform;
			var m = o.outMatrix;
			// interpolate rotation
			q1.set(m1._12, m1._13, m1._21, m1._23);
			q2.set(m2._12, m2._13, m2._21, m2._23);
			// shortest path
			qout.lerp(q1, q2, a, true);
			qout.normalize();
			qout.toMatrix(m);
			// interpolate scale
			var sx = m1._11 * a + m2._11 * b;
			var sy = m1._22 * a + m2._22 * b;
			var sz = m1._33 * a + m2._33 * b;
			m._11 *= sx;
			m._12 *= sx;
			m._13 *= sx;
			m._21 *= sy;
			m._22 *= sy;
			m._23 *= sy;
			m._31 *= sz;
			m._32 *= sz;
			m._33 *= sz;
			// interpolate translation
			m._41 = m1._41 * a + m2._41 * b;
			m._42 = m1._42 * a + m2._42 * b;
			m._43 = m1._43 * a + m2._43 * b;
			// save matrix
			if( o.targetSkin != null ) o.targetSkin.currentRelPose[o.targetJoint] = m else o.targetObject.defaultTransform = m;
		}
	}

	override function update( dt : Float ) : Float {
		var rt = super.update(dt);
		var st = dt - rt;
		blendFactor += st * tspeed;
		if( blendFactor >= 1 ) {
			blendFactor = 1;
			onAnimEnd();
		}
		return rt;
	}

}