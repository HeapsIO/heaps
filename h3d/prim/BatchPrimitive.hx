package h3d.prim;

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
	static var SUBMESH_INFOS_FMT = hxd.BufferFormat.make([{ name : "lodStart", type : DFloat }, { name : "lodCount", type : DFloat }]);
	static var SUBPART_INFOS_FMT = hxd.BufferFormat.make([{ name : "indexCount", type : DFloat }, { name : "indexStart", type : DFloat }]);
	static var LOD_INFOS_FMT = hxd.BufferFormat.make([{ name : "screenRatio", type : DFloat }]);

	public var vertexFormat(default, null) : hxd.BufferFormat;
	public var subMeshes(default, null) : Array<SubMesh> = [];
	var models(default, null) : Array<h3d.prim.HMDModel> = [];
	var bounds = new h3d.col.Bounds();
	var vbuf : haxe.io.Bytes;
	var vByteStart : Int = 0;
	var ibuf : haxe.io.Bytes;
	var iByteStart : Int = 0;

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

	public function new(format) {
		vertexFormat = format;

		vbuf = haxe.io.Bytes.alloc(0);
		ibuf = haxe.io.Bytes.alloc(0);
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
			var vByteNeeded = vByteStart + vByteSize;
			if ( vByteNeeded > vbuf.length ) {
				var oldVbuf = vbuf;
				vbuf = haxe.io.Bytes.alloc( (vByteNeeded >> 1) * 3 );
				vbuf.blit(0, oldVbuf, 0, vByteStart);
			}
			var vertices = entry.fetchBytes(dataPosition + lod.vertexPosition, vByteSize);
			vbuf.blit(vByteStart, vertices, 0, vByteSize);

			var iCount = lod.indexCount;
			var iByteSize = iCount * 4;
			var iByteNeeded = iByteStart + iByteSize;
			if ( iByteNeeded > ibuf.length ) {
				var oldIbuf = ibuf;
				ibuf = haxe.io.Bytes.alloc( (iByteNeeded >> 1) * 3 );
				ibuf.blit(0, oldIbuf, 0, iByteStart);
			}

			var lodIs32 = lod.vertexCount > 0x10000;
			var iLodByteSize = (lodIs32 ? 4 : 2) * iCount;
			var inIndices = entry.fetchBytes(dataPosition + lod.indexPosition, iLodByteSize);
			var outIndices : haxe.io.Bytes = !lodIs32 ? haxe.io.Bytes.alloc( iCount * 4 ) : inIndices;
			var vStart = Std.int(vByteStart / vertexFormat.strideBytes);
			for ( i in 0...iCount )
				if ( lodIs32 )
					outIndices.setInt32(i << 2, inIndices.getInt32(i << 2) + vStart);
				else
					outIndices.setInt32(i << 2, inIndices.getUInt16(i << 1) + vStart);
			ibuf.blit(iByteStart, outIndices, 0, iByteSize);

			var iStart = iByteStart >> 2;
			for ( count in lod.indexCounts ) {
				indexStarts.push(iStart);
				iStart += count;
			}

			vByteStart = vByteNeeded;
			iByteStart = iByteNeeded;
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

		totalLodCount += lodCount;
		var lodNeeded = totalLodCount * LOD_INFOS_FMT.stride;
		if ( cpuLodInfos == null )
			cpuLodInfos = new hxd.FloatBuffer(lodNeeded);
		if( cpuLodInfos.length < lodNeeded )
			cpuLodInfos.grow( hxd.Math.imax((cpuLodInfos.length >> 1) * 3, lodNeeded) );

		var lodConfigHasCulling = lodConfig.length > lodCount - 1;
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

		var vCount = Std.int(vByteStart / vertexFormat.strideBytes);
		buffer = new h3d.Buffer(vCount, vertexFormat);
		buffer.uploadBytes(vbuf, 0, vCount);

		var iCount = iByteStart >> 2;
		indexes = new h3d.Indexes(iCount, true);
		indexes.uploadBytes(ibuf, 0, iCount);

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