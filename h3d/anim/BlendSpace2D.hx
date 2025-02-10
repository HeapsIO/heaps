package h3d.anim;

/**
	Blends multiple animations points placed on a virtual 2d plane
**/
@:access(h3d.scene.Skin)
class BlendSpace2D extends h3d.anim.Animation {

	/**
		X Position of the blend point in the Blendspace
	**/
	public var x(default, set): Float = 0.0;

	/**
		Smooth factor for the X value position over time
	**/
	public var xSmooth: Float = 0.0;

	/**
		Y Position of the blend point in the BlendSpace
	**/
	public var y(default, set): Float = 0.0;

	/**
		Smooth factor for the Y value position over time
	**/
	public var ySmooth: Float = 0.0;

	/**
		If true, the speed of the blended animation will be scaled when
		the x/y points lies outside all of the blend space triangles,
		based on the distance of the point from the center of the graph (0,0)
		and the distance of the closest point inside of the graph to the center
	**/
	public var scaleSpeedOutsideOfBounds = false;

	var xSmoothed : Float = 0.0;
	var xVelocity : Float = 0.0;

	var ySmoothed : Float = 0.0;
	var yVelocity : Float = 0.0;

	var outsideSpeedScale : Float = 1.0;

	var points: Array<BlendSpace2DPoint>;
	var triangles : Array<Array<BlendSpace2DPoint>> = [];

	var currentTriangle : Int = -1;
	var weights : Array<Float> = [1.0,0.0,0.0];
	var animBlendLength = 1.0;

	var dirtyPos: Bool = true;

	var prevAnimEventBind : h3d.anim.Animation;

	var workQuat = new h3d.Quat();
	var blendQuats : Array<h3d.Quat> = [new h3d.Quat(), new h3d.Quat(), new h3d.Quat()];
	var defaultPoseQuat = new h3d.Quat();

	function set_x(v: Float) : Float {
		if (v != x)
			currentTriangle = -1;
		return x = v;
	}

	function set_y(v: Float) : Float {
		if (v != y)
			currentTriangle = -1;
		return y = v;
	}

	public function new(name:String, points: Array<BlendSpace2DPoint>) {
		super(name, 1, 1.0);
		this.points = points;
	}

	public function resetSmooth() {
		xSmoothed = x;
		ySmoothed = y;
		xVelocity = 0.0;
		yVelocity = 0.0;
	}

	override function sync(decompose:Bool = false) {
		updateCurrentTriangle();

		if (currentTriangle < 0)
			return;

		var triangle = triangles[currentTriangle];

		// Reset matrices to the default matrix
		for (object in getBlendSpaceObjects()) {
			for (i => _ in triangle) {
				object.matrices[i] = object.defaultMatrix;
			}
			object.touchedThisFrame = false;
		}

		for (ptIndex => point in triangle) {
			point.animation.isSync = false;
			point.animation.sync(true);

			// copy modified matrices references
			@:privateAccess
			for (object in point.objects) {
				object.matrices[ptIndex] = (if( object.targetSkin != null ) object.targetSkin.currentRelPose[object.targetJoint] else object.targetObject.defaultTransform) ?? object.matrices[ptIndex];
			}
		}

		for (object in getBlendSpaceObjects()) {
			var outMatrix = object.outMatrix;
			outMatrix.identity();

			var blendedRot = inline new h3d.Quat();

			var blendedPos = inline new h3d.Vector();
			var blendedScale = inline new h3d.Vector();

			var triangle = triangles[currentTriangle];
			var def = object.defaultMatrix;
			defaultPoseQuat.set(def._12, def._13, def._21, def._23);

			for (ptIndex => point in triangle) {
				var w =  weights[ptIndex];
				if (w == 0) {
					continue;
				}

				var matrix = object.matrices[ptIndex];

				if (matrix == null)
					continue;

				blendedPos.x += matrix.tx * w;
				blendedPos.y += matrix.ty * w;
				blendedPos.z += matrix.tz * w;

				blendedScale.x += matrix._11 * w;
				blendedScale.y += matrix._22 * w;
				blendedScale.z += matrix._33 * w;

				blendQuats[ptIndex].set(matrix._12, matrix._13, matrix._21, matrix._23);
			}

			workQuat.weightedBlend(blendQuats, weights, defaultPoseQuat);

			outMatrix.tx = blendedPos.x;
			outMatrix.ty = blendedPos.y;
			outMatrix.tz = blendedPos.z;

			outMatrix._11 = blendedScale.x;
			outMatrix._22 = blendedScale.y;
			outMatrix._33 = blendedScale.z;


			outMatrix._12 = workQuat.x;
			outMatrix._13 = workQuat.y;
			outMatrix._21 = workQuat.z;
			outMatrix._23 = workQuat.w;

			if (!decompose) {
				outMatrix.recomposeMatrix(outMatrix);
			}

			@:privateAccess if( object.targetSkin != null ) object.targetSkin.currentRelPose[object.targetJoint] = outMatrix else object.targetObject.defaultTransform = outMatrix;
		}
	}

