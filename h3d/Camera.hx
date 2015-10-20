package h3d;

// use left-handed coordinate system, more suitable for 2D games X=0,Y=0 at screen top-left and Z towards user

class Camera {

	public var zoom : Float;

	/**
		The screenRatio represents the W/H screen ratio.
	 **/
	public var screenRatio : Float;

	/**
		The vertical FieldOfView, in degrees.
		Usually cameras are using an horizontal FOV, but the value will change depending on the screen ratio.
		For instance a 4:3 screen will have a lower horizontal FOV than a 16:9 one, however the vertical FOV remains constant.
		Use setFovX to initialize fovY based on an horizontal FOV and an initial screen ratio.
	**/
	public var fovY : Float;
	public var zNear : Float;
	public var zFar : Float;

	/**
		Set orthographic bounds.
	**/
	public var orthoBounds : h3d.col.Bounds;

	public var rightHanded : Bool;

	public var mproj : Matrix;
	public var mcam : Matrix;
	public var m : Matrix;

	public var pos : Vector;
	public var up : Vector;
	public var target : Vector;

	public var viewX : Float = 0.;
	public var viewY : Float = 0.;

	public var follow : { pos : h3d.scene.Object, target : h3d.scene.Object };

	var minv : Matrix;
	var needInv : Bool;

	public function new( fovY = 25., zoom = 1., screenRatio = 1.333333, zNear = 0.02, zFar = 4000., rightHanded = false ) {
		this.fovY = fovY;
		this.zoom = zoom;
		this.screenRatio = screenRatio;
		this.zNear = zNear;
		this.zFar = zFar;
		this.rightHanded = rightHanded;
		pos = new Vector(2, 3, 4);
		up = new Vector(0, 0, 1);
		target = new Vector(0, 0, 0);
		m = new Matrix();
		mcam = new Matrix();
		mproj = new Matrix();
		update();
	}

	/**
		Set the vertical fov based on a given horizontal fov (in degrees) for a specified screen ratio.
	**/
	public function setFovX( fovX : Float, withRatio : Float ) {
		var degToRad = Math.PI / 180;
		fovY = 2 * Math.atan( Math.tan(fovX * 0.5 * degToRad) / withRatio ) / degToRad;
	}

	/**
		Calculate the current horizontal fov (in degrees).
	**/
	public function getFovX() {
		var degToRad = Math.PI / 180;
		var halfFovX = Math.atan( Math.tan(fovY * 0.5 * degToRad) * screenRatio );
		var fovX = halfFovX * 2 / degToRad;
		return fovX;
	}

	public function clone() {
		var c = new Camera(fovY, zoom, screenRatio, zNear, zFar, rightHanded);
		c.pos = pos.clone();
		c.up = up.clone();
		c.target = target.clone();
		c.update();
		return c;
	}

	/**
		Returns the inverse of the camera matrix view and projection. Cache the result until the next update().
	**/
	public function getInverseViewProj() {
		if( minv == null ) minv = new h3d.Matrix();
		if( needInv ) {
			minv.inverse(m);
			needInv = false;
		}
		return minv;
	}

	/**
		Transforms a 2D screen position into the 3D one according to the current camera.
		The screenX and screenY values must be in the [-1,1] range.
		The camZ value represents the normalized z in the frustum in the [0,1] range.
		[unproject] can be used to get the ray from the camera position to a given screen position by using two different camZ values.
		For instance the 3D ray between unproject(0,0,0) and unproject(0,0,1) is the center axis of the 3D frustum.
	**/
	public function unproject( screenX : Float, screenY : Float, camZ ) {
		var p = new h3d.Vector(screenX, screenY, camZ);
		p.project(getInverseViewProj());
		return p;
	}

	public function update() {
		if( follow != null ) {
			pos.set(0, 0, 0);
			target.set(0, 0, 0);
			follow.pos.localToGlobal(pos);
			follow.target.localToGlobal(target);
			// Animate FOV
			if( follow.pos.name != null ) {
				var p = follow.pos;
				while( p != null ) {
					if( p.currentAnimation != null ) {
						var v = p.currentAnimation.getPropValue(follow.pos.name, "FOVY");
						if( v != null ) {
							fovY = v;
							break;
						}
					}
					p = p.parent;
				}
			}
		}
		makeCameraMatrix(mcam);
		makeFrustumMatrix(mproj);
		m.multiply(mcam, mproj);
		needInv = true;
	}

