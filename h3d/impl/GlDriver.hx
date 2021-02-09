package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;
import h3d.mat.Stencil;
import h3d.mat.Data;

#if (js||hlsdl||usegl)

#if js
import hxd.impl.TypedArray;
private typedef GL = js.html.webgl.GL;
private extern class GL2 extends js.html.webgl.GL {
	// webgl2
	function drawBuffers( buffers : Array<Int> ) : Void;
	function vertexAttribDivisor( index : Int, divisor : Int ) : Void;
	function drawElementsInstanced( mode : Int, count : Int, type : Int, offset : Int, instanceCount : Int) : Void;
	function getUniformBlockIndex( p : Program, name : String ) : Int;
	function bindBufferBase( target : Int, index : Int, buffer : js.html.webgl.Buffer ) : Void;
	function uniformBlockBinding( p : Program, blockIndex : Int, blockBinding : Int ) : Void;
	function framebufferTextureLayer( target : Int, attach : Int, t : js.html.webgl.Texture, level : Int, layer : Int ) : Void;
	function texImage3D(target : Int, level : Int, internalformat : Int, width : Int, height : Int, depth : Int, border : Int, format : Int, type : Int, source : Dynamic) : Void;
	static inline var RGBA16F = 0x881A;
	static inline var RGBA32F = 0x8814;
	static inline var RED      = 0x1903;
	static inline var RG       = 0x8227;
	static inline var RGBA8	   = 0x8058;
	static inline var BGRA 		 = 0x80E1;
	static inline var HALF_FLOAT = 0x140B;
	static inline var SRGB       = 0x8C40;
	static inline var SRGB8      = 0x8C41;
	static inline var SRGB_ALPHA = 0x8C42;
	static inline var SRGB8_ALPHA = 0x8C43;
	static inline var R8 		  = 0x8229;
	static inline var RG8 		  = 0x822B;
	static inline var R16F 		  = 0x822D;
	static inline var R32F 		  = 0x822E;
	static inline var RG16F 	  = 0x822F;
	static inline var RG32F 	  = 0x8230;
	static inline var RGB16F 	  = 0x881B;
	static inline var RGB32F 	  = 0x8815;
	static inline var R11F_G11F_B10F = 0x8C3A;
	static inline var RGB10_A2     = 0x8059;
	static inline var DEPTH_COMPONENT24 = 0x81A6;
	static inline var UNIFORM_BUFFER = 0x8A11;
	static inline var TEXTURE_2D_ARRAY = 0x8C1A;
	static inline var UNSIGNED_INT_2_10_10_10_REV = 0x8368;
	static inline var UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;
	static inline var FUNC_MIN = 0x8007;
	static inline var FUNC_MAX = 0x8008;
	static inline var TEXTURE_LOD_BIAS : Int = 0x84FD;
}
private typedef Uniform = js.html.webgl.UniformLocation;
private typedef Program = js.html.webgl.Program;
private typedef GLShader = js.html.webgl.Shader;
private typedef Framebuffer = js.html.webgl.Framebuffer;
#elseif hlsdl
import sdl.GL;
private typedef Uniform = sdl.GL.Uniform;
private typedef Program = sdl.GL.Program;
private typedef GLShader = sdl.GL.Shader;
private typedef Framebuffer = sdl.GL.Framebuffer;
private typedef Texture = h3d.impl.Driver.Texture;
private typedef Query = h3d.impl.Driver.Query;
private typedef VertexArray = sdl.GL.VertexArray;
#elseif usegl
import haxe.GLTypes;
private typedef Uniform = haxe.GLTypes.Uniform;
private typedef Program = haxe.GLTypes.Program;
private typedef GLShader = haxe.GLTypes.Shader;
private typedef Framebuffer = haxe.GLTypes.Framebuffer;
private typedef Texture = h3d.impl.Driver.Texture;
private typedef Query = h3d.impl.Driver.Query;
private typedef VertexArray = haxe.GLTypes.VertexArray;
#end

#if usegl
private typedef ShaderCompiler = haxe.GLTypes.ShaderCompiler;
#else
private typedef ShaderCompiler = hxsl.GlslOut;
#end

private class CompiledShader {
	public var s : GLShader;
	public var vertex : Bool;
	public var globals : Uniform;
	public var params : Uniform;
	public var textures : Array<{ u : Uniform, t : hxsl.Ast.Type, mode : Int }>;
	public var buffers : Array<Int>;
	public var shader : hxsl.RuntimeShader.RuntimeShaderData;
	public function new(s,vertex,shader) {
		this.s = s;
		this.vertex = vertex;
		this.shader = shader;
	}
}

private class CompiledAttribute {
	public var index : Int;
	public var type : Int;
	public var size : Int;
	public var offset : Int;
	public var divisor : Int;
	public function new() {
	}
}

private class CompiledProgram {
	public var p : Program;
	public var vertex : CompiledShader;
	public var fragment : CompiledShader;
	public var stride : Int;
	public var inputs : InputNames;
	public var attribs : Array<CompiledAttribute>;
	public var hasAttribIndex : Array<Bool>;
	public function new() {
	}
}

@:access(h3d.impl.Shader)
#if (hlsdl||usegl)
@:build(h3d.impl.MacroHelper.replaceGL())
#end
class GlDriver extends Driver {

	#if js
	var canvas : js.html.CanvasElement;
	var mrtExt : { function drawBuffersWEBGL( colors : Array<Int> ) : Void; };
	static var UID = 0;
	public var gl : GL2;
	public static var ALLOW_WEBGL2 = true;
	#end

	#if (hlsdl||usegl)
	var commonVA : VertexArray;
	#end

	var commonFB : Framebuffer;
	var curAttribs : Array<Bool> = new Array<Bool>();
	var maxIdxCurAttribs : Int = 0;
	var curShader : CompiledProgram;
	var curBuffer : h3d.Buffer;
	var curIndexBuffer : IndexBuffer;
	var curMatBits : Int = -1;
	var curStOpBits : Int = -1;
	var curStMaskBits : Int = -1;
	var curStEnabled : Bool = false;
	var defStencil : Stencil;
	var programs : Map<Int, CompiledProgram>;
	var frame : Int;
	var lastActiveIndex : Int = 0;
	var curColorMask = -1;
	var currentDivisor : Array<Int> = [for( i in 0...32 ) 0];

	var bufferWidth : Int;
	var bufferHeight : Int;
	var curTarget : h3d.mat.Texture;
	var curTargets : Array<h3d.mat.Texture> = [];
	var numTargets : Int;
	var curTargetLayer : Int;
	var curTargetMip : Int;

	var debug : Bool;
	var glDebug : Bool;
	var boundTextures : Array<Texture> = [];
	var glES : Null<Float>;
	var shaderVersion : Null<Int>;
	var firstShader = true;
	var rightHanded = false;
	var hasMultiIndirect = false;
	var maxCompressedTexturesSupport = 0;

	var drawMode : Int;

	static var BLACK = new h3d.Vector(0,0,0,0);

	/**
		Perform OUT_OF_MEMORY checks when allocating textures/buffers.
		Default true, except in WebGL (false)
	**/
	public static var outOfMemoryCheck = #if js false #else true #end;

