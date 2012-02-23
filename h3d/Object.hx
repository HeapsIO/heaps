package h3d;

class Object {
	
	public var material(default, null) : h3d.mat.Material;
	public var primitive(default, null) : h3d.prim.Primitive;
	
	public function new(prim,mat) {
		this.primitive = prim;
		this.material = mat;
	}
	
	public function render( engine : Engine ) {
		engine.selectMaterial(material);
		primitive.render(engine);
	}
	
	public function dispose() {
		primitive.dispose();
	}
	
}