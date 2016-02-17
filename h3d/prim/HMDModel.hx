package h3d.prim;

class HMDModel extends MeshPrimitive {

	var data : hxd.fmt.hmd.Data.Geometry;
	var dataPosition : Int;
	var indexCount : Int;
	var indexesTriPos : Array<Int>;
	var lib : hxd.fmt.hmd.Library;
	var curMaterial : Int;
	var collider : h3d.col.RayCollider;
	var normalsRecomputed : String;

	public function new(data, dataPos, lib) {
		this.data = data;
		this.dataPosition = dataPos;
		this.lib = lib;
	}

	override function triCount() {
		return Std.int(data.indexCount / 3);
	}

	override function vertexCount() {
		return data.vertexCount;
	}

	override function getBounds() {
		return data.bounds;
	}

	override function selectMaterial( i : Int ) {
		curMaterial = i;
	}

	override function alloc(engine:h3d.Engine) {
		dispose();
		buffer = new h3d.Buffer(data.vertexCount, data.vertexStride);

		var entry = @:privateAccess lib.entry;
		entry.open();

		entry.skip(dataPosition + data.vertexPosition);
		var size = data.vertexCount * data.vertexStride * 4;
		var bytes = hxd.impl.Tmp.getBytes(size);
		entry.read(bytes, 0, size);
		buffer.uploadBytes(bytes, 0, data.vertexCount);
		hxd.impl.Tmp.saveBytes(bytes);

		indexCount = 0;
		indexesTriPos = [];
		for( n in data.indexCounts ) {
			indexesTriPos.push(Std.int(indexCount/3));
			indexCount += n;
		}
		indexes = new h3d.Indexes(indexCount);

		entry.skip(data.indexPosition - (data.vertexPosition + size));
		var bytes = hxd.impl.Tmp.getBytes(indexCount * 2);
		entry.read(bytes, 0, indexCount * 2);
		indexes.uploadBytes(bytes, 0, indexCount);
		hxd.impl.Tmp.saveBytes(bytes);

		entry.close();

		var pos = 0;
		for( f in data.vertexFormat ) {
			addBuffer(f.name, buffer, pos);
			pos += f.format.getSize();
		}

		if( normalsRecomputed != null )
			recomputeNormals(normalsRecomputed);
	}

	public function recomputeNormals( ?name : String ) {

		if( name == null ) name = "normal";

		var pos = lib.getBuffers(data, [new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3)]);
		var ids = new Array();
		var pts : Array<h3d.col.Point> = [];

		for( i in 0...data.vertexCount ) {
			var added = false;
			var pt = new h3d.col.Point(pos.vertexes[i * 3], pos.vertexes[i * 3 + 1], pos.vertexes[i * 3 + 2]);
			for(i in 0...pts.length) {
				var p = pts[i];
				if(p.x == pt.x && p.y == pt.y && p.z == pt.z) {
					ids.push(i);
					added = true;
					break;
				}
			}
			if( !added ) {
				ids.push(pts.length);
				pts.push(pt);
			}
		}

		var idx = new hxd.IndexBuffer();
		for( i in pos.indexes )
			idx.push(ids[i]);

		var pol = new Polygon(pts, idx);
		pol.addNormals();

		var v = new hxd.FloatBuffer();
		for( i in 0...data.vertexCount ) {
			var n = pol.normals[ids[i]];
			v.push(n.x);
			v.push(n.y);
			v.push(n.z);
		}
		var buf = h3d.Buffer.ofFloats(v, 3);
		addBuffer(name, buf, 0);
		normalsRecomputed = name;
	}

	override function render( engine : h3d.Engine ) {
		if( curMaterial < 0 ) {
			super.render(engine);
			return;
		}
		if( indexes == null || indexes.isDisposed() )
			alloc(engine);
		engine.renderMultiBuffers(getBuffers(engine), indexes, indexesTriPos[curMaterial], Std.int(data.indexCounts[curMaterial]/3));
		curMaterial = -1;
	}

	override function getCollider() {
		if( collider != null )
			return collider;

		var pos = lib.getBuffers(data, [new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3)]);
		var poly = new h3d.col.Polygon();
		poly.addBuffers(pos.vertexes, pos.indexes);
		var sphere = data.bounds.toSphere();
		collider = new h3d.col.RayCollider.OptimizedCollider(sphere, poly);
		return collider;
	}

}