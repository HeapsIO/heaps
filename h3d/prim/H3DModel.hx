package h3d.prim;

class H3DModel extends MeshPrimitive {

	var data : hxd.fmt.h3d.Data.Geometry;
	var dataPosition : Int;
	var entry : hxd.res.FileEntry;

	public function new(data, dataPos, entry) {
		this.data = data;
		this.dataPosition = dataPos;
		this.entry = entry;
	}

	override function alloc(engine:h3d.Engine) {
		dispose();
		buffer = new h3d.Buffer(data.vertexCount, data.vertexStride);

		entry.open();

		entry.skip(dataPosition + data.vertexPosition);
		var size = data.vertexCount * data.vertexStride * 4;
		var bytes = hxd.impl.Tmp.getBytes(size);
		entry.read(bytes, 0, size);
		buffer.uploadBytes(bytes, 0, data.vertexCount);
		hxd.impl.Tmp.saveBytes(bytes);

		indexes = new h3d.Indexes(data.indexCount);

		entry.skip(data.indexPosition - (data.vertexPosition + size));
		var bytes = hxd.impl.Tmp.getBytes(data.indexCount * 2);
		entry.read(bytes, 0, data.indexCount * 2);
		indexes.uploadBytes(bytes, 0, data.indexCount);
		hxd.impl.Tmp.saveBytes(bytes);

		entry.close();

		var pos = 0;
		for( f in data.vertexFormat ) {
			addBuffer(f.name, buffer, pos);
			var stride = switch( f.format ) {
			case DVec4: 4;
			case DVec3: 3;
			case DVec2: 2;
			case DFloat, DBytes4: 1;
			}
			pos += stride;
		}
	}

}