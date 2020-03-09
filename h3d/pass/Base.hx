package h3d.pass;

class Base {

	var ctx : h3d.scene.RenderContext;
	public var name(default, null) : String;

	public function new(name) {
		this.name = name;
	}

	public function compileShader( p : h3d.mat.Pass ) : hxsl.RuntimeShader {
		throw "Not implemented for this pass";
		return null;
	}

	public function setContext( ctx ) {
		this.ctx = ctx;
	}

	public function dispose() {
	}

	public function draw( passes : PassList, ?sort : h3d.pass.PassList -> Void ) {
	}

}