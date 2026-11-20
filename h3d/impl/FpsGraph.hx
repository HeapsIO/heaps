package h3d.impl;

private class FpsGraphShader extends hxsl.Shader {
	static var SRC = {
		@:import h3d.shader.Base2d;

		@param var data : Sampler2D;
		@param var count : Float;
		@param var offset : Float;
		@param var size : Vec2;
		@param var top : Float;
		@param var scale : Float;
		@param var refLines : Vec4;
		@param var limits : Vec2;
		@param var barAlpha : Float;
		@param var bgColor : Vec4;
		@param var gridColor : Vec4;
		@param var goodColor : Vec4;
		@param var warnColor : Vec4;
		@param var badColor : Vec4;
		@param var cpuColor : Vec4;
		@param var gpuColor : Vec4;

		function fragment() {
			var p = calculatedUV * size;
			var col = bgColor;
			if( p.y >= top ) {
				var bw = size.x / count;
				var i = floor(p.x / bw);
				var s0 = sample(i - 1.);
				var s1 = sample(i);
				var s2 = sample(i + 1.);

				var ms = s1.r;
				if( ms >= 0. && barAlpha > 0. ) {
					var y = min(toY(ms), size.y - 3.);
					if( p.y >= y ) {
						var c = badColor;
						if( ms <= limits.x ) c = goodColor;
						else if( ms <= limits.y ) c = warnColor;
						var k = p.y - y < 1.5 ? 1. : 0.75 - 0.4 * saturate((p.y - y) / (size.y - y + 1.));
						if( ms > scale ) k = 1.;
						col = mix(col, vec4(c.rgb, 1.), k);
					}
				}

				col = drawRef(col, p, refLines.x);
				col = drawRef(col, p, refLines.y);
				col = drawRef(col, p, refLines.z);
				col = drawRef(col, p, refLines.w);

				if( cpuColor.a > 0. )
					col = drawCurve(col, cpuColor, curveDist(p, bw, i, s0.g, s1.g, s2.g));
				if( gpuColor.a > 0. )
					col = drawCurve(col, gpuColor, curveDist(p, bw, i, s0.b, s1.b, s2.b));
			} else if( p.y >= top - 1. )
				col = mix(col, vec4(gridColor.rgb, 1.), gridColor.a);
			pixelColor *= col;
		}

		function sample( i : Float ) : Vec4 {
			return data.get(vec2((clamp(i, 0., count - 1.) + offset + 0.5) / count, 0.5));
		}

		function toY( ms : Float ) : Float {
			return top + (size.y - top) * min(ms / scale, 1.);
		}

		function segDist( p : Vec2, a : Vec2, b : Vec2 ) : Float {
			var pa = p - a;
			var ba = b - a;
			var h = saturate(pa.dot(ba) / ba.dot(ba));
			return (pa - ba * h).length();
		}

		function curveDist( p : Vec2, bw : Float, i : Float, a : Float, b : Float, c : Float ) : Float {
			var d = 1e9;
			var pa = vec2((i - 0.5) * bw, toY(a));
			var pb = vec2((i + 0.5) * bw, toY(b));
			var pc = vec2((i + 1.5) * bw, toY(c));
			if( b >= 0. ) {
				d = (p - pb).length();
				if( a >= 0. ) d = min(d, segDist(p, pa, pb));
				if( c >= 0. ) d = min(d, segDist(p, pb, pc));
			}
			return d;
		}

		function drawCurve( col : Vec4, color : Vec4, d : Float ) : Vec4 {
			var c = col;
			c.rgb *= 1. - 0.3 * saturate(1.8 - d);
			return mix(c, color, saturate(1.3 - d));
		}

		function drawRef( col : Vec4, p : Vec2, ms : Float ) : Vec4 {
			var c = col;
			if( ms < scale && abs(p.y - floor(toY(ms)) - 0.5) < 0.5 && fract(p.x / 6.) < 0.5 )
				c = mix(c, vec4(gridColor.rgb, 1.), gridColor.a);
			return c;
		}
	};
}

class FpsGraph {

	static inline var STRIDE = 16;
	static inline var STATS_PERIOD = 0.5;
	static inline var MAX_GPU_PENDING = 8;

	static inline var TEXT_COLOR = 0xFFFFFF;
	static inline var LABEL_COLOR = 0x9A9A9A;
	static inline var CPU_COLOR = 0x4DA6FF;
	static inline var GPU_COLOR = 0xFF6FD8;

	public var showGpu : Bool = true;
	public var showCpu : Bool = true;

