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
		lastFrame = -2; // force first sync
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
		// check if one of our parents has changed
		// we don't have a posChanged flag since the Joint
		// is not actualy part of the hierarchy
		var p : h3d.scene.Object = skin;
		while( p != null ) {
			if( p.posChanged) {
				update();
				break;
			}
			p = p.parent;
		}

		if( lastFrame != skin.lastFrame) {
			lastFrame = skin.lastFrame;
			absPos.load(skin.jointsData[index].currentAbsPos);
		}
	}

	/**
		Force the update of the position of this joint
	**/
	@:access(h3d.scene.Skin)
	public function update() {
		skin.getAbsPos();
		skin.syncJoints();
		lastFrame = -1;
	}
}

@:access(h3d.scene.Skin)
class JointData {
	public var currentRelPos : h3d.Matrix;
	public var currentAbsPos : h3d.Matrix;
	public var additivePose : h3d.Matrix;

	var targetMat : h3d.Matrix = h3d.Matrix.I();
	var originMat : h3d.Matrix = h3d.Matrix.I();

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

		if (!Std.isOfType(this, DynamicJointData)) {
			targetMat.load(m);
			originMat.load(m);
		}
	}
}

@:access(h3d.scene.Skin)
class DynamicJointData extends JointData {
	public var absPos : h3d.Matrix;
	public var relPos : h3d.Matrix;
	public var speed : h3d.Vector;

	static var newWorldPos = new Vector(0, 0, 0);
	static var expectedPos = new Vector(0, 0, 0);

	static var tmpVec = new Vector(0, 0, 0);
	static var tmpVec2 = new Vector(0, 0, 0);
	static var tmpQ = new Quat();
	static var tmpQ2 = new Quat();

	var f = -1;
	var initialState : DynamicJointData;

	public function new() {
		super();
		this.speed = new Vector(0, 0, 0);
	}

	public function load(data : DynamicJointData) {
		if (data.currentRelPos != null) {
			if (currentRelPos == null)
				currentRelPos = new Matrix();
			currentRelPos.load(data.currentRelPos);
		}
		if (data.currentAbsPos != null) {
			if (currentAbsPos == null)
				currentAbsPos = new Matrix();
			currentAbsPos.load(data.currentAbsPos);
		}
		if (data.additivePose != null) {
			if (additivePose == null)
				additivePose = new h3d.Matrix();
			additivePose.load(data.additivePose);
		}
		if (data.absPos != null) {
			if (absPos == null)
				absPos = new h3d.Matrix();
			absPos.load(data.absPos);
		}
		speed.load(data.speed);
	}

	public override function sync(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint, syncDyn : Bool) {
		super.sync(skin, j, syncDyn);

		// Ensure we compute dynamic joints data once per frame
		if (f != hxd.Timer.frameCount) {
			f = hxd.Timer.frameCount;
			if (initialState == null)
				initialState = new DynamicJointData();
			initialState.load(this);
		}
		else {
			this.load(initialState);
		}

		var jData : DynamicJointData = Std.downcast(skin.jointsData[j.index], DynamicJointData);
		var jParentData : JointData = Std.downcast(skin.jointsData[j.parent.index], JointData);
		if (syncDyn) {
			jData.originMat.load(jData.targetMat);

			// Compute position of the current joint
			computeDyn(skin, j);

			// Orient parent to make him lookat his children
			computeRotationDyn(skin, j.parent);
		}

		if (jData.originMat == null || jData.targetMat == null)
			return;

		var alpha = hxd.Math.clamp(skin.accumulator / Skin.FIXED_DT);

		lerpMatrixTerms(jData.originMat, jData.targetMat, alpha, Skin.TMP_MAT);
		if( j.bindIndex >= 0 )
			skin.currentPalette[j.bindIndex].multiply3x4inline(j.transPos, Skin.TMP_MAT);

		if( j.parent.bindIndex >= 0) {
			lerpMatrixTerms(jParentData.originMat, jParentData.targetMat, alpha, Skin.TMP_MAT);
			skin.currentPalette[j.parent.bindIndex].multiply3x4inline(j.parent.transPos, Skin.TMP_MAT);
		}

		if (jData.speed.length() != 0.)
			skin.forceJointsUpdateOnFrame = hxd.Timer.frameCount + 1;
	}

