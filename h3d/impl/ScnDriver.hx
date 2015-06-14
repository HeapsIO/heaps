package h3d.impl;
import h3d.impl.Driver;
import hxd.fmt.scn.Data;

class ScnDriver extends Driver {

	var d : Driver;
	var ops : Array<Operation>;
	var savedShaders : Map<Int, hxsl.RuntimeShader>;
	var textureMap : Map<Int, h3d.mat.Texture>;
	var vertexBuffers : Array<h3d.impl.ManagedBuffer>;
	var indexBuffers : Array<IndexBuffer>;
	#if !hxsdl
	var UID = 0;
	var indexMap : Map<IndexBuffer, Int>;
	var vertexMap : Map<VertexBuffer, Int>;
	#end
	var vertexStride : Array<Int>;
	var tmpShader : hxsl.RuntimeShader;
	var tmpPass : h3d.mat.Pass;
	var tmpBuf : h3d.shader.Buffers;
	var tmpVBuf : h3d.Buffer;
	var tmpBytes : haxe.io.Bytes;
	var frame = 0;

	public function new( driver : Driver ) {
		this.d = driver;
		ops = [];
		tmpPass = new h3d.mat.Pass("");
		tmpShader = new hxsl.RuntimeShader();
		var s = tmpShader;
		s.vertex = new hxsl.RuntimeShader.RuntimeShaderData();
		s.fragment = new hxsl.RuntimeShader.RuntimeShaderData();
		s.vertex.globalsSize = 0;
		s.vertex.paramsSize = 0;
		s.fragment.globalsSize = 0;
		s.fragment.paramsSize = 0;
		s.vertex.textures2DCount = s.vertex.texturesCubeCount = 0;
		s.fragment.textures2DCount = s.fragment.texturesCubeCount = 0;
		tmpBytes = haxe.io.Bytes.alloc(655536);
		tmpBuf = new h3d.shader.Buffers(s);
		tmpVBuf = new h3d.Buffer(0, 0, [NoAlloc]);
		logEnable = true;
		savedShaders = new Map();
		textureMap = new Map();
		vertexBuffers = [];
		indexBuffers = [];
		#if !hxsdl
		indexMap = new Map();
		vertexMap = new Map();
		#end
		vertexStride = [];
	}

	public function getDriver() {
		return d;
	}

	public function getBytes() {
		var d : Data = {
			version : 1,
			ops : ops,
		};
		return new hxd.fmt.scn.Writer().write(d);
	}

	override function logImpl( str : String ) {
		ops.push(Log(str));
	}

	override function hasFeature( f : Feature ) {
		return d.hasFeature(f);
	}

	override function isDisposed() {
		return d.isDisposed();
	}

	override function dispose() {
		d.dispose();
	}

	override function begin( frame : Int ) {
		ops.push(Begin);
		d.begin(frame);
	}

