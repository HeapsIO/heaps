package hxd.snd;

class Listener {

	public var position : h3d.Vector;
	public var direction : h3d.Vector;
	public var velocity : h3d.Vector;
	public var up  : h3d.Vector;

	public function new() {
		position = new h3d.Vector();
		velocity = new h3d.Vector();
		direction = new h3d.Vector(1,  0, 0);
		up = new h3d.Vector(0,  0,  1);
	}

	public function syncCamera( cam : h3d.Camera ) {
		position.load(cam.pos);
		direction.set(cam.target.x - cam.pos.x, cam.target.y - cam.pos.y, cam.target.z - cam.pos.z);
		direction.normalize();
		up.load(cam.up);
	}

}
