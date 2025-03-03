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
			absPos.load(skin.jointsData[index].currentAbsPose);
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
	public var currentRelPose : h3d.Matrix;
	public var currentAbsPose : h3d.Matrix;
	public var additivePose : h3d.Matrix;

	public function new() {
		this.currentAbsPose = h3d.Matrix.I();
	}

	public function sync(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		if ( j.follow != null ) return;
		var m = currentAbsPose;
		var r = currentRelPose;
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
			m.multiply3x4inline(r, skin.jointsData[j.parent.index].currentAbsPose);
		if( additivePose != null )
			m.multiply3x4inline(additivePose, m);
		if( bid >= 0 )
			skin.currentPalette[bid].multiply3x4inline(j.transPos, m);
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

	var f = -1;
	var initialState : DynamicJointData;

	public function new() {
		super();
		this.speed = new Vector(0, 0, 0);
	}

	public function load(data : DynamicJointData) {
		if (data.currentRelPose != null) {
			if (currentRelPose == null)
				currentRelPose = new Matrix();
			currentRelPose.load(data.currentRelPose);
		}
		if (data.currentAbsPose != null) {
			if (currentAbsPose == null)
				currentAbsPose = new Matrix();
			currentAbsPose.load(data.currentAbsPose);
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

	public override function sync(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		super.sync(skin, j);

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

		// Compute position of the current joint
		computeDyn(skin, j);

		// Orient parent to make him lookat his children
		computeRotationDyn(skin, j.parent);
	}

	function computeDyn(skin: h3d.scene.Skin, j: h3d.anim.Skin.Joint) {
		var j : DynamicJoint = cast j;
		var jData : DynamicJointData = Std.downcast(skin.jointsData[j.index], DynamicJointData);
		var absPos = jData.absPos == null ?  jData.currentAbsPose : jData.absPos;
		var relPos = j.defMat;
		newWorldPos.load(absPos.getPosition());
		expectedPos.load(absPos.getPosition());

		// Resistance (force resistance)
		var globalForce = j.globalForce;
		speed.load(speed + globalForce * (1.0 - j.resistance));

		// Damping (inertia attenuation)
		jData.speed *= 1.0 - j.damping;
		if (jData.speed.lengthSq() > DynamicJoint.SLEEP_THRESHOLD)
			newWorldPos.load(newWorldPos + jData.speed * hxd.Timer.dt);

		// Stiffness (shape keeper)
		Skin.TMP_MAT.multiply(relPos, skin.jointsData[j.parent.index].currentAbsPose);
        expectedPos.load(Skin.TMP_MAT.getPosition());
        newWorldPos.lerp(newWorldPos, expectedPos, j.stiffness);

		// Slackness (length keeper)
		var dirToParent = (newWorldPos - skin.jointsData[j.parent.index].currentAbsPose.getPosition()).normalized();
		var lengthToParent = relPos.getPosition().length();
		expectedPos.load(skin.jointsData[j.parent.index].currentAbsPose.getPosition() + dirToParent * lengthToParent);
		newWorldPos.lerp(expectedPos, newWorldPos, j.slackness);

		// Apply lock axis
		skin.jointsData[j.parent.index].currentAbsPose.getInverse(Skin.TMP_MAT);
		tmpVec.load(newWorldPos);
		tmpVec.transform(Skin.TMP_MAT);
		tmpVec2.load(jData.currentAbsPose.getPosition());
		tmpVec2.transform(Skin.TMP_MAT);
		if (j.lockAxis.x > 0.0)
			tmpVec.x = tmpVec2.x;
		if (j.lockAxis.y > 0.0)
			tmpVec.y = tmpVec2.y;
		if (j.lockAxis.z > 0.0)
			tmpVec.z = tmpVec2.z;
		tmpVec.transform(skin.jointsData[j.parent.index].currentAbsPose);
		newWorldPos.load(tmpVec);

		// Apply computed position to joint
		jData.speed.load((jData.speed + (newWorldPos - absPos.getPosition()) * (1.0 / hxd.Timer.dt)) * 0.5);
		jData.currentAbsPose.setPosition(newWorldPos);
		if (jData.absPos == null)
			jData.absPos = new h3d.Matrix();
		jData.absPos.load(jData.currentAbsPose);
		if (jData.relPos == null)
			jData.relPos = new Matrix();

		skin.jointsData[j.parent.index].currentAbsPose.getInverse(Skin.TMP_MAT);
		jData.relPos.multiply(jData.absPos, Skin.TMP_MAT);

		if( j.bindIndex >= 0 )
			skin.currentPalette[j.bindIndex].multiply3x4inline(j.transPos, jData.currentAbsPose);

		if (jData.speed.length() != 0.)
			skin.forceJointsUpdateOnFrame = hxd.Timer.frameCount + 1;
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

			jData.currentAbsPose.multiply(Skin.TMP_MAT, jData.currentAbsPose);
		}

		if( j.bindIndex >= 0 )
			skin.currentPalette[j.bindIndex].multiply3x4inline(j.transPos, jData.currentAbsPose);

		if (jDynData != null)
			jDynData.absPos.load(jDynData.currentAbsPose);
	}
}

class Skin extends MultiMaterial {

	var skinData : h3d.anim.Skin;
	var jointsData : Array<JointData>; // Runtime data

	var currentPalette : Array<h3d.Matrix>;
	var splitPalette : Array<Array<h3d.Matrix>>;
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
			var r = jointsData[j.index].currentAbsPose;
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

	override function getGlobalCollider() {
		var col = cast(primitive.getCollider(), h3d.col.Collider.OptimizedCollider);
		cast(primitive, h3d.prim.HMDModel).loadSkin(skinData);
		return new h3d.col.SkinCollider(this, cast(col.b, h3d.col.PolygonBuffer));
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
		return jointsData[j.index].currentRelPose ?? j.defMat;
	}

	public function setJointRelPosition( name : String, pos : h3d.Matrix, additive = false ) {
		var j = skinData.namedJoints.get(name);
		if( j == null ) return;
		if( additive ) {
			jointsData[j.index].additivePose = pos;
		} else
			jointsData[j.index].currentRelPose = pos;
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
		if( !jointsUpdated && forceJointsUpdateOnFrame != hxd.Timer.frameCount ) return;

		for( j in skinData.allJoints )
			jointsData[j.index].sync(this, j);

		skinShader.bonesMatrixes = currentPalette;
		jointsUpdated = false;
		prevEnableRetargeting = enableRetargeting;
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
			if( jointsGraphics == null ) {
				jointsGraphics = new Graphics(this);
				jointsGraphics.material.mainPass.depth(false, Always);
				jointsGraphics.material.mainPass.setPassName("alpha");
			}
			var topParent : Object = this;
			while( topParent.parent != null )
				topParent = topParent.parent;
			jointsGraphics.follow = topParent;

			var g = jointsGraphics;
			g.clear();
			for( j in skinData.allJoints ) {
				var m = jointsData[j.index].currentAbsPose;
				var mp = j.parent == null ? absPos : jointsData[j.parent.index].currentAbsPose;
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
			primitive.selectMaterial(i, primitive.screenRatioToLod(curScreenRatio));
			ctx.uploadParams();
			primitive.render(ctx.engine);
		}
	}

}