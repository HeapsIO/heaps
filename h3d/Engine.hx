package h3d;
import h3d.mat.Data;

class Engine {

	var driver : h3d.impl.Driver;
	
	public var mem(default,null) : h3d.impl.MemoryManager;

	public var hardware(default, null) : Bool;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var debug(default, set) : Bool;

	public var drawTriangles(default, null) : Int;
	public var drawCalls(default, null) : Int;
	public var shaderSwitches(default, null) : Int;

	public var backgroundColor : Int;
	public var autoResize : Bool;
	public var fullScreen(default, set) : Bool;
	
	public var fps(get, never) : Float;
	public var frameCount : Int = 0;
	
	var realFps : Float;
	var lastTime : Float;
	var antiAlias : Int;
	
	@:allow(h3d)
	var curProjMatrix : h3d.Matrix;

	@:access(hxd.Stage)
	public function new( hardware = true, aa = 0 ) {
		this.hardware = hardware;
		this.antiAlias = aa;
		this.autoResize = true;
		#if openfl
		hxd.Stage.openFLBoot(start);
		#else
		start();
		#end
	}
	
	function start() {
		fullScreen = !hxd.System.isWindowed;
		var stage = hxd.Stage.getInstance();
		realFps = stage.getFrameRate();
		lastTime = haxe.Timer.stamp();
		stage.addResizeEvent(onStageResize);
		#if flash
		driver = new h3d.impl.Stage3dDriver();
		#elseif (js || cpp)
		driver = new h3d.impl.GlDriver();
		#else
		throw "No driver";
		#end
		if( CURRENT == null )
			CURRENT = this;
	}
	
	static var CURRENT : Engine = null;
	
	public static function getCurrent() {
		return CURRENT;
	}
	
	public function setCurrent() {
		CURRENT = this;
	}

	public function init() {
		driver.init(onCreate, !hardware);
	}

	public function driverName(details=false) {
		return driver.getDriverName(details);
	}
	
	public function setCapture( bmp : hxd.BitmapData, callb : Void -> Void ) {
		driver.setCapture(bmp,callb);
	}

	function selectBuffer( buf : h3d.impl.MemoryManager.BigBuffer ) {
		if( buf.isDisposed() )
			return false;
		driver.selectBuffer(buf.vbuf);
		return true;
	}

