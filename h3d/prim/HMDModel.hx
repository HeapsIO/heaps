package h3d.prim;

class HMDModel extends MeshPrimitive {

	var data : hxd.fmt.hmd.Data.Geometry;
	var dataPosition : Int;
	var indexCount : Int;
	var indexesTriPos : Array<Int>;
	var entry : hxd.res.FileEntry;
	var curMaterial : Int;

	public function new(data, dataPos, entry) {
		this.data = data;
		this.dataPosition = dataPos;
		this.entry = entry;
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

}