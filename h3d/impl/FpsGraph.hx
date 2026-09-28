package h3d.impl;

class FpsGraph {
	var parent : h2d.Object;

	public var showGpu : Bool = true;
	public var showCpu : Bool = true;

	// Graph config
	public var width(default, set) : Float = 400.;
	public var height(default, set) : Float = 180.;
	public var maxFrameCount(default, set) : Int = 200;
	/**
		maxFps will be set automatically to *2 or /2.
		Default value is chosen for 30FPS(45), 60FPS(90), 144FPS(180)
	**/
	public var maxFps(default, set) : Float = 90.;
	public var maxDtMs(default, set) : Float = 1000 / 20;
	var xscale : Float;
	var yscaleFps : Float;
	var yscaleDtMs : Float;

	// Draw element
	var root : h2d.Flow;
	var graph : h2d.Graphics;
	var textFps : h2d.Text;
	var textDt : h2d.Text;

	// Global Data
	var globalDtMs : Float;
	var globalFpsData : FrameData;
	var globalFpsMin : Float = Math.POSITIVE_INFINITY;
	var globalFpsMax : Float = Math.NEGATIVE_INFINITY;
	var localFpsMax : Float = Math.NEGATIVE_INFINITY; // for auto-scale maxFps

	// CPU Data
	var pendingCount : Int = 0;
	var cpuStart : Float;
	var cpuEnd : Float;
	var cpuDtMsData : FrameData;

	// GPU Data
	var driver : h3d.impl.Driver;
	var gpuFreeQueryPool : Array<h3d.impl.Driver.Query> = [];
	var gpuPendingQueries : Array<h3d.impl.Driver.Query> = [];
	var gpuDtMs : Float;
	var gpuFpsData : FrameData;

	public function new( parent : h2d.Object ) {
		this.parent = parent;
		xscale = width / maxFrameCount;
		yscaleFps = height / maxFps;
		yscaleDtMs = height / maxDtMs;
		root = new h2d.Flow(parent);
		root.layout = Stack;
		var pflow = Std.downcast(parent, h2d.Flow);
		if( pflow != null ) {
			pflow.getProperties(root).isAbsolute = true;
		}
		graph = new h2d.Graphics(root);
		graph.bevel = 0;
		textFps = new h2d.Text(hxd.res.DefaultFont.get(), root);
		root.getProperties(textFps).isAbsolute = true;
		textDt = new h2d.Text(hxd.res.DefaultFont.get(), root);
		root.getProperties(textDt).isAbsolute = true;
		globalFpsData = new FrameData(maxFrameCount);
		cpuDtMsData = new FrameData(maxFrameCount);
		driver = h3d.Engine.getCurrent().driver;
		gpuFpsData = new FrameData(maxFrameCount);
	}

	public inline function setPosition( x : Float, y : Float ) {
		root.setPosition(x, y);
	}

	public function update( dt : Float ) {
		// var fps = dt == 0.0 ? Math.NaN : Math.round(1.0 / dt);
		var fps = h3d.Engine.getCurrent().fps;
		var dt = 1.0 / fps;
		globalDtMs = roundFloat(dt * 1000);
		globalFpsData.push(fps);
		if( fps < globalFpsMin )
			globalFpsMin = fps;
		if( fps > globalFpsMax )
			globalFpsMax = fps;
		if( fps > localFpsMax )
			localFpsMax = fps;
		if( localFpsMax > maxFps ) {
			maxFps = maxFps * 2.;
		} else if( localFpsMax < (maxFps/2.) - 5. ) {
			maxFps = maxFps / 2.;
		}
		localFpsMax -= 0.05;
		draw();
	}

	public function dispose() {
		if( root != null )
			root.remove();
		root = null;
		if( graph != null )
			graph.remove();
		graph = null;
		if( textFps != null )
			textFps.remove();
		textFps = null;
		if( textDt != null )
			textDt.remove();
		textDt = null;
		for( q in gpuFreeQueryPool )
			driver.deleteQuery(q);
		gpuFreeQueryPool = [];
		for( q in gpuPendingQueries )
			driver.deleteQuery(q);
		gpuPendingQueries = [];
		driver = null;
	}

	/**
		Call at the begining of a hxd.App's `update` for CPU/GPU time
	**/
	public function begin() {
		if( !showCpu && !showGpu )
			return;
		// force end
		if( pendingCount > 0 )
			end();
		// cpu
		if( showCpu ) {
			var cpuDt = cpuEnd - cpuStart;
			cpuDtMsData.push(roundFloat(cpuDt * 1000));
			cpuStart = haxe.Timer.stamp();
		}
		// gpu
		if( showGpu ) {
			while( gpuPendingQueries.length >= 2 ) {
				var gpuStartQuery = gpuPendingQueries[0];
				var gpuEndQuery = gpuPendingQueries[1];
				if( !driver.queryResultAvailable(gpuStartQuery) || !driver.queryResultAvailable(gpuEndQuery) )
					break;
				gpuPendingQueries.shift();
				gpuPendingQueries.shift();
				var gpuDtNs = driver.queryResult(gpuEndQuery) - driver.queryResult(gpuStartQuery);
				gpuDtMs = roundFloat(gpuDtNs / 1e6);
				gpuFpsData.push(roundFloat(1e9 / gpuDtNs));
				gpuFreeQueryPool.push(gpuStartQuery);
				gpuFreeQueryPool.push(gpuEndQuery);
			}
			if( gpuFreeQueryPool.length < 2 ) {
				gpuFreeQueryPool.push(driver.allocQuery(TimeStamp));
				gpuFreeQueryPool.push(driver.allocQuery(TimeStamp));
			}
			var query = gpuFreeQueryPool.pop();
			driver.endQuery(query);
			gpuPendingQueries.push(query);
		}
		pendingCount++;
	}

