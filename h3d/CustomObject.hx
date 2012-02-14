package h3d;

class CustomObject<T:Shader> extends Object {

	public var shader : T;
	
	public function new(prim, shader:T) {
		super(prim, new h3d.mat.Material(shader));
		this.shader = shader;
	}
	
}