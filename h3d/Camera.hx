package h3d;

// use left-handed coordinate system, more suitable for 2D games X=0,Y=0 at screen top-left and Z towards user

class Camera {
	
	public var zoom : Float;
	public var ratio : Float;
	public var fov : Float;
	public var zNear : Float;
	public var zFar : Float;
	
	public var rightHanded : Bool;
	
	public var mproj : Matrix;
	public var mcam : Matrix;
	public var m : Matrix;
	
	public var pos : Vector;
	public var up : Vector;
	public var target : Vector;

	public function new( fov = 60., zoom = 1., ratio = 1.333333, zNear = 0.02, zFar = 4000., rightHanded = false ) {
		this.fov = fov;
		this.zoom = zoom;
		this.ratio = ratio;
		this.zNear = zNear;
		this.zFar = zFar;
		this.rightHanded = rightHanded;
		pos = new Vector(2, 3, 4);
		up = new Vector(0, 0, 1);
		target = new Vector(0, 0, 0);
		m = new Matrix();
		mcam = new Matrix();
		update();
	}
	
	public function clone() {
		var c = new Camera(fov, zoom, ratio, zNear, zFar, rightHanded);
		c.pos = pos.copy();
		c.up = up.copy();
		c.target = target.copy();
		c.update();
		return c;
	}

	public function update() {
		var az = pos.sub(target);
		az.normalize();
		var ax;
		if( rightHanded )
			ax = up.cross(az);
		else
			ax = az.cross(up);
		ax.normalize();
		if( ax.length() == 0 ) {
			ax.x = az.y;
			ax.y = az.z;
			ax.z = az.x;
		}
		var ay = az.cross(ax);
		if( rightHanded ) {
			mcam._11 = ax.x;
			mcam._12 = ay.x;
			mcam._13 = -az.x;
			mcam._14 = 0;
			mcam._21 = ax.y;
			mcam._22 = ay.y;
			mcam._23 = -az.y;
			mcam._24 = 0;
			mcam._31 = ax.z;
			mcam._32 = ay.z;
			mcam._33 = -az.z;
			mcam._34 = 0;
			mcam._41 = -ax.dot3(pos);
			mcam._42 = -ay.dot3(pos);
			mcam._43 = az.dot3(pos);
			mcam._44 = 1;
		} else {
			mcam._11 = ax.x;
			mcam._12 = ay.x;
			mcam._13 = az.x;
			mcam._14 = 0;
			mcam._21 = ax.y;
			mcam._22 = ay.y;
			mcam._23 = az.y;
			mcam._24 = 0;
			mcam._31 = ax.z;
			mcam._32 = ay.z;
			mcam._33 = az.z;
			mcam._34 = 0;
			mcam._41 = -ax.dot3(pos);
			mcam._42 = -ay.dot3(pos);
			mcam._43 = -az.dot3(pos);
			mcam._44 = 1;
		}
		mproj = makeFrustumMatrix();
		m.multiply(mcam, mproj);
	}
	
	public function lostUp() {
		var p2 = pos.copy();
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
	
	function makeFrustumMatrix() {
		var scale = zoom / Math.tan(fov * Math.PI / 360.0);
		var m = new Matrix();
		m.zero();
		if( rightHanded ) {
			m._11 = scale;
			m._22 = scale * ratio;
			m._33 = zFar / (zFar - zNear);
			m._34 = 1;
			m._43 = -(zNear * zFar) / (zFar - zNear);
		} else {
			m._11 = scale;
			m._22 = -scale * ratio;
			m._33 = zFar / (zNear - zFar);
			m._34 = -1;
			m._43 = (zNear * zFar) / (zNear - zFar);
		}
		return m;
	}
		
}
