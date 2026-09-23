class TimedSSR extends h3d.pass.SSR {

	public var timer : BenchApp.BenchGpuTimer;

	override function apply( r : h3d.scene.pbr.Renderer ) {
		if( timer != null ) timer.begin();
		super.apply(r);
		if( timer != null ) timer.end();
	}

}

/**
	Test bench for h3d.pass.SSR (the effect behind hide's rfx.hierarchicalSSR): a deterministic scene
	on a floor made of strips of increasing roughness, one view per tracing situation and parameter sweeps.

	Automatic captures to captures/<backend>/ (see BenchApp for the options), tolerance 2 and 32 timed frames by default:
		hl screenSpaceReflection_dx12.hl --auto --make-ref
		hl screenSpaceReflection_dx12.hl --auto
	GPU timers: frame and ssr. NoSSR gives the frame time without the effect.
	SSR uses a compute shader: DX12, or GL 4.3 in the hl build. Not available in WebGL.
**/
class ScreenSpaceReflection extends BenchApp {

	static inline var SEED = 1234;
	static var STRIP_ROUGHNESS = [0., 0.1, 0.25, 0.5, 0.8];
	static inline var STRIP_WIDTH = 8;

	var ssr : TimedSSR;
	var defaults = new h3d.pass.SSR();
	var info : h2d.Text;

	override function init() {
		tolerance = 2;
		timingFrames = 32;
		super.init();

		#if js
		addText("SSR bench needs compute shaders, not available in WebGL");
		return;
		#end

		buildScene();
		ssr = new TimedSSR();
		ssr.timer = addGpuTimer("ssr");
		renderer().effects.push(ssr);

		buildViews();
		startBench();
		if( !autoMode )
			buildUI();
	}

	inline function renderer() : h3d.scene.pbr.Renderer {
		return cast s3d.renderer;
	}

	function setProps( m : h3d.scene.Mesh, metalness : Float, roughness : Float ) {
		m.material.mainPass.addShader(new h3d.shader.pbr.PropsValues(metalness, roughness));
	}

	function buildScene() {
		var rnd = new hxd.Rand(SEED);

		var env = new h3d.scene.pbr.Environment(BenchApp.makeCubeMap(64, BenchApp.skyColor), 32, 128, 10);
		env.compute();
		renderer().env = env;

		new h3d.scene.pbr.DirLight(new h3d.Vector(-1, -2, -4), s3d).shadows.mode = None;

		var grid = new h3d.prim.Grid(STRIP_WIDTH, 60, 1, 1);
		grid.addNormals();
		grid.addUVs();
		for( i in 0...STRIP_ROUGHNESS.length ) {
			var floor = new h3d.scene.Mesh(grid, s3d);
			floor.material.color.set(0.8, 0.8, 0.8);
			floor.material.castShadows = false;
			setProps(floor, 1, STRIP_ROUGHNESS[i]);
			floor.x = -20 + i * STRIP_WIDTH;
			floor.y = -30;
		}

		var box = new h3d.prim.Cube(1, 1, 1, true);
		box.unindex();
		box.addNormals();
		var wall = new h3d.scene.Mesh(box, s3d);
		wall.material.color.set(0.9, 0.9, 0.9);
		wall.scaleX = 0.4;
		wall.scaleY = 50;
		wall.scaleZ = 14;
		wall.setPosition(21, 0, 7);
		setProps(wall, 1, 0);

		for( i in 0...20 ) {
			var m = new h3d.scene.Mesh(box, s3d);
			m.material.color.set(0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8);
			setProps(m, 0, 0.6);
			m.scale(1.5 + rnd.rand() * 3);
			m.scaleZ = m.scaleX * (1 + rnd.rand() * 2);
			m.setRotation(0, 0, rnd.rand() * Math.PI * 2);
			m.setPosition(rnd.srand(18), 8 + rnd.rand() * 20, m.scaleZ * 0.5);
		}

		var sphere = new h3d.prim.Sphere(1, 32, 24);
		sphere.addNormals();
		for( i in 0...8 ) {
			var m = new h3d.scene.Mesh(sphere, s3d);
			m.material.color.set(0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8);
			setProps(m, 0, 0.3);
			m.scale(1 + rnd.rand() * 1.5);
			m.setPosition(rnd.srand(18), 2 + rnd.rand() * 10, m.scaleX + rnd.rand() * 3);
		}

		var pole = new h3d.prim.Cylinder(12, 0.15, 10);
		pole.addNormals();
		for( i in 0...12 ) {
			var m = new h3d.scene.Mesh(pole, s3d);
			m.material.color.set(0.9, 0.3 + rnd.rand() * 0.4, 0.1);
			setProps(m, 0, 0.4);
			m.setPosition(-18 + i * 3.3, -8 + rnd.srand(1), 0);
		}

		s3d.camera.zNear = 1;
		s3d.camera.zFar = 300;
	}

