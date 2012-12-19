package h3d.prim;
using h3d.fbx.Data;
import h3d.impl.Buffer.BufferOffset;

class FBXModel extends MeshPrimitive {

	public var geom(default, null) : h3d.fbx.Geometry;
	public var skin : Skin;
	
	public function new(g) {
		this.geom = g;
	}
	
	// not very good, but...
	inline function int32ToFloat( ix : Int ) {
		flash.Memory.setI32(0, ix);
		return flash.Memory.getFloat(0);
	}
	
	public function getVerticesCount() {
		return Std.int(geom.getVertices().length / 3);
	}
	
	override function alloc( engine : h3d.Engine ) {
		dispose();
		
		var verts = geom.getVertices();
		var norms = geom.getNormals();
		var tuvs = geom.getUVs()[0];
		
		var gt = geom.getGeomTranslate();
		if( gt == null ) gt = new h3d.Point();
		
		var idx = new flash.Vector<UInt>();
		var pbuf = new flash.Vector<Float>(), nbuf = (norms == null ? null : new flash.Vector<Float>()), sbuf = (skin == null ? null : new flash.Vector<Float>()), tbuf = (tuvs == null ? null : new flash.Vector<Float>());
		var pout = 0, nout = 0, sout = 0, tout = 0;
	
		var tmp = new flash.utils.ByteArray();
		tmp.length = 1024;
		flash.Memory.select(tmp);
		
		// triangulize indexes : format is  A,B,...,-X : negative values mark the end of the polygon
		var count = 0, pos = 0;
		var index = geom.getPolygons();
		for( i in index ) {
			count++;
			if( i < 0 ) {
				index[pos] = -i - 1;
				var start = pos - count + 1;
				for( n in 0...count ) {
					var k = n + start;
					var vidx = index[k];
					
					pbuf[pout++] = verts[vidx*3] + gt.x;
					pbuf[pout++] = verts[vidx*3 + 1] + gt.y;
					pbuf[pout++] = verts[vidx*3 + 2] + gt.z;

					if( nbuf != null ) {
						nbuf[nout++] = norms[k*3];
						nbuf[nout++] = norms[k*3 + 1];
						nbuf[nout++] = norms[k*3 + 2];
					}

					if( tbuf != null ) {
						var iuv = tuvs.index[k];
						tbuf[tout++] = tuvs.values[iuv*2];
						tbuf[tout++] = 1 - tuvs.values[iuv * 2 + 1];
					}
					
					if( sbuf != null ) {
						var p = vidx * skin.bonesPerVertex;
						var idx = 0;
						for( i in 0...skin.bonesPerVertex ) {
							sbuf[sout++] = skin.vertexWeights[p + i];
							idx = (skin.vertexJoints[p + i] << (8*i)) | idx;
						}
						sbuf[sout++] = int32ToFloat(idx);
					}
				}
				// polygons are actually triangle fans
				for( n in 0...count - 2 ) {
					idx.push(start);
					idx.push(start + n + 2);
					idx.push(start + n + 1);
				}
				index[pos] = i; // restore
				count = 0;
			}
			pos++;
		}
		
		addBuffer("pos", engine.mem.allocVector(pbuf, 3, 0));
		if( nbuf != null ) addBuffer("norm", engine.mem.allocVector(nbuf, 3, 0));
		if( tbuf != null ) addBuffer("uv", engine.mem.allocVector(tbuf, 2, 0));
		if( sbuf != null ) {
			var skinBuf = engine.mem.allocVector(sbuf, skin.bonesPerVertex + 1, 0);
			addBuffer("weights", skinBuf, 0);
			addBuffer("indexes", skinBuf, skin.bonesPerVertex);
		}
		
		indexes = engine.mem.allocIndex(idx);
	}
	
}
