package h3d;
import h3d.mat.Data;

private class TargetTmp {
	public var t : h3d.mat.Texture;
	public var textures : Array<h3d.mat.Texture>;
	public var next : TargetTmp;
	public var layer : Int;
	public var mipLevel : Int;
	public var depthBinding : DepthBinding;
	public function new(t, n, l, m, db) {
		this.t = t;
		this.next = n;
		this.layer = l;
		this.mipLevel = m;
		this.depthBinding = db;
	}
}

enum DepthBinding {
	ReadWrite;
	ReadOnly;
	DepthOnly;
	NotBound;
}

class Engine {
	#if multidriver
	static var ID = 0;
	public var id(default, null) : Int;
	#end

	public var driver(default,null) : h3d.impl.Driver;

	public var mem(default,null) : h3d.impl.MemoryManager;

	public var hardware(default, null) : Bool;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var debug(default, set) : Bool;

	public var drawTriangles(default, null) : Int;
	public var drawCalls(default, null) : Int;
	public var dispatches(default, null) : Int;
	public var shaderSwitches(default, null) : Int;

	public var backgroundColor : Null<Int> = 0xFF000000;
	public var autoResize : Bool;
	public var fullScreen(default, set) : Bool;

	public var fps(get, never) : Float;

	var realFps : Float;
	var lastTime : Float;
	var antiAlias : Int;
	var tmpVector = new h3d.Vector4();
	var window : hxd.Window;

	var targetTmp : TargetTmp;
	var targetStack : TargetTmp;
	var currentTargetTex : h3d.mat.Texture;
	var currentTargetLayer : Int;
	var currentTargetMip : Int;
	var currentDepthBinding : DepthBinding;
	var needFlushTarget : Bool;
	var nullTexture : h3d.mat.Texture;
	var textureColorCache = new Map<Int,h3d.mat.Texture>();
	var inRender = false;
	public var ready(default,null) = false;
	@:allow(hxd.res) var resCache = new Map<{},Dynamic>();

	public static var SOFTWARE_DRIVER = false;
	public static var ANTIALIASING = 0;

	@:access(hxd.Window)
	function new() {
		#if multidriver
		this.id = ID;
		ID++;
		#end
		this.hardware = !SOFTWARE_DRIVER;
		this.antiAlias = ANTIALIASING;
		this.autoResize = true;
		fullScreen = !hxd.System.getValue(IsWindowed);
		window = hxd.Window.getInstance();
		realFps = hxd.System.getDefaultFrameRate();
		lastTime = haxe.Timer.stamp();
		window.addResizeEvent(onWindowResize);
		setCurrent();
		#if macro
		driver = new h3d.impl.NullDriver();
		#elseif (js || hlsdl || usegl)
		#if (hlsdl && heaps_vulkan)
		if( hxd.Window.USE_VULKAN )
			driver = new h3d.impl.VulkanDriver();
		else
		#end
		#if js
		driver = js.Browser.supported ? new h3d.impl.GlDriver(antiAlias) : new h3d.impl.NullDriver();
		#else
		driver = new h3d.impl.GlDriver(antiAlias);
		#end
		#elseif (hldx && dx12)
		driver = new h3d.impl.DX12Driver();
		#elseif hldx
		driver = new h3d.impl.DirectXDriver();
		#elseif usesys
		driver = new haxe.GraphicsDriver(antiAlias);
		#else
		#if sys Sys.println #else trace #end("No output driver available." #if hl + " Compile with -lib hlsdl or -lib hldx" #end);
		#end
	}

	static var CURRENT : Engine = null;

	public function setDriver(d) {
		driver = d;
		if( mem != null ) mem.driver = d;
	}

	public static inline function getCurrent() {
		return CURRENT;
	}

	public inline function setCurrent() {
		CURRENT = this;
		window.setCurrent();
	}

	public function init() {
		driver.init(onCreate, !hardware);
	}

	public function driverName(details=false) {
		return driver.getDriverName(details);
	}

