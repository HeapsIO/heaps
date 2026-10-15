/**
	Base class for test bench samples: a list of named views, an interactive mode to browse them,
	and an automatic mode that renders a script per view, captures PNGs and compares them with references.

	Common command line (hl build only):
		--auto                 run every view and exit (0 = ok, 1 = differs from reference, 2 = render error)
		--only view1,view2     restrict to these views (spaces in names become underscores)
		--list                 print view names and exit
		--out dir              captures directory, default captures/<backend>
		--make-ref             save captures as references in <out>/ref/ instead of comparing
		--tolerance N          channel difference (0..255) ignored when comparing with references
		--timing-frames N      after each capture, time N frames on the GPU into <out>/gpu_times.csv (0 = off, the default)

	Minimal bench:
		class MyBench extends BenchApp {
			override function init() {
				super.init();
				// build scene...
				addView("default", () -> {});
				addView("rough", () -> props.roughnessValue = 0.5);
				startBench();
			}
			override function resetState() { props.roughnessValue = 0.1; setCamera(-10, -10, 4, 0, 0, 0); }
		}

	Auto mode runs a script per view. The default script renders warmupFrames frames then calls captureView,
	which saves <out>/<view>.png and compares it with <out>/ref/<view>.png. Pass `run` to addView (or override runView)
	to write custom scripts with renderFrames / capture / captureAccumulated / call. Steps queued from inside a step
	run right after it, so scripts read in order.
	Every step renders the scene once per engine frame, so TAA and velocity history advance like in a real game.

	GPU timing: the whole frame is always timed ("frame"), addGpuTimer(name) adds a timer that the bench wraps around
	its own work with begin() / end(). With --timing-frames N (or timingFrames set before super.init), each view is
	timed after its capture: median and min of every timer are printed and saved to <out>/gpu_times.csv. Timings never fail.
	Interactive mode times every frame, gpuTimesText() gives the current values to display.
**/

typedef BenchView = {
	var name : String;
	// name used for files and --only
	var file : String;
	// applied after resetState
	var setup : Void -> Void;
	// called with the frame index before each frame, null for static views
	var animate : Null<Int -> Void>;
	// interactive loop length and default auto script length for animated views
	var frames : Int;
	var run : Null<BenchView -> Void>;
}

typedef BenchDiff = {
	// largest channel difference
	var maxDiff : Int;
	// pixels with a channel difference above the tolerance
	var count : Int;
	// mean absolute channel difference
	var mae : Float;
	// |a - b| * scale
	var image : hxd.Pixels;
}

class BenchGpuTimer {

	public var name(default, null) : String;
	public var active = false;
	public var samples : Array<Float> = [];
	public var idle = 0;

	var driver : h3d.impl.Driver;
	var free : Array<h3d.impl.Driver.Query> = [];
	var pending : Array<h3d.impl.Driver.Query> = [];
	var started : h3d.impl.Driver.Query;

	public function new( name : String ) {
		this.name = name;
		driver = h3d.Engine.getCurrent().driver;
	}

	function stamp() {
		var q = free.length > 0 ? free.pop() : driver.allocQuery(TimeStamp);
		driver.endQuery(q);
		return q;
	}

	public function begin() {
		if( !active ) return;
		started = stamp();
		idle = 0;
	}

	public function end() {
		if( started == null ) return;
		pending.push(started);
		pending.push(stamp());
		started = null;
	}

	public function poll() {
		idle++;
		while( pending.length >= 2 && driver.queryResultAvailable(pending[0]) && driver.queryResultAvailable(pending[1]) ) {
			var start = pending.shift(), end = pending.shift();
			samples.push((driver.queryResult(end) - driver.queryResult(start)) / 1e6);
			free.push(start);
			free.push(end);
		}
	}

	public function isComplete() {
		return pending.length == 0 && started == null;
	}

	public function median() {
		if( samples.length == 0 ) return Math.NaN;
		var s = samples.copy();
		s.sort(Reflect.compare);
		var h = s.length >> 1;
		return s.length & 1 == 1 ? s[h] : (s[h - 1] + s[h]) * 0.5;
	}

	public function min() {
		if( samples.length == 0 ) return Math.NaN;
		var m = samples[0];
		for( v in samples ) if( v < m ) m = v;
		return m;
	}

}

