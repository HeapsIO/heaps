package h3d.impl;

#if macro
typedef IndexBuffer = {};
typedef VertexBuffer = {};
typedef Texture = {};
typedef DepthBuffer = {};
typedef Query = {};
#elseif flash
typedef IndexBuffer = flash.display3D.IndexBuffer3D;
typedef VertexBuffer = Stage3dDriver.VertexWrapper;
typedef Texture = flash.display3D.textures.TextureBase;
typedef DepthBuffer = {};
typedef Query = {};
#elseif js
typedef IndexBuffer = { b : js.html.webgl.Buffer, is32 : Bool };
typedef VertexBuffer = { b : js.html.webgl.Buffer, stride : Int #if multidriver, driver : Driver #end };
typedef Texture = { t : js.html.webgl.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bias : Float, bind : Int #if multidriver, driver : Driver #end };
typedef DepthBuffer = { r : js.html.webgl.Renderbuffer #if multidriver, driver : Driver #end };
typedef Query = {};
#elseif hlsdl
typedef IndexBuffer = { b : sdl.GL.Buffer, is32 : Bool };
typedef VertexBuffer = { b : sdl.GL.Buffer, stride : Int };
typedef Texture = { t : sdl.GL.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bind : Int, bias : Float };
typedef DepthBuffer = { r : sdl.GL.Renderbuffer };
typedef Query = { q : sdl.GL.Query, kind : QueryKind };
#elseif usegl
typedef IndexBuffer = { b : haxe.GLTypes.Buffer, is32 : Bool };
typedef VertexBuffer = { b : haxe.GLTypes.Buffer, stride : Int };
typedef Texture = { t : haxe.GLTypes.Texture, width : Int, height : Int, internalFmt : Int, pixelFmt : Int, bits : Int, bind : Int, bias : Float };
typedef DepthBuffer = { r : haxe.GLTypes.Renderbuffer };
typedef Query = { q : haxe.GLTypes.Query, kind : QueryKind };
#elseif hldx
typedef IndexBuffer = { res : dx.Resource, count : Int, bits : Int };
typedef VertexBuffer = { res : dx.Resource, count : Int, stride : Int, uniform : Bool };
typedef Texture = { res : dx.Resource, view : dx.Driver.ShaderResourceView, rt : Array<dx.Driver.RenderTargetView>, mips : Int };
typedef DepthBuffer = { res : dx.Resource, view : dx.Driver.DepthStencilView };
typedef Query = {};
#elseif usesys
typedef IndexBuffer = haxe.GraphicsDriver.IndexBuffer;
typedef VertexBuffer = haxe.GraphicsDriver.VertexBuffer;
typedef Texture = haxe.GraphicsDriver.Texture;
typedef DepthBuffer = haxe.GraphicsDriver.DepthBuffer;
typedef Query = haxe.GraphicsDriver.Query;
#else
typedef IndexBuffer = {};
typedef VertexBuffer = {};
typedef Texture = {};
typedef DepthBuffer = {};
typedef Query = {};
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
		Can we allocate custom depth buffers. If not, default depth buffer
		(queried with DepthBuffer.getDefault()) will be clear if we change
		the render target resolution or format.
	*/
	AllocDepthBuffer;
	/*
		Is our driver hardware accelerated or CPU emulated.
	*/
	HardwareAccelerated;
	/*
		Allows to render on several render targets with a single draw.
	*/
	MultipleRenderTargets;
	/*
		Does it supports query objects API.
	*/
	Queries;
	/*
		Supports gamma correct textures
	*/
	SRGBTextures;
	/*
		Allows advanced shader operations (webgl2, opengl3+, directx 9.0c+)
	*/
	ShaderModel3;
	/*
		Tells if the driver uses bottom-left coordinates for textures.
	*/
	BottomLeftCoords;
	/*
		Supports rendering in wireframe mode.
	*/
	Wireframe;
	/*
		Supports instanced rendering
	*/
	InstancedRendering;
}

enum QueryKind {
	/**
		The result will give the GPU Timestamp (in nanoseconds, 1e-9 seconds) at the time the endQuery is performed
	**/
	TimeStamp;
	/**
		The result will give the number of samples that passes the depth buffer between beginQuery/endQuery range
	**/
	Samples;
}

enum RenderFlag {
	/**
		0 = LeftHanded (default), 1 = RightHanded. Affects the meaning of triangle culling value.
	**/
	CameraHandness;
}

class InputNames {
	public var id(default,null) : Int;
	public var names(default,null) : Array<String>;
	function new(names) {
		this.id = UID++;
		this.names = names;
	}
	static var UID = 0;
	static var CACHE = new Map<String,InputNames>();
	public static function get( names : Array<String> ) {
		var key = names.join("|");
		var i = CACHE.get(key);
		if( i == null ) {
			i = new InputNames(names.copy());
			CACHE.set(key,i);
		}
		return i;
	}
}

class Driver {

	public var logEnable : Bool;

	public function hasFeature( f : Feature ) {
		return false;
	}

	public function setRenderFlag( r : RenderFlag, value : Int ) {
	}

	public function isSupportedFormat( fmt : h3d.mat.Data.TextureFormat ) {
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

	public function generateMipMaps( texture : h3d.mat.Texture ) {
		throw "Mipmaps auto generation is not supported on this platform";
	}

	public function getNativeShaderCode( shader : hxsl.RuntimeShader ) : String {
		return null;
	}

	function logImpl( str : String ) {
	}

	public function clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int ) {
	}

	public function captureRenderBuffer( pixels : hxd.Pixels ) {
	}

	public function capturePixels( tex : h3d.mat.Texture, layer : Int, mipLevel : Int, ?region : h2d.col.IBounds ) : hxd.Pixels {
		throw "Can't capture pixels on this platform";
		return null;
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

	public function getShaderInputNames() : InputNames {
		return null;
	}

	public function selectBuffer( buffer : Buffer ) {
	}

	public function selectMultiBuffers( buffers : Buffer.BufferOffset ) {
	}

	public function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
	}

	public function drawInstanced( ibuf : IndexBuffer, commands : h3d.impl.InstanceBuffer ) {
	}

	public function setRenderZone( x : Int, y : Int, width : Int, height : Int ) {
	}

	public function setRenderTarget( tex : Null<h3d.mat.Texture>, layer = 0, mipLevel = 0 ) {
	}

	public function setRenderTargets( textures : Array<h3d.mat.Texture> ) {
	}

	public function allocDepthBuffer( b : h3d.mat.DepthBuffer ) : DepthBuffer {
		return null;
	}

	public function disposeDepthBuffer( b : h3d.mat.DepthBuffer ) {
	}

	public function getDefaultDepthBuffer() : h3d.mat.DepthBuffer {
		return null;
	}

	public function present() {
	}

	public function end() {
	}

	public function setDebug( b : Bool ) {
	}

	public function allocTexture( t : h3d.mat.Texture ) : Texture {
		return null;
	}

	public function allocIndexes( count : Int, is32 : Bool ) : IndexBuffer {
		return null;
	}

	public function allocVertexes( m : ManagedBuffer ) : VertexBuffer {
		return null;
	}

	public function allocInstanceBuffer( b : h3d.impl.InstanceBuffer, bytes : haxe.io.Bytes ) {
	}

	public function disposeTexture( t : h3d.mat.Texture ) {
	}

	public function disposeIndexes( i : IndexBuffer ) {
	}

	public function disposeVertexes( v : VertexBuffer ) {
	}

	public function disposeInstanceBuffer( b : h3d.impl.InstanceBuffer ) {
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

	public function readVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		throw "Driver does not allow to read vertex bytes";
	}

	public function readIndexBytes( v : IndexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		throw "Driver does not allow to read index bytes";
	}

	/**
		Returns true if we could copy the texture, false otherwise (not supported by driver or mismatch in size/format)
	**/
	public function copyTexture( from : h3d.mat.Texture, to : h3d.mat.Texture ) {
		return false;
	}

	// --- QUERY API

	public function allocQuery( queryKind : QueryKind ) : Query {
		return null;
	}

	public function deleteQuery( q : Query ) {
	}

	public function beginQuery( q : Query ) {
	}

	public function endQuery( q : Query ) {
	}

	public function queryResultAvailable( q : Query ) {
		return true;
	}

	public function queryResult( q : Query ) {
		return 0.;
	}

}