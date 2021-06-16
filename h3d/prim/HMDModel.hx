package h3d.prim;

class HMDModel extends MeshPrimitive {

	var data : hxd.fmt.hmd.Data.Geometry;
	var dataPosition : Int;
	var indexCount : Int;
	var indexesTriPos : Array<Int>;
	var lib : hxd.fmt.hmd.Library;
	var curMaterial : Int;
	var collider : h3d.col.Collider;
	var normalsRecomputed : String;
	var bufferAliases : Map<String,{ realName : String, offset : Int }> = new Map();

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

	override function getMaterialIndexes(material:Int):{count:Int, start:Int} {
		return { start : indexesTriPos[material]*3, count : data.indexCounts[material] };
	}

	public function getDataBuffers(fmt, ?defaults,?material) {
		return lib.getBuffers(data, fmt, defaults, material);
	}

	public function loadSkin(skin) {
		lib.loadSkin(data, skin);
	}

	public function addAlias( name : String, realName : String, offset = 0 ) {
		var old = bufferAliases.get(name);
		if( old != null ) {
			if( old.realName != realName || old.offset != offset ) throw "Conflicting alias "+name;
			return;
		}
		bufferAliases.set(name, {realName : realName, offset : offset });
		// already allocated !
		if( bufferCache != null ) allocAlias(name);
	}

	override function alloc(engine:h3d.Engine) {
		dispose();
		buffer = new h3d.Buffer(data.vertexCount, data.vertexStride, [LargeBuffer]);

		var entry = lib.resource.entry;
		entry.open();

		entry.skip(dataPosition + data.vertexPosition);
		var size = data.vertexCount * data.vertexStride * 4;
		var bytes = haxe.io.Bytes.alloc(size);
		entry.read(bytes, 0, size);
		buffer.uploadBytes(bytes, 0, data.vertexCount);

		indexCount = 0;
		indexesTriPos = [];
		for( n in data.indexCounts ) {
			indexesTriPos.push(Std.int(indexCount/3));
			indexCount += n;
		}
		var is32 = data.vertexCount > 0x10000;
		indexes = new h3d.Indexes(indexCount, is32);

		entry.skip(data.indexPosition - (data.vertexPosition + size));
		var imult = is32 ? 4 : 2;
		var bytes = haxe.io.Bytes.alloc(indexCount * imult);
		entry.read(bytes, 0, indexCount * imult);
		indexes.uploadBytes(bytes, 0, indexCount);

		entry.close();

		var pos = 0;
		for( f in data.vertexFormat ) {
			addBuffer(f.name, buffer, pos);
			pos += f.format.getSize();
		}

		if( normalsRecomputed != null )
			recomputeNormals(normalsRecomputed);

		for( name in bufferAliases.keys() )
			allocAlias(name);
	}

	function allocAlias( name : String ) {
		var alias = bufferAliases.get(name);
		var buffer = bufferCache.get(hxsl.Globals.allocID(alias.realName));
		if( buffer == null ) throw "Buffer " + alias.realName+" not found for alias " + name;
		if( buffer.offset + alias.offset > buffer.buffer.buffer.stride ) throw "Alias " + name+" for buffer " + alias.realName+" outside stride";
		addBuffer(name, buffer.buffer, buffer.offset + alias.offset);
	}

	public function recomputeNormals( ?name : String ) {

		if( name == null ) name = "normal";

		var pos = lib.getBuffers(data, [new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3)]);
		var ids = new Array();
		var pts : Array<h3d.col.Point> = [];

		for( i in 0...data.vertexCount ) {
			var added = false;
			var px = pos.vertexes[i * 3];
			var py = pos.vertexes[i * 3 + 1];
			var pz = pos.vertexes[i * 3 + 2];
			for(i in 0...pts.length) {
				var p = pts[i];
				if(p.x == px && p.y == py && p.z == pz) {
					ids.push(i);
					added = true;
					break;
				}
			}
			if( !added ) {
				ids.push(pts.length);
				pts.push(new h3d.col.Point(px,py,pz));
			}
		}

		var idx = new hxd.IndexBuffer();
		for( i in pos.indexes )
			idx.push(ids[i]);

		var pol = new Polygon(pts, idx);
		pol.addNormals();

		var v = new hxd.FloatBuffer();
		v.grow(data.vertexCount*3);
		var k = 0;
		for( i in 0...data.vertexCount ) {
			var n = pol.normals[ids[i]];
			v[k++] = n.x;
			v[k++] = n.y;
			v[k++] = n.z;
		}
		var buf = h3d.Buffer.ofFloats(v, 3);
		addBuffer(name, buf, 0);
		normalsRecomputed = name;
	}

	public function addTangents() {
		var pos = lib.getBuffers(data, [new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3)]);
		var ids = new Array();
		var pts : Array<h3d.col.Point> = [];
		for( i in 0...data.vertexCount ) {
			var added = false;
			var px = pos.vertexes[i * 3];
			var py = pos.vertexes[i * 3 + 1];
			var pz = pos.vertexes[i * 3 + 2];
			for(i in 0...pts.length) {
				var p = pts[i];
				if(p.x == px && p.y == py && p.z == pz) {
					ids.push(i);
					added = true;
					break;
				}
			}
			if( !added ) {
				ids.push(pts.length);
				pts.push(new h3d.col.Point(px,py,pz));
			}
		}
		var idx = new hxd.IndexBuffer();
		for( i in pos.indexes )
			idx.push(ids[i]);
		var pol = new Polygon(pts, idx);
		pol.addNormals();
		pol.addTangents();
		var v = new hxd.FloatBuffer();
		v.grow(data.vertexCount*3);
		var k = 0;
		for( i in 0...data.vertexCount ) {
			var t = pol.tangents[ids[i]];
			v[k++] = t.x;
			v[k++] = t.y;
			v[k++] = t.z;
		}
		var buf = h3d.Buffer.ofFloats(v, 3);
		addBuffer("tangent", buf, 0);
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

	function initCollider( poly : h3d.col.PolygonBuffer ) {
		var buf= lib.getBuffers(data, [new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3)]);
		poly.setData(buf.vertexes, buf.indexes);
		if( collider == null ) {
			var sphere = data.bounds.toSphere();
			collider = new h3d.col.Collider.OptimizedCollider(sphere, poly);
		}
	}

	override function getCollider() {
		if( collider != null )
			return collider;
		var poly = new h3d.col.PolygonBuffer();
		poly.source = {
			entry : lib.resource.entry,
			geometryName : null,
		};
		for( h in lib.header.models )
			if( lib.header.geometries[h.geometry] == data ) {
				poly.source.geometryName = h.name;
				break;
			}
		initCollider(poly);
		return collider;
	}

	#if hxbit
	override function customSerialize(ctx:hxbit.Serializer) {
		ctx.addString(lib.resource.entry.path);
		for( m in lib.header.models )
			if( lib.header.geometries[m.geometry] == this.data ) {
				ctx.addString(m.name);
				break;
			}
	}
	override function customUnserialize(ctx:hxbit.Serializer) {
		var libPath = ctx.getString();
		var modelPath = ctx.getString();
		var ctx : hxd.fmt.hsd.Serializer = cast ctx;
		lib = ctx.loadHMD(libPath);
		for( m in lib.header.models )
			if( m.name == modelPath ) {
				this.data = lib.header.geometries[m.geometry];
				@:privateAccess lib.cachedPrimitives[m.geometry] = this;
				break;
			}
		dataPosition = lib.header.dataPosition;
	}
	#end

}