private class BenchStep {
	public var count : Int;
	public var renders : Bool;
	public var index = 0;
	public var run : (Int, h3d.Engine) -> Void;
	public function new(count, renders, run) {
		this.count = count;
		this.renders = renders;
		this.run = run;
	}
}

class BenchApp extends SampleApp {

	public static var BACKEND = #if dx12 "dx12" #elseif hlsdl "gl" #elseif js "webgl" #else "other" #end;

	var views : Array<BenchView> = [];
	var currentView : BenchView;
	var args : Array<String> = [];

	var autoMode = false;
	var makeRef = false;
	var outDir = "captures/" + BACKEND;
	var tolerance = 0;
	var warmupFrames = 4;
	var failures = 0;

	var useCameraController = true;
	var controller : h3d.scene.CameraController.OrbitCameraController;
	var viewFrame = 0;
	var paused = false;

	var steps : Array<BenchStep> = [];
	var stepInsert = -1;
	var captureTex : h3d.mat.Texture;
	var metricColumns : Array<String>;
	var metricRows : Array<String> = [];

	var timingFrames = 0;
	var gpuTimers : Array<BenchGpuTimer> = [];
	var frameTimer : BenchGpuTimer;
	var gpuTimeRows : Array<String> = [];

	override function init() {
		super.init();
		#if sys
		args = Sys.args();
		#end
		autoMode = hasArg("--auto");
		makeRef = hasArg("--make-ref");
		outDir = getArg("--out", outDir);
		tolerance = getIntArg("--tolerance", tolerance);
		timingFrames = getIntArg("--timing-frames", timingFrames);
		if( !hasGpuTimestamps() )
			timingFrames = 0;
		frameTimer = addGpuTimer("frame");
	}

	// ---- Command line

	function hasArg( name : String ) {
		return args.indexOf(name) >= 0;
	}

	function getArg( name : String, def : String ) {
		var i = args.indexOf(name);
		return i >= 0 && i + 1 < args.length ? args[i + 1] : def;
	}

	function getIntArg( name : String, def : Int ) {
		var v = Std.parseInt(getArg(name, null));
		return v == null ? def : v;
	}

	function getFloatArg( name : String, def : Float ) {
		var v = Std.parseFloat(getArg(name, null));
		return Math.isNaN(v) ? def : v;
	}

	// ---- Views

	function addView( name : String, setup : Void -> Void, ?opts : { ?frames : Int, ?animate : Int -> Void, ?run : BenchView -> Void } ) {
		var v : BenchView = {
			name : name,
			file : StringTools.replace(name, " ", "_"),
			setup : setup,
			animate : opts == null ? null : opts.animate,
			frames : opts == null || opts.frames == null ? 1 : opts.frames,
			run : opts == null ? null : opts.run,
		};
		views.push(v);
		return v;
	}

	// Called before each view setup: put every setting a view may change back to its default
	function resetState() {
	}

	function applyView( v : BenchView, frame = 0 ) {
		currentView = v;
		viewFrame = frame;
		resetState();
		v.setup();
		if( v.animate != null )
			v.animate(frame);
		if( controller != null )
			controller.loadFromCamera();
	}

	function setCamera( x : Float, y : Float, z : Float, tx : Float, ty : Float, tz : Float, ?fovY : Float ) {
		s3d.camera.pos.set(x, y, z);
		s3d.camera.target.set(tx, ty, tz);
		if( fovY != null )
			s3d.camera.fovY = fovY;
		if( controller != null )
			controller.loadFromCamera();
	}

	// Call at the end of init, once the scene and views are built. In interactive mode, adds the view chooser to the UI.
	function startBench() {
		var only = getArg("--only", null);
		if( only != null ) {
			var names = only.split(",");
			views = [for( v in views ) if( names.indexOf(v.file) >= 0 ) v];
		}
		#if sys
		if( hasArg("--list") ) {
			for( v in views )
				Sys.println(v.file);
			Sys.exit(0);
		}
		#end
		if( views.length == 0 )
			throw "No view to run";
		if( autoMode ) {
			fui.visible = false;
			for( v in views ) {
				call(() -> {
					applyView(v);
					onViewStart(v);
				});
				runView(v);
				if( timingFrames > 0 )
					timeView(v.file);
				call(() -> onViewEnd(v));
			}
			call(finishAuto);
			return;
		}
		if( useCameraController )
			controller = new h3d.scene.CameraController.OrbitCameraController(s3d);
		if( views.length > 1 )
			addChoice("View", [for( v in views ) v.name], i -> applyView(views[i]));
		applyView(views[0]);
	}

