class Main extends hxd.App {

	var world : h3d.scene.World;
	var shadow :h3d.pass.ShadowMap;

	override function init() {

		world = new h3d.scene.World(64, 128, s3d);
		var t = world.loadModel(hxd.Res.tree);
		var r = world.loadModel(hxd.Res.rock);

		for( i in 0...1000 )
			world.add(Std.random(2) == 0 ? t : r, Math.random() * 128, Math.random() * 128, 0, 1.2 + hxd.Math.srand(0.4), hxd.Math.srand(Math.PI));

		world.done();

		//
		new h3d.scene.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		s3d.lightSystem.ambientLight.setColor(0x909090);

		s3d.camera.target.set(72, 72, 0);
		s3d.camera.pos.set(120, 120, 120);

		shadow = Std.instance(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.size = 2048;
		shadow.power = 200;
		shadow.blur.passes = 0;
		shadow.bias *= 0.1;
		shadow.color.set(0.7, 0.7, 0.7);
		shadow.calcShadowBounds = function(cam) {
			cam.orthoBounds = h3d.col.Bounds.fromValues( -128, -128, -64, 256, 256, 128);
		};
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}