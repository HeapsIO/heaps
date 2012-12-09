package h3d;

/**
	A core object is a rendering context but completely outside of the 3d scene.
	It is meant to be able to share a rendering context between several similar physical objects.
 **/
class CoreObject<S:hxsl.Shader> {

	public var shader : S;
	public var primitive : h3d.prim.Primitive;
	public var material : h3d.mat.Material;
	
	public function new(prim, shader) {
		this.primitive = prim;
		this.shader = shader;
		this.material = new h3d.mat.Material(shader);
	}
	
	public function render( engine : h3d.Engine ) {
		engine.selectMaterial(material);
		primitive.render(engine);
	}
	
}