	// Auto mode script of a view, already applied when the first step runs
	function runView( v : BenchView ) {
		if( v.run != null ) {
			v.run(v);
			return;
		}
		if( v.animate != null )
			renderFrames(v.frames - 1, v.animate);
		else
			renderFrames(warmupFrames);
		captureView(v.file);
	}

	function onViewStart( v : BenchView ) {
	}

	function onViewEnd( v : BenchView ) {
	}

	function finishAuto() {
		saveMetrics();
		saveGpuTimes();
		report(makeRef ? "References saved" : (failures == 0 ? "Done" : failures + " capture(s) differ from reference"));
		#if sys
		Sys.exit(failures == 0 ? 0 : 1);
		#end
	}

	override function update( dt : Float ) {
		if( !autoMode )
			pollGpuTimers();
		if( autoMode || paused || currentView == null || currentView.animate == null )
			return;
		viewFrame = (viewFrame + 1) % currentView.frames;
		currentView.animate(viewFrame);
	}

	// ---- Script steps

	function addStep( s : BenchStep ) {
		if( stepInsert >= 0 )
			steps.insert(stepInsert++, s);
		else
			steps.push(s);
	}

	// Runs f without rendering
	function call( f : Void -> Void ) {
		addStep(new BenchStep(1, false, (_, _) -> f()));
	}

	// Renders count frames, calling before(i) ahead of each one. onPixels(i, pixels) receives frames i >= captureFrom.
	function renderFrames( count : Int, ?before : Int -> Void, ?onPixels : Int -> hxd.Pixels -> Void, captureFrom = 0 ) {
		addStep(new BenchStep(count, true, function(i, e) {
			if( before != null ) before(i);
			var pix = renderScene(e, onPixels != null && i >= captureFrom);
			if( pix != null ) onPixels(i, pix);
		}));
	}

	function capture( onPixels : hxd.Pixels -> Void, ?before : Void -> Void ) {
		renderFrames(1, before == null ? null : _ -> before(), (_, pix) -> onPixels(pix));
	}

	// Averages samples frames rendered with a Halton (2,3) sub-pixel jitter (box filter over the pixel), like converged TAA without motion.
	// setJitter(x, y) receives the projection offset in NDC and must apply it to the camera, it is reset to (0, 0) after the last frame.
	function captureAccumulated( samples : Int, setJitter : Float -> Float -> Void, onPixels : hxd.Pixels -> Void, ?before : Int -> Void ) {
		var sum : haxe.ds.Vector<Int> = null;
		renderFrames(samples, function(i) {
			if( before != null ) before(i);
			setJitter((halton(i + 1, 2) - 0.5) * 2 / engine.width, (halton(i + 1, 3) - 0.5) * 2 / engine.height);
		}, function(i, pix) {
			if( sum == null ) sum = new haxe.ds.Vector<Int>(pix.width * pix.height * 4, 0);
			for( k in 0...sum.length )
				sum[k] += pix.bytes.get(k);
			if( i < samples - 1 )
				return;
			setJitter(0, 0);
			for( k in 0...sum.length )
				pix.bytes.set(k, Math.round(sum[k] / samples));
			onPixels(pix);
		});
	}

	// Captures, saves <out>/<name>.png and compares it with the reference
	function captureView( name : String, ?before : Void -> Void ) {
		capture(pix -> saveCapture(name, pix), before);
	}

	override function render( e : h3d.Engine ) {
		if( !autoMode ) {
			frameTimer.begin();
			super.render(e);
			frameTimer.end();
			return;
		}
		try {
			while( true ) {
				var s = steps[0];
				if( s == null ) {
					super.render(e);
					return;
				}
				if( s.index >= s.count ) {
					steps.shift();
					continue;
				}
				stepInsert = 1;
				s.run(s.index++, e);
				stepInsert = -1;
				if( s.renders )
					return;
			}
		} catch( err ) {
			stepInsert = -1;
			report("Render error in " + (currentView == null ? "?" : currentView.name) + ": " + err.details());
			#if sys
			Sys.exit(2);
			#else
			steps = [];
			#end
		}
	}

