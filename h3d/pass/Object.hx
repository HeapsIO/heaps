package h3d.pass;

class Object {
	public var pass : h3d.mat.Pass;
	public var obj : h3d.scene.Object;
	public var shaders : Array<hxsl.Shader>;
	public var shader : hxsl.RuntimeShader;
	public var index : Int;
	public var next : Object;
	public function new() {
		shaders = [];
	}
}