package h3d.impl;

import h3d.impl.Driver;
import h3d.Vector;

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
#end

using StringTools;

#if js
private typedef GL = js.html.webgl.GL;
#elseif cpp
private typedef Uint16Array = openfl.utils.Int16Array;
private typedef Uint8Array = openfl.utils.UInt8Array;
private typedef Float32Array = openfl.utils.Float32Array;
#end

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

	//	curAttribs = 0;
		curMatBits = -1;
		selectMaterial(0);
	}
	
	override function reset() {
		curShader = null;
		gl.useProgram(null);
	}
	
	override function selectMaterial( mbits : Int ) {
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
			if( src == 0 && dst == 1 )
				gl.disable(GL.BLEND);
			else {
				if( curMatBits < 0 || (curMatBits >> 6) & 0xFF == 0x10 ) gl.enable(GL.BLEND);
				gl.blendFunc(BLEND[src], BLEND[dst]);
			}
		}
	
		if( diff & (15 << 2) != 0 ) {
			var write = (mbits >> 2) & 1 == 1;
			if ( curMatBits < 0 || diff & 4 != 0 ) {
				if ( System.debugLevel >= 3) trace("write :"+write);
				
				gl.depthMask(write);
			}
				
			gl.enable(GL.DEPTH_TEST);
			
			var cmp = (mbits >> 3) & 7;
			if ( cmp == 0 ) {
				if ( System.debugLevel >= 3) trace("no depth test");
				
				gl.disable(GL.DEPTH_TEST);
			}
			else {
				
				if ( curMatBits < 0 || (curMatBits >> 3) & 7 == 0 ) {
					if ( System.debugLevel >= 3) trace("enabling depth test");
					
					gl.enable(GL.DEPTH_TEST);
				}
				
				if ( System.debugLevel >= 3) trace("using " + glCompareToString(COMPARE[cmp]));
					
				gl.depthFunc(COMPARE[cmp]);
			}
		}
		else {
			if ( System.debugLevel >= 2)
					trace("no depth setup ");
		}
		
		checkError();
			
		if ( diff & (15 << 14) != 0 ) {
			if ( System.debugLevel >= 2) trace("using color mask");
					
			gl.colorMask((mbits >> 14) & 1 != 0, (mbits >> 14) & 2 != 0, (mbits >> 14) & 4 != 0, (mbits >> 14) & 8 != 0);
			checkError();
		}
			
		curMatBits = mbits;
	}
	
	override function clear( r : Float, g : Float, b : Float, a : Float ) {
		gl.clearColor(r, g, b, a);
		gl.depthMask(true);
		gl.clearDepth(1.0);
		
		//always clear depth & stencyl
		gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
		if( hxd.System.debugLevel>=3) trace("clearing");
	}

	//TODO optimize me
	override function getShaderInputNames() {
		return curShader.attribs.map(function(t) return t.name );
	}
	
	override function resize(width, height) {
		#if js
		canvas.width = width;
		canvas.height = height;
		#elseif cpp
		// resize window
		#end
		gl.viewport(0, 0, width, height);
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
		return { b : b, stride : stride };
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
	
	//TODO miplevel and side
	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		gl.enable(GL.TEXTURE_2D);
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
	
	function findVarComment(str,code)
	{
		var r = new EReg(str + "[ \\t]*\\/\\*([A-Za-z0-9_]+)\\*\\/", "g");
		if ( r.match(code) ) {
			return r.matched(1);
		}
		else return null;
	}
	
	function buildShaderInstance( shader : Shader ) {
		var cl = Type.getClass(shader);
		function compileShader(type) {
			var vertex = type == GL.VERTEX_SHADER;
			var name = vertex ? "VERTEX" : "FRAGMENT";
			var code = Reflect.field(cl, name);
			if( code == null ) throw "Missing " + Type.getClassName(cl) + "." + name + " shader source";
			var cst = shader.getConstants(vertex);
			
			//if ( System.isVerbose) { trace("compiling cst: \n" + cst); }
			//if ( System.isVerbose) { trace("compiling code: \n" + code); }
			
			code = StringTools.trim(cst + code);
			
			#if cpp
			code = "#define lowp\n#define mediump\n#define highp\n"+code;
			#end
			// replace haxe-like #if/#else/#end by GLSL ones
			code = ~/#if ([A-Za-z0-9_]+)/g.replace(code, "#if defined($1)");
			code = ~/#elseif ([A-Za-z0-9_]+)/g.replace(code, "#elif defined($1)");
			code = code.split("#end").join("#endif");
			
			//SHADER CODE
			//if ( System.isVerbose )trace("Trying to compile shader:"+code);
			
			var s = gl.createShader(type);
					
			
			gl.shaderSource(s, code);
			gl.compileShader(s);
			if( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
				var log = gl.getShaderInfoLog(s);
				var line = code.split("\n")[Std.parseInt(log.substr(9)) - 1];
				if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
				throw "An error occurred compiling the shaders: " + log + line;
			}
			return s;
		}
		var vs = compileShader(GL.VERTEX_SHADER);
		var fs = compileShader(GL.FRAGMENT_SHADER);
		
		var p = gl.createProgram();
		gl.bindAttribLocation(p, 0, "pos");
		gl.bindAttribLocation(p, 1, "uv");
		gl.bindAttribLocation(p, 2, "normal");
		gl.bindAttribLocation(p, 3, "color");
		gl.bindAttribLocation(p, 4, "weights");
		gl.bindAttribLocation(p, 5, "indexes");
		
		gl.attachShader(p, vs);
		gl.attachShader(p, fs);
		
		gl.linkProgram(p);
		
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
				
				inst.attribs.push( { name : aname, type : atype, etype : etype, size : size, index : a.index, offset : offset } );
			}
			offset += size;
			ccode = r.matchedRight();
		}
		inst.stride = offset;
		
		// list uniforms needed by shader
		var allCode = code + gl.getShaderSource(fs);
		
		var nuni = gl.getProgramParameter(p, GL.ACTIVE_UNIFORMS);
		inst.uniforms = [];
		var texIndex = -1;
		var r_array = ~/\[([0-9]+)\]$/;
		for( k in 0...nuni ) {
			var inf = gl.getActiveUniform(p, k);
			
			//if ( System.isVerbose) trace("retrieving uniform " + inf.name);
			if( inf.name.substr(0, 6) == "webgl_" )
				continue; // skip native uniforms
				
			//if (System.debugLevel>=2) trace('retrieved uniform $inf');
			
			var isArray = false;
			var t = decodeTypeInt(inf.type);
			switch( t ) {
				case Tex2d, TexCube:
					texIndex++;
				case Vec3:
					var r = new EReg(inf.name + "[ \\t]*\\/\\*([A-Za-z0-9_]+)\\*\\/", "g");
					if( r.match(allCode) ){
						switch( r.matched(1) ) {
						case "byte4":
							if(System.debugLevel>=2) trace('_0 fetched $inf');
							t = Byte3;
						default:
							if(System.debugLevel>=2) trace('_0 type filtering bails ${inf.name}');
						}
					}
					else 
					{
						//if (System.debugLevel>=2) trace('_0 bailed  $inf');
						
						var r = new EReg("[A-Z0-9_]+[ \t]+"+inf.name.split('.').pop() + "\\[[a-z](.+?)\\]", "gi");
						if ( r.match(allCode)) {
							if (System.debugLevel>=2) trace('_0 found an array ! ' + r.matched(0) + " - " + r.matched(1) );
							isArray = true;
						}
					}
				case Vec4:
					var r = new EReg(inf.name + "[ \\t]*\\/\\*([A-Za-z0-9_]+)\\*\\/", "g");
					if( r.match(allCode) ){
						switch( r.matched(1) ) {
						case "byte4":
							if(System.debugLevel>=2) trace('_1 fetched $inf');
							t = Byte4;
						default:
							if(System.debugLevel>=2) trace('_1 type filtering bails ${inf.name}');
						}
					}
					else
					{
						//if (System.debugLevel>=2) trace('_1 bailed  $inf');
						
						var r = new EReg("[A-Z0-9_]+[ \t]+"+inf.name.split('.').pop() + "\\[[a-z](.+?)\\]", "gi");
						if ( r.match(allCode)) {
							//if (System.isVerbose) trace('_1 found an array ! ' + r.matched(0) + " - " + r.matched(1) );
							isArray = true;
						}
					}
				default:	
					if(System.debugLevel>=2) trace('can t subtype $t ${inf.type}');
			}
			var name = inf.name;
			while( true ) {
				if( r_array.match(name) ) {
					name = r_array.matchedLeft();
					t = Index(Std.parseInt(r_array.matched(1)), t);
					//if (System.isVerbose) trace('0_ $name -> $t');
					continue;
				}
				var c = name.lastIndexOf(".");
				if ( c > 0 ) {
					//if (System.isVerbose) trace('1_ $name -> $t');
					var field = name.substr(c + 1);
					name = name.substr(0, c);
					
					if( !isArray)
						t = Struct(field, t);
					else
						t = Elements( field, inf.size, t );
				}
				break;
			}
			
			var tu = {
				name : name,
				type : t,
				loc : gl.getUniformLocation(p, inf.name),
				index : texIndex,
			};
			inst.uniforms.push( tu);
			//if(System.debugLevel>=2) trace('adding uniform ${tu.name} ${tu.type} ${tu.loc} ${tu.index}');
		}
		inst.program = p;
		checkError();
		return inst;
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
			if ( System.debugLevel>=2 ) trace("building shader" + Type.typeof(shader));
			shader.instance = buildShaderInstance(shader);
		}
		if ( shader.instance != curShader ) {
			var old = curShader;
			//if ( System.debugLevel>=2 ) trace("binding shader "+Type.getClass(shader)+" nbAttribs:"+shader.instance.attribs.length);
			curShader = shader.instance;
			
			if (curShader.program==null) throw "invalid shader";
			gl.useProgram(curShader.program);
			
			//kiss....
			if ( old != null )
				for ( a in old.attribs)
					gl.disableVertexAttribArray(a.index);
			
			for ( i in 0...curShader.attribs.length ) {
				var a = curShader.attribs[i];
				gl.enableVertexAttribArray(a.index);
				//if ( System.debugLevel>=2 ) trace('enabling attrib ${curShader.attribs[i]}');
			}
				
			//if ( System.debugLevel>=2 ) trace("attribs set");
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
			//if ( System.debugLevel>=2 ) trace('retrieving uniform ${u.name} $val');
			setUniform(val, u, u.type);
		}
		shader.customSetup(this);
		checkError();
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
	
	function setUniform( val : Dynamic, u : Shader.Uniform, t : Shader.ShaderType ) {
		#if debug if (u == null) throw "no uniform set, check your shader"; #end
		#if debug if (u.loc == null) throw "no uniform loc set, check your shader"; #end
		#if debug if (val == null) throw "no val set, check your shader"; #end
		#if debug if (gl == null) throw "no gl set, Arrrghh"; #end
		
		//if ( System.debugLevel >= 2 ) trace("setting uniform "+u.name);
		
		switch( t ) {
		case Mat4:
			if ( Std.is( val , Array)) {
				gl.uniformMatrix4fv(u.loc, true, packMatrix44(val));
				//if ( System.debugLevel >= 2 ) trace("uniform matrix array set");
			}
			else {
				var m : h3d.Matrix = val;
				var fl = m.getFloats();
				var arr = new Float32Array(fl);
				gl.uniformMatrix4fv(u.loc, true, arr);
				
				//if ( System.debugLevel >= 2 ) trace("uniform matrix set");
			}
		case Tex2d:
			var t : h3d.mat.Texture = val;
			setupTexture(t, t.mipMap, t.filter, t.wrap);
			gl.activeTexture(GL.TEXTURE0 + u.index);
			gl.uniform1i(u.loc, u.index);
		case Float:
			gl.uniform1f(u.loc, val);
		case Vec2:
			var v : h3d.Vector = val;
			gl.uniform2f(u.loc, v.x, v.y);
		case Vec3:
			var v : h3d.Vector = val;
			if (v == null) throw "no val set, check your shader "+v;
			gl.uniform3f(u.loc, v.x, v.y, v.z);
		case Vec4:
			var v : h3d.Vector = val;
			if (v == null) throw "no val set, check your shader "+v; 
			gl.uniform4f(u.loc, v.x, v.y, v.z, v.w);
		case Struct(field, t):
			var vs = Reflect.field(val, field);
			
			if ( t == null ) throw "Missing shader type " + t;
			if ( u == null ) throw "Missing shader loc " + u;
			if ( vs == null ) throw "Missing shader field " + field+ " in " +val;
			
			setUniform(vs, u, t);
			
		//todo optimize this...
		case Elements(field, nb, t): {
			var arr : Array<Vector> = Reflect.field(val, field);
			if (arr.length > nb) arr = arr.slice(0, nb);
			switch(t) {
				case Vec3: 
					gl.uniform3fv( u.loc, packArray3(arr));
				case Vec4: 
					gl.uniform4fv( u.loc, packArray4(arr));
				default: throw "not supported";
			}
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
		
	}
	
	//TODO cache this
	function packMatrix44( vecs : Array<h3d.Matrix> ):Float32Array{
		var a = [ ];
		a[16 * vecs.length - 1 ] = 0.;
		
		var k = 0;
		var mat : Matrix = null;
		for ( i in 0...vecs.length) {
			mat = vecs[i];
			k = i << 4;
			a[k+0] 	= mat._11;
			a[k+1] 	= mat._12;
			a[k+2] 	= mat._13;
			a[k+3] 	= mat._14;
			
			a[k+4] 	= mat._21;
			a[k+5] 	= mat._22;
			a[k+6] 	= mat._23;
			a[k+7] 	= mat._24;
			
			a[k+8] 	= mat._31;
			a[k+9] 	= mat._32;
			a[k+10] = mat._33;
			a[k+11] = mat._34;
			
			a[k+12] = mat._41;
			a[k+13] = mat._42;
			a[k+14] = mat._43;
			a[k+15] = mat._44;
		}
		return new Float32Array(a);
	}
	
	//TODO cache this
	function packArray4( vecs : Array<Vector> ):Float32Array{
		var a = [];
		a[vecs.length * 4-1] = 0.0;
		for ( i in 0...vecs.length) {
			var vec = vecs[i];
			a[i * 4] = vec.x;
			a[i * 4+1] = vec.y;
			a[i * 4+2] = vec.z;
			a[i * 4+3] = vec.w;
		}
		return new Float32Array(a);
	}
	
	//TODO cache this
	function packArray3( vecs : Array<Vector> ):Float32Array{
		var a = [];
		a[vecs.length * 3-1] = 0.0;
		for ( i in 0...vecs.length) {
			var vec = vecs[i];
			a[i * 3] = vec.x;
			a[i * 3+1] = vec.y;
			a[i * 3+2] = vec.z;
		}
		return new Float32Array(a);
	}
	
	var curBuffer : VertexBuffer;
	var curMultiBuffer : Array<Buffer.BufferOffset>;
	
	override function selectBuffer( v : VertexBuffer ) {
		if ( curBuffer == v ) return;
		curBuffer = v;
		curMultiBuffer = null;
		
		var stride : Int = v.stride;
		if( stride < curShader.stride )
			throw "Buffer stride (" + stride + ") and shader stride (" + curShader.stride + ") mismatch";
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		for( a in curShader.attribs )
			gl.vertexAttribPointer(a.index, a.size, a.etype, false, stride * 4, a.offset * 4);
		
		checkError();
	}
	
	override function selectMultiBuffers( buffers : Array<Buffer.BufferOffset> ) {
		var changed = curMultiBuffer == null || curMultiBuffer.length != buffers.length;
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
				var stride = curShader.stride;
				
				if( !b.shared )
					gl.vertexAttribPointer( a.index, a.size, a.etype, false, 0, 0);
				else {
					//trace('$a');
					//trace('$b');
					gl.vertexAttribPointer( a.index, a.size, a.etype, false, b.stride, b.offset*4);
				}
				checkError();
			}
				
			curBuffer = null;
			curMultiBuffer = buffers;
		}
	}
	
	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf);
		gl.drawElements(GL.TRIANGLES, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		checkError();
	}
	
	override function present() {
		gl.finish();
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
		if(gl.getError() != GL.NO_ERROR)
			throw getError();
		#end
	}
	
	public inline function getError() {
		switch(gl.getError()) {
			case GL.NO_ERROR                      	:"NO_ERROR";
			case GL.INVALID_ENUM                  	:"INVALID_ENUM";
			case GL.INVALID_VALUE                 	:"INVALID_VALUE";
			case GL.INVALID_OPERATION           	:"INVALID_OPERATION";
			case GL.OUT_OF_MEMORY               	:"OUT_OF_MEMORY";
			default 								:"UNKNOW_ERROR";
		}
	}

	/*
	public override function selectShaderProjection(_, transp) {
		return transp;
	}
	*/

}

#end
