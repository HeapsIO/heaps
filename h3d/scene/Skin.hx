package h3d.scene;

import haxe.Timer;
import h3d.anim.Skin.DynamicJoint;

class Joint extends Object {
	public var skin : Skin;
	public var index : Int;

	public function new(skin, j : h3d.anim.Skin.Joint ) {
		super(null);
		name = j.name;
		this.skin = skin;
		// fake parent
		this.parent = skin;
		this.index = j.index;
	}

	override function getObjectByName(name:String) {
		var sk = skin.getSkinData();
		var j = sk.namedJoints.get(name);
		if( j == null )
			return null;
		var cur = sk.allJoints[index];
		if( cur.index != index ) throw "assert";
		var jp = j.parent;
		while( jp != null ) {
			if( jp == cur ) {
				var jo = new Joint(skin, j);
				jo.parent = this;
				return jo;
			}
			jp = jp.parent;
		}
		return null;
	}

	@:access(h3d.scene.Skin)
	override function syncPos() {
		skin.getAbsPos();
		skin.syncJoints();
		absPos.load(skin.jointsData[index].currentAbsPos);
	}

}

@:access(h3d.scene.Skin)
class JointData {
	public var currentRelPos : h3d.Matrix;
	public var currentAbsPos : h3d.Matrix;
	public var additivePose : h3d.Matrix;

	public function new() {
		this.currentAbsPos = h3d.Matrix.I();
	}

	public function sync(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint, syncDyn : Bool) {
		if ( j.follow != null ) return;
		var m = currentAbsPos;
		var r = currentRelPos;
		var bid = j.bindIndex;
		if( r == null )
			r = j.defMat
		else if( j.retargetAnim && skin.enableRetargeting ) {
			h3d.scene.Skin.TMP_MAT.load(r);
			r = h3d.scene.Skin.TMP_MAT;
			r._41 = j.defMat._41;
			r._42 = j.defMat._42;
			r._43 = j.defMat._43;
		}
		if( j.parent == null )
			m.multiply3x4inline(r, skin.absPos);
		else
			m.multiply3x4inline(r, skin.jointsData[j.parent.index].currentAbsPos);
		if( additivePose != null )
			m.multiply3x4inline(additivePose, m);
		if( bid >= 0 )
			skin.currentPalette[bid].multiply3x4inline(j.transPos, m);
	}
}

@:access(h3d.scene.Skin)
class DynamicJointData extends JointData {
	static var tmpVec = new Vector(0, 0, 0);
	static var tmpVec2 = new Vector(0, 0, 0);
	static var tmpQ = new Quat();

	public var curTargetWorld : h3d.Matrix;
	var curTargetLocal : h3d.Matrix;
	var prevTargetLocal : h3d.Matrix;
	var speed : h3d.Vector;
	var parentQuat : h3d.Quat;
	var prevParentQuat : h3d.Quat;

	public function new() {
		super();
	}

	public function initData() {
		curTargetWorld = currentAbsPos.clone();
		curTargetLocal = h3d.Matrix.I();
		prevTargetLocal = h3d.Matrix.I();
		speed = new h3d.Vector();
		parentQuat = new h3d.Quat();
		prevParentQuat = new h3d.Quat();
	}

