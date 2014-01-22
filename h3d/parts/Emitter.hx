package h3d.parts;
import h3d.parts.Data;

class Emitter extends h3d.scene.Object {

	public var material : h3d.parts.Material;
	public var count(default, null) : Int;
	public var time(default,null) : Float;
	public var state(default, null) : State;
	public var speed : Float = 1.;
	public var collider : Collider;

	var rnd : Float;
	var emitCount : Float;
	var colorMap : ColorKey;
		
	var head : Particle;
	var tail : Particle;
	var pool : Particle;
	
	var tmp : h3d.Vector;
	var tmpBuf : hxd.FloatBuffer;
	var curPart : Particle;
	
	public function new(?state,?parent) {
		super(parent);
		material = new Material();
		time = 0;
		emitCount = 0;
		rnd = Math.random();
		tmp = new h3d.Vector();
		if( state == null ) {
			state = new State();
			state.setDefaults();
		}
		setState(state);
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
	
	public function reset() {
		while( head != null )
			kill(head);
		time = 0;
		emitCount = 0;
		rnd = Math.random();
	}
	
	public function setState(s) {
		this.state = s;
		material.texture = s.frames == null || s.frames.length == 0 ? null : s.frames[0].getTexture();
		switch( s.blendMode ) {
		case Add:
			material.blend(SrcAlpha, One);
		case SoftAdd:
			material.blend(OneMinusDstColor, One);
		case Alpha:
			material.blend(SrcAlpha, OneMinusSrcAlpha);
		}
		colorMap = null;
		if( s.colors != null ) {
			for( i in 0...s.colors.length ) {
				var c = s.colors[s.colors.length - (1 + i)];
				var k = new ColorKey(c.time, ((c.color>>16)&0xFF)/255, ((c.color>>8)&0xFF)/255, (c.color&0xFF)/255);
				k.next = colorMap;
				colorMap = k;
			}
		}
	}
	
	inline function eval(v,time,rnd) {
		return state.eval(v,time,rnd, curPart);
	}
	
	public function update(dt:Float) {
		var s = state;
		var old = time;
		if( posChanged ) syncPos();
		curPart = null;
		time += dt * eval(s.globalSpeed, time, rand) / s.globalLife;
		var et = (time - old) * s.globalLife;
		if( time >= 1 && s.loop )
			time -= 1;
		if( time < 1 )
			emitCount += eval(s.emitRate, time, rand) * et;
		for( b in s.bursts )
			if( b.time <= time && b.time > old )
				emitCount += b.count;
		while( emitCount > 0 ) {
			if( count < s.maxParts )
				emitParticle();
			emitCount -= 1;
			if( state.emitTrail )
				break;
		}
		var p = head;
		while( p != null ) {
			var n = p.next;
			curPart = p;
			updateParticle(p, et);
			p = n;
		}
		curPart = null;
	}
	
	inline function rand() {
		return Math.random();
	}
	
	function initPosDir( p : Particle ) {
		switch( state.shape ) {
		case SLine(size):
			p.dx = 0;
			p.dy = 0;
			p.dz = 1;
			p.x = 0;
			p.y = 0;
			p.z = eval(size, time, rand);
			if( !state.emitFromShell ) p.z *= rand();
		case SSphere(r):
			var theta = rand() * Math.PI * 2;
			var phi = Math.acos(rand() * 2 - 1);
			var r = eval(r, time, rand);
			if( !state.emitFromShell ) r *= rand();
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
		case SCone(r,angle):
			var theta = rand() * Math.PI * 2;
			var phi = eval(angle,time,rand) * rand();
			var r = eval(r, time, rand);
			if( !state.emitFromShell ) r *= rand();
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
		case SDisc(r):
			var r = eval(r, time, rand);
			if( !state.emitFromShell ) r *= rand();
			var a = rand() * Math.PI * 2;
			p.dx = Math.cos(a);
			p.dy = Math.sin(a);
			p.dz = 0;
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = 0;
		case SCustom(f):
			f(this,p);
		}
		if( state.randomDir ) {
			var theta = rand() * Math.PI * 2;
			var phi = Math.acos(rand() * 2 - 1);
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
		}
	}
	
	function initPart(p:Particle) {
		initPosDir(p);
		if( !state.emitLocal ) {
			var pos = new h3d.Vector(p.x, p.y, p.z);
			pos.transform3x4(absPos);
			p.x = pos.x;
			p.y = pos.y;
			p.z = pos.z;
			var v = new h3d.Vector(p.dx, p.dy, p.dz);
			v.transform3x3(absPos);
			p.dx = v.x;
			p.dy = v.y;
			p.dz = v.z;
		}
		p.fx = p.fy = p.fz = 0;
		p.time = 0;
		p.lifeTimeFactor = 1 / eval(state.life, time, rand);
	}
	
	public function emit() {
		if( posChanged ) syncPos();
		return emitParticle();
	}
	
	function emitParticle() {
		var p;
		if( pool == null )
			p = new Particle();
		else {
			p = pool;
			pool = p.next;
		}
		initPart(p);
		count++;
		switch( state.sortMode ) {
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
	
	function updateParticle( p : Particle, dt : Float ) {
		p.time += dt * p.lifeTimeFactor;
		if( p.time > 1 ) {
			kill(p);
			return;
		}
		p.randIndex = 0;
		var rand = p.getRand;
	
		// apply forces
		if( state.force != null ) {
			p.fx += eval(state.force.vx, time, rand) * dt;
			p.fy += eval(state.force.vy, time, rand) * dt;
			p.fz += eval(state.force.vz, time, rand) * dt;
		}
		p.fz -= eval(state.gravity, time, rand) * dt;
		// calc speed and update position
		var speed = eval(state.speed, p.time, rand);
		var ds = speed * dt;
		p.x += p.dx * ds + p.fx * dt;
		p.y += p.dy * ds + p.fy * dt;
		p.z += p.dz * ds + p.fz * dt;
		p.size = eval(state.size, p.time, rand);
		p.ratio = eval(state.ratio, p.time, rand);
		p.rotation = eval(state.rotation, p.time, rand);
		
		// collide
		if( state.collide && collider != null && collider.collidePart(p, tmp) ) {
			if( state.collideKill ) {
				kill(p);
				return;
			} else {
				var v = new h3d.Vector(p.dx, p.dy, p.dz).reflect(tmp);
				p.dx = v.x * state.bounce;
				p.dy = v.y * state.bounce;
				p.dz = v.z * state.bounce;
			}
		}
			
		
		// calc color
		var ck = colorMap;
		var light = eval(state.light, p.time, rand);
		if( ck != null ) {
			if( ck.time >= p.time ) {
				p.cr = ck.r;
				p.cg = ck.g;
				p.cb = ck.b;
			} else {
				var prev = ck;
				ck = ck.next;
				while( ck != null && ck.time < p.time ) {
					prev = ck;
					ck = ck.next;
				}
				if( ck == null ) {
					p.cr = prev.r;
					p.cg = prev.g;
					p.cb = prev.b;
				} else {
					var b = (p.time - prev.time) / (ck.time - prev.time);
					var a = 1 - b;
					p.cr = prev.r * a + ck.r * b;
					p.cg = prev.g * a + ck.g * b;
					p.cb = prev.b * a + ck.b * b;
				}
			}
			p.cr *= light;
			p.cg *= light;
			p.cb *= light;
		} else {
			p.cr = light;
			p.cg = light;
			p.cb = light;
		}
		p.ca = eval(state.alpha, p.time, rand);
		
		// frame
		if( state.frame != null ) {
			var f = eval(state.frame, p.time, rand) % 1;
			if( f < 0 ) f += 1;
			p.frame = Std.int(f * state.frames.length);
		}
		
		if( state.update != null )
			state.update(p);
	}
	
	override function sync( ctx : h3d.scene.RenderContext ) {
		super.sync(ctx);
		update(ctx.elapsedTime * speed);
	}
	
	public function isActive() {
		return count != 0 || time < 1 || state.loop;
	}
	
	function sort( list : Particle ) {
		return haxe.ds.ListSort.sort(list, function(p1, p2) return p1.w < p2.w ? 1 : -1);
	}

	function sortInv( list : Particle ) {
		return haxe.ds.ListSort.sort(list, function(p1, p2) return p1.w < p2.w ? -1 : 1);
	}
	
	@:access(h3d.parts.Material) @:access(h2d.Tile)
	override function draw( ctx : h3d.scene.RenderContext ) {
		if( head == null )
			return;
		switch( state.sortMode ) {
		case Sort, InvSort:
			var p = head;
			var m = ctx.camera.m;
			while( p != null ) {
				p.w = (p.x * m._13 + p.y * m._23 + p.z * m._33 + m._43) / (p.x * m._14 + p.y * m._24 + p.z * m._34 + m._44);
				p = p.next;
			}
			head = state.sortMode == Sort ? sort(head) : sortInv(head);
			tail = head.prev;
			head.prev = null;
		default:
		}
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var p = head;
		var tmp = tmpBuf;
		var hasColor = colorMap != null || !state.alpha.match(VConst(1)) || !state.light.match(VConst(1));
		var surface = 0.;
		var frames = state.frames;
		if( frames == null || frames.length == 0 ) {
			var t = new h2d.Tile(null, 0, 0, 1, 1);
			t.u = 0; t.u2 = 1;
			t.v = 0; t.v2 = 1;
			frames = [t];
		}
		if( state.emitTrail ) {
			var prev = p;
			var prevX1 = p.x, prevY1 = p.y, prevZ1 = p.z;
			var prevX2 = p.x, prevY2 = p.y, prevZ2 = p.z;
			if( p != null ) p = p.next;
			while( p != null ) {
				var f = frames[p.frame];
				if( f == null ) f = frames[0];
				var ratio = p.size * p.ratio * (f.height / f.width);
				
				tmp[pos++] = prevX1;
				tmp[pos++] = prevY1;
				tmp[pos++] = prevZ1;
				// delta
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				// UV
				tmp[pos++] = f.u;
				tmp[pos++] = f.v2;
				// RBGA
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}
				
				tmp[pos++] = prevX2;
				tmp[pos++] = prevY2;
				tmp[pos++] = prevZ2;
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
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
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v2;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}

				tmp[pos++] = prevX2;
				tmp[pos++] = prevY2;
				tmp[pos++] = prevZ2;
				tmp[pos++] = 0;
				tmp[pos++] = 0;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
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
				// delta
				tmp[pos++] = -0.5;
				tmp[pos++] = -0.5;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				// UV
				tmp[pos++] = f.u;
				tmp[pos++] = f.v2;
				// RBGA
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}
				
				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = -0.5;
				tmp[pos++] = 0.5;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}

				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = 0.5;
				tmp[pos++] = -0.5;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v2;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}

				tmp[pos++] = p.x;
				tmp[pos++] = p.y;
				tmp[pos++] = p.z;
				tmp[pos++] = 0.5;
				tmp[pos++] = 0.5;
				tmp[pos++] = p.rotation;
				tmp[pos++] = p.size;
				tmp[pos++] = ratio;
				tmp[pos++] = f.u2;
				tmp[pos++] = f.v;
				if( hasColor ) {
					tmp[pos++] = p.cr;
					tmp[pos++] = p.cg;
					tmp[pos++] = p.cb;
					tmp[pos++] = p.ca;
				}
				
				p = p.next;
			}
		}
		var stride = 10;
		if( hasColor ) stride += 4;
		var nverts = Std.int(pos / stride);
		var buffer = ctx.engine.mem.alloc(nverts, stride, 4);
		buffer.uploadVector(tmpBuf, 0, nverts);
		var size = eval(state.globalSize, time, rand);
		
		material.pshader.mpos = state.emitLocal ? this.absPos : h3d.Matrix.I();
		material.pshader.mproj = ctx.camera.m;
		if( state.is3D ) {
			material.pshader.is3D = true;
			material.pshader.partSize = new h3d.Vector(size, size);
		} else {
			material.pshader.is3D = false;
			material.pshader.partSize = new h3d.Vector(size, size * ctx.engine.width / ctx.engine.height);
		}
		material.pshader.hasColor = hasColor;
		material.pshader.isAlphaMap = state.isAlphaMap;
		
		ctx.engine.selectMaterial(material);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
}