package h3d.prim;

class HMDModel extends MeshPrimitive {

	var data (get, never) : hxd.fmt.hmd.Data.Geometry;
	function get_data() { return lods[0]; }
	var lods : Array<hxd.fmt.hmd.Data.Geometry>;
	var dataPosition : Int;
	var indexCount : Int;
	var indexesTriPos : Array<Int>;
	var lib : hxd.fmt.hmd.Library;
	var curMaterial : Int;
	var collider : h3d.col.Collider;
	var normalsRecomputed : String;
	var blendshape : Blendshape;

	public function new( data : hxd.fmt.hmd.Data.Geometry, dataPos, lib, lods = null ) {		
		this.lods = [data];
		if (lods != null)
			this.lods = this.lods.concat(lods);			
		this.dataPosition = dataPos;
		this.lib = lib;

		if (lib.header.shapes != null && lib.header.shapes.length > 0)
			this.blendshape = new Blendshape(this);
	}

	override function hasInput( name : String ) {
		return super.hasInput(name) || data.vertexFormat.hasInput(name);
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

	override function selectMaterial( material : Int, lod : Int ) {
		curMaterial = material + lod * data.indexCounts.length;
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

	override function alloc(engine:h3d.Engine) {
		dispose();

		var vertexCount : Int = 0;
		var vertexFormat : hxd.BufferFormat = data.vertexFormat;
		indexCount = 0;
		indexesTriPos = [];
		for ( lod in lods ) {
			vertexCount += lod.vertexCount;
			for( n in lod.indexCounts ) {
				indexesTriPos.push(Std.int(indexCount/3));
				indexCount += n;
			}
		}

		buffer = new h3d.Buffer(vertexCount, vertexFormat);

		var is32 : Bool = vertexCount > 0x10000;
		indexes = new h3d.Indexes(indexCount, is32);
		var indexStride : Int = (is32 ? 4 : 2);
		
		var entry = lib.resource.entry;
		var curVertexCount : Int = 0;
		var curIndexCount : Int = 0;
		
		for ( lod in lods ) {
			if (lod.vertexFormat != vertexFormat)
				throw "LOD has a different vertex format";
			
			var size = lod.vertexCount * vertexFormat.strideBytes;
			var bytes = entry.fetchBytes(dataPosition + lod.vertexPosition, size);			
			engine.driver.uploadBufferBytes(buffer, curVertexCount, lod.vertexCount, bytes, 0);

			var indexCount = lod.indexCount;
			size = indexStride * indexCount;
			var bytes = entry.fetchBytes(dataPosition + lod.indexPosition, size);
			if ( curIndexCount != 0 ) {
				if (is32)
					for ( i in 0...indexCount )
						bytes.setInt32(i << 2, bytes.getInt32(i << 2) + curVertexCount);
				else 
					for ( i in 0...indexCount )
						bytes.setUInt16(i << 1, bytes.getUInt16(i << 1) + curVertexCount);
			}
			engine.driver.uploadBufferBytes(indexes, curIndexCount, indexCount, bytes, 0);

			curVertexCount += lod.vertexCount;
			curIndexCount += indexCount;
		}

		if( normalsRecomputed != null ) {
			var name = normalsRecomputed;
			normalsRecomputed = null;
			recomputeNormals(name);
		}
	}

	public function recomputeNormals( ?name : String ) {

		if( normalsRecomputed != null )
			return;
		if( name != null && data.vertexFormat.hasInput(name) )
			return;

		if( name == null ) name = "normal";

		var v = new hxd.FloatBuffer();
		for ( lod in lods ) {
			var pos = lib.getBuffers(lod, hxd.BufferFormat.POS3D);
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
	
			var startOffset : Int = v.length;
			v.grow(lod.vertexCount*3);
			var k = 0;
			for( i in 0...lod.vertexCount ) {
				var n = pol.normals[ids[i]];
				v[startOffset + k++] = n.x;
				v[startOffset + k++] = n.y;
				v[startOffset + k++] = n.z;
			}
		}
		var buf = h3d.Buffer.ofFloats(v, hxd.BufferFormat.make([{ name : name, type : DVec3 }]));
		addBuffer(buf);
		normalsRecomputed = name;
	}

	public function addTangents() {
		if( hasInput("tangent") )
			return;
		var v = new hxd.FloatBuffer();
		for ( lod in lods ) {
			var pos = lib.getBuffers(lod, hxd.BufferFormat.POS3D);
			var ids = new Array();
			var pts : Array<h3d.col.Point> = [];
			for( i in 0...lod.vertexCount ) {
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
	
			var startOffset : Int = v.length;
			v.grow(lod.vertexCount*3);
			var k = 0;
			for( i in 0...lod.vertexCount ) {
				var t = pol.tangents[ids[i]];
				v[startOffset + k++] = t.x;
				v[startOffset + k++] = t.y;
				v[startOffset + k++] = t.z;
			}
		}
		
		var buf = h3d.Buffer.ofFloats(v, hxd.BufferFormat.make([{ name : "tangent", type : DVec3 }]));
		addBuffer(buf);
	}

	override function render( engine : h3d.Engine ) {
		if( curMaterial < 0 ) {
			super.render(engine);
			return;
		}

		var materialCount = data.indexCounts.length;
		var lodLevel = Std.int(curMaterial / data.indexCounts.length);

		if( indexes == null || indexes.isDisposed() )
			alloc(engine);
		if( buffers == null )
			engine.renderIndexed(buffer, indexes, indexesTriPos[curMaterial], Std.int(lods[lodLevel].indexCounts[curMaterial % materialCount]/3));
		else
			engine.renderMultiBuffers(formats, buffers, indexes, indexesTriPos[curMaterial], Std.int(lods[lodLevel].indexCounts[curMaterial % materialCount]/3));
		curMaterial = -1;
	}

	function initCollider( poly : h3d.col.PolygonBuffer ) {
		var buf= lib.getBuffers(data, hxd.BufferFormat.POS3D);
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
		
	override public function lodCount() : Int {
		return lods.length;
	}
	
	public static var lodExportKeyword : String = "LOD";
	static var lodConfig : Array<Float> = [0.02, 0.002, 0.0002];
	public static function loadLodConfig( config : Array<Float> ) {
		lodConfig = config;
	}

	override public function screenRatioToLod( screenRatio : Float ) : Int {
		var lodCount = lodCount();

		if ( lodCount == 1 )
			return 0;

		if ( lodConfig != null && lodConfig.length >= lodCount - 1) {
			var lodLevel : Int = 0; 
			var maxIter = ( ( lodConfig.length > lodCount - 1 ) ? lodCount - 1: lodConfig.length );
			for ( i in 0...maxIter ) {
				if ( lodConfig[i] > screenRatio )
					lodLevel++;
				else 
					break;
			}
			return lodLevel;
		}

		return 0;
	}
}