	function computeDyn(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		var j : DynamicJoint = cast j;
		var jData : DynamicJointData = Std.downcast(skin.jointsData[j.index], DynamicJointData);
		var absPos = jData.absPos == null ?  jData.currentAbsPos : jData.absPos;
		var relPos = j.defMat;
		newWorldPos.load(absPos.getPosition());
		expectedPos.load(absPos.getPosition());

		// Resistance (force resistance)
		var globalForce = j.globalForce;
		speed.load(speed + globalForce * (1.0 - j.resistance));

		// Damping (inertia attenuation)
		jData.speed *= 1.0 - j.damping;

		if (jData.speed.lengthSq() > DynamicJoint.SLEEP_THRESHOLD)
			newWorldPos.load(newWorldPos + jData.speed * Skin.FIXED_DT);

		if (jData.speed.lengthSq() > DynamicJoint.MAX_THRESHOLD) {
			jData.speed.set(0, 0, 0);
		}

		// Stiffness (shape keeper)
		Skin.TMP_MAT.multiply(relPos, skin.jointsData[j.parent.index].currentAbsPos);
		expectedPos.load(Skin.TMP_MAT.getPosition());
		newWorldPos.lerp(newWorldPos, expectedPos, j.stiffness);

		// Slackness (length keeper)
		var dirToParent = (newWorldPos - skin.jointsData[j.parent.index].currentAbsPos.getPosition()).normalized();
		var lengthToParent = relPos.getPosition().length();
		var scale = skin.jointsData[j.parent.index].currentAbsPos.getScale(); //! Non uniform scale won't work
		expectedPos.load(skin.jointsData[j.parent.index].currentAbsPos.getPosition() + (dirToParent * lengthToParent * scale.x));
		newWorldPos.lerp(expectedPos, newWorldPos, j.slackness);

		// Apply lock axis
		skin.jointsData[j.parent.index].currentAbsPos.getInverse(Skin.TMP_MAT);
		tmpVec.load(newWorldPos);
		tmpVec.transform(Skin.TMP_MAT);
		tmpVec2.load(jData.currentAbsPos.getPosition());
		tmpVec2.transform(Skin.TMP_MAT);
		if (j.lockAxis.x > 0.0)
			tmpVec.x = tmpVec2.x;
		if (j.lockAxis.y > 0.0)
			tmpVec.y = tmpVec2.y;
		if (j.lockAxis.z > 0.0)
			tmpVec.z = tmpVec2.z;
		tmpVec.transform(skin.jointsData[j.parent.index].currentAbsPos);
		newWorldPos.load(tmpVec);

		// Apply computed position to joint
		jData.speed.load((jData.speed + (newWorldPos - absPos.getPosition()) * (1.0 / Skin.FIXED_DT)) * 0.5);
		jData.currentAbsPos.setPosition(newWorldPos);
		if (jData.absPos == null)
			jData.absPos = new h3d.Matrix();
		jData.absPos.load(jData.currentAbsPos);
		if (jData.relPos == null)
			jData.relPos = new Matrix();

		skin.jointsData[j.parent.index].currentAbsPos.getInverse(Skin.TMP_MAT);
		jData.relPos.multiply(jData.absPos, Skin.TMP_MAT);

		jData.targetMat.load(jData.currentAbsPos);
	}

	function computeRotationDyn(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		if ( j.follow != null ) return;

		var jData = skin.jointsData[j.index];
		var jDynData = Std.downcast(skin.jointsData[j.index], DynamicJointData);
		var dynJoint = Std.downcast(j, DynamicJoint);
		if (j.subs.length == 1) {
			var child = Std.downcast(j.subs[0], DynamicJoint);
			if (child == null) return;

			var childData = Std.downcast(skin.jointsData[child.index], DynamicJointData);
			tmpVec.load(child.defMat.getPosition().normalized());
			tmpVec2.load(childData.relPos.getPosition().normalized());
			tmpQ.initMoveTo(tmpVec, tmpVec2);
			tmpQ.toMatrix(Skin.TMP_MAT);

			jData.currentAbsPos.multiply(Skin.TMP_MAT, jData.currentAbsPos);
		}

		jData.targetMat.load(jData.currentAbsPos);
	}

	function lerpMatrixTerms(a: h3d.Matrix, b: h3d.Matrix, t: Float, out: h3d.Matrix): h3d.Matrix {
		out._11 = hxd.Math.lerp(a._11, b._11, t);
		out._12 = hxd.Math.lerp(a._12, b._12, t);
		out._13 = hxd.Math.lerp(a._13, b._13, t);
		out._14 = hxd.Math.lerp(a._14, b._14, t);
		out._21 = hxd.Math.lerp(a._21, b._21, t);
		out._22 = hxd.Math.lerp(a._22, b._22, t);
		out._23 = hxd.Math.lerp(a._23, b._23, t);
		out._24 = hxd.Math.lerp(a._24, b._24, t);
		out._31 = hxd.Math.lerp(a._31, b._31, t);
		out._32 = hxd.Math.lerp(a._32, b._32, t);
		out._33 = hxd.Math.lerp(a._33, b._33, t);
		out._34 = hxd.Math.lerp(a._34, b._34, t);
		out._41 = hxd.Math.lerp(a._41, b._41, t);
		out._42 = hxd.Math.lerp(a._42, b._42, t);
		out._43 = hxd.Math.lerp(a._43, b._43, t);
		out._44 = hxd.Math.lerp(a._44, b._44, t);
    	return out;
	}
}

