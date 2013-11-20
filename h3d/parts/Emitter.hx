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
		return state.eval(v,time,rnd);
	}
	
	public function update(dt:Float) {
		var s = state;
		var old = time;
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
			if( count < s.maxParts ) {
				emit();
				count++;
			}
			emitCount -= 1;
		}
		var p = head;
		while( p != null ) {
			var n = p.next;
			updateParticle(p, et);
			p = n;
		}
	}
	
	inline function rand() {
		return Math.random();
	}
	
	function initPosDir( p : Particle ) {
		switch( state.shape ) {
		case SDir(x, y, z):
			p.x = 0;
			p.y = 0;
			p.z = 0;
			p.dx = x;
			p.dy = y;
			p.dz = z;
		case SSphere(r):
			var theta = rand() * Math.PI * 2;
			var phi = Math.acos(rand() * 2 - 1);
			var r = state.emitFromShell ? r : rand() * r;
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
		case SSector(r,angle):
			var theta = rand() * Math.PI * 2;
			var phi = angle;
			var r = state.emitFromShell ? r : rand() * r;
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
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
		p.time = 0;
		p.lifeTimeFactor = 1 / eval(state.life, time, rand);
	}
	
	public function emit() {
		var p;
		if( pool == null )
			p = new Particle();
		else {
			p = pool;
			pool = p.next;
		}
		initPart(p);
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
			p.dx += eval(state.force.vx, time, rand) * dt;
			p.dy += eval(state.force.vy, time, rand) * dt;
			p.dz += eval(state.force.vz, time, rand) * dt;
		}
		p.dz -= eval(state.gravity, time, rand) * dt;
		// calc speed and update position
		var speed = eval(state.speed, p.time, rand);
		var ds = speed * dt;
		p.x += p.dx * ds;
		p.y += p.dy * ds;
		p.z += p.dz * ds;
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
	}
	
	public function splitFrames() {
		var t = state.frames[0];
		var nw = Std.int(t.width / t.height);
		var nh = Std.int(t.height / t.width);
		if( nw > 1 ) {
			state.frames = [];
			for( i in 0...nw )
				state.frames.push(t.sub(i * t.height, 0, t.height, t.height));
		} else if( nh > 1 ) {
			state.frames = [];
			for( i in 0...nh )
				state.frames.push(t.sub(0, i * t.width, t.width, t.width));
		}
	}
	
	override function sync( ctx : h3d.scene.RenderContext ) {
		super.sync(ctx);
		update(ctx.elapsedTime * speed);
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
		while( p != null ) {
			var f = frames[p.frame];
			var ratio = p.size * p.ratio * (f.height / f.width);
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			// delta
			tmp[pos++] = 0;
			tmp[pos++] = 0;
			tmp[pos++] = p.rotation;
			tmp[pos++] = p.size;
			tmp[pos++] = ratio;
			// UV
			tmp[pos++] = f.u;
			tmp[pos++] = f.v;
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
			tmp[pos++] = 0;
			tmp[pos++] = 1;
			tmp[pos++] = p.rotation;
			tmp[pos++] = p.size;
			tmp[pos++] = ratio;
			tmp[pos++] = f.u;
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
			tmp[pos++] = 1;
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

			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			tmp[pos++] = 1;
			tmp[pos++] = 1;
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
			
			p = p.next;
		}
		var stride = 10;
		if( hasColor ) stride += 4;
		var nverts = Std.int(pos / stride);
		var buffer = ctx.engine.mem.alloc(nverts, stride, 4);
		buffer.uploadVector(tmpBuf, 0, nverts);
		var size = eval(state.globalSize, time, rand);
		
		material.pshader.mpos = this.absPos;
		material.pshader.mproj = ctx.camera.m;
		material.pshader.partSize = new h3d.Vector(size, size * ctx.engine.width / ctx.engine.height);
		material.pshader.hasColor = hasColor;
		
		ctx.engine.selectMaterial(material);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
}