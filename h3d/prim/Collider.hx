package h3d.prim;

import hxd.fmt.hmd.Library.GeometryBuffer;

@:access(h3d.prim.HMDModel)
class Collider {

	var hmdModel : HMDModel;
	var data : hxd.fmt.hmd.Data.Collider;

	public static function fromHmd(hmdModel : HMDModel) {
		var header = hmdModel.lib.header;
		for( h in header.models )
			if( header.geometries[h.geometry] == hmdModel.data ) {
				return new Collider(hmdModel, header.colliders[h.collider]);
			}
		return null;
	}

	function new(hmdModel : HMDModel, data : hxd.fmt.hmd.Data.Collider) {
		this.hmdModel = hmdModel;
		this.data = data;
	}

	public function getBuffers() {
		var vertexPosition = hmdModel.dataPosition + data.vertexPosition;
		var indexPosition = hmdModel.dataPosition + data.indexPosition;

		var buffers = [];
		for ( i in 0...data.vertexCounts.length ) {
			var vertexCount = data.vertexCounts[i];
			var indexCount = data.indexCounts[i];

			var is32 = vertexCount > 0x10000;
			var vSize = vertexCount * 3 * 4;

			var vertexBytes = haxe.io.Bytes.alloc(vSize);
			hmdModel.lib.resource.entry.readBytes(vertexBytes, 0, vertexPosition, vSize);

			var buf = new GeometryBuffer();
			buf.vertexes = new haxe.ds.Vector(3 * vertexCount);
			for ( i in 0...3 * vertexCount)
				buf.vertexes[i] = vertexBytes.getFloat(i * 4);

			var iSize = indexCount * (is32 ? 4 : 2);
			var indexBytes = haxe.io.Bytes.alloc(iSize);
			hmdModel.lib.resource.entry.readBytes(indexBytes, 0, indexPosition, iSize);

			buf.indexes = new haxe.ds.Vector(indexCount);
			var stride = is32 ? 4 : 2;
			if ( is32 )
				for ( i in 0...indexCount )
					buf.indexes[i] = indexBytes.getInt32(i * stride);
			else
				for ( i in 0...indexCount )
					buf.indexes[i] = indexBytes.getUInt16(i * stride);

			buffers.push(buf);

			vertexPosition += vSize;
			indexPosition += iSize;
		}
		return buffers;
	}
}