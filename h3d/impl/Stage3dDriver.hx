package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;

#if flash

@:allow(h3d.impl.Stage3dDriver)
class VertexWrapper {
	var vbuf : flash.display3D.VertexBuffer3D;
	var written : Bool;
	var b : ManagedBuffer;

	function new(vbuf, b) {
		this.vbuf = vbuf;
		this.b = b;
	}

	function finalize( driver : Stage3dDriver ) {
		if( written ) return;
		written = true;
		// fill all the free positions that were unwritten with zeroes (necessary for flash)
		var f = @:privateAccess b.freeList;
		while( f != null ) {
			if( f.count > 0 ) {
				var mem : UInt = f.count * b.stride * 4;
				if( driver.empty.length < mem ) driver.empty.length = mem;
				driver.uploadVertexBytes(@:privateAccess b.vbuf, f.pos, f.count, haxe.io.Bytes.ofData(driver.empty), 0);
			}
			f = f.next;
		}
	}

}

private class CompiledShader {
	public var p : flash.display3D.Program3D;
	public var s : hxsl.RuntimeShader;
	public var stride : Int;
	public var bufferFormat : Int;
	public var inputNames : Array<String>;
	public var usedTextures : Array<Bool>;
	public function new(s) {
		this.s = s;
		stride = 0;
		bufferFormat = 0;
		inputNames = [];
		usedTextures = [];
	}
}

class Stage3dDriver extends Driver {

	public static var PROFILE = #if flash14 cast "standard" #else flash.display3D.Context3DProfile.BASELINE #end;

	var s3d : flash.display.Stage3D;
	var ctx : flash.display3D.Context3D;
	var onCreateCallback : Bool -> Void;

	var curMatBits : Int;
	var curShader : CompiledShader;
	var curBuffer : Buffer;
	var curMultiBuffer : Array<Int>;
	var curAttributes : Int;
	var curTextures : Array<h3d.mat.Texture>;
	var curSamplerBits : Array<Int>;
	var inTarget : h3d.mat.Texture;
	var antiAlias : Int;
	var width : Int;
	var height : Int;
	var enableDraw : Bool;
	var capture : { bmp : hxd.BitmapData, callb : Void -> Void };
	var frame : Int;
	var programs : Map<Int, CompiledShader>;
	var isStandardMode : Bool;
	var flashVersion : Float;

	@:allow(h3d.impl.VertexWrapper)
	var empty : flash.utils.ByteArray;

	public function new() {
		var v = flash.system.Capabilities.version.split(" ")[1].split(",");
		flashVersion = Std.parseFloat(v[0] + "." + v[1]);
		empty = new flash.utils.ByteArray();
		s3d = flash.Lib.current.stage.stage3Ds[0];
		programs = new Map();
		curTextures = [];
		curMultiBuffer = [];
	}

	override function logImpl( str : String ) {
		flash.Lib.trace(str);
	}

	override function getDriverName(details:Bool) {
		return ctx == null ? "None" : (details ? ctx.driverInfo : ctx.driverInfo.split(" ")[0]);
	}

	override function begin( frame : Int ) {
		reset();
		this.frame = frame;
	}

