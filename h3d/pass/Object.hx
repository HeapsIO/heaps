package h3d.pass;

class Object {
	public var pass : h3d.mat.Pass;
	public var obj : h3d.scene.Object;
	public var index : Int;
	public var next : Object;

	// cache
	public var shaders : hxsl.ShaderList;
	public var shader : hxsl.RuntimeShader;
	public var depth : Float;

	public function new() {
	}
}