package h3d.pass;

class PassObject {
	@:noCompletion public var next : PassObject;
	var nextAlloc : PassObject;
	public var pass : h3d.mat.Pass;
	public var obj : h3d.scene.Object;
	public var index : Int;

	// cache
	public var shaders : hxsl.ShaderList;
	public var shader : hxsl.RuntimeShader;
	public var depth : Float;
	public var texture : Int = 0;

	function new() {
	}
}