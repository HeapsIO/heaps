package h3d.impl;
import h3d.impl.Driver;

#if flash

@:allow(h3d.impl.Stage3dDriver)
class VertexWrapper {
	var vbuf : flash.display3D.VertexBuffer3D;
	var stride : Int;
	var written : Bool;
	var b : MemoryManager.BigBuffer;
	
	function new(vbuf, stride) {
		this.vbuf = vbuf;
		this.stride = stride;
	}
	
	function finalize( driver : Stage3dDriver ) {
		if( written ) return;
		written = true;
		// fill all the free positions that were unwritten with zeroes (necessary for flash)
		var f = b.free;
		while( f != null ) {
			if( f.count > 0 ) {
				var mem : UInt = f.count * b.stride * 4;
				if( driver.empty.length < mem ) driver.empty.length = mem;
				driver.uploadVertexBytes(b.vbuf, f.pos, f.count, haxe.io.Bytes.ofData(driver.empty), 0);
			}
			f = f.next;
		}
	}

}

class Stage3dDriver extends Driver {
	
	var s3d : flash.display.Stage3D;
	var ctx : flash.display3D.Context3D;
	var onCreateCallback : Bool -> Void;
	
	var curMatBits : Int;
	var curShader : hxsl.Shader.ShaderInstance;
	var curBuffer : VertexBuffer;
	var curMultiBuffer : Array<Int>;
	var curAttributes : Int;
	var curTextures : Array<h3d.mat.Texture>;
	var curSamplerBits : Array<Int>;
	var inTarget : Texture;
	var antiAlias : Int;
	var width : Int;
	var height : Int;
	var enableDraw : Bool;
	var capture : { bmp : hxd.BitmapData, callb : Void -> Void };

	@:allow(h3d.impl.VertexWrapper)
	var empty : flash.utils.ByteArray;
	
	public function new() {
		empty = new flash.utils.ByteArray();
		s3d = flash.Lib.current.stage.stage3Ds[0];
		curTextures = [];
		curMultiBuffer = [];
	}
	
	override function getDriverName(details:Bool) {
		return ctx == null ? "None" : (details ? ctx.driverInfo : ctx.driverInfo.split(" ")[0]);
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
		this.onCreateCallback = onCreate;
		s3d.addEventListener(flash.events.Event.CONTEXT3D_CREATE, this.onCreate);
		s3d.requestContext3D( forceSoftware ? "software" : "auto" );
	}
	
	function onCreate(_) {
		var old = ctx;
		if( old != null ) {
			if( old.driverInfo != "Disposed" ) throw "Duplicate onCreate()";
			old.dispose();
			hxsl.Shader.ShaderGlobals.disposeAll();
			ctx = s3d.context3D;
			onCreateCallback(true);
		} else {
			ctx = s3d.context3D;
			onCreateCallback(false);
		}
	}
	
	override function isHardware() {
		return ctx != null && ctx.driverInfo.toLowerCase().indexOf("software") == -1;
	}
	
	override function resize(width, height) {
		ctx.configureBackBuffer(width, height, antiAlias);
		this.width = width;
		this.height = height;
	}
	
	override function clear(r, g, b, a) {
		ctx.clear(r, g, b, a);
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
	
	override function allocVertex( count : Int, stride : Int ) : VertexBuffer {
		var v;
		try {
			v = ctx.createVertexBuffer(count, stride);
		} catch( e : flash.errors.Error ) {
			// too many resources / out of memory
			if( e.errorID == 3691 )
				return null;
			throw e;
		}
		return new VertexWrapper(v, stride);
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		return ctx.createIndexBuffer(count);
	}
	
	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var fmt = switch( t.format ) {
		case Rgba, Atf:
			flash.display3D.Context3DTextureFormat.BGRA;
		case AtfCompressed(alpha):
			alpha ? flash.display3D.Context3DTextureFormat.COMPRESSED_ALPHA : flash.display3D.Context3DTextureFormat.COMPRESSED;
		}
		var rect = false;
		if( t.isTarget && !t.isCubic && t.mipLevels == 0 ) {
			var tw = 1, th = 1;
			while( tw < t.width ) tw <<= 1;
			while( th < t.height) th <<= 1;
			if( tw != t.width || th != t.height )
				rect = true;
		}
		return if( t.isCubic )
			ctx.createCubeTexture(t.width, fmt, t.isTarget, t.mipLevels);
		else if( rect ) {
			#if !flash11_8
			throw "Support for rectangle texture requires Flash 11.8+ compilation";
			#else
			ctx.createRectangleTexture(t.width, t.height, fmt, t.isTarget);
			#end
		}
		else
			ctx.createTexture(t.width, t.height, fmt, t.isTarget, t.mipLevels);
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		if( t.isCubic ) {
			var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
			t.uploadFromBitmapData(bmp.toNative(), side, mipLevel);
		}
		else {
			var t = flash.Lib.as(t.t, flash.display3D.textures.Texture);
			t.uploadFromBitmapData(bmp.toNative(), mipLevel);
		}
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		pixels.convert(BGRA);
		var data = pixels.bytes.getData();
		switch( t.format ) {
		case Atf, AtfCompressed(_):
			if( t.isCubic ) {
				var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
				t.uploadCompressedTextureFromByteArray(data, 0);
			}
			else {
				var t = flash.Lib.as(t.t,  flash.display3D.textures.Texture);
				t.uploadCompressedTextureFromByteArray(data, 0);
			}
		default:
			if( t.isCubic ) {
				var t = flash.Lib.as(t.t, flash.display3D.textures.CubeTexture);
				t.uploadFromByteArray(data, 0, side, mipLevel);
			}
			else {
				var t = flash.Lib.as(t.t,  flash.display3D.textures.Texture);
				t.uploadFromByteArray(data, 0, mipLevel);
			}
		}
	}
	
