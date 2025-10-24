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
		case ConvexHulls:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.ConvexHullsCollider);
			var buffers = getBuffersFromConvexHulls(data);
			var bounds = new h3d.col.Bounds();
			var hulls : Array<h3d.col.Collider> = [];
			hulls.resize(buffers.length);
			for ( i => buf in buffers ) {
				var p = new h3d.col.PolygonBuffer();
				p.setData(buf.vertexes, buf.indexes, 0, -1, true);
				hulls[i] = p;
				bounds.add(p.getBounds());
			}
			var convexHulls = new h3d.col.Collider.GroupCollider(hulls);
			return new h3d.col.Collider.OptimizedCollider(bounds, convexHulls);
		case Mesh:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.MeshCollider);
			var buf = getBufferFromMesh(data.vertexCount, data.vertexPosition, data.indexCount, data.indexPosition);
			var p = new h3d.col.PolygonBuffer();
			p.setData(buf.vertexes, buf.indexes);
			return new h3d.col.Collider.OptimizedCollider(p.getBounds(), p);
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
			var mat = Matrix.I();
			var size = data.halfExtent * 2;
			mat.scale(size.x, size.y, size.z);
			mat.rotate(data.rotation.x, data.rotation.y, data.rotation.z);
			mat.translate(data.position.x, data.position.y, data.position.z);
			var box = new h3d.col.OrientedBounds();
			box.setMatrix(mat);
			return box;
		case Capsule:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.CapsuleCollider);
			var point1 = data.position + data.halfExtent;
			var point2 = data.position - data.halfExtent;
			return new h3d.col.Capsule(point1, point2, data.radius);
		case Cylinder:
			var data = Std.downcast(data, hxd.fmt.hmd.Data.CylinderCollider);
			var point1 = data.position + data.halfExtent;
			var point2 = data.position - data.halfExtent;
			return new h3d.col.Cylinder(point1, point2, data.radius);
		}
		return null;
	}

	function getBufferFromMesh( vertexCount : Int, vertexPosition : Int, indexCount : Int, indexPosition : Int) : GeometryBuffer {
		var vertexPosition = hmdModel.dataPosition + vertexPosition;
		var indexPosition = hmdModel.dataPosition + indexPosition;
		var buf = new GeometryBuffer();
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

		return buf;
	}

	function getBuffersFromConvexHulls( data : hxd.fmt.hmd.Data.ConvexHullsCollider ) : Array<GeometryBuffer> {
		var vertexPosition = data.vertexPosition;
		var indexPosition = data.indexPosition;

		var buffers = [];
		for ( i in 0...data.vertexCounts.length ) {
			var vertexCount = data.vertexCounts[i];
			var indexCount = data.indexCounts[i];

			var buf = getBufferFromMesh(vertexCount, vertexPosition, indexCount, indexPosition);
			buffers.push(buf);

			var is32 = vertexCount > 0x10000;
			vertexPosition += vertexCount * 3 * 4;
			indexPosition += indexCount * (is32 ? 4 : 2);
		}
		return buffers;
	}
}
