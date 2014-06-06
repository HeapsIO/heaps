package h3d.impl;
import h3d.impl.Driver;

#if (js||cpp)
	#if js
	import js.html.Uint16Array;
	import js.html.Uint8Array;
	import js.html.Float32Array;
	typedef _GLActiveInfo = js.html.webgl.ActiveInfo;
	
	#elseif cpp
	import openfl.gl.GL;
	typedef _GLActiveInfo = openfl.gl.GLActiveInfo;
	#end

	//to allow writin
	@:publicFields
	class GLActiveInfo {
		var size : Int;
		var type : Int;
		var name : String;
		
		function new(g:_GLActiveInfo) {
			size = g.size;
			type = g.type;
			name = g.name;
		}
	}
	
	#if js
	private typedef GL = js.html.webgl.GL;
	#elseif cpp
	private typedef Uint16Array = openfl.utils.Int16Array;
	private typedef Uint8Array = openfl.utils.UInt8Array;
	private typedef Float32Array = openfl.utils.Float32Array;
	#end

	#if js
	typedef NativeFBO = js.html.webgl.Framebuffer;//todo test
	typedef NativeRBO = js.html.webgl.Renderbuffer;//todo test
	#elseif cpp
	typedef NativeFBO = openfl.gl.GLFramebuffer;//todo test
	typedef NativeRBO = openfl.gl.GLRenderbuffer;//todo test
	#end

@:publicFields
class FBO {
	var fbo : NativeFBO;
	var color : h3d.mat.Texture;
	var rbo : NativeRBO;
	
	var width : Int=0;
	var height : Int=0;
	
	public function new() {
	
	}
}

@:publicFields
class UniformContext { 
	var texIndex : Int; 
	var inf: GLActiveInfo;
	public function new(t,i) {
		texIndex = t;
		inf = i;
	}
}


@:access(h3d.impl.Shader)
class GlDriver extends Driver {

	#if js
	var canvas : js.html.CanvasElement;
	public var gl : js.html.webgl.RenderingContext;
	#elseif cpp
	static var gl = GL;
	var fixMult : Bool;
	#end
	
	var curShader : Shader.ShaderInstance;
	var curMatBits : Int;
	var depthMask : Bool;
	var depthTest : Bool;
	var depthFunc : Int;
	var curTex : Array<h3d.mat.Texture> = [];
	
	public var shaderSwitch = 0;
	public var textureSwitch = 0;
	public var resetSwitch = 0;
	
	public function new() {
		#if js
		canvas = cast js.Browser.document.getElementById("webgl");
		if( canvas == null ) throw "Canvas #webgl not found";
		gl = canvas.getContextWebGL();
		if( gl == null ) throw "Could not acquire GL context";
		// debug if webgl_debug.js is included
		untyped if( __js__('typeof')(WebGLDebugUtils) != "undefined" ) gl = untyped WebGLDebugUtils.makeDebugContext(gl);
		#elseif cpp
		// check for a bug in HxCPP handling of sub buffers
		var tmp = new Float32Array(8);
		var sub = new Float32Array(tmp.buffer, 0, 4);
		fixMult = sub.length == 1; // should be 4
		#end

		depthMask = false;
		depthTest = false;
		depthFunc = Type.enumIndex(h3d.mat.Data.Compare.Always);
		
		curMatBits = -1;
		selectMaterial(0);
		
		fboList = new List();
	}
	
	inline function getUints( h : haxe.io.Bytes, pos = 0, size = null)
	{
		return 
		new Uint8Array(
		#if openfl 
		flash.utils.ByteArray.fromBytes( h )
		#else
		h.getData()
		#end
		, pos,size );
	}
	
	inline function getUints16( h : haxe.io.Bytes, pos = 0)
	{
		return 
		new Uint16Array(
		#if openfl 
		flash.utils.ByteArray.fromBytes( h )
		#else
		h.getData()
		#end
		, pos );
	}
	
	
	override function reset() {
		resetSwitch++;
		curShader = null;
		for( i in 0...curTex.length)
			curTex[i] = null;
		gl.useProgram(null);
	}
	
	override function selectMaterial( mbits : Int ) {
		//trace("glDriver:selectMaterial");
		var diff = curMatBits ^ mbits;
		if ( diff == 0 ) {
			//trace("glDriver:selectMaterial:already ok");
			return;
		}
			
		if( diff & 3 != 0 ) {
			if( mbits & 3 == 0 ){
				gl.disable(GL.CULL_FACE);
			}
			else {
				if ( curMatBits & 3 == 0 ){
					gl.enable(GL.CULL_FACE);
				}
				gl.cullFace(FACES[mbits&3]);
			}
		}
		
		if( diff & (0xFF << 6) != 0 ) {
			var src = (mbits >> 6) & 15;
			var dst = (mbits >> 10) & 15;
			if( src == 0 && dst == 1 ){
				gl.disable(GL.BLEND);
			}
			else {
				if ( curMatBits < 0 || (curMatBits >> 6) & 0xFF == 0x10 ) {
					gl.enable(GL.BLEND);
				}
					
				gl.blendFunc(BLEND[src], BLEND[dst]);
			}
		}
	
		if( diff & (15 << 2) != 0 ) {
			var write = (mbits >> 2) & 1 == 1;
			if ( curMatBits < 0 || diff & 4 != 0 ) {
				if( depthMask != write)
					gl.depthMask(depthMask=write);
			}
				
			if( !depthTest ){
				gl.enable(GL.DEPTH_TEST);
				depthTest = true;
			}
			
			var cmp = (mbits >> 3) & 7;
			if ( cmp == 0 ) {

				if( depthTest ){
					gl.disable(GL.DEPTH_TEST);
					depthTest = false;
				}
			}
			else {
				
				if ( curMatBits < 0 || (curMatBits >> 3) & 7 == 0 ) {
					if( !depthTest ){
						gl.enable(GL.DEPTH_TEST);
						depthTest = true;
					}
				}
				
				if( cmp != depthFunc)
					gl.depthFunc(COMPARE[depthFunc=cmp]);
			}
		}
		else {
			if( depthTest ){
				gl.disable(GL.DEPTH_TEST);
				depthTest = false;
			}
		}
		
		checkError();
			
		
		if ( diff & (15 << 14) != 0 ) {
			gl.colorMask((mbits >> 14) & 1 != 0, (mbits >> 14) & 2 != 0, (mbits >> 14) & 4 != 0, (mbits >> 14) & 8 != 0);
			checkError();
		}
		
		
		curMatBits = mbits;
		//trace("glDriver:selectMaterial:done");
	}
	
