package h3d.parts;
import h3d.parts.Data;

class Emitter extends Particles implements Randomized {

	public var time(default,null) : Float;
	public var state(default, null) : State;
	public var speed : Float = 1.;
	public var collider : Collider;

	var rnd : Float;
	var emitCount : Float;
	var colorMap : ColorKey;
	var curPart : Particle;

	public function new(?state,?parent) {
		super(null, parent);
		time = 0;
		emitCount = 0;
		rnd = Math.random();
		if( state == null ) {
			state = new State();
			state.setDefaults();
			state.initFrames();
		}
		setState(state);
	}

	override function clear() {
		super.clear();
		time = 0;
		emitCount = 0;
		rnd = Math.random();
	}

	public function setState(s) {
		this.state = s;
		material.texture = s.frames == null || s.frames.length == 0 ? null : s.frames[0].getTexture();
		frames = s.frames;
		switch( s.blendMode ) {
		case Add:
			material.blendMode = Add;
		case SoftAdd:
			material.blendMode = SoftAdd;
		case Alpha:
			material.blendMode = Alpha;
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
		hasColor = colorMap != null || !state.alpha.match(VConst(1)) || !state.light.match(VConst(1));
		pshader.isAbsolute = !state.emitLocal;
		pshader.is3D = state.is3D;
		sortMode = state.sortMode;
		emitTrail = state.emitTrail;
	}

	inline function eval(v) {
		return Data.State.eval(v,time, this, curPart);
	}

	public function update(dt:Float) {
		var s = state;
		var old = time;
		if( posChanged ) syncPos();
		curPart = null;
		time += dt * eval(s.globalSpeed) / s.globalLife;
		var et = (time - old) * s.globalLife;
		if( time >= 1 && s.loop )
			time -= 1;
		if( time < 1 )
			emitCount += eval(s.emitRate) * et;
		for( b in s.bursts )
			if( b.time <= time && b.time > old )
				emitCount += b.count;
		if( emitCount > 0 && posChanged ) syncPos();
		while( emitCount > 0 ) {
			if( count < s.maxParts )
				initPart(emitParticle());
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

	public inline function rand() {
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
			p.z = eval(size);
			if( !state.emitFromShell ) p.z *= rand();
		case SSphere(r):
			var theta = rand() * Math.PI * 2;
			var phi = Math.acos(rand() * 2 - 1);
			var r = eval(r);
			if( !state.emitFromShell ) r *= rand();
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
		case SCone(r,angle):
			var theta = rand() * Math.PI * 2;
			var phi = eval(angle) * rand();
			var r = eval(r);
			if( !state.emitFromShell ) r *= rand();
			p.dx = Math.sin(phi) * Math.cos(theta);
			p.dy = Math.sin(phi) * Math.sin(theta);
			p.dz = Math.cos(phi);
			p.x = p.dx * r;
			p.y = p.dy * r;
			p.z = p.dz * r;
		case SDisc(r):
			var r = eval(r);
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
		p.lifeTimeFactor = 1 / eval(state.life);
	}

	function updateParticle( p : Particle, dt : Float ) {
		p.time += dt * p.lifeTimeFactor;
		if( p.time > 1 ) {
			kill(p);
			return;
		}
		p.randIndex = 0;

		// apply forces
		if( state.force != null ) {
			p.fx += p.eval(state.force.vx, time) * dt;
			p.fy += p.eval(state.force.vy, time) * dt;
			p.fz += p.eval(state.force.vz, time) * dt;
		}
		p.fz -= p.eval(state.gravity, time) * dt;
		// calc speed and update position
		var speed = p.eval(state.speed, p.time);
		var ds = speed * dt;
		p.x += p.dx * ds + p.fx * dt;
		p.y += p.dy * ds + p.fy * dt;
		p.z += p.dz * ds + p.fz * dt;
		p.size = p.eval(state.size, p.time);
		p.ratio = p.eval(state.ratio, p.time);
		p.rotation = p.eval(state.rotation, p.time);

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
		var light = p.eval(state.light, p.time);
		if( ck != null ) {
			if( ck.time >= p.time ) {
				p.r = ck.r;
				p.g = ck.g;
				p.b = ck.b;
			} else {
				var prev = ck;
				ck = ck.next;
				while( ck != null && ck.time < p.time ) {
					prev = ck;
					ck = ck.next;
				}
				if( ck == null ) {
					p.r = prev.r;
					p.g = prev.g;
					p.b = prev.b;
				} else {
					var b = (p.time - prev.time) / (ck.time - prev.time);
					var a = 1 - b;
					p.r = prev.r * a + ck.r * b;
					p.g = prev.g * a + ck.g * b;
					p.b = prev.b * a + ck.b * b;
				}
			}
			p.r *= light;
			p.g *= light;
			p.b *= light;
		} else {
			p.r = light;
			p.g = light;
			p.b = light;
		}
		p.a = p.eval(state.alpha, p.time);

		// frame
		if( state.frame != null ) {
			var f = p.eval(state.frame, p.time) % 1;
			if( f < 0 ) f += 1;
			p.frame = Std.int(f * state.frames.length);
		}

		if( state.update != null )
			state.update(p);
	}

	override function sync( ctx : h3d.scene.RenderContext ) {
		update(ctx.elapsedTime * speed);
	}

	public function isActive() {
		return count != 0 || time < 1 || state.loop;
	}

	override function draw( ctx : h3d.scene.RenderContext ) {
		globalSize = eval(state.globalSize) * 0.1;
		super.draw(ctx);
	}

}