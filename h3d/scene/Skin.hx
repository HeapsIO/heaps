package h3d.scene;

class Skin extends Mesh {
	
	var skinData : h3d.prim.Skin;
	var currentRelPose : Array<h3d.Matrix>;
	var currentAbsPose : Array<h3d.Matrix>;
	var currentPalette : Array<h3d.Matrix>;

	public var showJoints : Bool;
	
	public function new(s, ?mat, ?parent) {
		super(null, mat, parent);
		if( s != null )
			setSkinData(s);
	}
	
	override function getObjectByName( name : String ) {
		var o = super.getObjectByName(name);
		if( o != null ) return o;
		// create a fake object targeted at the bone, not persistant but matrixes are shared
		if( skinData != null )
			for( j in skinData.allJoints )
				if( j.name == name ) {
					var o = new Object();
					o.parent = this;
					o.absPos = currentAbsPose[j.index];
					o.defaultTransform = currentRelPose[j.index];
					return o;
				}
		return null;
	}
	
	public function setSkinData( s ) {
		skinData = s;
		primitive = s.primitive;
		currentRelPose = [];
		currentAbsPose = [];
		currentPalette = [];
		for( j in skinData.allJoints ) {
			currentRelPose.push(h3d.Matrix.I());
			currentAbsPose.push(h3d.Matrix.I());
		}
		for( i in 0...skinData.boundJoints.length )
			currentPalette.push(h3d.Matrix.I());
	}
	
	override function draw( ctx : RenderContext ) {
		for( j in skinData.allJoints ) {
			var id = j.index;
			var m = currentAbsPose[id];
			if( j.parent == null )
				m.multiply(currentRelPose[id], absPos);
			else
				m.multiply(currentRelPose[id], currentAbsPose[j.parent.index]);
			var bid = j.bindIndex;
			if( bid >= 0 )
				currentPalette[bid].multiply(j.transPos, m);
		}
		material.skinMatrixes = currentPalette;
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