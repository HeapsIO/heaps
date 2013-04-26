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
	
	public function getColors() {
		var color = root.get("LayerElementColor");
		return color == null ? null : { values : color.get("Colors").getFloats(), index : color.get("ColorIndex").getInts() };
	}
	
	public function getUVs() {
		var uvs = [];
		for( v in root.getAll("LayerElementUV") )
			uvs.push({ values : v.get("UV").getFloats(), index : v.get("UVIndex").getInts() });
		return uvs;
	}
	
	@:access(h3d.fbx.Library.leftHand)
	public function getGeomTranslate() {
		for( p in lib.getParent(root, "Model").getAll("Properties70.P") )
			if( p.props[0].toString() == "GeometricTranslation" )
				return new h3d.Point(p.props[4].toFloat() * (lib.leftHand ? -1 : 1), p.props[5].toFloat(), p.props[6].toFloat());
		return null;
	}


}