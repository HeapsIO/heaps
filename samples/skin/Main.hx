import h3d.scene.*;

class Main extends hxd.App {

	override function init() {
		var prim = hxd.Res.Model.toFbx();
		var obj = prim.makeObject(loadTexture);
		obj.scale(0.1);
		s3d.addChild(obj);
		s3d.camera.pos.set( -2, -3, 2);
		s3d.camera.target.z += 1;

		obj.playAnimation(prim.loadAnimation(LinearAnim));

		// add lights
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		for( s in obj )
			s.toMesh().material.mainPass.enableLights = true;
		var ls = s3d.mainPass.getLightSystem();
		ls.ambientLight.set(0.4, 0.4, 0.4);
		ls.perPixelLighting = true;

		// add self shadowing
		for( s in obj )
			s.toMesh().material.shadows = true;

		var shadow = cast(s3d.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.lightDirection = dir.direction;
		shadow.power = 50;
	}

	function loadTexture( name : String, _ ) {
		name = name.split("\\").pop();
		var m = new h3d.mat.MeshMaterial(hxd.Res.load(name).toTexture());
		m.mainPass.culling = None;
		m.texture.filter = Nearest;
		m.mainPass.getShader(h3d.shader.Texture).killAlpha = true;
		return m;
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}
