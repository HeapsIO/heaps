package h3d.prim;

class BytesArray {
	public var bytes(default, null) : Array<haxe.io.Bytes>;
	public var pos(default, null) : Array<Int>;
	public var totalSize(default, null) : Int;
	var maxSize : Int;

	public function new(bSize: Int, maxSize : Int) {
		if ( bSize > maxSize && maxSize > 0 )
			throw "assert";
		this.maxSize = maxSize;
		bytes = [haxe.io.Bytes.alloc(bSize)];
		pos = [0];
	}

	public function alloc(bSize : Int) : { b : haxe.io.Bytes, pos : Int } {
		if ( bSize > maxSize && maxSize > 0 )
			throw "assert";
		totalSize += bSize;
		var bIdx = bytes.length - 1;
		var b = bytes[bIdx];
		var bStart = pos[bIdx];
		var bNeeded = bStart + bSize;
		if ( bNeeded > b.length ) {
			if ( bNeeded < maxSize || maxSize < 0 ) {
				var oldB = b;
				b = bytes[bIdx] = haxe.io.Bytes.alloc( (bNeeded >> 1) * 3 );
				b.blit(0, oldB, 0, bStart);
			} else {
				b = bytes[++bIdx] = haxe.io.Bytes.alloc(bSize);
				bNeeded = bSize;
				bStart = 0;
			}
		}
		pos[bIdx] = bNeeded;
		return { b : b, pos : bStart };
	}

	public function upload( buffer : h3d.Buffer, vStart : Int = 0 ) {
		for ( i => b in bytes ) {
			var vCount = Std.int(pos[i] / buffer.format.strideBytes);
			buffer.uploadBytes(b, 0, vCount, vStart);
			vStart += vCount;
		}
	}
}

class SubMesh {
	public var subParts : Array<SubPart>;
	public var subPartStart : Int;
	public var bounds : h3d.col.Bounds;
	public var lodCount : Int;
	public var lodConfig : Array<Float>;
	public function new() {
	}
}

class SubPart {
	public var indexStarts : Array<Int>;
	public var indexCounts : Array<Int>;
	public function new() {
	}
}

@:access(h3d.prim.HMDModel)
class BatchPrimitive extends MeshPrimitive {
	static var SUBMESH_INFOS_FMT = hxd.BufferFormat.make([{ name : "lodStart", type : DFloat }, { name : "lodCount", type : DFloat },{ name : "boudingSphere", type : DFloat }]);
	static var SUBPART_INFOS_FMT = hxd.BufferFormat.make([{ name : "indexCount", type : DFloat }, { name : "indexStart", type : DFloat }]);
	static var LOD_INFOS_FMT = hxd.BufferFormat.make([{ name : "screenRatio", type : DFloat }]);

	public var vertexFormat(default, null) : hxd.BufferFormat;
	public var subMeshes(default, null) : Array<SubMesh> = [];
	var models(default, null) : Array<h3d.prim.HMDModel> = [];
	var bounds = new h3d.col.Bounds();

	var vBytes : BytesArray;
	var iBytes : BytesArray;
	var maxByteSize = -1;

	var subMeshCount : Int = 0;
	public var cpuSubMeshInfos : haxe.io.Bytes;
	public var gpuSubMeshInfos : h3d.Buffer;
	var subPartCount : Int = 0;
	public var cpuSubPartInfos : haxe.io.Bytes;
	public var gpuSubPartInfos : h3d.Buffer;
	var totalLodCount : Int = 0;
	public var cpuLodInfos : hxd.FloatBuffer;
	public var gpuLodInfos : h3d.Buffer;

	var logicNormals : hxd.FloatBuffer;
	public var hasLogicNormal(get, never) : Bool;
	function get_hasLogicNormal() return logicNormals != null;

	public function new(format, maxByteSize = -1) {
		vertexFormat = format;
		this.maxByteSize = maxByteSize;
	}

	public function addModel( model : h3d.prim.HMDModel ) : Int {
		if ( model.data.vertexFormat != vertexFormat )
			throw "assert";
		var subMeshID = models.indexOf(model);
		if ( subMeshID >= 0 )
			return subMeshID;
		dispose();
		subMeshID = models.length;
		models.push(model);
		fillModel(model);
		return subMeshID;
	}

	public function addLogicNormal() {
		if ( hasLogicNormal )
			return;
		logicNormals = new hxd.FloatBuffer();
		for ( m in models )
			fillLogicNormal(m);
		addBuffer(h3d.Buffer.ofFloats(logicNormals, hxd.BufferFormat.make([{ name : "logicNormal", type : DVec3 }])));
	}

	public function getSubMeshID( model : h3d.prim.HMDModel ) {
		return models.indexOf(model);
	}

