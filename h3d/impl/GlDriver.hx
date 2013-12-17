package h3d.impl;

import h3d.impl.Driver;
import h3d.impl.GlDriver.FBO;
import h3d.Matrix;
import h3d.Vector;
import haxe.ds.IntMap.IntMap;
import hxd.BytesBuffer;
import hxd.Math;
import hxd.Profiler;

import hxd.FloatBuffer;
import hxd.Pixels;
import hxd.System;

#if (js||cpp)

#if js
import js.html.Uint16Array;
import js.html.Uint8Array;
import js.html.Float32Array;
#elseif cpp
import openfl.gl.GL;
import openfl.gl.GLActiveInfo;
#end

using StringTools;

#if js
private typedef GL = js.html.webgl.GL;
#elseif cpp
private typedef Uint16Array = openfl.utils.Int16Array;
private typedef Uint8Array = openfl.utils.UInt8Array;
private typedef Float32Array = openfl.utils.Float32Array;
#end

#if js
typedef NativeFBO = js.html.webgl.Framebuffer;//todo test
typedef NativeRBO = js.html.webgl.RenderBuffer;//todo test
#elseif cpp
typedef NativeFBO = openfl.gl.GLFramebuffer;//todo test
typedef NativeRBO = openfl.gl.GLRenderbuffer;//todo test
#end

@:publicFields
class FBO {
	var fbo : NativeFBO;
	var color : Texture;
	var rbo : NativeRBO;
	
	var width : Int=0;
	var height : Int=0;
	
	public function new() {
	
	}
}

@:publicFields
class UniformContext { 
	var texIndex : Int; 
	var inf: openfl.gl.GLActiveInfo;
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
	
	//var curAttribs : Int;
	var curShader : Shader.ShaderInstance;
	var curMatBits : Int;
	

	var depthMask : Bool;
	var depthTest : Bool;
	var depthFunc : Int;
	
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
		
	//	curAttribs = 0;
		curMatBits = -1;
		selectMaterial(0);

		System.trace3('gldriver newed');
		