	public var width : Float = 400.;
	public var height : Float = 180.;
	public var maxFrameCount(default, set) : Int = 200;
	public var maxDtMs : Float = 100.;
	public var goodMs : Float = 17.5;
	public var warnMs : Float = 34.;

	var root : h2d.Object;
	var graph : h2d.Bitmap;
	var shader : FpsGraphShader;
	var font : h2d.Font;
	var text : h2d.SpriteBatch;
	var chars : Array<h2d.SpriteBatch.BatchElement> = [];
	var charCount : Int;
	var penX : Float;
	var penY : Float;
	var penColor : Int;
	var penAlpha : Float = 1.;
	var lineHeight : Float;
	var headerHeight : Float;
	var zones : Array<h2d.Interactive> = [];
	var highlight : Int = 0;

	var texture : h3d.mat.Texture;
	var pixels : hxd.Pixels;
	var frame : Int = 0;
	var scale : Float = 25.;
	var scaleMs : Float = 1000. / 60.;

	var frameStart : Float = -1.;
	var cpuEnd : Float = -1.;

	var driver : h3d.impl.Driver;
	var gpuStarted : Bool = false;
	var gpuFreeQueries : Array<h3d.impl.Driver.Query> = [];
	var gpuPendingQueries : Array<h3d.impl.Driver.Query> = [];
	var gpuPendingFrames : Array<Int> = [];

	var statStart : Float = -1.;
	var statFrame : Int = 0;
	var avgMs : Float = -1.;
	var maxMs : Float = -1.;
	var cpuMs : Float = -1.;
	var gpuMs : Float = -1.;

