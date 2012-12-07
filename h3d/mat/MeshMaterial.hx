package h3d.mat;

class MeshMaterial extends Material {
	
	// make constructor private (is abstract class)
	function new(shader) {
		super(shader);
	}
	
	public function setMatrixes( mpos : h3d.Matrix, mproj : h3d.Matrix ) {
		throw "Not implemented";
	}
	
}