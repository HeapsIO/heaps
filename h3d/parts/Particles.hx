package h3d.parts;

private class ParticleIterator {
	var p : Particle;
	public inline function new(p) {
		this.p = p;
	}
	public inline function hasNext() {
		return p != null;
	}
	public inline function next() {
		var v = p;
		p = p.next;
		return v;
	}
}

@:access(h3d.parts.Particle)
class Particles extends h3d.scene.Mesh {

	var pshader : h3d.shader.ParticleShader;
	public var frames : Array<h2d.Tile>;
	public var count(default, null) : Int = 0;
	public var hasColor(default, set) : Bool;
	public var sortMode : Data.SortMode;
	public var globalSize : Float = 1;
	public var emitTrail : Bool;

	var head : Particle;
	var tail : Particle;
	var pool : Particle;

	var tmp : h3d.Vector;
	var tmpBuf : hxd.FloatBuffer;

	public function new( ?texture, ?parent) {
		super(null, null, parent);
		material.props = material.getDefaultProps("particles3D");
		sortMode = Back;
		pshader = new h3d.shader.ParticleShader();
		pshader.isAbsolute = true;
		material.mainPass.addShader(pshader);
		material.mainPass.dynamicParameters = true;
		material.texture = texture;
		tmp = new h3d.Vector();
	}

	function set_hasColor(b) {
		var c = material.mainPass.getShader(h3d.shader.VertexColorAlpha);
		if( b ) {
			if( c == null )
				material.mainPass.addShader(new h3d.shader.VertexColorAlpha());
		} else {
			if( c != null )
				material.mainPass.removeShader(c);
		}
		return hasColor = b;
	}

	/**
		Offset all existing particles by the given values.
	**/
	public function offsetParticles( dx : Float, dy : Float, dz = 0. ) {
		var p = head;
		while( p != null ) {
			p.x += dx;
			p.y += dy;
			p.z += dz;
			p = p.next;
		}
	}

	public function clear() {
		while( head != null )
			kill(head);
	}

	public function alloc() {
		var p = emitParticle();
		if( posChanged ) syncPos();
		p.parts = this;
		p.x = absPos.tx;
		p.y = absPos.ty;
		p.z = absPos.tz;
		p.rotation = 0;
		p.ratio = 1;
		p.size = 1;
		p.r = p.g = p.b = p.a = 1;
		return p;
	}

	public function add(p) {
		emitParticle(p);
		return p;
	}

	function emitParticle( ?p ) {
		if( p == null ) {
			if( pool == null )
				p = new Particle();
			else {
				p = pool;
				pool = p.next;
			}
		}
		count++;
		switch( sortMode ) {
		case Front, Sort, InvSort:
			if( head == null ) {
				p.next = null;
				head = tail = p;
			} else {
				head.prev = p;
				p.next = head;
				head = p;
			}
		case Back:
			if( head == null ) {
				p.next = null;
				head = tail = p;
			} else {
				tail.next = p;
				p.prev = tail;
				p.next = null;
				tail = p;
			}
		}
		return p;
	}

	function kill(p:Particle) {
		if( p.prev == null ) head = p.next else p.prev.next = p.next;
		if( p.next == null ) tail = p.prev else p.next.prev = p.prev;
		p.prev = null;
		p.next = pool;
		pool = p;
		count--;
	}

	function sort( list : Particle ) {
		return haxe.ds.ListSort.sort(list, function(p1, p2) return p1.w < p2.w ? 1 : -1);
	}

	function sortInv( list : Particle ) {
		return haxe.ds.ListSort.sort(list, function(p1, p2) return p1.w < p2.w ? -1 : 1);
	}

	public inline function getParticles() {
		return new ParticleIterator(head);
	}

