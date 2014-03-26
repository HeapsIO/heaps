package h3d.prim;
using h3d.fbx.Data;
import h3d.Buffer.BufferOffset;
import h3d.col.Point;

class FBXModel extends MeshPrimitive {

	public var geom(default, null) : h3d.fbx.Geometry;
	public var skin : h3d.anim.Skin;
	public var multiMaterial : Bool;
	var bounds : h3d.col.Bounds;
	var curMaterial : Int;
	var groupIndexes : Array<Indexes>;

	public function new(g) {
		this.geom = g;
		curMaterial = -1;
	}
	
	public function getVerticesCount() {
		return Std.int(geom.getVertices().length / 3);
	}
	
	override function getBounds() {
		if( bounds != null )
			return bounds;
		bounds = new h3d.col.Bounds();
		var verts = geom.getVertices();
		var gt = geom.getGeomTranslate();
		if( gt == null ) gt = new Point();
		if( verts.length > 0 ) {
			bounds.xMin = bounds.xMax = verts[0] + gt.x;
			bounds.yMin = bounds.yMax = verts[1] + gt.y;
			bounds.zMin = bounds.zMax = verts[2] + gt.z;
		}
		var pos = 3;
		for( i in 1...Std.int(verts.length / 3) ) {
			var x = verts[pos++] + gt.x;
			var y = verts[pos++] + gt.y;
			var z = verts[pos++] + gt.z;
			if( x > bounds.xMax ) bounds.xMax = x;
			if( x < bounds.xMin ) bounds.xMin = x;
			if( y > bounds.yMax ) bounds.yMax = y;
			if( y < bounds.yMin ) bounds.yMin = y;
			if( z > bounds.zMax ) bounds.zMax = z;
			if( z < bounds.zMin ) bounds.zMin = z;
		}
		return bounds;
	}
	
	override function render( engine : h3d.Engine ) {
		if( curMaterial < 0 ) {
			super.render(engine);
			return;
		}
		if( indexes == null || indexes.isDisposed() )
			alloc(engine);
		var idx = indexes;
		indexes = groupIndexes[curMaterial];
		if( indexes != null ) super.render(engine);
		indexes = idx;
		curMaterial = -1;
	}
	
	override function selectMaterial( material : Int ) {
		curMaterial = material;
	}
	
	override function dispose() {
		super.dispose();
		if( groupIndexes != null ) {
			for( i in groupIndexes )
				if( i != null )
					i.dispose();
			groupIndexes = null;
		}
	}
	
	override function alloc( engine : h3d.Engine ) {
		dispose();
		
		var verts = geom.getVertices();
		var norms = geom.getNormals();
		var tuvs = geom.getUVs()[0];
		var colors = geom.getColors();
		var mats = multiMaterial ? geom.getMaterials() : null;
		
		var gt = geom.getGeomTranslate();
		if( gt == null ) gt = new Point();
		
		var idx = new hxd.IndexBuffer();
		var midx = new Array<hxd.IndexBuffer>();
		var pbuf = new hxd.FloatBuffer(), nbuf = (norms == null ? null : new hxd.FloatBuffer()), sbuf = (skin == null ? null : new hxd.BytesBuffer()), tbuf = (tuvs == null ? null : new hxd.FloatBuffer());
		var cbuf = (colors == null ? null : new hxd.FloatBuffer());
		
		// skin split
		var sidx = null, stri = 0;
		if( skin != null && skin.isSplit() ) {
			if( multiMaterial ) throw "Multimaterial not supported with skin split";
			sidx = [for( _ in skin.splitJoints ) new hxd.IndexBuffer()];
		}
		
		// triangulize indexes : format is  A,B,...,-X : negative values mark the end of the polygon
		var count = 0, pos = 0, matPos = 0;
		var index = geom.getPolygons();
		for( i in index ) {
			count++;
			if( i < 0 ) {
				index[pos] = -i - 1;
				var start = pos - count + 1;
				for( n in 0...count ) {
					var k = n + start;
					var vidx = index[k];
					
					var x = verts[vidx * 3] + gt.x;
					var y = verts[vidx * 3 + 1] + gt.y;
					var z = verts[vidx * 3 + 2] + gt.z;
					pbuf.push(x);
					pbuf.push(y);
					pbuf.push(z);

					if( nbuf != null ) {
						nbuf.push(norms[k*3]);
						nbuf.push(norms[k*3 + 1]);
						nbuf.push(norms[k*3 + 2]);
					}

					if( tbuf != null ) {
						var iuv = tuvs.index[k];
						tbuf.push(tuvs.values[iuv*2]);
						tbuf.push(1 - tuvs.values[iuv * 2 + 1]);
					}
					
					if( sbuf != null ) {
						var p = vidx * skin.bonesPerVertex;
						var idx = 0;
						for( i in 0...skin.bonesPerVertex ) {
							sbuf.writeFloat(skin.vertexWeights[p + i]);
							idx = (skin.vertexJoints[p + i] << (8*i)) | idx;
						}
						sbuf.writeInt32(idx);
					}
					
					if( cbuf != null ) {
						var icol = colors.index[k];
						cbuf.push(colors.values[icol * 4]);
						cbuf.push(colors.values[icol * 4 + 1]);
						cbuf.push(colors.values[icol * 4 + 2]);
					}
				}
				// polygons are actually triangle fans
				for( n in 0...count - 2 ) {
					idx.push(start + n);
					idx.push(start + count - 1);
					idx.push(start + n + 1);
				}
				// by-skin-group index
				if( skin != null && skin.isSplit() ) {
					for( n in 0...count - 2 ) {
						var idx = sidx[skin.triangleGroups[stri++]];
						idx.push(start + n);
						idx.push(start + count - 1);
						idx.push(start + n + 1);
					}
				}
				// by-material index
				if( mats != null ) {
					var mid = mats[matPos++];
					var idx = midx[mid];
					if( idx == null ) {
						idx = new hxd.IndexBuffer();
						midx[mid] = idx;
					}
					for( n in 0...count - 2 ) {
						idx.push(start + n);
						idx.push(start + count - 1);
						idx.push(start + n + 1);
					}
				}
				index[pos] = i; // restore
				count = 0;
			}
			pos++;
		}
		
		addBuffer("pos", h3d.Buffer.ofFloats(pbuf, 3));
		if( nbuf != null ) addBuffer("normal", h3d.Buffer.ofFloats(nbuf, 3));
		if( tbuf != null ) addBuffer("uv", h3d.Buffer.ofFloats(tbuf, 2));
		if( sbuf != null ) {
			var nverts = Std.int(sbuf.length / ((skin.bonesPerVertex + 1) * 4));
			var skinBuf = new h3d.Buffer(nverts, skin.bonesPerVertex + 1);
			skinBuf.uploadBytes(sbuf.getBytes(), 0, nverts);
			addBuffer("weights", skinBuf, 0);
			addBuffer("indexes", skinBuf, skin.bonesPerVertex);
		}
		if( cbuf != null ) addBuffer("color", h3d.Buffer.ofFloats(cbuf, 3));
		
		indexes = h3d.Indexes.alloc(idx);
		if( mats != null ) {
			groupIndexes = [];
			for( i in midx )
				groupIndexes.push(i == null ? null : h3d.Indexes.alloc(i));
		}
		if( sidx != null ) {
			groupIndexes = [];
			for( i in sidx )
				groupIndexes.push(i == null ? null : h3d.Indexes.alloc(i));
		}
	}
	
}