		fboList = new List();
	}
	
	
	override function reset() {
		curShader = null;
		gl.useProgram(null);
	}
	
	override function selectMaterial( mbits : Int ) {
		Profiler.begin("gldriver.select_material");
		var diff = curMatBits ^ mbits;
		if( diff == 0 )
			return;
			
		if( diff & 3 != 0 ) {
			if( mbits & 3 == 0 )
				gl.disable(GL.CULL_FACE);
			else {
				if ( curMatBits & 3 == 0 )
					gl.enable(GL.CULL_FACE);
				gl.cullFace(FACES[mbits&3]);
			}
		}
		
		if( diff & (0xFF << 6) != 0 ) {
			var src = (mbits >> 6) & 15;
			var dst = (mbits >> 10) & 15;
			if( src == 0 && dst == 1 ){
				gl.disable(GL.BLEND);
				System.trace3('disabling blend');
			}
			else {
				if ( curMatBits < 0 || (curMatBits >> 6) & 0xFF == 0x10 ) 
					gl.enable(GL.BLEND);
					
				gl.blendFunc(BLEND[src], BLEND[dst]);
				System.trace3('blend func ${BLEND[src]} ${BLEND[dst]}');
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
				System.trace3("no depth test");
				
				if( depthTest ){
					gl.disable(GL.DEPTH_TEST);
					depthTest = false;
				}
			}
			else {
				
				if ( curMatBits < 0 || (curMatBits >> 3) & 7 == 0 ) {
					System.trace3("enabling depth test");
					if( !depthTest ){
						gl.enable(GL.DEPTH_TEST);
						depthTest = true;
					}
				}
				
				System.trace3("using " + glCompareToString(COMPARE[cmp]));
					
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
			System.trace3("using color mask");
					
			gl.colorMask((mbits >> 14) & 1 != 0, (mbits >> 14) & 2 != 0, (mbits >> 14) & 4 != 0, (mbits >> 14) & 8 != 0);
			checkError();
		}
			
		curMatBits = mbits;
		System.trace3('gldriver select material');
		Profiler.end("gldriver.select_material");
	}
	
	override function clear( r : Float, g : Float, b : Float, a : Float ) {
		
		curMatBits = 0;
		gl.clearColor(r, g, b, a);
		gl.depthMask(depthMask = true);
		gl.clearDepth(1.0);
		gl.depthRange(0, 1);
		gl.frontFace( GL.CW);
		
		//always clear depth & stencyl to enable opts
		gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
		hxd.System.trace3("clearing");
		
		depthTest = true;
		gl.enable(GL.DEPTH_TEST);
		
		depthFunc = Type.enumIndex( h3d.mat.Data.Compare.Less);
		gl.depthFunc(COMPARE[depthFunc]);
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
		System.trace2("resizing");
	}
	
	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var tt = gl.createTexture();
		gl.bindTexture(GL.TEXTURE_2D, tt);
		gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
		gl.bindTexture(GL.TEXTURE_2D, null);
		return tt;
	}
	
	override function allocVertex( count : Int, stride : Int ) : VertexBuffer {
		var b = gl.createBuffer();
		#if js
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		gl.bufferData(GL.ARRAY_BUFFER, count * stride * 4, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		#else
		var tmp = new Uint8Array(count * stride * 4);
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		gl.bufferData(GL.ARRAY_BUFFER, tmp, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		#end
		return new VertexBuffer(b, stride );
	}
	
	override function allocIndexes( count : Int ) : IndexBuffer {
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

	public override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 )
			//ctx.setScissorRectangle(null);
			gl.disable( GL.SCISSOR_TEST );
		else {
			var x = x < 0 ? 0 : x;
			var y = y < 0 ? 0 : y;
			//copied back from stage 3d impl
			// todo : support target texture
			var tw = vpWidth;
			var th = vpHeight;
			if( x+width > tw ) width = tw - x;
			if( y+height > th ) height = th - y;
			if( width < 0 ) { x = 0; width = 0; };
			if ( height < 0 ) { y = 0; height = 0; };
			
			gl.enable( GL.SCISSOR_TEST );
			gl.scissor(x, y, width, height);
		}
	}
	
	var inTarget : h3d.mat.Texture;
	var fboList : List<FBO>;
	
	public function checkFBO(fbo:FBO) {
		
		#if debug
		var st = gl.checkFramebufferStatus(GL.FRAMEBUFFER);
		if (st ==  GL.FRAMEBUFFER_COMPLETE )
			return;
		
		throw switch(st) {
			default: 											"UNKNOWN ERROR";
			case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:			"FRAMEBUFFER_INCOMPLETE_ATTACHMENT​";
			case GL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:	"FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT";
			case GL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:   		"FRAMEBUFFER_INCOMPLETE_DIMENSIONS";
			
			case GL.FRAMEBUFFER_UNSUPPORTED:                    "FRAMEBUFFER_UNSUPPORTED";
		}
		#end
		
	}
	
	public override function setRenderTarget( tex : Null<h3d.mat.Texture>, useDepth : Bool, clearColor : Int ) {
		if ( tex == null ) {
			gl.bindRenderbuffer( GL.RENDERBUFFER, null);
			gl.bindFramebuffer( GL.FRAMEBUFFER, null ); 
			inTarget = null;
		}
		else {
			var fbo : FBO = null;
			for ( f in fboList) {
				if ( f.color == tex.t ) {
					fbo = f;
					break;
				}
			}
			if ( fbo == null) {
				fbo = new FBO();
				fboList.push(fbo);
			}
			
			if ( inTarget != null ) throw "Calling setTarget() while already set";
			inTarget = tex;
			
			if ( fbo.fbo == null ) fbo.fbo = gl.createFramebuffer();
			gl.bindFramebuffer(gl.FRAMEBUFFER, fbo.fbo);
						
			var bw = Math.bitCount(tex.width );
			var bh = Math.bitCount(tex.height );
			
			if ( bh > 1 || bw > 1) throw "invalid texture size, must be a power of two texture";
			
			fbo.width = tex.width;
			fbo.height = tex.height;
			fbo.color = tex.t;
			//bind color
			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, fbo.color, 0);
			
			//bind depth
			if ( useDepth ) {
				if( fbo.rbo ==null) fbo.rbo = gl.createRenderbuffer();
				gl.bindRenderbuffer( gl.RENDERBUFFER, fbo.rbo);
				gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, fbo.rbo);
			}
			checkFBO(fbo);
			
			reset();
			clear(	Math.b2f(clearColor>> 16),
					Math.b2f(clearColor>> 8),
					Math.b2f(clearColor),
					Math.b2f(clearColor>>24));
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
		gl.hint(gl.GENERATE_MIPMAP_HINT, gl.DONT_CARE);
		gl.generateMipmap(GL.TEXTURE_2D);
		checkError();
	}
	
	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		gl.bindTexture(GL.TEXTURE_2D, t.t);
		var pix = bmp.getPixels();
		pix.convert(RGBA);
		var pixels = new Uint8Array(pix.bytes.getData());
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		
		if ( mipLevel > 0 ) makeMips();
			
		gl.bindTexture(GL.TEXTURE_2D, null);
		checkError();
	}
	
	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		gl.enable(GL.TEXTURE_2D);
		gl.bindTexture(GL.TEXTURE_2D, t.t);
		pixels.convert(RGBA);
		var pixels = new Uint8Array(pixels.bytes.getData());
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		
		if ( mipLevel > 0 ) makeMips();
		
		gl.bindTexture(GL.TEXTURE_2D, null);
		checkError();
	}
	
	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride : Int = v.stride;
		var buf = new Float32Array(buf.getNative());
		var sub = new Float32Array(buf.buffer, bufPos, vertexCount * stride #if cpp * (fixMult?4:1) #end);
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		checkError();
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride : Int = v.stride;
		var buf = new Uint8Array(buf.getData());
		var sub = new Uint8Array(buf.buffer, bufPos, vertexCount * stride * 4);
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		checkError();
	}

	override function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var buf = new Uint16Array(buf.getNative());
		var sub = new Uint16Array(buf.buffer, bufPos, indiceCount #if cpp * (fixMult?2:1) #end);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		var buf = new Uint8Array(buf.getData());
		var sub = new Uint8Array(buf.buffer, bufPos, indiceCount * 2);
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
			
			System.trace3("compiling cst: \n" + cst);
			//System.trace3("compiling code: \n" + code);
			
			code = StringTools.trim(cst + code);

			

			var gles = [ "precision highp float; "];
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

			System.trace3("compiling code: \n" + code);
			
			
			//SHADER CODE
			//System.trace2('Trying to compile shader $name $code');
			
			var s = gl.createShader(type);
			gl.shaderSource(s, code);
			if ( System.debugLevel >= 2) {
				trace("source shaderInfoLog:" + getShaderInfoLog(s,code));
			}
				
			gl.compileShader(s);
			if( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
				throw "An error occurred compiling the "+Type.getClass(shader)+" : " + getShaderInfoLog(s,code);
			}
			else {
				
				//always print him becausit can hint gles errors
				if ( System.debugLevel >= 2) {
					trace("compile shaderInfoLog:" + getShaderInfoLog(s,code));
				}
			}
			
			return s;
		}
		
		var vs = compileShader(GL.VERTEX_SHADER);
		var fs = compileShader(GL.FRAGMENT_SHADER);
		
		var p = gl.createProgram();

		//before doign that we should parse code to check those attrs existence
		gl.bindAttribLocation(p, 0, "pos");
		gl.bindAttribLocation(p, 1, "uv");
		gl.bindAttribLocation(p, 2, "normal");
		gl.bindAttribLocation(p, 3, "color");
		gl.bindAttribLocation(p, 4, "weights");
		gl.bindAttribLocation(p, 5, "indexes");
		
		gl.attachShader(p, vs);
		checkError();
		
		System.trace2("attach vs programInfoLog:" + getProgramInfoLog(p, fullCode));
		
		gl.attachShader(p, fs);
		checkError();
		
		System.trace2("attach fs programInfoLog:" + getProgramInfoLog(p,fullCode));
		
		gl.linkProgram(p);
		checkError();
		
		System.trace2("link programInfoLog:" + getProgramInfoLog(p,fullCode));
		
		if( gl.getProgramParameter(p, GL.LINK_STATUS) != cast 1 ) {
			var log = gl.getProgramInfoLog(p);
			throw "Program linkage failure: "+log;
		}
		else {
			System.trace2("linked programInfoLog:" + getProgramInfoLog(p, fullCode));
		}
		
		checkError();
	
		var inst = new Shader.ShaderInstance();
			
		var nattr = gl.getProgramParameter(p, GL.ACTIVE_ATTRIBUTES);
		inst.attribs = [];
		
		var amap = new Map();
		for( k in 0...nattr ) {
			var inf = gl.getActiveAttrib(p, k);
			amap.set(inf.name, { index : gl.getAttribLocation(p,inf.name), inf : inf } );
			if (System.debugLevel>=2) trace('adding attributes $inf');
			if (System.debugLevel>=2) trace("attr loc" + gl.getAttribLocation(p,inf.name));
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
					//if ( System.debugLevel>=2) trace("found comment on " + aname + " " + com);
					if ( com.startsWith("byte") )
						etype = GL.UNSIGNED_BYTE;
				}
				else 
				{
					//if ( System.debugLevel>=2) trace("didn't find comment on var " + aname);
				}
				
				inst.attribs.push( new Shader.Attribute( aname,  atype, etype, offset , a.index , size ));
			}
			offset += size;
			ccode = r.matchedRight();
		}
		inst.stride = offset;//this stride is mostly not useful as it can be broken down into several stream
		
		// list uniforms needed by shader
		var allCode = code + gl.getShaderSource(fs);
		
		var nuni = gl.getProgramParameter(p, GL.ACTIVE_UNIFORMS);
		inst.uniforms = [];
		
		parseUniInfo = new UniformContext(-1,null);
		//parseUniInfo = { texIndex: -1, inf:null };
		for( k in 0...nuni ) {
			parseUniInfo.inf = gl.getActiveUniform(p, k);
			
			//if ( System.isVerbose) trace("retrieving uniform " + inf.name);
			if( parseUniInfo.inf.name.substr(0, 6) == "webgl_" )
				continue; // skip native uniforms
				
			if( parseUniInfo.inf.name.substr(0, 3) == "gl_" )
				continue;
				
			var tu = parseUniform(  allCode,p );
			inst.uniforms.push( tu );
			System.trace2('adding uniform ${tu.name} ${tu.type} ${tu.loc} ${tu.index}');
		}
		
		inst.program = p;
		checkError();
		return inst;
	}
	
	//var parseUniInfo : { var texIndex : Int; var inf: openfl.gl.GLActiveInfo;};
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
		
		System.trace2('retrieved uniform $inf');
		
		var isSubscriptArray = false;
		var t = decodeTypeInt(inf.type);
		var scanSubscript = true;
		var r_array = ~/\[([0-9]+)\]$/g;
		
		switch( t ) {
			case Tex2d, TexCube: parseUniInfo.texIndex++;
			case Vec3:
				var c = findVarComment( inf.name,allCode );
				if( c != null && c.startsWith( "byte" )){
					t = Byte3;
				}
				else 
				{
					if ( hasArrayAccess(inf.name.split('.').pop(), allCode ) ) {
						isSubscriptArray = true;
					}
				}
			case Vec4:
				var c = findVarComment( inf.name,allCode );
				if( c != null && c.startsWith( "byte" )){
					t = Byte4;
				}
				else 
				{
					if ( hasArrayAccess(inf.name.split('.').pop(), allCode ) ) {
						isSubscriptArray = true;
					}
				}
			case Mat4:
				var li = inf.name.lastIndexOf("[");
				if ( li >= 0 )
					inf.name = inf.name.substr( 0,li );
					
				if(  hasArrayAccess(inf.name,allCode ) ) {
					scanSubscript = false;
					t = Elements( inf.name, null, t );
					System.trace2('subtyped ${inf.name} $t ${inf.type} as array');
				}
				else System.trace2('can t subtype ${inf.name} $t ${inf.type}');
				
			default:	
				System.trace2('can t subtype $t ${inf.type}');
		}
		
		//todo refactor all...but it will wait hxsl3

		var name = inf.name;
		while ( scanSubscript ) {
			if ( r_array.match(name) ) { //
				System.trace2('0_ pre $name ');
				name = r_array.matchedLeft();
				t = Index(Std.parseInt(r_array.matched(1)), t);
				System.trace2('0_ sub $name -> $t');
				continue;
			}
			
			var c = name.lastIndexOf(".");
			if ( c < 0) {
				c = name.lastIndexOf("[");
			}
			
			if ( c > 0 ) {
				System.trace2('1_ $name -> $t');
				var field = name.substr(c + 1);
				name = name.substr(0, c);
				System.trace2('1_ $name -> field $field $t');
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
	
	override function selectShader( shader : Shader ) : Bool {
		if ( shader == null ) {
			#if debug
				throw "Shader not set ?";
			#end
			return false;
		}
		
		var change = false;
		if ( shader.instance == null ) {
			System.trace2("building shader" + Type.typeof(shader));
			shader.instance = buildShaderInstance(shader);
		}
		if ( shader.instance != curShader ) {
			var old = curShader;
			System.trace3("binding shader "+Type.getClass(shader)+" nbAttribs:"+shader.instance.attribs.length);
			curShader = shader.instance;
			
			if (curShader.program == null) throw "invalid shader";
			System.trace3("using program");
			gl.useProgram(curShader.program);
			
			//kiss....
			if ( old != null )
				for ( a in old.attribs)
					gl.disableVertexAttribArray(a.index);
			
			for ( i in 0...curShader.attribs.length ) {
				var a = curShader.attribs[i];
				gl.enableVertexAttribArray(a.index);
			}
				
			System.trace3("attribs set program");
			change = true;
		}
			
		
		//if ( System.debugLevel>=2 ) trace("setting uniforms");
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
			//System.trace3('retrieving uniform ($u) $val ');
			System.trace3('retrieving uniform ${u.name} ');
			setUniform(val, u, u.type);
		}
		
		System.trace3('shader custom setup ');
		shader.customSetup(this);
		checkError();
		System.trace3('shader is now setup ');
		
		return change;
	}
	
	public function setupTexture( t : h3d.mat.Texture, mipMap : h3d.mat.Data.MipMap, filter : h3d.mat.Data.Filter, wrap : h3d.mat.Data.Wrap ) {
		gl.bindTexture(GL.TEXTURE_2D, t.t);
		var flags = TFILTERS[Type.enumIndex(mipMap)][Type.enumIndex(filter)];
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, flags[0]);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, flags[1]);
		var w = TWRAP[Type.enumIndex(wrap)];
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, w);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, w);
		checkError();
	}
	
	inline function blitMatrices(a:Array<Matrix>, transpose) {
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
	
	public static var f32Pool : IntMap<Float32Array> =  new haxe.ds.IntMap();
	
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
	
	function setUniform( val : Dynamic, u : Shader.Uniform, t : Shader.ShaderType ) {
		
		var buff : Float32Array = null;
		#if debug if (u == null) throw "no uniform set, check your shader"; #end
		#if debug if (u.loc == null) throw "no uniform loc set, check your shader"; #end
		#if debug if (val == null) throw "no val set, check your shader"; #end
		#if debug if (gl == null) throw "no gl set, Arrrghh"; #end
		
		checkError();
		
		//System.trace2("setting uniform "+u.name);
		//System.trace3("setting uniform " + u.name+ " of type "+t +" and value "+val );
		
		switch( t ) {
		case Mat4:
			
			#if debug
			if ( Std.is( val , Array)) throw "error";
			#end
			
			System.trace3("setUniform : mono matrix batch" );
			
			var m : h3d.Matrix = val;
			gl.uniformMatrix4fv(u.loc, false, buff = blitMatrix(m, true) );
			deleteF32(buff);
			
			//System.trace3("one matrix batch " + m + " of val " + val);
			
		case Tex2d:
			System.trace3("active texture" );
			
			var t : h3d.mat.Texture = val;
			setupTexture(t, t.mipMap, t.filter, t.wrap);
			gl.activeTexture(GL.TEXTURE0 + u.index);
			gl.uniform1i(u.loc, u.index);
			
		case Float: 							var f : Float = val;  gl.uniform1f(u.loc, f);
		case Vec2:	var v : h3d.Vector = val;	gl.uniform2f(u.loc, v.x, v.y);
		case Vec3:	var v : h3d.Vector = val;	gl.uniform3f(u.loc, v.x, v.y, v.z);
		case Vec4:	var v : h3d.Vector = val;	gl.uniform4f(u.loc, v.x, v.y, v.z, v.w);
		
		case Struct(field, t):
			var vs = Reflect.field(val, field);
			
			if ( t == null ) throw "Missing shader type " + t;
			if ( u == null ) throw "Missing shader loc " + u;
			if ( vs == null ) throw "Missing shader field " + field+ " in " +val;
			
			setUniform(vs, u, t);
			
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
					if ( nb != null && ms.length != nb)  System.trace3('Array uniform type mismatch $nb requested, ${ms.length} found');
						
					gl.uniformMatrix4fv(u.loc, false, buff = blitMatrices(ms,true) );
					//System.trace3("sending matrix batch " + ms.length + " " + ms + " of val " + val);
					
				default: throw "not supported";
			}
			deleteF32(buff);
		}
			
		case Index(index, t):
			var v = val[index];
			if( v == null ) throw "Missing shader index " + index;
			setUniform(v, u, t);
		case Byte4:
			var v : Int = val;
			gl.uniform4f(u.loc, ((v >> 16) & 0xFF) / 255, ((v >> 8) & 0xFF) / 255, (v & 0xFF) / 255, (v >>> 24) / 255);
		case Byte3:
			var v : Int = val;
			gl.uniform3f(u.loc, ((v >> 16) & 0xFF) / 255, ((v >> 8) & 0xFF) / 255, (v & 0xFF) / 255);
		default:
			throw "Unsupported uniform " + u.type;
		}
		
		System.trace3("uniform " + u.name+ " is now set" );
		checkError();
		
	}
	//TODO cache this
	function packArray4( vecs : Array<Vector> ):Float32Array{
		var a = createF32(vecs.length*4);
		for ( i in 0...vecs.length) {
			var vec = vecs[i];
			a[i * 4] = vec.x;
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
	var curMultiBuffer : Array<Buffer.BufferOffset>;
	
	override function selectBuffer( v : VertexBuffer ) {
		if ( curBuffer == v ) return;
		
		System.trace3("selected Buffer");
		curBuffer = v;
		curMultiBuffer = null;
		
		var stride : Int = v.stride;
		//if( stride < curShader.stride )
		//	throw "Buffer stride (" + stride + ") and shader stride (" + curShader.stride + ") mismatch";
			
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		checkError();
		
		//this one is sharde most of the time, let's define it fully
		for( a in curShader.attribs )
			gl.vertexAttribPointer(a.index, a.size, a.etype, false, stride * 4, a.offset * 4);
		
		checkError();
	}
	
	override function selectMultiBuffers( buffers : Array<Buffer.BufferOffset> ) {
		var changed = curMultiBuffer == null || curMultiBuffer.length != buffers.length;
		
		System.trace3("selectMultiBuffers");
		
		if( !changed )
			for( i in 0...curMultiBuffer.length )
				if( buffers[i] != curMultiBuffer[i] ) {
					changed = true;
					break;
				}
				
		if ( changed ) {
			for ( i in 0...buffers.length ) {
				var b = buffers[i];
				var a = curShader.attribs[i];
				gl.bindBuffer(GL.ARRAY_BUFFER, b.b.b.vbuf.b);

				//this is a single stream, let's bind it without stride
				if( !b.shared )
					gl.vertexAttribPointer( a.index, a.size, a.etype, false, 0, 0);
				//this is a composite one
				else 
					gl.vertexAttribPointer( a.index, a.size, a.etype, false, b.stride, b.offset*4);
				
				checkError();
			}
				
			curBuffer = null;
			curMultiBuffer = buffers;
		}
	}
	
	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		System.trace3('binding index');
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf);
		checkError();
		System.trace3('index bound');
		
		System.trace3('drawing tris');
		System.trace3('$ntriangles $startIndex');
		gl.drawElements(GL.TRIANGLES, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
		checkError();
		System.trace3('tri drawn');
		
		System.trace3('reseting bind');
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		checkError();
		System.trace3('bind reset');
	}
	
	override function present() {
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
		GL.FRONT, // front/back reversed wrt stage3d
		GL.BACK,
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
				trace("GL_ERROR " + s);
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
	
	public inline function getShaderInfoLog(s,code) {
		var log = gl.getShaderInfoLog(s);
		var line = code.split("\n")[Std.parseInt(log.substr(9)) - 1];
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

}

#end
