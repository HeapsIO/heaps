typedef LightPreset = {
	var name : String;
	var lights : Array<h3d.scene.pbr.Light>;
	// this preset can cast shadows, so its views are captured with every sampling kind
	var shadows : Bool;
}

/**
	Test bench for forward lighting: the same deterministic scene, one view per light type,
	rendered with deferred and forward materials and compared against references.

	Interactive: the View choice picks the light preset, the other controls switch forward/deferred,
	shadows, sampling kind and transparents.

	Automatic captures to captures/<backend>/ (see BenchApp for the common options: --only, --make-ref, --out...):
		hl pbrLights_dx12.hl --auto --make-ref   // capture every state as reference
		hl pbrLights_dx12.hl --auto              // capture every state and compare, exit code 1 on differences
		--tolerance N                            // max per-channel difference (0-255) still considered equal, default 2
	Every view captures deferred then forward for each sampling kind, named <preset>_<mode>[_<sampling>], and also writes
	the forward vs deferred difference to captures/<backend>/parity/ (informational, never fails).
	--only takes the view names with spaces replaced by underscores (Many_points), not the capture names.
**/
class PbrLights extends BenchApp {

	static inline var SEED = 1234;

	var presets : Array<LightPreset> = [];
	var curPreset = 0;
	var forward = true;
	var shadows = true;
	var sampling : h3d.pass.Shadows.ShadowSamplingKind = PCF;
	var showTransparents = false;
	var transparents : Array<h3d.scene.Mesh> = [];
	var info : h2d.Text;

	override function init() {
		tolerance = 2;
		super.init();

		#if js
		if( !engine.driver.hasFeature(ShaderModel3) ) {
			addText("WebGL 2.0 support required and not available on this browser.");
			return;
		}
		#end

		buildScene();
		buildLights();
		buildViews();
		startBench();
		if( !autoMode )
			buildUI();
	}

	function buildScene() {
		var rnd = new hxd.Rand(SEED);

		var grid = new h3d.prim.Grid(100, 100, 1, 1);
		grid.addNormals();
		grid.addUVs();
		var floor = new h3d.scene.Mesh(grid, s3d);
		floor.material.castShadows = false;
		floor.x = -50;
		floor.y = -50;

		var box = new h3d.prim.Cube(1, 1, 1, true);
		box.unindex();
		box.addNormals();
		for( i in 0...40 ) {
			var m = new h3d.scene.Mesh(box, s3d);
			m.material.color.set(0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8);
			m.scale(1 + rnd.rand() * 6);
			m.z = m.scaleX * 0.5;
			m.setRotation(0, 0, rnd.rand() * Math.PI * 2);
			do {
				m.x = rnd.random(80) - 40;
				m.y = rnd.random(80) - 40;
			} while( m.x * m.x + m.y * m.y < 25 + m.scaleX * m.scaleX );
		}

		var sphere = new h3d.prim.Sphere(1, 32, 24);
		sphere.addNormals();
		for( i in 0...12 ) {
			var m = new h3d.scene.Mesh(sphere, s3d);
			m.material.color.set(0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8, 0.2 + rnd.rand() * 0.8);
			m.scale(1 + rnd.rand() * 2);
			m.x = rnd.srand(30);
			m.y = rnd.srand(30);
			m.z = m.scaleX + rnd.rand() * 4;
		}

		for( i in 0...6 ) {
			var m = new h3d.scene.Mesh(sphere, s3d);
			m.material.color.set(0.3 + rnd.rand() * 0.7, 0.3 + rnd.rand() * 0.7, 0.3 + rnd.rand() * 0.7, 0.4);
			var props : h3d.mat.PbrMaterial.PbrProps = m.material.props;
			props.blend = Alpha;
			props.shadows = false;
			m.material.props = props;
			m.scale(2);
			m.x = -15 + i * 6;
			m.y = 5;
			m.z = 6;
			transparents.push(m);
		}

		// The orbit controller sets these interactively, auto mode needs them : the default 0.02 near plane
		// wastes the depth precision the deferred pass reads back
		s3d.camera.zNear = 1;
		s3d.camera.zFar = 500;
	}

	function buildLights() {
		var dir = new h3d.scene.pbr.DirLight(new h3d.Vector(-1, -2, -4), s3d);
		var cascade = new h3d.scene.pbr.DirLight(new h3d.Vector(-1, -2, -4), s3d, true);
		var cascadeShadows = cast(cascade.shadows, h3d.pass.CascadeShadowMap);
		var cascadeCount = 2;
		cascadeShadows.cascade = cascadeCount;
		for( i in 0...cascadeCount )
			cascadeShadows.params[i] = { depthBias : 1.0, slopeBias : 2.0 };
		cascadeShadows.firstCascadeSize = 20.0;
		cascadeShadows.maxDist = 100.0;
		cascadeShadows.transitionFraction = 0.15;

		var point = new h3d.scene.pbr.PointLight(s3d);
		point.setPosition(0, 0, 15);
		point.range = 40;
		point.power = 4.5;
		point.shadows.bias = 0.1;

		var spot = new h3d.scene.pbr.SpotLight(s3d);
		spot.setPosition(-30, -30, 30);
		spot.setDirection(new h3d.Vector(1, 2, -5));
		spot.range = 70;
		spot.angle = 70;
		spot.power = 3.2;
		spot.shadows.bias = 0.001;

		var capsule = new h3d.scene.pbr.CapsuleLight(s3d);
		capsule.setPosition(10, -10, 8);
		capsule.setDirection(new h3d.Vector(1, 1, 0));
		capsule.length = 12;
		capsule.radius = 0.5;
		capsule.range = 30;
		capsule.power = 4.5;
		capsule.shadows.bias = 0.0001;

		var rect = new h3d.scene.pbr.RectangleLight(s3d);
		rect.setPosition(-25, 10, 12);
		rect.setDirection(new h3d.Vector(1, -0.5, -0.6));
		rect.width = 10;
		rect.height = 5;
		rect.horizontalAngle = 120;
		rect.verticalAngle = 120;
		rect.range = 50;
		rect.power = 3.2;
		rect.shadows.bias = 0.001;

		addPreset("Dir", true, [dir]);
		addPreset("Cascade", true, [cascade]);
		addPreset("Point", true, [point]);
		addPreset("Spot", true, [spot]);
		addPreset("Capsule", true, [capsule]);
		addPreset("Rectangle", true, [rect]);
		addPreset("Mixed", true, [dir, point, spot, capsule, rect]);

		var rnd = new hxd.Rand(SEED + 1);
		var many : Array<h3d.scene.pbr.Light> = [];
		for( x in 0...8 ) {
			for( y in 0...8 ) {
				var l = new h3d.scene.pbr.PointLight(s3d);
				l.setPosition(-42 + x * 12, -42 + y * 12, 3);
				l.range = 12;
				l.color.set(0.3 + rnd.rand() * 0.7, 0.3 + rnd.rand() * 0.7, 0.3 + rnd.rand() * 0.7);
				l.power = 2.8;
				many.push(l);
			}
		}
		addPreset("Many points", false, many);
	}

