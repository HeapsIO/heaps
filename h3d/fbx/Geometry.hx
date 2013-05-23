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
	
	/**
		Decode polygon informations into triangle indexes and vertexes indexes
	**/
	public function getIndexes() {
		var count = 0, pos = 0;
		var index = getPolygons();
		var vout = [], iout = [];
		for( i in index ) {
			count++;
			if( i < 0 ) {
				index[pos] = -i - 1;
				var start = pos - count + 1;
				for( n in 0...count )
					vout.push(n + start);
				for( n in 0...count - 2 ) {
					iout.push(start + n);
					iout.push(start + count - 1);
					iout.push(start + n + 1);
				}
				index[pos] = i; // restore
				count = 0;
			}
		}
		return { vidx : vout, idx : iout };
	}

	public function getNormals() {
		var nrm = root.get("LayerElementNormal.Normals").getFloats();
		// if by-vertice (Maya in some cases, unless maybe "Split per-Vertex Normals" is checked)
		// let's reindex based on polygon indexes
		if( root.get("LayerElementNormal.MappingInformationType").props[0].toString() == "ByVertice" ) {
			var nout = [];
			for( i in getPolygons() ) {
				var vid = i;
				if( vid < 0 ) vid = -vid;
				nout.push(nrm[vid * 3]);
				nout.push(nrm[vid * 3 + 1]);
				nout.push(nrm[vid * 3 + 2]);
			}
			nrm = nout;
		}
		return nrm;
	}
	
	public function getColors() {
		var color = root.get("LayerElementColor",true);
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
				return new h3d.prim.Point(p.props[4].toFloat() * (lib.leftHand ? -1 : 1), p.props[5].toFloat(), p.props[6].toFloat());
		return null;
	}


}