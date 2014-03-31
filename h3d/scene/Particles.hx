package h3d.scene;

@:allow(h3d.scene.Particles)
class Particle {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var alpha : Float;
	public var group(default, null) : Particles;
	public var frame : Int;
	public var rotation : Float;
	public var size : Float;
	
	var prev : Particle;
	var next : Particle;
	
	function new(g) {
		x = 0; y = 0; z = 0; alpha = 1;
		rotation = 0.; size = 1.;
		this.group = g;
	}
	
	public inline function remove() {
		group.delete(this);
	}
	
}

class Particles extends Object {
	
	public var partSize : Float;
	public var frameCount : Int;
	public var hasRotation : Bool;
	public var hasSize : Bool;
	public var material : h3d.mat.PartMaterial;

	var first : Particle;
	var last : Particle;
	var tmpBuf : hxd.FloatBuffer;

	public function new( ?mat, ?parent ) {
		super(parent);
		partSize = 1.;
		frameCount = 1;
		if( mat == null ) mat = new h3d.mat.PartMaterial(null);
		this.material = mat;
	}
	
	public function add( p : Particle ) {
		p.group = this;
		if( first == null )
			first = last = p;
		else {
			last.next = p;
			p.prev = last;
			last = p;
		}
	}

	public function alloc() {
		var p = new Particle(this);
		if( first == null )
			first = last = p;
		else {
			last.next = p;
			p.prev = last;
			last = p;
		}
		return p;
	}
	
	@:allow(h3d.scene.Particle)
	function delete(p : Particle) {
		if( p.prev == null ) {
			if( first == p )
				first = p.next;
		} else
			p.prev.next = p.next;
		if( p.next == null ) {
			if( last == p )
				last = p.prev;
		} else
			p.next.prev = p.prev;
		// prevent multiple remove() from affecting chain
		p.prev = null;
		p.next = null;
	}
	
	@:access(h3d.mat.PartMaterial.setup)
	override function draw( ctx : RenderContext ) {
		if( first == null )
			return;
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var p = first;
		var tmp = tmpBuf;
		var hasFrame = frameCount > 1;
		var curFrame = 0.;
		while( p != null ) {
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 0.;
			tmp[pos++] = 0.;
			tmp[pos++] = p.alpha;
			if( hasFrame ) {
				curFrame = p.frame / frameCount;
				tmp[pos++] = curFrame;
			}
			if( hasRotation ) tmp[pos++] = p.rotation;
			if( hasSize ) tmp[pos++] = p.size;
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 0.;
			tmp[pos++] = 1.;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			if( hasRotation ) tmp[pos++] = p.rotation;
			if( hasSize ) tmp[pos++] = p.size;
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 1.;
			tmp[pos++] = 0.;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			if( hasRotation ) tmp[pos++] = p.rotation;
			if( hasSize ) tmp[pos++] = p.size;
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 1.;
			tmp[pos++] = 1.;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			if( hasRotation ) tmp[pos++] = p.rotation;
			if( hasSize ) tmp[pos++] = p.size;
			p = p.next;
		}
		var stride = 6;
		if( hasFrame ) stride++;
		if( hasRotation ) stride++;
		if( hasSize ) stride++;
		var buffer = h3d.Buffer.ofFloats(tmpBuf, stride, [Quads, Dynamic], Std.int(pos/stride));
		var size = partSize;
		ctx.localPos = this.absPos;
		material.setup(ctx);
		material.init(size, size * ctx.engine.width / ctx.engine.height, frameCount, hasRotation, hasSize);
		ctx.engine.selectMaterial(material);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
	public inline function isEmpty() {
		return first == null;
	}
	
	public function getParticles() {
		var a = [];
		var p = first;
		while( p != null ) {
			a.push(p);
			p = p.next;
		}
		return a;
	}
	
}
