import h3d.scene.*;

class Main extends hxd.App {
	
	override function init() {
		var prim = hxd.Res.Model.toFbx();
		var obj = prim.makeObject(loadTexture);
		obj.scale(0.05);
		s3d.addChild(obj);
		s3d.camera.pos.z -= 2;
		s3d.camera.target.z += 0.5;
		
//		obj.playAnimation(prim.loadAnimation(LinearAnim));
	}
	
	function loadTexture( name : String, _ ) {
		name = name.split("\\").pop();
		var m = new h3d.mat.MeshMaterial(hxd.Res.load(name).toTexture());
		m.mainPass.culling = None;
		m.texture.filter = Nearest;
		m.mainPass.addShader(new h3d.shader.AlphaKill());
		return m;
	}
	
	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
	
}
