package h3d.anim;
import hxd.Math.*;

private class SmoothObject extends Animation.AnimatedObject {
	public var tx : Float;
	public var ty : Float;
	public var tz : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public var q : h3d.Quat;
	public var tmpMatrix : h3d.Matrix;
	public function new(name) {
		super(name);
	}
}

class SmoothTarget extends Animation {

	@:s public var target : Animation;
	@:s public var blend : Float;
	@:s public var duration : Float;
	@:s public var ignoreTranslate = false;
	@:s public var easing : Float = 0.;

	public function new( target : h3d.anim.Animation, duration = 0.5 ) {
		super("SmoothTarget(" + target.name+")", target.frameCount, target.sampling);
		this.blend = 0;
		this.target = target;
		this.duration = duration;
		this.frame = target.frame;
		this.frameCount = target.frameCount;
		if( !target.isInstance )
			throw "Target should be instance";
		this.isInstance = true;
		initObjects();
	}

	function initObjects() {
		objects = [];
		for( o in target.getObjects() ) {
			var mat = null;
			var s = new SmoothObject(o.objectName);
			s.targetObject = o.targetObject;
			s.targetSkin = o.targetSkin;
			s.targetJoint = o.targetJoint;
			objects.push(s);
			if( o.targetSkin != null )
				mat = @:privateAccess o.targetSkin.currentRelPose[o.targetJoint];
			else if( o.targetObject != null )
				mat = o.targetObject.defaultTransform;
			if( mat == null )
				continue;
			s.tx = mat.tx;
			s.ty = mat.ty;
			s.tz = mat.tz;
			var sc = mat.getScale();
			s.sx = sc.x;
			s.sy = sc.y;
			s.sz = sc.z;
			s.q = new h3d.Quat();
			s.q.initRotateMatrix(mat);
			s.tmpMatrix = new h3d.Matrix();
		}
	}

	override function update(dt:Float) {
		if( !isPlaying() )
			return 0.;
		var rt = target.update(dt);
		var st = dt - rt;
		blend += st * speed / duration;
		frame = target.frame;
		if( blend > 1 ) {
			blend = 1;
			if( onAnimEnd != null ) onAnimEnd();
		}
		return rt;
	}

	override function setFrame(f) {
		target.setFrame(f);
		frame = target.frame;
	}

	override function getEvents() {
		return target.getEvents();
	}

	function getSmoothObjects() : Array<SmoothObject> {
		return cast objects;
	}


	var q1 : Quat = new h3d.Quat();
	var qout : Quat = new h3d.Quat();
	@:noDebug
	override function sync( decompose = false ) {
		if( decompose ) throw "assert";
		var objects = getSmoothObjects();
		target.sync(true);

		var bpow = Math.pow(blend, 1 + easing);
		var blend = bpow / (bpow + Math.pow(1 - blend, easing + 1));

		for( o in objects ) {
			var m = @:privateAccess if( o.targetSkin != null ) o.targetSkin.currentRelPose[o.targetJoint] else if( o.targetObject != null ) o.targetObject.defaultTransform else null;

			if( m == null ) continue;

			var mout = o.tmpMatrix;

			if( mout == null ) {

				// only recompose
				q1.set(m._12, m._13, m._21, m._23);
				var sx = m._11, sy = m._22, sz = m._33;
				var tx = m.tx, ty = m.ty, tz = m.tz;
				var m14 = m._14, m24 = m._24, m34 = m._34; // backup (used in BufferedAnimation)
				q1.toMatrix(m);
				m._11 *= sx;
				m._12 *= sx;
				m._13 *= sx;
				m._21 *= sy;
				m._22 *= sy;
				m._23 *= sy;
				m._31 *= sz;
				m._32 *= sz;
				m._33 *= sz;
				m._14 = m14;
				m._24 = m24;
				m._34 = m34;

				m.tx = tx;
				m.ty = ty;
				m.tz = tz;

			} else {

				q1.set(m._12, m._13, m._21, m._23);
				qout.lerp(o.q, q1, blend, true);
				qout.normalize();
				qout.toMatrix(mout);

				var sx = lerp(o.sx, m._11, blend);
				var sy = lerp(o.sy, m._22, blend);
				var sz = lerp(o.sz, m._33, blend);
				mout._11 *= sx;
				mout._12 *= sx;
				mout._13 *= sx;
				mout._21 *= sy;
				mout._22 *= sy;
				mout._23 *= sy;
				mout._31 *= sz;
				mout._32 *= sz;
				mout._33 *= sz;

				if( ignoreTranslate ) {
					mout.tx = m.tx;
					mout.ty = m.ty;
					mout.tz = m.tz;
				} else {
					mout.tx = lerp(o.tx, m.tx, blend);
					mout.ty = lerp(o.ty, m.ty, blend);
					mout.tz = lerp(o.tz, m.tz, blend);
				}

				@:privateAccess if( o.targetSkin != null ) o.targetSkin.currentRelPose[o.targetJoint] = mout else o.targetObject.defaultTransform = mout;
			}
		}
	}

	#if !(dataOnly || macro)
	override function initAndBind( obj : h3d.scene.Object ) {
		super.initAndBind(obj);
		target.initAndBind(obj);
		var old : Array<SmoothObject> = getSmoothObjects();
		initObjects();
		var index = 0;
		var objects = [for( o in getSmoothObjects() ) o.objectName => o];

		for( i in 0...old.length ) {
			var o = old[i];
			var n = objects.get(o.objectName);
			if( n == null )
				continue;
			n.tmpMatrix = new h3d.Matrix();
			n.q = new h3d.Quat();
			n.tx = o.tx;
			n.ty = o.ty;
			n.tz = o.tz;
			n.sx = o.sx;
			n.sy = o.sy;
			n.sz = o.sz;
			n.q.load(o.q);
		}
	}
	#end

	#if (hxbit && !macro)
	function customSerialize( ctx : hxbit.Serializer ) {
		var objects : Array<SmoothObject> = cast objects;
		var objects = [for( o in objects ) if( o.tmpMatrix != null ) o];
		ctx.addInt(objects.length);
		for( o in objects ) {
			ctx.addString(o.objectName);
			ctx.addFloat(o.tx);
			ctx.addFloat(o.ty);
			ctx.addFloat(o.tz);
			ctx.addFloat(o.sx);
			ctx.addFloat(o.sy);
			ctx.addFloat(o.sz);
			ctx.addFloat(o.q.x);
			ctx.addFloat(o.q.y);
			ctx.addFloat(o.q.z);
			ctx.addFloat(o.q.w);
		}
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		var count = ctx.getInt();
		var cur = 0;
		objects = [];
		for( i in 0...count ) {
			var o = new SmoothObject(ctx.getString());
			o.tx = ctx.getFloat();
			o.ty = ctx.getFloat();
			o.tz = ctx.getFloat();
			o.sx = ctx.getFloat();
			o.sy = ctx.getFloat();
			o.sz = ctx.getFloat();
			o.q = new h3d.Quat();
			o.q.x = ctx.getFloat();
			o.q.y = ctx.getFloat();
			o.q.z = ctx.getFloat();
			o.q.w = ctx.getFloat();
			objects.push(o);
		}
	}
	#end

}