package h3d.parts;
import hxd.Math;

enum GpuEmitMode {
	Point;
	Cone;
	VolumeBounds;
	ParentBounds;
}

enum GpuPartFlag {
}

class GpuParticles extends h3d.scene.Mesh {

	var needRebuild = true;
	var pshader : h3d.shader.GpuParticle;
	public var emitMode(default,set):GpuEmitMode= Point;
	public var emitDist(default, set) : Float	= 1.;
	public var emitAngle(default,set) : Float 	= Math.PI;
	public var seed(default, set) : Int			= Std.random(0x1000000);
	public var nparts(default, set) : Int 		= 100;
	public var size(default, set) : Float		= 1;
	public var sizeIncr(default, set) : Float	= 0;
	public var sizeRand(default, set) : Float	= 0;
	public var life(default, set) : Float		= 1;
	public var lifeRand(default, set) : Float	= 0;
	public var speed(default, set) : Float		= 1;
	public var speedRand(default, set) : Float	= 0;
	public var speedIncr : Float				= 0;

	public var rotInit(default, set) : Float	= 0;
	public var rotSpeed(default, set) : Float	= 0;
	public var rotSpeedRand(default, set):Float = 0;

	public var fadePower : Float				= 2;
	public var volumeBounds(default, set) : h3d.col.Bounds;
	public var partFlags(default, set) : haxe.EnumFlags<GpuPartFlag>;

	public function new( ?parent ) {
		super(null, null, parent);
		pshader = new h3d.shader.GpuParticle();
		material.mainPass.addShader(pshader);
		material.mainPass.culling = None;
		material.mainPass.depthWrite = false;
		material.blendMode = Alpha;
	}

	inline function set_seed(v) { needRebuild = true; return seed = v; }
	inline function set_size(v) { needRebuild = true; return size = v; }
	inline function set_sizeRand(v) { needRebuild = true; return sizeRand = v; }
	inline function set_sizeIncr(v) { needRebuild = true; return sizeIncr = v; }
	inline function set_speed(v) { needRebuild = true; return speed = v; }
	inline function set_speedRand(v) { needRebuild = true; return speedRand = v; }
	inline function set_life(v) { needRebuild = true; return life = v; }
	inline function set_lifeRand(v) { needRebuild = true; return lifeRand = v; }
	inline function set_nparts(n) { if( n > nparts ) needRebuild = true; return nparts = n; }
	inline function set_volumeBounds(v) { needRebuild = true; return volumeBounds = v; }
	inline function set_emitMode(v) { needRebuild = true; return emitMode = v; }
	inline function set_emitDist(v) { needRebuild = true; return emitDist = v; }
	inline function set_emitAngle(v) { needRebuild = true; return emitAngle = v; }
	inline function set_partFlags(v) { needRebuild = true; return partFlags = v; }
	inline function set_rotInit(v) { needRebuild = true; return rotInit = v; }
	inline function set_rotSpeed(v) { needRebuild = true; return rotSpeed = v; }
	inline function set_rotSpeedRand(v) { needRebuild = true; return rotSpeedRand = v; }

	override function sync(ctx) {
		super.sync(ctx);
		if( !needRebuild ) return;
		needRebuild = false;
		if( primitive != null ) {
			primitive.dispose();
			primitive = null;
		}
		var vbuf = new hxd.FloatBuffer();
		var uvs = [new h3d.prim.UV(0, 0), new h3d.prim.UV(1, 0), new h3d.prim.UV(0, 1), new h3d.prim.UV(1, 1)];
		var rnd = new hxd.Rand(seed);
		var ebounds = null;
		for( i in 0...nparts ) {

			inline function rand() return rnd.rand();
			inline function srand() return rnd.srand();

			var size = size * (1 + srand() * sizeRand), rot = srand() * Math.PI * rotInit;
			var vsize = sizeIncr, vrot = rotSpeed * (1 + rand() * rotSpeedRand) * (srand() < 0 ? -1 : 1);


			var life = life * (1 + srand() * lifeRand), time = rand() * life;

			var p = new h3d.col.Point();
			var v = new h3d.col.Point();

			switch( emitMode ) {
			case Point:

				v.x = rand();
				v.y = rand();
				v.z = rand();
				v.normalizeFast();

			case Cone:
				var theta = rand() * Math.PI * 2;
				var phi = emitAngle * rand();
				var r = emitDist * rand();
				v.x = Math.sin(phi) * Math.cos(theta);
				v.y = Math.sin(phi) * Math.sin(theta);
				v.z = Math.cos(phi);
				p.x = v.x * r;
				p.y = v.y * r;
				p.z = v.z * r;

			case ParentBounds, VolumeBounds:

				if( ebounds == null ) {
					if( emitMode == ParentBounds ) {
						ebounds = parent.getBounds();
						ebounds.transform3x4(getInvPos());
					} else {
						ebounds = volumeBounds;
						if( ebounds == null ) ebounds = h3d.col.Bounds.fromValues( -1, -1, -1, 2, 2, 2 );
					}
				}

				p.x = rand() * ebounds.xSize + ebounds.xMin;
				p.y = rand() * ebounds.ySize + ebounds.yMin;
				p.z = rand() * ebounds.zSize + ebounds.zMin;

				v.x = rand();
				v.y = rand();
				v.z = rand();
				v.normalizeFast();


			}


			var speed = speed * (1 + srand() * speedRand);

			v.x *= speed;
			v.y *= speed;
			v.z *= speed;

			inline function add(v) vbuf.push(v);
			for( u in uvs ) {
				add(p.x);
				add(p.y);
				add(p.z);

				add(v.x);
				add(v.y);
				add(v.z);

				add(u.u);
				add(u.v);
				add(time);
				add(life);

				add(rot);
				add(size);
				add(vrot);
				add(vsize);
			}
		}
		primitive = new h3d.prim.RawPrimitive( { vbuf : vbuf, stride : 14, quads : true }, true);
		primitive.buffer.flags.set(RawFormat);
	}

	override function draw( ctx : h3d.scene.RenderContext ) {
		pshader.speedIncr = speedIncr;
		pshader.fadePower = fadePower;
		@:privateAccess if( primitive.buffer == null || primitive.buffer.isDisposed() ) primitive.alloc(ctx.engine);
		@:privateAccess ctx.engine.renderQuadBuffer(primitive.buffer,0,nparts*2);
	}


}