	override function reset() {
		enableDraw = true;
		curMatBits = -1;
		curShader = null;
		curBuffer = null;
		curMultiBuffer[0] = -1;
		for( i in 0...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = 0;
		for( i in 0...curTextures.length )
			ctx.setTextureAt(i, null);
		curTextures = [];
		curSamplerBits = [];
	}

	override function init( onCreate, forceSoftware = false ) {
		isStandardMode = Std.string(PROFILE) == "standard";
		if( isStandardMode && flashVersion < 14 ) {
			isStandardMode = false;
			PROFILE = flash.display3D.Context3DProfile.BASELINE;
		}
		this.onCreateCallback = onCreate;
		s3d.addEventListener(flash.events.Event.CONTEXT3D_CREATE, this.onCreate);
		s3d.requestContext3D( forceSoftware ? "software" : "auto", PROFILE );
	}

	function onCreate(_) {
		var old = ctx;
		for( p in programs )
			p.p.dispose();
		programs = new Map();
		if( old != null ) {
			if( old.driverInfo != "Disposed" ) throw "Duplicate onCreate()";
			old.dispose();
			ctx = s3d.context3D;
			onCreateCallback(true);
		} else {
			ctx = s3d.context3D;
			onCreateCallback(false);
		}
	}

	override function hasFeature( f : Feature ) : Bool {
		return switch( f ) {
		case HardwareAccelerated: ctx != null && ctx.driverInfo.toLowerCase().indexOf("software") == -1;
		case StandardDerivatives, FloatTextures: isStandardMode;
		case PerTargetDepthBuffer: false;
		case TargetUseDefaultDepthBuffer: true;
		case FullClearRequired: flashVersion < 15;
		}
	}

	override function resize(width, height) {
		ctx.configureBackBuffer(width, height, antiAlias);
		this.width = width;
		this.height = height;
	}

	override function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
		var mask = 0;
		if( color != null ) mask |= flash.display3D.Context3DClearMask.COLOR;
		if( depth != null ) mask |= flash.display3D.Context3DClearMask.DEPTH;
		if( stencil != null ) mask |= flash.display3D.Context3DClearMask.STENCIL;
		ctx.clear( color == null ? 0 : color.r, color == null ? 0 : color.g, color == null ? 0 : color.b, color == null ? 1 : color.a, depth == null ? 1 : depth, stencil == null ? 0 : stencil, mask);
	}

	override function setCapture( bmp : hxd.BitmapData, onCapture : Void -> Void ) {
		capture = { bmp : bmp, callb : onCapture };
	}

	override function dispose() {
		s3d.removeEventListener(flash.events.Event.CONTEXT3D_CREATE, onCreate);
		if( ctx != null ) ctx.dispose();
		ctx = null;
	}

	override function isDisposed() {
		return ctx == null || ctx.driverInfo == "Disposed";
	}

	override function present() {
		if( capture != null ) {
			ctx.drawToBitmapData(capture.bmp.toNative());
			ctx.present();
			var callb = capture.callb;
			capture = null;
			callb();
			return;
		}
		ctx.present();
	}

	override function disposeTexture( t : Texture ) {
		t.dispose();
	}

	override function allocVertexes( buf : ManagedBuffer ) : VertexBuffer {
		var v;
		try {
			v = ctx.createVertexBuffer(buf.size, buf.stride);
		} catch( e : flash.errors.Error ) {
			// too many resources / out of memory
			if( e.errorID == 3691 )
				return null;
			throw e;
		}
		return new VertexWrapper(v, buf);
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		return ctx.createIndexBuffer(count);
	}

	function getMipLevels( t : h3d.mat.Texture ) {
		if( !t.flags.has(MipMapped) )
			return 0;
		var levels = 0;
		while( t.width > (1 << levels) || t.height > (1 << levels) )
			levels++;
		return levels;
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		if( t.flags.has(TargetDepth) )
			throw "TargetDepth not supported in Stage3D";
		var fmt = flash.display3D.Context3DTextureFormat.BGRA;
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		try {
			if( t.flags.has(IsNPOT) ) {
				if( t.flags.has(Cubic) || t.flags.has(MipMapped) )
					throw "Not power of two texture is not supported with these flags";
				#if !flash11_8
				throw "Support for rectangle texture requires Flash 11.8+ compilation";
				#else
				return ctx.createRectangleTexture(t.width, t.height, fmt, t.flags.has(Target));
				#end
			}
			if( t.flags.has(Cubic) )
				return ctx.createCubeTexture(t.width, fmt, t.flags.has(Target), getMipLevels(t));
			return ctx.createTexture(t.width, t.height, fmt, t.flags.has(Target), getMipLevels(t));
		} catch( e : flash.errors.Error ) {
			if( e.errorID == 3691 )
				return null;
			throw e;
		}
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		if( t.flags.has(Cubic) ) {
			var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
			t.uploadFromBitmapData(bmp.toNative(), side, mipLevel);
		} else if( t.flags.has(IsNPOT) ) {
			#if flash11_8
			var t = flash.Lib.as(t.t, flash.display3D.textures.RectangleTexture);
			t.uploadFromBitmapData(bmp.toNative());
			#end
		} else {
			var t = flash.Lib.as(t.t, flash.display3D.textures.Texture);
			t.uploadFromBitmapData(bmp.toNative(), mipLevel);
		}
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		pixels.convert(BGRA);
		var data = pixels.bytes.getData();
		if( t.flags.has(Cubic) ) {
			var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
			t.uploadFromByteArray(data, 0, side, mipLevel);
		} else if( t.flags.has(IsNPOT) ) {
			#if flash11_8
			var t = flash.Lib.as(t.t, flash.display3D.textures.RectangleTexture);
			t.uploadFromByteArray(data, 0);
			#end
		} else {
			var t = flash.Lib.as(t.t,  flash.display3D.textures.Texture);
			t.uploadFromByteArray(data, 0, mipLevel);
		}
	}