	override function sync(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint, syncDyn : Bool) {
		super.sync(skin, j, syncDyn);
		if (curTargetWorld == null)
			initData();

		var jParentData : JointData = Std.downcast(skin.jointsData[j.parent.index], JointData);
		if (syncDyn) {
			// Compute position of the current joint
			updateJoint(skin, j);

			// Orient parent to make him lookat his children
			updateParentRotation(skin, j);
		}

		var alpha = hxd.Math.clamp(skin.accumulator / Skin.FIXED_DT);

		// Scale and rotation lerping is not needed for current joint since it only translate
		Skin.TMP_MAT.load(curTargetLocal);
		Skin.TMP_MAT._41 = hxd.Math.lerp(prevTargetLocal._41, curTargetLocal._41, alpha);
		Skin.TMP_MAT._42 = hxd.Math.lerp(prevTargetLocal._42, curTargetLocal._42, alpha);
		Skin.TMP_MAT._43 = hxd.Math.lerp(prevTargetLocal._43, curTargetLocal._43, alpha);
		currentAbsPos.multiply3x4(Skin.TMP_MAT, jParentData.currentAbsPos);

		if( j.bindIndex >= 0 )
			skin.currentPalette[j.bindIndex].multiply3x4inline(j.transPos, currentAbsPos);

		if (j.parent.follow == null) {
			tmpQ.slerp(prevParentQuat, parentQuat, alpha);
			tmpQ.toMatrix(Skin.TMP_MAT);
			jParentData.currentAbsPos.multiply(Skin.TMP_MAT, jParentData.currentAbsPos);
			if (j.parent.bindIndex >= 0)
				skin.currentPalette[j.parent.bindIndex].multiply3x4inline(j.parent.transPos, jParentData.currentAbsPos);
		}

		if (speed.length() != 0.)
			skin.forceJointsUpdateOnFrame = hxd.Timer.frameCount + 1;
	}

	function updateJoint(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		var j : DynamicJoint = cast j;
		if (curTargetWorld == null) {
			curTargetWorld = new h3d.Matrix();
			curTargetWorld.load(currentAbsPos);
		}

		var prevPos = curTargetWorld.getPosition();
		var nextPos = prevPos.clone();

		var jParent = skin.jointsData[j.parent.index];
		var jParentMat = Std.downcast(jParent, DynamicJointData)?.curTargetWorld ?? jParent.currentAbsPos;

		// Resistance (force resistance)
		speed.load(speed + j.globalForce * (1.0 - j.resistance));

		// Damping (inertia attenuation)
		speed *= 1.0 - j.damping;

		if (speed.lengthSq() > DynamicJoint.SLEEP_THRESHOLD)
			nextPos = nextPos + speed * Skin.FIXED_DT;

		if (speed.lengthSq() > DynamicJoint.MAX_THRESHOLD)
			speed.set(0, 0, 0);

		// Stiffness (shape keeper)
		var stiffAbsPos = Skin.TMP_MAT;
		stiffAbsPos.multiply(j.defMat, jParentMat);
		var stiffPos = stiffAbsPos.getPosition();
		nextPos.lerp(nextPos, stiffPos, j.stiffness);

		// Slackness (length keeper)
		var dirToParent = (nextPos - jParentMat.getPosition()).normalized();
		var lengthToParent = j.defMat.getPosition().length();
		var scale = jParentMat.getScale(); //! Non uniform scale won't work
		var slackPos = jParentMat.getPosition() + (dirToParent * lengthToParent * scale.x);
		nextPos.lerp(slackPos, nextPos, j.slackness);

		// Apply lock axis
		jParentMat.getInverse(stiffAbsPos);
		nextPos.transform(stiffAbsPos);
		var curPos = currentAbsPos.getPosition();
		curPos.transform(stiffAbsPos);
		if (j.lockAxis.x > 0.0)
			nextPos.x = curPos.x;
		if (j.lockAxis.y > 0.0)
			nextPos.y = curPos.y;
		if (j.lockAxis.z > 0.0)
			nextPos.z = curPos.z;
		nextPos.transform(jParentMat);

		// Apply computed position to joint
		speed.load((speed + (nextPos - prevPos) * (1.0 / Skin.FIXED_DT)) * 0.5);
		currentAbsPos.setPosition(nextPos);
		curTargetWorld.load(currentAbsPos);

		prevTargetLocal.load(curTargetLocal);
		jParentMat.getInverse(Skin.TMP_MAT);
		curTargetLocal.multiply3x4(currentAbsPos, Skin.TMP_MAT);
	}

	function updateParentRotation(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		var jParent = j.parent;
		if (jParent.follow != null)
			return;

		prevParentQuat.load(parentQuat);

		if (jParent.subs.length == 1) {
			var jParentData = skin.jointsData[jParent.index];
			tmpVec.load(j.defMat.getPosition().normalized());
			var tmpMat = Skin.TMP_MAT;
			jParentData.currentAbsPos.getInverse(tmpMat);
			tmpMat.multiply(curTargetWorld, tmpMat);
			tmpVec2.load(tmpMat.getPosition().normalized());
			parentQuat.initMoveTo(tmpVec, tmpVec2);
		} else {
			parentQuat.identity();
		}
	}
}