	function fillModel( model : h3d.prim.HMDModel ) {
		var subMesh = new SubMesh();
		subMesh.bounds = model.getBounds();
		bounds.add(subMesh.bounds);
		var lodCount = subMesh.lodCount = model.lods.length;
		subMesh.lodConfig = model.lodConfig;
		subMesh.subParts = [];
		subMesh.subPartStart = subPartCount;
		var dataPosition = model.dataPosition;
		var entry = model.lib.resource.entry;

		var indexStarts = [];
		var matCount = model.data.indexCounts.length;

		for ( lod in model.lods ) {
			var vByteSize = lod.vertexCount * vertexFormat.strideBytes;
			if ( vBytes == null )
				vBytes = new BytesArray(vByteSize, maxByteSize);
			var vStart = Std.int(vBytes.totalSize / vertexFormat.strideBytes);
			var vAlloc = vBytes.alloc(vByteSize);
			var vbuf = vAlloc.b;
			var vByteStart = vAlloc.pos;
			var vertices = entry.fetchBytes(dataPosition + lod.vertexPosition, vByteSize);
			vbuf.blit(vByteStart, vertices, 0, vByteSize);

			var iCount = lod.indexCount;
			var iByteSize = iCount * 4;
			if ( iBytes == null )
				iBytes = new BytesArray(iByteSize, maxByteSize);

			var iStart = iBytes.totalSize >> 2;
			for ( count in lod.indexCounts ) {
				indexStarts.push(iStart);
				iStart += count;
			}

			var iAlloc = iBytes.alloc(iByteSize);
			var ibuf = iAlloc.b;
			var iByteStart = iAlloc.pos;

			var lodIs32 = lod.vertexCount > 0x10000;
			var iLodByteSize = (lodIs32 ? 4 : 2) * iCount;
			var indices = entry.fetchBytes(dataPosition + lod.indexPosition, iLodByteSize);
			for ( i in 0...iCount )
				if ( lodIs32 )
					ibuf.setInt32(iByteStart + (i << 2), indices.getInt32(i << 2) + vStart);
				else
					ibuf.setInt32(iByteStart + (i << 2), indices.getUInt16(i << 1) + vStart);
		}

		for ( matIdx in 0...matCount ) {
			var subPart = new SubPart();
			subPart.indexStarts = [];
			subPart.indexCounts = [];
			for ( lodIdx => lod in model.lods ) {
				subPart.indexStarts.push( indexStarts[lodIdx * matCount + matIdx] );
				subPart.indexCounts.push( lod.indexCounts[matIdx] );
			}
			subMesh.subParts.push( subPart );
		};

		subMeshes.push( subMesh );
		fillSubMeshInfos( subMesh );
	}

	function fillSubMeshInfos( subMesh : SubMesh ) {
		var subMeshID = subMeshCount++;
		var subMeshNeeded = subMeshCount * SUBMESH_INFOS_FMT.strideBytes;
		if ( cpuSubMeshInfos == null )
			cpuSubMeshInfos = haxe.io.Bytes.alloc(subMeshNeeded);
		if ( cpuSubMeshInfos.length < subMeshNeeded ) {
			var old = cpuSubMeshInfos;
			cpuSubMeshInfos = haxe.io.Bytes.alloc(hxd.Math.imax((old.length >> 1) * 3, subMeshNeeded));
			cpuSubMeshInfos.blit(0, old, 0, old.length);
		}

		var lodCount = subMesh.lodCount;
		var lodConfig = subMesh.lodConfig ?? [0.0];

		var subMeshStart = subMeshID * SUBMESH_INFOS_FMT.strideBytes;
		var lodStart = totalLodCount * LOD_INFOS_FMT.stride;
		cpuSubMeshInfos.setInt32(subMeshStart + 0, lodStart);
		cpuSubMeshInfos.setInt32(subMeshStart + 4, lodCount);
		cpuSubMeshInfos.setFloat(subMeshStart + 8, subMesh.bounds.getBoundingRadius());

		totalLodCount += lodCount;
		var lodNeeded = totalLodCount * LOD_INFOS_FMT.stride;
		if ( cpuLodInfos == null )
			cpuLodInfos = new hxd.FloatBuffer(lodNeeded);
		if( cpuLodInfos.length < lodNeeded )
			cpuLodInfos.grow( hxd.Math.imax((cpuLodInfos.length >> 1) * 3, lodNeeded) );

		var lodConfigHasCulling = lodConfig.length > lodCount - 1 && lodCount > 1;
		var minScreenRatioCulling = lodConfigHasCulling ? lodConfig[lodConfig.length - 1] : 0.0;
		for ( lodIndex in 0...lodCount )
			cpuLodInfos[lodStart + lodIndex] = lodIndex < lodConfig.length ? lodConfig[lodIndex] : 0.0;
		cpuLodInfos[totalLodCount - 1] = minScreenRatioCulling;

		var subParts = subMesh.subParts;
		var subPartNeeded = (subPartCount + subParts.length * lodCount) * SUBPART_INFOS_FMT.strideBytes;
		if ( cpuSubPartInfos == null )
			cpuSubPartInfos = haxe.io.Bytes.alloc(subPartNeeded);
		if ( cpuSubPartInfos.length < subPartNeeded ) {
			var old = cpuSubPartInfos;
			cpuSubPartInfos = haxe.io.Bytes.alloc(hxd.Math.imax((cpuSubPartInfos.length >> 1) * 3, subPartNeeded));
			cpuSubPartInfos.blit(0, old, 0, old.length);
		}

		var subPartStart = subPartCount * SUBPART_INFOS_FMT.strideBytes;
		for ( subPart in subParts ) {
			for ( lodIndex in 0...lodCount ) {
				cpuSubPartInfos.setInt32(subPartStart + 0, subPart.indexCounts[lodIndex]);
				cpuSubPartInfos.setInt32(subPartStart + 4, subPart.indexStarts[lodIndex]);
				subPartStart += SUBPART_INFOS_FMT.strideBytes;
			}
		}
		subPartCount += subParts.length * lodCount;
	}

