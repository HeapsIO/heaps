package h3d.prim;
using h3d.fbx.Data;

class FBXModel extends Polygon {

	var mesh : h3d.fbx.Mesh;
	
	public function new(m) {
		super(null);
		this.mesh = m;
		buildMesh();
	}
	
	function buildMesh() {
		var verts = makePoints(mesh.getVertices());
		var norms = makePoints(mesh.getNormals());
		var tuvs = mesh.getUVs()[0];
		var uvs = [];
		for( i in tuvs.index )
			uvs.push(new UV(tuvs.values[i << 1], 1-tuvs.values[(i << 1) + 1]));
		
		this.idx = [];
		this.points = [];
		this.tcoords = [];
		this.normals = [];
		
		// triangulize indexes : format is  A,B,...,-X : negative values mark the end of the polygon
		var count = 0, pos = 0;
		var index = mesh.getPolygons();
		for( i in index ) {
			count++;
			if( i < 0 ) {
				index[pos] = -i - 1;
				var start = pos - count + 1;
				for( n in 0...count ) {
					var k = n + start;
					points.push(verts[index[k]]);
					tcoords.push(uvs[k]);
					normals.push(norms[k]);
				}
				// polygons are actually triangle fans
				for( n in 0...count - 2 ) {
					idx.push(start);
					idx.push(start + n + 2); // inverse face
					idx.push(start + n + 1);
				}
				index[pos] = i; // restore
				count = 0;
			}
			pos++;
		}
	}
	
	function makePoints( a : Array<Float> ) {
		var pts = [];
		var pos = 0;
		for( i in 0...Std.int(a.length / 3) ) {
			var x = a[pos++];
			var y = a[pos++];
			var z = a[pos++];
			pts.push(new h3d.Point(x, z, y)); // inverse Y/Z
		}
		return pts;
	}
	
}