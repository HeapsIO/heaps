package h3d.anim;
import h3d.anim.Animation;

class LinearFrame {
	public var tx : Float;
	public var ty : Float;
	public var tz : Float;
	public var qx : Float;
	public var qy : Float;
	public var qz : Float;
	public var qw : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public function new() {
	}
	public function toMatrix() {
		var m = new h3d.Matrix();
		new h3d.Quat(qx, qy, qz, qw).toMatrix(m);
		m.prependScale(sx, sy, sz);
		m.translate(tx, ty, tz);
		return m;
	}
}

class LinearObject extends AnimatedObject {
	public var hasPosition : Bool = true;
	public var hasRotation : Bool;
	public var hasScale : Bool;
	public var frames : haxe.ds.Vector<LinearFrame>;
	public var alphas : haxe.ds.Vector<Float>;
	public var uvs : haxe.ds.Vector<Float>;
	public var propName:  String;
	public var propValues : haxe.ds.Vector<Float>;
	public var matrix : h3d.Matrix;
	public var propCurrentValue : Float;
	override function clone() : AnimatedObject {
		var o = new LinearObject(objectName);
		o.hasPosition = hasPosition;
		o.hasRotation = hasRotation;
		o.hasScale = hasScale;
		o.frames = frames;
		o.alphas = alphas;
		o.uvs = uvs;
		o.propName = propName;
		o.propValues = propValues;
		return o;
	}
}

class LinearAnimation extends Animation {

	var syncFrame : Float;

	public function new(name,frame,sampling) {
		super(name,frame,sampling);
		syncFrame = -1;
	}

	public function addCurve( objName, frames, hasPos, hasRot, hasScale ) {
		var f = new LinearObject(objName);
		f.frames = frames;
		f.hasPosition = hasPos;
		f.hasRotation = hasRot;
		f.hasScale = hasScale;
		objects.push(f);
	}

	public function addAlphaCurve( objName, alphas ) {
		var f = new LinearObject(objName);
		f.alphas = alphas;
		objects.push(f);
	}

	public function addUVCurve( objName, uvs ) {
		var f = new LinearObject(objName);
		f.uvs = uvs;
		objects.push(f);
	}

	public function addPropCurve( objName, propName, values ) {
		var f = new LinearObject(objName);
		f.propName = propName;
		f.propValues = values;
		objects.push(f);
	}

	override function getPropValue( objName, propName ) : Null<Float> {
		for( o in getFrames() )
			if( o.objectName == objName && o.propName == propName )
				return o.propCurrentValue;
		return null;
	}

	inline function getFrames() : Array<LinearObject> {
		return cast objects;
	}

	override function clone(?a:Animation) {
		if( a == null )
			a = new LinearAnimation(name, frameCount, sampling);
		super.clone(a);
		return a;
	}

	override function endFrame() {
		return loop ? frameCount : frameCount - 1;
	}

	#if !(dataOnly || macro)

	override function initInstance() {
		super.initInstance();
		var frames = getFrames();
		for( a in frames ) {
			if( a.propValues != null ) {
				a.propCurrentValue = a.propValues[0];
				continue;
			}
			if( a.alphas != null && (a.targetObject == null || !a.targetObject.isMesh()) )
				throw a.objectName + " should be a mesh (for alpha animation)";
			if( a.uvs != null || a.alphas != null ) continue;
			a.matrix = new h3d.Matrix();
			a.matrix.identity();
		}
		// makes sure that all single frame anims are at the end so we can break early when isSync=true
		frames.sort(sortByFrameCountDesc);
	}

	function sortByFrameCountDesc( o1 : LinearObject, o2 : LinearObject ) {
		return (o2.frames == null ? 10 : o2.frames.length) - (o1.frames == null ? 10 : o1.frames.length);
	}

	inline function uvLerp( v1 : Float, v2 : Float, k : Float ) {
		v1 %= 1.;
		v2 %= 1.;
		if( v1 < v2 - 0.5 )
			v1 += 1;
		else if( v1 > v2 + 0.5 )
			v1 -= 1;
		return v1 * (1 - k) + v2 * k;
	}