	@:access(h2d.Tile)
	@:noDebug
	override function draw( ctx : h3d.scene.RenderContext ) {
		if( head == null )
			return;
		switch( sortMode ) {
		case Sort, InvSort:
			var p = head;
			var m = ctx.camera.m;
			while( p != null ) {
				p.w = (p.x * m._13 + p.y * m._23 + p.z * m._33 + m._43) / (p.x * m._14 + p.y * m._24 + p.z * m._34 + m._44);
				p = p.next;
			}
			head = sortMode == Sort ? sort(head) : sortInv(head);
			tail = head.prev;
			head.prev = null;
		default:
		}
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var p = head;
		var tmp = tmpBuf;
		var surface = 0.;
		if( frames == null || frames.length == 0 ) {
			var t = material.texture == null ? h2d.Tile.fromColor(0xFF00FF) : h2d.Tile.fromTexture(material.texture);
			frames = [t];
		}
		material.texture = frames[0].getTexture();
		if( emitTrail ) {
			var prev = p;
			var prevX1 = p.x, prevY1 = p.y, prevZ1 = p.z;
			var prevX2 = p.x, prevY2 = p.y, prevZ2 = p.z;
			if( p != null ) p = p.next;
			while( p != null ) {
				var f = frames[p.frame];
				if( f == null ) f = frames[0];
				var ratio = p.size * p.ratio * (f.height / f.width);

				// pos
				tmp[pos++] = prevX1;
				tmp[pos++] = prevY1;
				tmp[pos++] = prevZ1;
				// normal
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				// delta
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				// UV
				tmp[pos++] = f.u;
				tmp[pos++] = f.v2;
				// RBGA
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				tmp[pos++] = prevX2;
				tmp[pos++] = prevY2;
				tmp[pos++] = prevZ2;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = f.u;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				var dx = p.x - prev.x;
				var dy = p.y - prev.y;
				var dz = p.z - prev.z;
				var d = hxd.Math.invSqrt(dx * dx + dy * dy + dz * dz);
				// this prevent big rotations from occuring while we have a very small offset
				// the value is a bit arbitrary
				if( d > 10 ) d = 10;
				dx *= d;
				dy *= d;
				dz *= d;
				var dir = new h3d.Vector(Math.sin(p.rotation), 0, Math.cos(p.rotation)).cross(new h3d.Vector(dx, dy, dz));

				prevX1 = p.x + dir.x * p.size;
				prevY1 = p.y + dir.y * p.size;
				prevZ1 = p.z + dir.z * p.size;

				prevX2 = p.x - dir.x * p.size;
				prevY2 = p.y - dir.y * p.size;
				prevZ2 = p.z - dir.z * p.size;

				tmp[pos++] = prevX1;
				tmp[pos++] = prevY1;
				tmp[pos++] = prevZ1;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v2;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				tmp[pos++] = prevX2;
				tmp[pos++] = prevY2;
				tmp[pos++] = prevZ2;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				prev = p;
				p = p.next;
			}
		} else {
			while( p != null ) {
				var f = frames[p.frame];
				if( f == null ) f = frames[0];
				var ratio = p.size * p.ratio * (f.height / f.width);
				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				// delta
				tmp[pos++] = -0.5;
				tmp[pos++] = -0.5;
				// UV
				tmp[pos++] = f.u;
				tmp[pos++] = f.v2;
				// RBGA
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = -0.5;
				tmp[pos++] = 0.5;
				tmp[pos++] = f.u;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = 0.5;
				tmp[pos++] = -0.5;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v2;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = p.rotation;
				tmp[pos++] = 0.5;
				tmp[pos++] = 0.5;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.r;
					tmp[pos++] = p.g;
					tmp[pos++] = p.b;
					tmp[pos++] = p.a;
				}

				p = p.next;
			}
		}
		var stride = 10;
		if( hasColor ) stride += 4;
		var buffer = h3d.Buffer.ofSubFloats(tmp, stride, Std.int(pos/stride), [Quads, Dynamic, RawFormat]);
		if( pshader.is3D )
			pshader.size.set(globalSize, globalSize);
		else
			pshader.size.set(globalSize * ctx.engine.height / ctx.engine.width * 4, globalSize * 4);
		ctx.uploadParams();
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}

}