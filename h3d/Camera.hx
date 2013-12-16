package h3d;
import hxd.Profiler;

// use left-handed coordinate system, more suitable for 2D games X=0,Y=0 at screen top-left and Z towards user

class Camera {
	
	public var zoom : Float;
	
	/**
		The screenRatio represents the W/H screen ratio.
	 **/
	public var screenRatio : Float;
	
	/**
		The horizontal FieldOfView, in degrees.
	**/
	public var fovX : Float;
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
	var minv : Matrix;
	var needInv : Bool;

	public function new( fovX = 60., zoom = 1., screenRatio = 1.333333, zNear = 0.02, zFar = 1000., rightHanded = false ) {
		this.fovX = fovX;
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
		Update the fovX value based on the requested fovY value (in degrees) and current screenRatio.
	**/
	public function setFovY( value : Float ) {
		fovX = Math.atan( Math.tan(value * Math.PI / 180) / screenRatio ) * 180 / Math.PI;
	}
	
	public function clone() {
		var c = new Camera(fovX, zoom, screenRatio, zNear, zFar, rightHanded);
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
		Profiler.begin("Camera.update");
		makeCameraMatrix(mcam);
		makeFrustumMatrix(mproj);
		m.multiply(mcam, mproj);
		needInv = true;
		Profiler.end("Camera.update");
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
	
	function makeCameraMatrix( m : Matrix ) {
		// in leftHanded the z axis is positive else it's negative
		// this way we make sure that our [ax,ay,-az] matrix follow the same handness as our world
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
		
			var scale = zoom / Math.tan(fovX * Math.PI / 360.0);
			m._11 = scale;
			m._22 = scale * screenRatio;
			m._33 = zFar / (zFar - zNear);
			m._34 = 1;
			m._43 = -(zNear * zFar) / (zFar - zNear);
			
		}
		
		// our z is negative in that case
		if( rightHanded ) {
			m._33 *= -1;
			m._34 *= -1;
		}
	}
		
}
