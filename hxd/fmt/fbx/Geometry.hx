package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;

class Geometry {

	var lib : BaseLibrary;
	var root : FbxNode;

	public function new(l, root) {
		this.lib = l;
		this.root = root;
	}

	public function getRoot() {
		return root;
	}

	public function getVertices() {
		return root.get("Vertices").getFloats();
	}

	public function getPolygons() {
		return root.get("PolygonVertexIndex").getInts();
	}

	public function getMaterials() {
		var mats = root.get("LayerElementMaterial",true);
		return mats == null ? null : mats.get("Materials").getInts();
	}

	public function getMaterialByTriangle() {
		var mids = getMaterials();
		var pos = 0;
		var count = 0;
		var mats = [];
		for( p in getPolygons() ) {
			count++;
			if( p >= 0 )
				continue;
			var m = mids[pos++];
			for( i in 0...count - 2 )
				mats.push(m);
			count = 0;
		}
		return mats;
	}

	public function merge( g : Geometry, materials : Array<Int> ) {
		var vl = getVertices();
		var vcount = Std.int(vl.length / 3);
		if( g.getGeomMatrix() != null || this.getGeomMatrix() != null )
			throw "TODO";

		// merge vertices
		for( v in g.getVertices() )
			vl.push(v);

		var poly = getPolygons();
		var mats = getMaterials();

		// expand materials
		if( mats.length == 1 && root.get("LayerElementMaterial.MappingInformationType").props[0].toString() == "AllSame" ) {
			var polyCount = 0;
			for( p in poly )
				if( p < 0 ) polyCount++;
			var m0 = mats[0];
			for( i in 1...polyCount )
				mats.push(m0);
		}

		// merge polygons
		var polyCount = 0;
		for( p in g.getPolygons() ) {
			var p = p;
			if( p < 0 ) {
				polyCount++;
				p -= vcount;
			} else {
				p += vcount;
			}
			poly.push(p);
		}

		// merge normals
		var normals = getNormals();
		for( n in g.getNormals() )
			normals.push(n);

		// merge uvs
		var uv = getUVs();
		var uv2 = g.getUVs();
		if( uv.length != uv2.length )
			throw "Different UV layer (" + uv2.length + " should be " + uv.length + ")";
		for( i in 0...uv.length ) {
			var uv = uv[i];
			var uv2 = uv2[i];
			var count = uv.values.length >> 1;
			for( v in uv2.values )
				uv.values.push(v);
			for( i in uv2.index )
				uv.index.push(i + count);
		}

		// merge colors
		var colors = getColors();
		var colors2 = g.getColors();
		if( colors != null ) {
			if( colors2 != null ) {
				var count = colors.values.length >> 2;
				for( v in colors2.values )
					colors.values.push(v);
				for( i in colors2.index )
					colors.index.push(i + count);
			} else {
				var count = colors.values.length >> 2;
				var count2 = Std.int(g.getNormals().length / 3); // quick guess for vertex count
				colors.values.push(1);
				colors.values.push(1);
				colors.values.push(1);
				colors.values.push(1);
				for( i in 0...count2 )
					colors.index.push(count);
			}
		} else if( colors2 != null ) {
			// ignore colors, would require to create a FBX Node
		}

		// merge materials
		var m2 = g.getMaterials();
		if( m2 == null ) {
			var mid = materials[0];
			for( i in 0...polyCount )
				mats.push(mid);
		} else if( polyCount > 1 && m2.length == 1 ) {
			var m = m2[0];
			for( i in 0...polyCount )
				mats.push(materials[m]);
		} else {
			for( m in m2 )
				mats.push(materials[m]);
		}
	}

	/**
		Decode polygon informations into triangle indexes and vertices indexes.
		Returns vidx, which is the list of vertices indexes and iout which is the index buffer for the full vertex model
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
					vout.push(index[n + start]);
				for( n in 0...count - 2 ) {
					iout.push(start + n);
					iout.push(start + count - 1);
					iout.push(start + n + 1);
				}
				index[pos] = i; // restore
				count = 0;
			}
			pos++;
		}
		return { vidx : vout, idx : iout };
	}

	public function getNormals() {
		return processVectors("LayerElementNormal", "Normals");
	}

	public function getTangents( opt = false ) {
		return processVectors("LayerElementTangent", "Tangents", opt);
	}

	function processVectors( layer, name, opt = false ) {
		var vect = root.get(layer + "." + name, opt);
		if( vect == null ) return null;
		var nrm = vect.getFloats();
		// if by-vertice (Maya in some cases, unless maybe "Split per-Vertex Normals" is checked)
		// let's reindex based on polygon indexes
		if( root.get(layer+".MappingInformationType").props[0].toString() == "ByVertice" ) {
			var nout = [];
			for( i in getPolygons() ) {
				var vid = i;
				if( vid < 0 ) vid = -vid - 1;
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
		for( v in root.getAll("LayerElementUV") ) {
			var index = v.get("UVIndex", true);
			var values = v.get("UV").getFloats();
			var index = if( index == null ) {
				// ByVertice/Direct (Maya sometimes...)
				[for( i in getPolygons() ) if( i < 0 ) -i - 1 else i];
			} else index.getInts();
			uvs.push({ values : values, index : index });
		}
		return uvs;
	}

	@:access(hxd.fmt.fbx.BaseLibrary.leftHand)
	public function getGeomMatrix() {
		var rot = null, trans = null;
		for( p in lib.getParent(root, "Model").getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				trans = new h3d.col.Point(p.props[4].toFloat() * (lib.leftHand ? -1 : 1), p.props[5].toFloat(), p.props[6].toFloat());
			case "GeometricRotation":
				rot = new h3d.col.Point(p.props[4].toFloat() * Math.PI / 180, p.props[5].toFloat() * Math.PI / 180, p.props[6].toFloat() * Math.PI / 180);
			default:
			}
		if( rot == null && trans == null )
			return null;
		var m = new h3d.Matrix();
		if( rot == null )
			m.identity();
		else
			m.initRotate(rot.x, rot.y, rot.z);
		if( trans != null ) {
			m.tx += trans.x;
			m.ty += trans.y;
			m.tz += trans.z;
		}
		return m;
	}

}