	// ---- Views

	function setParams( ?steps : Int, ?depthTolerance : Float, ?margin : Float, ?distanceBias : Float ) {
		if( steps != null ) ssr.stepCount = steps;
		if( depthTolerance != null ) ssr.depthTolerance = depthTolerance;
		if( margin != null ) ssr.marginSize = margin;
		if( distanceBias != null ) ssr.distanceBias = distanceBias;
	}

	function roughnessCamera() setCamera(0, -45, 18, 0, 10, 0, 60);
	function thinCamera() setCamera(2, -24, 5, 0, 0, 1, 60);
	function edgeCamera() setCamera(0, -12, 26, 0, 12, 0, 60);

	override function resetState() {
		ssr.enabled = true;
		ssr.stepCount = defaults.stepCount;
		ssr.fadeInExponent = defaults.fadeInExponent;
		ssr.fadeOutExponent = defaults.fadeOutExponent;
		ssr.depthTolerance = defaults.depthTolerance;
		ssr.distanceBias = defaults.distanceBias;
		ssr.distancePowerBias = defaults.distancePowerBias;
		ssr.marginSize = defaults.marginSize;
		ssr.debugEnabled = false;
		s3d.camera.orthoBounds = null;
		roughnessCamera();
	}

	function buildViews() {
		addView("NoSSR", () -> ssr.enabled = false);
		addView("Mirror", () -> setCamera(-16, -40, 8, -16, 15, 2, 60));
		addView("Roughness", () -> {});
		addView("Grazing", () -> setCamera(0, -45, 2.5, 0, 20, 2, 60));
		addView("Wall", () -> setCamera(-8, -30, 9, 21, 8, 5, 60));
		addView("ScreenEdge", edgeCamera);
		addView("Thin", thinCamera);
		addView("Ortho", () -> {
			setCamera(0, -45, 30, 0, 5, 0);
			s3d.camera.orthoBounds = h3d.col.Bounds.fromValues(-32, -24, 1, 64, 48, 200);
		});

		for( steps in [8, 16, 32, 64] )
			addView("Steps_" + steps, () -> setParams(steps));
		for( t in [0.1, 0.5, 2.] )
			addView("DepthTol_" + floatName(t), () -> { thinCamera(); setParams(null, t); });
		for( margin in [0., 0.1, 0.3] )
			addView("Margin_" + floatName(margin), () -> { edgeCamera(); setParams(null, null, margin); });
		for( bias in [0., 1.] )
			addView("DistBias_" + floatName(bias), () -> setParams(null, null, null, bias));
	}

	static function floatName( v : Float ) {
		return StringTools.replace("" + v, ".", "p");
	}

	// ---- Interactive

	function buildUI() {
		addCheck("SSR", () -> ssr.enabled, b -> ssr.enabled = b);
		addSlider("Steps", () -> ssr.stepCount, v -> ssr.stepCount = Std.int(v), 1, 64);
		addSlider("Fade in exp", () -> ssr.fadeInExponent, v -> ssr.fadeInExponent = v, 0, 4);
		addSlider("Fade out exp", () -> ssr.fadeOutExponent, v -> ssr.fadeOutExponent = v, 0, 8);
		addSlider("Depth tol", () -> ssr.depthTolerance, v -> ssr.depthTolerance = v, 0, 4);
		addSlider("Dist bias", () -> ssr.distanceBias, v -> ssr.distanceBias = v, 0, 4);
		addSlider("Dist pow bias", () -> ssr.distancePowerBias, v -> ssr.distancePowerBias = v, 0, 4);
		addSlider("Margin", () -> ssr.marginSize, v -> ssr.marginSize = v, 0, 1);
		addCheck("Debug", () -> ssr.debugEnabled, b -> ssr.debugEnabled = b);
		addButton("Reset view", () -> applyView(currentView));
		info = addText();
	}

	override function update( dt : Float ) {
		super.update(dt);
		if( info == null ) return;
		info.text = BenchApp.BACKEND + " | " + currentView.name
			+ "\nGPU: " + gpuTimesText() + "  FPS: " + Std.int(engine.fps);
	}

	static function main() {
		#if hlsdl
		h3d.impl.GlDriver.enableComputeShaders();
		#end
		h3d.mat.MaterialSetup.current = new h3d.mat.PbrMaterialSetup();
		new ScreenSpaceReflection();
	}

}
