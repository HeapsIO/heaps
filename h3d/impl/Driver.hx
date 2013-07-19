package h3d.impl;

#if flash
typedef IndexBuffer = flash.display3D.IndexBuffer3D;
typedef VertexBuffer = Stage3dDriver.VertexWrapper;
typedef Texture = flash.display3D.textures.TextureBase;
#else
typedef IndexBuffer = Int;
typedef VertexBuffer = Int;
typedef Texture = Int;
#end

class Driver {
	
	public function isDisposed() {
		return true;
	}
	
	public function dispose() {
	}
	
	public function clear( r : Float, g : Float, b : Float, a : Float ) {
	}
	
	public function reset() {
	}
	
	public function getDriverName( details : Bool ) {
		return "Not available";
	}
	
	public function init( onCreate : Bool -> Void, forceSoftware = false ) {
	}
	
	public function resize( width : Int, height : Int, aa : Int ) {
	}
	
	public function selectMaterial( mbits : Int ) {
	}
	
	/** return value tells if we have shader shader **/
	public function selectShader( shader : Shader ) : Bool {
		return false;
	}
	
	public function selectBuffer( buffer : VertexBuffer ) {
	}
	
	public function getShaderInputNames() : Array<String> {
		return null;
	}
	
	public function selectMultiBuffers( buffers : Array<Buffer.BufferOffset> ) {
	}
	
	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
	}
	
	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
	}
	
	public function setRenderTarget( tex : Null<Texture>, useDepth : Bool, clearColor : Int ) {
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

	public function disposeTexture( t : Texture ) {
	}
	
	public function disposeVertex( v : VertexBuffer ) {
	}
	
	public function allocIndexes( count : Int ) : IndexBuffer {
		return null;
	}

	public function allocVertex( count : Int, stride : Int ) : VertexBuffer {
		return null;
	}
	
	public function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
	}

	public function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
	}
	
	public function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
	}

	public function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
	}
	
	public function disposeIndexes( i : IndexBuffer ) {
	}
	
	public function uploadTextureBitmap( t : h3d.mat.Texture, bmp : hxd.BitmapData, mipLevel : Int, side : Int ) {
	}

	public function uploadTextureBytes( t : h3d.mat.Texture, bytes : haxe.io.Bytes, mipLevel : Int, side : Int ) {
	}
	
}