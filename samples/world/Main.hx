class Main extends hxd.App {

	var world : h3d.scene.World;

	override function init() {
		world = new h3d.scene.World(64, 128, s3d);
		var t = world.loadModel(hxd.Res.tree);
		var r = world.loadModel(hxd.Res.rock);

		for( i in 0...1000 )
			world.add(Std.random(2) == 0 ? t : r, Math.random() * 100, Math.random() * 100, 0);

		s3d.camera.pos.set(0, 0, 120);
		s3d.camera.target.set(64, 64, 0);

		world.done();
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}