	override function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
		ops.push(Clear(color, depth, stencil));
		d.clear(color, depth, stencil);
	}

	override function setCapture( bmp : hxd.BitmapData, callb : Void -> Void ) {
		d.setCapture(bmp, callb);
	}

	override function reset() {
		ops.push(Reset);
		d.reset();
	}

	override function getDriverName( details : Bool ) {
		return d.getDriverName(details);
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		d.init(function(b) {
			onCreate(b);
		},forceSoftware);
	}

	override function resize( width : Int, height : Int ) {
		ops.push(Resize(width, height));
		d.resize(width, height);
	}


	override function selectShader( shader : hxsl.RuntimeShader ) {
		var s = savedShaders.get(shader.id);
		if( s != null )
			ops.push(SelectShader(shader.id, null));
		else {
			var s = new haxe.Serializer();
			s.useCache = true;
			s.serialize(shader);
			ops.push(SelectShader(shader.id, haxe.io.Bytes.ofString(s.toString())));
			savedShaders.set(shader.id, shader);
		}
		return d.selectShader(shader);
	}

	override function getNativeShaderCode( shader ) {
		return d.getNativeShaderCode(shader);
	}

	override function selectMaterial( pass : h3d.mat.Pass ) {
		ops.push(Material(@:privateAccess pass.bits));
		d.selectMaterial(pass);
	}

	override function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
		switch( which ) {
		case Globals:
			ops.push(UploadShaderBuffers(true, buffers.vertex.globals.toArray(), buffers.fragment.globals.toArray()));
		case Params:
			ops.push(UploadShaderBuffers(false, buffers.vertex.params.toArray(), buffers.fragment.params.toArray()));
		case Textures:
			ops.push(UploadShaderTextures([for( t in buffers.vertex.tex ) t.id], [for( t in buffers.fragment.tex ) t.id]));
		}
		d.uploadShaderBuffers(buffers, which);
	}

	override function getShaderInputNames() : Array<String> {
		return d.getShaderInputNames();
	}

	override function selectBuffer( buffer : Buffer ) {
		ops.push(SelectBuffer(@:privateAccess vertexID(buffer.buffer.vbuf), buffer.flags.has(RawFormat)));
		d.selectBuffer(buffer);
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		var bufs = [];
		var b = buffers;
		while( b != null ) {
			bufs.push( { vbuf : @:privateAccess vertexID(buffers.buffer.buffer.vbuf), offset : b.offset } );
			b = b.next;
		}
		ops.push(SelectMultiBuffer(bufs));
		d.selectMultiBuffers(buffers);
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		ops.push(Draw(indexID(ibuf), startIndex, ntriangles));
		d.draw(ibuf, startIndex, ntriangles);
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		ops.push(RenderZone(x, y, width, height));
		d.setRenderZone(x, y, width, height);
	}

	override function setRenderTarget( tex : Null<h3d.mat.Texture> ) {
		d.setRenderTarget(tex);
		ops.push(RenderTarget(tex == null ? -1 : tex.id));
	}

	override function present() {
		d.present();
		ops.push(Present);
	}

	override function setDebug( b : Bool ) {
		d.setDebug(b);
	}

	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		ops.push(AllocTexture(t.id, t.name, t.width, t.height, t.flags));
		return d.allocTexture(t);
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		var ibuf = d.allocIndexes(count);
		#if hxsdl
		var id : Int = cast ibuf;
		#else
		var id = ++UID;
		indexMap.set(ibuf, id);
		#end
		ops.push(AllocIndexes(id, count));
		return ibuf;
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		var vbuf = d.allocVertexes(m);
		#if hxsdl
		var id : Int = cast vbuf;
		#else
		var id = ++UID;
		vertexMap.set(vbuf, id);
		#end
		ops.push(AllocVertexes(id, m.size, m.stride, m.flags));
		vertexStride[id] = m.stride;
		return vbuf;
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		d.disposeTexture(t);
		ops.push(DisposeTexture(t.id));
	}

	inline function indexID(i:IndexBuffer) : Int {
		#if hxsdl
		return (cast i : Int);
		#else
		return indexMap.get(i);
		#end
	}

	inline function vertexID(v:VertexBuffer) : Int {
		#if hxsdl
		return (cast v : Int);
		#else
		return vertexMap.get(v);
		#end
	}

	override function disposeIndexes( i : IndexBuffer ) {
		d.disposeIndexes(i);
		ops.push(DisposeIndexes(indexID(i)));
		#if !hxsdl
		indexMap.remove(i);
		#end
	}

	override function disposeVertexes( v : VertexBuffer ) {
		d.disposeVertexes(v);
		ops.push(DisposeVertexes(vertexID(v)));
		#if !hxsdl
		vertexMap.remove(v);
		#end
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		d.uploadIndexBuffer(i, startIndice, indiceCount, buf, bufPos);
		var bytes = haxe.io.Bytes.alloc(indiceCount * 2);
		for( i in 0...indiceCount )
			bytes.setUInt16(i << 1, buf[bufPos + i]);
		ops.push(UploadIndexes(indexID(i), startIndice, indiceCount, bytes));
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		d.uploadIndexBytes(i, startIndice, indiceCount, buf, bufPos);
		ops.push(UploadIndexes(indexID(i), startIndice, indiceCount, buf.sub(bufPos, indiceCount * 2)));
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		d.uploadVertexBuffer(v, startVertex, vertexCount, buf, bufPos);
		var stride = vertexStride[vertexID(v)];
		var bytes = haxe.io.Bytes.alloc(stride * vertexCount * 4);
		for( i in 0...vertexCount * stride )
			bytes.setFloat(i << 2, buf[i + bufPos]);
		ops.push(UploadVertexes(vertexID(v), startVertex, vertexCount, bytes));
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		d.uploadVertexBytes(v, startVertex, vertexCount, buf, bufPos);
		var stride = vertexStride[vertexID(v)];
		ops.push(UploadVertexes(vertexID(v), startVertex, vertexCount, buf.sub(bufPos, stride * vertexCount * 4)));
	}

	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		d.uploadTextureBitmap(t, bmp, mipLevel, side);
		var pixels = bmp.getPixels();
		if( pixels.bytes.length != bmp.width * bmp.height * 4 )
			pixels.bytes = pixels.bytes.sub(0, bmp.width * bmp.height * 4);
		ops.push(UploadTexture(t.id, pixels, mipLevel, side));
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		d.uploadTexturePixels(t, pixels, mipLevel, side);
		var pixels = pixels.clone();
		if( pixels.bytes.length != pixels.width * pixels.height * 4 )
			pixels.bytes = pixels.bytes.sub(0, pixels.width * pixels.height * 4);
		ops.push(UploadTexture(t.id, pixels, mipLevel, side));
	}

	var defTex : h3d.mat.Texture;
	function defaultTexture() {
		if( defTex == null || defTex.isDisposed() ) {
			defTex = new h3d.mat.Texture(1, 1, [NoAlloc]);
			defTex.t = d.allocTexture(defTex);
			var pix = new hxd.Pixels(1, 1, haxe.io.Bytes.alloc(4), hxd.PixelFormat.ARGB);
			pix.setPixel(0, 0, 0xFFFFFF00);
			d.uploadTexturePixels(defTex, pix, 0, 0);
		}
		return defTex;
	}

	public function getTexture( id : Int ) {
		return textureMap.get(id);
	}

	@:access(h3d.impl.ManagedBuffer)
	public function replay( op : Operation ) {
		switch( op ) {
		case Log(str):
			d.log(str);
		case Begin:
			d.begin(++frame);
		case Clear(color, depth, stencil):
			d.clear(color,depth,stencil);
		case Reset:
			d.reset();
		case Resize(w, h):
			d.resize(w,h);
		case SelectShader(id, data):
			if( data != null ) {
				var s : hxsl.RuntimeShader = haxe.Unserializer.run(data.toString());
				@:privateAccess (s.id = hxsl.RuntimeShader.UID++); // make sure id is unique
				savedShaders.set(id, s);
			}
			d.selectShader(savedShaders.get(id));
		case Material(bits):
			@:privateAccess tmpPass.bits = bits;
			d.selectMaterial(tmpPass);
		case UploadShaderBuffers(globals, vertex, fragment):
			var b = tmpBuf;
			if( globals ) {
				tmpShader.vertex.globalsSize = vertex.length>>2;
				tmpShader.fragment.globalsSize = fragment.length >> 2;
				b.grow(tmpShader);
				for( i in 0...vertex.length )
					b.vertex.globals[i] = vertex[i];
				for( i in 0...fragment.length )
					b.fragment.globals[i] = fragment[i];
			} else {
				tmpShader.vertex.paramsSize = vertex.length>>2;
				tmpShader.fragment.paramsSize = fragment.length>>2;
				b.grow(tmpShader);
				for( i in 0...vertex.length )
					b.vertex.params[i] = vertex[i];
				for( i in 0...fragment.length )
					b.fragment.params[i] = fragment[i];
			}
			d.uploadShaderBuffers(b, globals ? Globals : Params);
		case UploadShaderTextures(vertex, fragment):
			var b = tmpBuf;
			tmpShader.vertex.textures2DCount = vertex.length;
			tmpShader.fragment.textures2DCount = fragment.length;
			b.grow(tmpShader);
			for( i in 0...vertex.length ) {
				var t = textureMap.get(vertex[i]);
				b.vertex.tex[i] = t == null ? defaultTexture() : t;
			}
			for( i in 0...fragment.length ) {
				var t = textureMap.get(fragment[i]);
				b.fragment.tex[i] = t == null ? defaultTexture() : t;
			}
			d.uploadShaderBuffers(b, Textures);
		case AllocTexture(id, name, width, height, flags):
			var fl : Array<h3d.mat.Data.TextureFlags> = [NoAlloc];
			var flbits = flags.toInt();
			var flcount = 0;
			while( flbits != 0 ) {
				if( flbits & 1 != 0 )
					fl.push(h3d.mat.Data.TextureFlags.createByIndex(flcount));
				flbits >>>= 1;
				flcount++;
			}
			var t = new h3d.mat.Texture(width, height, fl);
			t.name = name;
			t.t = d.allocTexture(t);
			t.flags.unset(WasCleared);
			textureMap.set(id, t);
		case AllocIndexes(id, count):
			var i = d.allocIndexes(count);
			indexBuffers[id] = i;
		case AllocVertexes(id, size, stride, flags):
			var m = new ManagedBuffer(stride, size, [NoAlloc]);
			m.flags = flags;
			m.vbuf = d.allocVertexes(m);
			vertexBuffers[id] = m;
		case DisposeTexture(id):
			var t = textureMap.get(id);
			if( t != null ) {
				textureMap.remove(id);
				d.disposeTexture(t);
			}
		case DisposeIndexes(id):
			var i = indexBuffers[id];
			if( i != null ) {
				indexBuffers[id] = null;
				d.disposeIndexes(i);
			}
		case DisposeVertexes(id):
			var v = vertexBuffers[id];
			if( v != null ) {
				vertexBuffers[id] = null;
				d.disposeVertexes(v.vbuf);
			}
		case UploadTexture(id, pixels, mipMap, side):
			d.uploadTexturePixels(textureMap.get(id), pixels, mipMap, side);
		case UploadIndexes(id, start, count, data):
			d.uploadIndexBytes(indexBuffers[id], start, count, data, 0);
		case UploadVertexes(id, start, count, data):
			var m = vertexBuffers[id];
			d.uploadVertexBytes(m.vbuf, start, count, data, 0);
			#if flash
			@:privateAccess if( !m.vbuf.written ) {
				m.vbuf.written = true;
				if( start > 0 ) {
					var size = start * m.stride * 4 * m.stride;
					if( tmpBytes.length < size ) tmpBytes = haxe.io.Bytes.alloc(size);
					d.uploadVertexBytes(m.vbuf, 0, start, tmpBytes, 0);
				}
				if( start + count < m.size ) {
					var size = (m.size - (start + count)) * 4 * m.stride;
					if( tmpBytes.length < size ) tmpBytes = haxe.io.Bytes.alloc(size);
					d.uploadVertexBytes(m.vbuf, start+count, m.size - (start+count), tmpBytes, 0);
				}
			}
			#end
		case SelectBuffer(id, raw):
			var m = vertexBuffers[id];
			var buf = new h3d.Buffer(0, 0, [NoAlloc]);
			@:privateAccess buf.buffer = m;
			if( raw ) buf.flags.set(RawFormat);
			d.selectBuffer(buf);
		case SelectMultiBuffer(bufs):
			var head = null;
			var cur : h3d.Buffer.BufferOffset = null;
			for( b in bufs ) {
				var buf = new h3d.Buffer(0, 0, [NoAlloc]);
				@:privateAccess buf.buffer = vertexBuffers[b.vbuf];
				var b = new h3d.Buffer.BufferOffset(buf, b.offset);
				if( head == null )
					head = b;
				else
					cur.next = b;
				cur = b;
			}
			d.selectMultiBuffers(head);
		case Draw(indexes, start, ntri):
			d.draw(indexBuffers[indexes], start, ntri);
		case RenderZone(x, y, w, h):
			d.setRenderZone(x, y, w, h);
		case RenderTarget(tid):
			var t = textureMap.get(tid);
			d.setRenderTarget(t);
		case Present:
			d.present();
		}
	}

}