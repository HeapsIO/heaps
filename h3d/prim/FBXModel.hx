package h3d.prim;
using h3d.fbx.Data;

class FBXModel extends Primitive {

	public var mesh(default, null) : h3d.fbx.Mesh;
	public var skin(default, null) : h3d.fbx.Skin;
	var anims(default, null) : Hash<Skin.Animation>;
	
	public function new(m) {
		this.mesh = m;
		skin = m.getSkin();
		anims = new Hash();
	}
	
	public function getAnimation( name : String ) {
		var a = anims.get(name);
		if( a == null ) {
			if( skin == null ) throw "No skin";
			a = skin.getAnimation(name);
			anims.set(name, a);
		}
		return a;
	}
	
	// not very good, but...
	inline function int32ToFloat( ix : Int ) {
		flash.Memory.setI32(0, ix);
		return flash.Memory.getFloat(0);
	}
	
	override function alloc( engine : h3d.Engine ) {
		dispose();
		
		var verts = mesh.getVertices();
		var norms = mesh.getNormals();
		var tuvs = mesh.getUVs()[0];
		
		var idx = new flash.Vector<UInt>();
		var buf = new flash.Vector<Float>();
		var out = 0;
	
		var tmp = new flash.utils.ByteArray();
		tmp.length = 1024;
		flash.Memory.select(tmp);
		
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
					var vidx = index[k];
					
					buf[out++] = verts[vidx*3];
					buf[out++] = verts[vidx*3 + 1];
					buf[out++] = verts[vidx*3 + 2];

					buf[out++] = norms[k*3];
					buf[out++] = norms[k*3 + 1];
					buf[out++] = norms[k*3 + 2];

					var iuv = tuvs.index[k];
					buf[out++] = tuvs.values[iuv*2];
					buf[out++] = 1 - tuvs.values[iuv*2 + 1];
					
					if( skin != null ) {
						var p = vidx * skin.bonesPerVertex;
						var idx = 0;
						for( i in 0...skin.bonesPerVertex ) {
							buf[out++] = skin.vertexWeights[p + i];
							idx = (skin.vertexJoints[p + i] << (8*i)) | idx;
						}
						buf[out++] = int32ToFloat(idx);
					}
				}
				// polygons are actually triangle fans
				for( n in 0...count - 2 ) {
					idx.push(start);
					idx.push(start + n + 1);
					idx.push(start + n + 2);
				}
				index[pos] = i; // restore
				count = 0;
			}
			pos++;
		}

		var size = skin == null ? 8 : (8 + 1 + skin.bonesPerVertex);
		buffer = engine.mem.allocVector(buf, size, 0);
		indexes = engine.mem.allocIndex(idx);
	}
	
}