	// Renders the scene once into an offscreen target and shows it, returns its BGRA pixels if capture is set
	function renderScene( e : h3d.Engine, capture : Bool ) {
		if( captureTex == null || captureTex.width != e.width || captureTex.height != e.height ) {
			if( captureTex != null ) {
				captureTex.depthBuffer = null;
				captureTex.dispose();
			}
			captureTex = new h3d.mat.Texture(e.width, e.height, [Target]);
		}
		captureTex.depthBuffer = h3d.mat.Texture.getDefaultDepth();
		frameTimer.begin();
		e.pushTarget(captureTex);
		s3d.render(e);
		e.popTarget();
		frameTimer.end();
		h3d.pass.Copy.run(captureTex, null);
		if( !capture )
			return null;
		var pix = captureTex.capturePixels();
		pix.convert(BGRA);
		return pix;
	}

	// ---- Files and comparison

	function report( msg : String ) {
		#if sys
		Sys.println(msg);
		#else
		trace(msg);
		#end
	}

	function refPath( name : String ) {
		return outDir + "/ref/" + name + ".png";
	}

	// Saves the capture, then with --make-ref saves it as reference, otherwise compares with the reference if there is one
	function saveCapture( name : String, pix : hxd.Pixels ) {
		if( makeRef ) {
			savePng(refPath(name), pix);
			report(name + ": reference saved");
			return true;
		}
		savePng(outDir + "/" + name + ".png", pix);
		var ref = loadPng(refPath(name));
		if( ref == null ) {
			report("Captured " + name);
			return true;
		}
		var d = diffPixels(ref, pix, 8);
		if( d == null ) {
			failures++;
			report(name + ": size differs from reference");
			return false;
		}
		if( d.count == 0 ) {
			report(name + ": OK" + (d.maxDiff > 0 ? " (max " + d.maxDiff + ")" : ""));
			return true;
		}
		failures++;
		report(name + ": DIFF (max " + d.maxDiff + ", " + d.count + " px above " + tolerance + ")");
		savePng(outDir + "/" + name + "_diff.png", d.image);
		return false;
	}

	function savePng( path : String, pix : hxd.Pixels ) {
		#if sys
		var dir = haxe.io.Path.directory(path);
		if( dir != "" && !sys.FileSystem.exists(dir) )
			sys.FileSystem.createDirectory(dir);
		sys.io.File.saveBytes(path, pix.toPNG());
		#elseif js
		var blob = new js.html.Blob([pix.toPNG().getData()], { type : "image/png" });
		var a = js.Browser.document.createAnchorElement();
		a.href = js.html.URL.createObjectURL(blob);
		a.download = haxe.io.Path.withoutDirectory(path);
		a.click();
		#end
	}

	function loadPng( path : String ) : hxd.Pixels {
		#if sys
		if( !sys.FileSystem.exists(path) )
			return null;
		return hxd.res.Any.fromBytes(path, sys.io.File.getBytes(path)).toImage().getPixels(BGRA);
		#else
		return null;
		#end
	}

	// Compares two BGRA images of the same size, null if sizes differ. The tolerance defaults to --tolerance.
	function diffPixels( a : hxd.Pixels, b : hxd.Pixels, scale = 4., ?tolerance : Int ) : BenchDiff {
		if( tolerance == null ) tolerance = this.tolerance;
		if( a.width != b.width || a.height != b.height )
			return null;
		a.convert(BGRA);
		b.convert(BGRA);
		var out = hxd.Pixels.alloc(a.width, a.height, BGRA);
		var maxDiff = 0, count = 0, sum = 0.;
		for( i in 0...a.width * a.height ) {
			var pa = a.offset + i * 4, pb = b.offset + i * 4, po = out.offset + i * 4;
			var m = 0;
			for( c in 0...3 ) {
				var d = hxd.Math.iabs(a.bytes.get(pa + c) - b.bytes.get(pb + c));
				sum += d;
				if( d > m ) m = d;
				out.bytes.set(po + c, Std.int(Math.min(255, d * scale)));
			}
			out.bytes.set(po + 3, 255);
			if( m > maxDiff ) maxDiff = m;
			if( m > tolerance ) count++;
		}
		return { maxDiff : maxDiff, count : count, mae : sum / (a.width * a.height * 3), image : out };
	}