	override function bind(object: h3d.scene.Object) {
		triangles = [];
		currentTriangle = -1;
		objects = [];

		resetSmooth();

		// only one animation is created per anim path, so if multiple points use the same anim, only one instance is created
		var animMap : Map<String, Int> = [];
		var allObjects : Map<String, BlendSpaceObject> = [];

		for (point in points) {

			if (!point.animation.isInstance) {
				point.animation = point.animation.createInstance(object);
			} else {
				point.animation.bind(object);
			}

			point.objects = [];
			for (animObject in point.animation.getObjects()) {
				var ourObject = allObjects.get(animObject.objectName);
				if (ourObject == null) {
					ourObject = new BlendSpaceObject(animObject.objectName);
					ourObject.targetJoint = animObject.targetJoint;
					ourObject.targetSkin = animObject.targetSkin;
					ourObject.targetObject = animObject.targetObject;

					if (ourObject.targetSkin != null) {
						ourObject.defaultMatrix.decomposeMatrix(ourObject.targetSkin.skinData.allJoints[ourObject.targetJoint].defMat);
					} else {
						ourObject.defaultMatrix.load(h3d.Matrix.IDENTITY_DECOMPOSED);
					}
					allObjects.set(animObject.objectName, ourObject);
					objects.push(ourObject);
				}

				point.objects.push(ourObject);
			}
		}

		triangulate();
	}

	override function unbind(objectName:String) {
		super.unbind(objectName);
		for (point in points) {
			point.animation.unbind(objectName);
		}
	}

	override function clone(?a:h3d.anim.Animation):h3d.anim.Animation {
		var a : BlendSpace2D = cast a;
		if (a == null) {
			a = new BlendSpace2D(name, null);
			a.xSmooth = xSmooth;
			a.ySmooth = ySmooth;
			a.scaleSpeedOutsideOfBounds = scaleSpeedOutsideOfBounds;
		}
		super.clone(a);

		a.points = [];
		a.points.resize(points.length);
		for (i => point in points) {
			a.points[i] = new BlendSpace2DPoint(point.x, point.y, point.animation?.clone(), point.keepSync);
		}
		return a;
	}

	override function update(dt:Float):Float {
		// bypass super.update frame ticking
		var speed = this.speed;
		this.speed = 0;
		var dt2 = super.update(dt);
		this.speed = speed;

		if (xSmooth > 0) {
			var r = simpleSpringDamper(xSmoothed, xVelocity, x, xSmooth, dt);
			xSmoothed = r.x;
			xVelocity = r.v;

			currentTriangle = -1;
		} else {
			xSmoothed = x;
		}

		if (ySmooth > 0) {
			var r = simpleSpringDamper(ySmoothed, yVelocity, y, ySmooth, dt);
			ySmoothed = r.x;
			yVelocity = r.v;

			currentTriangle = -1;
		} else {
			ySmoothed = y;
		}

		var scale = 1.0 / animBlendLength;
		if (scaleSpeedOutsideOfBounds)
		{
			scale *= outsideSpeedScale;
		}
		frame = (frame + dt * scale) % 1.0;

		updateCurrentTriangle();

		if (currentTriangle < 0)
			return dt2;

		var triangle = triangles[currentTriangle];

		// update points animations
		for (point in points) {
			var newTime = if (point.keepSync) {
				point.animation.getDuration() * frame;
			} else {
				point.animation.frame / (point.animation.speed * point.animation.sampling) + dt;
			}

			// Check if the anim info is in one of our triangle points, and if so
			// tick it normaly
			if (triangle.contains(point)) {
				var delta = newTime - point.animation.frame / (point.animation.speed * point.animation.sampling);
				point.animation.update(delta);
			} else {
				point.animation.setFrame(newTime * (point.animation.speed * point.animation.sampling));
			}
		}
		return dt2;
	}