	/**
		Call at the end of a hxd.App's `render` for CPU/GPU time
	**/
	public function end() {
		if( pendingCount <= 0 )
			return;
		if( showCpu ) {
			cpuEnd = haxe.Timer.stamp();
		}
		if( showGpu ) {
			var query = gpuFreeQueryPool.pop();
			driver.endQuery(query);
			gpuPendingQueries.push(query);
		}
		pendingCount--;
	}

	function roundFloat( v : Float ) {
		return Math.ceil(v * 100) / 100;
	}

	function draw() {
		if( globalFpsData.length <= 0 )
			return;

		inline function frameToX( frame : Int ) {
			return frame * xscale;
		}
		inline function fpsToY( fps : Float ) {
			var fps = hxd.Math.clamp(fps, 0., maxFps);
			return (maxFps - fps) * yscaleFps;
		}
		inline function dtMsToY( dtMs : Float ) {
			var dtMs = hxd.Math.clamp(dtMs, 0., maxDtMs);
			return (maxDtMs - dtMs) * yscaleDtMs;
		}

		var showGpuData = showGpu && gpuFpsData.length > 0;
		var showCpuData = showCpu && cpuDtMsData.length > 0;

		var fpsText = 'FPS: ${globalFpsData[globalFpsData.length-1]}\nMin: ${globalFpsMin} Max: ${globalFpsMax}';
		if( showGpuData ) {
			fpsText += '\nGpu FPS: ${gpuFpsData[gpuFpsData.length-1]}';
		}
		textFps.text = fpsText;
		textFps.x = 10.;
		var dtText = 'Dt: ${globalDtMs} ms';
		if( showCpuData ) {
			dtText += '\nCpu Dt: ${cpuDtMsData[cpuDtMsData.length-1]} ms';
		}
		if( showGpuData ) {
			dtText += '\nGpu Dt: ${gpuDtMs} ms';
		}
		textDt.text = dtText;
		textDt.x = 150.;

		graph.clear();

		var globalColor = 0xff0000;
		var cpuColor = 0x0059ff;
		var gpuColor = 0x00ffaa;
		var legendWidth = 10.;

		// background
		graph.beginFill(0x000000, 0.4);
		graph.drawRect(0., 0., width, height);

		// legend
		graph.setColor(globalColor);
		graph.drawRect(0., 4., legendWidth, legendWidth);
		if( showCpuData ) {
			graph.setColor(cpuColor);
			graph.drawRect(140., 20., legendWidth, legendWidth);
		}
		if( showGpuData ) {
			graph.setColor(gpuColor);
			graph.drawRect(0., 35., legendWidth, legendWidth);
		}

		graph.endFill();

		// fps ref lines
		graph.lineStyle(1, 0xffffff, 0.4);
		for( refFps in [30., 60., 120., 240.] ) {
			if( refFps >= maxFps )
				break;
			graph.moveTo(frameToX(0), fpsToY(refFps));
			graph.lineTo(frameToX(maxFrameCount), fpsToY(refFps));
		}

		// cpu
		if( showCpuData ) {
			graph.lineStyle(1, cpuColor, 1.);
			for( i in 0...cpuDtMsData.length ) {
				graph.lineTo(frameToX(i), dtMsToY(cpuDtMsData[i]));
			}
		}

		// gpu
		if( showGpuData ) {
			graph.lineStyle(1, gpuColor, 1.);
			for( i in 0...gpuFpsData.length ) {
				graph.lineTo(frameToX(i), fpsToY(gpuFpsData[i]));
			}
		}

		// global
		graph.lineStyle(1, globalColor, 1.);
		for( i in 0...globalFpsData.length ) {
			graph.lineTo(frameToX(i), fpsToY(globalFpsData[i]));
		}
	}

	function set_width( v : Float ) {
		width = v;
		xscale = width / maxFrameCount;
		return width;
	}

	function set_height( v : Float ) {
		height = v;
		yscaleFps = height / maxFps;
		yscaleDtMs = height / maxDtMs;
		return height;
	}

	function set_maxFrameCount( v : Int ) {
		maxFrameCount = v;
		xscale = width / maxFrameCount;
		globalFpsData = new FrameData(maxFrameCount);
		cpuDtMsData = new FrameData(maxFrameCount);
		gpuFpsData = new FrameData(maxFrameCount);
		return maxFrameCount;
	}

	function set_maxFps( v : Float ) {
		maxFps = v;
		yscaleFps = height / maxFps;
		yscaleDtMs = height / maxDtMs;
		return maxFps;
	}

	function set_maxDtMs( v : Float ) {
		maxDtMs = v;
		yscaleDtMs = height / maxDtMs;
		return maxDtMs;
	}
}
