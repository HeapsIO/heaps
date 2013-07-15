package h3d;
import h3d.mat.Data;

class Engine {

	var s3d : flash.display.Stage3D;
	var ctx : flash.display3D.Context3D;

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
	
	public var forcedMatBits : Int = 0;
	public var forcedMatMask : Int = 0xFFFFFF;
	
	var realFps : Float;
	var lastTime : Int;
	
	var curMatBits : Int;
	var curShader : hxsl.Shader.ShaderInstance;
	var curBuffer : h3d.impl.MemoryManager.BigBuffer;
	var curMultiBuffer : Array<h3d.impl.Buffer.BufferOffset>;
	var curAttributes : Int;
	var curTextures : Array<h3d.mat.Texture>;
	var curSamplerBits : Array<Int>;
	var antiAlias : Int;
	var inTarget : Bool;

	var debugPoint : h3d.Drawable<h3d.impl.Shaders.PointShader>;
	var debugLine : h3d.Drawable<h3d.impl.Shaders.LineShader>;
	
	@:allow(h3d)
	var curProjMatrix : h3d.Matrix;

	public function new( width = 0, height = 0, hardware = true, aa = 0, stageIndex = 0 ) {
		if( width == 0 )
			width = System.width;
		if( height == 0 )
			height = System.height;
		this.width = width;
		this.height = height;
		this.hardware = hardware;
		this.antiAlias = aa;
		this.autoResize = true;
		fullScreen = !System.isWindowed;
		var stage = flash.Lib.current.stage;
		realFps = stage.frameRate;
		lastTime = flash.Lib.getTimer();
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.addEventListener(flash.events.Event.RESIZE, onStageResize);
		s3d = stage.stage3Ds[stageIndex];
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

	public function show( b ) {
		s3d.visible = b;
	}

	public function init() {
		s3d.addEventListener(flash.events.Event.CONTEXT3D_CREATE, onCreate);
		s3d.requestContext3D( hardware ? "auto" : "software" );
	}

	public function saveTo( bmp : flash.display.BitmapData ) {
		ctx.drawToBitmapData(bmp);
	}

	public function driverName(details=false) {
		return ctx == null ? "None" : (details ? ctx.driverInfo : ctx.driverInfo.split(" ")[0]);
	}

	public function isReady() {
		return ctx != null;
	}

	public function selectShader( shader : hxsl.Shader ) {
		var s = shader.getInstance();
		if( s.program == null ) {
			s.program = ctx.createProgram();
			var vdata = s.vertexBytes.getData();
			var fdata = s.fragmentBytes.getData();
			vdata.endian = flash.utils.Endian.LITTLE_ENDIAN;
			fdata.endian = flash.utils.Endian.LITTLE_ENDIAN;
			s.program.upload(vdata, fdata);
			curShader = null; // in case we had the same shader and it was disposed
		}
		if( s != curShader ) {
			ctx.setProgram(s.program);
			shaderSwitches++;
			s.varsChanged = true;
			// unbind extra textures
			var tcount : Int = s.textures.length;
			while( curTextures.length > tcount ) {
				curTextures.pop();
				ctx.setTextureAt(curTextures.length, null);
			}
			// force remapping of vertex buffer
			curBuffer = null;
			curMultiBuffer = null;
			curShader = s;
		}
		if( s.varsChanged ) {
			s.varsChanged = false;
			ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.VERTEX, 0, s.vertexVars.toData());
			ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.FRAGMENT, 0, s.fragmentVars.toData());
			for( i in 0...s.textures.length ) {
				var t = s.textures[i];
				if( t == null || t.isDisposed() )
					t = h2d.Tile.fromColor(0xFFFF00FF).getTexture();
				var cur = curTextures[i];
				if( t != cur ) {
					ctx.setTextureAt(i, t.t);
					curTextures[i] = t;
				}
				// if we have set one of the texture flag manually or if the shader does not configure the texture flags
				if( !t.hasDefaultFlags() || !s.texHasConfig[s.textureMap[i]] ) {
					if( cur == null || t.bits != curSamplerBits[i] ) {
						ctx.setSamplerStateAt(i, WRAP[t.wrap.getIndex()], FILTER[t.filter.getIndex()], MIP[t.mipMap.getIndex()]);
						curSamplerBits[i] = t.bits;
					}
				} else {
					// the texture flags has been set by the shader, so we are in an unkown state
					curSamplerBits[i] = -1;
				}
			}
		}
	}

	@:access(h3d.mat.Material.bits)
	public function selectMaterial( m : h3d.mat.Material ) {
		var mbits = (m.bits & forcedMatMask) | forcedMatBits;
		var diff = curMatBits ^ mbits;
		if( diff != 0 ) {
			if( curMatBits < 0 || diff&3 != 0 )
				ctx.setCulling(FACE[mbits&3]);
			if( curMatBits < 0 || diff & (0xFF << 6) != 0 )
				ctx.setBlendFactors(BLEND[(mbits>>6)&15], BLEND[(mbits>>10)&15]);
			if( curMatBits < 0 || diff & (15 << 2) != 0 )
				ctx.setDepthTest((mbits >> 2) & 1 == 1, COMPARE[(mbits>>3)&7]);
			if( curMatBits < 0 || diff & (15 << 14) != 0 )
				ctx.setColorMask((mbits >> 14) & 1 != 0, (mbits >> 14) & 2 != 0, (mbits >> 14) & 4 != 0, (mbits >> 14) & 8 != 0);
			curMatBits = mbits;
		}
		selectShader(m.shader);
	}

	function selectBuffer( buf : h3d.impl.MemoryManager.BigBuffer ) {
		if( buf.isDisposed() )
			return false;
		if( buf == curBuffer )
			return true;
		curBuffer = buf;
		curMultiBuffer = null;
		if( buf.stride < curShader.stride )
			throw "Buffer stride (" + buf.stride + ") and shader stride (" + curShader.stride + ") mismatch";
		if( !buf.written )
			mem.finalize(buf);
		var pos = 0, offset = 0;
		var bits = curShader.bufferFormat;
		while( offset < curShader.stride ) {
			var size = bits & 7;
			ctx.setVertexBufferAt(pos++, buf.vbuf, offset, FORMAT[size]);
			offset += size == 0 ? 1 : size;
			bits >>= 3;
		}
		for( i in pos...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = pos;
		return true;
	}

	public inline function renderTriBuffer( b : h3d.impl.Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.indexes, 3, start, max);
	}
	
	public inline function renderQuadBuffer( b : h3d.impl.Buffer, start = 0, max = -1 ) {
		return renderBuffer(b, mem.quadIndexes, 2, start, max);
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
				ctx.drawTriangles(indexes.ibuf, pos * 3, ntri);
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
			ctx.drawTriangles(indexes.ibuf, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}
	
	public function renderMultiBuffers( buffers : Array<h3d.impl.Buffer.BufferOffset>, indexes : h3d.impl.Indexes, startTri = 0, drawTri = -1 ) {
		var maxTri = Std.int(indexes.count / 3);
		if( maxTri <= 0 ) return;
		
		// select the multiple buffers elements
		var changed = curMultiBuffer == null || curMultiBuffer.length != buffers.length;
		if( !changed )
			for( i in 0...curMultiBuffer.length )
				if( buffers[i] != curMultiBuffer[i] ) {
					changed = true;
					break;
				}
		if( changed ) {
			var pos = 0, offset = 0;
			var bits = curShader.bufferFormat;
			while( offset < curShader.stride ) {
				var size = bits & 7;
				var b = buffers[pos];
				if( b.b.next != null )
					throw "Buffer is split";
				if( !b.b.b.written )
					mem.finalize(b.b.b);
				ctx.setVertexBufferAt(pos, b.b.b.vbuf, b.offset, FORMAT[size]);
				offset += size == 0 ? 1 : size;
				bits >>= 3;
				pos++;
			}
			for( i in pos...curAttributes )
				ctx.setVertexBufferAt(i, null);
			curAttributes = pos;
			curBuffer = null;
			curMultiBuffer = buffers;
		}
		
		if( indexes.isDisposed() )
			return;
		
		if( drawTri < 0 ) drawTri = maxTri - startTri;
		if( drawTri > 0 ) {
			// render
			ctx.drawTriangles(indexes.ibuf, startTri * 3, drawTri);
			drawTriangles += drawTri;
			drawCalls++;
		}
	}

	function set_debug(d) {
		debug = d;
		if( ctx != null ) ctx.enableErrorChecking = d && hardware;
		return d;
	}

	function onCreate(_) {
		var old = ctx;
		if( old != null ) {
			if( old.driverInfo != "Disposed" ) throw "Duplicate onCreate()";
			old.dispose();
			hxsl.Shader.ShaderGlobals.disposeAll();
			ctx = s3d.context3D;
			mem.onContextLost(ctx);
		} else {
			ctx = s3d.context3D;
			mem = new h3d.impl.MemoryManager(ctx, 65400);
		}
		hardware = ctx.driverInfo.toLowerCase().indexOf("software") == -1;
		set_debug(debug);
		set_fullScreen(fullScreen);
		resize(width, height, antiAlias);
		if( old != null )
			onContextLost();
		else
			onReady();
	}
	
	public dynamic function onContextLost() {
	}

	public dynamic function onReady() {
	}
	
	function onStageResize(_) {
		if( ctx != null && autoResize && ctx.driverInfo != "Disposed" ) {
			var w = System.width, h = System.height;
			if( w != width || h != height )
				resize(w, h, antiAlias);
			onResized();
		}
	}
	
	var fsDelayed : Bool;
	function set_fullScreen(v) {
		fullScreen = v;
		if( ctx != null && System.isWindowed ) {
			var stage = flash.Lib.current.stage;
			var isAir = flash.system.Capabilities.playerType == "Desktop";
			var state = v ? (isAir ? flash.display.StageDisplayState.FULL_SCREEN_INTERACTIVE : flash.display.StageDisplayState.FULL_SCREEN) : flash.display.StageDisplayState.NORMAL;
			if( stage.displayState != state ) {
				var t = flash.Lib.getTimer();
				// delay first fullsrceen toggle on OSX/Air to prevent the command window to spawn over
				if( v && isAir && t < 5000 && !fsDelayed && flash.system.Capabilities.os.indexOf("Mac") != -1 ) {
					fsDelayed = true;
					haxe.Timer.delay(function() this.fullScreen = fullScreen, 1000);
					return v;
				}
				stage.displayState = state;
			}
		}
		return v;
	}
	
	public dynamic function onResized() {
	}

	public function resize(width, height, aa = 0) {
		// minimum 32x32 size
		if( width < 32 ) width = 32;
		if( height < 32 ) height = 32;
		this.width = width;
		this.height = height;
		this.antiAlias = aa;
		if( ctx.driverInfo != "Disposed" ) {
			try {
				ctx.configureBackBuffer(width, height, aa);
			} catch( e : Dynamic ) {
				throw Std.string(e) + " " + width + "x" + height;
			}
		}
	}

	public function begin() {
		if( ctx == null || ctx.driverInfo == "Disposed" )
			return false;
		ctx.clear( ((backgroundColor>>16)&0xFF)/255 , ((backgroundColor>>8)&0xFF)/255, (backgroundColor&0xFF)/255, ((backgroundColor>>>24)&0xFF)/255);
		// init
		frameCount++;
		drawTriangles = 0;
		shaderSwitches = 0;
		drawCalls = 0;
		curMatBits = -1;
		curShader = null;
		curBuffer = null;
		curMultiBuffer = null;
		curProjMatrix = null;
		curTextures = [];
		curSamplerBits = [];
		return true;
	}

	function reset() {
		curMatBits = -1;
		curShader = null;
		curBuffer = null;
		curMultiBuffer = null;
		for( i in 0...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = 0;
		for( i in 0...curTextures.length )
			ctx.setTextureAt(i, null);
		curTextures = [];
	}

	public function end() {
		ctx.present();
		reset();
		curProjMatrix = null;
	}

	public function setTarget( tex : h3d.mat.Texture, useDepth = false, clearColor = 0 ) {
		if( tex == null ) {
			ctx.setRenderToBackBuffer();
			inTarget = false;
		} else {
			if( inTarget )
				throw "Calling setTarget() while already set";
			ctx.setRenderToTexture(tex.t, useDepth);
			inTarget = true;
			reset();
			ctx.clear( ((clearColor>>16)&0xFF)/255 , ((clearColor>>8)&0xFF)/255, (clearColor&0xFF)/255, ((clearColor>>>24)&0xFF)/255);
		}
	}

	public function setRenderZone( x = 0, y = 0, width = -1, height = -1 ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 )
			ctx.setScissorRectangle(null);
		else
			ctx.setScissorRectangle(new flash.geom.Rectangle(x, y, width < 0 ? this.width : width, height < 0 ? this.height : height));
	}

	public function render( obj : { function render( engine : Engine ) : Void; } ) {
		if( !begin() ) return false;
		obj.render(this);
		end();
				
		var delta = flash.Lib.getTimer() - lastTime;
		lastTime += delta;
		if( delta > 0 ) {
			var curFps = 1000 / delta;
			if( curFps > realFps * 2 ) curFps = realFps * 2 else if( curFps < realFps * 0.5 ) curFps = realFps * 0.5;
			var f = delta / 500;
			if( f > 0.3 ) f = 0.3;
			realFps = realFps * (1 - f) + curFps * f; // smooth a bit the fps
		}
		return true;
	}
	
	// debug functions
	public function point( x : Float, y : Float, z : Float, color = 0x80FF0000, size = 1.0, depth = false ) {
		if( curProjMatrix == null )
			return;
		if( debugPoint == null ) {
			debugPoint = new Drawable(new h3d.prim.Plan2D(), new h3d.impl.Shaders.PointShader());
			debugPoint.material.blend(SrcAlpha, OneMinusSrcAlpha);
			debugPoint.material.depthWrite = false;
		}
		debugPoint.material.depthTest = depth ? h3d.mat.Data.Compare.LessEqual : h3d.mat.Data.Compare.Always;
		debugPoint.shader.mproj = curProjMatrix;
		debugPoint.shader.delta = new h3d.Vector(x, y, z, 1);
		var gscale = 1 / 200;
		debugPoint.shader.size = new h3d.Vector(size * gscale, size * gscale * width / height);
		debugPoint.shader.color = color;
		debugPoint.render(h3d.Engine.getCurrent());
	}

	public function line( x1 : Float, y1 : Float, z1 : Float, x2 : Float, y2 : Float, z2 : Float, color = 0x80FF0000, depth = false ) {
		if( curProjMatrix == null )
			return;
		if( debugLine == null ) {
			debugLine = new Drawable(new h3d.prim.Plan2D(), new h3d.impl.Shaders.LineShader());
			debugLine.material.blend(SrcAlpha, OneMinusSrcAlpha);
			debugLine.material.depthWrite = false;
			debugLine.material.culling = None;
		}
		debugLine.material.depthTest = depth ? h3d.mat.Data.Compare.LessEqual : h3d.mat.Data.Compare.Always;
		debugLine.shader.mproj = curProjMatrix;
		debugLine.shader.start = new h3d.Vector(x1, y1, z1);
		debugLine.shader.end = new h3d.Vector(x2, y2, z2);
		debugLine.shader.color = color;
		debugLine.render(h3d.Engine.getCurrent());
	}

	public function lineP( a : { x : Float, y : Float, z : Float }, b : { x : Float, y : Float, z : Float }, color = 0x80FF0000, depth = false ) {
		line(a.x, a.y, a.z, b.x, b.y, b.z, color, depth);
	}

	public function dispose() {
		s3d.removeEventListener(flash.events.Event.CONTEXT3D_CREATE, onCreate);
		ctx.dispose();
		ctx = null;
	}
	
	function get_fps() {
		return Math.ceil(realFps * 100) / 100;
	}

	static var BLEND = [
		flash.display3D.Context3DBlendFactor.ONE,
		flash.display3D.Context3DBlendFactor.ZERO,
		flash.display3D.Context3DBlendFactor.SOURCE_ALPHA,
		flash.display3D.Context3DBlendFactor.SOURCE_COLOR,
		flash.display3D.Context3DBlendFactor.DESTINATION_ALPHA,
		flash.display3D.Context3DBlendFactor.DESTINATION_COLOR,
		flash.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA,
		flash.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR,
		flash.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA,
		flash.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR
	];

	static var FACE = [
		flash.display3D.Context3DTriangleFace.NONE,
		flash.display3D.Context3DTriangleFace.BACK,
		flash.display3D.Context3DTriangleFace.FRONT,
		flash.display3D.Context3DTriangleFace.FRONT_AND_BACK,
	];

	static var COMPARE = [
		flash.display3D.Context3DCompareMode.ALWAYS,
		flash.display3D.Context3DCompareMode.NEVER,
		flash.display3D.Context3DCompareMode.EQUAL,
		flash.display3D.Context3DCompareMode.NOT_EQUAL,
		flash.display3D.Context3DCompareMode.GREATER,
		flash.display3D.Context3DCompareMode.GREATER_EQUAL,
		flash.display3D.Context3DCompareMode.LESS,
		flash.display3D.Context3DCompareMode.LESS_EQUAL,
	];

	static var FORMAT = [
		flash.display3D.Context3DVertexBufferFormat.BYTES_4,
		flash.display3D.Context3DVertexBufferFormat.FLOAT_1,
		flash.display3D.Context3DVertexBufferFormat.FLOAT_2,
		flash.display3D.Context3DVertexBufferFormat.FLOAT_3,
		flash.display3D.Context3DVertexBufferFormat.FLOAT_4,
	];
	
	static var WRAP = [
		flash.display3D.Context3DWrapMode.CLAMP,
		flash.display3D.Context3DWrapMode.REPEAT,
	];
	
	static var FILTER = [
		flash.display3D.Context3DTextureFilter.NEAREST,
		flash.display3D.Context3DTextureFilter.LINEAR,
	];
	
	static var MIP = [
		flash.display3D.Context3DMipFilter.MIPNONE,
		flash.display3D.Context3DMipFilter.MIPNEAREST,
		flash.display3D.Context3DMipFilter.MIPLINEAR,
	];
	
}