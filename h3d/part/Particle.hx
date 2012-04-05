package h3d.part;

class ParticleVertex {
	public var dx : Float;
	public var dy : Float;
	public var u : Float;
	public var v : Float;
	public var next : ParticleVertex;
	public function new(dx, dy, u, v) {
		this.dx = dx;
		this.dy = dy;
		this.u = u;
		this.v = v;
	}
}

class Particle {
	
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var light : Float;
	
	public var verts : ParticleVertex;
	
	public function new(x, y, z,l) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.light = l;
	}
	
	public function initQuad( width : Float, height : Float ) {
		var w = width * 0.5, h = height * 0.5;
		addVertex(new ParticleVertex( -w, -h, 0, 1));
		addVertex(new ParticleVertex( w, -h, 1, 1));
		addVertex(new ParticleVertex( -w, h, 0, 0));
		addVertex(new ParticleVertex( w, h, 1, 0));
	}
	
	public function addVertex( v : ParticleVertex ) {
		v.next = verts;
		verts = v;
	}
	
}