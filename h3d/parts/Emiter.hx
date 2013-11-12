package h3d.parts;
import h3d.parts.Data;

class Emiter extends h3d.scene.Object {

	public var material : h3d.parts.Material;
	public var count(default, null) : Int;
	public var time(default,null) : Float;
	public var state(default, null) : State;
	public var pause : Bool;

	var rnd : Float;
	var emitCount : Float;
	var colorMap : ColorKey;
		
	var head : Particle;
	var tail : Particle;
	var pool : Particle;
	
	var tmpBuf : hxd.FloatBuffer;
	
	public function new(?state,?parent) {
		super(parent);
		material = new Material();
		time = 0;
		emitCount = 0;
		rnd = Math.random();
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
		material.texture = s.texture;
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
		time += dt * eval(s.globalSpeed, time, rnd) / s.globalLife;
		var et = (time - old) * s.globalLife;
		if( time >= 1 && s.loop )
			time -= 1;
		if( time < 1 )
			emitCount += eval(s.emitRate, time, rand()) * et;
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
			var phi = angle * Math.PI / 380;
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
		p.lifeTimeFactor = 1 / eval(state.life, time, rand());
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
		if( head == null ) {
			p.next = null;
			head = tail = p;
		} else {
			head.prev = p;
			p.next = head;
			head = p;
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
		var randIndex = 0;
		inline function rand() {
			randIndex++;
			return 0.;
		};
		
		// apply forces
		if( state.force != null ) {
			p.dx += eval(state.force.vx, time, rand()) * dt;
			p.dy += eval(state.force.vy, time, rand()) * dt;
			p.dz += eval(state.force.vz, time, rand()) * dt;
		}
		p.dz -= eval(state.gravity, time, rand()) * dt;
		// calc speed and update position
		var speed = eval(state.speed, p.time, rand());
		var ds = speed * dt;
		p.x += p.dx * ds;
		p.y += p.dy * ds;
		p.z += p.dz * ds;
		p.size = eval(state.size, p.time, rand());
		p.rotation = eval(state.rotation, p.time, rand());
		// calc color
		var ck = colorMap;
		var light = eval(state.light, p.time, rand());
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
		p.ca = eval(state.alpha, p.time, rand());
	}
	
	override function sync( ctx : h3d.scene.RenderContext ) {
		super.sync(ctx);
		if( !pause ) update(ctx.elapsedTime);
	}
	
	@:access(h3d.parts.Material)
	override function draw( ctx : h3d.scene.RenderContext ) {
		if( head == null )
			return;
		if( tmpBuf == null ) tmpBuf = new hxd.FloatBuffer();
		var pos = 0;
		var p = head;
		var tmp = tmpBuf;
		var hasColor = colorMap != null;
		var surface = 0.;
		while( p != null ) {
			tmp[pos++] = p.x;
			tmp[pos++] = p.y;
			tmp[pos++] = p.z;
			// UV
			tmp[pos++] = 0;
			tmp[pos++] = 0;
			tmp[pos++] = p.rotation;
			tmp[pos++] = p.size;
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
			if( hasColor ) {
				tmp[pos++] = p.cr;
				tmp[pos++] = p.cg;
				tmp[pos++] = p.cb;
				tmp[pos++] = p.ca;
			}
			
			p = p.next;
		}
		var stride = 7;
		if( hasColor ) stride += 4;
		var nverts = Std.int(pos / stride);
		var buffer = ctx.engine.mem.alloc(nverts, stride, 4);
		buffer.uploadVector(tmpBuf, 0, nverts);
		var size = eval(state.globalSize, time, rand());
		
		material.pshader.mpos = this.absPos;
		material.pshader.mproj = ctx.camera.m;
		material.pshader.partSize = new h3d.Vector(size, size * ctx.engine.width / ctx.engine.height);
		material.pshader.hasColor = colorMap != null;
		
		ctx.engine.selectMaterial(material);
		ctx.engine.renderQuadBuffer(buffer);
		buffer.dispose();
	}
	
}