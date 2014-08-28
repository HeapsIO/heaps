package h3d;
import h3d.mat.Data;

class Engine {

	public var driver(default,null) : h3d.impl.Driver;

	public var mem(default,null) : h3d.impl.MemoryManager;

	public var hardware(default, null) : Bool;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var debug(default, set) : Bool;

	public var drawTriangles(default, null) : Int;
	public var drawCalls(default, null) : Int;
	public var shaderSwitches(default, null) : Int;

	public var backgroundColor : Null<Int> = 0xFF000000;
	public var autoResize : Bool;
	public var fullScreen(default, set) : Bool;

	public var fps(get, never) : Float;
	public var frameCount : Int = 0;

	var realFps : Float;
	var lastTime : Float;
	var antiAlias : Int;
	var tmpVector = new h3d.Vector();

	@:allow(h3d)
	var curProjMatrix : h3d.Matrix;

	@:access(hxd.Stage)
	public function new( hardware = true, aa = 0 ) {
		this.hardware = hardware;
		this.antiAlias = aa;
		this.autoResize = true;

		#if (!flash && openfl)
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
		#if (js || cpp)
		driver = new h3d.impl.GlDriver();
		#elseif flash
		driver = new h3d.impl.Stage3dDriver();
		#else
		throw "No driver";
		#end
		if( CURRENT == null )
			CURRENT = this;
	}

	static var CURRENT : Engine = null;

	static inline function check() {
		#if debug
		if ( CURRENT == null ) throw "no current context, please do this operation after engine init/creation";
		#end
	}

	public static inline function getCurrent() {
		check();
		return CURRENT;
	}

	public inline function setCurrent() {
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

	public function selectShader( shader : hxsl.RuntimeShader ) {
		if( driver.selectShader(shader) )
			shaderSwitches++;
	}

	public function selectMaterial( pass : h3d.mat.Pass ) {
		driver.selectMaterial(pass);
	}

	public function uploadShaderBuffers(buffers, which) {
		driver.uploadShaderBuffers(buffers, which);
	}

	function selectBuffer( buf : Buffer ) {
		if( buf.isDisposed() )
			return false;
		driver.selectBuffer(buf);
		return true;
	}

	public inline function renderTriBuffer( b : Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.triIndexes, 3, start, max);
	}

	public inline function renderQuadBuffer( b : Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.quadIndexes, 2, start, max);
	}

	// we use preallocated indexes so all the triangles are stored inside our buffers
	function renderBuffer( b : Buffer, indexes : Indexes, vertPerTri : Int, startTri = 0, drawTri = -1 ) {
		if( indexes.isDisposed() )
			return;
		do {
			var ntri = Std.int(b.vertices / vertPerTri);
			var pos = Std.int(b.position / vertPerTri);
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
			if( ntri > 0 && selectBuffer(b) ) {
				// *3 because it's the position in indexes which are always by 3
				driver.draw(indexes.ibuf, pos * 3, ntri);
				drawTriangles += ntri;
				drawCalls++;
			}
			b = b.next;
		} while( b != null );
	}

	// we use custom indexes, so the number of triangles is the number of indexes/3
	public function renderIndexed( b : Buffer, indexes : Indexes, startTri = 0, drawTri = -1 ) {
		if( b.next != null )
			throw "Buffer is split";
		if( indexes.isDisposed() )
			return;
		var maxTri = Std.int(indexes.count / 3);
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 && selectBuffer(b) ) {
			// *3 because it's the position in indexes which are always by 3
			driver.draw(indexes.ibuf, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	public function renderMultiBuffers( buffers : Buffer.BufferOffset, indexes : Indexes, startTri = 0, drawTri = -1 ) {
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
			var stage = hxd.Stage.getInstance();
			width = stage.width;
			height = stage.height;
		}
		if( disposed )
			mem.onContextLost();
		else {
			mem = new h3d.impl.MemoryManager(driver);
			mem.init();
		}
		hardware = driver.hasFeature(HardwareAccelerated);
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
			var stage = hxd.Stage.getInstance();
			var w = stage.width, h = stage.height;
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
		// init
		frameCount++;
		drawTriangles = 0;
		shaderSwitches = 0;
		drawCalls = 0;
		curProjMatrix = null;
		currentTarget = null;
		driver.begin(frameCount);
		if( backgroundColor != null ) clear(backgroundColor, 1, 0);
		return true;
	}

	function reset() {
		driver.reset();
	}

	public function hasFeature(f) {
		return driver.hasFeature(f);
	}

	public function end() {
		driver.present();
		reset();
		curProjMatrix = null;
	}

	var currentTarget : h3d.mat.Texture;

	public function getTarget() {
		return currentTarget;
	}

	/**
	 * Setus a render target to do off screen rendering, might be costly on low end devices
     * setTarget to null when you're finished rendering to it.
	 */
	public function setTarget( tex : h3d.mat.Texture ) {
		currentTarget = tex;
		driver.setRenderTarget(tex);
	}

	public function clear( ?color : Int, ?depth : Float, ?stencil : Int ) {
		if( color != null )
			tmpVector.setColor(color);
		driver.clear(color == null ? null : tmpVector, depth, stencil);
	}

	/**
	 * Sets up a scissored zone to eliminate pixels outside the given range.
	 * Call with no parameters to reset to full viewport.
	 */
	public function setRenderZone( x = 0, y = 0, ?width = -1, ?height = -1 ) : Void {
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