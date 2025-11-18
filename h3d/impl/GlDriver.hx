package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;
import h3d.mat.Stencil;
import h3d.mat.Data;

#if (js||hlsdl||usegl)

#if js
import hxd.impl.TypedArray;
private typedef GL = js.html.webgl.GL2;
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
	public var kind : hxsl.Ast.FunctionKind;
	public var globals : Uniform;
	public var params : Uniform;
	public var textures : Array<{ u : Uniform, t : hxsl.Ast.Type, mode : Int }>;
	public var buffers : Array<Int>;
	public var bufferTypes : Array<hxsl.Ast.BufferKind>;
	public var shader : hxsl.RuntimeShader.RuntimeShaderData;
	public function new(s,kind,shader) {
		this.s = s;
		this.kind = kind;
		this.shader = shader;
	}
}

private class CompiledAttribute {
	public var index : Int;
	public var type : Int;
	public var size : Int;
	public var divisor : Int;
	public function new() {
	}
}

private class CompiledProgram {
	public var p : Program;
	public var vertex : CompiledShader;
	public var fragment : CompiledShader;
	public var format : hxd.BufferFormat;
	public var attribs : Array<CompiledAttribute>;
	public var hasAttribIndex : Int;
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
	public var gl : GL;
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
	var curIndexBuffer : h3d.Buffer;
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
	var useDepthClamp = false;

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

	public static var hasMultiIndirectCount = false;

	var drawMode : Int;
	var isIntelGpu : Bool;

	static var BLACK = new h3d.Vector4(0,0,0,0);

	/**
		Perform OUT_OF_MEMORY checks when allocating textures/buffers.
		Default true, except in WebGL (false)
	**/
	public static var outOfMemoryCheck = #if js false #else true #end;

