class GpuParticles extends SampleApp {

	var parts : h3d.parts.GpuParticles;

	override function init() {
		super.init();
		parts = new h3d.parts.GpuParticles(s3d);

		var g = new h3d.parts.GpuParticles.GpuPartGroup();

		g.emitMode = Cone;
		g.emitAngle = 0.5;

		g.fadeIn = 0.1;
		g.fadeOut = 0.2;
		g.gravity = 1;
		g.size = 0.1;
		g.sizeRand = 0.5;

		g.rotSpeed = 10;

		g.speed = 2;
		g.speedRand = 0.5;

		g.life = 2;
		g.lifeRand = 0.5;
		//g.sortMode = Dynamic;
		g.nparts = 10000;
		g.displayedParts = g.nparts;

		addSlider("Parts", 0, 10000, function() return g.displayedParts, function(v) g.displayedParts = Std.int(v));

		parts.addGroup(g);
		new h3d.scene.CameraController(20, s3d);

	}

	/*
	var time = 0.;

	override function update(dt:Float) {
		time += dt;
		parts.x = Math.cos(time) * 2;
		parts.y = Math.sin(time) * 2;
	}*/

	static function main() {
		new GpuParticles();
	}

}