	override function disposeVertexes( v : VertexBuffer ) {
		v.vbuf.dispose();
		v.b = null;
	}

	override function disposeIndexes( i : IndexBuffer ) {
		i.dispose();
	}

	override function setDebug( d : Bool ) {
		if( ctx != null ) ctx.enableErrorChecking = d && hasFeature(HardwareAccelerated);
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var data = buf.getNative();
		v.vbuf.uploadFromVector( bufPos == 0 ? data : data.slice(bufPos, vertexCount * v.b.stride + bufPos), startVertex, vertexCount );
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, bytes : haxe.io.Bytes, bufPos : Int ) {
		v.vbuf.uploadFromByteArray( bytes.getData(), bufPos, startVertex, vertexCount );
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var data = buf.getNative();
		i.uploadFromVector( bufPos == 0 ? data : data.slice(bufPos, indiceCount + bufPos), startIndice, indiceCount );
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		i.uploadFromByteArray(buf.getData(), bufPos, startIndice, indiceCount );
	}

	override function selectMaterial( pass : Pass ) {
		selectMaterialBits(@:privateAccess pass.bits);
	}

	function selectMaterialBits( bits : Int ) {
		var diff = bits ^ curMatBits;
		if( curMatBits < 0 ) diff = -1;
		if( diff == 0 )
			return;
		if( diff & Pass.culling_mask != 0 )
			ctx.setCulling(FACE[Pass.getCulling(bits)]);
		if( diff & (Pass.blendSrc_mask | Pass.blendDst_mask | Pass.blendAlphaSrc_mask | Pass.blendAlphaDst_mask) != 0 ) {
			var csrc = Pass.getBlendSrc(bits);
			var cdst = Pass.getBlendDst(bits);
			var asrc = Pass.getBlendAlphaSrc(bits);
			var adst = Pass.getBlendAlphaDst(bits);
			if( csrc == asrc && cdst == adst ) {
				if( (csrc | cdst) > BLEND.length ) throw "Blend operation not supported on flash";
				ctx.setBlendFactors(BLEND[csrc], BLEND[cdst]);
			} else {
				throw "Alpha blend functions not supported on flash";
			}
		}
		if( diff & (Pass.blendOp_mask | Pass.blendAlphaOp_mask) != 0 ) {
			var cop = Pass.getBlendOp(bits);
			var aop = Pass.getBlendAlphaOp(bits);
			if( cop != 0 || aop != 0 )
				throw "Custom blend operation not supported on flash";
		}
		if( diff & (Pass.depthWrite_mask | Pass.depthTest_mask) != 0 ) {
			var write = Pass.getDepthWrite(bits) != 0;
			var cmp = Pass.getDepthTest(bits);
			ctx.setDepthTest(write, COMPARE[cmp]);
		}
		if( diff & Pass.colorMask_mask != 0 ) {
			var m = Pass.getColorMask(bits);
			ctx.setColorMask(m & 1 != 0, m & 2 != 0, m & 4 != 0, m & 8 != 0);
		}
		curMatBits = bits;
	}

