package h3d.impl;
import h3d.impl.Driver;
import h3d.mat.Pass;
import h3d.mat.Stencil;
import h3d.mat.Data;

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
	public var inputs : InputNames;
	public var usedTextures : Array<Bool>;
	public function new(s) {
		this.s = s;
		stride = 0;
		bufferFormat = 0;
		usedTextures = [];
	}
}

class Stage3dDriver extends Driver {

	// standard profile was introduced with Flash14 but it causes problems with filters, only enable it for flash15+
	public static var PROFILE = #if flash15 cast "standard" #else flash.display3D.Context3DProfile.BASELINE #end;
	public static var SHADER_CACHE_PATH = null;

	var s3d : flash.display.Stage3D;
	var ctx : flash.display3D.Context3D;
	var onCreateCallback : Bool -> Void;

	var curMatBits : Int;
	var curStOpBits : Int;
	var curStMaskBits : Int;
	var defStencil : Stencil;
	var curShader : CompiledShader;
	var curBuffer : Buffer;
	var curManagedBuffer : ManagedBuffer;
	var curMultiBuffer : Array<Int>;
	var curAttributes : Int;
	var curTextures : Array<h3d.mat.Texture>;
	var curSamplerBits : Array<Int>;
	var renderTargets : Int;
	var antiAlias : Int;
	var width : Int;
	var height : Int;
	var enableDraw : Bool;
	var frame : Int;
	var programs : Map<Int, CompiledShader>;
	var isStandardMode : Bool;
	var flashVersion : Float;
	var tdisposed : Texture;
	var defaultDepth : h3d.mat.DepthBuffer;
	var curColorMask = -1;

	@:allow(h3d.impl.VertexWrapper)
	var empty : flash.utils.ByteArray;

