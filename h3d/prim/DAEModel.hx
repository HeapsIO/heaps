package h3d.prim;

using h3d.dae.Tools;

class DAEModel extends Primitive {

	var mesh : h3d.dae.Mesh;
	var vertexes : flash.Vector<Float>;
	var indices : flash.Vector<UInt>;
	
	var vertexCount : Int;
	var vertexMap : flash.Vector<Int>;
	
	var jointPerVertex : Int;
	var jointIndexes : flash.Vector<Int>;
	var jointWeights : flash.Vector<Float>;
	
	public function new(m) {
		setup(m);
	}
	
	public function setup(mesh) {
		this.mesh = mesh;
		indices = new flash.Vector();
		vertexes = new flash.Vector();
		vertexMap = new flash.Vector();
		var mesh = mesh.root.get("mesh");
		var points = mesh.get("source[name=positions].float_array").value.toFloats();
		vertexCount = Std.int(points.length / 3);
		var normals = mesh.get("source[name=normals].float_array").value.toFloats();
		var tcoords = mesh.getValue("source[name=Texture].float_array", DFloatArray(null, 0)).toFloats();
		var ip = 0, vp = 0, vm = 0;
		for( p in mesh.getAll("polylist") ) {
			var vcount = p.get("vcount").value.toInts();
			var idx = p.get("p").value.toInts();
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
					vertexMap[vm++] = idx[pos];
					vertexes[vp++] = points[vidx];
					vertexes[vp++] = points[vidx + 2]; // inverse Y/Z
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
	
	public function initSkeleton( jointPerVertex : Int ) {
		if( mesh.controller == null )
			throw mesh.name + " does not have a controller";
		this.jointPerVertex = jointPerVertex;
		this.jointIndexes = new flash.Vector(jointPerVertex * vertexCount);
		this.jointWeights = new flash.Vector(jointPerVertex * vertexCount);
		
		var skin = mesh.controller.get("skin");
		var jweights = skin.get("source[name=weights].float_array").value.toFloats();
		var vcount = skin.get("vertex_weights.vcount").value.toInts();
		var values = skin.get("vertex_weights.v").value.toInts();
		var pos = 0, out = 0;
		for( v in vcount ) {
			if( v <= jointPerVertex ) {
				for( i in 0...v ) {
					jointIndexes[out] = values[pos++];
					jointWeights[out] = jweights[values[pos++]];
					out++;
				}
				for( k in v...jointPerVertex ) {
					jointIndexes[out] = 0;
					jointWeights[out] = 0;
					out++;
				}
			} else {
				var all = [];
				for( i in 0...v )
					all.push({
						i : values[pos++],
						w : jweights[values[pos++]]
					});
				all.sort(function(a, b) return Reflect.compare(b.w, a.w));
				// normalize weights
				var tot = 0.;
				for( i in 0...jointPerVertex )
					tot += all[i].w;
				for( i in 0...jointPerVertex ) {
					jointIndexes[out] = all[i].i;
					jointWeights[out] = all[i].w / tot;
					out++;
				}
			}
		}
	}
	
	override function alloc( engine : h3d.Engine ) {
		buffer = engine.mem.allocVector(vertexes, 8, 0);
		indexes = engine.mem.allocIndex(indices);
	}
	
}