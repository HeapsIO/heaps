package h3d.prim;

using h3d.dae.Tools;

class DAEModel extends Primitive {

	var root : h3d.dae.DAE;
	var vertexes : flash.Vector<Float>;
	var indices : flash.Vector<UInt>;
	
	public function new(d) {
		setup(d);
	}
	
	public function setup(d) {
		this.root = d;
		indices = new flash.Vector();
		vertexes = new flash.Vector();
		var ip = 0, vp = 0;
		for( mesh in root.getAll("library_geometries.geometry.mesh") ) {
			var points = switch( mesh.get("source[name=positions].float_array").value ) {
			case DFloatArray(vl, _): vl;
			default: throw "assert";
			}
			var normals = switch( mesh.get("source[name=normals].float_array").value ) {
			case DFloatArray(vl, _): vl;
			default: throw "assert";
			}
			var tcoords = switch( mesh.getValue("source[name=Texture].float_array",DFloatArray(null,0)) ) {
			case DFloatArray(vl, _): vl;
			default: throw "assert";
			}
			for( p in mesh.getAll("polylist") ) {
				var vcount = switch( p.get("vcount").value ) {
				case DIntArray(il, _): il;
				case DInt(v): flash.Vector.ofArray([v]);
				default: throw "assert";
				}
				var idx = switch( p.get("p").value ) {
				case DIntArray(il, _): il;
				default: throw "assert";
				}
				var sum = 0;
				for( n in vcount )
					sum += n;
				var stride = Std.int(idx.length / sum);
				var pos = 0;
				for( n in vcount ) {
					var vbase = vp >> 3;
					for( i in 0...n ) {
						var vidx = idx[pos] * 3;
						var nidx = idx[pos + 1] * 3;
						var tidx = idx[pos + 2] * 2;
						vertexes[vp++] = points[vidx];
						vertexes[vp++] = points[vidx + 2];
						vertexes[vp++] = points[vidx + 1];
						vertexes[vp++] = normals[nidx];
						vertexes[vp++] = normals[nidx + 2];
						vertexes[vp++] = normals[nidx + 1];
						if( tcoords == null ) {
							vertexes[vp++] = 0.;
							vertexes[vp++] = 0.;
						} else {
							vertexes[vp++] = tcoords[tidx];
							vertexes[vp++] = 1 - tcoords[tidx + 1]; // inverse Y
						}
						pos += stride;
					}
					for( tri in 0...n - 2 ) {
						indices[ip++] = vbase;
						indices[ip++] = vbase + tri + 2;
						indices[ip++] = vbase + tri + 1;
					}
				}
			}
		}
	}
	
	override function alloc( engine : h3d.Engine ) {
		buffer = engine.mem.allocVector(vertexes, 8, 0);
		indexes = engine.mem.allocIndex(indices);
	}
	
}