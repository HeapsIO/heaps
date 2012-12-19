package h3d.fbx;
using h3d.fbx.Data;

class Geometry {

	var lib : Library;
	var root : FbxNode;
	
	public function new(l, root) {
		this.lib = l;
		this.root = root;
	}
	
	public function getVertices() {
		return root.get("Vertices").getFloats();
	}
	
	public function getPolygons() {
		return root.get("PolygonVertexIndex").getInts();
	}

	public function getNormals() {
		return root.get("LayerElementNormal.Normals").getFloats();
	}
	
	public function getUVs() {
		var uvs = [];
		for( v in root.getAll("LayerElementUV") )
			uvs.push({ values : v.get("UV").getFloats(), index : v.get("UVIndex").getInts() });
		return uvs;
	}
	
	/*
	public function getSkin( bonesPerVertex = 3 ) {
		var skin = null;
		for( v in lib.getSubs(root) )
			if( v.getType() == "Skin" )
				return new Skin(lib, v, root, Std.int(getVertices().length/3), bonesPerVertex);
		return null;
	}
	*/

}