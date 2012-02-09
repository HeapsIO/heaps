package h3d;

class Object {
	
	public var visible : Bool;
	public var material(default, null) : h3d.mat.Material;
	public var primitive(default, null) : h3d.prim.Primitive;
	
	public function new(prim,mat) {
		visible = true;
		this.primitive = prim;
		this.material = mat;
	}
	
}