package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;

#if (js||cpp)

#if js
import js.html.Uint16Array;
import js.html.Uint8Array;
import js.html.Float32Array;
private typedef GL = js.html.webgl.GL;
private typedef Uniform = js.html.webgl.UniformLocation;
private typedef Program = js.html.webgl.Program;
private typedef GLShader = js.html.webgl.Shader;
#elseif lime
import lime.graphics.opengl.GL;
private typedef Uniform = Dynamic;
private typedef Program = lime.graphics.opengl.GLProgram;
private typedef GLShader = lime.graphics.opengl.GLShader;
private typedef Uint16Array = lime.utils.UInt16Array;
private typedef Uint8Array = lime.utils.UInt8Array;
private typedef Float32Array = lime.utils.Float32Array;
#elseif nme
import nme.gl.GL;
private typedef Uniform = Dynamic;
private typedef Program = nme.gl.GLProgram;
private typedef GLShader = nme.gl.GLShader;
private typedef Uint16Array = nme.utils.Int16Array;
private typedef Uint8Array = nme.utils.UInt8Array;
private typedef Float32Array = nme.utils.Float32Array;
#elseif hxsdl
import sdl.GL;
private typedef Uniform = sdl.GL.Uniform;
private typedef Program = sdl.GL.Program;
private typedef GLShader = sdl.GL.Shader;
private typedef Texture = h3d.impl.Driver.Texture;
#end

private class CompiledShader {
	public var s : GLShader;
	public var vertex : Bool;
	public var globals : Uniform;
	public var params : Uniform;
	public var textures : Array<Uniform>;
	public var shader : hxsl.RuntimeShader.RuntimeShaderData;
	public function new(s,vertex,shader) {
		this.s = s;
		this.vertex = vertex;
		this.shader = shader;
	}
}

private class CompiledProgram {
	public var p : Program;
	public var vertex : CompiledShader;
	public var fragment : CompiledShader;
	public var stride : Int;
	public var attribNames : Array<String>;
	public var attribs : Array<{ index : Int, type : Int, size : Int, offset : Int }>;
	public function new() {
	}
}

@:access(h3d.impl.Shader)
#if cpp
@:build(h3d.impl.MacroHelper.replaceGL())
#end
class GlDriver extends Driver {

	#if js
	var canvas : js.html.CanvasElement;
	public var gl : js.html.webgl.RenderingContext;
	#elseif cpp
	var fixMult : Bool;
	#end

	var curAttribs : Int;
	var curShader : CompiledProgram;
	var curBuffer : h3d.Buffer;
	var curMatBits : Int;
	var programs : Map<Int, CompiledProgram>;
	var frame : Int;

	var bufferWidth : Int;
	var bufferHeight : Int;
	var curTarget : h3d.mat.Texture;