	function triangulate() : Void {
		triangles = [];

		var xMin = hxd.Math.POSITIVE_INFINITY;
		var xMax = hxd.Math.NEGATIVE_INFINITY;
		var yMin = hxd.Math.POSITIVE_INFINITY;
		var yMax = hxd.Math.NEGATIVE_INFINITY;

		for (point in points) {
			xMin = hxd.Math.min(point.x, xMin);
			xMax = hxd.Math.max(point.x, xMax);
			yMin = hxd.Math.min(point.y, xMin);
			yMax = hxd.Math.max(point.y, yMax);
		}

		var h2dPoints : Array<h2d.col.Point> = [];
		for (point in points) {
			// normalize x / y in range 0/1 so the triangulation is done in a square
			// this avoid the triangulation failing to create triangles when one axis is far larger than the other

			var x = (point.x - xMin) / (xMax - xMin);
			var y = (point.y - yMin) / (yMax - yMin);

			h2dPoints.push(new h2d.col.Point(x, y));
		}

		var triangulation = h2d.col.Delaunay.triangulate(h2dPoints);
		if (triangulation == null) {
			throw "triangulation failed";
			return;
		}

		for (triTriangle in triangulation) {
			var triangle : Array<BlendSpace2DPoint> = [];
			triangle[0] = points[h2dPoints.indexOf(triTriangle.p1)];
			triangle[1] = points[h2dPoints.indexOf(triTriangle.p2)];
			triangle[2] = points[h2dPoints.indexOf(triTriangle.p3)];
			triangles.push(triangle);
		}
	}

	function updateCurrentTriangle() {
		if (triangles.length < 1)
			return;

		if (currentTriangle == -1) {
			var curPos = inline new h2d.col.Point(xSmoothed, ySmoothed);

			// find the triangle our curPos resides in
			var collided = false;
			for (triIndex => tri in triangles) {
				var colTri = inline new h2d.col.Triangle(inline new h2d.col.Point(tri[0].x, tri[0].y), inline new h2d.col.Point(tri[1].x, tri[1].y), inline new h2d.col.Point(tri[2].x, tri[2].y));
				if (inline colTri.contains(curPos)) {
					var bary = inline colTri.barycentric(curPos);
					currentTriangle = triIndex;
					weights[0] = bary.x;
					weights[1] = bary.y;
					weights[2] = bary.z;
					collided = true;
					break;
				}
			}

			if (currentTriangle == -1) {
				// We are outside all triangles, find the closest edge

				var closestDistanceSq : Float = hxd.Math.POSITIVE_INFINITY;
				var closestX : Float = 0.0;
				var closestY : Float = 0.0;

				for (triIndex => tri in triangles) {
					for (i in 0...3) {
						var i2 = (i+1) % 3;
						var p1 = tri[i];
						var p2 = tri[i2];

						var dx = p2.x - p1.x;
						var dy = p2.y - p1.y;
						var k = ((curPos.x - p1.x) * dx + (curPos.y - p1.y) * dy) / (dx * dx + dy * dy);
						k = hxd.Math.clamp(k, 0, 1);
						var mx = dx * k + p1.x - curPos.x;
						var my = dy * k + p1.y - curPos.y;
						var dist2SegmentSq = mx * mx + my * my;

						if (dist2SegmentSq < closestDistanceSq) {
							closestDistanceSq = dist2SegmentSq;
							currentTriangle = triIndex;
							closestX = mx;
							closestY = my;

							weights[i] = 1.0 - k;
							weights[(i + 1) % 3] = k;
							weights[(i + 2) % 3] = 0.0;
						}
					}
				}

				closestX += (curPos.x);
				closestY += (curPos.y);

				var distClosesetToCenter = hxd.Math.distance(closestX, closestY) + hxd.Math.EPSILON;
				var distToCenter = curPos.length() + hxd.Math.EPSILON;

				outsideSpeedScale = distToCenter / distClosesetToCenter;
			} else {
				outsideSpeedScale = 1.0;
			}

			if (currentTriangle == -1)
				throw "assert";

			var maxWeightIndex = 0;
			for (i in 1...3) {
				if (weights[i] > weights[maxWeightIndex]) {
					maxWeightIndex = i;
				}
			}

			var strongestAnim = triangles[currentTriangle][maxWeightIndex].animation;
			if (prevAnimEventBind != strongestAnim) {
				if (prevAnimEventBind != null)
					prevAnimEventBind.onEvent = null;
				if (strongestAnim != null)
					strongestAnim.onEvent = animEventHander;
				prevAnimEventBind = strongestAnim;
			}

			animBlendLength = 0.0;

			// Compensate for null animations that don't have length, or anim that are not kept in sync
			var nulls = 0;
			var nullWeights: Float = 0;
			for (i => point in triangles[currentTriangle]) {
				if (point.animation == null || !point.keepSync) {
					nulls ++;
					nullWeights += weights[i];
				}
			}

			if (nulls < 3) {
				nullWeights /= (3 - nulls);
			}

			for (i => point in triangles[currentTriangle]) {
				if(point.animation != null && point.keepSync) {
					var blendLength = point.animation.getDuration() * (weights[i] + nullWeights);
					animBlendLength += blendLength;
				}
			}
		}
	}