class Skin extends MultiMaterial {
	public static var FIXED_DT = 1. / 60.;
	public static var MIN_SHADER_BONES = 32;
	public final MAX_SHADER_BONES = 256;
	public var accumulator = FIXED_DT;

	var skinData : h3d.anim.Skin;
	var jointsData : Array<JointData>; // Runtime data

	var currentPalette : Array<h3d.Matrix>;
	var jointsBuffer : h3d.Buffer;
	var prevJointsBuffer : h3d.Buffer;

	var splitPalette : Array<Array<h3d.Matrix>>;
	var splitBuffers : Array<h3d.Buffer>;
	var prevSplitBuffers : Array<h3d.Buffer>;

	var forceJointsUpdateOnFrame : Int = -1;
	var buffersDirty = true;
	var jointsFrame : Int = -1;
	var jointsUpdated : Bool;
	var skinShader : h3d.shader.SkinBase;
	var jointsGraphics : Graphics;

	public var showJoints : Bool;
	public var enableRetargeting : Bool = true;
	public var prevEnableRetargeting : Bool = true;

	public function new(s, ?mat, ?parent) {
		super(null, mat, parent);
		if( s != null )
			setSkinData(s);
	}

	override function clone( ?o : Object ) {
		var s = o == null ? new Skin(null,materials.copy()) : cast o;
		super.clone(s);
		s.setSkinData(skinData);
		return s;
	}

	override function onRemove() {
		super.onRemove();
		disposeBuffers();
	}

	override function addBoundsRec( b : h3d.col.Bounds, relativeTo : h3d.Matrix ) {
		// ignore primitive bounds !
		var old = primitive;
		primitive = null;
		super.addBoundsRec(b, relativeTo);
		primitive = old;
		if( flags.has(FIgnoreBounds) )
			return;
		syncJoints();
		if( skinData.vertexWeights == null )
			cast(primitive, h3d.prim.HMDModel).loadSkin(skinData);
		var absScale = getAbsPos().getScale();
		var scale = Math.max(Math.max(absScale.x, absScale.y), absScale.z);
		for( j in skinData.allJoints ) {
			if( j.offsetRay < 0 ) continue;
			var m = currentPalette[j.bindIndex];
			var pt = j.offsets.getMin();
			if ( m != null ) {
				pt.transform(m);
				if( relativeTo != null ) pt.transform(relativeTo);
				b.addSpherePos(pt.x, pt.y, pt.z, j.offsetRay * scale);
				var pt = j.offsets.getMax();
				pt.transform(m);
				if( relativeTo != null ) pt.transform(relativeTo);
				b.addSpherePos(pt.x, pt.y, pt.z, j.offsetRay * scale);
			}
		}
	}

	public function getCurrentSkeletonBounds() {
		syncJoints();
		var b = new h3d.col.Bounds();
		for( j in skinData.allJoints ) {
			if( j.bindIndex < 0 ) continue;
			var r = jointsData[j.index].currentAbsPos;
			b.addSpherePos(r.tx, r.ty, r.tz, 0);
		}
		return b;
	}

	override function getObjectByName( name : String ) : h3d.scene.Object {
		// we can reference the object by both its model name and skin name
		if( skinData != null && skinData.name == name )
			return this;
		var o = super.getObjectByName(name);
		if( o != null ) return o;
		// create a fake object targeted at the bone, not persistant but matrixes are shared
		if( skinData != null ) {
			var j = skinData.namedJoints.get(name);
			if( j != null )
				return new Joint(this, j);
		}
		return null;
	}

	override function getLocalCollider() : h3d.col.Collider {
		return primitive.getCollider();
	}

