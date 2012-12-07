package h3d.scene;

class Mesh<M:h3d.mat.MeshMaterial> extends Object {

	public var primitive : h3d.prim.Primitive;
	public var material : M;
	
	public function new( prim, mat, ?parent ) {
		super(parent);
		this.primitive = prim;
		this.material = mat;
	}
	
	override function draw( engine : h3d.Engine ) {
		material.setMatrixes(this.absPos, engine.curProjMatrix);
		engine.selectMaterial(material);
		primitive.render(engine);
	}
	
}