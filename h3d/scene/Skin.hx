package h3d.scene;

class Skin extends Object {
	
	var skinData : h3d.prim.Skin;
	var currentRelPose : Array<h3d.Matrix>;
	var currentAbsPose : Array<h3d.Matrix>;
	
	public var showJoints : Bool;
	
	public function setSkinData( s ) {
		showJoints = true;
		skinData = s;
		currentRelPose = [];
		for( j in skinData.boundJoints ) {
			var m = h3d.Matrix.I();
			if( j.defRotate != null )
				m.initRotate(j.defRotate.x, j.defRotate.y, j.defRotate.z);
			if( j.defScale != null )
				m.scale(j.defScale.x, j.defScale.y, j.defScale.z);
			if( j.defTrans != null )
				m.translate(j.defTrans.x, j.defTrans.y, j.defTrans.z);
			currentRelPose.push(j.relPos);
		}
		currentAbsPose = [];
		for( i in 0...skinData.boundJoints.length )
			currentAbsPose.push(h3d.Matrix.I());
	}
	
	override function draw( ctx : RenderContext ) {
		for( j in skinData.boundJoints ) {
			var m = currentAbsPose[j.bindId];
			if( j.parent == null )
				m.multiply3x4(currentRelPose[j.bindId], absPos);
			else
				m.multiply3x4(currentRelPose[j.bindId], currentAbsPose[j.parent.bindId]);
		}
		if( showJoints )
			ctx.addPass(drawJoints);
	}
	
	function drawJoints( ctx : RenderContext ) {
		for( j in skinData.boundJoints ) {
			var m = currentAbsPose[j.bindId];
			var mp = j.parent == null ? absPos : currentAbsPose[j.parent.bindId];
			ctx.engine.line(mp._41, mp._42, mp._43, m._41, m._42, m._43, j.parent == null ? 0xFF0000FF : 0xFFFFFF00);
			ctx.engine.point(m._41, m._42, m._43, 0xFFFF0000);
		}
	}
	
	
}