	override function getGlobalCollider() : h3d.col.Collider {
		var col = getLocalCollider();
		if( Std.isOfType(col, h3d.col.Collider.OptimizedCollider) ) {
			// Generated from mesh, so need skin's transform
			var col = cast(col, h3d.col.Collider.OptimizedCollider);
			var primCol = Std.downcast(col.b, h3d.col.PolygonBuffer);
			if( primCol != null && primCol.source != null ) {
				cast(primitive, h3d.prim.HMDModel).loadSkin(skinData);
				return new h3d.col.SkinCollider(this, primCol);
			}
			var rootTrans = this.getAbsPos();
			return new h3d.col.TransformCollider(rootTrans, col);
		}
		return col;
	}

	override function calcAbsPos() {
		super.calcAbsPos();
		// if we update our absolute position, rebuild the matrixes
		jointsUpdated = true;
	}

	public function getSkinData() {
		return skinData;
	}

	public function getJointRelPosition( name : String, additive = false ) : Null<h3d.Matrix> {
		var j = skinData.namedJoints.get(name);
		if( j == null ) return null;
		if( additive )
			return jointsData[j.index].additivePose;
		return jointsData[j.index].currentRelPos ?? j.defMat;
	}

	public function setJointRelPosition( name : String, pos : h3d.Matrix, additive = false ) {
		var j = skinData.namedJoints.get(name);
		if( j == null ) return;
		if( additive ) {
			jointsData[j.index].additivePose = pos;
		} else
			jointsData[j.index].currentRelPos = pos;
		jointsUpdated = true;
	}

	public function setSkinData( s, shaderInit = true ) {
		skinData = s;
		jointsUpdated = true;
		primitive = s.primitive;
		if( shaderInit ) {
			var hasNormalMap = false;
			for( m in materials )
				if( m != null && m.normalMap != null ) {
					hasNormalMap = true;
					break;
				}
			skinShader = hasNormalMap ? new h3d.shader.SkinTangent() : new h3d.shader.Skin();
			skinShader.fourBonesByVertex = skinData.bonesPerVertex == 4;
			var maxBones = 0;
			if( skinData.splitJoints != null ) {
				for( s in skinData.splitJoints )
					if( s.joints.length > maxBones )
						maxBones = s.joints.length;
			} else
				maxBones = skinData.boundJoints.length;
			#if !editor
			maxBones = hxd.Math.imax(MIN_SHADER_BONES, hxd.Math.nextPOT(maxBones));
			#end
			if(maxBones > MAX_SHADER_BONES)
				throw "too many bones";
			skinShader.BUFFER_SIZE = maxBones * 3; // Mat3x4 passed as 3 vec4
			for( m in materials )
				if( m != null ) {
					m.mainPass.removeShaders(h3d.shader.SkinBase);
					if( m.normalMap != null ) {
						@:privateAccess m.mainPass.addShaderAtIndex(skinShader, m.mainPass.getShaderIndex(m.normalShader) + 1);
					} else {
						m.mainPass.addShader(skinShader);
					}
					if( skinData.splitJoints != null ) {
						for( p in m.getPasses() )
							p.dynamicParameters = true;
					}
				}
		}

		disposeBuffers();

		jointsData = [];
		currentPalette = [];
		makeJointsData();
		for( i in 0...skinData.boundJoints.length )
			currentPalette.push(h3d.Matrix.I());
		if( skinData.splitJoints != null ) {
			splitPalette = [];
			for( a in skinData.splitJoints )
				splitPalette.push([for( j in a.joints ) currentPalette[j.bindIndex]]);
		} else
			splitPalette = null;
	}

	function disposeBuffers() {
		var alloc = hxd.impl.Allocator.get();
		if( jointsBuffer != null ) {
			alloc.disposeBuffer(jointsBuffer);
			jointsBuffer = null;
		}
		if(prevJointsBuffer != null) {
			alloc.disposeBuffer(prevJointsBuffer);
			prevJointsBuffer = null;
		}
		if( splitBuffers != null ) {
			for( b in splitBuffers )
				alloc.disposeBuffer(b);
			splitBuffers = null;
		}
		if(prevSplitBuffers != null) {
			for( b in prevSplitBuffers )
				alloc.disposeBuffer(b);
			prevSplitBuffers = null;
		}
	}

