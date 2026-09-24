package hxd.fmt;
typedef Index<T> = Int;

typedef Mesh = {
	var vertexCount : Int;
	var attributes : Array<MeshAttribute>;
	var primitives : Array<MeshPrimitive>;
	var ?bounds : h3d.col.Bounds;
}

typedef Node = {
	var name : String;

	var ?parent : Node;
	var children : Array<Node>;

	var ?position : h3d.Vector;
	var ?rotation : h3d.Quat;
	var ?scale : h3d.Vector;

	var ?mesh : Index<Mesh>;
	// var ?materials : Array<Index<Material>>;
	// var ?skin : Index<Skin>;
	// var ?camera : Index<Camera>;
	// var ?light : Index<Light>;
}

class Library {
	public var root : Node;

	public var meshes : Array<Mesh> = [];
	// public var materials : Array<Material>;
	// public var skins : Array<Skin>;
	// public var animations : Array<Animation>;

	public function new() {
	}
}