package h3d.shader;

@:enum abstract BufferKind(Int) {
	public var Globals = 0;
	public var Params = 1;
	public var Textures = 2;
}

class ShaderBuffers {

	public var globals : haxe.ds.Vector<Float>;
	public var params : haxe.ds.Vector<Float>;
	public var tex : haxe.ds.Vector<h3d.mat.Texture>;

	public function new( s : hxsl.RuntimeShader.RuntimeShaderData ) {
		globals = new haxe.ds.Vector(s.globalsSize<<2);
		params = new haxe.ds.Vector(s.paramsSize<<2);
		tex = new haxe.ds.Vector(s.textures.length);
	}

	public function grow( s : hxsl.RuntimeShader.RuntimeShaderData ) {
		var ng = s.globalsSize << 2;
		var np = s.paramsSize << 2;
		var nt = s.textures.length;
		if( globals.length < ng ) globals = new haxe.ds.Vector(ng);
		if( params.length < np ) params = new haxe.ds.Vector(np);
		if( tex.length < nt ) tex = new haxe.ds.Vector(nt);
	}

}

class Buffers {

	public var vertex : ShaderBuffers;
	public var fragment : ShaderBuffers;

	public function new( s : hxsl.RuntimeShader ) {
		vertex = new ShaderBuffers(s.vertex);
		fragment = new ShaderBuffers(s.fragment);
	}

	public inline function grow( s : hxsl.RuntimeShader ) {
		vertex.grow(s.vertex);
		fragment.grow(s.fragment);
	}
}