	public inline function renderTriBuffer( b : h3d.impl.Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.indexes, 3, start, max);
	}
	
	public inline function renderQuadBuffer( b : h3d.impl.Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.quadIndexes, 2, start, max);
	}
	
	public function enableDriver( ?b : Bool ) {
		if( b == null )
			b = Std.is(driver, h3d.impl.NullDriver);
		if( b ) {
			var d = Std.instance(driver, h3d.impl.NullDriver);
			if( d != null )
				driver = d.driver;
		} else if( !Std.is(driver,h3d.impl.NullDriver) ) {
			driver = new h3d.impl.NullDriver(driver);
		}
	}

	// we use preallocated indexes so all the triangles are stored inside our buffers
	function renderBuffer( b : h3d.impl.Buffer, indexes : h3d.impl.Indexes, vertPerTri : Int, startTri = 0, drawTri = -1 ) {
		if( indexes.isDisposed() )
			return;
		do {
			var ntri = Std.int(b.nvert / vertPerTri);
			var pos = Std.int(b.pos / vertPerTri);
			if( startTri > 0 ) {
				if( startTri >= ntri ) {
					startTri -= ntri;
					b = b.next;
					continue;
				}
				pos += startTri;
				ntri -= startTri;
				startTri = 0;
			}
			if( drawTri >= 0 ) {
				if( drawTri == 0 ) return;
				drawTri -= ntri;
				if( drawTri < 0 ) {
					ntri += drawTri;
					drawTri = 0;
				}
			}
			if( ntri > 0 && selectBuffer(b.b) ) {
				// *3 because it's the position in indexes which are always by 3
				driver.draw(indexes.ibuf, pos * 3, ntri);
				drawTriangles += ntri;
				drawCalls++;
			}
			b = b.next;
		} while( b != null );
	}
	
	// we use custom indexes, so the number of triangles is the number of indexes/3
	public function renderIndexed( b : h3d.impl.Buffer, indexes : h3d.impl.Indexes, startTri = 0, drawTri = -1 ) {
		if( b.next != null )
			throw "Buffer is split";
		if( indexes.isDisposed() )
			return;
		var maxTri = Std.int(indexes.count / 3);
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 && selectBuffer(b.b) ) {
			// *3 because it's the position in indexes which are always by 3
			driver.draw(indexes.ibuf, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}
	
	public function renderMultiBuffers( buffers : h3d.impl.Buffer.BufferOffset, indexes : h3d.impl.Indexes, startTri = 0, drawTri = -1 ) {
		var maxTri = Std.int(indexes.count / 3);
		if( maxTri <= 0 ) return;
		driver.selectMultiBuffers(buffers);
		if( indexes.isDisposed() )
			return;
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 ) {
			// render
			driver.draw(indexes.ibuf, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	function set_debug(d) {
		debug = d;
		driver.setDebug(debug);
		return d;
	}

	function onCreate( disposed ) {
		if( autoResize ) {
			width = hxd.System.width;
			height = hxd.System.height;
		}
		if( disposed )
			mem.onContextLost();
		else
			mem = new h3d.impl.MemoryManager(driver, 65400);
		hardware = driver.isHardware();
		set_debug(debug);
		set_fullScreen(fullScreen);
		resize(width, height);
		if( disposed )
			onContextLost();
		else
			onReady();
	}
	
	public dynamic function onContextLost() {
	}

	public dynamic function onReady() {
	}
	
	function onStageResize() {
		if( autoResize && !driver.isDisposed() ) {
			var w = hxd.System.width, h = hxd.System.height;
			if( w != width || h != height )
				resize(w, h);
			onResized();
		}
	}
	
	function set_fullScreen(v) {
		fullScreen = v;
		if( mem != null && hxd.System.isWindowed )
			hxd.Stage.getInstance().setFullScreen(v);
		return v;
	}
	
	public dynamic function onResized() {
	}

	public function resize(width, height) {
		// minimum 32x32 size
		if( width < 32 ) width = 32;
		if( height < 32 ) height = 32;
		this.width = width;
		this.height = height;
		if( !driver.isDisposed() ) driver.resize(width, height);
	}

	public function begin() {
		if( driver.isDisposed() )
			return false;
		driver.clear( ((backgroundColor>>16)&0xFF)/255 , ((backgroundColor>>8)&0xFF)/255, (backgroundColor&0xFF)/255, ((backgroundColor>>>24)&0xFF)/255);
		// init
		frameCount++;
		drawTriangles = 0;
		shaderSwitches = 0;
		drawCalls = 0;
		curProjMatrix = null;
		driver.reset();
		return true;
	}

	function reset() {
		driver.reset();
	}

	public function end() {
		driver.present();
		reset();
		curProjMatrix = null;
	}

	public function setTarget( tex : h3d.mat.Texture, useDepth = false, clearColor = 0 ) {
		driver.setRenderTarget(tex == null ? null : tex.t, useDepth, clearColor);
	}

	public function setRenderZone( x = 0, y = 0, width = -1, height = -1 ) {
		driver.setRenderZone(x, y, width, height);
	}

	public function render( obj : { function render( engine : Engine ) : Void; } ) {
		if( !begin() ) return false;
		obj.render(this);
		end();
				
		var delta = haxe.Timer.stamp() - lastTime;
		lastTime += delta;
		if( delta > 0 ) {
			var curFps = 1. / delta;
			if( curFps > realFps * 2 ) curFps = realFps * 2 else if( curFps < realFps * 0.5 ) curFps = realFps * 0.5;
			var f = delta / .5;
			if( f > 0.3 ) f = 0.3;
			realFps = realFps * (1 - f) + curFps * f; // smooth a bit the fps
		}
		return true;
	}

	public function dispose() {
		driver.dispose();
		hxd.Stage.getInstance().removeResizeEvent(onStageResize);
	}
	
	function get_fps() {
		return Math.ceil(realFps * 100) / 100;
	}
	
}