import h3d.scene.*;

class Main extends hxd.App {

	var cache : h3d.prim.ModelCache;

	override function init() {
		cache = new h3d.prim.ModelCache();

		var obj = cache.loadModel(hxd.Res.Model);
		obj.scale(0.1);
		s3d.addChild(obj);
		s3d.camera.pos.set( -3, -5, 3);
		s3d.camera.target.z += 1;

		obj.playAnimation(cache.loadAnimation(hxd.Res.Model));

		// add lights and setup materials
		var dir = new DirLight(new h3d.Vector( -1, 3, -10), s3d);
		for( m in obj.getMaterials() ) {
			var t = m.mainPass.getShader(h3d.shader.Texture);
			if( t != null ) t.killAlpha = true;
			m.mainPass.culling = None;
			m.getPass("shadow").culling = None;
		}
		s3d.lightSystem.ambientLight.set(0.4, 0.4, 0.4);

		var shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.power = 20;
		dir.enableSpecular = true;

		#if castle
		// this is an example for connecting to scene inspector
		// and enable extra properties
		// this requires to compile with -lib castle and run CDB
		var i = new hxd.inspect.Inspector(s3d);

		var delta = s3d.camera.pos.sub(s3d.camera.target);
		delta.z = 0;
		var angle = Math.atan2(delta.y, delta.x);
		var dist = delta.length();

		// add node to scene graph
		var n = i.scenePanel.addNode("Rotation", "repeat", function() {
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
						var j = new hxd.inspect.Panel(null,"New Panel");
						j.content.text("Nothing to see there.");
						j.show();
					});
					return j;
				})
			];
		});
		i.scenePanel.addNode("Test", "", n);
		i.addTool("Exit", "bomb", function() {
			hxd.System.exit();
		});
		#end
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}