	@:access(h3d.scene.Skin)
	@:noDebug
	override function sync( decompose = false ) {
		if( frame == syncFrame && !decompose )
			return;
		var frame1 = getIFrame();
		var frame2 = (frame1 + 1) % frameCount;
		var k2 = frame - frame1;
		var k1 = 1 - k2;
		if( frame1 < 0 ) frame1 = frame2 = 0 else if( frame >= frameCount ) frame1 = frame2 = frameCount - 1 else if( !loop && frame2 == 0 ) frame2 = frameCount - 1;
		syncFrame = frame;
		if( decompose ) isSync = false;
		for( o in getFrames() ) {

			if( o.targetObject == null && o.targetSkin == null ) continue;

			if( o.alphas != null ) {
				var mat = o.targetObject.toMesh().material;
				if( mat.blendMode == None ) mat.blendMode = Alpha;
				mat.color.w = o.alphas[frame1] * k1 + o.alphas[frame2] * k2;
				continue;
			}
			if( o.uvs != null ) {
				var mat = o.targetObject.toMesh().material;
				var s = mat.mainPass.getShader(h3d.shader.UVDelta);
				if( s == null ) {
					s = mat.mainPass.addShader(new h3d.shader.UVDelta());
					mat.texture.wrap = Repeat;
				}
				s.uvDelta.x = uvLerp(o.uvs[frame1 << 1],o.uvs[frame2 << 1],k2);
				s.uvDelta.y = uvLerp(o.uvs[(frame1 << 1) | 1],o.uvs[(frame2 << 1) | 1],k2);
				continue;
			}
			if( o.propValues != null ) {
				o.propCurrentValue = o.propValues[frame1] * k1 + o.propValues[frame2] * k2;
				continue;
			}

			var frame1 = frame1, frame2 = frame2;

			// if we have a single frame
			if( o.frames.length == 1 ) {
				if( isSync )
					break;
				frame1 = frame2 = 0;
			}

			var f1 = o.frames[frame1], f2 = o.frames[frame2];

			var m = o.matrix;

			m._41 = f1.tx * k1 + f2.tx * k2;
			m._42 = f1.ty * k1 + f2.ty * k2;
			m._43 = f1.tz * k1 + f2.tz * k2;

			if( o.hasRotation ) {
				// qlerp nearest
				var dot = f1.qx * f2.qx + f1.qy * f2.qy + f1.qz * f2.qz + f1.qw * f2.qw;
				var q2 = dot < 0 ? -k2 : k2;
				var qx = f1.qx * k1 + f2.qx * q2;
				var qy = f1.qy * k1 + f2.qy * q2;
				var qz = f1.qz * k1 + f2.qz * q2;
				var qw = f1.qw * k1 + f2.qw * q2;
				// make sure the resulting quaternion is normalized
				var ql = 1 / Math.sqrt(qx * qx + qy * qy + qz * qz + qw * qw);
				qx *= ql;
				qy *= ql;
				qz *= ql;
				qw *= ql;

				if( decompose ) {
					m._12 = qx;
					m._13 = qy;
					m._21 = qz;
					m._23 = qw;
					if( o.hasScale ) {
						m._11 = f1.sx * k1 + f2.sx * k2;
						m._22 = f1.sy * k1 + f2.sy * k2;
						m._33 = f1.sz * k1 + f2.sz * k2;
					} else {
						m._11 = 1;
						m._22 = 1;
						m._33 = 1;
					}
				} else {
					// quaternion to matrix
					var xx = qx * qx;
					var xy = qx * qy;
					var xz = qx * qz;
					var xw = qx * qw;
					var yy = qy * qy;
					var yz = qy * qz;
					var yw = qy * qw;
					var zz = qz * qz;
					var zw = qz * qw;
					m._11 = 1 - 2 * ( yy + zz );
					m._12 = 2 * ( xy + zw );
					m._13 = 2 * ( xz - yw );
					m._21 = 2 * ( xy - zw );
					m._22 = 1 - 2 * ( xx + zz );
					m._23 = 2 * ( yz + xw );
					m._31 = 2 * ( xz + yw );
					m._32 = 2 * ( yz - xw );
					m._33 = 1 - 2 * ( xx + yy );
					if( o.hasScale ) {
						var sx = f1.sx * k1 + f2.sx * k2;
						var sy = f1.sy * k1 + f2.sy * k2;
						var sz = f1.sz * k1 + f2.sz * k2;
						m._11 *= sx;
						m._12 *= sx;
						m._13 *= sx;
						m._21 *= sy;
						m._22 *= sy;
						m._23 *= sy;
						m._31 *= sz;
						m._32 *= sz;
						m._33 *= sz;
					}
				}

			} else {
				m._12 = 0;
				m._13 = 0;
				m._21 = 0;
				m._23 = decompose ? 1 : 0;

				if( o.hasScale ) {
					m._11 = f1.sx * k1 + f2.sx * k2;
					m._22 = f1.sy * k1 + f2.sy * k2;
					m._33 = f1.sz * k1 + f2.sz * k2;
				} else {
					m._11 = 1;
					m._22 = 1;
					m._33 = 1;
				}
			}

			if( o.targetSkin != null ) {
				o.targetSkin.currentRelPose[o.targetJoint] = o.matrix;
				o.targetSkin.jointsUpdated = true;
			} else
				o.targetObject.defaultTransform = o.matrix;
		}
		if( !decompose ) isSync = true;
	}
	#end

}