package h3d.pass;

class Base {

	var ctx : h3d.scene.RenderContext;
	public var priority : Int = 0;
	public var forceProcessing : Bool = false;

	public function new() {
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

	public function draw( name : String, passes : Object ) {
		return passes;
	}

	public function getLightSystem() : Null<LightSystem> {
		return null;
	}

}