import h3d.scene.*;

class Main extends hxd.App {

	override function init() {
		var prim = hxd.Res.Model.toHmd();
		var obj = prim.makeObject(loadTexture);
		obj.scale(0.1);
		s3d.addChild(obj);
		s3d.camera.pos.set( -2, -3, 2);
		s3d.camera.target.z += 1;

		obj.playAnimation(prim.loadAnimation(LinearAnim));

		// add lights
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		for( m in obj.getMaterials() ) {
			var t = m.mainPass.getShader(h3d.shader.Texture);
			if( t != null ) t.killAlpha = true;
			m.mainPass.enableLights = true;
			m.shadows = true;
		}
		s3d.lightSystem.ambientLight.set(0.4, 0.4, 0.4);

		var shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.lightDirection = dir.direction;
		shadow.power = 50;
	}

	function loadMaterial( name : String, _ ) {
		var name = name.split("\\").pop();
		return new h3d.mat.MeshMaterial(loadTexture(name));
	}

	function loadTexture( name : String ) {
		name = name.split("/").pop();
		return hxd.Res.load(name).toTexture();
	}

	static function main() {
		hxd.Res.initEmbed({ createHMD : true });
		new Main();
	}

}