	function compileShader( s : hxsl.RuntimeShader.RuntimeShaderData, usedTextures : Array<Bool> ) {
		//trace(hxsl.Printer.shaderToString(s.data));
		var agal = hxsl.AgalOut.toAgal(s, isStandardMode ? 2 : 1);
		//var old = format.agal.Tools.toString(agal);
		agal = new hxsl.AgalOptim().optimize(agal);
		//var opt = format.agal.Tools.toString(agal);
		for( op in agal.code )
			switch( op ) {
			case OTex(_, _, t): usedTextures[t.index] = true;
			default:
			}
		var o = new haxe.io.BytesOutput();
		new format.agal.Writer(o).write(agal);
		return { agal : agal, bytes : o.getBytes() };
	}

	override function getNativeShaderCode( shader : hxsl.RuntimeShader ) {
		var vertex = compileShader(shader.vertex, []).agal;
		var fragment = compileShader(shader.fragment, []).agal;
		function fmt( agal, data : hxsl.RuntimeShader.RuntimeShaderData ) {
			var str = format.agal.Tools.toString(agal);
			return ~/c([0-9]+)(.[xyz]+)?/g.map(str, function(r) {
				var cid = Std.parseInt(r.matched(1)) << 2;
				var swiz = r.matched(2);
				if( swiz != null ) {
					var d = swiz.charCodeAt(1) - 'x'.code;
					cid += d;
					swiz = "." + [for( i in 1...swiz.length ) String.fromCharCode(swiz.charCodeAt(i) - d)].join("");
				}
				var name = "C" + cid;
				for( g in data.globals ) {
					if( g.path == "__consts__" && cid >= g.pos && cid < g.pos + (switch(g.type) { case TArray(TFloat, SConst(n)): n; default: 0; } ) && swiz == ".x" ) {
						swiz = null;
						name = "" + data.consts[cid - g.pos];
						break;
					}
					if( g.pos == cid ) {
						name = g.path;
						break;
					}
				}
				for( p in data.params )
					if( p.pos + (data.globalsSize << 2) == cid ) {
						name = p.name;
						break;
					}
				return swiz == null ? name : name+swiz;
			});
		}
		return fmt(vertex, shader.vertex) + "\n" + fmt(fragment, shader.fragment);
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var shaderChanged = false;
		var p = programs.get(shader.id);
		if( p == null ) {
			p = new CompiledShader(shader);
			p.p = ctx.createProgram();
			var vdata = compileShader(shader.vertex,[]).bytes.getData();
			var fdata = compileShader(shader.fragment, p.usedTextures).bytes.getData();
			vdata.endian = flash.utils.Endian.LITTLE_ENDIAN;
			fdata.endian = flash.utils.Endian.LITTLE_ENDIAN;

			var pos = 0;
			for( v in shader.vertex.data.vars )
				if( v.kind == Input ) {
					var size;
					var fmt = switch( v.type ) {
					case TBytes(4): size = 1; flash.display3D.Context3DVertexBufferFormat.BYTES_4;
					case TFloat: size = 1; flash.display3D.Context3DVertexBufferFormat.FLOAT_1;
					case TVec(2, VFloat): size = 2; flash.display3D.Context3DVertexBufferFormat.FLOAT_2;
					case TVec(3, VFloat): size = 3; flash.display3D.Context3DVertexBufferFormat.FLOAT_3;
					case TVec(4, VFloat): size = 4; flash.display3D.Context3DVertexBufferFormat.FLOAT_4;
					default: throw "unsupported input " + v.type;
					}
					var idx = FORMAT.indexOf(fmt);
					if( idx < 0 ) throw "assert " + fmt;
					p.bufferFormat |= idx << (pos * 3);
					p.inputNames.push(v.name);
					p.stride += size;
					pos++;
				}

			p.p.upload(vdata, fdata);
			programs.set(shader.id, p);
			curShader = null;
		}
		if( p != curShader ) {
			ctx.setProgram(p.p);
			shaderChanged = true;
			curShader = p;
			// unbind extra textures
			var tcount : Int = shader.fragment.textures.length + shader.vertex.textures.length;
			while( curTextures.length > tcount ) {
				curTextures.pop();
				ctx.setTextureAt(curTextures.length, null);
			}
			// force remapping of vertex buffer
			curBuffer = null;
			curMultiBuffer[0] = -1;
		}
		return shaderChanged;
	}

