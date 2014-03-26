package h3d.impl;

typedef IndexBuffer = flash.display3D.IndexBuffer3D;
typedef VertexBuffer = Stage3dDriver.VertexWrapper;
typedef Texture = flash.display3D.textures.TextureBase;

class Driver {
	
	public function isDisposed() {
		return true;
	}
	
	public function dispose() {
	}
	
	public function begin( frame : Int ) {
	}
	
	public function clear( r : Float, g : Float, b : Float, a : Float ) {
	}
	
	public function setCapture( bmp : hxd.BitmapData, callb : Void -> Void ) {
	}
	
	public function reset() {
	}
	
	public function getDriverName( details : Bool ) {
		return "Not available";
	}
	
	public function init( onCreate : Bool -> Void, forceSoftware = false ) {
	}
	
	public function resize( width : Int, height : Int ) {
	}
	
	public function selectMaterial( mbits : Int ) {
	}
	
	/** return value tells if we have shader shader **/
	public function selectShader( shader : Shader ) : Bool {
		return false;
	}
	
	public function getShaderInputNames() : Array<String> {
		return null;
	}
	
	public function selectBuffer( buffer : VertexBuffer ) {
	}
	
	public function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
	}
	
	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
	}
	
	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
	}
	
	public function setRenderTarget( tex : Null<h3d.mat.Texture>, clearColor : Int ) {
	}
	
	public function present() {
	}
	
	public function isHardware() {
		return true;
	}
	
	public function setDebug( b : Bool ) {
	}
	
	public function allocTexture( t : h3d.mat.Texture ) : Texture {
		return null;
	}

	public function allocIndexes( count : Int ) : IndexBuffer {
		return null;
	}

	public function allocVertex( m : ManagedBuffer ) : VertexBuffer {
		return null;
	}
	
	public function disposeTexture( t : Texture ) {
	}
	
	public function disposeIndexes( i : IndexBuffer ) {
	}
	
	public function disposeVertex( v : VertexBuffer ) {
	}
	
	public function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
	}

	public function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
	}
	
	public function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
	}

	public function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
	}
	
	public function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
	}

	public function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
	}
	
}