	public function new(antiAlias=0) {
		#if (hlsdl >= version("1.15.0"))
		if ( computeEnabled )
			sdl.Sdl.setGLVersion(4, 3);
		#end

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
		frame = hxd.Timer.frameCount;

		#if hlsdl
		hasMultiIndirect = gl.getConfigParameter(0) > 0;
		maxCompressedTexturesSupport = 7;
		var driver = getDriverName(false).toLowerCase();
		isIntelGpu = ~/intel.*graphics/.match(driver);
		#end

		#if (hlsdl >= version("1.15.0"))
		hasMultiIndirectCount = gl.hasExtension("GL_ARB_indirect_parameters");
		#end

		#if hlmesa
		hasMultiIndirect = true;
		maxCompressedTexturesSupport = 7;
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

		#if (hlsdl >= version("1.15.0"))
		if ( computeEnabled )
			shaderVersion = 430;
		#end

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

	#if hlsdl
	static var computeEnabled : Bool = false;
	public static function enableComputeShaders() {
		#if (hlsdl >= version("1.15.0"))
		computeEnabled = true;
		#else
		throw "enableComputeShaders() requires hlsdl 1.15+";
		#end
	}
	#end

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

	function makeCompiler() {
		var glout = new ShaderCompiler();
		glout.glES = glES;
		glout.version = shaderVersion;
		#if !usegl
		@:privateAccess glout.intelDriverFix = isIntelGpu;
		#end
		return glout;
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		inline function compile(sh) {
			return makeCompiler().run(sh);
		}
		if( shader.mode == Compute )
			return compile(shader.compute.data);
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
		var type = switch( shader.kind ) {
		case Vertex: GL.VERTEX_SHADER;
		case Fragment: GL.FRAGMENT_SHADER;
		#if js
		case Main: throw "Compute shader is not supported";
		#else
		case Main: GL.COMPUTE_SHADER;
		#end
		default: throw "assert";
		};
		var s = gl.createShader(type);
		if( shader.code == null ){
			shader.code = glout.run(shader.data);
			#if !heaps_compact_mem
			shader.data.funs = null;
			#end
		}
		gl.shaderSource(s, shader.code);
		gl.compileShader(s);
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
		return new CompiledShader(s, shader.kind, shader);
	}

	function initShader( p : CompiledProgram, s : CompiledShader, shader : hxsl.RuntimeShader.RuntimeShaderData, rt : hxsl.RuntimeShader ) {
		var prefix = switch( s.kind ) {
		case Vertex: "vertex";
		case Fragment: "fragment";
		default: "compute";
		}
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
			case TChannel(_): tt = TSampler(T2D,false);
			case TArray(t,SConst(n)): tt = t; count = n;
			default:
			}
			if( curT == null || !tt.equals(curT) ) {
				curT = tt;
				name = switch( tt ) {
				case TSampler(dim,arr):
					mode = switch( [dim, arr] ) {
					case [T2D, false]: GL.TEXTURE_2D;
					case [T3D, false]: GL.TEXTURE_3D;
					case [TCube, false]: GL.TEXTURE_CUBE_MAP;
					case [T2D, true]: GL.TEXTURE_2D_ARRAY;
					#if (hlsdl > version("1.15.0"))
					case [T1D, false]: GL.TEXTURE_1D;
					case [T1D, true]: GL.TEXTURE_1D_ARRAY;
					case [TCube, true]: GL.TEXTURE_CUBE_MAP_ARRAY;
					#end
					default: throw "Texture not supported "+tt;
					}
					"Textures" + (dim == T2D ? "" : dim.getName().substr(1))+(arr ? "Array" : "");
				case TRWTexture(dim, arr, chans):
					#if (js || hlsdl < version("1.15.0"))
					throw "Texture not supported "+tt;
					#else
					mode = switch( [dim, arr] ) {
					case [T1D, false]: GL.IMAGE_1D;
					case [T2D, false]: GL.IMAGE_2D;
					case [T3D, false]: GL.IMAGE_3D;
					case [TCube, false]: GL.IMAGE_CUBE;
					case [T1D, true]: GL.IMAGE_1D_ARRAY;
					case [T2D, true]: GL.IMAGE_2D_ARRAY;
					case [TCube, true]: GL.IMAGE_CUBE_MAP_ARRAY;
					default: throw "Texture not supported "+tt;
					};
					"TexturesRW" + (dim == T2D ? "" : dim.getName().substr(1))+chans+(arr ? "Array" : "");
					#end
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
					throw "Texture "+rt.spec.instances[t.instance].shader.data.name+"."+t.name+" is missing from generated shader";
				s.textures.push({ u : loc, t : curT, mode : mode });
				index++;
			}
			t = t.next;
		}
		if( shader.bufferCount > 0 ) {
			s.bufferTypes = [];
			var bp = s.shader.buffers;
			while( bp != null ) {
				var kind = switch( bp.type ) {
				case TBuffer(_,_,kind): kind;
				default: throw "assert";
				}
				s.bufferTypes.push(kind);
				bp = bp.next;
			}
			s.buffers = [for( i in 0...shader.bufferCount ) {
				switch( s.bufferTypes[i] ) {
				case Storage:
					#if js
					throw "Storage buffer not supported in WebGL";
					#elseif (hl_ver < version("1.15.0"))
					throw "Storage buffer support requires -D hl-ver=1.15.0";
					#else
					gl.getProgramResourceIndex(p.p,GL.SHADER_STORAGE_BLOCK,(shader.kind==Vertex?"storage_vertex_":"storage_")+"uniform_buffer"+i);
					#end
				case RW:
					#if js
					throw "RW buffer not supported in WebGL";
					#elseif (hl_ver < version("1.15.0"))
					throw "RW buffer support requires -D hl-ver=1.15.0";
					#else
					gl.getProgramResourceIndex(p.p,GL.SHADER_STORAGE_BLOCK,(shader.kind==Vertex?"rw_vertex_":"rw_")+"uniform_buffer"+i);
					#end
				case Uniform:
					gl.getUniformBlockIndex(p.p,(shader.kind==Vertex?"vertex_":"")+"uniform_buffer"+i);
				default:
					throw "assert";
				}
			}];
			var start = 0;
			if( s.kind == Fragment ) start = rt.vertex.bufferCount;
			for( i in 0...shader.bufferCount )
				switch( s.bufferTypes[i] ) {
				case Uniform:
					gl.uniformBlockBinding(p.p,s.buffers[i],i + start);
				case RW, Storage:
					#if (hl && hl_ver >= version("1.15.0"))
					gl.shaderStorageBlockBinding(p.p,s.buffers[i], i + start);
					#end
				default:
					throw "assert";
				}
		}
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var p = programs.get(shader.id);
		if( p == null ) {
			p = new CompiledProgram();
			var glout = makeCompiler();
			p.vertex = compileShader(glout,shader.vertex);
			if( shader.fragment != null )
				p.fragment = compileShader(glout,shader.fragment);

			p.p = gl.createProgram();
			#if ((hlsdl || usegl) && !hlmesa)
			if( glES == null && shader.fragment != null ) {
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
			if( p.fragment != null )
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
			if( p.fragment != null )
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
				throw "Program linkage failure: "+log+"\nVertex=\n"+shader.vertex.code+(shader.fragment == null ? "" : "\n\nFragment=\n"+shader.fragment.code);
			}
			firstShader = false;
			initShader(p, p.vertex, shader.vertex, shader);
			if( p.fragment != null )
				initShader(p, p.fragment, shader.fragment, shader);
			p.attribs = [];
			p.hasAttribIndex = 0;
			var format : Array<hxd.BufferFormat.BufferInput> = [];
			for( v in shader.vertex.data.vars )
				switch( v.kind ) {
				case Input:
					var t = hxd.BufferFormat.InputFormat.fromHXSL(v.type);
					var index = gl.getAttribLocation(p.p, glout.varNames.exists(v.id) ? glout.varNames.get(v.id) : v.name);
					if( index < 0 )
						continue;
					if( index >= 32 )
						throw "assert";
					var a = new CompiledAttribute();
					a.type = GL.FLOAT;
					a.index = index;
					a.size = t.getSize();
					switch( v.type ) {
					case TBytes(n):
						a.type = GL.BYTE;
						a.size = n;
					default:
					}

					a.divisor = 0;
					if( v.qualifiers != null ) {
						for( q in v.qualifiers )
							switch( q ) {
							case PerInstance(n): a.divisor = n;
							default:
							}
					}
					p.attribs.push(a);
					p.hasAttribIndex |= 1 << a.index;
					format.push({ name : v.name, type : t });
				default:
				}
			p.format = hxd.BufferFormat.make(format);
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
			if( curAttribs[i] && p.hasAttribIndex & (1 << i) == 0) {
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
		if( curShader.fragment != null )
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
				if( s.kind == Fragment && curShader.vertex.buffers != null )
					start = curShader.vertex.buffers.length;
				for( i in 0...s.buffers.length )
					switch( s.bufferTypes[i] ) {
					case Uniform:
						gl.bindBufferBase(GL.UNIFORM_BUFFER, i + start, buf.buffers[i].vbuf);
					case Storage:
						gl.bindBufferBase(0x90D2 /*GL.SHADER STORAGE BUFFER*/, i + start, buf.buffers[i].vbuf);
					case RW:
						if ( !buf.buffers[i].flags.has(ReadWriteBuffer) )
							throw "Buffer was allocated without ReadWriteBuffer flag";
						gl.bindBufferBase(0x90D2 /*GL.SHADER STORAGE BUFFER*/, i + start, buf.buffers[i].vbuf);
					default:
						throw "assert";
					}
			}
		case Textures:
			var imageBindingIdx = 0;
			for( i in 0...s.textures.length ) {
				var t = buf.tex[i];
				var pt = s.textures[i];
				if( t == null || t.isDisposed() ) {
					switch( pt.t ) {
						case TSampler(TCube, false):
							t = h3d.mat.Texture.defaultCubeTexture();
						case TSampler(T3D, false):
							t = h3d.mat.Texture3D.default3DTexture();
						case TSampler(_, false):
							var color = h3d.mat.Defaults.loadingTextureColor;
							t = h3d.mat.Texture.fromColor(color, (color >>> 24) / 255);
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

				#if !js
				switch( pt.t ) {
				case TRWTexture(dim,arr,chans):
					var tdim : hxsl.Ast.TexDimension = t.flags.has(Cube) ? TCube : dim;
					var fmt;
					if( (arr != t.flags.has(IsArray)) || dim != tdim )
						fmt = 0;
					else {
						// we suppose it's possible to map from one pixel format to shader declared 32f
						fmt = switch( [chans,t.format] ) {
						case [1, R8]: GL.R8;
						case [2, RG8]: GL.RG8;
						case [4, RGBA]: GL.RGBA8;
						case [1, R16F]: GL.R16F;
						case [2, RG16F]: GL.RG16F;
						case [4, RGBA16F]: GL.RGBA16F;
						case [1, R32F]: GL.R32F;
						case [2, RG32F]: GL.RG32F;
						case [4, RGBA32F]: GL.RGBA32F;
						default: 0;
						}
					}
					if( fmt == 0 )
						throw "Texture format does not match: "+t+"["+t.format+"] should be "+hxsl.Ast.Tools.toString(pt.t);
					#if (hlsdl < version("1.15.0"))
					throw "RWTextures support requires hlsdl 1.15+";
					#else
					gl.bindImageTexture(imageBindingIdx++, cast t.t.t, 0, tdim == T3D ? true : false, 0, GL.READ_WRITE, fmt);
					#end
					boundTextures[i] = null;
					continue;
				default:
				}
				#end

				var idx = s.kind == Fragment ? curShader.vertex.textures.length + i : i;
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
				var startingMip = t.startingMip;
				var bits = t.bits;
				if( bits != t.t.bits ) {
					t.t.bits = bits;
					var flags = TFILTERS[mip][filter];
					var mode = pt.mode;
					gl.texParameteri(mode, GL.TEXTURE_MAG_FILTER, flags[0]);
					gl.texParameteri(mode, GL.TEXTURE_MIN_FILTER, flags[1]);
					gl.texParameteri(mode, GL.TEXTURE_COMPARE_MODE, GL.NONE);
					var w = TWRAP[wrap];
					gl.texParameteri(mode, GL.TEXTURE_WRAP_S, w);
					gl.texParameteri(mode, GL.TEXTURE_WRAP_T, w);
					gl.texParameteri(mode, GL.TEXTURE_WRAP_R, w);
					gl.texParameteri(mode, GL.TEXTURE_BASE_LEVEL, startingMip);
					#if !js
					gl.texParameterf(mode, GL.TEXTURE_LOD_BIAS, t.lodBias);
					#end
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
			var mi = m >> 4;
			if ( mi > 0 ) {
				#if (hl && hl_ver >= version("1.14.0"))
				var i = 1;
				do {
					if ( mi & 15 > 0 ) {
						gl.colorMaski(i, mi & 1 != 0, mi & 2 != 0, mi & 4 != 0, mi & 8 != 0);
					}
					mi = mi >> 4;
					i++;
				} while ( mi > 0 );
				#else
				throw "GL ColorMaski support requires hlsdl 1.14+";
				#end
			}
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

		var fallback = true;
		#if (js && haxe_ver >= 5)
		var extension:js.html.webgl.extension.WEBGLPolygonMode =  cast gl.getExtension("WEBGL_polygon_mode");
		if(extension != null) {
			if(wireframe) {
				extension.polygonModeWEBGL(GL.FRONT_AND_BACK, js.html.webgl.extension.WEBGLPolygonMode.LINE_WEBGL);
			} else {
				extension.polygonModeWEBGL(GL.FRONT_AND_BACK, js.html.webgl.extension.WEBGLPolygonMode.FILL_WEBGL);
			}
			fallback = false;
		}
		#end

		if(fallback) {
			drawMode = wireframe ? GL.LINE_STRIP : GL.TRIANGLES;
		}
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

		#if !js
		if ( (!useDepthClamp && diff & Pass.depthClamp_mask != 0) ) {
			if ( Pass.getDepthClamp(bits) != 0 )
				gl.enable(GL.DEPTH_CLAMP);
			else
				gl.disable(GL.DEPTH_CLAMP);
		}
		#end

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

	override function clear( ?color : h3d.Vector4, ?depth : Float, ?stencil : Int ) {
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
			// reset stencil mask when we allow to change it
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
			defaultDepth.t = allocDepthBuffer(defaultDepth);
		}
	}

	function getChannels( t : Texture ) {
		return switch( t.internalFmt ) {
		case GL.RGBA32F, GL.RGBA16F: GL.RGBA;
		#if !js
		case GL.SRGB_ALPHA, GL.SRGB8_ALPHA: GL.RGBA;
		case GL.RGBA8: GL.BGRA;
		#end
		case GL.SRGB, GL.SRGB8: GL.RGB;
		case GL.RGBA: GL.RGBA;
		case GL.RGB: GL.RGB;
		case GL.R11F_G11F_B10F: GL.RGB;
		case GL.RGB10_A2: GL.RGBA;
		case GL.RED, GL.R8, GL.R16F, GL.R32F, 0x822A: GL.RED;
		case GL.RG, GL.RG8, GL.RG16F, GL.RG32F, 0x822C: GL.RG;
		case GL.RGB16F, GL.RGB32F, 0x8054, 0x8E8F: GL.RGB;
		case 0x83F1, 0x83F2, 0x83F3, 0x805B, 0x8E8C: GL.RGBA;
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
		if ( t.flags.has(Is3D) )
			return GL.TEXTURE_3D;
		var isArray = t.flags.has(IsArray);
		if( t.flags.has(Cube) )
			return #if (hlsdl > version("1.15.0")) isArray ? GL.TEXTURE_CUBE_MAP_ARRAY : #end GL.TEXTURE_CUBE_MAP;
		return isArray ? GL.TEXTURE_2D_ARRAY : GL.TEXTURE_2D;
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		discardError();
		var tt = gl.createTexture();
		var bind = getBindType(t);
		var tt : Texture = { t : tt, width : t.width, height : t.height, internalFmt : GL.RGBA, pixelFmt : GL.UNSIGNED_BYTE, bits : -1, bind : bind #if multidriver, driver : this #end };
		switch( t.format ) {
		case RGBA:
			// default
		case RGBA32F if( hasFeature(FloatTextures) ):
			tt.internalFmt = GL.RGBA32F;
			tt.pixelFmt = GL.FLOAT;
		case RGBA16F if( hasFeature(FloatTextures) ):
			tt.pixelFmt = GL.HALF_FLOAT;
			tt.internalFmt = GL.RGBA16F;
		case BGRA:
			tt.internalFmt = GL.RGBA8;
		case SRGB:
			tt.internalFmt = GL.SRGB8;
		#if !js
		case SRGB_ALPHA:
			tt.internalFmt = GL.SRGB8_ALPHA;
		#end
		case RGB8:
			tt.internalFmt = GL.RGB;
		case R8:
			tt.internalFmt = GL.R8;
		case RG8:
			tt.internalFmt = GL.RG8;
		case R16F:
			tt.internalFmt = GL.R16F;
			tt.pixelFmt = GL.HALF_FLOAT;
		case RG16F:
			tt.internalFmt = GL.RG16F;
			tt.pixelFmt = GL.HALF_FLOAT;
		case R16U:
			tt.internalFmt = 0x822A; // GL.R16
			tt.pixelFmt = GL.UNSIGNED_SHORT;
		case RG16U:
			tt.internalFmt = 0x822C; // GL.RG16
			tt.pixelFmt = GL.UNSIGNED_SHORT;
		case RGB16U:
			tt.internalFmt = 0x8054; // GL.RGB16
			tt.pixelFmt = GL.UNSIGNED_SHORT;
		case RGBA16U:
			tt.internalFmt = 0x805B; // GL.RGBA16
			tt.pixelFmt = GL.UNSIGNED_SHORT;
		case R32F:
			tt.internalFmt = GL.R32F;
			tt.pixelFmt = GL.FLOAT;
		case RG32F:
			tt.internalFmt = GL.RG32F;
			tt.pixelFmt = GL.FLOAT;
		case RGB16F:
			tt.internalFmt = GL.RGB16F;
			tt.pixelFmt = GL.HALF_FLOAT;
		case RGB32F:
			tt.internalFmt = GL.RGB32F;
			tt.pixelFmt = GL.FLOAT;
		case RGB10A2:
			tt.internalFmt = GL.RGB10_A2;
			tt.pixelFmt = GL.UNSIGNED_INT_2_10_10_10_REV;
		case RG11B10UF:
			tt.internalFmt = GL.R11F_G11F_B10F;
			tt.pixelFmt = GL.UNSIGNED_INT_10F_11F_11F_REV;
		case S3TC(n) if( n <= maxCompressedTexturesSupport ):
			if( t.width&3 != 0 || t.height&3 != 0 )
				throw "Compressed texture "+t+" has size "+t.width+"x"+t.height+" - must be a multiple of 4";
			switch( n ) {
			case 1: tt.internalFmt = 0x83F1; // COMPRESSED_RGBA_S3TC_DXT1_EXT
			case 2:	tt.internalFmt = 0x83F2; // COMPRESSED_RGBA_S3TC_DXT3_EXT
			case 3: tt.internalFmt = 0x83F3; // COMPRESSED_RGBA_S3TC_DXT5_EXT
			case 6: tt.internalFmt = 0x8E8F; // COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT
			case 7: tt.internalFmt = 0x8E8C; // COMPRESSED_RGBA_BPTC_UNORM
			default: throw "Unsupported texture format "+t.format;
			}
		default:
			throw "Unsupported texture format "+t.format;
		}

		#if js
		if( tt.pixelFmt == GL.UNSIGNED_SHORT && !has16Bits )
			throw "16 bit textures requires EXT_texture_norm16 extension";
		#end

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

		#if (js || (hlsdl >= version("1.12.0")))
		gl.texParameteri(bind, GL.TEXTURE_BASE_LEVEL, t.startingMip);
		gl.texParameteri(bind, GL.TEXTURE_MAX_LEVEL, t.mipLevels-1);
		#end

		#if js
		// Modern texture allocation that supports both compressed and uncompressed texture in WebGL
		// texStorate2D/3D is only defined in OpenGL 4.2 but is defined in openGL ES 3 which the js target targets

		// Patch RGBA to be RGBA8 because texStorage expect a "Sized Internal Format"
		var sizedFormat = tt.internalFmt == GL.RGBA ? GL.RGBA8 : tt.internalFmt;
		if( ( t.flags.has(IsArray) || t.flags.has(Is3D) ) && !t.flags.has(Cube) ) {
			gl.texStorage3D(bind, t.mipLevels, sizedFormat, tt.width, tt.height, t.layerCount);
			checkError();
		} else {
			gl.texStorage2D(bind, t.mipLevels, sizedFormat, tt.width, tt.height);
			checkError();
		}
		#else
		for(mip in 0...t.mipLevels) {
			var w = hxd.Math.imax(1, tt.width >> mip);
			var h = hxd.Math.imax(1, tt.height >> mip);
			var d = hxd.Math.imax(1, t.layerCount >> mip);
			if( t.flags.has(Cube) ) {
				for( i in 0...6 ) {
					gl.texImage2D(CUBE_FACES[i], mip, tt.internalFmt, w, h, 0, getChannels(tt), tt.pixelFmt, null);
					if( checkError() ) break;
				}
			} else if( t.flags.has(IsArray) ) {
				gl.texImage3D(bind, mip, tt.internalFmt, w, h, t.layerCount, 0, getChannels(tt), tt.pixelFmt, null);
				checkError();
			} else if ( t.flags.has(Is3D) ) {
				gl.texImage3D(bind, mip, tt.internalFmt, w, h, d, 0, getChannels(tt), tt.pixelFmt, null);
				checkError();
			} else {
				gl.texImage2D(bind, mip, tt.internalFmt, w, h, 0, getChannels(tt), tt.pixelFmt, null);
				checkError();
			}
		}
		#end

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

	override function allocDepthBuffer( t : h3d.mat.Texture ) : Texture {
		var tt = gl.createTexture();
		var tt : Texture = { t : tt, width : t.width, height : t.height, internalFmt : GL.RGBA, pixelFmt : GL.UNSIGNED_BYTE, bits : -1, bind : GL.TEXTURE_2D #if multidriver, driver : this #end };
		var fmt = GL.DEPTH_COMPONENT;
		switch( t.format ) {
		case Depth16:
			tt.internalFmt = GL.DEPTH_COMPONENT16;
		case Depth24 #if js if( glES >= 3 ) #end: tt.internalFmt = GL.DEPTH_COMPONENT;
		case Depth24Stencil8:
			tt.internalFmt = GL.DEPTH24_STENCIL8;
			tt.pixelFmt = GL.UNSIGNED_INT_24_8;
			fmt = GL.DEPTH_STENCIL;
		case Depth32:
			tt.internalFmt = GL.DEPTH_COMPONENT32F;
			tt.pixelFmt = GL.FLOAT;
		default:
			throw "Unsupported depth format "+	t.format;
		}
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		gl.bindTexture(tt.bind, tt.t);

		#if (js || (hlsdl >= version("1.12.0")))
		gl.texParameteri(tt.bind, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
		gl.texParameteri(tt.bind, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		gl.texParameteri(tt.bind, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		gl.texParameteri(tt.bind, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		#end
		gl.texImage2D(tt.bind, 0, tt.internalFmt, tt.width, tt.height, 0, fmt, tt.pixelFmt, null);

		restoreBind();
		return tt;
	}

	override function disposeDepthBuffer( b : h3d.mat.Texture ) {
		@:privateAccess if( b.t != null && b.t.t != null ) {
			gl.deleteTexture(b.t.t);
			b.t = null;
		}
	}

	var defaultDepth : h3d.mat.Texture;

	override function getDefaultDepthBuffer() : h3d.mat.Texture {
		// Unfortunately there is no way to bind the depth buffer of the default frame buffer to a frame buffer object.
		if( defaultDepth != null )
			return defaultDepth;
		defaultDepth = new h3d.mat.Texture(0, 0, Depth24Stencil8);
		defaultDepth.name = "defaultDepthBuffer";
		@:privateAccess {
			defaultDepth.width = this.bufferWidth;
			defaultDepth.height = this.bufferHeight;
			defaultDepth.t = allocDepthBuffer(defaultDepth);
		}
		return defaultDepth;
	}

	inline function discardError() {
		if( outOfMemoryCheck ) gl.getError(); // make sure to reset error flag
	}

	override function allocBuffer( b : h3d.Buffer ) : GPUBuffer {
		discardError();
		var vb = gl.createBuffer();
		var type = b.flags.has(IndexBuffer) ? GL.ELEMENT_ARRAY_BUFFER : GL.ARRAY_BUFFER;
		gl.bindBuffer(type, vb);
		if( b.vertices * b.format.stride == 0 ) throw "assert";
		#if js
		var size = b.getMemSize();
		if ( b.flags.has(UniformBuffer) )
			hxd.Math.imin(1024, size);
		gl.bufferData(type, size, b.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#elseif hl
		gl.bufferDataSize(type, b.getMemSize(), b.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#else
		var tmp = new Uint8Array(b.getMemSize());
		gl.bufferData(type, tmp, b.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#end
		#if multidriver
		@:privateAccess if( b.engine.driver != this )
			throw "Invalid buffer context";
		#end
		var outOfMem = outOfMemoryCheck && gl.getError() == GL.OUT_OF_MEMORY;
		gl.bindBuffer(type, null);
		if( b.flags.has(IndexBuffer) )
			curIndexBuffer = null;
		if( outOfMem ) {
			gl.deleteBuffer(vb);
			return null;
		}
		return vb;
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

	override function disposeBuffer( b : h3d.Buffer ) {
		gl.deleteBuffer(b.vbuf);
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
		if( t.format != RGBA || t.layerCount != 1 ) {
			var pixels = bmp.getPixels();
			uploadTexturePixels(t, pixels, mipLevel, side);
			pixels.dispose();
		} else {
			var img = bmp.toNative();
			gl.bindTexture(GL.TEXTURE_2D, t.t.t);
			gl.texSubImage2D(GL.TEXTURE_2D, mipLevel, 0, 0, getChannels(t.t), t.t.pixelFmt, img.getImageData(0, 0, bmp.width, bmp.height));
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
		var face = GL.TEXTURE_2D;
		if ( cubic )
			face = CUBE_FACES[side];
		if ( t.flags.has(IsArray) )
			face = GL.TEXTURE_2D_ARRAY
		else if ( t.flags.has(Is3D) )
			face = GL.TEXTURE_3D;
		var bind = getBindType(t);
		gl.bindTexture(bind, t.t.t);
		pixels.convert(t.format);
		var dataLen = pixels.dataSize;
		#if hl
		var stream = streamData(pixels.bytes.getData(),pixels.offset,dataLen);
		if( t.format.match(S3TC(_)) ) {
			if( t.flags.has(IsArray) || t.flags.has(Is3D) )
				#if (hlsdl >= version("1.12.0"))
				gl.compressedTexSubImage3D(face, mipLevel, 0, 0, side, pixels.width, pixels.height, 1, t.t.internalFmt, dataLen, stream);
				#else throw "TextureArray support requires hlsdl 1.12+"; #end
			else
				gl.compressedTexImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, dataLen, stream);
		} else {
			if( t.flags.has(IsArray) || t.flags.has(Is3D) )
				#if (hlsdl >= version("1.12.0"))
				gl.texSubImage3D(face, mipLevel, 0, 0, side, pixels.width, pixels.height, 1, getChannels(t.t), t.t.pixelFmt, stream);
				#else throw "TextureArray support requires hlsdl 1.12+"; #end
			else
				gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, stream);
		}
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
		case RGBA16F, R16F, RG16F, RGB16F, RGBA16U, R16U, RG16U, RGB16U: new Uint16Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen>>1);
		case RGB10A2, RG11B10UF: new Uint32Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen>>2);
		default: new Uint8Array(@:privateAccess pixels.bytes.b.buffer, pixels.offset, dataLen);
		}
		if( t.format.match(S3TC(_)) ) {
			if( t.flags.has(IsArray) || t.flags.has(Is3D) )
				gl.compressedTexSubImage3D(face, mipLevel, 0, 0, side, pixels.width, pixels.height, 1, t.t.internalFmt, buffer);
			else
				gl.compressedTexSubImage2D(face, mipLevel, 0, 0, pixels.width, pixels.height, t.t.internalFmt, buffer);
		} else {
			if( t.flags.has(IsArray) || t.flags.has(Is3D) )
				gl.texSubImage3D(face, mipLevel, 0, 0, side, pixels.width, pixels.height, 1, getChannels(t.t), t.t.pixelFmt, buffer);
			else
				gl.texSubImage2D(face, mipLevel, 0, 0, pixels.width, pixels.height, getChannels(t.t), t.t.pixelFmt, buffer);
		}
		#else
		throw "Not implemented";
		#end
		t.flags.set(WasCleared);
		restoreBind();
	}

	override function uploadBufferData( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride = b.format.strideBytes;
		gl.bindBuffer(GL.ARRAY_BUFFER, b.vbuf);
		#if hl
		var data = #if hl hl.Bytes.getArray(buf.getNative()) #else buf.getNative() #end;
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride, streamData(data,bufPos * 4,vertexCount * stride), bufPos * 4 * STREAM_POS, vertexCount * stride);
		#else
		var buf : Float32Array = buf.getNative();
		var sub = new Float32Array(buf.buffer, bufPos * 4, (vertexCount * stride) >> 2);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadBufferBytes( b : h3d.Buffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride = b.format.strideBytes;
		var type = b.flags.has(IndexBuffer) ? GL.ELEMENT_ARRAY_BUFFER : GL.ARRAY_BUFFER;
		gl.bindBuffer(type, b.vbuf);
		#if hl
		gl.bufferSubData(type, startVertex * stride, streamData(buf.getData(),bufPos,vertexCount * stride), bufPos * STREAM_POS, vertexCount * stride);
		#else
		var sub = new Uint8Array(buf.getData(), bufPos, vertexCount * stride);
		gl.bufferSubData(type, startVertex * stride, sub);
		#end
		gl.bindBuffer(type, null);
		if( b.flags.has(IndexBuffer) ) curIndexBuffer = null;
	}

	override function readBufferBytes(b:h3d.Buffer, startVertex:Int, vertexCount:Int, buf:haxe.io.Bytes, bufPos:Int) {
		var stride = b.format.strideBytes;
		var totalSize = vertexCount*stride;
		var type = b.flags.has(IndexBuffer) ? GL.ELEMENT_ARRAY_BUFFER : GL.ARRAY_BUFFER;
		gl.bindBuffer(type, b.vbuf);
		gl.getBufferSubData(type, startVertex*stride, @:privateAccess buf.b, bufPos*STREAM_POS, totalSize);
		gl.bindBuffer(type, null);
	}

	override function uploadIndexData( i : h3d.Buffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var bits = i.format.strideBytes >> 1;
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i.vbuf);
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

	inline function updateDivisor( a : CompiledAttribute ) {
		if( currentDivisor[a.index] != a.divisor ) {
			currentDivisor[a.index] = a.divisor;
			gl.vertexAttribDivisor(a.index, a.divisor);
		}
	}

	override function selectBuffer( b : h3d.Buffer ) {
		if( b == curBuffer )
			return;

		if( curShader == null )
			throw "No shader selected";
		#if multidriver
		if( @:privateAccess b.engine.driver != this )
			throw "Invalid buffer context";
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, b.vbuf);
		curBuffer = b;

		var strideBytes = b.format.strideBytes;
		var map = b.format.resolveMapping(curShader.format);
		for( i => a in curShader.attribs ) {
			var inf = map[i];
			var norm = false;
			gl.vertexAttribPointer(a.index, a.size, switch( inf.precision ) {
				case F32: a.type;
				case F16: GL.HALF_FLOAT;
				case S8: norm = true; GL.BYTE;
				case U8: norm = true; GL.UNSIGNED_BYTE;
			}, norm, strideBytes, inf.offset);
			updateDivisor(a);
		}
	}

	override function selectMultiBuffers( format : hxd.BufferFormat.MultiFormat, buffers : Array<h3d.Buffer> ) {
		var map = format.resolveMapping(curShader.format);
		for( i => a in curShader.attribs ) {
			var inf = map[i];
			var b = buffers[inf.bufferIndex];
			if( curBuffer != b ) {
				gl.bindBuffer(GL.ARRAY_BUFFER, b.vbuf);
				curBuffer = b;
			}
			var norm = false;
			gl.vertexAttribPointer(a.index, a.size, switch( inf.precision ) {
			case F32: a.type;
			case F16: GL.HALF_FLOAT;
			case S8: norm = true; GL.BYTE;
			case U8: norm = true; GL.UNSIGNED_BYTE;
			}, norm, b.format.strideBytes, inf.offset);
			updateDivisor(a);
		}
	}

	override function draw( ibuf : h3d.Buffer, startIndex : Int, ntriangles : Int ) {
		if( ibuf != curIndexBuffer ) {
			curIndexBuffer = ibuf;
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf.vbuf);
		}
		if( ibuf.format.strideBytes == 4 )
			gl.drawElements(drawMode, ntriangles * 3, GL.UNSIGNED_INT, startIndex * 4);
		else
			gl.drawElements(drawMode, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
	}

	override function allocInstanceBuffer( b : InstanceBuffer, bytes : haxe.io.Bytes ) {
		#if hl
		if( hasMultiIndirect ) {
			var buf = gl.createBuffer();
			gl.bindBuffer(GL.DRAW_INDIRECT_BUFFER, buf);
			gl.bufferData(GL.DRAW_INDIRECT_BUFFER, b.commandCount * 20, streamData(bytes.getData(),0, b.commandCount * 20), GL.DYNAMIC_DRAW);
			gl.bindBuffer(GL.DRAW_INDIRECT_BUFFER, null);
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
		b.cpuData = data;
	}

	override function uploadInstanceBufferBytes(b : InstanceBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride = 5*4;
		#if hl
		var type = GL.DRAW_INDIRECT_BUFFER;
		gl.bindBuffer(type, b.data);
		gl.bufferSubData(type, startVertex * stride, streamData(buf.getData(),bufPos,vertexCount * stride), bufPos * STREAM_POS, vertexCount * stride);
		#else
		var type = GL.ARRAY_BUFFER;
	 	var sub = new Uint8Array(buf.getData(), bufPos, vertexCount * stride);
	 	gl.bufferSubData(type, startVertex * stride, sub);
		#end
		gl.bindBuffer(type, null);
	}

	override function disposeInstanceBuffer(b:InstanceBuffer) {
		b.data = null;
	}

	override function drawInstanced( ibuf : h3d.Buffer, commands : InstanceBuffer ) {
		if( ibuf != curIndexBuffer ) {
			curIndexBuffer = ibuf;
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf.vbuf);
		}
		var kind, size;
		if( ibuf.format.strideBytes == 4 ) {
			kind = GL.UNSIGNED_INT;
			size = 4;
		} else {
			kind = GL.UNSIGNED_SHORT;
			size = 2;
		}
		#if !js
		if( hasMultiIndirect && commands.data != null ) {
			#if (haxe_ver < 5)
				var arr = new hl.NativeArray<Int>(1);
				arr[0] = commands.offset * InstanceBuffer.ELEMENT_SIZE;
				var commandOffset : hl.Bytes = (cast arr : hl.NativeArray<hl.Bytes>)[0];
			#else
				var commandOffset : hl.Bytes = hl.Api.unsafeCast(haxe.Int64.make(0, commands.offset * InstanceBuffer.ELEMENT_SIZE));
			#end
			gl.bindBuffer(GL.DRAW_INDIRECT_BUFFER, commands.data);
			#if (hlsdl >= version("1.15.0"))
			if ( commands.countBuffer != null && hasMultiIndirectCount ) {
				#if (haxe_ver < 5)
					var arr = new hl.NativeArray<Int>(1);
					arr[0] = commands.countOffset * 4;
					var countOffset : hl.Bytes = (cast arr : hl.NativeArray<hl.Bytes>)[0];
				#else
					var countOffset : hl.Bytes = hl.Api.unsafeCast(haxe.Int64.make(0, commands.countOffset * 4));
				#end
				gl.bindBuffer(GL.PARAMETER_BUFFER, commands.countBuffer);
				gl.multiDrawElementsIndirectCount(drawMode, kind, commandOffset, countOffset, commands.commandCount, 0);
			} else
			#end
			gl.multiDrawElementsIndirect(drawMode, kind, commandOffset, commands.commandCount, 0);
			gl.bindBuffer(GL.DRAW_INDIRECT_BUFFER, null);
			return;
		}
		#end
		var args : Array<Int> = commands.cpuData;
		if( args != null ) {
			var p = 0;
			for( i in 0...Std.int(args.length/3) )
				gl.drawElementsInstanced(drawMode, args[p++], kind, args[p++]*size, args[p++]);
		} else
			gl.drawElementsInstanced(drawMode, commands.indexCount, kind, commands.startIndex*size, commands.commandCount);
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

	override function setRenderTarget( tex : h3d.mat.Texture, layer = 0, mipLevel = 0, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
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

		if( tex.flags.has(IsArray) || tex.flags.has(Is3D) )
			gl.framebufferTextureLayer(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, tex.t.t, mipLevel, layer);
		else
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, tex.flags.has(Cube) ? CUBE_FACES[layer] : GL.TEXTURE_2D, tex.t.t, mipLevel);

		if( tex.depthBuffer != null && depthBinding != NotBound ) {
			// Depthbuffer and stencilbuffer are combined in one buffer, created with GL.DEPTH_STENCIL
			if(tex.depthBuffer.hasStencil() && tex.depthBuffer.format == Depth24Stencil8) {
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.TEXTURE_2D,@:privateAccess tex.depthBuffer.t.t, 0);
			} else {
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.TEXTURE_2D,null,0);
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.TEXTURE_2D, @:privateAccess tex.depthBuffer.t.t,0);
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.TEXTURE_2D,tex.depthBuffer.hasStencil() ? @:privateAccess tex.depthBuffer.t.t : null,0);
			}
		} else {
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.TEXTURE_2D,null,0);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.TEXTURE_2D, null,0);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.TEXTURE_2D, null,0);
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

	override function setRenderTargets( textures : Array<h3d.mat.Texture>, depthBinding : h3d.Engine.DepthBinding = ReadWrite ) {
		unbindTargets();
		setRenderTarget(textures[0], depthBinding);
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

	override function setDepth( depthBuffer : h3d.mat.Texture ) {
		unbindTargets();
		curTarget = depthBuffer;

		depthBuffer.lastFrame = frame;
		curTargetLayer = 0;
		curTargetMip = 0;
		#if multidriver
		if( depthBuffer.t.driver != this )
			throw "Invalid texture context";
		#end
		gl.bindFramebuffer(GL.FRAMEBUFFER, commonFB);

		gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, null, 0);

		if(depthBuffer.hasStencil() && depthBuffer.format == Depth24Stencil8) {
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.TEXTURE_2D,@:privateAccess depthBuffer.t.t, 0);
		} else {
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.TEXTURE_2D,null,0);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.TEXTURE_2D, @:privateAccess depthBuffer.t.t,0);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.TEXTURE_2D,depthBuffer.hasStencil() ? @:privateAccess depthBuffer.t.t : null,0);
		}

		var w = depthBuffer.width; if( w == 0 ) w = 1;
		var h = depthBuffer.height; if( h == 0 ) h = 1;
		gl.viewport(0, 0, w, h);
		for( i in 0...boundTextures.length )
			boundTextures[i] = null;

		#if js
		if( glDebug ) {
			var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);
			if( code != GL.FRAMEBUFFER_COMPLETE )
				throw "Invalid frame buffer: "+code;
		}
		#end
	}

	override function setDepthClamp( enabled : Bool ) {
		#if !js
		useDepthClamp = enabled;
		if ( useDepthClamp )
			gl.enable(GL.DEPTH_CLAMP);
		else
			gl.disable(GL.DEPTH_CLAMP);
		#end
	}

	override function setDepthBias( depthBias : Float, slopeScaledBias : Float ) {
		if ( depthBias != 0 || slopeScaledBias != 0 ) {
			gl.enable(GL.POLYGON_OFFSET_FILL);
			gl.polygonOffset(slopeScaledBias, depthBias);
		} else
			gl.disable(GL.POLYGON_OFFSET_FILL);
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		#if js
		// wait until all assets have properly load
		if( js.Browser.document.readyState == 'complete' )
			haxe.Timer.delay(onCreate.bind(false), 1);
		else {
			function onLoad() {
				js.Browser.window.removeEventListener("load", onLoad);
				onCreate(false);
			}
			js.Browser.window.addEventListener("load", onLoad);
		}
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
	var has16Bits : Bool;
	function makeFeatures() {
		for( f in Type.allEnums(Feature) )
			features.set(f,checkFeature(f));
		if( gl.getExtension("WEBGL_compressed_texture_s3tc") != null ) {
			maxCompressedTexturesSupport = 3;
			if( gl.getExtension("EXT_texture_compression_bptc") != null )
				maxCompressedTexturesSupport = 7;
		}
		if( glES < 3 )
			gl.getExtension("WEBGL_depth_texture");
		has16Bits = gl.getExtension("EXT_texture_norm16") != null; // 16 bit textures
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
		gl.texSubImage2D(face, mipLevel, 0, 0, v.videoWidth, v.videoHeight, getChannels(t.t), t.t.pixelFmt, untyped v);
		restoreBind();
	}

	#end

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		captureSubRenderBuffer(pixels, 0, 0);
	}

	function captureSubRenderBuffer( pixels : hxd.Pixels, x : Int, y : Int ) {
		if( curTarget == null )
			throw "Can't capture main render buffer in GL";
		gl.getError(); // always discard
		#if js
		var buffer : ArrayBufferView = @:privateAccess pixels.bytes.b;
		switch( curTarget.format ) {
		case RGBA32F, R32F, RG32F, RGB32F: buffer = new Float32Array(buffer.buffer);
		case RGBA16F, R16F, RG16F, RGB16F, RGBA16U, R16U, RG16U, RGB16U: buffer = new Uint16Array(buffer.buffer);
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

	override function computeDispatch(x:Int = 1, y:Int = 1, z:Int = 1, barrier:Bool = true) {
		GL.dispatchCompute(x,y,z);
		if( barrier )
			memoryBarrier();
	}

	override function memoryBarrier(){
		GL.memoryBarrier(GL.BUFFER_UPDATE_BARRIER_BIT | GL.TEXTURE_FETCH_BARRIER_BIT);
	}

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
		case TimeElapsed:
			GL.beginQuery(GL.TIME_ELAPSED, q.q);
		}
	}

	override function endQuery( q : Query ) {
		switch( q.kind ) {
		case TimeStamp:
			GL.queryCounter(q.q, GL.TIMESTAMP);
		case Samples:
			GL.endQuery(GL.SAMPLES_PASSED);
		case TimeElapsed:
			GL.endQuery(GL.TIME_ELAPSED);
		}
	}

	override function queryResultAvailable(q:Query) {
		return GL.queryResultAvailable(q.q);
	}

	override function queryResult(q:Query) {
		return GL.queryResult(q.q);
	}

	inline function debugCheckError() {
		if(!debug) return;
		var err = gl.getError();
		if(err != GL.NO_ERROR) {
			switch(err) {
				case GL.INVALID_ENUM: throw "INVALID_ENUM";
				case GL.INVALID_VALUE: throw "INVALID_VALUE";
				case GL.INVALID_OPERATION: throw "INVALID_OPERATION";
				case 1286: throw "INVALID_FRAMEBUFFER_OPERATION";
				default: throw "Error: " + err;
			}
		}
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
		GL.MIRRORED_REPEAT,
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
		#if js GL.MIN #else GL.FUNC_MIN #end,
		#if js GL.MAX #else GL.FUNC_MAX #end,
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