class Skin extends MultiMaterial {
	public static var FIXED_DT = 1. / 60.;
	public var accumulator = FIXED_DT;

	var skinData : h3d.anim.Skin;
	var jointsData : Array<JointData>; // Runtime data

	var currentPalette : Array<h3d.Matrix>;
	var prevPalette : Array<h3d.Matrix>;
	var splitPalette : Array<Array<h3d.Matrix>>;
	var prevSplitPalette : Array<Array<h3d.Matrix>>;
	var prevJointsFrame : Int = -1;
	var forceJointsUpdateOnFrame : Int = -1;
	var jointsUpdated : Bool;
	var paletteChanged : Bool;
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

		s.jointsData = [];
		for (jData in jointsData)
			s.jointsData.push(Reflect.copy(jData));

		return s;
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

	override function getLocalCollider() {
		throw "Not implemented";
		return null;
	}

	override function getGlobalCollider() : h3d.col.Collider {
		var col = cast(primitive.getCollider(), h3d.col.Collider.OptimizedCollider);
		var primCol = Std.downcast(col.b, h3d.col.PolygonBuffer);
		if( primCol == null )
			return col;
		cast(primitive, h3d.prim.HMDModel).loadSkin(skinData);
		return new h3d.col.SkinCollider(this, primCol);
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
			if( skinShader.MaxBones < maxBones )
				skinShader.MaxBones = maxBones;
			for( m in materials )
				if( m != null ) {
					var s = m.mainPass.getShader(h3d.shader.SkinTangent);
					if ( s != null )
						m.mainPass.removeShader(s);
					if( m.normalMap != null ) {
						@:privateAccess m.mainPass.addShaderAtIndex(skinShader, m.mainPass.getShaderIndex(m.normalShader) + 1);
					} else {
						m.mainPass.addShader(skinShader);
					}
					if( skinData.splitJoints != null ) m.mainPass.dynamicParameters = true;
				}
		}

		jointsData = [];
		currentPalette = [];
		prevPalette = null;
		prevSplitPalette = null;
		paletteChanged = true;
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
		if( !jointsUpdated && forceJointsUpdateOnFrame >= hxd.Timer.frameCount )
			return;

		if ( computeVelocity() ) {
			syncPrevJoints();
			skinShader.calcPrevPos = true;
		} else {
			prevSplitPalette = null;
			prevPalette = null;
			skinShader.calcPrevPos = false;
		}

		skinShader.calcPrevPos = computeVelocity();

		var syncDyn = false;
		accumulator += hxd.Timer.dt;
		if (accumulator >= Skin.FIXED_DT) {
			syncDyn = true;
			accumulator -= Skin.FIXED_DT;
		}

		for (j in skinData.allJoints)
			jointsData[j.index].sync(this, j, syncDyn);

		skinShader.bonesMatrixes = currentPalette;
		jointsUpdated = false;
		prevEnableRetargeting = enableRetargeting;
	}

	function syncPrevJoints() {
		if ( prevJointsFrame == hxd.Timer.frameCount )
			return;
		prevJointsFrame = hxd.Timer.frameCount;

		if ( prevPalette == null ) {
			prevPalette = [];
			for ( _ in 0...currentPalette.length )
				prevPalette.push(h3d.Matrix.I());
			if ( splitPalette != null ) {
				prevSplitPalette = [];
				for ( a in skinData.splitJoints )
					prevSplitPalette.push([for ( j in a.joints ) prevPalette[j.bindIndex]]);
			}
		}
		for ( i => m in currentPalette )
			prevPalette[i].load(m);
		skinShader.prevBonesMatrixes = prevPalette;
	}

	override function emit( ctx : RenderContext ) {
		calcScreenRatio(ctx);
		syncJoints(); // In case sync was not called because of culling (eg fixedPosition)
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
			skinShader.bonesMatrixes = splitPalette[i];
			if ( prevSplitPalette != null )
				skinShader.prevBonesMatrixes = prevSplitPalette[i];
			primitive.selectMaterial(i, primitive.screenRatioToLod(curScreenRatio));
			ctx.uploadParams();
			primitive.render(ctx.engine);
		}
	}

}