	function animEventHander(name: String) {
		if (onEvent != null)
			onEvent(name);
	}

	inline function getBlendSpaceObjects() : Array<BlendSpaceObject> {
		return cast objects;
	}

	// need to be inline so the double return value doesn't create an allocation
	/**
		x : the current value
		v : the current velocity of the value
		xGoal : the target value we want to reach
		vGoal : the target velocity we want to reach
		halfLife: the time in seconds that the x value will take to reach half the distance to xGoal
		dt : the delta time since the last call of this function
	**/
	inline static function criticalSpringDamper(x: Float, v: Float, xGoal: Float, vGoal: Float, halfLife: Float, dt: Float) : {x: Float, v: Float} {
		// Algorythm from https://theorangeduck.com/page/spring-roll-call#critical
		final damping = halfLifeToDamping(halfLife);
		final c = xGoal + (damping * vGoal) / (damping * damping ) / 4.0;
		final half_damping = damping / 2.0;
		final j0 = x - c;
		final j1 = v + j0 * half_damping;
		final eydt = fastNegexp(half_damping * dt);

		return {x: eydt * (j0 + j1 * dt) + c, v: eydt *(v - j1*half_damping*dt)};
	}

	/**
		Same as criticalSpringDamper but with vGoal = 0
	**/
	inline static function simpleSpringDamper(x: Float, v: Float, xGoal: Float,halfLife: Float, dt: Float) : {x: Float, v: Float} {
		// Algorythm from https://theorangeduck.com/page/spring-roll-call#critical
		final damping = halfLifeToDamping(halfLife);
		final half_damping = damping / 2.0;
		final j0 = x - xGoal;
		final j1 = v + j0 * half_damping;
		final eydt = fastNegexp(half_damping * dt);

		return {x: eydt * (j0 + j1 * dt) + xGoal, v: eydt *(v - j1*half_damping*dt)};
	}

	static inline function halfLifeToDamping(halfLife: Float) {
    	return (4.0 * 0.69314718056) / (halfLife + 1e-5);
	}

	static inline function fastNegexp(x: Float) : Float
	{
		return 1.0 / (1.0 + x + 0.48*x*x + 0.235*x*x*x);
	}

	static var tmpMatrix = new h3d.Matrix();
}

@:allow(h3d.anim.BlendSpace2D)
class BlendSpace2DPoint {
	// init info
	public var x: Float;
	public var y: Float;
	public var animation: h3d.anim.Animation;
	public var keepSync: Bool;

	// runtime info
	var objects: Array<BlendSpaceObject> = [];


	public function new(x: Float, y: Float, animation: h3d.anim.Animation, keepSync: Bool = true) {
		this.x = x;
		this.y = y;
		this.animation = animation;
		this.keepSync = keepSync;
	}
}

@:allow(h3d.anim.BlendSpace2D)
class BlendSpaceObject extends h3d.anim.Animation.AnimatedObject {
	public var matrices : Array<h3d.Matrix> = [];
	public var outMatrix = new h3d.Matrix();
	public var defaultMatrix = new h3d.Matrix();
	public var touchedThisFrame = false;

	override function clone() {
		return new BlendSpaceObject(objectName);
	}
}