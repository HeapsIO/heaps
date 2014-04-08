package h3d.scene;

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
	
	@:access(h3d.scene.Skin)
	override function syncPos() {
		// check if one of our parents has changed
		// we don't have a posChanged flag since the Joint
		// is not actualy part of the hierarchy
		var p = parent;
		while( p != null ) {
			if( p.posChanged ) {
				// save the inverse absPos that was used to build the joints absPos
				if( skin.jointsAbsPosInv == null ) {
					skin.jointsAbsPosInv = new h3d.Matrix();
					skin.jointsAbsPosInv.zero();
				}
				if( skin.jointsAbsPosInv._44 == 0 )
					skin.jointsAbsPosInv.inverse3x4(parent.absPos);
				parent.syncPos();
				lastFrame = -1;
				break;
			}
			p = p.parent;
		}
		if( lastFrame != skin.lastFrame ) {
			lastFrame = skin.lastFrame;
			absPos.loadFrom(skin.currentAbsPose[index]);
			if( skin.jointsAbsPosInv != null && skin.jointsAbsPosInv._44 != 0 ) {
				absPos.multiply3x4(absPos, skin.jointsAbsPosInv);
				absPos.multiply3x4(absPos, parent.absPos);
			}
		}
	}
}

class Skin extends MultiMaterial {
	
	var skinData : h3d.anim.Skin;
	var currentRelPose : Array<h3d.Matrix>;
	var currentAbsPose : Array<h3d.Matrix>;
	var currentPalette : Array<h3d.Matrix>;
	var splitPalette : Array<Array<h3d.Matrix>>;
	var jointsUpdated : Bool;
	var jointsAbsPosInv : h3d.Matrix;
	var paletteChanged : Bool;

	public var showJoints : Bool;
	public var syncIfHidden : Bool = true;
	
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
	
	
	override function getBounds( ?b : h3d.col.Bounds, rec = false ) {
		b = super.getBounds(b, rec);
		var tmp = primitive.getBounds().clone();
		var b0 = skinData.allJoints[0];
		// not sure if that's the good joint
		if( b0 != null && b0.parent == null ) {
			var mtmp = absPos.clone();
			var r = currentRelPose[b0.index];
			if( r != null )
				mtmp.multiply3x4(r, mtmp);
			else
				mtmp.multiply3x4(b0.defMat, mtmp);
			if( b0.transPos != null )
				mtmp.multiply3x4(b0.transPos, mtmp);
			tmp.transform3x4(mtmp);
		} else
			tmp.transform3x4(absPos);
		b.add(tmp);
		return b;
	}

	override function getObjectByName( name : String ) {
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
	
	override function calcAbsPos() {
		super.calcAbsPos();
		// if we update our absolute position, rebuild the matrixes
		jointsUpdated = true;
	}
	
	public function setSkinData( s ) {
		skinData = s;
		jointsUpdated = true;
		primitive = s.primitive;
		for( m in materials )
			if( m != null )
				m.hasSkin = true;
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
				splitPalette.push([for( j in a ) currentPalette[j.bindIndex]]);
		} else
			splitPalette = null;
	}

	override function sync( ctx : RenderContext ) {
		if( !(visible || syncIfHidden) )
			return;
		if( jointsUpdated || posChanged ) {
			super.sync(ctx);
			for( j in skinData.allJoints ) {
				var id = j.index;
				var m = currentAbsPose[id];
				var r = currentRelPose[id];
				if( r == null ) r = j.defMat;
				if( j.parent == null )
					m.multiply3x4(r, absPos);
				else
					m.multiply3x4(r, currentAbsPose[j.parent.index]);
				var bid = j.bindIndex;
				if( bid >= 0 )
					currentPalette[bid].multiply3x4(j.transPos, m);
			}
			paletteChanged = true;
			if( jointsAbsPosInv != null ) jointsAbsPosInv._44 = 0; // mark as invalid
			jointsUpdated = false;
		} else
			super.sync(ctx);
	}
	
	override function draw( ctx : RenderContext ) {
		if( splitPalette == null ) {
			if( paletteChanged ) {
				paletteChanged = false;
				for( m in materials )
					if( m != null )
						m.skinMatrixes = currentPalette;
			}
			super.draw(ctx);
		} else {
			for( i in 0...splitPalette.length ) {
				material.skinMatrixes = splitPalette[i];
				primitive.selectMaterial(i);
				super.draw(ctx);
			}
		}
		if( showJoints )
			ctx.addPass(drawJoints);
	}
	
	function drawJoints( ctx : RenderContext ) {
		for( j in skinData.allJoints ) {
			var m = currentAbsPose[j.index];
			var mp = j.parent == null ? absPos : currentAbsPose[j.parent.index];
			ctx.engine.line(mp._41, mp._42, mp._43, m._41, m._42, m._43, j.parent == null ? 0xFF0000FF : 0xFFFFFF00);
			
			var dz = new h3d.Vector(0, 0.01, 0);
			dz.transform(m);
			ctx.engine.line(m._41, m._42, m._43, dz.x, dz.y, dz.z, 0xFF00FF00);
			
			ctx.engine.point(m._41, m._42, m._43, j.bindIndex < 0 ? 0xFF0000FF : 0xFFFF0000);
		}
	}
	
	
}