	// ---- Metrics

	// Columns printed and written to <out>/metrics.csv, one row per addMetrics
	function setMetricColumns( columns : Array<String> ) {
		metricColumns = columns;
	}

	// Floats are rounded to 3 decimals, NaN prints "-"
	function addMetrics( name : String, values : Array<Float> ) {
		inline function fmt( v : Float ) return Math.isNaN(v) ? "-" : "" + Math.round(v * 1000) / 1000;
		inline function width( i : Int ) return metricColumns[i].length < 7 ? 8 : metricColumns[i].length + 1;
		if( metricRows.length == 0 )
			report(StringTools.rpad("view", " ", 26) + [for( i in 0...metricColumns.length ) StringTools.lpad(metricColumns[i], " ", width(i))].join(""));
		report(StringTools.rpad(name, " ", 26) + [for( i in 0...values.length ) StringTools.lpad(fmt(values[i]), " ", width(i))].join(""));
		metricRows.push([name].concat([for( v in values ) fmt(v)]).join(","));
	}

	function saveMetrics() {
		if( metricColumns == null || metricRows.length == 0 )
			return;
		#if sys
		if( !sys.FileSystem.exists(outDir) )
			sys.FileSystem.createDirectory(outDir);
		sys.io.File.saveContent(outDir + "/metrics.csv", ["view"].concat(metricColumns).join(",") + "\n" + metricRows.join("\n") + "\n");
		#end
	}

	// ---- GPU timing

	function hasGpuTimestamps() {
		return #if dx12 true #elseif js false #else engine.driver.hasFeature(Queries) #end;
	}

	function addGpuTimer( name : String ) {
		var t = new BenchGpuTimer(name);
		t.active = !autoMode && hasGpuTimestamps();
		gpuTimers.push(t);
		return t;
	}

	function timeView( name : String ) {
		call(function() {
			for( t in gpuTimers ) {
				t.samples = [];
				t.active = true;
			}
		});
		renderFrames(timingFrames);
		call(() -> for( t in gpuTimers ) t.active = false);
		var waited = 0;
		function collect() {
			var complete = true;
			for( t in gpuTimers ) {
				t.poll();
				if( !t.isComplete() ) complete = false;
			}
			if( !complete && waited++ < 30 ) {
				renderFrames(1);
				call(collect);
				return;
			}
			addGpuTimes(name);
		}
		call(collect);
	}

	function addGpuTimes( name : String ) {
		inline function fmt( v : Float ) return Math.isNaN(v) ? "-" : "" + Math.round(v * 1000) / 1000;
		report("  gpu ms: " + [for( t in gpuTimers ) t.name + " " + fmt(t.median()) + " (min " + fmt(t.min()) + ")"].join(", "));
		gpuTimeRows.push([name].concat([for( t in gpuTimers ) fmt(t.median()) + "," + fmt(t.min())]).join(","));
	}

	function saveGpuTimes() {
		if( gpuTimeRows.length == 0 )
			return;
		#if sys
		if( !sys.FileSystem.exists(outDir) )
			sys.FileSystem.createDirectory(outDir);
		var header = ["view"].concat([for( t in gpuTimers ) t.name + "_med," + t.name + "_min"]).join(",");
		sys.io.File.saveContent(outDir + "/gpu_times.csv", header + "\n" + gpuTimeRows.join("\n") + "\n");
		#end
	}

	function pollGpuTimers() {
		for( t in gpuTimers ) {
			t.poll();
			var keep = t.idle > 8 ? 0 : 30;
			if( t.samples.length > keep )
				t.samples.splice(0, t.samples.length - keep);
		}
	}

	function gpuTimesText() {
		if( !hasGpuTimestamps() )
			return "GPU timing not available";
		inline function fmt( v : Float ) return Math.isNaN(v) ? "-" : Math.round(v * 100) / 100 + " ms";
		return [for( t in gpuTimers ) t.name + " " + fmt(t.median())].join("  ");
	}