	public function lostUp() {
		var p2 = pos.clone();
		p2.normalize();
		return Math.abs(p2.dot3(up)) > 0.999;
	}

	public function movePosAxis( dx : Float, dy : Float, dz = 0. ) {
		var p = new Vector(dx, dy, dz);
		p.project(mcam);
		pos.x += p.x;
		pos.y += p.y;
		pos.z += p.z;
	}

	public function moveTargetAxis( dx : Float, dy : Float, dz = 0. ) {
		var p = new Vector(dx, dy, dz);
		p.project(mcam);
		target.x += p.x;
		target.y += p.y;
		target.z += p.z;
	}

	public function forward(speed = 1.) {
		var c = 1 - 0.025 * speed;
		pos.set(
			target.x + (pos.x - target.x) * c,
			target.y + (pos.y - target.y) * c,
			target.z + (pos.z - target.z) * c
		);
	}

	public function backward(speed = 1.) {
		var c = 1 + 0.025 * speed;
		pos.set(
			target.x + (pos.x - target.x) * c,
			target.y + (pos.y - target.y) * c,
			target.z + (pos.z - target.z) * c
		);
	}

	function makeCameraMatrix( m : Matrix ) {
		// in leftHanded the z axis is positive else it's negative
		// this way we make sure that our [ax,ay,-az] matrix follow the same handness as our world
		// We build a transposed version of Matrix.lookAt
		var az = rightHanded ? pos.sub(target) : target.sub(pos);
		az.normalize();
		var ax = up.cross(az);
		ax.normalize();
		if( ax.length() == 0 ) {
			ax.x = az.y;
			ax.y = az.z;
			ax.z = az.x;
		}
		var ay = az.cross(ax);
		m._11 = ax.x;
		m._12 = ay.x;
		m._13 = az.x;
		m._14 = 0;
		m._21 = ax.y;
		m._22 = ay.y;
		m._23 = az.y;
		m._24 = 0;
		m._31 = ax.z;
		m._32 = ay.z;
		m._33 = az.z;
		m._34 = 0;
		m._41 = -ax.dot3(pos);
		m._42 = -ay.dot3(pos);
		m._43 = -az.dot3(pos);
		m._44 = 1;
	}

	function makeFrustumMatrix( m : Matrix ) {
		m.zero();

		// this will take into account the aspect ratio and normalize the z value into [0,1] once it's been divided by w
		// Matrixes have to solve the following formulaes :
		//
		// transform P by Mproj and divide everything by
		//    [x,y,-zNear,1] => [sx/zNear, sy/zNear, 0, 1]
		//    [x,y,-zFar,1] => [sx/zFar, sy/zFar, 1, 1]

		// we apply the screen ratio to the height in order to have the fov being a horizontal FOV. This way we don't have to change the FOV when the screen is enlarged

		var bounds = orthoBounds;
		if( bounds != null ) {

			var w = 1 / (bounds.xMax - bounds.xMin);
			var h = 1 / (bounds.yMax - bounds.yMin);
			var d = 1 / (bounds.zMax - bounds.zMin);

			m._11 = 2 * w;
			m._22 = 2 * h;
			m._33 = d;
			m._41 = -(bounds.xMin + bounds.xMax) * w;
			m._42 = -(bounds.yMin + bounds.yMax) * h;
			m._43 = -bounds.zMin * d;
			m._44 = 1;

		} else {
			var degToRad = (Math.PI / 180);
			var halfFovX = Math.atan( Math.tan(fovY * 0.5 * degToRad) * screenRatio );
			var scale = zoom / Math.tan(halfFovX);
			m._11 = scale;
			m._22 = scale * screenRatio;
			m._33 = zFar / (zFar - zNear);
			m._34 = 1;
			m._43 = -(zNear * zFar) / (zFar - zNear);
		}

		m._11 += viewX * m._14;
		m._21 += viewX * m._24;
		m._31 += viewX * m._34;
		m._41 += viewX * m._44;

		m._12 += viewY * m._14;
		m._22 += viewY * m._24;
		m._32 += viewY * m._34;
		m._42 += viewY * m._44;

		// our z is negative in that case
		if( rightHanded ) {
			m._33 *= -1;
			m._34 *= -1;
		}
	}

}
