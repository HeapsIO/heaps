package h3d.anim;
import h3d.anim.Animation;
import hxd.impl.Float32;

enum DataLayout {
	Position;
	Rotation;
	Scale;
	UV;
	Alpha;
	Property;
	SingleFrame;
}

class BufferObject extends AnimatedObject {

	public var layout : haxe.EnumFlags<DataLayout>;
	public var dataOffset : Int;
	public var propCurrentValue : Float;
	public var propName:  String;
	public var matrix : h3d.Matrix;

	public function new( objectName, dataOffset ) {
		super(objectName);
		this.dataOffset = dataOffset;
	}

	public function getStride() {
		var stride = 0;
		if( layout.has(Position) ) stride += 3;
		if( layout.has(Rotation) ) stride += 3;
		if( layout.has(Scale) ) stride += 3;
		if( layout.has(UV) ) stride += 2;
		if( layout.has(Alpha) ) stride += 1;
		if( layout.has(Property) ) stride += 1;
		return stride;
	}

	override function clone() : AnimatedObject {
		var o = new BufferObject(objectName, dataOffset);
		o.layout = layout;
		o.propName = propName;
		return o;
	}
}

class BufferAnimation extends Animation {

	var syncFrame : Float;
	var data : #if hl hl.BytesAccess<hl.F32> #else hxd.impl.TypedArray.Float32Array #end;
	var stride : Int;

	public function new(name,frame,sampling) {
		super(name,frame,sampling);
		syncFrame = -1;
	}

	public function setData( data, stride ) {
		this.data = data;
		this.stride = stride;
	}

	public function addObject( objName, offset ) {
		var f = new BufferObject(objName, offset);
		objects.push(f);
		return f;
	}

	override function getPropValue( objName, propName ) : Null<Float> {
		for( o in getFrames() )
			if( o.objectName == objName && o.propName == propName )
				return o.propCurrentValue;
		return null;
	}

	inline function getFrames() : Array<BufferObject> {
		return cast objects;
	}

	override function clone(?a:Animation) {
		if( a == null )
			a = new BufferAnimation(name, frameCount, sampling);
		super.clone(a);
		var la = hxd.impl.Api.downcast(a, BufferAnimation);
		la.setData(data, stride);
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
			if( a.layout.has(Property) )
				a.propCurrentValue = data[a.dataOffset];
			if( a.layout.has(Alpha) && (a.targetObject == null || !a.targetObject.isMesh()) )
				throw a.objectName + " should be a mesh (for alpha animation)";
			if( a.layout.has(Position) || a.layout.has(Rotation) || a.layout.has(Scale) ) {
				a.matrix = new h3d.Matrix();
				a.matrix.identity();
				// store default position in our matrix unused parts
				if( !a.layout.has(Position) && a.targetSkin != null ) {
					var m2 = a.targetSkin.getSkinData().allJoints[a.targetJoint].defMat;
					a.matrix._14 = m2._41;
					a.matrix._24 = m2._42;
					a.matrix._34 = m2._43;
				}
			}
		}
		// makes sure that all single frame anims are at the end so we can break early when isSync=true
		frames.sort(sortByFrameCountDesc);
	}

	function sortByFrameCountDesc( o1 : BufferObject, o2 : BufferObject ) {
		return (o2.layout.has(SingleFrame) ? 0 : 1) - (o1.layout.has(SingleFrame) ? 0 : 1);
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
		var k2 : Float32 = frame - frame1;
		var k1 : Float32 = 1 - k2;
		if( frame1 < 0 ) frame1 = frame2 = 0 else if( frame >= frameCount ) frame1 = frame2 = frameCount - 1 else if( !loop && frame2 == 0 ) frame2 = frameCount - 1;
		syncFrame = frame;
		if( decompose ) isSync = false;
		for( o in getFrames() ) {

			if( o.targetObject == null && o.targetSkin == null ) continue;

			var layout = o.layout;
			var offset1 = stride * frame1 + o.dataOffset;
			var offset2 = stride * frame2 + o.dataOffset;
			inline function lerpValue() {
				return data[offset1++] * k1 + data[offset2++] * k2;
			}

			var frame1 = frame1, frame2 = frame2;

			// if we have a single frame
			if( layout.has(SingleFrame) ) {
				if( isSync )
					break;
				frame1 = frame2 = 0;
				offset1 = offset2 = o.dataOffset;
			}

			var m = o.matrix;
			if( m != null ) {

				if( layout.has(Position) ) {
					m._41 = lerpValue();
					m._42 = lerpValue();
					m._43 = lerpValue();
				} else {
					m._41 = m._14;
					m._42 = m._24;
					m._43 = m._34;
				}

				if( layout.has(Rotation) ) {
					var q1x : Float32 = data[offset1++];
					var q1y : Float32 = data[offset1++];
					var q1z : Float32 = data[offset1++];
					var q1w : Float32 = Math.sqrt(hxd.Math.abs(1 - (q1x*q1x+q1y*q1y+q1z*q1z)));
					var q2x : Float32 = data[offset2++];
					var q2y : Float32 = data[offset2++];
					var q2z : Float32 = data[offset2++];
					var q2w : Float32 = Math.sqrt(hxd.Math.abs(1 - (q2x*q2x+q2y*q2y+q2z*q2z)));

					// qlerp nearest
					var dot = q1x * q2x + q1y * q2y + q1z * q2z + q1w * q2w;
					var q2 = dot < 0 ? -k2 : k2;
					var qx = q1x * k1 + q2x * q2;
					var qy = q1y * k1 + q2y * q2;
					var qz = q1z * k1 + q2z * q2;
					var qw = q1w * k1 + q2w * q2;
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
						if( layout.has(Scale) ) {
							m._11 = lerpValue();
							m._22 = lerpValue();
							m._33 = lerpValue();
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
						if( layout.has(Scale) ) {
							var sx = lerpValue();
							var sy = lerpValue();
							var sz = lerpValue();
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

					if( layout.has(Scale) ) {
						m._11 = lerpValue();
						m._22 = lerpValue();
						m._33 = lerpValue();
					} else {
						m._11 = 1;
						m._22 = 1;
						m._33 = 1;
					}
				}

				if( o.targetSkin != null ) {
					o.targetSkin.currentRelPose[o.targetJoint] = m;
					o.targetSkin.jointsUpdated = true;
				} else
					o.targetObject.defaultTransform = m;
			}

			if( layout.has(UV) ) {
				var mat = o.targetObject.toMesh().material;
				var s = mat.mainPass.getShader(h3d.shader.UVDelta);
				if( s == null ) {
					s = mat.mainPass.addShader(new h3d.shader.UVDelta());
					mat.texture.wrap = Repeat;
				}
				s.uvDelta.x = uvLerp(data[offset1++],data[offset2++],k2);
				s.uvDelta.y = uvLerp(data[offset1++],data[offset2++],k2);
			}
			if( layout.has(Alpha) ) {
				var mat = o.targetObject.toMesh().material;
				if( mat.blendMode == None ) mat.blendMode = Alpha;
				mat.color.w = lerpValue();
			}
			if( layout.has(Property) )
				o.propCurrentValue = lerpValue();
		}
		if( !decompose ) isSync = true;
	}
	#end

}