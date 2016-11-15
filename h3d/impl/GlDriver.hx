package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;

#if (js||cpp||hxsdl)

#if js
import js.html.Uint16Array;
import js.html.Uint8Array;
import js.html.Float32Array;
private typedef GL = js.html.webgl.GL;
private typedef Uniform = js.html.webgl.UniformLocation;
private typedef Program = js.html.webgl.Program;
private typedef GLShader = js.html.webgl.Shader;
private typedef Framebuffer = js.html.webgl.Framebuffer;
#elseif lime
import lime.graphics.opengl.GL;
private typedef Uniform = Dynamic;
private typedef Program = lime.graphics.opengl.GLProgram;
private typedef GLShader = lime.graphics.opengl.GLShader;
private typedef Framebuffer = lime.graphics.opengl.Framebuffer;
private typedef Uint16Array = lime.utils.UInt16Array;
private typedef Uint8Array = lime.utils.UInt8Array;
private typedef Float32Array = lime.utils.Float32Array;
#elseif nme
import nme.gl.GL;
private typedef Uniform = Dynamic;
private typedef Program = nme.gl.GLProgram;
private typedef GLShader = nme.gl.GLShader;
private typedef Framebuffer = nme.gl.Framebuffer;
private typedef Uint16Array = nme.utils.Int16Array;
private typedef Uint8Array = nme.utils.UInt8Array;
private typedef Float32Array = nme.utils.Float32Array;
#elseif hxsdl
import sdl.GL;
private typedef Uniform = sdl.GL.Uniform;
private typedef Program = sdl.GL.Program;
private typedef GLShader = sdl.GL.Shader;
private typedef Framebuffer = sdl.GL.Framebuffer;
private typedef Texture = h3d.impl.Driver.Texture;
#if cpp
private typedef Float32Array = Array<cpp.Float32>;
#end
#end

private class CompiledShader {
	public var s : GLShader;
	public var vertex : Bool;
	public var globals : Uniform;
	public var params : Uniform;
	public var textures : Array<Uniform>;
	public var cubeTextures : Array<Uniform>;
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
#if (cpp||hxsdl)
@:build(h3d.impl.MacroHelper.replaceGL())
#end
class GlDriver extends Driver {

	#if js
	var canvas : js.html.CanvasElement;
	var mrtExt : { function drawBuffersWEBGL( colors : Array<Int> ) : Void; };
	public var gl : js.html.webgl.RenderingContext;
	#end

	var commonFB : Framebuffer;
	var curAttribs : Int;
	var curShader : CompiledProgram;
	var curBuffer : h3d.Buffer;
	var curMatBits : Int;
	var programs : Map<Int, CompiledProgram>;
	var frame : Int;

	var bufferWidth : Int;
	var bufferHeight : Int;
	var curTarget : h3d.mat.Texture;
	var numTargets : Int;

