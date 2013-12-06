package h3d.impl;
import h3d.impl.Driver;

class NullDriver extends Driver {

	public var driver : Driver;
	
	public function new( driver ) {
		this.driver = driver;
	}
	
	override function isDisposed() {
		return driver.isDisposed();
	}
	
	override function dispose() {
		driver.dispose();
	}

	override function reset() {
		driver.reset();
	}

	override function present() {
		driver.present();
	}

	override function clear( r : Float, g : Float, b : Float, a : Float ) {
		driver.clear(r, g, b, a);
	}
	
	override function getDriverName( details : Bool ) {
		return "Null Driver - " + driver.getDriverName(details);
	}
	
	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		driver.init(onCreate, forceSoftware);
	}

	override function resize( width : Int, height : Int ) {
		driver.resize(width, height);
	}

	override function selectMaterial( mbits : Int ) {
		driver.selectMaterial(mbits);
	}
	
	override function selectShader( shader : Shader ) : Bool {
		return driver.selectShader(shader);
	}
	
	override function getShaderInputNames() : Array<String> {
		return driver.getShaderInputNames();
	}
	
	override function isHardware() {
		return driver.isHardware();
	}
	
	override function setDebug( b : Bool ) {
		driver.setDebug(b);
	}
	
	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		return driver.allocTexture(t);
	}

	override function allocIndexes( count : Int ) : IndexBuffer {
		return driver.allocIndexes(count);
	}

	override function allocVertex( count : Int, stride : Int ) : VertexBuffer {
		return driver.allocVertex(count,stride);
	}
	
	override function disposeTexture( t : Texture ) {
		driver.disposeTexture(t);
	}
	
	override function disposeIndexes( i : IndexBuffer ) {
		driver.disposeIndexes(i);
	}
	
	override function disposeVertex( v : VertexBuffer ) {
		driver.disposeVertex(v);
	}
	
	override function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		driver.uploadIndexesBuffer(i, startIndice, indiceCount, buf, bufPos);
	}

	override function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		driver.uploadIndexesBytes(i, startIndice, indiceCount, buf, bufPos);
	}
	
	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		driver.uploadVertexBuffer(v, startVertex, vertexCount, buf, bufPos);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		driver.uploadVertexBytes(v, startVertex, vertexCount, buf, bufPos);
	}
	
	override function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
		driver.uploadTextureBitmap(t, bmp, mipLevel, side);
	}

	override function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
		driver.uploadTexturePixels(t, pixels, mipLevel, side);
	}

	/*
	public function selectBuffer( buffer : VertexBuffer )
	public function selectMultiBuffers( buffers : Array<Buffer.BufferOffset> )
	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int )
	public function setRenderZone( x : Int, y : Int, width : Int, height : Int )
	public function setRenderTarget( tex : Null<Texture>, useDepth : Bool, clearColor : Int )
	*/
	
}