	public function new(antiAlias=0) {
		var v = flash.system.Capabilities.version.split(" ")[1].split(",");
		flashVersion = Std.parseFloat(v[0] + "." + v[1]);
		empty = new flash.utils.ByteArray();
		s3d = flash.Lib.current.stage.stage3Ds[0];
		programs = new Map();
		this.antiAlias = antiAlias;
		curTextures = [];
		curSamplerBits = [];
		curMultiBuffer = [];
		defStencil = new Stencil();
		defaultDepth = new h3d.mat.DepthBuffer( -1, -1);
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

	function reset() {
		enableDraw = true;
		curMatBits = -1;
		curStOpBits = -1;
		curStMaskBits = -1;
		curShader = null;
		curBuffer = null;
		curMultiBuffer[0] = -1;
		for( i in 0...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = 0;
		for( i in 0...curTextures.length ) {
			ctx.setTextureAt(i, null);
			curTextures[i] = null;
		}
		for( i in 0...curSamplerBits.length )
			curSamplerBits[i] = -1;
	}

	override function init( onCreate, forceSoftware = false ) {
		isStandardMode = Std.string(PROFILE) == "standard";
		if( isStandardMode && flashVersion < 14 ) {
			isStandardMode = false;
			PROFILE = flash.display3D.Context3DProfile.BASELINE;
		}
		this.onCreateCallback = onCreate;
		s3d.addEventListener(flash.events.Event.CONTEXT3D_CREATE, this.onCreate);
		s3d.requestContext3D( cast (forceSoftware ? "software" : "auto"), PROFILE );
	}

	function onCreate(_) {
		var old = ctx;
		for( p in programs )
			p.p.dispose();
		programs = new Map();
		if( old != null ) {
			//if( old.driverInfo != "Disposed" ) throw "Duplicate onCreate()";
			old.dispose();
			ctx = s3d.context3D;
			onCreateCallback(true);
		} else {
			ctx = s3d.context3D;
			if( tdisposed == null ) {
				tdisposed = ctx.createTexture(1, 1, flash.display3D.Context3DTextureFormat.BGRA, false);
				tdisposed.dispose();
			}
			onCreateCallback(false);
		}
	}

	override function hasFeature( f : Feature ) : Bool {
		return switch( f ) {
		case HardwareAccelerated: ctx != null && ctx.driverInfo.toLowerCase().indexOf("software") == -1;
		case StandardDerivatives, FloatTextures: isStandardMode;
		case MultipleRenderTargets: (PROFILE == cast "standard") || (PROFILE == cast "standardExtended");
		default: false;
		}
	}

	override function resize(width, height) {
		try {
			ctx.configureBackBuffer(width, height, antiAlias);
			this.width = width;
			this.height = height;
			@:privateAccess {
				defaultDepth.width = width;
				defaultDepth.height = height;
			}
		} catch( e : flash.errors.Error ) {
			// large screen but bad video card ?
			if( width > 2048 || height > 2048 ) {
				if( width > 2048 ) width = 2048;
				if( height > 2048 ) height = 2048;
				resize(width, height);
			} else
				throw new flash.errors.Error("" + e+" (" + width + "x" + height + ")");
		}
	}

	override function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
		var mask = 0;
		if( color != null ) mask |= flash.display3D.Context3DClearMask.COLOR;
		if( depth != null ) mask |= flash.display3D.Context3DClearMask.DEPTH;
		if( stencil != null ) mask |= flash.display3D.Context3DClearMask.STENCIL;
		ctx.clear( color == null ? 0 : color.r, color == null ? 0 : color.g, color == null ? 0 : color.b, color == null ? 1 : color.a, depth == null ? 1 : depth, stencil == null ? 0 : stencil, mask);
	}

	override function captureRenderBuffer( pixels : hxd.Pixels ) {
		if( renderTargets != 0 )
			throw "Can't capture render target in flash";
		var bmp = new flash.display.BitmapData(pixels.width, pixels.height, true, 0);
		ctx.drawToBitmapData(bmp);

		var pix = bmp.getPixels(bmp.rect);
		bmp.dispose();
		var b = pixels.bytes.getData();
		b.position = 0;
		b.writeBytes(pix, 0, pixels.width * pixels.height * 4);
		@:privateAccess pixels.innerFormat = ARGB;
		pixels.flags.set(AlphaPremultiplied);
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
		ctx.present();
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		if( t.t != null ) {
			t.t.dispose();
			t.t = null;
		}
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

	override function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		if( is32 )
			throw "32 bit indexes are not supported";
		try {
			return ctx.createIndexBuffer(count);
		} catch( e : flash.errors.Error ) {
			// too many resources / out of memory
			if( e.errorID == 3691 )
				return null;
			throw e;
		}
	}

	function getMipLevels( t : h3d.mat.Texture ) {
		if( !t.flags.has(MipMapped) )
			return 0;
		var levels = 0;
		while( t.width > (1 << levels) || t.height > (1 << levels) )
			levels++;
		return levels;
	}

	override function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
		return switch( fmt ) {
		case BGRA: true;
		case RGBA16F: true;
		default: false;
		}
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var fmt = switch( t.format ) {
		case BGRA: flash.display3D.Context3DTextureFormat.BGRA;
		case RGBA16F: flash.display3D.Context3DTextureFormat.RGBA_HALF_FLOAT;
		default: throw "Unsupported texture format " + t.format;
		}
		t.lastFrame = frame;
		t.flags.unset(WasCleared);
		try {
			if( t.flags.has(IsNPOT) ) {
				if( t.flags.has(Cube) || t.flags.has(MipMapped) )
					throw "Not power of two texture is not supported with these flags";
				#if !flash11_8
				throw "Support for rectangle texture requires Flash 11.8+ compilation";
				#else
				return ctx.createRectangleTexture(t.width, t.height, fmt, t.flags.has(Target));
				#end
			}
			if( t.flags.has(Cube) )
				return ctx.createCubeTexture(t.width, fmt, t.flags.has(Target), getMipLevels(t));
			return ctx.createTexture(t.width, t.height, fmt, t.flags.has(Target), getMipLevels(t));
		} catch( e : flash.errors.Error ) {
			if( e.errorID == 3691 )
				return null;
			if( e.errorID == 3694 )
				return tdisposed; // our context was disposed, let's return a disposed texture
			throw e;
		}
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		if( t.t == tdisposed ) return;
		if( t.flags.has(Cube) ) {
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
		if( t.t == tdisposed ) return;
		pixels.convert(BGRA);
		var data = pixels.bytes.getData();
		if( t.flags.has(Cube) ) {
			var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
			t.uploadFromByteArray(data, pixels.offset, side, mipLevel);
		} else if( t.flags.has(IsNPOT) ) {
			#if flash11_8
			var t = flash.Lib.as(t.t, flash.display3D.textures.RectangleTexture);
			t.uploadFromByteArray(data, pixels.offset);
			#end
		} else {
			var t = flash.Lib.as(t.t,  flash.display3D.textures.Texture);
			t.uploadFromByteArray(data, pixels.offset, mipLevel);
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

		if( pass.colorMask != curColorMask ) {
			var m = pass.colorMask;
			ctx.setColorMask(m & 1 != 0, m & 2 != 0, m & 4 != 0, m & 8 != 0);
			curColorMask = m;
		}

		var s = pass.stencil != null ? pass.stencil : defStencil;
		@:privateAccess selectStencilBits(s.opBits, s.maskBits);
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
		curMatBits = bits;
	}

	function selectStencilBits( opBits : Int, maskBits : Int ) {
		var diffOp  = opBits ^ curStOpBits;
		var diffMask = maskBits ^ curStMaskBits;

		if( (diffOp | diffMask) == 0 ) return;

		if( diffOp & (Stencil.frontTest_mask | Stencil.frontSTfail_mask | Stencil.frontDPfail_mask | Stencil.frontPass_mask) != 0 ) {
			ctx.setStencilActions(
				FACE[Type.enumIndex(Front)],
				COMPARE[Stencil.getFrontTest(opBits)],
				STENCIL_OP[Stencil.getFrontPass(opBits)],
				STENCIL_OP[Stencil.getFrontDPfail(opBits)],
				STENCIL_OP[Stencil.getFrontSTfail(opBits)]);
		}

		if( diffOp & (Stencil.backTest_mask | Stencil.backSTfail_mask | Stencil.backDPfail_mask | Stencil.backPass_mask) != 0 ) {
			ctx.setStencilActions(
				FACE[Type.enumIndex(Back)],
				COMPARE[Stencil.getBackTest(opBits)],
				STENCIL_OP[Stencil.getBackPass(opBits)],
				STENCIL_OP[Stencil.getBackDPfail(opBits)],
				STENCIL_OP[Stencil.getBackSTfail(opBits)]);
		}

		if( diffMask != 0 ) {
			ctx.setStencilReferenceValue(
				Stencil.getReference(maskBits),
				Stencil.getReadMask(maskBits),
				Stencil.getWriteMask(maskBits));
		}

		curStOpBits = opBits;
		curStMaskBits = maskBits;
	}

	function compileShader( s : hxsl.RuntimeShader.RuntimeShaderData, usedTextures : Array<Bool> ) {
		//trace(hxsl.Printer.shaderToString(s.data));
		var agalVersion = isStandardMode ? 2 : 1;
		var agal = hxsl.AgalOut.toAgal(s, agalVersion);
		//var old = format.agal.Tools.toString(agal);
		var optim = new hxsl.AgalOptim();
		agal = optim.optimize(agal);
		#if debug
		var maxVarying = format.agal.Tools.getProps(RVar, !s.vertex, agalVersion).count;
		var maxTextures = format.agal.Tools.getProps(RTexture, !s.vertex, agalVersion).count;
		for( op in agal.code )
			optim.iter(op, function(r, _) {
				switch( r.t ) {
				case RVar:
					if( r.index >= maxVarying ) {
						var vars = [];
						for( v in s.data.vars )
							switch( v.kind ) {
							case Var: vars.push(v.name);
							default:
							}
						throw "Too many varying for this shader ("+vars.join(",")+")";
					}
				case RTexture:
					if( r.index >= maxTextures ) {
						var vars = [];
						for( v in s.data.vars )
							switch( v.type ) {
							case TSampler2D, TSamplerCube: vars.push(v.name);
							default:
							}
						throw "Too many textures for this shader ("+vars.join(",")+")";
					}
				default:
				}
			});
		#end
		//var opt = format.agal.Tools.toString(agal);
		for( op in agal.code )
			switch( op ) {
			case OTex(_, _, t): usedTextures[t.index] = true;
			default:
			}
		var size = s.globalsSize+s.paramsSize;
		var max = format.agal.Tools.getProps(RConst, !s.vertex, agalVersion).count;
		if( size > max )
			throw (s.vertex?"Vertex ":"Fragment ") + " shader uses " + size+" constant registers while " + max + " is allowed";
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
				var g = data.globals;
				while( g != null ) {
					if( g.path == "__consts__" && cid >= g.pos && cid < g.pos + (switch(g.type) { case TArray(TFloat, SConst(n)): n; default: 0; } ) && swiz == ".x" ) {
						swiz = null;
						name = "" + data.consts[cid - g.pos];
						break;
					}
					if( g.pos == cid ) {
						name = g.path;
						break;
					}
					g = g.next;
				}
				var p = data.params;
				while( p != null ) {
					if( p.pos + (data.globalsSize << 2) == cid ) {
						name = p.name;
						break;
					}
					p = p.next;
				}
				return swiz == null ? name : name+swiz;
			});
		}
		return fmt(vertex, shader.vertex) + "\n" + fmt(fragment, shader.fragment);
	}

	function initShader( shader : hxsl.RuntimeShader ) {
		var p = new CompiledShader(shader);
		p.p = ctx.createProgram();

		var cachedShader = null;
		var file = SHADER_CACHE_PATH;
		if( SHADER_CACHE_PATH != null ) {
			file += shader.signature;
			if( !isStandardMode ) file += "1";
			file += ".shader";
			try cachedShader = haxe.Unserializer.run(hxd.File.getBytes(file).toString()) catch( e : Dynamic ) { };
		}
		if( cachedShader == null ) {
			cachedShader = {
				vertex : compileShader(shader.vertex,[]).bytes,
				fragment : compileShader(shader.fragment, p.usedTextures).bytes,
				tex : p.usedTextures,
			};
			if( file != null )
				hxd.File.saveBytes(file, haxe.io.Bytes.ofString(haxe.Serializer.run(cachedShader)));
		} else {
			p.usedTextures = cachedShader.tex;
		}

		var vdata = cachedShader.vertex.getData();
		var fdata = cachedShader.fragment.getData();
		vdata.endian = flash.utils.Endian.LITTLE_ENDIAN;
		fdata.endian = flash.utils.Endian.LITTLE_ENDIAN;

		var pos = 0;
		var inputNames = [];
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
				inputNames.push(v.name);
				p.stride += size;
				pos++;
			}
		p.inputs = InputNames.get(inputNames);
		p.p.upload(vdata, fdata);
		return p;
	}

	override function selectShader( shader : hxsl.RuntimeShader ) {
		var shaderChanged = false;
		var p = programs.get(shader.id);
		if( p == null ) {
			p = initShader(shader);
			programs.set(shader.id, p);
			curShader = null;
		}
		if( p != curShader ) {
			ctx.setProgram(p.p);
			shaderChanged = true;
			curShader = p;
			// unbind extra textures
			var tcount : Int = shader.fragment.texturesCount + shader.vertex.texturesCount;
			while( curTextures.length > tcount ) {
				curTextures.pop();
				ctx.setTextureAt(curTextures.length, null);
			}
			// force remapping for sampler bits
			for( i in 0...curSamplerBits.length )
				curSamplerBits[i] = -1;
			// force remapping of vertex buffer
			curBuffer = null;
			curMultiBuffer[0] = -1;
		}
		return shaderChanged;
	}

	override function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Textures:
			for( i in 0...curShader.s.fragment.texturesCount ) {
				var t = buffers.fragment.tex[i];
				if( t == null || t.isDisposed() ) {
					var color = h3d.mat.Defaults.loadingTextureColor;
					t = h3d.mat.Texture.fromColor(color,(color>>>24)/255);
				}
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
		case Buffers:
			if( curShader.s.fragment.bufferCount + curShader.s.vertex.bufferCount > 0 )
				throw "Uniform Buffers are not supported";
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
		if( curBuffer != null && v.buffer == curManagedBuffer && v.flags.has(RawFormat) == curBuffer.flags.has(RawFormat) ) {
			curBuffer = v;
			return;
		}
		if( curShader == null )
			throw "No shader selected";

		curBuffer = v;
		curManagedBuffer = v.buffer; // store if curBuffer is disposed()
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
			for( s in curShader.inputs.names ) {
				switch( s ) {
				case "position":
					ctx.setVertexBufferAt(pos++, m.vbuf, 0, FORMAT[3]);
				case "normal":
					if( m.b.stride < 6 ) throw "Buffer is missing NORMAL data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
					ctx.setVertexBufferAt(pos++, m.vbuf, 3, FORMAT[3]);
				case "uv":
					if( m.b.stride < 8 ) throw "Buffer is missing UV data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
					ctx.setVertexBufferAt(pos++, m.vbuf, 6, FORMAT[2]);
				default:
					var size = bits & 7;
					ctx.setVertexBufferAt(pos++, m.vbuf, offset, FORMAT[size]);
					offset += size == 0 ? 1 : size;
					if( offset > m.b.stride ) throw "Buffer is missing '"+s+"' data, set it to RAW format ?" #if track_alloc + @:privateAccess v.allocPos #end;
				}
				bits >>= 3;
			}
		}
		for( i in pos...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = pos;
	}

	override function getShaderInputNames() {
		return curShader.inputs;
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

	override function allocDepthBuffer(b:h3d.mat.DepthBuffer):DepthBuffer {
		throw "You can't allocate custom depth buffer on this platform.";
	}

	override function getDefaultDepthBuffer() {
		return defaultDepth;
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
			var tw = renderTargets == 0 ? this.width : 9999;
			var th = renderTargets == 0 ? this.height : 9999;
			if( x + width > tw ) width = tw - x;
			if( y + height > th ) height = th - y;
			enableDraw = width > 0 && height > 0;
			if( enableDraw )
				ctx.setScissorRectangle(new flash.geom.Rectangle(x, y, width, height));
		}
	}

	override function setRenderTarget( t : Null<h3d.mat.Texture>, face = 0, mipLevel = 0 ) {
		if( mipLevel != 0 )
			throw "Cannot render to mipmap in flash, use upload()";
		if( renderTargets > 1 ) {
			for( i in 1...renderTargets )
				ctx.setRenderToTexture(null, false, 0, 0, i);
			renderTargets = 1;
		}
		if( t == null ) {
			ctx.setRenderToBackBuffer();
			renderTargets = 0;
		} else {
			if( t.t == null )
				t.alloc();
			ctx.setRenderToTexture(t.t, t.depthBuffer != null, 0, face);
			renderTargets = 1;
			t.lastFrame = frame;
			// make sure we at least clear the color the first time
			if( flashVersion >= 15 && !t.flags.has(WasCleared) ) {
				t.flags.set(WasCleared);
				ctx.clear(0, 0, 0, 0, 1, 0, flash.display3D.Context3DClearMask.COLOR);
			}
		}
		reset();
	}

	override function setRenderTargets( textures : Array<h3d.mat.Texture>) {
		if( textures.length == 0 ) {
			setRenderTarget(null);
			return;
		}
		var hasDepth = textures[0].depthBuffer != null;
		for( i in 0...textures.length ) {
			var t = textures[i];
			if( t.t == null )
				t.alloc();
			ctx.setRenderToTexture(t.t, hasDepth, 0, 0, i);
			t.lastFrame = frame;
		}
		for( i in textures.length...renderTargets )
			ctx.setRenderToTexture(null, false, 0, 0, i);
		renderTargets = textures.length;
		reset();
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

	static var STENCIL_OP = [
		flash.display3D.Context3DStencilAction.KEEP,
		flash.display3D.Context3DStencilAction.ZERO,
		flash.display3D.Context3DStencilAction.SET,
		flash.display3D.Context3DStencilAction.INCREMENT_SATURATE,
		flash.display3D.Context3DStencilAction.INCREMENT_WRAP,
		flash.display3D.Context3DStencilAction.DECREMENT_SATURATE,
		flash.display3D.Context3DStencilAction.DECREMENT_WRAP,
		flash.display3D.Context3DStencilAction.INVERT,
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