	override function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Textures:
			for( i in 0...curShader.s.fragment.textures.length ) {
				var t = buffers.fragment.tex[i];
				if( t == null || t.isDisposed() )
					t = h3d.mat.Texture.fromColor(0xFF00FF);
				if( t != null && t.t == null && t.realloc != null ) {
					t.alloc();
					t.realloc();
				}
				t.lastFrame = frame;
				if( !curShader.usedTextures[i] ) {
					if( curTextures[i] != null ) {
						ctx.setTextureAt(i, null);
						curTextures[i] = null;
						curSamplerBits[i] = -1;
					}
					continue;
				}
				var cur = curTextures[i];
				if( t != cur ) {
					ctx.setTextureAt(i, t.t);
					curTextures[i] = t;
				}
				// if we have set one of the texture flag manually or if the shader does not configure the texture flags
				if( true /*!t.hasDefaultFlags() || !s.texHasConfig[s.textureMap[i]]*/ ) {
					if( cur == null || t.bits != curSamplerBits[i] ) {
						ctx.setSamplerStateAt(i, WRAP[t.wrap.getIndex()], FILTER[t.filter.getIndex()], MIP[t.mipMap.getIndex()]);
						curSamplerBits[i] = t.bits;
					}
				} else {
					// the texture flags has been set by the shader, so we are in an unkown state
					curSamplerBits[i] = -1;
				}
			}
		case Params:
			if( curShader.s.vertex.paramsSize > 0 ) ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.VERTEX, curShader.s.vertex.globalsSize, buffers.vertex.params.toData(), curShader.s.vertex.paramsSize);
			if( curShader.s.fragment.paramsSize > 0 ) ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.FRAGMENT, curShader.s.fragment.globalsSize, buffers.fragment.params.toData(), curShader.s.fragment.paramsSize);
		case Globals:
			if( curShader.s.vertex.globalsSize > 0 ) ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.VERTEX, 0, buffers.vertex.globals.toData(), curShader.s.vertex.globalsSize);
			if( curShader.s.fragment.globalsSize > 0 ) ctx.setProgramConstantsFromVector(flash.display3D.Context3DProgramType.FRAGMENT, 0, buffers.fragment.globals.toData(), curShader.s.fragment.globalsSize);
		}
	}

	@:access(h3d.impl.ManagedBuffer)
	override function selectBuffer( v : Buffer ) {
		if( v == curBuffer )
			return;
		if( curBuffer != null && v.buffer == curBuffer.buffer && v.buffer.flags.has(RawFormat) == curBuffer.flags.has(RawFormat) ) {
			curBuffer = v;
			return;
		}
		if( curShader == null )
			throw "No shader selected";
		curBuffer = v;
		curMultiBuffer[0] = -1;

		var m = v.buffer.vbuf;
		if( m.b.stride < curShader.stride )
			throw "Buffer stride (" + m.b.stride + ") and shader stride (" + curShader.stride + ") mismatch";
		if( !m.written )
			m.finalize(this);
		var pos = 0, offset = 0;
		var bits = curShader.bufferFormat;
		if( v.flags.has(RawFormat) ) {
			while( offset < curShader.stride ) {
				var size = bits & 7;
				ctx.setVertexBufferAt(pos++, m.vbuf, offset, FORMAT[size]);
				offset += size == 0 ? 1 : size;
				bits >>= 3;
			}
		} else {
			offset = 8; // custom data starts after [position, normal, uv]
			for( s in curShader.inputNames ) {
				switch( s ) {
				case "position":
					ctx.setVertexBufferAt(pos++, m.vbuf, 0, FORMAT[3]);
				case "normal":
					if( m.b.stride < 6 ) throw "Buffer is missing NORMAL data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
					ctx.setVertexBufferAt(pos++, m.vbuf, 3, FORMAT[3]);
				case "uv":
					if( m.b.stride < 8 ) throw "Buffer is missing UV data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
					ctx.setVertexBufferAt(pos++, m.vbuf, 6, FORMAT[2]);
				default:
					var size = bits & 7;
					ctx.setVertexBufferAt(pos++, m.vbuf, offset, FORMAT[size]);
					offset += size == 0 ? 1 : size;
					if( offset > m.b.stride ) throw "Buffer is missing '"+s+"' data, set it to RAW format ?" #if debug + @:privateAccess v.allocPos #end;
					bits >>= 3;
				}
				bits >>= 3;
			}
		}
		for( i in pos...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = pos;
	}

	override function getShaderInputNames() {
		return curShader.inputNames;
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		// select the multiple buffers elements
		var changed = false;
		var b = buffers;
		var i = 0;
		while( b != null || i < curAttributes ) {
			if( b == null || b.id != curMultiBuffer[i] ) {
				changed = true;
				break;
			}
			b = b.next;
			i++;
		}
		if( changed ) {
			var pos = 0, offset = 0;
			var bits = curShader.bufferFormat;
			var b = buffers;
			while( offset < curShader.stride ) {
				var size = bits & 7;
				if( b.buffer.next != null )
					throw "Buffer is split";
				var vbuf = @:privateAccess b.buffer.buffer.vbuf;
				if( !vbuf.written ) vbuf.finalize(this);
				ctx.setVertexBufferAt(pos, vbuf.vbuf, b.offset, FORMAT[size]);
				curMultiBuffer[pos] = b.id;
				offset += size == 0 ? 1 : size;
				bits >>= 3;
				pos++;
				b = b.next;
			}
			for( i in pos...curAttributes )
				ctx.setVertexBufferAt(i, null);
			curAttributes = pos;
			curBuffer = null;
		}
	}

	function debugDraw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		try {
			ctx.drawTriangles(ibuf, startIndex, ntriangles);
		} catch( e : flash.errors.Error ) {
			// this error should not happen, but sometime does in debug mode (?)
			if( e.errorID != 3605 )
				throw e;
		}
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		if( enableDraw ) {
			if( ctx.enableErrorChecking )
				debugDraw(ibuf, startIndex, ntriangles);
			else
				ctx.drawTriangles(ibuf, startIndex, ntriangles);
		}
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		if( x == 0 && y == 0 && width < 0 && height < 0 ) {
			enableDraw = true;
			ctx.setScissorRectangle(null);
		} else {
			if( x < 0 ) {
				width += x;
				x = 0;
			}
			if( y < 0 ) {
				height += y;
				y = 0;
			}
			var tw = inTarget == null ? this.width : 9999;
			var th = inTarget == null ? this.height : 9999;
			if( x + width > tw ) width = tw - x;
			if( y + height > th ) height = th - y;
			enableDraw = width > 0 && height > 0;
			if( enableDraw )
				ctx.setScissorRectangle(new flash.geom.Rectangle(x, y, width, height));
		}
	}

	override function setRenderTarget( t : Null<h3d.mat.Texture>) {
		if( t == null ) {
			ctx.setRenderToBackBuffer();
			inTarget = null;
		} else {
			if( t.t == null )
				t.alloc();
			if( inTarget != null )
				throw "Calling setTarget() while already set";
			ctx.setRenderToTexture(t.t, t.flags.has(TargetUseDefaultDepth));
			inTarget = t;
			t.lastFrame = frame;
			// make sure we at least clear the color the first time
			if( flashVersion >= 15 && !t.flags.has(WasCleared) ) {
				t.flags.set(WasCleared);
				ctx.clear(0, 0, 0, 1, 1, 0, flash.display3D.Context3DClearMask.COLOR);
			}
			reset();
		}
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
#end