	public function new() {
		#if js
		canvas = @:privateAccess hxd.Stage.getCanvas();
		if( canvas == null ) throw "Canvas #webgl not found";
		gl = canvas.getContextWebGL({alpha:false});
		if( gl == null ) throw "Could not acquire GL context";
		// debug if webgl_debug.js is included
		untyped if( __js__('typeof')(WebGLDebugUtils) != "undefined" ) gl = untyped WebGLDebugUtils.makeDebugContext(gl);
		#elseif (nme || openfl)
		// check for a bug in HxCPP handling of sub buffers
		var tmp = new Float32Array(8);
		var sub = new Float32Array(tmp.buffer, 0, 4);
		fixMult = sub.length == 1; // should be 4
		#end
		programs = new Map();
		curAttribs = 0;
		curMatBits = -1;
		#if js
		gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);
		#end
	}

	override function logImpl( str : String ) {
		#if js
		untyped console.log(str);
		#else
		Sys.println(str);
		#end
	}

	override function begin(frame) {
		this.frame = frame;
		#if cpp
		curAttribs = 0;
		curMatBits = -1;
		#end
		gl.useProgram(null);
		curShader = null;
		curBuffer = null;
	}

	override function getShaderInputNames() {
		return curShader.attribNames;
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var glout = new hxsl.GlslOut();
		return "// vertex:\n" + glout.run(shader.vertex.data) + "// fragment:\n" + glout.run(shader.fragment.data);
	}

	function compileShader( glout : hxsl.GlslOut, shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var type = shader.vertex ? GL.VERTEX_SHADER : GL.FRAGMENT_SHADER;
		var s = gl.createShader(type);
		var code = glout.run(shader.data);
		gl.shaderSource(s, code);
		gl.compileShader(s);
		if ( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
			var log = gl.getShaderInfoLog(s);
			var lid = Std.parseInt(log.substr(9));
			var line = lid == null ? null : code.split("\n")[lid - 1];
			if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
			throw "An error occurred compiling the shaders: " + log + line+"\n\n"+code;
		}
		return new CompiledShader(s, shader.vertex, shader);
	}

	function initShader( p : CompiledProgram, s : CompiledShader, shader : hxsl.RuntimeShader.RuntimeShaderData ) {
		var prefix = s.vertex ? "vertex" : "fragment";
		s.globals = gl.getUniformLocation(p.p, prefix + "Globals");
		s.params = gl.getUniformLocation(p.p, prefix + "Params");
		s.textures = [for( i in 0...shader.textures2DCount ) gl.getUniformLocation(p.p, prefix + "Textures[" + i + "]")];
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var p = programs.get(shader.id);
		if( p == null ) {
			p = new CompiledProgram();
			var glout = new hxsl.GlslOut();
			p.vertex = compileShader(glout,shader.vertex);
			p.fragment = compileShader(glout,shader.fragment);
			p.p = gl.createProgram();
			gl.attachShader(p.p, p.vertex.s);
			gl.attachShader(p.p, p.fragment.s);
			gl.linkProgram(p.p);
			gl.deleteShader(p.vertex.s);
			gl.deleteShader(p.fragment.s);
			if( gl.getProgramParameter(p.p, GL.LINK_STATUS) != cast 1 ) {
				var log = gl.getProgramInfoLog(p.p);
				throw "Program linkage failure: "+log;
			}
			initShader(p, p.vertex, shader.vertex);
			initShader(p, p.fragment, shader.fragment);
			p.attribNames = [];
			p.attribs = [];
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
					var index = gl.getAttribLocation(p.p, glout.varNames.get(v.id));
					if( index < 0 ) continue;
					p.attribs.push( { offset : p.stride, index : index, size:size, type:t } );
					p.attribNames.push(v.name);
					p.stride += size;
				default:
				}
			programs.set(shader.id, p);
		}
		if( curShader == p ) return false;

		gl.useProgram(p.p);
		for( i in curAttribs...p.attribs.length ) {
			gl.enableVertexAttribArray(i);
			curAttribs++;
		}
		while( curAttribs > p.attribs.length )
			gl.disableVertexAttribArray(--curAttribs);
		curShader = p;
		curBuffer = null;
		return true;
	}

	override function uploadShaderBuffers( buf : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		uploadBuffer(curShader.vertex, buf.vertex, which);
		uploadBuffer(curShader.fragment, buf.fragment, which);
	}

	function uploadBuffer( s : CompiledShader, buf : h3d.shader.Buffers.ShaderBuffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
			if( s.globals != null ) {
				#if hxsdl
				gl.uniform4fv(s.globals, buf.globals.toData(), 0, s.shader.globalsSize);
				#else
				var a = new Float32Array(buf.globals.toData()).subarray(0, s.shader.globalsSize * 4);
				gl.uniform4fv(s.globals, a);
				#end
			}
		case Params:
			if( s.params != null ) {
				#if hxsdl
				gl.uniform4fv(s.params, buf.params.toData(), 0, s.shader.paramsSize);
				#else
				var a = new Float32Array(buf.params.toData()).subarray(0, s.shader.paramsSize * 4);
				gl.uniform4fv(s.params, a);
				#end
			}
		case Textures:
			for( i in 0...s.textures.length ) {
				var t = buf.tex[i];
				if( t == null || t.isDisposed() )
					t = h3d.mat.Texture.fromColor(loadingTextureColor,(loadingTextureColor>>>24)/255);
				if( t != null && t.t == null && t.realloc != null ) {
					t.alloc();
					t.realloc();
				}
				t.lastFrame = frame;

				gl.activeTexture(GL.TEXTURE0 + i);
				gl.uniform1i(s.textures[i], i);

				gl.bindTexture(GL.TEXTURE_2D, t.t.t);
				var flags = TFILTERS[Type.enumIndex(t.mipMap)][Type.enumIndex(t.filter)];
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, flags[0]);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, flags[1]);
				var w = TWRAP[Type.enumIndex(t.wrap)];
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, w);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, w);
			}
		}
	}

	override function selectMaterial( pass : Pass ) {
		selectMaterialBits(@:privateAccess pass.bits);
		// TODO : Blend Op value sync
	}

	function selectMaterialBits( bits : Int ) {
		var diff = bits ^ curMatBits;
		if( curMatBits < 0 ) diff = -1;
		if( diff == 0 )
			return;
		if( diff & Pass.culling_mask != 0 ) {
			var cull = Pass.getCulling(bits);
			if( cull == 0 )
				gl.disable(GL.CULL_FACE);
			else {
				if( Pass.getCulling(curMatBits) == 0 ) gl.enable(GL.CULL_FACE);
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
				#if (nme || openfl)
				if( OP[cop] != GL.FUNC_ADD )
					throw "blendEquation() disable atm (crash)";
				#else
				gl.blendEquation(OP[cop]);
				#end
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
		if( diff & Pass.colorMask_mask != 0 ) {
			var m = Pass.getColorMask(bits);
			gl.colorMask(m & 1 != 0, m & 2 != 0, m & 4 != 0, m & 8 != 0);
		}
		curMatBits = bits;
	}

	override function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
		var bits = 0;
		if( color != null ) {
			gl.colorMask(true, true, true, true);
			if( curMatBits >= 0 ) curMatBits |= Pass.colorMask_mask;
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
		#elseif cpp
		// resize window
		#end
		bufferWidth = width;
		bufferHeight = height;
		gl.viewport(0, 0, width, height);
	}

	function getChannels( t : Texture ) {
		return switch( t.internalFmt ) {
		case GL.RGBA: GL.RGBA;
		default: throw "Invalid format " + t.internalFmt;
		}
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return switch( fmt ) {
		case RGBA: true;
		case RGBA32F: hasFeature(FloatTextures);
		default: false;
		}
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		if( t.flags.has(TargetUseDefaultDepth) )
			throw "TargetUseDefaultDepth not supported in GL";
		var tt = gl.createTexture();
		var tt : Texture = { t : tt, width : t.width, height : t.height, internalFmt : GL.RGBA, pixelFmt : GL.UNSIGNED_BYTE };
		switch( t.format ) {
		case RGBA:
			// default
		case RGBA32F if( hasFeature(FloatTextures) ):
			tt.pixelFmt = GL.FLOAT;
		default:
			throw "Unsupported texture format "+t.format;
		}
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		gl.bindTexture(GL.TEXTURE_2D, tt.t);
		var mipMap = t.flags.has(MipMapped) ? GL.LINEAR_MIPMAP_NEAREST : GL.LINEAR;
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, mipMap);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, mipMap);
		gl.texImage2D(GL.TEXTURE_2D, 0, tt.internalFmt, tt.width, tt.height, 0, getChannels(tt), tt.pixelFmt, null);
		if( t.flags.has(Target) ) {
			var fb = gl.createFramebuffer();
			gl.bindFramebuffer(GL.FRAMEBUFFER, fb);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, tt.t, 0);
			tt.fb = fb;
			if( t.flags.has(TargetDepth) ) {
				tt.rb = gl.createRenderbuffer();
				gl.bindRenderbuffer(GL.RENDERBUFFER, tt.rb);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, tt.width, tt.height);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, tt.rb);
				gl.bindRenderbuffer(GL.RENDERBUFFER, null);
			}
			gl.bindFramebuffer(GL.FRAMEBUFFER, curTarget == null ? null : curTarget.t.fb);
		}
		gl.bindTexture(GL.TEXTURE_2D, null);
		return tt;
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		var b = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		if( m.size * m.stride == 0 ) throw "assert";
		#if js
		gl.bufferData(GL.ARRAY_BUFFER, m.size * m.stride * 4, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#elseif hxsdl
		gl.bufferDataSize(GL.ARRAY_BUFFER, m.size * m.stride * 4, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#else
		var tmp = new Uint8Array(m.size * m.stride * 4);
		gl.bufferData(GL.ARRAY_BUFFER, tmp, m.flags.has(Dynamic) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		return { b : b, stride : m.stride };
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		var b = gl.createBuffer();
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, b);
		#if js
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, count * 2, GL.STATIC_DRAW);
		#elseif hxsdl
		gl.bufferDataSize(GL.ELEMENT_ARRAY_BUFFER, count * 2, GL.STATIC_DRAW);
		#else
		var tmp = new Uint16Array(count);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, tmp, GL.STATIC_DRAW);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		return b;
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		var tt = t.t;
		if( tt == null ) return;
		t.t = null;
		gl.deleteTexture(tt.t);
		if( tt.rb != null ) gl.deleteRenderbuffer(tt.rb);
		if( tt.fb != null ) gl.deleteFramebuffer(tt.fb);
	}

	override function disposeIndexes( i : IndexBuffer ) {
		gl.deleteBuffer(i);
	}

	override function disposeVertexes( v : VertexBuffer ) {
		gl.deleteBuffer(v.b);
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		#if (nme || hxsdl)
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
		#else
		if( t.format != RGBA ) {
			var pixels = bmp.getPixels();
			uploadTexturePixels(t, pixels, mipLevel, side);
			pixels.dispose();
		} else {
			var img = bmp.toNative();
			gl.bindTexture(GL.TEXTURE_2D, t.t.t);
			#if lime
			gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, bmp.width, bmp.height, 0, getChannels(t.t), t.pixelFmt, img.image.data);
			#else
			gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, getChannels(t.t), t.t.pixelFmt, img.getImageData(0, 0, bmp.width, bmp.height));
			#end
			if( t.flags.has(MipMapped) ) gl.generateMipmap(GL.TEXTURE_2D);
			gl.bindTexture(GL.TEXTURE_2D, null);
			t.flags.set(WasCleared);
		}
		#end
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		gl.bindTexture(GL.TEXTURE_2D, t.t.t);
		pixels.convert(t.format);
		#if hxsdl
		pixels.setFlip(true);
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, t.width, t.height, 0, getChannels(t.t), t.t.pixelFmt, pixels.bytes.getData());
		#else
		var pixels = new Uint8Array(pixels.bytes.getData());
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, t.width, t.height, 0, getChannels(t.t), t.t.pixelFmt, pixels);
		#end
		if( t.flags.has(MipMapped) ) gl.generateMipmap(GL.TEXTURE_2D);
		gl.bindTexture(GL.TEXTURE_2D, null);
		t.flags.set(WasCleared);
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hxsdl
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, buf.getNative(), bufPos, vertexCount * stride * 4);
		#else
		var buf = new Float32Array(buf.getNative());
		var sub = new Float32Array(buf.buffer, bufPos, vertexCount * stride #if cpp * (fixMult?4:1) #end);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hxsdl
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, buf.getData(), bufPos, vertexCount * stride * 4);
		#else
		var buf = new Uint8Array(buf.getData());
		var sub = new Uint8Array(buf.buffer, bufPos, vertexCount * stride * 4);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		#if hxsdl
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, buf.getNative(), bufPos, indiceCount * 2);
		#else
		var buf = new Uint16Array(buf.getNative());
		var sub = new Uint16Array(buf.buffer, bufPos, indiceCount #if cpp * (fixMult?2:1) #end);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		#if hxsdl
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, buf.getData(), bufPos, indiceCount * 2);
		#else
		var buf = new Uint8Array(buf.getData());
		var sub = new Uint8Array(buf.buffer, bufPos, indiceCount * 2);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
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

		gl.bindBuffer(GL.ARRAY_BUFFER, m.b);

		if( v.flags.has(RawFormat) ) {
			for( a in curShader.attribs )
				gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, a.offset * 4);
		} else {
			var offset = 8;
			for( i in 0...curShader.attribs.length ) {
				var a = curShader.attribs[i];
				switch( curShader.attribNames[i] ) {
				case "position":
					gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, 0);
				case "normal":
					if( m.stride < 6 ) throw "Buffer is missing NORMAL data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
					gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, 3 * 4);
				case "uv":
					if( m.stride < 8 ) throw "Buffer is missing UV data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
					gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, 6 * 4);
				case s:
					gl.vertexAttribPointer(a.index, a.size, a.type, false, m.stride * 4, offset * 4);
					offset += a.size;
					if( offset > m.stride ) throw "Buffer is missing '"+s+"' data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
				}
			}
		}
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		for( a in curShader.attribs ) {
			gl.bindBuffer(GL.ARRAY_BUFFER, @:privateAccess buffers.buffer.buffer.vbuf.b);
			gl.vertexAttribPointer(a.index, a.size, a.type, false, buffers.buffer.buffer.stride * 4, buffers.offset * 4);
			buffers = buffers.next;
		}
		curBuffer = null;
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf);
		gl.drawElements(GL.TRIANGLES, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function present() {
		gl.finish();
	}

	override function isDisposed() {
		#if (nme || openfl)
		return false;
		#else
		return gl.isContextLost();
		#end
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 )
			gl.disable(GL.SCISSOR_TEST);
		else {
			gl.enable(GL.SCISSOR_TEST);
			gl.scissor(x, bufferHeight - (y + height), width, height);
		}
	}

	override function setRenderTarget( tex : h3d.mat.Texture ) {
		curTarget = tex;
		if( tex == null ) {
			gl.bindFramebuffer(GL.FRAMEBUFFER, null);
			gl.viewport(0, 0, bufferWidth, bufferHeight);
			return;
		}
		if( tex.t == null )
			tex.alloc();
		tex.lastFrame = frame;
		gl.bindFramebuffer(GL.FRAMEBUFFER, tex.t.fb);
		gl.viewport(0, 0, tex.width, tex.height);
	}

	override public function setRenderTargets( textures : Array<h3d.mat.Texture> )  {
		throw "TODO";
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		#if js
		var ready = false;
		// wait until all assets have properly load
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
		return switch( f ) {
		#if hxsdl
		case StandardDerivatives, FloatTextures, MultipleRenderTargets:
			true; // runtime extension detect required ?
		#else
		case StandardDerivatives:
			gl.getExtension('OES_standard_derivatives') != null;
		case FloatTextures:
			gl.getExtension('OES_texture_float') != null && gl.getExtension('OES_texture_float_linear') != null;
		case MultipleRenderTargets:
			gl.getExtension('WEBGL_draw_buffers') != null;
		#end
		case PerTargetDepthBuffer:
			true;
		case TargetUseDefaultDepthBuffer:
			false;
		case HardwareAccelerated:
			true;
		case FullClearRequired:
			false;
		}
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		if( curTarget == null )
			throw "Can't capture main render buffer in GL";
		#if js
		gl.readPixels(0, 0, pixels.width, pixels.height, GL.RGBA, GL.UNSIGNED_BYTE, @:privateAccess pixels.bytes.b);
		pixels.format = RGBA;
		#end
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

	static var OP = [
		GL.FUNC_ADD,
		GL.FUNC_SUBTRACT,
		GL.FUNC_REVERSE_SUBTRACT
	];

}

#end
