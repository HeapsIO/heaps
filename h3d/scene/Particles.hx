package h3d.scene;

@:allow(h3d.scene.Particles)
class Particle {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var alpha : Float;
	public var group(default, null) : Particles;
	public var frame : Int;
	
	var prev : Particle;
	var next : Particle;
	
	function new(g) {
		x = 0; y = 0; z = 0; alpha = 1;
		this.group = g;
	}
	
	public inline function remove() {
		group.delete(this);
	}
	
}

class Particles extends Object {
	
	public var partSize : Float;
	public var frameCount : Int;
	public var material : h3d.mat.PartMaterial;

	var first : Particle;
	var last : Particle;
	var tmpBuf : flash.Vector<Float>;

	public function new( ?mat, ?parent ) {
		super(parent);
		partSize = 1.;
		frameCount = 1;
		if( mat == null ) mat = new h3d.mat.PartMaterial(null);
		this.material = mat;
	}
	
	override public function free() {
		if (material != null) material.free();
		super.free();
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
	}
	
	@:access(h3d.mat.PartMaterial.setup)
	override function draw( ctx : RenderContext ) {
		if( first == null )
			return;
		if( tmpBuf == null ) tmpBuf = new flash.Vector();
		var pos = 0;
		var p = first;
		var tmp = tmpBuf;
		var hasFrame = frameCount > 1;
		var curFrame = 0.;
		while( p != null ) {
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 0;
			tmp[pos++] = 0;
			tmp[pos++] = p.alpha;
			if( hasFrame ) {
				curFrame = p.frame / frameCount;
				tmp[pos++] = curFrame;
			}
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 0;
			tmp[pos++] = 1;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 1;
			tmp[pos++] = 0;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 1;
			tmp[pos++] = 1;
			tmp[pos++] = p.alpha;
			if( hasFrame ) tmp[pos++] = curFrame;
			p = p.next;
		}
		var stride = 6;
		if( hasFrame ) stride++;
		var buffer = ctx.engine.mem.allocVector(tmpBuf, stride, 4);
		var size = partSize;
		material.setup(this.absPos, ctx.camera.m, size, size * ctx.engine.width / ctx.engine.height, frameCount);
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