	function addPreset( name : String, shadows : Bool, lights : Array<h3d.scene.pbr.Light> ) {
		presets.push({ name : name, lights : lights, shadows : shadows });
	}

	function applyPreset() {
		var preset = presets[curPreset];
		for( p in presets )
			for( l in p.lights )
				l.visible = false;
		for( l in preset.lights ) {
			l.visible = true;
			l.shadows.mode = preset.shadows && shadows ? Dynamic : None;
			l.shadows.samplingKind = sampling;
		}
		for( m in transparents )
			m.visible = showTransparents;
		for( mat in s3d.getMaterials() ) {
			var pbr = Std.downcast(mat, h3d.mat.PbrMaterial);
			if( pbr == null ) continue;
			var props : h3d.mat.PbrMaterial.PbrProps = pbr.props;
			if( props == null || (props.mode != PBR && props.mode != Forward) ) continue;
			props.mode = forward ? Forward : PBR;
			pbr.props = props;
		}
	}

	function samplingName() {
		return switch( sampling ) {
		case None: "none";
		case ESM: "esm";
		case PCF: "pcf";
		}
	}

	// Capture name of the current state, a view captures several of them
	function presetName() {
		var preset = presets[curPreset];
		var name = preset.name.split(" ").join("") + "_" + (forward ? "forward" : "deferred");
		if( preset.shadows )
			name += shadows ? "_" + samplingName() : "_noshadow";
		if( showTransparents )
			name += "_alpha";
		return name;
	}

	override function resetState() {
		forward = true;
		shadows = true;
		sampling = PCF;
		showTransparents = false;
		setCamera(70, 45, 55, 0, 0, 0, 60);
	}

	function buildViews() {
		for( i in 0...presets.length )
			addPresetView(i);
	}

	function addPresetView( p : Int ) {
		addView(presets[p].name, () -> { curPreset = p; applyPreset(); }, { run : _ -> runPreset(p) });
	}

	// Deferred then forward for each sampling kind, comparing the two modes with each other along the way
	function runPreset( p : Int ) {
		var deferredPix : hxd.Pixels = null;
		function queue( fwd : Bool, kind : h3d.pass.Shadows.ShadowSamplingKind ) {
			call(function() {
				forward = fwd;
				sampling = kind;
				applyPreset();
			});
			renderFrames(warmupFrames);
			capture(function(pix) {
				saveCapture(presetName(), pix);
				if( !fwd ) {
					deferredPix = pix;
					return;
				}
				var name = presetName().split("_forward").join("") + "_forward_vs_deferred";
				var d = diffPixels(deferredPix, pix, 8);
				report("  " + name + ": max " + d.maxDiff + ", " + d.count + " px above " + tolerance);
				savePng(outDir + "/parity/" + name + ".png", d.image);
			});
		}
		var kinds : Array<h3d.pass.Shadows.ShadowSamplingKind> = presets[p].shadows ? [None, ESM, PCF] : [PCF];
		for( k in kinds )
			for( fwd in [false, true] )
				queue(fwd, k);
	}

	function buildUI() {
		addCheck("Forward", () -> forward, function(b) { forward = b; applyPreset(); });
		addCheck("Shadows", () -> shadows, function(b) { shadows = b; applyPreset(); });
		var kinds : Array<h3d.pass.Shadows.ShadowSamplingKind> = [None, ESM, PCF];
		addChoice("Sampling", ["None", "ESM", "PCF"], function(i) { sampling = kinds[i]; applyPreset(); }, kinds.indexOf(sampling));
		addCheck("Alpha", () -> showTransparents, function(b) { showTransparents = b; applyPreset(); });
		addButton("Reset view", () -> applyView(currentView));
		info = addText();
	}

	override function update( dt : Float ) {
		super.update(dt);
		if( info == null ) return;
		info.text = BenchApp.BACKEND + " | " + (forward ? "forward" : "deferred") + " | " + presets[curPreset].name
			+ "\nDraw calls: " + engine.drawCalls + "  FPS: " + Std.int(engine.fps);
	}

	static function main() {
		h3d.mat.MaterialSetup.current = new h3d.mat.PbrMaterialSetup();
		new PbrLights();
	}

}