	public function new(antiAlias=0) {
		#if js
		canvas = @:privateAccess hxd.Window.getInstance().canvas;
		var options = {alpha:false,stencil:true,antialias:antiAlias>0};
		if(ALLOW_WEBGL2)
			gl = cast canvas.getContext("webgl2",options);
		if( gl == null )
			gl = cast canvas.getContextWebGL(options);
		if( gl == null ) throw "Could not acquire GL context";
		// debug if webgl_debug.js is included
		if( js.Syntax.typeof(untyped WebGLDebugUtils) != "undefined" ) {
			gl = untyped WebGLDebugUtils.makeDebugContext(gl);
			glDebug = true;
		}
		#if multidriver
		canvas.setAttribute("class", canvas.getAttribute("class") + " _id_" + (UID++));
		#end
		#end
		commonFB = gl.createFramebuffer();
		programs = new Map();
		defStencil = new Stencil();

		#if hlsdl
		hasMultiIndirect = gl.getConfigParameter(0) > 0;
		maxCompressedTexturesSupport = 3;
		#end

		#if hlmesa
		hasMultiIndirect = true;
		maxCompressedTexturesSupport = 3;
		#end

		var v : String = gl.getParameter(GL.VERSION);
		var reg = ~/ES ([0-9]+\.[0-9]+)/;
		if( reg.match(v) )
			glES = Std.parseFloat(reg.matched(1));

		#if !js
		if( glES == null ) {
			commonVA = gl.createVertexArray();
			gl.bindVertexArray( commonVA );
		}
		#end

		var reg = ~/[0-9]+\.[0-9]+/;
		var v : String = gl.getParameter(GL.SHADING_LANGUAGE_VERSION);
		if( reg.match(v) ) {
			#if js
			glES = Std.parseFloat(reg.matched(0));
			#end
			shaderVersion = Math.round( Std.parseFloat(reg.matched(0)) * 100 );
		}

		drawMode = GL.TRIANGLES;

		#if js
		// make sure to enable extensions
		makeFeatures();

		// We need to get instanced rendering by it's ANGLE extension if we are using webgl1
		if(hasFeature(InstancedRendering) && glES < 3) {
			var extension:js.html.webgl.extension.ANGLEInstancedArrays =  cast gl.getExtension("ANGLE_instanced_arrays");
			Reflect.setField(gl,"vertexAttribDivisor",extension.vertexAttribDivisorANGLE);
			Reflect.setField(gl,"drawElementsInstanced",extension.drawElementsInstancedANGLE);
		}

		// setup shader optim
		hxsl.SharedShader.UNROLL_LOOPS = !hasFeature(ShaderModel3);
		#else
		gl.enable(GL.TEXTURE_CUBE_MAP_SEAMLESS);
		gl.finish(); // prevent glError() on first bufferData
		#end
		gl.pixelStorei(GL.PACK_ALIGNMENT, 1);
		gl.pixelStorei(GL.UNPACK_ALIGNMENT, 1);
	}

	override function setRenderFlag( r : RenderFlag, value : Int ) {
		switch( r ) {
		case CameraHandness:
			rightHanded = value > 0;
		default:
		}
	}

	override function logImpl( str : String ) {
		#if js
		untyped console.log(str);
		#else
		Sys.println(str);
		#end
	}

	override function setDebug(d) {
		this.debug = d;
	}

	override function begin(frame) {
		this.frame = frame;
		resetStream();
		gl.useProgram(null);
		curShader = null;
		curBuffer = null;
	}

	override function getShaderInputNames() {
		return curShader.inputs;
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		inline function compile(sh) {
			var glout = new ShaderCompiler();
			glout.glES = glES;
			glout.version = shaderVersion;
			return glout.run(sh);
		}
		return "// vertex:\n" + compile(shader.vertex.data) + "// fragment:\n" + compile(shader.fragment.data);
	}

	override public function getDriverName(details:Bool) {
		var render = gl.getParameter(GL.RENDERER);
		if( details )
			render += " GLv" + gl.getParameter(GL.VERSION);
		else
			render = render.split("/").shift(); // GeForce reports "/PCIe/SSE2" extension
		#if js
		render = render.split("WebGL ").join("");
		#end
		return "OpenGL "+render;
	}

	function compileShader( glout : ShaderCompiler, shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var type = shader.vertex ? GL.VERTEX_SHADER : GL.FRAGMENT_SHADER;
		var s = gl.createShader(type);
		if( shader.code == null ){
			shader.code = glout.run(shader.data);
			shader.data.funs = null;
		}
		gl.shaderSource(s, shader.code);
		gl.compileShader(s);
		var log = gl.getShaderInfoLog(s);
		if ( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
			var log = gl.getShaderInfoLog(s);
			var lid = Std.parseInt(log.substr(9));
			var line = lid == null ? null : shader.code.split("\n")[lid - 1];
			if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
			var codeLines = shader.code.split("\n");
			for( i in 0...codeLines.length )
				codeLines[i] = (i+1) + "\t" + codeLines[i];
			throw "An error occurred compiling the shaders: " + log + line+"\n\n"+codeLines.join("\n");
		}
		return new CompiledShader(s, shader.vertex, shader);
	}

	function initShader( p : CompiledProgram, s : CompiledShader, shader : hxsl.RuntimeShader.RuntimeShaderData, rt : hxsl.RuntimeShader ) {
		var prefix = s.vertex ? "vertex" : "fragment";
		s.globals = gl.getUniformLocation(p.p, prefix + "Globals");
		s.params = gl.getUniformLocation(p.p, prefix + "Params");
		s.textures = [];
		var index = 0;
		var curT = null;
		var mode = 0;
		var name = "";
		var t = shader.textures;
		while( t != null ) {
			var tt = t.type;
			var count = 1;
			switch( tt ) {
			case TChannel(_): tt = TSampler2D;
			case TArray(t,SConst(n)): tt = t; count = n;
			default:
			}
			if( tt != curT ) {
				curT = tt;
				name = switch( tt ) {
				case TSampler2D: mode = GL.TEXTURE_2D; "Textures";
				case TSamplerCube: mode = GL.TEXTURE_CUBE_MAP; "TexturesCube";
				case TSampler2DArray: mode = GL2.TEXTURE_2D_ARRAY; "TexturesArray";
				default: throw "Unsupported texture type "+tt;
				}
				index = 0;
			}
			for( i in 0...count ) {
				var loc = gl.getUniformLocation(p.p, prefix+name+"["+index+"]");
				/*
					This is a texture that is used in HxSL but has been optimized out by GLSL compiler.
					While some drivers will correctly report `null` here, some others (AMD) will instead
					return a uniform but still mismatch the texture slot, leading to swapped textures or
					incorrect rendering. We also don't handle texture skipping in DirectX.

					Fix is to make sure HxSL will optimize the texture out.
					Alternate fix is to improve HxSL so he does it on its own.
				*/
				if( loc == null )
					throw "Texture "+rt.spec.instances[t.instance].shader.data.name+"."+t.name+" is missing from shader output";
				s.textures.push({ u : loc, t : curT, mode : mode });
				index++;
			}
			t = t.next;
		}
		if( shader.bufferCount > 0 ) {
			s.buffers = [for( i in 0...shader.bufferCount ) gl.getUniformBlockIndex(p.p,(shader.vertex?"vertex_":"")+"uniform_buffer"+i)];
			var start = 0;
			if( !s.vertex ) start = rt.vertex.bufferCount;
			for( i in 0...shader.bufferCount )
				gl.uniformBlockBinding(p.p,s.buffers[i],i + start);
		}
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var p = programs.get(shader.id);
		if( p == null ) {
			p = new CompiledProgram();
			var glout = new ShaderCompiler();
			glout.glES = glES;
			glout.version = shaderVersion;
			p.vertex = compileShader(glout,shader.vertex);
			p.fragment = compileShader(glout,shader.fragment);

			p.p = gl.createProgram();
			#if ((hlsdl || usegl) && !hlmesa)
			if( glES == null ) {
				var outCount = 0;
				for( v in shader.fragment.data.vars )
					switch( v.kind ) {
					case Output:
						gl.bindFragDataLocation(p.p, outCount++, glout.varNames.exists(v.id) ? glout.varNames.get(v.id) : v.name);
					default:
					}
			}
			#end
			gl.attachShader(p.p, p.vertex.s);
			gl.attachShader(p.p, p.fragment.s);
			var log = null;
			try {
				gl.linkProgram(p.p);
				if( gl.getProgramParameter(p.p, GL.LINK_STATUS) != cast 1 )
					log = gl.getProgramInfoLog(p.p);
			} catch( e : Dynamic ) {
				throw "Shader linkage error: "+Std.string(e)+" ("+getDriverName(false)+")";
			}
			gl.deleteShader(p.vertex.s);
			gl.deleteShader(p.fragment.s);
			if( log != null ) {
				#if js
				gl.deleteProgram(p.p);
				#end
				#if hlsdl
				/*
					Tentative patch on some driver that report an higher shader version that it's allowed to use.
				*/
				if( log == "" && shaderVersion > 130 && firstShader ) {
					shaderVersion -= 10;
					return selectShader(shader);
				}
				#end
				throw "Program linkage failure: "+log+"\nVertex=\n"+shader.vertex.code+"\n\nFragment=\n"+shader.fragment.code;
			}
			firstShader = false;
			initShader(p, p.vertex, shader.vertex, shader);
			initShader(p, p.fragment, shader.fragment, shader);
			var attribNames = [];
			p.attribs = [];
			p.hasAttribIndex = [];
			p.stride = 0;
			for( v in shader.vertex.data.vars )
				switch( v.kind ) {
				case Input:
					var t = GL.FLOAT;
					var size = switch( v.type ) {
					case TVec(n, _): n;
					case TBytes(n): t = GL.BYTE; n;
					case TFloat: 1;
					default: throw "assert " + v.type;
					}
					var index = gl.getAttribLocation(p.p, glout.varNames.exists(v.id) ? glout.varNames.get(v.id) : v.name);
					if( index < 0 ) {
						p.stride += size;
						continue;
					}
					var a = new CompiledAttribute();
					a.type = t;
					a.size = size;
					a.index = index;
					a.offset = p.stride;
					a.divisor = 0;
					if( v.qualifiers != null ) {
						for( q in v.qualifiers )
							switch( q ) {
							case PerInstance(n): a.divisor = n;
							default:
							}
					}
					p.attribs.push(a);
					p.hasAttribIndex[a.index] = true;
					attribNames.push(v.name);
					p.stride += size;
				default:
				}
			p.inputs = InputNames.get(attribNames);
			programs.set(shader.id, p);
		}
		if( curShader == p ) return false;
		setProgram(p);
		return true;
	}