	public function selectShader( shader : hxsl.RuntimeShader ) {
		flushTarget();
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
		flushTarget();
		driver.selectBuffer(buf);
		return true;
	}

	public inline function renderTriBuffer( b : Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.getTriIndexes(b.vertices), 3, start, max);
	}

	public inline function renderQuadBuffer( b : Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.getQuadIndexes(b.vertices), 2, start, max);
	}

	// we use preallocated indexes so all the triangles are stored inside our buffers
	function renderBuffer( b : Buffer, indexes : Indexes, vertPerTri : Int, startTri = 0, drawTri = -1 ) {
		if( indexes.isDisposed() )
			return;
		var ntri = Std.int(b.vertices / vertPerTri);
		if( drawTri < 0 )
			drawTri = ntri - startTri;
		if( startTri < 0 || drawTri < 0 || startTri + drawTri > ntri )
			throw "Invalid vertices count";
		if( drawTri > 0 && selectBuffer(b) ) {
			// *3 because it's the position in indexes which are always by 3
			driver.draw(indexes, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	// we use custom indexes, so the number of triangles is the number of indexes/3
	public function renderIndexed( b : Buffer, indexes : Indexes, startTri = 0, drawTri = -1 ) {
		if( indexes.isDisposed() )
			return;
		var maxTri = Std.int(indexes.count / 3);
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 && selectBuffer(b) ) {
			// *3 because it's the position in indexes which are always by 3
			driver.draw(indexes, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	public function renderMultiBuffers( format : hxd.BufferFormat.MultiFormat, buffers : Array<Buffer>, indexes : Indexes, startTri = 0, drawTri = -1 ) {
		var maxTri = Std.int(indexes.count / 3);
		if( maxTri <= 0 ) return;
		flushTarget();
		driver.selectMultiBuffers(format, buffers);
		if( indexes.isDisposed() )
			return;
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 ) {
			// render
			driver.draw(indexes, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	public function renderInstanced( indexes : Indexes, commands : h3d.impl.InstanceBuffer ) {
		if( indexes.isDisposed() )
			return;
		if( commands.commandCount > 0 ) {
			driver.drawInstanced(indexes, commands);
			drawTriangles += commands.triCount;
			drawCalls++;
		}
	}

	function set_debug(d) {
		debug = d;
		driver.setDebug(debug);
		return d;
	}

	function onCreate( disposed ) {
		setCurrent();
		if( autoResize ) {
			width = window.width;
			height = window.height;
		}
		if( disposed ) {
			hxd.impl.Allocator.get().onContextLost();
			mem.onContextLost();
		} else {
			mem = new h3d.impl.MemoryManager(driver);
			mem.init();
			nullTexture = new h3d.mat.Texture(0, 0, [NoAlloc]);
		}
		hardware = driver.hasFeature(HardwareAccelerated);
		set_debug(debug);
		set_fullScreen(fullScreen);
		resize(width, height);
		if( disposed )
			onContextLost();
		else
			onReady();
		ready = true;
	}

	public dynamic function onContextLost() {
	}

	public dynamic function onReady() {
	}

	function onWindowResize() {
		if( autoResize && !driver.isDisposed() ) {
			var w = window.width, h = window.height;
			if( w != width || h != height )
				resize(w, h);
			onResized();
		}
	}

	function set_fullScreen(v) {
		fullScreen = v;
		if( mem != null && hxd.System.getValue(IsWindowed) ) {
			window.displayMode = v ? Borderless : Windowed;
		}
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

	public function begin(preventClear = false) {
		if( driver.isDisposed() )
			return false;
		// init
		inRender = true;
		drawTriangles = 0;
		shaderSwitches = 0;
		drawCalls = 0;
		dispatches = 0;
		targetStack = null;
		needFlushTarget = currentTargetTex != null;
		#if (usesys && !macro)
		haxe.System.beginFrame();
		#end
		driver.begin(hxd.Timer.frameCount);
		if( backgroundColor != null && !preventClear )
			clear(backgroundColor, 1, 0);
		return true;
	}

	public function hasFeature(f) {
		return driver.hasFeature(f);
	}

	public function end() {
		inRender = false;
		driver.end();
	}

	public function getCurrentTarget() {
		return targetStack == null ? null : targetStack.t == nullTexture ? targetStack.textures[0] : targetStack.t;
	}

	public function pushTarget( tex : h3d.mat.Texture, layer = 0, mipLevel = 0, depthBinding = ReadWrite ) {
		var c = targetTmp;
		if( c == null )
			c = new TargetTmp(tex, targetStack, layer, mipLevel, depthBinding);
		else {
			targetTmp = c.next;
			c.t = tex;
			c.next = targetStack;
			c.mipLevel = mipLevel;
			c.layer = layer;
			c.depthBinding = depthBinding;
		}
		targetStack = c;
		updateNeedFlush();
	}

	function updateNeedFlush() {
		var t = targetStack;
		if( t == null )
			needFlushTarget = currentTargetTex != null;
		else
			needFlushTarget = currentTargetTex != t.t || currentTargetLayer != t.layer || currentTargetMip != t.mipLevel || t.textures != null || currentDepthBinding != t.depthBinding;
	}

	public function pushTargets( textures : Array<h3d.mat.Texture>, depthBinding = ReadWrite ) {
		pushTarget(nullTexture, depthBinding);
		targetStack.textures = textures;
		needFlushTarget = true;
	}

	public function pushDepth( depthBuffer : h3d.mat.Texture ) {
		pushTarget(depthBuffer, DepthOnly);
	}

	public function popTarget() {
		var c = targetStack;
		if( c == null )
			throw "popTarget() with no matching pushTarget()";
		targetStack = c.next;
		updateNeedFlush();
		// recycle
		c.t = null;
		c.textures = null;
		c.next = targetTmp;
		targetTmp = c;
	}

	inline function flushTarget() {
		if( needFlushTarget ) doFlushTarget();
	}

	function doFlushTarget() {
		var t = targetStack;
		if( t == null ) {
			driver.setRenderTarget(null);
			currentTargetTex = null;
		} else {
			if ( t.depthBinding == DepthOnly )
				driver.setDepth(t.t);
			else if( t.textures != null )
				driver.setRenderTargets(t.textures, t.depthBinding);
			else
				driver.setRenderTarget(t.t, t.layer, t.mipLevel, t.depthBinding);
			currentTargetTex = t.t;
			currentTargetLayer = t.layer;
			currentTargetMip = t.mipLevel;
			currentDepthBinding = t.depthBinding;
		}
		needFlushTarget = false;
	}

	public function clearF( color : h3d.Vector4, ?depth : Float, ?stencil : Int ) {
		flushTarget();
		driver.clear(color, depth, stencil);
	}

	public function clear( ?color : Int, ?depth : Float, ?stencil : Int ) {
		if( color != null )
			tmpVector.setColor(color);
		flushTarget();
		driver.clear(color == null ? null : tmpVector, depth, stencil);
	}

	/**
	 * Sets up a scissored zone to eliminate pixels outside the given range.
	 * Call with no parameters to reset to full viewport.
	 */
	public function setRenderZone( x = 0, y = 0, width = -1, height = -1 ) : Void {
		flushTarget();
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

	public function onTextureBiasChanged(t : h3d.mat.Texture) {
		if ( !t.isDepth() )
			throw "Can change texture bias on depth buffer only";
		driver.onTextureBiasChanged(t);
	}

	public function dispose() {
		driver.dispose();
		window.removeResizeEvent(onWindowResize);
		if ( mem != null )
			mem.dispose();
		#if multidriver
		for ( r in resCache ) {
			var resource = Std.downcast(r, hxd.res.Resource);
			if ( resource != null ) {
				resource.entry.unwatch(id);
			}
		}
		#end
	}

	function get_fps() {
		return Math.ceil(realFps * 100) / 100;
	}

}
