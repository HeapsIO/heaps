package h3d.shader;

enum abstract BufferKind(Int) {
	public var Globals = 0;
	public var Params = 1;
	public var Textures = 2;
	public var Buffers = 3;
}

typedef ShaderBufferData = hxd.impl.TypedArray.Float32Array;

class ShaderBuffers {

	public var globals : ShaderBufferData;
	public var params : ShaderBufferData;
	public var tex : haxe.ds.Vector<h3d.mat.Texture>;
	public var buffers : haxe.ds.Vector<h3d.Buffer>;
	public var texHandles : haxe.ds.Vector<h3d.mat.TextureHandle>;
	public var bufHandles : haxe.ds.Vector<h3d.BufferHandle>;

	public function new() {
		globals = new ShaderBufferData(0);
		params = new ShaderBufferData(0);
		tex = new haxe.ds.Vector(0);
	}

	public function grow( s : hxsl.RuntimeShader.RuntimeShaderData ) {
		var ng = s.globalsSize << 2;
		var np = s.paramsSize << 2;
		var nt = s.texturesCount;
		var nb = s.bufferCount;
		var nth = s.globalsTexHandleCount + s.paramsTexHandleCount;
		var nbh = s.globalsBufHandleCount + s.paramsBufHandleCount;
		if( globals.length < ng ) globals = new ShaderBufferData(ng);
		if( params.length < np ) params = new ShaderBufferData(np);
		if( tex.length < nt ) tex = new haxe.ds.Vector(nt);
		if( nb > 0 && (buffers == null || buffers.length < nb) ) buffers = new haxe.ds.Vector(nb);
		if( nth > 0 && (texHandles == null || texHandles.length < nth) ) texHandles = new haxe.ds.Vector(nth);
		if( nbh > 0 && (bufHandles == null || bufHandles.length < nbh) ) bufHandles = new haxe.ds.Vector(nbh);
	}

}

class Buffers {

	public var vertex : ShaderBuffers;
	public var fragment : ShaderBuffers;

	public function new() {
		vertex = new ShaderBuffers();
		fragment = new ShaderBuffers();
	}

	public inline function grow( s : hxsl.RuntimeShader ) {
		vertex.grow(s.vertex);
		if( s.fragment != null ) fragment.grow(s.fragment);
	}
}

