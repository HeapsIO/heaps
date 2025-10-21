package h3d.prim;

import hxd.fmt.hmd.Library.GeometryBuffer;

@:access(h3d.prim.HMDModel)
class ColliderData {

	var hmdModel : HMDModel;
	var data : hxd.fmt.hmd.Data.Collider;

	public static function fromHmd( hmdModel : HMDModel ) {
		var header = hmdModel.lib.header;
		for( h in header.models )
			if( h.collider != null && header.geometries[h.geometry] == hmdModel.data ) {
				return new ColliderData(hmdModel, header.colliders[h.collider]);
			}
		return null;
	}

	function new( hmdModel : HMDModel, data : hxd.fmt.hmd.Data.Collider ) {
		this.hmdModel = hmdModel;
		this.data = data;
	}

	public function getCollider() : h3d.col.Collider {
		return getColliderFromData(this.data);
	}

	function getColliderFromData( data : hxd.fmt.hmd.Data.Collider ) : h3d.col.Collider {
		switch( data.type ) {
		case Mesh:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.MeshCollider);
			var buffers = getBuffersFromMesh(data);
			var bounds = new h3d.col.Bounds();
			var hulls : Array<h3d.col.Collider> = [];
			hulls.resize(buffers.length);
			for ( i => buf in buffers ) {
				var p = new h3d.col.PolygonBuffer();
				p.setData(buf.vertexes, buf.indexes);
				hulls[i] = p;
				bounds.add(p.getBounds());
			}
			var convexHulls = new h3d.col.Collider.GroupCollider(hulls);
			return new h3d.col.Collider.OptimizedCollider(bounds, convexHulls);
		case Group:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.GroupCollider);
			var shapes : Array<h3d.col.Collider> = [];
			for( sub in data.colliders ) {
				var c = getColliderFromData(sub);
				shapes.push(c);
			}
			return new h3d.col.Collider.GroupCollider(shapes);
		case Sphere:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.SphereCollider);
			var p = data.position;
			return new h3d.col.Sphere(p.x, p.y, p.z, data.radius);
		case Box:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.BoxCollider);
			var box = new h3d.col.Bounds();
			box.setMin(data.min);
			box.setMax(data.max);
			return box;
		case Capsule:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.CapsuleCollider);
			return new h3d.col.Capsule(data.point1, data.point2, data.radius);
		}
		return null;
	}

	function getBuffersFromMesh( data : hxd.fmt.hmd.Data.MeshCollider ) : Array<GeometryBuffer> {
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
