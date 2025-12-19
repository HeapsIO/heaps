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
	public var globalsHandles : haxe.ds.Vector<h3d.mat.TextureHandle>;
	public var params : ShaderBufferData;
	public var paramsHandles : haxe.ds.Vector<h3d.mat.TextureHandle>;
	public var tex : haxe.ds.Vector<h3d.mat.Texture>;
	public var buffers : haxe.ds.Vector<h3d.Buffer>;

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
		var ngh = s.globalsHandleCount;
		var nph = s.paramsHandleCount;
		if( globals.length < ng ) globals = new ShaderBufferData(ng);
		if( params.length < np ) params = new ShaderBufferData(np);
		if( tex.length < nt ) tex = new haxe.ds.Vector(nt);
		if( nb > 0 && (buffers == null || buffers.length < nb) ) buffers = new haxe.ds.Vector(nb);
		if( ngh > 0 && (globalsHandles == null || globalsHandles.length < ngh) ) globalsHandles = new haxe.ds.Vector(ngh);
		if( nph > 0 && (paramsHandles == null || paramsHandles.length < nph) ) paramsHandles = new haxe.ds.Vector(nph);
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

