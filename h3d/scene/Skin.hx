package h3d.scene;

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
			absPos.load(skin.currentAbsPose[index]);
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

class Skin extends MultiMaterial {

	var skinData : h3d.anim.Skin;
	var currentRelPose : Array<h3d.Matrix>;
	var currentAbsPose : Array<h3d.Matrix>;
	var currentPalette : Array<h3d.Matrix>;
	var splitPalette : Array<Array<h3d.Matrix>>;
	var jointsUpdated : Bool;
	var paletteChanged : Bool;
	var skinShader : h3d.shader.SkinBase;
	var jointsGraphics : Graphics;
	var additivePose : Array<h3d.Matrix>;

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
		s.currentRelPose = currentRelPose.copy(); // copy current pose
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
			var r = currentAbsPose[j.index];
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

	public function setJointRelPosition( name : String, pos : h3d.Matrix, additive = false ) {
		var j = skinData.namedJoints.get(name);
		if( j == null ) return;
		if( additive ) {
			if( additivePose == null ) additivePose = [];
			additivePose[j.index] = pos;
		} else
			currentRelPose[j.index] = pos;
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
		currentRelPose = [];
		currentAbsPose = [];
		currentPalette = [];
		paletteChanged = true;
		for( j in skinData.allJoints )
			currentAbsPose.push(h3d.Matrix.I());
		for( i in 0...skinData.boundJoints.length )
			currentPalette.push(h3d.Matrix.I());
		if( skinData.splitJoints != null ) {
			splitPalette = [];
			for( a in skinData.splitJoints )
				splitPalette.push([for( j in a.joints ) currentPalette[j.bindIndex]]);
		} else
			splitPalette = null;
	}

	override function sync( ctx : RenderContext ) {
		if( !ctx.visibleFlag && !alwaysSyncAnimation )
			return;
		syncJoints();
	}

	static var TMP_MAT = new h3d.Matrix();

	@:noDebug
	function syncJoints() {
		if( !jointsUpdated ) return;
		var tmpMat = TMP_MAT;
		for( j in skinData.allJoints ) {
			if ( j.follow != null ) continue;
			var id = j.index;
			var m = currentAbsPose[id];
			var r = currentRelPose[id];
			var bid = j.bindIndex;
			if( r == null ) r = j.defMat else if( j.retargetAnim && enableRetargeting ) { tmpMat.load(r); r = tmpMat; r._41 = j.defMat._41; r._42 = j.defMat._42; r._43 = j.defMat._43; }
			if( j.parent == null )
				m.multiply3x4inline(r, absPos);
			else
				m.multiply3x4inline(r, currentAbsPose[j.parent.index]);
			if( additivePose != null ) {
				var a = additivePose[id];
				if( a != null ) m.multiply3x4inline(a, m);
			}
			if( bid >= 0 )
				currentPalette[bid].multiply3x4inline(j.transPos, m);
		}
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
				var m = currentAbsPose[j.index];
				var mp = j.parent == null ? absPos : currentAbsPose[j.parent.index];
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