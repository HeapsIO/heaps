class GpuParticles extends SampleApp {

	var parts : h3d.parts.GpuParticles;
	var group : h3d.parts.GpuParticles.GpuPartGroup;
	var box : h3d.scene.Box;
	var tf : h2d.Text;
	var moving = false;
	var time = 0.;

	override function init() {
		super.init();
		parts = new h3d.parts.GpuParticles(s3d);

		var g = new h3d.parts.GpuParticles.GpuPartGroup(parts);

		g.emitMode = Cone;
		g.emitAngle = 0.5;
		g.emitDist = 0;

		g.fadeIn = 0.8;
		g.fadeOut = 0.8;
		g.fadePower = 10;
		g.gravity = 1;
		g.size = 0.1;
		g.sizeRand = 0.5;

		g.rotSpeed = 10;

		g.speed = 2;
		g.speedRand = 0.5;

		g.life = 2;
		g.lifeRand = 0.5;
		g.nparts = 10000;

		addSlider("Amount", function() return parts.amount, function(v) parts.amount = v);
		addSlider("Speed", function() return g.speed, function(v) g.speed = v, 0, 10);
		addSlider("Gravity", function() return g.gravity, function(v) g.gravity = v, 0, 5);
		addCheck("Sort", function() return g.sortMode == Dynamic, function(v) g.sortMode = v ? Dynamic : None);
		addCheck("Loop", function() return g.emitLoop, function(v) { g.emitLoop = v; if( !v ) parts.currentTime = 0; });
		addCheck("Move", function() return moving, function(v) moving = v);
		addCheck("Relative", function() return g.isRelative, function(v) g.isRelative = v);

		parts.onEnd = function() {
			engine.backgroundColor = 0xFF000080;
			parts.currentTime = 0;
		};
		parts.addGroup(g);
		group = g;

		new h3d.scene.CameraController(20, s3d);
		box = new h3d.scene.Box(0x80404050, parts.bounds, parts);

		tf = addText();
	}



	override function update(dt:Float) {

		if( moving ) {
			time += dt * 0.6;
			parts.x = Math.cos(time) * 5;
			parts.y = Math.sin(time) * 5;
		}

		if( engine.backgroundColor&0xFFFFFF > 0 )
			engine.backgroundColor -= 8;

		var cur = @:privateAccess group.currentParts;
		tf.text = ("cur=" + Std.int(cur * 100 / group.nparts) + "%");
		if( parts.uploadedCount > 0 )
			tf.text += " U="+parts.uploadedCount;
	}

	static function main() {
		new GpuParticles();
	}

}