import hxd.Key in K;

class WorldMesh extends h3d.scene.World {

	override function initChunkSoil(c:h3d.scene.World.WorldChunk) {
		var cube = new h3d.prim.Cube(chunkSize, chunkSize, 0);
		cube.addNormals();
		cube.addUVs();
		var soil = new h3d.scene.Mesh(cube, c.root);
		soil.x = c.x;
		soil.y = c.y;
		soil.material.texture = h3d.mat.Texture.fromColor(0x408020);
		soil.material.shadows = true;
	}

}

class World extends hxd.App {

	var world : h3d.scene.World;
	var shadow :h3d.pass.DefaultShadowMap;
	var tf : h2d.Text;

	override function init() {

		world = new WorldMesh(16, s3d);
		var t = world.loadModel(hxd.Res.tree);
		var r = world.loadModel(hxd.Res.rock);

		for( i in 0...1000 )
			world.add(Std.random(2) == 0 ? t : r, Math.random() * 128, Math.random() * 128, 0, 1.2 + hxd.Math.srand(0.4), hxd.Math.srand(Math.PI));

		world.done();

		//
		new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		s3d.lightSystem.ambientLight.setColor(0x909090);

		s3d.camera.target.set(72, 72, 0);
		s3d.camera.pos.set(120, 120, 40);

		shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.size = 2048;
		shadow.power = 200;
		shadow.blur.radius= 0;
		shadow.bias *= 0.1;
		shadow.color.set(0.7, 0.7, 0.7);


		//
		var parts = new h3d.parts.GpuParticles(world);
		var g = parts.addGroup();
		g.size = 0.2;
		g.gravity = 1;
		g.life = 10;
		g.nparts = 10000;
		g.emitMode = CameraBounds;
		parts.volumeBounds = h3d.col.Bounds.fromValues( -20, -20, 15, 40, 40, 40);

		s3d.camera.zNear = 1;
		s3d.camera.zFar = 100;
		new h3d.scene.CameraController(s3d).loadFromCamera();

		tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
	}

	override function update(dt:Float) {
		tf.text = ""+engine.drawCalls;
	}

	static function main() {
		hxd.Res.initEmbed();
		new World();
	}

}