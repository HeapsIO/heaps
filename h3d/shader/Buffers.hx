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

}

class Buffers {

	public var vertex : ShaderBuffers;
	public var fragment : ShaderBuffers;

	public function new( s : hxsl.RuntimeShader ) {
		vertex = new ShaderBuffers(s.vertex);
		fragment = new ShaderBuffers(s.fragment);
	}
}