	public function new() {
		#if js
		canvas = @:privateAccess hxd.Stage.getCanvas();
		if( canvas == null ) throw "Canvas #webgl not found";
		gl = canvas.getContextWebGL({alpha:false});
		if( gl == null ) throw "Could not acquire GL context";
		// debug if webgl_debug.js is included
		untyped if( __js__('typeof')(WebGLDebugUtils) != "undefined" ) gl = untyped WebGLDebugUtils.makeDebugContext(gl);
		#end
		commonFB = gl.createFramebuffer();
		programs = new Map();
		curAttribs = 0;
		curMatBits = -1;
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
		resetStream();
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
		s.cubeTextures = [for( i in 0...shader.texturesCubeCount ) gl.getUniformLocation(p.p, prefix + "TexturesCube[" + i + "]")];
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
				throw "Program linkage failure: "+log+"\nVertex=\n"+glout.run(shader.vertex.data)+"\n\nFragment=\n"+glout.run(shader.fragment.data);
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
					if( index < 0 ) {
						p.stride += size;
						continue;
					}
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
				#if hl
				gl.uniform4fv(s.globals, streamData(@:privateAccess (cast buf.globals.toData() : hl.types.ArrayBasic.ArrayF32).bytes, 0, s.shader.globalsSize * 16), 0, s.shader.globalsSize * 4);
				#elseif hxsdl
				gl.uniform4fv(s.globals, buf.globals.toData(), 0, s.shader.globalsSize * 4);
				#else
				var a = new Float32Array(buf.globals.toData()).subarray(0, s.shader.globalsSize * 4);
				gl.uniform4fv(s.globals, a);
				#end
			}
		case Params:
			if( s.params != null ) {
				#if hl
				gl.uniform4fv(s.params, streamData(@:privateAccess (cast buf.params.toData() : hl.types.ArrayBasic.ArrayF32).bytes, 0, s.shader.paramsSize * 16), 0, s.shader.paramsSize * 4);
				#elseif hxsdl
				gl.uniform4fv(s.params, buf.params.toData(), 0, s.shader.paramsSize * 4);
				#else
				var a = new Float32Array(buf.params.toData()).subarray(0, s.shader.paramsSize * 4);
				gl.uniform4fv(s.params, a);
				#end
			}
		case Textures:
			for( i in 0...s.textures.length + s.cubeTextures.length ) {
				var t = buf.tex[i];
				if( t == null || t.isDisposed() ) {
					var color = h3d.mat.Defaults.loadingTextureColor;
					t = h3d.mat.Texture.fromColor(color,(color>>>24)/255);
				}
				if( t != null && t.t == null && t.realloc != null ) {
					t.alloc();
					t.realloc();
				}
				t.lastFrame = frame;
			}

