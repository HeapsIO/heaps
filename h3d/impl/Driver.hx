package h3d.impl;

#if flash
typedef IndexBuffer = flash.display3D.IndexBuffer3D;
typedef VertexBuffer = Stage3dDriver.VertexWrapper;
typedef Texture = flash.display3D.textures.TextureBase;
#elseif js
typedef IndexBuffer = js.html.webgl.Buffer;
typedef VertexBuffer = { b : js.html.webgl.Buffer, stride : Int };
typedef Texture = { t : js.html.webgl.Texture, width : Int, height : Int, fmt : Int, ?fb : js.html.webgl.Framebuffer, ?rb : js.html.webgl.Renderbuffer };
#elseif nme
typedef IndexBuffer = nme.gl.GLBuffer;
typedef VertexBuffer = { b : nme.gl.GLBuffer, stride : Int };
typedef Texture = { t : nme.gl.GLTexture, width : Int, height : Int, fmt : Int, ?fb : nme.gl.GLFramebuffer, ?rb : nme.gl.GLRenderbuffer };
#else
typedef IndexBuffer = Int;
typedef VertexBuffer = Int;
typedef Texture = Int;
#end

enum Feature {
	/*
		Do the shader support standard derivates functions (ddx ddy).
	*/
	StandardDerivatives;
	/*
		Can use allocate floating point textures.
	*/
	FloatTextures;
	/*
		Can we create a per-target-texture depth buffer.
	*/
	PerTargetDepthBuffer;
	/*
		Can we use the default depth buffer when rendering to a target texture.
	*/
	TargetUseDefaultDepthBuffer;
	/*
		Is our driver hardware accelerated or CPU emulated.
	*/
	HardwareAccelerated;
	/*
		Is it required to perform a full clear each frame on render target textures.
	*/
	FullClearRequired;
}

class Driver {

	public var logEnable : Bool;

	public function hasFeature( f : Feature ) {
		return false;
	}

	public function isDisposed() {
		return true;
	}

	public function dispose() {
	}

	public function begin( frame : Int ) {
	}

	public inline function log( str : String ) {
		#if debug
		if( logEnable ) logImpl(str);
		#end
	}

	public function getNativeShaderCode( shader : hxsl.RuntimeShader ) : String {
		return null;
	}

	function logImpl( str : String ) {
	}

	public function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
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

	public function selectShader( shader : hxsl.RuntimeShader ) {
		return false;
	}

	public function selectMaterial( pass : h3d.mat.Pass ) {
	}

	public function uploadShaderBuffers( buffers : h3d.shader.Buffers, which : h3d.shader.Buffers.BufferKind ) {
	}

	public function getShaderInputNames() : Array<String> {
		return null;
	}

	public function selectBuffer( buffer : Buffer ) {
	}

	public function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
	}

	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
	}

	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
	}

	public function setRenderTarget( tex : Null<h3d.mat.Texture> ) {
	}

	public function present() {
	}

	public function setDebug( b : Bool ) {
	}

	public function allocTexture( t : h3d.mat.Texture ) : Texture {
		return null;
	}

	public function allocIndexes( count : Int ) : IndexBuffer {
		return null;
	}

	public function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return null;
	}

	public function disposeTexture( t : Texture ) {
	}

	public function disposeIndexes( i : IndexBuffer ) {
	}

	public function disposeVertexes( v : VertexBuffer ) {
	}

	public function uploadIndexBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
	}

	public function uploadIndexBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
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