	// ---- Utilities

	public static function halton( index : Int, base : Int ) {
		var f = 1.0, r = 0.0;
		while( index > 0 ) {
			f /= base;
			r += f * (index % base);
			index = Std.int(index / base);
		}
		return r;
	}

	// Procedural cube map, color(dir) gets a normalized direction (z up). RGBA32F keeps HDR values, RGBA clamps to 0..1.
	public static function makeCubeMap( size : Int, color : h3d.Vector -> h3d.Vector4, format : hxd.PixelFormat = RGBA ) {
		var tex = new h3d.mat.Texture(size, size, [Cube], format);
		var dir = new h3d.Vector();
		for( face in 0...6 ) {
			var pix = hxd.Pixels.alloc(size, size, format);
			for( y in 0...size )
				for( x in 0...size ) {
					var u = (x + 0.5) / size * 2 - 1;
					var v = (y + 0.5) / size * 2 - 1;
					switch( face ) {
					case 0: dir.set(1, -v, -u);
					case 1: dir.set(-1, -v, u);
					case 2: dir.set(u, 1, v);
					case 3: dir.set(u, -1, -v);
					case 4: dir.set(u, -v, 1);
					default: dir.set(-u, -v, -1);
					}
					dir.normalize();
					var c = color(dir);
					if( format == RGBA32F )
						pix.setPixelF(x, y, c);
					else {
						inline function byte( f : Float ) return Std.int(Math.max(0, Math.min(1, f)) * 255);
						pix.setPixel(x, y, (byte(c.w) << 24) | (byte(c.x) << 16) | (byte(c.y) << 8) | byte(c.z));
					}
				}
			tex.uploadPixels(pix, 0, face);
		}
		return tex;
	}

	// Blue gradient sky above the horizon, dark ground below, so benches need no resources
	public static function skyColor( dir : h3d.Vector ) {
		var up = dir.z;
		return up >= 0 ? new h3d.Vector4(0.55 - up * 0.35, 0.65 - up * 0.3, 0.9 - up * 0.1, 1) : new h3d.Vector4(0.25, 0.22, 0.2, 1);
	}

	// Reads a texture back as a displayable BGRA image: channel -1 = rgb, 0..3 = a single channel as grey. Values are multiplied by scale and clamped.
	public static function readTexture( tex : h3d.mat.Texture, channel = -1, scale = 1. ) {
		var src = tex.capturePixels();
		var out = hxd.Pixels.alloc(src.width, src.height, BGRA);
		var v = new h3d.Vector4();
		inline function byte( f : Float ) return Std.int(Math.max(0, Math.min(1, f * scale)) * 255);
		for( y in 0...src.height )
			for( x in 0...src.width ) {
				switch( src.format ) {
				case RGBA16F:
					var p = src.offset + (x + y * src.width) * 8;
					v.set(halfToFloat(src.bytes.getUInt16(p)), halfToFloat(src.bytes.getUInt16(p + 2)), halfToFloat(src.bytes.getUInt16(p + 4)), halfToFloat(src.bytes.getUInt16(p + 6)));
				case R16F:
					v.set(halfToFloat(src.bytes.getUInt16(src.offset + (x + y * src.width) * 2)), 0, 0, 0);
				default:
					src.getPixelF(x, y, v);
				}
				var r, g, b;
				if( channel < 0 ) {
					r = v.x; g = v.y; b = v.z;
				} else
					r = g = b = channel == 0 ? v.x : channel == 1 ? v.y : channel == 2 ? v.z : v.w;
				out.setPixel(x, y, 0xFF000000 | (byte(r) << 16) | (byte(g) << 8) | byte(b));
			}
		return out;
	}

	public static function halfToFloat( h : Int ) : Float {
		var e = (h >> 10) & 0x1F;
		var m = h & 0x3FF;
		var v = e == 0 ? m / 1024 * Math.pow(2, -14) : (e == 31 ? 1e9 : (1 + m / 1024) * Math.pow(2, e - 15));
		return (h & 0x8000) != 0 ? -v : v;
	}
}