			for( i in 0...s.textures.length ) {
				var t = buf.tex[i];
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

			for( i in 0...s.cubeTextures.length ) {
				var t = buf.tex[i + s.textures.length];
				gl.activeTexture(GL.TEXTURE0 + i + s.textures.length);
				gl.uniform1i(s.cubeTextures[i], i + s.textures.length);

				gl.bindTexture(GL.TEXTURE_CUBE_MAP, t.t.t);
				var flags = TFILTERS[Type.enumIndex(t.mipMap)][Type.enumIndex(t.filter)];
				gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, flags[0]);
				gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, flags[1]);
				var w = TWRAP[Type.enumIndex(t.wrap)];
				gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_S, w);
				gl.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_T, w);
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
		case GL.ALPHA: GL.ALPHA;
		default: throw "Invalid format " + t.internalFmt;
		}
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return switch( fmt ) {
		case RGBA, ALPHA: true;
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
		case ALPHA:
			tt.internalFmt = GL.ALPHA;
		case RGBA32F if( hasFeature(FloatTextures) ):
			tt.pixelFmt = GL.FLOAT;
		default:
			throw "Unsupported texture format "+t.format;
		}
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		var bind = t.flags.has(Cubic) ? GL.TEXTURE_CUBE_MAP : GL.TEXTURE_2D;
		gl.bindTexture(bind, tt.t);
		var mipMap = t.flags.has(MipMapped) ? GL.LINEAR_MIPMAP_NEAREST : GL.LINEAR;
		gl.texParameteri(bind, GL.TEXTURE_MAG_FILTER, mipMap);
		gl.texParameteri(bind, GL.TEXTURE_MIN_FILTER, mipMap);
		if( t.flags.has(Cubic) ) {
			for( i in 0...6 )
				gl.texImage2D(CUBE_FACES[i], 0, tt.internalFmt, tt.width, tt.height, 0, getChannels(tt), tt.pixelFmt, null);
		} else
			gl.texImage2D(bind, 0, tt.internalFmt, tt.width, tt.height, 0, getChannels(tt), tt.pixelFmt, null);
		if( t.flags.has(TargetDepth) ) {
			tt.rb = gl.createRenderbuffer();
			gl.bindRenderbuffer(GL.RENDERBUFFER, tt.rb);
			gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, tt.width, tt.height);
			gl.bindRenderbuffer(GL.RENDERBUFFER, null);
		}
		gl.bindTexture(bind, null);
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
	}

	override function disposeIndexes( i : IndexBuffer ) {
		gl.deleteBuffer(i);
	}

	override function disposeVertexes( v : VertexBuffer ) {
		gl.deleteBuffer(v.b);
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
	#if (nme || hxsdl || openfl || lime)
		var pixels = bmp.getPixels();
		uploadTexturePixels(t, pixels, mipLevel, side);
		pixels.dispose();
	#else
		if( t.format != RGBA || t.flags.has(Cubic) ) {
			var pixels = bmp.getPixels();
			uploadTexturePixels(t, pixels, mipLevel, side);
			pixels.dispose();
		} else {
			var img = bmp.toNative();
			gl.bindTexture(GL.TEXTURE_2D, t.t.t);
			#if js
			gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);
			#end
			gl.texImage2D(GL.TEXTURE_2D, mipLevel, t.t.internalFmt, getChannels(t.t), t.t.pixelFmt, img.getImageData(0, 0, bmp.width, bmp.height));
			if( t.flags.has(MipMapped) ) gl.generateMipmap(GL.TEXTURE_2D);
			gl.bindTexture(GL.TEXTURE_2D, null);
			t.flags.set(WasCleared);
		}
	#end
	}

	#if !hxsdl
	inline static function bytesToUint8Array( b : haxe.io.Bytes ) : Uint8Array {
		#if (lime && !js)
		return new Uint8Array(b);
		#else
		return new Uint8Array(b.getData());
		#end
	}
	#end

	/*
		GL async model create crashes if the GC free the memory that we send it.
		Instead, we will copy the data into a temp location before uploading.
	*/

	static inline var STREAM_POS = #if hl 0 #else 1 #end;
	#if hl

	var streamBytes : hl.types.Bytes;
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
		var newBytes = new hl.types.Bytes(newLen);
		if( streamPos > 0 )
			newBytes.blit(0, streamBytes, 0, streamPos);
		streamLen = newLen;
		streamBytes = newBytes;
	}

	#end

	function resetStream() {
		#if hl
		streamPos = 0;
		#end
	}

	inline function streamData(data, pos:Int, length:Int) {
		#if hl
		var needed = streamPos + length;
		if( needed > streamLen ) expandStream(needed);
		streamBytes.blit(streamPos, data, pos, length);
		data = streamBytes.offset(streamPos);
		streamPos += length;
		#end
		return data;
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		var cubic = t.flags.has(Cubic);
		var bind = cubic ? GL.TEXTURE_CUBE_MAP : GL.TEXTURE_2D;
		var face = cubic ? CUBE_FACES[side] : GL.TEXTURE_2D;
		gl.bindTexture(bind, t.t.t);
		pixels.convert(t.format);
		#if hxsdl
		pixels.setFlip(!cubic);
		gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, streamData(pixels.bytes.getData(),0,pixels.width*pixels.height*4));
		#elseif lime
		pixels.setFlip(!cubic);
		gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, bytesToUint8Array(pixels.bytes));
		#else
		gl.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, cubic ? 0 : 1);
		gl.texImage2D(face, mipLevel, t.t.internalFmt, pixels.width, pixels.height, 0, getChannels(t.t), t.t.pixelFmt, bytesToUint8Array(pixels.bytes));
		#end
		gl.bindTexture(bind, null);
		t.flags.set(WasCleared);
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hxsdl
		var data = #if hl @:privateAccess (cast buf.getNative() : hl.types.ArrayBasic.ArrayF32).bytes #else buf.getNative() #end;
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, streamData(data,bufPos * 4,vertexCount * stride * 4), bufPos * 4 * STREAM_POS, vertexCount * stride * 4);
		#else
		var buf = new Float32Array(buf.getNative());
		var sub = new Float32Array(buf.buffer, bufPos, vertexCount * stride);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride : Int = v.stride;
		gl.bindBuffer(GL.ARRAY_BUFFER, v.b);
		#if hxsdl
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, streamData(buf.getData(),bufPos * 4,vertexCount * stride * 4), bufPos * 4 * STREAM_POS, vertexCount * stride * 4);
		#else
		var buf = bytesToUint8Array(buf);
		var sub = new Uint8Array(buf.buffer, bufPos * 4, vertexCount * stride * 4);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, sub);
		#end
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		#if hxsdl
		var data = #if hl @:privateAccess (cast buf.getNative() : hl.types.ArrayBasic.ArrayUI16).bytes #else buf.getNative() #end;
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, streamData(data,bufPos*2,indiceCount*2), bufPos * 2 * STREAM_POS, indiceCount * 2);
		#else
		var buf = new Uint16Array(buf.getNative());
		var sub = new Uint16Array(buf.buffer, bufPos, indiceCount);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, sub);
		#end
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		#if hxsdl
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, streamData(buf.getData(),bufPos * 2, indiceCount * 2), bufPos * 2 * STREAM_POS, indiceCount * 2);
		#else
		var buf = bytesToUint8Array(buf);
		var sub = new Uint8Array(buf.buffer, bufPos * 2, indiceCount * 2);
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
		#if (nme || openfl) //lime ??
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

	inline function unbindTargets() {
		if( curTarget != null && numTargets > 1 ) {
			while( numTargets > 1 )
				gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0 + (--numTargets), GL.TEXTURE_2D, null, 0);
			#if js
			if( mrtExt != null )
				mrtExt.drawBuffersWEBGL([GL.COLOR_ATTACHMENT0]);
			#elseif hlsdl
			gl.drawBuffers(1, @:privateAccess CBUFFERS.bytes);
			#end
		}
	}

	override function setRenderTarget( tex : h3d.mat.Texture, face = 0 ) {
		unbindTargets();
		curTarget = tex;
		if( tex == null ) {
			gl.bindFramebuffer(GL.FRAMEBUFFER, null);
			gl.viewport(0, 0, bufferWidth, bufferHeight);
			return;
		}
		if( tex.t == null )
			tex.alloc();
		tex.lastFrame = frame;
		gl.bindFramebuffer(GL.FRAMEBUFFER, commonFB);
		gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, tex.flags.has(Cubic) ? CUBE_FACES[face] : GL.TEXTURE_2D, tex.t.t, 0);
		if( tex.t.rb != null )
			gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, tex.t.rb);
		else
			gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, null);
		gl.viewport(0, 0, tex.width, tex.height);
	}

	override function setRenderTargets( textures : Array<h3d.mat.Texture> ) {
		unbindTargets();
		setRenderTarget(textures[0]);
		if( textures.length < 2 )
			return;
		numTargets = textures.length;
		for( i in 1...textures.length ) {
			var tex = textures[i];
			if( tex.t == null )
				tex.alloc();
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0 + i, GL.TEXTURE_2D, tex.t.t, 0);
			tex.lastFrame = frame;
		}
		#if js
		if( mrtExt != null )
			mrtExt.drawBuffersWEBGL([for( i in 0...textures.length ) GL.COLOR_ATTACHMENT0 + i]);
		#elseif hlsdl
			gl.drawBuffers(textures.length, @:privateAccess CBUFFERS.bytes);
		#end
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
			#if js
			mrtExt != null || (mrtExt = gl.getExtension('WEBGL_draw_buffers')) != null;
			#else
			false; // no support for glDrawBuffers in OpenFL
			#end
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
		#if (js || hl)
		gl.readPixels(0, 0, pixels.width, pixels.height, GL.RGBA, GL.UNSIGNED_BYTE, @:privateAccess pixels.bytes.b);
		@:privateAccess pixels.innerFormat = RGBA;
		pixels.flags.set(FlipY);
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

	static var CUBE_FACES = [
		GL.TEXTURE_CUBE_MAP_POSITIVE_X,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_X,
		GL.TEXTURE_CUBE_MAP_POSITIVE_Y,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_Y,
		GL.TEXTURE_CUBE_MAP_POSITIVE_Z,
		GL.TEXTURE_CUBE_MAP_NEGATIVE_Z,
	];

	#if hlsdl
	static var CBUFFERS = (cast [for( i in 0...32 ) GL.COLOR_ATTACHMENT0 + i] : hl.types.ArrayBasic<Int>);
	#end

}

#end
