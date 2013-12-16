package h3d.impl;
import h3d.Matrix;

#if (flash&&!cpp&&!js)
typedef IndexBuffer = flash.display3D.IndexBuffer3D;
typedef VertexBuffer = Stage3dDriver.VertexWrapper;
typedef Texture = flash.display3D.textures.TextureBase;
#elseif js
typedef IndexBuffer = js.html.webgl.Buffer;
@:publicFields
class GLVB {
	var b : js.html.webgl.Buffer;
	var stride : Int;
	public function new(b = null, s = 0) { this.b = b; this.stride = s; };
}
typedef VertexBuffer = GLVB;
typedef Texture = js.html.webgl.Texture;
#elseif cpp
typedef IndexBuffer = openfl.gl.GLBuffer;
@:publicFields
class GLVB {
	var b : openfl.gl.GLBuffer;
	var stride : Int;
	public function new(b = null, s = 0) { this.b = b; this.stride = s; };
}
typedef VertexBuffer = GLVB;
typedef Texture = openfl.gl.GLTexture;
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
	
	public function resize( width : Int, height : Int ) {
	}
	
	public function selectMaterial( mbits : Int ) {
	}
	
	/** return value tells if we have shader shader **/
	public function selectShader( shader : Shader ) : Bool {
		return false;
	}
	
	public function selectBuffer( buffer : VertexBuffer ) {
		throw "selectBuffer is not implemented";
	}
	
	public function getShaderInputNames() : Array<String> {
		return null;
	}
	
	public function selectMultiBuffers( buffers : Array<Buffer.BufferOffset> ) {
		throw "selectMultiBuffers is not implemented";
	}
	
	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		throw "draw is not implemented";
	}
	
	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
		throw "setRenderZone is not implemented";
	}
	
	/**
	 * Sets a texture as render target for current draw commands
	 * @param	tex a write enabled texture
	 * @param	useDepth shall we bind a depth(z) buffer to the render target
	 * @param	clearColor is a ARGB color to clear the target
	 */
	public function setRenderTarget( tex : Null<Texture>, useDepth : Bool, clearColor : Int ) {
		throw "setRenderTarget is not implemented";
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

	public function allocVertex( count : Int, stride : Int ) : VertexBuffer {
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
		throw "not implemented";
	}

	public function uploadTexturePixels( t : h3d.mat.Texture, pixels : hxd.Pixels, mipLevel : Int, side : Int ) {
	}
	
	/*
	public function selectShaderProjection(proj, transp) :Matrix{
		throw "not implemented";
		return null;
	}
	*/
}