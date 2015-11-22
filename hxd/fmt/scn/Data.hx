package hxd.fmt.scn;

typedef Serialized<T> = haxe.io.Bytes;

enum Operation {
	Log( str : String );
	Begin;
	Clear( ?color : h3d.Vector, ?depth : Float, ?stencil : Int );
	Resize( width : Int, height : Int );
	SelectShader( id : Int, ?data : Serialized<hxsl.RuntimeShader> );
	Material( bits : Int );
	UploadShaderBuffers( globals : Bool, vertex : Array<hxd.impl.Float32>, fragment : Array<hxd.impl.Float32> );
	UploadShaderTextures( vertex : Array<Int>, fragment : Array<Int> );

	AllocTexture( id : Int, name : String, width : Int, height : Int, flags : haxe.EnumFlags<h3d.mat.Data.TextureFlags> );
	AllocIndexes( id : Int, count : Int );
	AllocVertexes( id : Int, size : Int, stride : Int, flags : haxe.EnumFlags<h3d.Buffer.BufferFlag> );
	DisposeTexture( id : Int );
	DisposeIndexes( id : Int );
	DisposeVertexes( id : Int );

	UploadTexture( id : Int, pixels : hxd.Pixels, mipMap : Int, side : Int );
	UploadIndexes( id : Int, start : Int, count : Int, data : haxe.io.Bytes );
	UploadVertexes( id : Int, start : Int, count : Int, data : haxe.io.Bytes );

	SelectBuffer( id : Int, raw : Bool );
	SelectMultiBuffer( bufs : Array<{ vbuf:Int, offset : Int }> );
	Draw( indexes : Int, start : Int, ntri : Int );

	RenderZone( x : Int, y : Int, width : Int, height : Int );
	RenderTarget( tid : Int );
	Present;
}

typedef Data = {
	var version : Int;
	var ops : Array<Operation>;
}