	override function clear( r : Float, g : Float, b : Float, a : Float ) {
		super.clear(r, g, b, a);
		
		curMatBits = 0;
		gl.clearColor(r, g, b, a);
		gl.depthMask(depthMask = true);
		gl.clearDepth(1.0);
		gl.depthRange(0, 1);
		gl.frontFace( GL.CW);
		gl.disable( GL.SCISSOR_TEST );
		
		//always clear depth & stencyl to enable opts
		gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
	}

	override function begin(frame) {
		depthTest = true;
		gl.enable(GL.DEPTH_TEST);
		
		depthFunc = Type.enumIndex( h3d.mat.Data.Compare.Less);
		gl.depthFunc(COMPARE[depthFunc]);
		
		curTex = [];
		curShader = null;
		textureSwitch = 0;
		shaderSwitch = 0;
		resetSwitch = 0;
	}
	
	//TODO optimize me
	override function getShaderInputNames() {
		return curShader.attribs.map(function(t) return t.name );
	}
	
	var vpWidth = 0;
	var vpHeight = 0;
	
	override function resize(width, height) {
		#if js
		canvas.width = width;
		canvas.height = height;
		#elseif cpp
		// resize window
		#end
		gl.viewport(0, 0, width, height);
		vpWidth = width; vpHeight = height;
	}
	
	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var tt = gl.createTexture();
		checkError();
		gl.bindTexture(GL.TEXTURE_2D, tt); 																			checkError();
		gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null); 			checkError();
		gl.bindTexture(GL.TEXTURE_2D, null);																		checkError();

		return tt;
	}
	
	//override function allocVertex( count : Int, stride : Int , isDynamic = false) : VertexBuffer {
	override function allocVertex( m : ManagedBuffer ) : VertexBuffer {
		
		var count = m.size;
		var stride = m.stride;
		var isDynamic = m.flags.has(Buffer.BufferFlag.Dynamic);

		//trace("allocating vertex nbFloat:" +count);
		
		var b = gl.createBuffer();
		#if js
		gl.bufferData(GL.ARRAY_BUFFER, count * stride * 4, isDynamic? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		gl.bindBuffer(GL.ARRAY_BUFFER, null); curBuffer = null; curMultiBuffer = null;
		#else
		var tmp = new Uint8Array(count * stride * 4);
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		gl.bufferData(GL.ARRAY_BUFFER, tmp,  isDynamic? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		gl.bindBuffer(GL.ARRAY_BUFFER, null); curBuffer = null; curMultiBuffer = null;
		#end
		
		return new VertexBuffer(b, stride );
	}
	
	override function allocIndexes( count : Int ) : IndexBuffer {
		//trace("allocating index");
		var b = gl.createBuffer();
		#if js
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, b);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, count * 2, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		#else
		var tmp = new Uint16Array(count);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, b);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, tmp, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		#end
		return b;
	}

	/**
	 * render target and render zone should be tightly packed to enable recursive "capture" in "capture" render scheme
	 */
	public override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 ){
			gl.disable( GL.SCISSOR_TEST );
		}
		else {
			if( x < 0 ) {
				width += x;
				x = 0;
			}
			if( y < 0 ) {
				height += y;
				y = 0;
			}
			//copied back from stage 3d impl
			// todo : support target texture
			var tw = vpWidth;
			var th = vpHeight;
			if( x+width > tw ) width = tw - x;
			if( y+height > th ) height = th - y;
			if( width <= 0 ) { x = 0; width = 1; };
			if ( height <= 0 ) { y = 0; height = 1; };
			
			gl.enable( GL.SCISSOR_TEST );
			gl.scissor(x, y, width, height);
		}
	}
	
	var fboList : List<FBO>;
	
	public function checkFBO(fbo:FBO) {
		
		#if debug
		var st = gl.checkFramebufferStatus(GL.FRAMEBUFFER);
		if (st ==  GL.FRAMEBUFFER_COMPLETE ) {
			//trace("fbo is complete");
			return;
		}
		
		var msg = switch(st) {
			default: 											"UNKNOWN ERROR";
			case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:			"FRAMEBUFFER_INCOMPLETE_ATTACHMENT​";
			case GL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:	"FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT";
			case GL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:   		"FRAMEBUFFER_INCOMPLETE_DIMENSIONS";
			
			case GL.FRAMEBUFFER_UNSUPPORTED:                    "FRAMEBUFFER_UNSUPPORTED";
		}
		
		trace("a FrameBufferObject error occured : "+msg);
		throw msg;
		#end
		
	}
	
	public override function setRenderTarget( tex : Null<h3d.mat.Texture>, clearColor : Int ) {
		
		//TODO support target depth
		var useDepth = !tex.flags.has(TargetUseDefaultDepth);
		
		if ( tex == null ) {
			gl.bindRenderbuffer( GL.RENDERBUFFER, null);
			gl.bindFramebuffer( GL.FRAMEBUFFER, null ); 
			gl.viewport( 0, 0, vpWidth, vpHeight);
		}
		else {
			var fbo : FBO = null;
			
			//tidy a bit
			for ( f in fboList) {
				if ( f.color.isDisposed() ) {
					f.color = null;
					gl.deleteFramebuffer( f.fbo );
					if( f.rbo!=null ) gl.deleteRenderbuffer( f.rbo);
					fboList.remove( f );
				}
			}
			
			for ( f in fboList) {
				if ( f.color == tex ) {
					fbo = f;
					break;
				}
			}
			
			if ( fbo == null) {
				var i = 0;
				for ( f in fboList) {
					i++;
				}
				
				fbo = new FBO();
				fboList.push(fbo);
			}
			
			if ( fbo.fbo == null ) fbo.fbo = gl.createFramebuffer();
			gl.bindFramebuffer(GL.FRAMEBUFFER, fbo.fbo);
			checkError();
						
			var bw = hxd.Math.bitCount(tex.width );
			var bh = hxd.Math.bitCount(tex.height );
			
			
			if ( bh > 1 || bw > 1) throw "invalid texture size, must be a power of two texture";
			
			fbo.width = tex.width;
			fbo.height = tex.height;
			fbo.color = tex;
			//bind color
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, fbo.color.t, 0);
			checkError();
			//bind depth
			if ( useDepth ) {
				checkError();
				if ( fbo.rbo == null) {
					fbo.rbo = gl.createRenderbuffer();
				}
				
				gl.bindRenderbuffer( GL.RENDERBUFFER, fbo.rbo);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT, fbo.width,fbo.height);
				
				checkError();
				
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, fbo.rbo);
				
				checkError();
			}
			checkError();
			checkFBO(fbo);
			
			begin(0);
			reset();
			
			//needed ?
			
			clear(	hxd.Math.b2f(clearColor>> 16),
					hxd.Math.b2f(clearColor>> 8),
					hxd.Math.b2f(clearColor),
					hxd.Math.b2f(clearColor >> 24));
					
			gl.viewport( 0, 0, tex.width, tex.height);
			
			checkError();
			#if debug
			if ( tex.width > gl.getParameter(GL.MAX_VIEWPORT_DIMS) )
				throw "invalid texture size, must be within gpu range";
			if ( tex.height > gl.getParameter(GL.MAX_VIEWPORT_DIMS) )
				throw "invalid texture size, must be within gpu range";
				
			if ( fboList.length > 256 ) 
				throw "it is unsafe to have more than 256 active fbo";
			#end
			
		}
	}
	
	override function disposeTexture( t : Texture ) {
		gl.deleteTexture(t);
	}

	override function disposeIndexes( i : IndexBuffer ) {
		gl.deleteBuffer(i);
	}
	
	override function disposeVertex( v : VertexBuffer ) {
		gl.deleteBuffer(v.b);
	}
	
	inline function makeMips()
	{
		gl.hint(GL.GENERATE_MIPMAP_HINT, GL.DONT_CARE);
		gl.generateMipmap(GL.TEXTURE_2D);
		checkError();
	}
	
	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		//trace("GlDriver:uploadTextureBitmap");
		gl.bindTexture(GL.TEXTURE_2D, t.t);
		var pix = bmp.getPixels();
		var oldFormat = pix.format;
		
		pix.convert(RGBA);
		var pixels = getUints(pix.bytes);
		
		#if debug
		var sz = gl.getParameter( GL.MAX_TEXTURE_SIZE );
		if( t.width * t.height > sz * sz ) throw "texture too big for video driver";
		#end
		
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		
		if ( mipLevel > 0 ) makeMips();
			
		gl.bindTexture(GL.TEXTURE_2D, null);
		checkError();
	}
	
	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		//trace("GlDriver:uploadTexturePixels");
		gl.bindTexture(GL.TEXTURE_2D, t.t); checkError();
		pixels.convert(RGBA);
		
		#if debug
		var sz = gl.getParameter( GL.MAX_TEXTURE_SIZE );
		if( t.width * t.height > sz * sz ) throw "texture too big for video driver";
		#end
		
		var pix = getUints( pixels.bytes, pixels.offset);
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pix);
		
		if ( mipLevel > 0 ) makeMips();
		
		gl.bindTexture(GL.TEXTURE_2D, null);
		checkError();
	}
	
	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		//trace("GlDriver:uploadVertexBuffer");
		//for ( i in 0...16) { trace("vert-" + i + " " + buf[i]); }
		var stride : Int = v.stride;
		var buf = new Float32Array(buf.getNative());
		var sub = new Float32Array(buf.buffer, bufPos, vertexCount * stride #if cpp * (fixMult?4:1) #end);
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		curBuffer = null; curMultiBuffer = null;
		checkError();
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		//trace("GlDriver:uploadVertexBytes");
		var stride : Int = v.stride;
		var buf = getUints(buf);
		var sub = getUints(buf.buffer, bufPos, vertexCount * stride * 4);
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		curBuffer = null; curMultiBuffer = null;
		checkError();
	}

	override function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		//trace("GlDriver:uploadIndexesBuffer");
		var buf = new Uint16Array(buf.getNative());
		var sub = new Uint16Array(buf.getByteBuffer(), bufPos, indiceCount #if cpp * (fixMult?2:1) #end);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		var buf = new Uint8Array(buf.getData());
		var sub = new Uint8Array(buf.getByteBuffer(), bufPos, indiceCount * 2);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}
	
	function decodeType( t : String ) : Shader.ShaderType {
		return switch( t ) {
		case "float": Float;
		case "vec2": Vec2;
		case "vec3": Vec3;
		case "vec4": Vec4;
		case "mat4": Mat4;
		default: throw "Unknown type " + t;
		}
	}
	
	function decodeTypeInt( t : Int ) : Shader.ShaderType {
		return switch( t ) {
		case GL.SAMPLER_2D:	Tex2d;
		case GL.SAMPLER_CUBE: TexCube;
		case GL.FLOAT: Float;
		case GL.FLOAT_VEC2: Vec2;
		case GL.FLOAT_VEC3: Vec3;
		case GL.FLOAT_VEC4: Vec4;
		case GL.FLOAT_MAT2: Mat2;
		case GL.FLOAT_MAT3: Mat3;
		case GL.FLOAT_MAT4: Mat4;
		default:
			gl.pixelStorei(t, 0); // get DEBUG value
			throw "Unknown type " + t;
		}
	}
	
	function typeSize( t : Shader.ShaderType ) {
		return switch( t ) {
		case Float, Byte4, Byte3: 1;
		case Vec2: 2;
		case Vec3: 3;
		case Vec4: 4;
		case Mat2: 4;
		case Mat3: 9;
		case Mat4: 16;
		case Tex2d, TexCube, Struct(_), Index(_): throw "Unexpected " + t;
		case Elements(_, nb,t ): return nb * typeSize(t); 
		}
	}
	
	
	
	function buildShaderInstance( shader : Shader ) {
		var cl = Type.getClass(shader);
		var fullCode = "";
		function compileShader(type) {
			var vertex = type == GL.VERTEX_SHADER;
			var name = vertex ? "VERTEX" : "FRAGMENT";
			var code = Reflect.field(cl, name);
			if ( code == null ) throw "Missing " + Type.getClassName(cl) + "." + name + " shader source";
			
			fullCode += code;
			var cst = shader.getConstants(vertex);
			code = StringTools.trim(cst + code);

			var gles = [ "#ifndef GL_FRAGMENT_PRECISION_HIGH\n precision mediump float;\n precision mediump int;\n #else\nprecision highp float;\n precision highp int;\n #end"];
			var notgles = [ "#define lowp  ", "#define mediump  " , "#define highp  " ];

			code = gles.map( function(s) return "#if GL_ES \n\t"+s+" \n #end \n").join('') + code;
			code = notgles.map( function(s) return "#if !defined(GL_ES) \n\t"+s+" \n #end \n").join('') + code;

			// replace haxe-like #if/#else/#end by GLSL ones
			code = ~/#if ([A-Za-z0-9_]+)/g.replace(code, "#if defined ( $1 ) \n");
			code = ~/#elseif ([A-Za-z0-9_]+)/g.replace(code, "#elif defined ( $1 ) \n");
			code = code.split("#end").join("#endif");

			//on apple software version should come first
			#if !mobile
			code = "#version 120 \n" + code;
			#end
			
			//SHADER CODE
			//trace('Trying to compile shader $name $code');
			
			var s = gl.createShader(type);
			if ( s == null ) trace("shader creation failed!");
			gl.shaderSource(s, code);
			
			checkError();
			
			gl.compileShader(s);
			
			checkError();
			
			if ( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) 
				throw "An error occurred compiling the "+Type.getClass(shader)+" : " + getShaderInfoLog(s,code);
			
			//trace("shader creation success !");
			return s;
		}
		
		var vs = compileShader(GL.VERTEX_SHADER);
		var fs = compileShader(GL.FRAGMENT_SHADER);
		
		var p = gl.createProgram();

		//before doing that we should parse code to check those attrs existence
		gl.bindAttribLocation(p, 0, "pos");
		gl.bindAttribLocation(p, 1, "uv");
		gl.bindAttribLocation(p, 2, "normal");
		gl.bindAttribLocation(p, 3, "color");
		gl.bindAttribLocation(p, 4, "weights");
		gl.bindAttribLocation(p, 5, "indexes");
		
		gl.attachShader(p, vs);
		checkError();
		gl.attachShader(p, fs);
		checkError();
		gl.linkProgram(p);
		checkError();
		if( gl.getProgramParameter(p, GL.LINK_STATUS) != cast 1 ) {
			var log = gl.getProgramInfoLog(p);
			throw "Program linkage failure: "+log;
		}
		checkError();
	
		var inst = new Shader.ShaderInstance();
			
		var nattr = gl.getProgramParameter(p, GL.ACTIVE_ATTRIBUTES);
		inst.attribs = [];
		
		var amap = new Map();
		for( k in 0...nattr ) {
			var inf = gl.getActiveAttrib(p, k);
			amap.set(inf.name, { index : gl.getAttribLocation(p,inf.name), inf : inf } );
		}
		
		
		var code = gl.getShaderSource(vs);

		// remove (and save) all #define's
		var rdef = ~/#define ([A-Za-z0-9_]+)/;
		var defs = new Map();
		while( rdef.match(code) ) {
			defs.set(rdef.matched(1), true);
			code = rdef.matchedLeft() + rdef.matchedRight();
		}
		
		// remove parts of the codes that are undefined
		var rif = ~/#if defined\(([A-Za-z0-9_]+)\)([^#]+)#endif/;
		while( rif.match(code) ) {
			if( defs.get(rif.matched(1)) )
				code = rif.matchedLeft() + rif.matched(2) + rif.matchedRight();
			else
				code = rif.matchedLeft() + rif.matchedRight();
		}
		
		// extract attributes from code (so we know the offset and stride)
		var r = ~/attribute[ \t\r\n]+([A-Za-z0-9_]+)[ \t\r\n]+([A-Za-z0-9_]+)/;
		var offset = 0;
		var ccode = code;
		while( r.match(ccode) ) {
			var aname = r.matched(2);
			var atype = decodeType(r.matched(1));
			var a = amap.get(aname);
			var size = typeSize(atype);
			if ( a != null ) {
				
				var etype = GL.FLOAT;
				var com = findVarComment(aname,ccode);
				if ( com != null ) {
					if ( StringTools.startsWith( com , "byte") )
						etype = GL.UNSIGNED_BYTE;
				}
				
				inst.attribs.push( new Shader.Attribute( aname,  atype, etype, offset , a.index , size ));
				offset += size;
			}
			
			ccode = r.matchedRight();
		}
		inst.stride = offset;//this stride is mostly not useful as it can be broken down into several stream
		
		// list uniforms needed by shader
		var allCode = code + gl.getShaderSource(fs);
		
		var nuni = gl.getProgramParameter(p, GL.ACTIVE_UNIFORMS);
		inst.uniforms = [];
		
		parseUniInfo = new UniformContext(-1,null);
		for( k in 0...nuni ) {
			parseUniInfo.inf = new GLActiveInfo( gl.getActiveUniform(p, k) );
			
			if( parseUniInfo.inf.name.substr(0, 6) == "webgl_" ) 	continue; // skip native uniforms
			if( parseUniInfo.inf.name.substr(0, 3) == "gl_" )		continue;
				
			var tu = parseUniform(  allCode,p );
			inst.uniforms.push( tu );
			//trace('adding uniform ${tu.name} ${tu.type} ${tu.loc} ${tu.index}');
		}
		
		inst.program = p;
		checkError();
		
		gl.deleteShader( vs );
		gl.deleteShader( fs );
		
		//trace('deleting temp shader objects');
		
		checkError();
		
		//trace("shader creation successful!");
		return inst;
	}
	
	var parseUniInfo : UniformContext;
	
	function findVarComment(str,code){
		var r = new EReg(str + "[ \\t]*\\/\\*([A-Za-z0-9_]+)\\*\\/", "g");
		return 
		if ( r.match(code) )
			r.matched(1);
		else 
			return null;
	}
	
	function hasArrayAccess(str,code){
		var r = new EReg("[A-Z0-9_]+[ \t]+" + str + "\\[[a-z](.+?)\\]", "gi");
		return 
		if ( r.match(code) )
			true;
		else false;
	}

	
	function parseUniform(allCode,p)
	{
		var inf : GLActiveInfo = parseUniInfo.inf;
		
		var isSubscriptArray = false;
		var t = decodeTypeInt(inf.type);
		var scanSubscript = true;
		var r_array = ~/\[([0-9]+)\]$/g;
		
		switch( t ) {
			case Tex2d, TexCube: parseUniInfo.texIndex++;
			case Vec3:
				var c = findVarComment( inf.name, allCode );
				var isByte = StringTools.startsWith( c , "byte" );
				if( c != null && isByte )
					t = Byte3;
				else {
					if ( hasArrayAccess(inf.name.split('.').pop(), allCode ) ) 
						isSubscriptArray = true;
				}
			case Vec4:
				var c = findVarComment( inf.name, allCode );
				var isByte = StringTools.startsWith( c , "byte" );
				if( c != null && isByte )
					t = Byte4;
				else {
					if ( hasArrayAccess(inf.name.split('.').pop(), allCode ) ) 
						isSubscriptArray = true;
				}
			case Mat4:
				var li = inf.name.lastIndexOf("[");
				if ( li >= 0 )
					inf.name = inf.name.substr( 0,li );
					
				if(  hasArrayAccess(inf.name,allCode ) ) {
					scanSubscript = false;
					t = Elements( inf.name, null, t );
				}
				
			default:	
				//trace('can t subtype $t ${inf.type}');
		}
		
		//todo refactor all...but it will wait hxsl3

		var name = inf.name;
		while ( scanSubscript ) {
			if ( r_array.match(name) ) { //
				name = r_array.matchedLeft();
				t = Index(Std.parseInt(r_array.matched(1)), t);
				continue;
			}
			
			var c = name.lastIndexOf(".");
			if ( c < 0) {
				c = name.lastIndexOf("[");
			}
			
			if ( c > 0 ) {
				var field = name.substr(c + 1);
				name = name.substr(0, c);
				if ( !isSubscriptArray){ //struct subscript{
					t = Struct(field, t);
				}
				else //array subscript{
					t = Elements( field, inf.size, t );
			}
			break;
		}
		
		
		return new Shader.Uniform(
			name,
			gl.getUniformLocation(p, inf.name),
			t,
			parseUniInfo.texIndex
		);
	}
	
	public override function deleteShader(shader : Shader) {
		if ( shader == null ) {
			#if debug
				throw "Shader not set ?";
			#end
			return;
		}
		
		gl.deleteProgram(shader.instance.program);
	}
	
	override function selectShader( shader : Shader ) : Bool {
		var change = false;
		if ( shader.instance == null ) {
			shader.instance = buildShaderInstance(shader);
		}
		if ( shader.instance != curShader ) {
			var old = curShader;
			//trace("binding shader "+Type.getClass(shader)+" nbAttribs:"+shader.instance.attribs.length);
			curShader = shader.instance;
			
			if (curShader.program == null) throw "invalid shader";
			gl.useProgram(curShader.program);
			
			var oa = 0;
			if ( old != null )
				for ( a in old.attribs) 
					oa |= 1<<a.index;
					
			var na = 0;
				for ( a in curShader.attribs) 
					na |= 1<<a.index;
				
			if ( old != null )
				for ( a in old.attribs)
					if( na&(1<<a.index) == 0)
						gl.disableVertexAttribArray(a.index);
			
			for ( a in curShader.attribs)
				if( oa&(1<<a.index) == 0)
					gl.enableVertexAttribArray(a.index);
				
			change = true;
			shaderSwitch++;
		}
			
		
		for ( u in curShader.uniforms ) {
			if ( u == null ) throw "Missing uniform pointer";
			if ( u.loc == null ) throw "Missing uniform location";
			
			var val : Dynamic = Reflect.getProperty(shader, u.name);
			if ( val == null ) {
				if ( Reflect.hasField( shader, u.name) ) 
					throw 'Shader param ${u.name} is null';
				else 
					throw "Missing shader value " + u.name + " among "+ Reflect.fields(shader);
			}
			setUniform(val, u, u.type,change);
		}
		
		shader.customSetup(this);
		checkError();
		
		return change;
	}
	
	/**
	 * 
	 * @param	t
	 * @param	?stage relevant texture stage
	 * @param	mipMap
	 * @param	filter
	 * @param	wrap
	 * @return true if context was reused ( maybe you can make good use of the info )
	 */
	public function setupTexture( t : h3d.mat.Texture, stage : Int, mipMap : h3d.mat.Data.MipMap, filter : h3d.mat.Data.Filter, wrap : h3d.mat.Data.Wrap ) : Bool {
		//trace("setuping texture");
		if( curTex[stage] != t ){
			gl.bindTexture(GL.TEXTURE_2D, t.t);
			var flags = TFILTERS[Type.enumIndex(mipMap)][Type.enumIndex(filter)];
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, flags[0]);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, flags[1]);
			var w = TWRAP[Type.enumIndex(wrap)];
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, w);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, w);
			checkError();
			curTex[stage] = t;
			textureSwitch++;
			return true;
		}
		return false;
	}
	
	inline function blitMatrices(a:Array<Matrix>, transpose) {
		//trace("blitting matrices");
		var t = createF32( a.length * 16 );
		var p = 0;
		for ( m in a ){
			blitMatrix( m, transpose, p,t  );
			p += 16;
		}
		return t;
	}
	
	inline function blitMatrix(a:Matrix, transpose, ofs = 0, t :Float32Array=null) {
		if (t == null) t = createF32( 16 );
		
		if ( !transpose) {
			t[ofs+0] 	= a._11; 
			t[ofs+1] 	= a._12; 
			t[ofs+2] 	= a._13; 
			t[ofs+3] 	= a._14;
			     
			t[ofs+4] 	= a._21; 
			t[ofs+5] 	= a._22; 
			t[ofs+6] 	= a._23; 
			t[ofs+7] 	= a._24;
			    
			t[ofs+8] 	= a._31; 
			t[ofs+9]	= a._32; 
			t[ofs+10] = a._33; 
			t[ofs+11] = a._34;
			 
			t[ofs+12] = a._41; 
			t[ofs+13] = a._42; 
			t[ofs+14] = a._43; 
			t[ofs+15] = a._44;
		}
		else {
			t[ofs+0] 	= a._11; 
			t[ofs+1] 	= a._21; 
			t[ofs+2] 	= a._31; 
			t[ofs+3] 	= a._41;
			     
			t[ofs+4] 	= a._12; 
			t[ofs+5] 	= a._22; 
			t[ofs+6] 	= a._32; 
			t[ofs+7] 	= a._42;
			    
			t[ofs+8] 	= a._13; 
			t[ofs+9] 	= a._23; 
			t[ofs+10] = a._33; 
			t[ofs+11] = a._43;
			      
			t[ofs+12] = a._14; 
			t[ofs+13] = a._24; 
			t[ofs+14] = a._34; 
			t[ofs+15] = a._44;
		}
		return t;
	}
	
	public static var f32Pool : haxe.ds.IntMap<Float32Array> =  new haxe.ds.IntMap();
	
	function createF32(sz:Int) : Float32Array {
		if ( !f32Pool.exists(sz) ) {
			f32Pool.set(sz, new Float32Array([for( i in 0...sz) 0.0]));
		}
		
		var p = f32Pool.get( sz );
		
		for ( i in 0...p.length ) p[i] = 0.0;
		
		f32Pool.set( sz, null);
		return p;
	}
	
	function deleteF32(a:Float32Array) {
		f32Pool.set(a.length, a);
	}
	
	
	
	function setUniform( val : Dynamic, u : Shader.Uniform, t : Shader.ShaderType , shaderChange) {
		
		var buff : Float32Array = null;
		#if debug if (u == null) throw "no uniform set, check your shader"; #end
		#if debug if (u.loc == null) throw "no uniform loc set, check your shader"; #end
		#if debug if (val == null) throw "no val set, check your shader"; #end
		#if debug if (gl == null) throw "no gl set, Arrrghh"; #end
		
		checkError();
		
		//trace("setting uniform " + u.name+ " of type "+t +" and value "+val );
		
		switch( t ) {
		case Mat4:
			
			#if debug
			if ( Std.is( val , Array)) throw "error";
			#end
			
			var m : h3d.Matrix = val;
			gl.uniformMatrix4fv(u.loc, false, buff = blitMatrix(m, true) );
			deleteF32(buff);
			
		case Tex2d:
			var t : h3d.mat.Texture = val;
			var reuse = setupTexture(t, u.index, t.mipMap, t.filter, t.wrap);
			if ( !reuse || shaderChange ) {
				gl.activeTexture(GL.TEXTURE0 + u.index);
				gl.uniform1i(u.loc,  u.index);
			}
			
		case Float: var f : Float = val;  		gl.uniform1f(u.loc, f);
		case Vec2:	var v : h3d.Vector = val;	gl.uniform2f(u.loc, v.x, v.y);
		case Vec3:	var v : h3d.Vector = val;	gl.uniform3f(u.loc, v.x, v.y, v.z);
		case Vec4:	var v : h3d.Vector = val;	gl.uniform4f(u.loc, v.x, v.y, v.z, v.w);
		
		case Struct(field, t):
			var vs = Reflect.field(val, field);
			
			if ( t == null ) throw "Missing shader type " + t;
			if ( u == null ) throw "Missing shader loc " + u;
			if ( vs == null ) throw "Missing shader field " + field+ " in " +val;
			
			setUniform(vs, u, t,shaderChange);
			
		case Elements(field, nb, t): {
			
			switch(t) {
				case Vec3: 
					var arr : Array<Vector> = Reflect.field(val, field);
					if (arr.length > nb) arr = arr.slice(0, nb);
					gl.uniform3fv( u.loc, buff = packArray3(arr));
					
				case Vec4: 
					var arr : Array<Vector> = Reflect.field(val, field);
					if (arr.length > nb) arr = arr.slice(0, nb);
					gl.uniform4fv( u.loc, buff = packArray4(arr));
					
				case Mat4: 
					var ms : Array<h3d.Matrix> = val;
					//if ( nb != null && ms.length != nb)  trace('Array uniform type mismatch $nb requested, ${ms.length} found');
						
					gl.uniformMatrix4fv(u.loc, false, buff = blitMatrices(ms,true) );
					
				default: throw "not supported";
			}
			deleteF32(buff);
		}
			
		case Index(index, t):
			var v = val[index];
			if( v == null ) throw "Missing shader index " + index;
			setUniform(v, u, t,shaderChange);
		case Byte4:
			var v : Int = val;
			gl.uniform4f(u.loc, ((v >> 16) & 0xFF) / 255, ((v >> 8) & 0xFF) / 255, (v & 0xFF) / 255, (v >>> 24) / 255);
		case Byte3:
			var v : Int = val;
			gl.uniform3f(u.loc, ((v >> 16) & 0xFF) / 255, ((v >> 8) & 0xFF) / 255, (v & 0xFF) / 255);
		default:
			throw "Unsupported uniform " + u.type;
		}
		
		checkError();
		
	}
	//TODO cache this
	function packArray4( vecs : Array<Vector> ):Float32Array{
		var a = createF32(vecs.length*4);
		for ( i in 0...vecs.length) {
			var vec = vecs[i];
			a[i * 4  ] = vec.x;
			a[i * 4+1] = vec.y;
			a[i * 4+2] = vec.z;
			a[i * 4+3] = vec.w;
		}
		return a;
	}
	
	//TODO cache this
	function packArray3( vecs : Array<Vector> ):Float32Array{
		var a = createF32(vecs.length*4);
		for ( i in 0...vecs.length) {
			var vec = vecs[i];
			a[i * 3] = vec.x;
			a[i * 3+1] = vec.y;
			a[i * 3+2] = vec.z;
		}
		return a;
	}
	
	var curBuffer : VertexBuffer;
	var curMultiBuffer : Array<Int>;
	
	override function selectBuffer( v : VertexBuffer ) {
		var ob = curBuffer;
		
		curBuffer = v;
		curMultiBuffer = null;
		
		var stride : Int = v.stride;
		if ( ob != v ) 
			gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		
		checkError();
		
		//this one is shared most of the time, let's define it fully
		for ( a in curShader.attribs ) {
			var ofs = a.offset * 4;
			gl.vertexAttribPointer(a.index, a.size, a.etype, false, stride*4, ofs);
		}
		
		checkError();
	}
	
	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		// select the multiple buffers elements
		var changed = false;
		var b = buffers;
		var i = 0;
		while( b != null  ) {
			if( b == null || b.id != curMultiBuffer[i] ) {
				changed = true;
				break;
			}
			b = b.next;
			i++;
		}
				
		
		if ( changed ) {
			var b = buffers;
			var i = 0;
			while( b != null  ) {
				var a = curShader.attribs[i];
				gl.bindBuffer(GL.ARRAY_BUFFER, @:privateAccess b.buffer.buffer.vbuf.b);
				gl.vertexAttribPointer( a.index, a.size, a.etype, false, b.buffer.buffer.stride * 4, b.offset * 4);
				curMultiBuffer[i] = b.id;
				checkError();
				i++;
			}
			
			for ( v in i...curMultiBuffer.length)
				curMultiBuffer[v] = -1;
			curBuffer = null;
		}
	}
	
	public function checkObject(o:openfl.gl.GLObject) {
		#if cpp
		//trace( o.toStrig() + " " + (untyped o.getType()) + " " + o.isValid() );
		if ( !o.isValid() ) throw "assert GlDriver.checkObject";
		#end
	}
	
	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		//trace("glDriver:draw");
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf);
		gl.drawElements(GL.TRIANGLES, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}
	
	override function present() {
		//trace("glDriver:present");
		//useless ofl will do it at swap time
		#if !openfl
			gl.finish();
		#end
	}

	override function isDisposed() {
		return false;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		haxe.Timer.delay(onCreate.bind(false), 1);
	}
	
	static var TFILTERS = [
		[[GL.NEAREST,GL.NEAREST],[GL.LINEAR,GL.LINEAR]],
		[[GL.NEAREST,GL.NEAREST_MIPMAP_NEAREST],[GL.LINEAR,GL.LINEAR_MIPMAP_NEAREST]],
		[[GL.NEAREST,GL.NEAREST_MIPMAP_LINEAR],[GL.LINEAR,GL.LINEAR_MIPMAP_LINEAR]],
	];
	
	static var TWRAP = [
		GL.CLAMP_TO_EDGE,
		GL.REPEAT,
	];
	
	static var FACES = [
		0,
		GL.BACK,
		GL.FRONT,
		GL.FRONT_AND_BACK,
	];
	
	static var BLEND = [
		GL.ONE,
		GL.ZERO,
		GL.SRC_ALPHA,
		GL.SRC_COLOR,
		GL.DST_ALPHA,
		GL.DST_COLOR,
		GL.ONE_MINUS_SRC_ALPHA,
		GL.ONE_MINUS_SRC_COLOR,
		GL.ONE_MINUS_DST_ALPHA,
		GL.ONE_MINUS_DST_COLOR,
		GL.CONSTANT_COLOR,
		GL.CONSTANT_ALPHA,
		GL.ONE_MINUS_CONSTANT_COLOR,
		GL.ONE_MINUS_CONSTANT_ALPHA,
		GL.SRC_ALPHA_SATURATE,
	];
	
	static var COMPARE = [
		GL.ALWAYS,
		GL.NEVER,
		GL.EQUAL,
		GL.NOTEQUAL,
		GL.GREATER,
		GL.GEQUAL,
		GL.LESS,
		GL.LEQUAL,
	];
	
	function glCompareToString(c){
		return switch(c) {
			case GL.ALWAYS    :      "ALWAYS";
			case GL.NEVER     :      "NEVER";  
			case GL.EQUAL     :      "EQUAL";   
			case GL.NOTEQUAL  :      "NOTEQUAL";
			case GL.GREATER   :      "GREATER";
			case GL.GEQUAL    :      "GEQUAL";  
			case GL.LESS      :      "LESS";    
			case GL.LEQUAL    :      "LEQUAL";
			default :			 	"Unknown";
		}
	}


	public inline function checkError() {
		#if debug
		if (gl.getError() != GL.NO_ERROR)
		{
			var s = getError();
			if ( s != null) {
				var str = "GL_ERROR:" + s;
				trace(str);
				throw s;
			}
		}
		#end
	}
	
	public inline function getError() {
		return 
		switch(gl.getError()) {
			case GL.NO_ERROR                      	: null;
			case GL.INVALID_ENUM                  	:"INVALID_ENUM";
			case GL.INVALID_VALUE                 	:"INVALID_VALUE";
			case GL.INVALID_OPERATION           	:"INVALID_OPERATION";
			case GL.OUT_OF_MEMORY               	:"OUT_OF_MEMORY";
			default 								:null;
		}
	}
	
	public inline function getShaderInfoLog(s, code) {
		var log = gl.getShaderInfoLog(s);
		if ( log == null ) return "";
		var lines = code.split("\n");
		var index = Std.parseInt(log.substr(9));
		if (index == null) return "";
		index--;
		if ( lines[index] == null ) return "";
		var line = lines[index];
		if ( line == null ) 
			line = "-" 
		else 
			line = "(" + StringTools.trim(line) + ").";
		return log + line;
	}
	
	public inline function getProgramInfoLog(p,code) {
		var log = gl.getProgramInfoLog(p);
		var hnt = log.substr(26);
		var line = code.split("\n")[Std.parseInt(hnt)];
		if ( line == null ) 
			line = "-" 
		else 
			line = "(" + StringTools.trim(line) + ").";
		return log + line;
	}

	public function restoreOpenfl() {
		//trace("restoring openfl");

		gl.depthRange(0, 1);
		gl.clearDepth(-1);
		gl.depthMask(true);
		gl.colorMask(true,true,true,true);
		gl.disable(GL.DEPTH_TEST);
		gl.frontFace(GL.CCW);
		gl.enable( GL.BLEND );
		gl.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		gl.disable(GL.CULL_FACE);
		gl.bindTexture(GL.TEXTURE_2D, null);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
		curShader = null;
		curMatBits = 0;
		depthMask = false;
		depthTest = false;
		depthFunc = -1;
		curTex = null;
		curBuffer = null; 
		curMultiBuffer = null;
	}
	
}

#end
