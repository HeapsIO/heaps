import h3d.scene.*;

class Main extends hxd.App {

	override function init() {
		var prim = hxd.Res.Model.toHmd();
		var obj = prim.makeObject(loadTexture);
		obj.scale(0.1);
		s3d.addChild(obj);
		s3d.camera.pos.set( -3, -5, 3);
		s3d.camera.target.z += 1;

		obj.playAnimation(prim.loadAnimation());

		// add lights and setup materials
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		for( m in obj.getMaterials() ) {
			var t = m.mainPass.getShader(h3d.shader.Texture);
			if( t != null ) t.killAlpha = true;
			m.mainPass.enableLights = true;
			m.mainPass.culling = None;
			m.shadows = true;
			m.getPass("shadow").culling = None;
		}
		s3d.lightSystem.ambientLight.set(0.4, 0.4, 0.4);

		var shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.power = 50;
		dir.enableSpecular = true;

		#if castle
		// this is an example for connecting to scene inspector
		// and enable extra properties
		// this requires to compile with -lib castle and run CDB
		var i = new hxd.net.SceneInspector(s3d);

		var delta = s3d.camera.pos.sub(s3d.camera.target);
		delta.z = 0;
		var angle = Math.atan2(delta.y, delta.x);
		var dist = delta.length();

		// add node to scene graph
		var n = i.addNode("Rotation", "repeat", function() {
			return [
				PFloat("v", function() return angle, function(v) {
					angle = v;
					s3d.camera.pos.x = Math.cos(angle) * dist;
					s3d.camera.pos.y = Math.sin(angle) * dist;
				}),
				PCustom("", function() {
					var j = i.J("<button>");
					j.text("Click Me!");
					j.click(function(_) {
						var j = i.createPanel("New Panel");
						j.text("Nothing to see there.");
					});
					return j;
				})
			];
		});
		i.addNode("Test", "", n);
		i.addTool("Exit", "bomb", function() {
			hxd.System.exit();
		});
		#end
	}

	function loadTexture( name : String ) {
		name = name.split("/").pop();
		return hxd.Res.load(name).toTexture();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}