	function updateShader() {
		inline function alloc(count: Int) {
			#if !hldx
			// GL doesn't support passing smaller buffers than declared
			count = Std.int(skinShader.BUFFER_SIZE / 3);  // Mat3x4 passed as Vec3
			#end
			return hxd.impl.Allocator.get().allocBuffer(count, hxd.BufferFormat.MAT3x4_DATA, UniformDynamic);
		}
		var hasVelocity = computeVelocity();

		if(buffersDirty) {
			// Swap buffers
			if( skinData.splitJoints != null ) {
				if(splitBuffers == null)
					splitBuffers = [for( a in skinData.splitJoints ) alloc(a.joints.length)];
				if(hasVelocity) {
					if(prevSplitBuffers == null)
						prevSplitBuffers = [for( a in skinData.splitJoints ) alloc(a.joints.length)];
					var tmp = prevSplitBuffers;
					prevSplitBuffers = splitBuffers;
					splitBuffers = tmp;
				}
			} else {
				if(jointsBuffer == null)
					jointsBuffer = alloc(skinData.boundJoints.length);
				if(hasVelocity) {
					if(prevJointsBuffer == null)
						prevJointsBuffer = alloc(skinData.boundJoints.length);
					var tmp = prevJointsBuffer;
					prevJointsBuffer = jointsBuffer;
					jointsBuffer = tmp;
				}
			}

			// Fill current
			static var fbuf : hxd.FloatBuffer;
				if(fbuf == null) fbuf = hxd.impl.Allocator.get().allocFloats(MAX_SHADER_BONES * hxd.BufferFormat.MAT3x4_DATA.stride * 4);

			inline function fillBones(palette : Array<h3d.Matrix>, buffer : h3d.Buffer) {
				var loader = new hxd.FloatBufferLoader(fbuf, 0);
				for( m in palette ) loader.loadMatrix3x4(m);
				buffer.uploadFloats(fbuf, 0, palette.length);
			}
			if( splitPalette != null ) {
				for( si in 0...splitPalette.length ) {
					fillBones(splitPalette[si], splitBuffers[si]);
				}
			} else
				fillBones(currentPalette, jointsBuffer);
		}

		if( splitPalette == null ) {
			skinShader.bonesMatrixes = jointsBuffer;
			if( hasVelocity )
				skinShader.prevBonesMatrixes = buffersDirty ? prevJointsBuffer : jointsBuffer;
		}
		else {
			// shader buffers set in draw() because dynamicParameters
		}

		skinShader.calcPrevPos = hasVelocity;
		buffersDirty = false;
	}

	function makeJointsData() {
		for( j in skinData.allJoints )
			jointsData[j.index] = j.makeRuntimeData();
	}

	override function sync( ctx : RenderContext ) {
		if( !ctx.visibleFlag && !alwaysSyncAnimation )
			return;
		syncJoints();
	}

	static var TMP_MAT = new h3d.Matrix();

	@:noDebug
	function syncJoints() {
		if( !jointsUpdated && (forceJointsUpdateOnFrame < 0 || forceJointsUpdateOnFrame >= hxd.Timer.frameCount ))
			return;

		var syncDyn = false;
		if( jointsFrame != hxd.Timer.frameCount ) {
			accumulator += hxd.Timer.dt;
			while ( accumulator >= FIXED_DT ) {
				syncDyn = true;
				accumulator -= FIXED_DT;
			}
		}

		for (j in skinData.allJoints)
			jointsData[j.index].sync(this, j, syncDyn);

		jointsUpdated = false;
		buffersDirty = true;
		jointsFrame = hxd.Timer.frameCount;
		prevEnableRetargeting = enableRetargeting;
	}