	override function disposeVertex( v : VertexBuffer ) {
		v.vbuf.dispose();
		v.b = null;
	}
	
	override function disposeIndexes( i : IndexBuffer ) {
		i.dispose();
	}
	
	override function setDebug( d : Bool ) {
		if( ctx != null ) ctx.enableErrorChecking = d && isHardware();
	}
	
	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var data = buf.getNative();
		v.vbuf.uploadFromVector( bufPos == 0 ? data : data.slice(bufPos, vertexCount * v.stride + bufPos), startVertex, vertexCount );
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, bytes : haxe.io.Bytes, bufPos : Int ) {
		v.vbuf.uploadFromByteArray( bytes.getData(), bufPos, startVertex, vertexCount );
	}

	override function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var data = buf.getNative();
		i.uploadFromVector( bufPos == 0 ? data : data.slice(bufPos, indiceCount + bufPos), startIndice, indiceCount );
	}

	override function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		i.uploadFromByteArray(buf.getData(), bufPos, startIndice, indiceCount );
	}
	
	override function selectMaterial( mbits : Int ) {
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
	}

	override function selectShader( shader : Shader ) {
		var shaderChanged = false;
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
			shaderChanged = true;
			s.varsChanged = true;
			// unbind extra textures
			var tcount : Int = s.textures.length;
			while( curTextures.length > tcount ) {
				curTextures.pop();
				ctx.setTextureAt(curTextures.length, null);
			}
			// force remapping of vertex buffer
			curBuffer = null;
			curMultiBuffer[0] = -1;
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
		return shaderChanged;
	}
	
	override function selectBuffer( v : VertexBuffer ) {
		if( v == curBuffer )
			return;
		curBuffer = v;
		curMultiBuffer[0] = -1;
		if( v.stride < curShader.stride )
			throw "Buffer stride (" + v.stride + ") and shader stride (" + curShader.stride + ") mismatch";
		if( !v.written )
			v.finalize(this);
		var pos = 0, offset = 0;
		var bits = curShader.bufferFormat;
		while( offset < curShader.stride ) {
			var size = bits & 7;
			ctx.setVertexBufferAt(pos++, v.vbuf, offset, FORMAT[size]);
			offset += size == 0 ? 1 : size;
			bits >>= 3;
		}
		for( i in pos...curAttributes )
			ctx.setVertexBufferAt(i, null);
		curAttributes = pos;
	}
	
	override function getShaderInputNames() {
		return curShader.bufferNames;
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
				if( b.b.next != null )
					throw "Buffer is split";
				if( !b.b.b.vbuf.written )
					b.b.b.vbuf.finalize(this);
				ctx.setVertexBufferAt(pos, b.b.b.vbuf.vbuf, b.offset, FORMAT[size]);
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
	
	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		if( enableDraw ) ctx.drawTriangles(ibuf, startIndex, ntriangles);
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

	override function setRenderTarget( tex : Null<Texture>, useDepth : Bool, clearColor : Int ) {
		if( tex == null ) {
			ctx.setRenderToBackBuffer();
			inTarget = null;
		} else {
			if( inTarget != null )
				throw "Calling setTarget() while already set";
			ctx.setRenderToTexture(tex, useDepth);
			inTarget = tex;
			reset();
			ctx.clear( ((clearColor>>16)&0xFF)/255 , ((clearColor>>8)&0xFF)/255, (clearColor&0xFF)/255, ((clearColor>>>24)&0xFF)/255);
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