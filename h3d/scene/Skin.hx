package h3d.scene;

class Joint extends Object {
	public var index : Int;
	public function new(index) {
		super(null);
		this.index = index;
	}
}

class Skin extends Mesh {
	
	var skinData : h3d.anim.Skin;
	var currentRelPose : Array<h3d.Matrix>;
	var currentAbsPose : Array<h3d.Matrix>;
	var currentPalette : Array<h3d.Matrix>;
	var jointsUpdated : Bool;

	public var showJoints : Bool;
	
	public function new(s, ?mat, ?parent) {
		super(null, mat, parent);
		if( s != null )
			setSkinData(s);
	}
	
	override function clone( ?o : Object ) {
		var s = o == null ? new Skin(null,material) : cast o;
		super.clone(s);
		s.setSkinData(skinData);
		s.currentRelPose = currentRelPose.copy(); // copy current pose
		return s;
	}
	
	override function getObjectByName( name : String ) {
		var o = super.getObjectByName(name);
		if( o != null ) return o;
		// create a fake object targeted at the bone, not persistant but matrixes are shared
		if( skinData != null ) {
			var j = skinData.namedJoints.get(name);
			if( j != null ) {
				var o = new Joint(j.index);
				o.parent = this;
				o.absPos = currentAbsPose[j.index];
				o.defaultTransform = currentRelPose[j.index];
				return o;
			}
		}
		return null;
	}
	
	public function setSkinData( s ) {
		skinData = s;
		jointsUpdated = true;
		primitive = s.primitive;
		material.hasSkin = true;
		currentRelPose = [];
		currentAbsPose = [];
		currentPalette = [];
		for( j in skinData.allJoints )
			currentAbsPose.push(h3d.Matrix.I());
		for( i in 0...skinData.boundJoints.length )
			currentPalette.push(h3d.Matrix.I());
	}

	override function sync( ctx : RenderContext ) {
		if( jointsUpdated || posChanged ) {
			super.sync(ctx);
			for( j in skinData.allJoints ) {
				var id = j.index;
				var m = currentAbsPose[id];
				var r = currentRelPose[id];
				if( r == null ) {
					var bid = j.bindIndex;
					if( bid >= 0 ) r = j.defMat else continue;
				}
				if( j.parent == null )
					m.multiply(r, absPos);
				else
					m.multiply(r, currentAbsPose[j.parent.index]);
				var bid = j.bindIndex;
				if( bid >= 0 )
					currentPalette[bid].multiply(j.transPos, m);
			}
			material.skinMatrixes = currentPalette;
			jointsUpdated = false;
		} else
			super.sync(ctx);
	}
	
	override function draw( ctx : RenderContext ) {
		super.draw(ctx);
		if( showJoints )
			ctx.addPass(drawJoints);
	}
	
	function drawJoints( ctx : RenderContext ) {
		for( j in skinData.allJoints ) {
			var m = currentAbsPose[j.index];
			var mp = j.parent == null ? absPos : currentAbsPose[j.parent.index];
			ctx.engine.line(mp._41, mp._42, mp._43, m._41, m._42, m._43, j.parent == null ? 0xFF0000FF : 0xFFFFFF00);
			ctx.engine.point(m._41, m._42, m._43, j.bindIndex < 0 ? 0xFF0000FF : 0xFFFF0000);
		}
	}
	
	
}