	function fillLogicNormal( model : h3d.prim.HMDModel ) @:privateAccess {
		var lods = model.lods;
		for ( lod in lods ) {
			var pos = model.lib.getBuffers(lod, hxd.BufferFormat.POS3D);
			var ids = new Array();
			var pts : Array<h3d.col.Point> = [];
			var mpts = new Map();

			for( i in 0...lod.vertexCount ) {
				var added = false;
				var px = pos.vertexes[i * 3];
				var py = pos.vertexes[i * 3 + 1];
				var pz = pos.vertexes[i * 3 + 2];
				var pid = Std.int((px + py + pz) * 10.01);
				var arr = mpts.get(pid);
				if( arr == null ) {
					arr = [];
					mpts.set(pid, arr);
				} else {
					for( idx in arr ) {
						var p = pts[idx];
						if( p.x == px && p.y == py && p.z == pz ) {
							ids.push(idx);
							added = true;
							break;
						}
					}
				}
				if( !added ) {
					ids.push(pts.length);
					arr.push(pts.length);
					pts.push(new h3d.col.Point(px,py,pz));
				}
			}

			var idx = new hxd.IndexBuffer();
			for( i in pos.indexes )
				idx.push(ids[i]);

			var pol = new Polygon(pts, idx);
			pol.addNormals();

			var startOffset : Int = logicNormals.length;
			logicNormals.grow(lod.vertexCount*3);
			var k = 0;
			for( i in 0...lod.vertexCount ) {
				var n = pol.normals[ids[i]];
				logicNormals[startOffset + k++] = n.x;
				logicNormals[startOffset + k++] = n.y;
				logicNormals[startOffset + k++] = n.z;
			}
		}
	}

	override function dispose() {
		super.dispose();
		gpuSubMeshInfos?.dispose();
		gpuSubPartInfos?.dispose();
		gpuLodInfos?.dispose();
	}

	override public function alloc( engine : h3d.Engine ) {
		dispose();

		var vCount = Std.int(vBytes.totalSize / vertexFormat.strideBytes);
		buffer = new h3d.Buffer(vCount, vertexFormat);
		vBytes.upload(buffer);

		var iCount = iBytes.totalSize >> 2;
		indexes = new h3d.Indexes(iCount, true);
		iBytes.upload(indexes);

		if ( hasLogicNormal )
			addBuffer(h3d.Buffer.ofFloats(logicNormals, hxd.BufferFormat.make([{ name : "logicNormal", type : DVec3 }])));

		gpuSubMeshInfos = new h3d.Buffer(subMeshCount, SUBMESH_INFOS_FMT, [UniformBuffer]);
		gpuSubMeshInfos.uploadBytes(cpuSubMeshInfos, 0, subMeshCount, 0);
		gpuSubPartInfos = new h3d.Buffer(subPartCount, SUBPART_INFOS_FMT, [UniformBuffer]);
		gpuSubPartInfos.uploadBytes(cpuSubPartInfos, 0, subPartCount, 0);
		gpuLodInfos = new h3d.Buffer(totalLodCount, LOD_INFOS_FMT, [UniformBuffer]);
		gpuLodInfos.uploadFloats(cpuLodInfos, 0, totalLodCount, 0);
	}

	override public function getBounds() : h3d.col.Bounds {
		return bounds;
	}
}