	override function emit( ctx : RenderContext ) {
		calcScreenRatio(ctx);
		syncJoints(); // In case sync was not called because of culling (eg fixedPosition)

		updateShader();

		if( splitPalette == null )
			super.emit(ctx);
		else {
			for( i in 0...splitPalette.length ) {
				var m = materials[skinData.splitJoints[i].material];
				if( m != null )
					ctx.emit(m, this, i);
			}
		}
		if( showJoints ) {
			var topParent : Object = this;
			while( topParent.parent != null )
				topParent = topParent.parent;

			if( jointsGraphics == null ) {
				jointsGraphics = new Graphics(topParent);
				jointsGraphics.material.mainPass.depth(false, Always);
				jointsGraphics.material.mainPass.setPassName("alpha");
			}

			jointsGraphics.follow = topParent;

			var g = jointsGraphics;
			g.clear();
			for( j in skinData.allJoints ) {
				var m = jointsData[j.index].currentAbsPos;
				var mp = j.parent == null ? absPos : jointsData[j.parent.index].currentAbsPos;
				g.lineStyle(1, j.parent == null ? 0xFF0000FF : 0xFFFFFF00);
				g.moveTo(mp._41, mp._42, mp._43);
				g.lineTo(m._41, m._42, m._43);
			}
		} else if( jointsGraphics != null ) {
			jointsGraphics.remove();
			jointsGraphics = null;
		}
	}

	override function draw( ctx : RenderContext ) {
		if( splitPalette == null ) {
			super.draw(ctx);
		} else {
			var i = ctx.drawPass.index;
			skinShader.bonesMatrixes = splitBuffers[i];
			if ( skinShader.calcPrevPos )
				skinShader.prevBonesMatrixes = prevSplitBuffers[i];
			primitive.selectMaterial(i, getLodIndex());
			ctx.uploadParams();
			primitive.render(ctx.engine);
		}
	}

}

class SubSkin extends h3d.scene.Skin {

	var baseSkin : h3d.scene.Skin;
	var bindMap : Array<Int> = null;

	public function new( baseSkin : h3d.scene.Skin, subSkin : h3d.scene.Skin, ?parent) {
		this.baseSkin = baseSkin;
		super(null, subSkin.materials, parent);
		skinShader = subSkin.skinShader;
		setSkinData(subSkin.skinData, false);
	}

	function initBinds() {
		bindMap = [];
		for( b in skinData.allJoints ) {
			var b2 = baseSkin.skinData.namedJoints.get(b.name);
			if( b2 != null )
				bindJoint(b2, b);
		}
	}

	override function setSkinData( s, shaderInit = true ) {
		super.setSkinData(s, shaderInit);
		initBinds();
	}

	inline function packIndices(from: Int, to: Int) {
		return (from << 16) | to;
	}

	inline function unpackIndices( i : Int ) {
		return {
			to: i & ((1<<16)-1),
			from: i >> 16
		}
	}

	function bindJoint(from: h3d.anim.Skin.Joint, to: h3d.anim.Skin.Joint) {
		if(!baseSkin.skinData.allJoints.contains(from)) throw "assert";
		if(!skinData.allJoints.contains(to)) throw "assert";
		bindMap.push(packIndices(from.index, to.index));
	}

	function getBound(toJoint: h3d.anim.Skin.Joint) {
		for( b in bindMap ) {
			var bind = unpackIndices( b );
			if(toJoint.index == bind.to)
				return baseSkin.getSkinData().allJoints[bind.from];
		}
		return null;
	}

	var selfPlayAnim = false;
	override function playAnimation( a : h3d.anim.Animation ) {
		selfPlayAnim = true;
		var inst = super.playAnimation(a);
		selfPlayAnim = false;
		return inst;
	}

	override function getObjectByName( name : String ) : h3d.scene.Object {
		// Returning null prevents external animation.bind() from matching our joints and writing
		// currentRelPos here instead of baseSkin. Bypassed when playAnimation is called on this
		// SubSkin directly, so specific bones can still be animated on top (lipsync, eye blinks etc)
		if( !selfPlayAnim )
			return null;
		return super.getObjectByName(name);
	}

	override function syncJoints() {
		baseSkin.syncJoints();  // for when subSkin is before baseSkin in the hierarchy
		if( baseSkin.jointsFrame != hxd.Timer.frameCount )
			return;
		jointsUpdated = true;
		if( bindMap != null ) {
			for( b in bindMap ) {
				var bind = unpackIndices( b );
				var toJoint = jointsData[bind.to];
				var fromJoint = baseSkin.jointsData[bind.from];
				if(toJoint != null && fromJoint != null)
					toJoint.currentRelPos = fromJoint.currentRelPos;
			}
		}
		super.syncJoints();
	}
}