package h3d.impl;
import h3d.impl.Driver;
import hxd.fmt.scn.Data;

class ScnDriver extends Driver {

	var d : Driver;
	var ops : Array<Operation>;
	var savedShaders : Map<Int, Bool>;
	var UID = 0;
	var indexMap : Map<IndexBuffer, Int>;
	var vertexMap : Map<VertexBuffer, Int>;
	var vertexStride : Array<Int>;

	public function new( driver : Driver ) {
		this.d = driver;
		ops = [];
		logEnable = true;
		savedShaders = new Map();
		indexMap = new Map();
		vertexMap = new Map();
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
		//d.logImpl(str);
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
		var hasData = savedShaders.get(shader.id);
		if( hasData )
			ops.push(SelectShader(shader.id, null));
		else {
			var s = new haxe.Serializer();
			s.useCache = true;
			s.serialize(shader);
			ops.push(SelectShader(shader.id, haxe.io.Bytes.ofString(s.toString())));
			savedShaders.set(shader.id, true);
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
		d.selectBuffer(buffer);
	}

	override function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
		d.selectMultiBuffers(buffers);
	}

	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		d.draw(ibuf, startIndex, ntriangles);
	}

	override function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
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
		var id = ++UID;
		indexMap.set(ibuf, id);
		ops.push(AllocIndexes(id, count));
		return ibuf;
	}

	override function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		var vbuf = d.allocVertexes(m);
		var id = ++UID;
		vertexMap.set(vbuf, id);
		ops.push(AllocVertexes(id, m.size, m.stride, m.flags));
		vertexStride[id] = m.stride;
		return vbuf;
	}

	override function disposeTexture( t : h3d.mat.Texture ) {
		d.disposeTexture(t);
		ops.push(DisposeTexture(t.id));
	}

	override function disposeIndexes( i : IndexBuffer ) {
		d.disposeIndexes(i);
		ops.push(DisposeIndexes(indexMap.get(i)));
		indexMap.remove(i);
	}

	override function disposeVertexes( v : VertexBuffer ) {
		d.disposeVertexes(v);
		ops.push(DisposeVertexes(vertexMap.get(v)));
		vertexMap.remove(v);
	}

	override function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		d.uploadIndexBuffer(i, startIndice, indiceCount, buf, bufPos);
		var bytes = haxe.io.Bytes.alloc(indiceCount * 2);
		for( i in 0...indiceCount )
			bytes.setUInt16(i << 1, buf[bufPos + i]);
		ops.push(UploadIndexes(indexMap.get(i), startIndice, indiceCount, bytes));
	}

	override function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		d.uploadIndexBytes(i, startIndice, indiceCount, buf, bufPos);
		ops.push(UploadIndexes(indexMap.get(i), startIndice, indiceCount, buf.sub(bufPos, indiceCount * 2)));
	}

	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		d.uploadVertexBuffer(v, startVertex, vertexCount, buf, bufPos);
		var stride = vertexStride[vertexMap.get(v)];
		var bytes = haxe.io.Bytes.alloc(stride * vertexCount * 4);
		for( i in 0...vertexCount * stride )
			bytes.setFloat(i << 2, buf[i + bufPos]);
		ops.push(UploadVertexes(vertexMap.get(v), startVertex, vertexCount, bytes));
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		d.uploadVertexBytes(v, startVertex, vertexCount, buf, bufPos);
		var stride = vertexStride[vertexMap.get(v)];
		ops.push(UploadVertexes(vertexMap.get(v), startVertex, vertexCount, buf.sub(bufPos, stride * vertexCount * 4)));
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

}