	public function new( parent : h2d.Object ) {
		root = new h2d.Object(parent);
		var pflow = Std.downcast(parent, h2d.Flow);
		if( pflow != null )
			pflow.getProperties(root).isAbsolute = true;

		font = hxd.res.DefaultFont.get();
		lineHeight = Math.ceil(font.lineHeight);
		headerHeight = lineHeight * 2 + 6;

		shader = new FpsGraphShader();
		shader.refLines.set(1000 / 120, 1000 / 60, 1000 / 30, 1000 / 15);
		shader.bgColor.set(0.05, 0.06, 0.08, 0.72);
		shader.gridColor.set(1, 1, 1, 0.3);
		shader.goodColor.setColor(0x3FBF5F);
		shader.warnColor.setColor(0xF2B42C);
		shader.badColor.setColor(0xF0453A);
		shader.cpuColor.setColor(CPU_COLOR);
		shader.gpuColor.setColor(GPU_COLOR);

		graph = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF), root);
		graph.addShader(shader);
		text = new h2d.SpriteBatch(font.tile, root);
		for( i in 0...3 ) {
			var z = new h2d.Interactive(0, lineHeight, root);
			var bit = 1 << i;
			z.onClick = function(_) highlight ^= bit;
			zones.push(z);
		}

		driver = h3d.Engine.getCurrent().driver;
		allocData();
	}

	/**
		Call at the begining of a hxd.App's `update` for CPU/GPU time
	**/
	public function begin() {
		if( driver == null )
			return;
		if( frameStart >= 0 && cpuEnd < 0 )
			end();
		var now = haxe.Timer.stamp();
		if( frameStart >= 0 )
			pushFrame((now - frameStart) * 1000, (cpuEnd - frameStart) * 1000);
		frameStart = now;
		cpuEnd = -1;

		readGpu();
		gpuStarted = showGpu && gpuPendingFrames.length < MAX_GPU_PENDING;
		if( gpuStarted ) {
			if( gpuFreeQueries.length < 2 ) {
				gpuFreeQueries.push(driver.allocQuery(TimeStamp));
				gpuFreeQueries.push(driver.allocQuery(TimeStamp));
			}
			var q = gpuFreeQueries.pop();
			driver.endQuery(q);
			gpuPendingQueries.push(q);
			gpuPendingFrames.push(frame);
		}
	}

	/**
		Call at the end of a hxd.App's `render` for CPU/GPU time
	**/
	public function end() {
		if( driver == null || frameStart < 0 || cpuEnd >= 0 )
			return;
		cpuEnd = haxe.Timer.stamp();
		if( gpuStarted ) {
			var q = gpuFreeQueries.pop();
			driver.endQuery(q);
			gpuPendingQueries.push(q);
			gpuStarted = false;
		}
	}

	public function update( dt : Float ) {
		if( root == null )
			return;
		if( frameStart < 0 )
			pushFrame(dt * 1000, -1);

		var now = haxe.Timer.stamp();
		if( statStart < 0 )
			statStart = now;
		if( now - statStart >= STATS_PERIOD && frame > statFrame ) {
			updateStats();
			statStart = now;
		}

		var showFrame = isShown(0);
		var showCpuCurve = showCpu && isShown(1);
		var showGpuCurve = showGpu && isShown(2);
		var ms = scaleMs;
		if( !showFrame )
			ms = hxd.Math.max(showCpuCurve ? cpuMs : 0, showGpuCurve ? gpuMs : 0);
		if( ms * 2.0 > scale && scale * 2.0 <= maxDtMs )
			scale *= 2.0;
		else if( ms * 2.0 < scale * 0.45 && scale > 12.5 )
			scale /= 2.0;

		texture.uploadPixels(pixels);
		shader.offset = frame % maxFrameCount;
		shader.size.set(width, height);
		shader.top = headerHeight;
		shader.scale = scale;
		shader.limits.set(goodMs, warnMs);
		shader.barAlpha = showFrame ? 1 : 0;
		shader.cpuColor.w = showCpuCurve ? 1 : 0;
		shader.gpuColor.w = showGpuCurve ? 1 : 0;
		graph.width = width;
		graph.height = height;

		drawText();
	}

	public inline function setPosition( x : Float, y : Float ) {
		root.setPosition(x, y);
	}

	public function dispose() {
		if( root != null )
			root.remove();
		root = null;
		if( texture != null )
			texture.dispose();
		texture = null;
		if( driver != null ) {
			for( q in gpuFreeQueries )
				driver.deleteQuery(q);
			for( q in gpuPendingQueries )
				driver.deleteQuery(q);
		}
		gpuFreeQueries = [];
		gpuPendingQueries = [];
		gpuPendingFrames = [];
		driver = null;
	}

	function set_maxFrameCount( v : Int ) {
		if( v == maxFrameCount )
			return v;
		maxFrameCount = v;
		if( texture != null )
			allocData();
		return v;
	}

	function allocData() {
		if( texture != null )
			texture.dispose();
		texture = new h3d.mat.Texture(maxFrameCount, 1, [Dynamic], RGBA32F);
		texture.filter = Nearest;
		texture.wrap = Repeat;
		shader.data = texture;
		shader.count = maxFrameCount;
		pixels = hxd.Pixels.alloc(maxFrameCount, 1, RGBA32F);
		var bytes = pixels.bytes;
		for( i in 0...maxFrameCount * 4 )
			bytes.setFloat(i * 4, -1);
	}

	function pushFrame( ms : Float, cpu : Float ) {
		var pos = (frame % maxFrameCount) * STRIDE;
		var bytes = pixels.bytes;
		bytes.setFloat(pos, ms);
		bytes.setFloat(pos + 4, showCpu ? cpu : -1);
		bytes.setFloat(pos + 8, -1);
		frame++;
		// smoothed frame time for the scale, ignoring stutters
		scaleMs += (hxd.Math.min(ms, scaleMs * 2.0) - scaleMs) * 0.02;
	}

	function updateStats() {
		var count = hxd.Math.imin(frame - statFrame, maxFrameCount);
		var bytes = pixels.bytes;
		var sum = 0., cpuSum = 0., gpuSum = 0.;
		var cpuCount = 0, gpuCount = 0;
		maxMs = 0;
		for( f in frame - count...frame ) {
			var pos = (f % maxFrameCount) * STRIDE;
			var ms = bytes.getFloat(pos);
			sum += ms;
			if( ms > maxMs ) maxMs = ms;
			var cpu = bytes.getFloat(pos + 4);
			if( cpu >= 0 ) {
				cpuSum += cpu;
				cpuCount++;
			}
			var gpu = bytes.getFloat(pos + 8);
			if( gpu >= 0 ) {
				gpuSum += gpu;
				gpuCount++;
			}
		}
		avgMs = sum / count;
		cpuMs = cpuCount > 0 ? cpuSum / cpuCount : -1;
		gpuMs = gpuCount > 0 ? gpuSum / gpuCount : -1;
		statFrame = frame;
	}

	function readGpu() {
		while( gpuPendingQueries.length >= 2 ) {
			var q0 = gpuPendingQueries[0];
			var q1 = gpuPendingQueries[1];
			if( !driver.queryResultAvailable(q0) || !driver.queryResultAvailable(q1) )
				break;
			var ms = (driver.queryResult(q1) - driver.queryResult(q0)) / 1e6;
			gpuPendingQueries.shift();
			gpuPendingQueries.shift();
			gpuFreeQueries.push(q0);
			gpuFreeQueries.push(q1);
			var f = gpuPendingFrames.shift();
			if( ms >= 0 && showGpu && f < frame && f >= frame - maxFrameCount )
				pixels.bytes.setFloat((f % maxFrameCount) * STRIDE + 8, ms);
		}
	}

	function drawText() {
		charCount = 0;

		setPen(6, 3, LABEL_COLOR);
		penAlpha = isShown(0) ? 1 : 0.35;
		putStr("FPS ");
		penColor = avgMs <= 0 ? LABEL_COLOR : avgMs <= goodMs ? 0x6FE08A : avgMs <= warnMs ? 0xF7CB5A : 0xFF6A5E;
		putNum(avgMs <= 0 ? -1 : 1000 / avgMs, 0);
		penX += 14;
		penColor = TEXT_COLOR;
		putNum(avgMs, 1);
		penColor = LABEL_COLOR;
		putStr(" ms   max ");
		penColor = TEXT_COLOR;
		putNum(maxMs, 1);
		penColor = LABEL_COLOR;
		putStr(" ms");
		setZone(0, 6);

		setPen(6, 3 + lineHeight, CPU_COLOR);
		zones[1].visible = showCpu;
		if( showCpu ) {
			penAlpha = isShown(1) ? 1 : 0.35;
			putStr("CPU ");
			penColor = TEXT_COLOR;
			putNum(cpuMs, 2);
			penColor = LABEL_COLOR;
			putStr(" ms");
			setZone(1, 6);
			penX += 14;
		}
		zones[2].visible = showGpu;
		if( showGpu ) {
			var x = penX;
			penAlpha = isShown(2) ? 1 : 0.35;
			penColor = GPU_COLOR;
			putStr("GPU ");
			penColor = TEXT_COLOR;
			putNum(gpuMs, 2);
			penColor = LABEL_COLOR;
			putStr(" ms");
			setZone(2, x);
		}

		penAlpha = 1;
		refLabel(120);
		refLabel(60);
		refLabel(30);
		refLabel(15);

		for( i in charCount...chars.length )
			chars[i].visible = false;
	}

	function refLabel( rate : Int ) {
		var ms = 1000 / rate;
		if( ms >= scale )
			return;
		var y = Math.floor(headerHeight + (height - headerHeight) * ms / scale) - lineHeight;
		if( y < headerHeight + 1 )
			return;
		setPen(4, y, LABEL_COLOR);
		putNum(ms, 1);
		putStr(" ms");
		setPen(width - 4 - (rate >= 100 ? 3 : 2) * font.getChar("0".code).width - strWidth(" fps"), y, LABEL_COLOR);
		putInt(rate);
		putStr(" fps");
	}

	inline function isShown( series : Int ) {
		return highlight == 0 || highlight & (1 << series) != 0;
	}

	function setZone( index : Int, x : Float ) {
		var z = zones[index];
		z.x = x - 3;
		z.y = penY - 2;
		z.width = penX - x + 6;
		z.height = lineHeight + 2;
	}

	inline function setPen( x : Float, y : Float, color : Int ) {
		penX = x;
		penY = y;
		penColor = color;
	}

	function strWidth( s : String ) {
		var w = 0.;
		for( i in 0...s.length )
			w += font.getChar(StringTools.fastCodeAt(s, i)).width;
		return w;
	}

	function putChar( code : Int ) {
		var c = font.getChar(code);
		if( code != " ".code ) {
			if( charCount == chars.length )
				chars.push(text.add(new h2d.SpriteBatch.BatchElement(c.t)));
			var e = chars[charCount++];
			e.t = c.t;
			e.x = penX;
			e.y = penY;
			e.r = ((penColor >> 16) & 0xFF) / 255;
			e.g = ((penColor >> 8) & 0xFF) / 255;
			e.b = (penColor & 0xFF) / 255;
			e.a = penAlpha;
			e.visible = true;
		}
		penX += c.width;
	}

	function putStr( s : String ) {
		for( i in 0...s.length )
			putChar(StringTools.fastCodeAt(s, i));
	}

	function putInt( v : Int ) {
		var div = 1;
		while( div <= Std.int(v / 10) )
			div *= 10;
		while( div > 0 ) {
			putChar("0".code + Std.int(v / div) % 10);
			div = Std.int(div / 10);
		}
	}

	function putNum( v : Float, decimals : Int ) {
		if( v < 0 ) {
			putChar("-".code);
			return;
		}
		var mul = decimals == 0 ? 1 : decimals == 1 ? 10 : 100;
		var n = Math.round(hxd.Math.min(v, 99999) * mul);
		putInt(Std.int(n / mul));
		if( decimals > 0 ) {
			putChar(".".code);
			var f = n % mul;
			if( decimals == 2 && f < 10 )
				putChar("0".code);
			putInt(f);
		}
	}
}
