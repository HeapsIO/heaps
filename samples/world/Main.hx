import hxd.Key in K;

class Main extends hxd.App {

	var world : h3d.scene.World;
	var shadow :h3d.pass.ShadowMap;
	var mx = 0.;
	var my = 0.;
	var cdist : Float;
	var tdist : Float;

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
		s3d.camera.pos.set(120, 120, 40);

		shadow = Std.instance(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.size = 2048;
		shadow.power = 200;
		shadow.blur.passes = 0;
		shadow.bias *= 0.1;
		shadow.color.set(0.7, 0.7, 0.7);
		shadow.calcShadowBounds = function(cam) {
			cam.orthoBounds = h3d.col.Bounds.fromValues( -128, -128, -64, 256, 256, 128);
		};

		#if castle
		new hxd.inspect.Inspector(s3d);
		#end

		//
		var parts = new h3d.parts.GpuParticles(world);
		var g = parts.addGroup();
		g.size = 0.2;
		g.gravity = 1;
		g.life = 10;
		g.nparts = 10000;
		g.emitMode = CameraBounds;
		parts.volumeBounds = h3d.col.Bounds.fromValues( -20, -20, 15, 40, 40, 40);

		tdist = cdist = s3d.camera.pos.sub(s3d.camera.target).length();
	}

	override function update(dt:Float) {
		var dx = 0, dy = 0;
		if( K.isDown(K.LEFT) ) dx = -1;
		if( K.isDown(K.RIGHT) ) dx = 1;
		if( K.isDown(K.UP) ) dy = -1;
		if( K.isDown(K.DOWN) ) dy = 1;
		if( K.isPressed(K.MOUSE_WHEEL_UP) ) tdist *= 0.9;
		if( K.isPressed(K.MOUSE_WHEEL_DOWN) ) tdist *= 1.1;

		mx *= Math.pow(0.9, dt);
		my *= Math.pow(0.9, dt);

		mx += (dx + dy) * dt * 0.1;
		my += (-dx + dy) * dt * 0.1;
		s3d.camera.pos.x += mx * dt;
		s3d.camera.pos.y += my * dt;
		s3d.camera.target.x += mx * dt;
		s3d.camera.target.y += my * dt;

		var p = Math.pow(0.9, dt);
		cdist = cdist * p + (1 - p) * tdist;
		var d = s3d.camera.pos.sub(s3d.camera.target);
		d.normalize();
		d.scale3(cdist);
		s3d.camera.pos = s3d.camera.target.add(d);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}

}