	function setProgram( p : CompiledProgram ) {
		gl.useProgram(p.p);

		for( a in p.attribs )
			if( !curAttribs[a.index] ) {
				gl.enableVertexAttribArray(a.index);
				curAttribs[a.index] = true;
				if (maxIdxCurAttribs < a.index) {
					maxIdxCurAttribs = a.index;
				}
			}

		var lastIdxCurAttribTrue = 0;
		for( i in 0...maxIdxCurAttribs+1 ) {
			if( curAttribs[i] && !p.hasAttribIndex[i]) {
				gl.disableVertexAttribArray(i);
				curAttribs[i] = false;
			} else if (curAttribs[i]) {
				lastIdxCurAttribTrue = i;
			}
		}
		maxIdxCurAttribs = lastIdxCurAttribTrue;

		curShader = p;
		curBuffer = null;
		for( i in 0...boundTextures.length )
			boundTextures[i] = null;
	}

	override function uploadShaderBuffers( buf : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		uploadBuffer(buf, curShader.vertex, buf.vertex, which);
		uploadBuffer(buf, curShader.fragment, buf.fragment, which);
	}

	function uploadBuffer( buffer : h3d.shader.Buffers, s : CompiledShader, buf : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
			if( s.globals != null ) {
				#if hl
				gl.uniform4fv(s.globals, streamData(hl.Bytes.getArray(buf.globals.toData()), 0, s.shader.globalsSize * 16), 0, s.shader.globalsSize * 4);
				#else
				var a = buf.globals.subarray(0, s.shader.globalsSize * 4);
				gl.uniform4fv(s.globals, a);
				#end
			}
		case Params:
			if( s.params != null ) {
				#if hl
				gl.uniform4fv(s.params, streamData(hl.Bytes.getArray(buf.params.toData()), 0, s.shader.paramsSize * 16), 0, s.shader.paramsSize * 4);
				#else
				var a = buf.params.subarray(0, s.shader.paramsSize * 4);
				gl.uniform4fv(s.params, a);
				#end
			}
		case Buffers:
			if( s.buffers != null ) {
				var start = 0;
				if( !s.vertex && curShader.vertex.buffers != null )
					start = curShader.vertex.buffers.length;
				for( i in 0...s.buffers.length )
					gl.bindBufferBase(GL2.UNIFORM_BUFFER, i + start, @:privateAccess buf.buffers[i].buffer.vbuf.b);
			}
		case Textures:
			var tcount = s.textures.length;
			for( i in 0...s.textures.length ) {
				var t = buf.tex[i];
				var pt = s.textures[i];
				if( t == null || t.isDisposed() ) {
					switch( pt.t ) {
					case TSampler2D:
						var color = h3d.mat.Defaults.loadingTextureColor;
						t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
					case TSamplerCube:
						t = h3d.mat.Texture.defaultCubeTexture();
					default:
						throw "Missing texture";
					}
				}
				if( t != null && t.t == null && t.realloc != null ) {
					var s = curShader;
					t.alloc();
					t.realloc();
					if( curShader != s ) {
						// realloc triggered a shader change !
						// we need to reset the original shader and reupload everything
						setProgram(s);
						uploadShaderBuffers(buffer,Globals);
						uploadShaderBuffers(buffer,Params);
						uploadShaderBuffers(buffer,Textures);
						return;
					}
				}
				t.lastFrame = frame;

				if( pt.u == null ) continue;

				var idx = s.vertex ? i : curShader.vertex.textures.length + i;
				if( boundTextures[idx] != t.t ) {
					boundTextures[idx] = t.t;

					#if multidriver
					if( t.t.driver != this )
						throw "Invalid texture context";
					#end

					var mode = getBindType(t);
					if( mode != pt.mode )
						throw "Texture format mismatch: "+t+" should be "+pt.t;
					gl.activeTexture(GL.TEXTURE0 + idx);
					gl.uniform1i(pt.u, idx);
					gl.bindTexture(mode, t.t.t);
					lastActiveIndex = idx;
				}

				var mip = Type.enumIndex(t.mipMap);
				var filter = Type.enumIndex(t.filter);
				var wrap = Type.enumIndex(t.wrap);
				var bits = mip | (filter << 3) | (wrap << 6);
				if( bits != t.t.bits ) {
					t.t.bits = bits;
					var flags = TFILTERS[mip][filter];
					var mode = pt.mode;
					gl.texParameteri(mode, GL.TEXTURE_MAG_FILTER, flags[0]);
					gl.texParameteri(mode, GL.TEXTURE_MIN_FILTER, flags[1]);
					var w = TWRAP[wrap];
					gl.texParameteri(mode, GL.TEXTURE_WRAP_S, w);
					gl.texParameteri(mode, GL.TEXTURE_WRAP_T, w);
				}
				if( t.lodBias != t.t.bias ) {
					t.t.bias = t.lodBias;
					gl.texParameterf(pt.mode, GL2.TEXTURE_LOD_BIAS, t.lodBias);
				}
			}
		}
	}

	override function selectMaterial( pass : Pass ) {
		var bits = @:privateAccess pass.bits;
		/*
			When rendering to a render target, our output will be flipped in Y to match
			output texture coordinates. We also need to flip our culling.
			The result is inverted if we are using a right handed camera.
		*/
		if( (curTarget == null) == rightHanded ) {
			switch( pass.culling ) {
			case Back: bits = (bits & ~Pass.culling_mask) | (2 << Pass.culling_offset);
			case Front: bits = (bits & ~Pass.culling_mask) | (1 << Pass.culling_offset);
			default:
			}
		}
		selectMaterialBits(bits);

		if( curColorMask != pass.colorMask ) {
			var m = pass.colorMask;
			gl.colorMask(m & 1 != 0, m & 2 != 0, m & 4 != 0, m & 8 != 0);
			curColorMask = m;
		}

		var s = defStencil;
		if( pass.stencil == null ) {
			if( curStEnabled ) {
				gl.disable(GL.STENCIL_TEST);
				curStEnabled = false;
			}
		} else {
			s = pass.stencil;
			if( !curStEnabled ) {
				gl.enable(GL.STENCIL_TEST);
				curStEnabled = true;
			}
		}
		@:privateAccess selectStencilBits(s.opBits, s.maskBits);
		// TODO : Blend Op value sync
	}

	function selectMaterialBits( bits : Int ) {
		var diff = bits ^ curMatBits;
		if( curMatBits < 0 ) diff = -1;
		if( diff == 0 )
			return;

		var wireframe = bits & Pass.wireframe_mask != 0;
		#if hlsdl
		if ( wireframe ) {
			gl.polygonMode(GL.FRONT_AND_BACK, GL.LINE);
			// Force set to cull = None
			bits = (bits & ~Pass.culling_mask);
			diff |= Pass.culling_mask;
		} else {
			gl.polygonMode(GL.FRONT_AND_BACK, GL.FILL);
		}
		#else
		// Not entirely accurate wireframe, but the best possible on WebGL.
		drawMode = wireframe ? GL.LINE_STRIP : GL.TRIANGLES;
		#end

		if( diff & Pass.culling_mask != 0 ) {
			var cull = Pass.getCulling(bits);
			if( cull == 0 )
				gl.disable(GL.CULL_FACE);
			else {
				if( curMatBits < 0 || Pass.getCulling(curMatBits) == 0 )
					gl.enable(GL.CULL_FACE);
				gl.cullFace(FACES[cull]);
			}
		}
		if( diff & (Pass.blendSrc_mask | Pass.blendDst_mask | Pass.blendAlphaSrc_mask | Pass.blendAlphaDst_mask) != 0 ) {
			var csrc = Pass.getBlendSrc(bits);
			var cdst = Pass.getBlendDst(bits);
			var asrc = Pass.getBlendAlphaSrc(bits);
			var adst = Pass.getBlendAlphaDst(bits);
			if( csrc == asrc && cdst == adst ) {
				if( csrc == 0 && cdst == 1 )
					gl.disable(GL.BLEND);
				else {
					if( curMatBits < 0 || (Pass.getBlendSrc(curMatBits) == 0 && Pass.getBlendDst(curMatBits) == 1) ) gl.enable(GL.BLEND);
					gl.blendFunc(BLEND[csrc], BLEND[cdst]);
				}
			} else {
				if( curMatBits < 0 || (Pass.getBlendSrc(curMatBits) == 0 && Pass.getBlendDst(curMatBits) == 1) ) gl.enable(GL.BLEND);
				gl.blendFuncSeparate(BLEND[csrc], BLEND[cdst], BLEND[asrc], BLEND[adst]);
			}
		}
		if( diff & (Pass.blendOp_mask | Pass.blendAlphaOp_mask) != 0 ) {
			var cop = Pass.getBlendOp(bits);
			var aop = Pass.getBlendAlphaOp(bits);
			if( cop == aop ) {
				gl.blendEquation(OP[cop]);
			}
			else
				gl.blendEquationSeparate(OP[cop], OP[aop]);
		}
		if( diff & Pass.depthWrite_mask != 0 )
			gl.depthMask(Pass.getDepthWrite(bits) != 0);
		if( diff & Pass.depthTest_mask != 0 ) {
			var cmp = Pass.getDepthTest(bits);
			if( cmp == 0 )
				gl.disable(GL.DEPTH_TEST);
			else {
				if( curMatBits < 0 || Pass.getDepthTest(curMatBits) == 0 ) gl.enable(GL.DEPTH_TEST);
				gl.depthFunc(COMPARE[cmp]);
			}
		}
		curMatBits = bits;
	}

	function selectStencilBits( opBits : Int, maskBits : Int ) {
		var diffOp = opBits ^ curStOpBits;
		var diffMask = maskBits ^ curStMaskBits;

		if ( (diffOp | diffMask) == 0 ) return;

		if( diffOp & (Stencil.frontSTfail_mask | Stencil.frontDPfail_mask | Stencil.frontPass_mask) != 0 ) {
			gl.stencilOpSeparate(
				FACES[Type.enumIndex(Front)],
				STENCIL_OP[Stencil.getFrontSTfail(opBits)],
				STENCIL_OP[Stencil.getFrontDPfail(opBits)],
				STENCIL_OP[Stencil.getFrontPass(opBits)]);
		}

		if( diffOp & (Stencil.backSTfail_mask | Stencil.backDPfail_mask | Stencil.backPass_mask) != 0 ) {
			gl.stencilOpSeparate(
				FACES[Type.enumIndex(Back)],
				STENCIL_OP[Stencil.getBackSTfail(opBits)],
				STENCIL_OP[Stencil.getBackDPfail(opBits)],
				STENCIL_OP[Stencil.getBackPass(opBits)]);
		}

		if( (diffOp & Stencil.frontTest_mask) | (diffMask & (Stencil.reference_mask | Stencil.readMask_mask)) != 0 ) {
			gl.stencilFuncSeparate(
				FACES[Type.enumIndex(Front)],
				COMPARE[Stencil.getFrontTest(opBits)],
				Stencil.getReference(maskBits),
				Stencil.getReadMask(maskBits));
		}

		if( (diffOp & Stencil.backTest_mask) | (diffMask & (Stencil.reference_mask | Stencil.readMask_mask)) != 0 ) {
			gl.stencilFuncSeparate(
				FACES[Type.enumIndex(Back)],
				COMPARE[Stencil.getBackTest(opBits)],
				Stencil.getReference(maskBits),
				Stencil.getReadMask(maskBits));
		}

		if( diffMask & Stencil.writeMask_mask != 0 ) {
			var w = Stencil.getWriteMask(maskBits);
			gl.stencilMaskSeparate(FACES[Type.enumIndex(Front)], w);
			gl.stencilMaskSeparate(FACES[Type.enumIndex(Back)], w);
		}

		curStOpBits = opBits;
		curStMaskBits = maskBits;
	}

	override function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
		var bits = 0;
		if( color != null ) {
			gl.colorMask(true, true, true, true);
			curColorMask = 15;
			#if hlsdl
			// clear does not take gamma correction into account in GL/Windows
			if( curTarget != null && curTarget.isSRGB() )
				gl.clearColor(Math.pow(color.r, 1/2.2), Math.pow(color.g, 1/2.2), Math.pow(color.b, 1/2.2), color.a);
			else
			#end
			gl.clearColor(color.r, color.g, color.b, color.a);
			bits |= GL.COLOR_BUFFER_BIT;
		}
		if( depth != null ) {
			gl.depthMask(true);
			if( curMatBits >= 0 ) curMatBits |= Pass.depthWrite_mask;
			gl.clearDepth(depth);
			bits |= GL.DEPTH_BUFFER_BIT;
		}
		if( stencil != null ) {
			// reset stencyl mask when we allow to change it
			@:privateAccess selectStencilBits(defStencil.opBits, defStencil.maskBits);
			gl.clearStencil(stencil);
			bits |= GL.STENCIL_BUFFER_BIT;
		}
		if( bits != 0 ) gl.clear(bits);
		if( curTarget != null ) curTarget.flags.set(WasCleared);
	}

	override function resize(width, height) {
		#if js
		// prevent infinite grow if pixelRatio != 1
		if( canvas.style.width == "" ) {
			canvas.style.width = Std.int(width / js.Browser.window.devicePixelRatio)+"px";
			canvas.style.height = Std.int(height / js.Browser.window.devicePixelRatio)+"px";
		}
		canvas.width = width;
		canvas.height = height;
		#end
		bufferWidth = width;
		bufferHeight = height;
		gl.viewport(0, 0, width, height);

		@:privateAccess if( defaultDepth != null ) {
			disposeDepthBuffer(defaultDepth);
			defaultDepth.width = this.bufferWidth;
			defaultDepth.height = this.bufferHeight;
			defaultDepth.b = allocDepthBuffer(defaultDepth);
		}
	}

	function getChannels( t : Texture ) {
		return switch( t.internalFmt ) {
		case GL2.RGBA32F, GL2.RGBA16F, GL2.SRGB_ALPHA, GL2.SRGB8_ALPHA: GL.RGBA;
		case GL2.RGBA8: GL2.BGRA;
		case GL2.SRGB, GL2.SRGB8: GL.RGB;
		case GL.RGBA: GL.RGBA;
		case GL.RGB: GL.RGB;
		case GL2.R11F_G11F_B10F: GL.RGB;
		case GL2.RGB10_A2: GL.RGBA;
		case GL2.RED, GL2.R8, GL2.R16F, GL2.R32F: GL2.RED;
		case GL2.RG, GL2.RG8, GL2.RG16F, GL2.RG32F: GL2.RG;
		case GL2.RGB16F, GL2.RGB32F: GL.RGB;
		case 0x83F1, 0x83F2, 0x83F3: GL.RGBA;
		default: throw "Invalid format " + t.internalFmt;
		}
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return switch( fmt ) {
		case RGBA: true;
		case RGBA16F, RGBA32F: hasFeature(FloatTextures);
		case SRGB, SRGB_ALPHA: hasFeature(SRGBTextures);
		case R8, RG8, RGB8, R16F, RG16F, RGB16F, R32F, RG32F, RGB32F, RG11B10UF, RGB10A2: #if js glES >= 3 #else true #end;
		case S3TC(n): n <= maxCompressedTexturesSupport;
		default: false;
		}
	}

	function getBindType( t : h3d.mat.Texture ) {
		var isCube = t.flags.has(Cube);
		var isArray = t.flags.has(IsArray);
		return isCube ? GL.TEXTURE_CUBE_MAP : isArray ? GL2.TEXTURE_2D_ARRAY : GL.TEXTURE_2D;
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		discardError();
		var tt = gl.createTexture();
		var bind = getBindType(t);
		var tt : Texture = { t : tt, width : t.width, height : t.height, internalFmt : GL.RGBA, pixelFmt : GL.UNSIGNED_BYTE, bits : -1, bind : bind, bias : 0 #if multidriver, driver : this #end };
		switch( t.format ) {
		case RGBA:
			// default
		case RGBA32F if( hasFeature(FloatTextures) ):
			tt.internalFmt = GL2.RGBA32F;
			tt.pixelFmt = GL.FLOAT;
		case RGBA16F if( hasFeature(FloatTextures) ):
			tt.pixelFmt = GL2.HALF_FLOAT;
			tt.internalFmt = GL2.RGBA16F;
		case BGRA:
			tt.internalFmt = GL2.RGBA8;
		case SRGB:
			tt.internalFmt = GL2.SRGB8;
		case SRGB_ALPHA:
			tt.internalFmt = GL2.SRGB8_ALPHA;
		case RGB8:
			tt.internalFmt = GL.RGB;
		case R8:
			tt.internalFmt = GL2.R8;
		case RG8:
			tt.internalFmt = GL2.RG8;
		case R16F:
			tt.internalFmt = GL2.R16F;
			tt.pixelFmt = GL2.HALF_FLOAT;
		case RG16F:
			tt.internalFmt = GL2.RG16F;
			tt.pixelFmt = GL2.HALF_FLOAT;
		case R32F:
			tt.internalFmt = GL2.R32F;
			tt.pixelFmt = GL.FLOAT;
		case RG32F:
			tt.internalFmt = GL2.RG32F;
			tt.pixelFmt = GL.FLOAT;
		case RGB16F:
			tt.internalFmt = GL2.RGB16F;
			tt.pixelFmt = GL2.HALF_FLOAT;
		case RGB32F:
			tt.internalFmt = GL2.RGB32F;
			tt.pixelFmt = GL.FLOAT;
		case RGB10A2:
			tt.internalFmt = GL2.RGB10_A2;
			tt.pixelFmt = GL2.UNSIGNED_INT_2_10_10_10_REV;
		case RG11B10UF:
			tt.internalFmt = GL2.R11F_G11F_B10F;
			tt.pixelFmt = GL2.UNSIGNED_INT_10F_11F_11F_REV;
		case S3TC(n) if( n <= maxCompressedTexturesSupport ):
			if( t.width&3 != 0 || t.height&3 != 0 )
				throw "Compressed texture "+t+" has size "+t.width+"x"+t.height+" - must be a multiple of 4";
			switch( n ) {
			case 1: tt.internalFmt = 0x83F1; // COMPRESSED_RGBA_S3TC_DXT1_EXT
			case 2:	tt.internalFmt = 0x83F2; // COMPRESSED_RGBA_S3TC_DXT3_EXT
			case 3: tt.internalFmt = 0x83F3; // COMPRESSED_RGBA_S3TC_DXT5_EXT
			default: throw "Unsupported texture format "+t.format;
			}
		default:
			throw "Unsupported texture format "+t.format;
		}
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		gl.bindTexture(bind, tt.t);
		var outOfMem = false;

		inline function checkError() {
			if( !outOfMemoryCheck ) return false;
			var err = gl.getError();
			if( err == GL.OUT_OF_MEMORY ) {
				outOfMem = true;
				return true;
			}
			if( err != 0 ) throw "Failed to alloc texture "+t.format+"(error "+err+")";
			return false;
		}

		if( t.flags.has(Cube) ) {
			for( i in 0...6 ) {
				gl.texImage2D(CUBE_FACES[i], 0, tt.internalFmt, tt.width, tt.height, 0, getChannels(tt), tt.pixelFmt, null);
				if( checkError() ) break;
			}
		} else if( t.flags.has(IsArray) ) {
			gl.texImage3D(GL2.TEXTURE_2D_ARRAY, 0, tt.internalFmt, tt.width, tt.height, t.layerCount, 0, getChannels(tt), tt.pixelFmt, null);
			checkError();
		} else {
			#if js
			if( !t.format.match(S3TC(_)) )
			#end
			gl.texImage2D(bind, 0, tt.internalFmt, tt.width, tt.height, 0, getChannels(tt), tt.pixelFmt, null);
			checkError();
		}
		restoreBind();

		if( outOfMem ) {
			gl.deleteTexture(tt.t);
			return null;
		}

		return tt;
	}

	function restoreBind() {
		var t = boundTextures[lastActiveIndex];
		if( t == null )
			gl.bindTexture(GL.TEXTURE_2D, null);
		else
			gl.bindTexture(t.bind, t.t);
	}

	override function allocDepthBuffer( b : h3d.mat.DepthBuffer ) : DepthBuffer {
		var r = gl.createRenderbuffer();
		if( b.format == null )
			@:privateAccess b.format = #if js (glES >= 3 ? Depth24Stencil8 : Depth16) #else Depth24Stencil8 #end;
		var format = switch( b.format ) {
		case Depth16: GL.DEPTH_COMPONENT16;
		case Depth24 #if js if( glES >= 3 ) #end: GL2.DEPTH_COMPONENT24;
		case Depth24Stencil8: GL.DEPTH_STENCIL;
		default:
			throw "Unsupported depth format "+b.format;
		}
		gl.bindRenderbuffer(GL.RENDERBUFFER, r);
		gl.renderbufferStorage(GL.RENDERBUFFER, format, b.width, b.height);
		gl.bindRenderbuffer(GL.RENDERBUFFER, null);
		return { r : r #if multidriver, driver : this #end };
	}

	override function disposeDepthBuffer( b : h3d.mat.DepthBuffer ) {
		@:privateAccess if( b.b != null && b.b.r != null ) {
			gl.deleteRenderbuffer(b.b.r);
			b.b = null;
		}
	}

	var defaultDepth : h3d.mat.DepthBuffer;

	override function getDefaultDepthBuffer() : h3d.mat.DepthBuffer {
		if( defaultDepth != null )
			return defaultDepth;
		defaultDepth = new h3d.mat.DepthBuffer(0, 0);
		@:privateAccess {
			defaultDepth.width = this.bufferWidth;
			defaultDepth.height = this.bufferHeight;
			defaultDepth.b = allocDepthBuffer(defaultDepth);
		}
		return defaultDepth;
	}

	inline function discardError() {
		if( outOfMemoryCheck ) gl.getError(); // make sure to reset error flag
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		discardError();
		var b = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		if( m.size * m.stride == 0 ) throw "assert";
		#if js
		gl.bufferData(GL.ARRAY_BUFFER, m.size * m.stride * 4, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#elseif hl
		gl.bufferDataSize(GL.ARRAY_BUFFER, m.size * m.stride * 4, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#else
		var tmp = new Uint8Array(m.size * m.stride * 4);
		gl.bufferData(GL.ARRAY_BUFFER, tmp, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#end
		var outOfMem = outOfMemoryCheck && gl.getError() == GL.OUT_OF_MEMORY;
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		if( outOfMem ) {
			gl.deleteBuffer(b);
			return null;
		}
		return { b : b, stride : m.stride #if multidriver, driver : this #end };
	}

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		discardError();
		var b = gl.createBuffer();
		var size = is32 ? 4 : 2;
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, b);
		#if js
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, count * size, GL.STATIC_DRAW);
		#elseif hl
		gl.bufferDataSize(GL.ELEMENT_ARRAY_BUFFER, count * size, GL.STATIC_DRAW);
		#end
		var outOfMem = outOfMemoryCheck && gl.getError() == GL.OUT_OF_MEMORY;
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		curIndexBuffer = null;
		if( outOfMem ) {
			gl.deleteBuffer(b);
			return null;
		}
		return { b : b, is32 : is32 };
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		var tt = t.t;
		if( tt == null ) return;
		t.t = null;
		for( i in 0...boundTextures.length )
			if( boundTextures[i] == tt )
				boundTextures[i] = null;
		gl.deleteTexture(tt.t);
	}

	override function disposeIndexes( i : IndexBuffer ) {
		gl.deleteBuffer(i.b);
	}

	override function disposeVertexes( v : VertexBuffer ) {
		gl.deleteBuffer(v.b);
	}

	override function generateMipMaps( t : h3d.mat.Texture ) {
		var bind = getBindType(t);
		gl.bindTexture(bind, t.t.t);
		gl.generateMipmap(bind);
		restoreBind();
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
	#if hl
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	#else
		if( t.format != RGBA || t.flags.has(Cube) ) {
			var pixels = bmp.getPixels();
			uploadTexturePixels(t, pixels, mipLevel, side);
			pixels.dispose();
		} else {
			var img = bmp.toNative();
			gl.bindTexture(GL.TEXTURE_2D, t.t.t);
			gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, getChannels(t.t), t.t.pixelFmt, img.getImageData(0, 0, bmp.width, bmp.height));
			restoreBind();
		}
	#end
	}

	/*
		GL async model create crashes if the GC free the memory that we send it.
		Instead, we will copy the data into a temp location before uploading.
	*/

	static inline var STREAM_POS = #if hl 0 #else 1 #end;
	#if hl

	var streamKeep : Array<{ f : Int, b : hl.Bytes }> = [];
	var streamBytes : hl.Bytes;
	var streamLen : Int;
	var streamPos : Int;

	function expandStream(needed:Int) {
		GL.finish();

		// too much data in our tmp buffer, let's flush it
		if( streamPos > (needed >> 1) && needed > 16 << 20 ) {
			needed -= streamPos;
			streamPos = 0;
			if( needed < streamLen )
				return;
		}

		var newLen = streamLen == 0 ? 0x10000 : streamLen;
		while( newLen < needed )
			newLen = (newLen * 3) >> 1;
		var newBytes = new hl.Bytes(newLen);
		if( streamPos > 0 )
			newBytes.blit(0, streamBytes, 0, streamPos);
		streamLen = newLen;
		if( streamBytes != null ) streamKeep.push({ f : frame, b : streamBytes });
		streamBytes = newBytes;
	}

	#end

	function resetStream() {
		#if hl
		streamPos = 0;
		// keep during 2 frames
		while( streamKeep.length > 0 && streamKeep[0].f < frame - 1 ) streamKeep.shift();
		#end
	}

	inline function streamData(data, pos:Int, length:Int) {
		#if hl
		var needed = streamPos + length;
		var total = (needed + 7) & ~7; // align on 8 bytes
		var alen = total - streamPos;
		if( total > streamLen ) expandStream(total);
		streamBytes.blit(streamPos, data, pos, length);
		data = streamBytes.offset(streamPos);
		streamPos += alen;
		#end
		return data;
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		var cubic = t.flags.has(Cube);
		var bind = getBindType(t);
		if( t.flags.has(IsArray) ) throw "TODO:texImage3D";
		var face = cubic ? CUBE_FACES[side] : GL.TEXTURE_2D;
		gl.bindTexture(bind, t.t.t);
		pixels.convert(t.format);
		pixels.setFlip(false);
		var dataLen = pixels.dataSize;
		#if hl
		var stream = streamData(pixels.bytes.getData(),pixels.offset,dataLen);
		if( t.format.match(S3TC(_)) ) {
			#if( (hlsdl == "1.8.0") || (hlsdl == "1.9.0") )
			throw "Compressed textures require hlsdl 1.10+";
			#else
			gl.compressedTexImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, dataLen, stream);
			#end
		} else
			gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, stream);
		#elseif js
		#if hxnodejs
		if( (pixels:Dynamic).bytes.b.hxBytes != null ) {
			// if the pixels are a nodejs buffer, their might be GC'ed while upload !
			// might be some problem with Node/WebGL relation
			// let's clone the pixels in order to have a fresh JS bytes buffer
			pixels = pixels.clone();
		}
		#end
		var buffer : ArrayBufferView = switch( t.format ) {
		case RGBA32F, R32F, RG32F, RGB32F: new Float32Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen>>2);
		case RGBA16F, R16F, RG16F, RGB16F: new Uint16Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen>>1);
		case RGB10A2, RG11B10UF: new Uint32Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen>>2);
		default: new Uint8Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen);
		}
		if( t.format.match(S3TC(_)) )
			gl.compressedTexImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, buffer);
		else
			gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, buffer);
		#else
		throw "Not implemented";
		#end
		t.flags.set(WasCleared);
		restoreBind();
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hl
		var data = #if hl hl.Bytes.getArray(buf.getNative()) #else buf.getNative() #end;
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, streamData(data,bufPos * 4,vertexCount * stride * 4), bufPos * 4 * STREAM_POS, vertexCount * stride * 4);
		#else
		var buf : Float32Array = buf.getNative();
		var sub = new Float32Array(buf.buffer, bufPos * 4, vertexCount * stride);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hl
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, streamData(buf.getData(),bufPos * 4,vertexCount * stride * 4), bufPos * 4 * STREAM_POS, vertexCount * stride * 4);
		#else
		var sub = new Uint8Array(buf.getData(), bufPos * 4, vertexCount * stride * 4);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var bits = i.is32 ? 2 : 1;
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i.b);
		#if hl
		var data = #if hl hl.Bytes.getArray(buf.getNative()) #else buf.getNative() #end;
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice << bits, streamData(data,bufPos << bits,indiceCount << bits), (bufPos << bits) * STREAM_POS, indiceCount << bits);
		#else
		var buf = new Uint16Array(buf.getNative());
		var sub = new Uint16Array(buf.buffer, bufPos << bits, indiceCount);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice << bits, sub);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		curIndexBuffer = null;
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		var bits = i.is32 ? 2 : 1;
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i.b);
		#if hl
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice << bits, streamData(buf.getData(),bufPos << bits, indiceCount << bits), (bufPos << bits) * STREAM_POS, indiceCount << bits);
		#else
		var sub = new Uint8Array(buf.getData(), bufPos << bits, indiceCount << bits);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice << bits, sub);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		curIndexBuffer = null;
	}

	inline function updateDivisor( a : CompiledAttribute ) {
		if( currentDivisor[a.index] != a.divisor ) {
			currentDivisor[a.index] = a.divisor;
			gl.vertexAttribDivisor(a.index, a.divisor);
		}
	}

	override function selectBuffer( v : h3d.Buffer ) {

		if( v == curBuffer )
			return;
		if( curBuffer != null && v.buffer == curBuffer.buffer && v.buffer.flags.has(RawFormat) == curBuffer.flags.has(RawFormat) ) {
			curBuffer = v;
			return;
		}

		if( curShader == null )
			throw "No shader selected";
		curBuffer = v;

		var m = @:privateAccess v.buffer.vbuf;
		if( m.stride < curShader.stride )
			throw "Buffer stride (" + m.stride + ") and shader stride (" + curShader.stride + ") mismatch";

		#if multidriver
		if( m.driver != this )
			throw "Invalid buffer context";
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, m.b);

		if( v.flags.has(RawFormat) ) {
			for( a in curShader.attribs ) {
				var pos = a.offset;
				gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, pos * 4);
				updateDivisor(a);
			}
		} else {
			var offset = 8;
			for( i in 0...curShader.attribs.length ) {
				var a = curShader.attribs[i];
				var pos;
				switch( curShader.inputs.names[i] ) {
				case "position":
					pos = 0;
				case "normal":
					if( m.stride < 6 ) throw "Buffer is missing NORMAL data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
					pos = 3;
				case "uv":
					if( m.stride < 8 ) throw "Buffer is missing UV data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
					pos = 6;
				case s:
					pos = offset;
					offset += a.size;
					if( offset > m.stride ) throw "Buffer is missing '"+s+"' data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
				}
				gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, pos * 4);
				updateDivisor(a);
			}
		}
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		for( a in curShader.attribs ) {
			gl.bindBuffer(GL.ARRAY_BUFFER, @:privateAccess buffers.buffer.buffer.vbuf.b);
			gl.vertexAttribPointer(a.index, a.size, a.type, false, buffers.buffer.buffer.stride * 4, buffers.offset * 4);
			updateDivisor(a);
			buffers = buffers.next;
		}
		curBuffer = null;
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		if( ibuf != curIndexBuffer ) {
			curIndexBuffer = ibuf;
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf.b);
		}
		if( ibuf.is32 )
			gl.drawElements(drawMode, ntriangles * 3, GL.UNSIGNED_INT, startIndex * 4);
		else
			gl.drawElements(drawMode, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
	}

	override function allocInstanceBuffer( b : InstanceBuffer, bytes : haxe.io.Bytes ) {
		#if hl
		if( hasMultiIndirect ) {
			var buf = gl.createBuffer();
			gl.bindBuffer(GL2.DRAW_INDIRECT_BUFFER, buf);
			gl.bufferData(GL2.DRAW_INDIRECT_BUFFER, b.commandCount * 20, streamData(bytes.getData(),0, b.commandCount * 20), GL.DYNAMIC_DRAW);
			gl.bindBuffer(GL2.DRAW_INDIRECT_BUFFER, null);
			b.data = buf;
			return;
		}
		#end
		var data = [];
		for( i in 0...b.commandCount ) {
			var p = i * 5 * 4;
			var indexCount = bytes.getInt32(p);
			var instanceCount = bytes.getInt32(p+4);
			var offIndex = bytes.getInt32(p+8);
			var offVertex = bytes.getInt32(p+12);
			var offInstance = bytes.getInt32(p+16);
			if( offVertex != 0 || offInstance != 0 )
				throw "baseVertex and baseInstance must be zero on this platform";
			data.push(indexCount);
			data.push(offIndex);
			data.push(instanceCount);
		}
		b.data = data;
	}

	override function disposeInstanceBuffer(b:InstanceBuffer) {
		b.data = null;
	}

	override function drawInstanced( ibuf : IndexBuffer, commands : InstanceBuffer ) {
		if( ibuf != curIndexBuffer ) {
			curIndexBuffer = ibuf;
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf.b);
		}
		#if !js
		if( hasMultiIndirect && commands.data != null ) {
			gl.bindBuffer(GL2.DRAW_INDIRECT_BUFFER, commands.data);
			gl.multiDrawElementsIndirect(drawMode, ibuf.is32 ? GL.UNSIGNED_INT : GL.UNSIGNED_SHORT, null, commands.commandCount, 0);
			gl.bindBuffer(GL2.DRAW_INDIRECT_BUFFER, null);
			return;
		}
		#end
		var args : Array<Int> = commands.data;
		if( args != null ) {
			var p = 0;
			for( i in 0...Std.int(args.length/3) )
				gl.drawElementsInstanced(drawMode, args[p++], ibuf.is32 ? GL.UNSIGNED_INT : GL.UNSIGNED_SHORT, args[p++], args[p++]);
		} else
			gl.drawElementsInstanced(drawMode, commands.indexCount, ibuf.is32 ? GL.UNSIGNED_INT : GL.UNSIGNED_SHORT, 0, commands.commandCount);
	}

	override function end() {
		// no gl finish or flush !
	}

	override function present() {
		#if hlsdl
		@:privateAccess hxd.Window.inst.window.present();
		#elseif usesys
		haxe.System.present();
		#end
	}

	override function isDisposed() {
		return gl.isContextLost();
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 )
			gl.disable(GL.SCISSOR_TEST);
		else {
			gl.enable(GL.SCISSOR_TEST);
			if( curTarget == null )
				y = bufferHeight - (y + height);
			gl.scissor(x, y, width, height);
		}
	}

	function setDrawBuffers( k : Int ) {
		#if js
		if( glES >= 3 )
			gl.drawBuffers(CBUFFERS[k]);
		else if( mrtExt != null )
			mrtExt.drawBuffersWEBGL(CBUFFERS[k]);
		#elseif (hlsdl || usegl)
		gl.drawBuffers(k, CBUFFERS);
		#end
	}

	function unbindTargets() {
		if( curTarget != null && numTargets > 1 ) {
			while( numTargets > 1 ) {
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0 + (--numTargets), GL.TEXTURE_2D, null, 0);
				curTargets[numTargets] = null;
			}
			setDrawBuffers(1);
		}
	}

	override function capturePixels(tex:h3d.mat.Texture, layer:Int, mipLevel:Int, ?region:h2d.col.IBounds) {

		var pixels : hxd.Pixels;
		var x : Int, y : Int, w : Int, h : Int;
		if (region != null) {
			if (region.xMax > tex.width) region.xMax = tex.width;
			if (region.yMax > tex.height) region.yMax = tex.height;
			if (region.xMin < 0) region.xMin = 0;
			if (region.yMin < 0) region.yMin = 0;
			w = region.width;
			h = region.height;
			x = region.xMin;
			y = region.yMin;
		} else {
			w = tex.width;
			h = tex.height;
			x = 0;
			y = 0;
		}

		w >>= mipLevel;
		h >>= mipLevel;
		if( w == 0 ) w = 1;
		if( h == 0 ) h = 1;
		pixels = hxd.Pixels.alloc(w, h, tex.format);

		var old = curTarget;
		var oldCount = numTargets;
		var oldLayer = curTargetLayer;
		var oldMip = curTargetMip;
		if( oldCount > 1 ) {
			numTargets = 1;
			for( i in 1...oldCount )
				if( curTargets[i] == tex )
					gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0+i,GL.TEXTURE_2D,null,0);
		}
		setRenderTarget(tex, layer, mipLevel);
		captureSubRenderBuffer(pixels, x, y);
		setRenderTarget(old, oldLayer, oldMip);
		if( oldCount > 1 ) {
			for( i in 1...oldCount )
				if( curTargets[i] == tex )
					gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0+i,GL.TEXTURE_2D,tex.t.t,0);
			setDrawBuffers(oldCount);
			numTargets = oldCount;
		}
		return pixels;
	}

	override function setRenderTarget( tex : h3d.mat.Texture, layer = 0, mipLevel = 0 ) {
		unbindTargets();
		curTarget = tex;
		if( tex == null ) {
			gl.bindFramebuffer(GL.FRAMEBUFFER, null);
			gl.viewport(0, 0, bufferWidth, bufferHeight);
			return;
		}

		if( tex.depthBuffer != null && (tex.depthBuffer.width != tex.width || tex.depthBuffer.height != tex.height) )
			throw "Invalid depth buffer size : does not match render target size";

		if( mipLevel > 0 && glES == 1 ) throw "Cannot render to mipLevel in WebGL1, use upload() instead";

		if( tex.t == null )
			tex.alloc();

		if( tex.flags.has(MipMapped) && !tex.flags.has(WasCleared) ) {
			var bind = getBindType(tex);
			gl.bindTexture(bind, tex.t.t);
			gl.generateMipmap(bind);
			restoreBind();
		}

		tex.lastFrame = frame;
		curTargetLayer = layer;
		curTargetMip = mipLevel;
		#if multidriver
		if( tex.t.driver != this )
			throw "Invalid texture context";
		#end
		gl.bindFramebuffer(GL.FRAMEBUFFER, commonFB);

		if( tex.flags.has(IsArray) )
			gl.framebufferTextureLayer(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, tex.t.t, mipLevel, layer);
		else
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, tex.flags.has(Cube) ? CUBE_FACES[layer] : GL.TEXTURE_2D, tex.t.t, mipLevel);

		if( tex.depthBuffer != null ) {
			// Depthbuffer and stencilbuffer are combined in one buffer, created with GL.DEPTH_STENCIL
			if(tex.depthBuffer.hasStencil() && tex.depthBuffer.format == Depth24Stencil8) {
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER,@:privateAccess tex.depthBuffer.b.r);
			} else {
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER,null);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, @:privateAccess tex.depthBuffer.b.r);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER,tex.depthBuffer.hasStencil() ? @:privateAccess tex.depthBuffer.b.r : null);
			}
		} else {
			gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER,null);
			gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, null);
			gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER, null);
		}

		var w = tex.width >> mipLevel; if( w == 0 ) w = 1;
		var h = tex.height >> mipLevel; if( h == 0 ) h = 1;
		gl.viewport(0, 0, w, h);
		for( i in 0...boundTextures.length )
			boundTextures[i] = null;

		if( !tex.flags.has(WasCleared) ) {
			tex.flags.set(WasCleared); // once we draw to, do not clear again
			clear(BLACK);
		}

		#if js
		if( glDebug ) {
			var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);
			if( code != GL.FRAMEBUFFER_COMPLETE )
				throw "Invalid frame buffer: "+code;
		}
		#end
	}

	override function setRenderTargets( textures : Array<h3d.mat.Texture> ) {
		unbindTargets();
		setRenderTarget(textures[0]);
		if( textures.length < 2 )
			return;
		numTargets = textures.length;
		var needClear = false;
		for( i in 1...textures.length ) {
			var tex = textures[i];
			if( tex.t == null )
				tex.alloc();
			#if multidriver
			if( tex.t.driver != this )
				throw "Invalid texture context";
			#end
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0 + i, GL.TEXTURE_2D, tex.t.t, 0);
			curTargets[i] = tex;
			tex.lastFrame = frame;
			if( !tex.flags.has(WasCleared) ) {
				tex.flags.set(WasCleared); // once we draw to, do not clear again
				needClear = true;
			}
		}
		setDrawBuffers(textures.length);
		if( needClear ) clear(BLACK);
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		#if js
		var ready = false;
		// wait until all assets have properly load
		if( js.Browser.document.readyState == 'complete' )
			haxe.Timer.delay(onCreate.bind(false), 1);
		else
			js.Browser.window.addEventListener("load", function(_) {
				if( !ready ) {
					ready = true;
					onCreate(false);
				}
			});
		#else
		haxe.Timer.delay(onCreate.bind(false), 1);
		#end
	}

	override function hasFeature( f : Feature ) : Bool {
		#if js
		return features.get(f);
		#else
		return true;
		#end
	}

	#if js
	var features : Map<Feature,Bool> = new Map();
	function makeFeatures() {
		for( f in Type.allEnums(Feature) )
			features.set(f,checkFeature(f));
		if( gl.getExtension("WEBGL_compressed_texture_s3tc") != null )
			maxCompressedTexturesSupport = 3;
	}
	function checkFeature( f : Feature ) {
		return switch( f ) {

		case HardwareAccelerated, AllocDepthBuffer, BottomLeftCoords, Wireframe:
			true;

		case StandardDerivatives, MultipleRenderTargets, SRGBTextures if( glES >= 3 ):
			true;

		case ShaderModel3 if( glES >= 3 ):
			true;

		case FloatTextures if( glES >= 3 ):
			gl.getExtension('EXT_color_buffer_float') != null && gl.getExtension("OES_texture_float_linear") != null; // allow render to 16f/32f textures (not standard in webgl 2)

		case StandardDerivatives:
			gl.getExtension('OES_standard_derivatives') != null;

		case FloatTextures:
			gl.getExtension('OES_texture_float') != null && gl.getExtension('OES_texture_float_linear') != null &&
			gl.getExtension('OES_texture_half_float') != null && gl.getExtension('OES_texture_half_float_linear') != null;

		case SRGBTextures:
			gl.getExtension('EXT_sRGB') != null;

		case MultipleRenderTargets:
			mrtExt != null || (mrtExt = gl.getExtension('WEBGL_draw_buffers')) != null;

		case InstancedRendering:
			return (glES >= 3) ? true : gl.getExtension("ANGLE_instanced_arrays") != null;

		default:
			false;
		}
	}

	// Draws video element directly onto Texture. Used for video rendering.
	private function uploadTextureVideoElement( t : h3d.mat.Texture, v : js.html.VideoElement, mipLevel : Int, side : Int ) {
		var cubic = t.flags.has(Cube);
		var bind = getBindType(t);
		if( t.flags.has(IsArray) ) throw "TODO:texImage3D";
		var face = cubic ? CUBE_FACES[side] : GL.TEXTURE_2D;
		gl.bindTexture(bind, t.t.t);
		if (glES >= 3) {
			// WebGL2 support
			gl.texImage2D(face, mipLevel, t.t.internalFmt, v.videoWidth, v.videoHeight, 0, getChannels(t.t), t.t.pixelFmt, untyped v);
		} else {
			gl.texImage2D(face, mipLevel, t.t.internalFmt, t.t.internalFmt, t.t.pixelFmt, v);
		}
		restoreBind();
	}

	#end

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		captureSubRenderBuffer(pixels, 0, 0);
	}

	function captureSubRenderBuffer( pixels : hxd.Pixels, x : Int, y : Int ) {
		if( curTarget == null )
			throw "Can't capture main render buffer in GL";
		discardError();
		#if js
		var buffer : ArrayBufferView = @:privateAccess pixels.bytes.b;
		switch( curTarget.format ) {
		case RGBA32F, R32F, RG32F, RGB32F: buffer = new Float32Array(buffer.buffer);
		case RGBA16F, R16F, RG16F, RGB16F: buffer = new Uint16Array(buffer.buffer);
		case RGB10A2, RG11B10UF: buffer = new Uint32Array(buffer.buffer);
		default:
		}
		#else
		var buffer = @:privateAccess pixels.bytes.b;
		#end
		#if (js || hl)
		gl.readPixels(x, y, pixels.width, pixels.height, getChannels(curTarget.t), curTarget.t.pixelFmt, buffer);
		var error = gl.getError();
		if( error != 0 ) throw "Failed to capture pixels (error "+error+")";
		@:privateAccess pixels.innerFormat = curTarget.format;
		#end
	}

	#if hl

	override function allocQuery(kind:QueryKind) {
		return { q : GL.createQuery(), kind : kind };
	}

	override function deleteQuery( q : Query ) {
		GL.deleteQuery(q.q);
		q.q = null;
	}

	override function beginQuery( q : Query ) {
		switch( q.kind ) {
		case TimeStamp:
			throw "use endQuery() for timestamp queries";
		case Samples:
			GL.beginQuery(GL.SAMPLES_PASSED, q.q);
		}
	}

	override function endQuery( q : Query ) {
		switch( q.kind ) {
		case TimeStamp:
			GL.queryCounter(q.q, GL.TIMESTAMP);
		case Samples:
			GL.endQuery(GL.SAMPLES_PASSED);
		}
	}

	override function queryResultAvailable(q:Query) {
		return GL.queryResultAvailable(q.q);
	}

	override function queryResult(q:Query) {
		return GL.queryResult(q.q);
	}

	#end

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
		GL.FRONT,
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

	static var STENCIL_OP = [
		GL.KEEP,
		GL.ZERO,
		GL.REPLACE,
		GL.INCR,
		GL.INCR_WRAP,
		GL.DECR,
		GL.DECR_WRAP,
		GL.INVERT,
	];

	static var OP = [
		GL.FUNC_ADD,
		GL.FUNC_SUBTRACT,
		GL.FUNC_REVERSE_SUBTRACT,
		GL2.FUNC_MIN,
		GL2.FUNC_MAX
	];

	static var CUBE_FACES = [
		GL.TEXTURE_CUBE_MAP_POSITIVE_X,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_X,
		GL.TEXTURE_CUBE_MAP_POSITIVE_Y,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_Y,
		GL.TEXTURE_CUBE_MAP_POSITIVE_Z,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_Z,
	];

	static var CBUFFERS =
		#if (hlsdl || usegl)
			hl.Bytes.getArray([for( i in 0...32 ) GL.COLOR_ATTACHMENT0 + i]);
		#elseif js
			[for( i in 0...32 ) [for( k in 0...i ) GL.COLOR_ATTACHMENT0 + k]];
		#else
			null;
		#end

}

#end
