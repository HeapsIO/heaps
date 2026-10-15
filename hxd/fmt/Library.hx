package hxd.fmt;
import hxd.fmt.hmd.Data;
import hxd.BufferFormat;

typedef CollideParams = {
	?useDefault : Bool,
	?unit : Float,
	?scale : Float,
	?maxConvexHulls : Int,
	?mesh : String,
	?shapes : Array<ShapeColliderParams>
}

typedef ShapeColliderParams = {
	type : ShapeColliderType,
	position : { x : Float, y : Float, z : Float },
	?halfExtent : { x : Float, y : Float, z : Float },
	?rotation : { x : Float, y : Float, z : Float },
	?radius : Float,
}

enum abstract ShapeColliderType(String) to String {
	var Sphere;
	var Box;
	var Capsule;
	var Cylinder;
}

typedef BuiltGeometry = {
	var g : Geometry;
	var materials : Array<Int>;
	var vbuf : hxd.FloatBuffer;
	var ibufs : Array<Array<Int>>;
}

typedef GeometryCollideData = {
	var gid : Int;
	var mids : Array<Int>;
	var vbuf : hxd.FloatBuffer;
	var ibufs : Array<Array<Int>>;
}

abstract class Library {

	public var fileName : String;

	// Use 4 bones of influence per vertex instead of 3
	public var fourBonesByVertex = false;

	// If there are too many bones, the model will be split in separate render passes.
	public var maxBonesPerSkin = 256;

	// Keep high precision values. Might increase animation data size and compressed size.
	public var highPrecision : Bool = false;

	public var absoluteTexturePath : Bool;
	public var optimizeMesh = false;
	public var generateNormals = false;
	public var generateTangents = false;
	public var generateCollides : CollideParams;
	public var modelCollides : Map<String, Array<CollideParams>> = [];
	public var ignoreCollides : Array<String>;
	public var collisionThresholdHeight : Float;
	public var collisionUseLowLod : Bool;
	public var noCollision : Bool;
	public var lowPrecConfig : Map<String,Precision>;
	public var lodsDecimation : Array<Float>;
	public var maxUVs : Int = 0;
	public var noColor : Bool = false;

	var d : Data;
	var dataOut : haxe.io.BytesOutput;
	var filePath : String;
	var tmp = haxe.io.Bytes.alloc(4);
	var ignoreCollidesCache : Map<Int,Bool> = [];
	var animationEvents : Array<{ frame : Int, data : String }>;

	public function new( fileName ) {
		this.fileName = fileName;
	}

	public abstract function loadFile( data : haxe.io.Bytes ) : Void;

	public abstract function toHMD( filePath : String, includeGeometry : Bool ) : Data;


	public function setConvertParams( params : Dynamic, localParams : Dynamic ) {
		if( params != null ) {
			if( params.normals )
				generateNormals = true;
			if( params.precise ) {
				highPrecision = true;
				fourBonesByVertex = true;
			}
			if( params.maxBones != null )
				maxBonesPerSkin = params.maxBones;
			if( params.tangents != null )
				generateTangents = true;
			if( params.collide != null ) {
				var collide = params.collide;
				generateCollides = {
					maxConvexHulls : collide.maxConvexHulls,
					scale : collide.scale,
				};
			}
			if( params.lowp != null ) {
				var m : haxe.DynamicAccess<String> = params.lowp;
				lowPrecConfig = [];
				for( k in m.keys() ) {
					var prec : Precision = switch( m.get(k) ) {
						case "f16": F16;
						case "u8": U8;
						case "s8": S8;
						case "remove":
							switch( k ) {
							case "color": noColor = true;
							default: throw "Removal of attribute " + k + " is not supported";
							}
							Precision.fromInt(-1);
						case x: throw "Invalid precision '" + x + "' should be u8|s8|f16";
					}
					if( prec.toInt() != -1 )
						lowPrecConfig.set(k, prec);
				}
			}
			if( params.optimizeMesh != null )
				optimizeMesh = params.optimizeMesh;
			if( params.lodsDecimation != null ) {
				var config : Array<Float> = params.lodsDecimation;
				lodsDecimation = [for( lod in config ) lod];
			}
			if( params.collisionThresholdHeight != null )
				collisionThresholdHeight = params.collisionThresholdHeight;
			if( params.collisionUseLowLod != null )
				collisionUseLowLod = params.collisionUseLowLod;
			if( params.noCollision != null )
				noCollision = params.noCollision;
			if( params.maxUVs != null )
				maxUVs = params.maxUVs;
		}
		if( localParams != null ) {
			if( localParams.ignoreCollideMaterials != null )
				ignoreCollides = localParams.ignoreCollideMaterials;
			if( localParams.modelCollides != null )
				modelCollides = localParams.modelCollides;
		}
	}


	function initData( filePath : String ) {
		if( filePath != null ) {
			filePath = filePath.split("\\").join("/").toLowerCase();
			if( !StringTools.endsWith(filePath, "/") )
				filePath += "/";
		}
		this.filePath = filePath;

		d = new Data();
		#if hmd_version
		d.version = Std.parseInt(#if macro haxe.macro.Context.definedValue("hmd_version") #else haxe.macro.Compiler.getDefine("hmd_version") #end);
		#else
		d.version = Data.CURRENT_VERSION;
		#end
		d.geometries = [];
		d.materials = [];
		d.models = [];
		d.animations = [];
		d.shapes = [];

		dataOut = new haxe.io.BytesOutput();
	}

	function flushData() : Data {
		d.data = dataOut.getBytes();
		return d;
	}

	function resolveTexturePath( path : String ) {
		if( path == null || path == "" )
			return null;
		path = path.split("\\").join("/");
		if( !absoluteTexturePath ) {
			if( filePath != null && StringTools.startsWith(path.toLowerCase(), filePath) )
				path = path.substr(filePath.length);
			else {
				// relative resource path
				var k = path.split("/res/");
				if( k.length > 1 ) {
					k.shift();
					path = k.join("/res/");
				}
			}
		}
		return path;
	}

	function addDefaultMaterial() : Int {
		var mat = new Material();
		mat.blendMode = None;
		mat.name = "default";
		var mid = d.materials.length;
		d.materials.push(mat);
		return mid;
	}


	function int32tof( v : Int ) : Float {
		tmp.set(0, v & 0xFF);
		tmp.set(1, (v >> 8) & 0xFF);
		tmp.set(2, (v >> 16) & 0xFF);
		tmp.set(3, v >>> 24);
		return tmp.getFloat(0);
	}

	function round(v:Float) {
		if( v != v ) throw '${fileName} : NaN found (could be multiple skin mesh, currently not supported)';
		return highPrecision ? v : hxd.Math.fround(v * 131072) / 131072;
	}

	function roundValues( data : Array<Float>, def : Float, mult : Float = 1. ) {
		var hasValue = false;
		var epsi = highPrecision ? 0 : 1e-3;
		for( i in 0...data.length ) {
			var v = data[i] * mult;
			if( Math.abs(v - def) > epsi )
				hasValue = true;
			else
				v = def;
			data[i] = round(v);
		}
		return hasValue;
	}

	function checkData( t : { x : Array<Float>, y :Array<Float>, z:Array<Float> } ) {
		if( t == null )
			return true;
		if( t.x != null ) {
			var v = t.x[0];
			for( v2 in t.x )
				if( v != v2 )
					return false;
		}
		if( t.y != null ) {
			var v = t.y[0];
			for( v2 in t.y )
				if( v != v2 )
					return false;
		}
		if( t.z != null ) {
			var v = t.z[0];
			for( v2 in t.z )
				if( v != v2 )
					return false;
		}
		return true;
	}

	function sortDistinctFloats( a : Float, b : Float ) {
		return if( a > b ) 1 else -1;
	}

	public static inline function writeFloat(d : haxe.io.BytesOutput, f : Float ) {
		d.writeFloat( f == 0 ? 0 : f ); // prevent negative zero
	}

	public static inline function writePrec( d : haxe.io.BytesOutput, v : Float, p : Precision ) : Float {
		return switch( p ) {
			case F32:
				writeFloat(d, v);
				v;
			case F16:
				var tmp = hxd.BufferFormat.float32to16(v, true);
				d.writeUInt16(tmp);
				hxd.BufferFormat.float16to32(tmp);
			case S8:
				var tmp = hxd.BufferFormat.float32toS8(v);
				d.writeByte(tmp);
				hxd.BufferFormat.floatS8to32(tmp);
			case U8:
				var tmp = BufferFormat.float32toU8(v);
				d.writeByte(tmp);
				BufferFormat.floatU8to32(tmp);
		}
	}

	public static inline function precisionSize(p:Precision) {
		return switch( p ) {
		case F32: 4;
		case F16: 2;
		case U8, S8: 1;
		}
	}

	public static inline function flushPrec( d : haxe.io.BytesOutput, p : Precision, count : Int ) {
		var b = (count * precisionSize(p)) & 3;
		switch( b ) {
		case 0:
		case 1:
			d.writeUInt16(0);
			d.writeByte(0);
		case 2:
			d.writeUInt16(0);
		case 3:
			d.writeByte(0);
		}
	}

	public static function remapPrecision(inputName : String) {
		if ( inputName == "tangent" )
			return "normal";
		if ( inputName.indexOf("uv") == 0 )
			return "uv";
		return inputName;
	}


	#if (sys || nodejs)
	function tmpFile(name : String) {
		var tmp = Sys.getEnv("TMPDIR");
		if( tmp == null ) tmp = Sys.getEnv("TMP");
		if( tmp == null ) tmp = Sys.getEnv("TEMP");
		if( tmp == null ) tmp = ".";
		return tmp+"/"+name+Date.now().getTime()+"_"+Std.random(0x1000000)+".bin";
	}
	#end

	/**
		Compute mikktspace tangents for `count` unindexed vertexes.
		`buffer` contains 8 floats per vertex : position, normal and uv.
		Returns 4 floats per vertex, the last one being the tangent sign.
	**/
	function computeTangents( buffer : Array<Float>, count : Int ) {
		#if (hl && !hl_disable_mikkt)
		var m = new hxd.tools.Mikktspace();
		m.buffer = new hl.Bytes(8 * 4 * count);
		m.stride = 8;
		m.xPos = 0;
		m.normalPos = 3;
		m.uvPos = 6;

		m.indexes = new hl.Bytes(4 * count);
		m.indices = count;

		m.tangents = new hl.Bytes(4 * 4 * count);
		(m.tangents:hl.Bytes).fill(0,4 * 4 * count,0);
		m.tangentStride = 4;
		m.tangentPos = 0;

		for( i in 0...count * 8 )
			m.buffer[i] = buffer[i];
		for( i in 0...count ) {
			m.tangents[i<<2] = 1;
			m.indexes[i] = i;
		}

		m.compute();
		return m.tangents;
		#elseif (sys || nodejs)
		var fileName = tmpFile("mikktspace_data");
		var outFile = fileName+".out";
		var outputData = new haxe.io.BytesBuffer();
		outputData.addInt32(count);
		outputData.addInt32(8);
		outputData.addInt32(0);
		outputData.addInt32(3);
		outputData.addInt32(6);
		for( i in 0...count * 8 )
			outputData.addFloat(buffer[i]);
		outputData.addInt32(count);
		for( i in 0...count )
			outputData.addInt32(i);
		sys.io.File.saveBytes(fileName, outputData.getBytes());
		var ret = try Sys.command("meshTools",["mikktspace",fileName,outFile]) catch( e : Dynamic ) -1;
		if( ret != 0 ) {
			sys.FileSystem.deleteFile(fileName);
			throw "Failed to call 'mikktspace' executable required to generate tangent data. Please ensure it's in your PATH"+(filePath == null ? "" : ' ($filePath)');
		}
		var bytes = sys.io.File.getBytes(outFile);
		var size = count*4;
		var arr = new hxd.FloatBuffer(size);
		for( i in 0...size )
			arr[i] = bytes.getFloat(i << 2);
		sys.FileSystem.deleteFile(fileName);
		sys.FileSystem.deleteFile(outFile);
		return arr;
		#else
		throw "Tangent generation is not supported on this platform";
		return ([] : Array<Float>);
		#end
	}

	function updateNormals( g : Geometry, vbuf : hxd.FloatBuffer, idx : Array<Array<Int>> ) {
		var stride = g.vertexFormat.stride;
		var normalPos = 0;
		for( f in g.vertexFormat.getInputs() ) {
			if( f.name == "logicNormal" ) break;
			normalPos += f.type.getSize();
		}

		var points : Array<h3d.col.Point> = [];
		var psearch = new haxe.ds.Vector(1024);
		inline function getPID(x:Float,y:Float,z:Float) {
			return Std.int(((x + y + z) * 100) % 1024) & 1023;
		}
		var pmap = [];
		for( vid in 0...g.vertexCount ) {
			var x = vbuf[vid * stride];
			var y = vbuf[vid * stride + 1];
			var z = vbuf[vid * stride + 2];
			var pid = getPID(x,y,z);
			var indexes = psearch[pid];
			var found = false;
			if( indexes == null ) {
				indexes = [];
				psearch[pid] = indexes;
			}
			for( idx in indexes ) {
				var p = points[idx];
				if( p.x == x && p.y == y && p.z == z ) {
					pmap[vid] = idx;
					found = true;
					break;
				}
			}
			if( !found ) {
				var idx = points.length;
				pmap[vid] = idx;
				indexes.push(idx);
				points.push(new h3d.col.Point(x,y,z));
			}
		}
		var realIdx = new hxd.IndexBuffer();
		for( idx in idx ) {
			if ( idx == null )
				continue;
			for( i in idx )
				realIdx.push(pmap[i]);
		}

		var poly = new h3d.prim.Polygon(points, realIdx);
		poly.addNormals();

		for( vid in 0...g.vertexCount ) {
			var nid = pmap[vid];
			vbuf[vid*stride + normalPos] = poly.normals[nid].x;
			vbuf[vid*stride + normalPos + 1] = poly.normals[nid].y;
			vbuf[vid*stride + normalPos + 2] = poly.normals[nid].z;
		}
	}

	function optimize( vbuf : hxd.FloatBuffer, vertexFormat : hxd.BufferFormat, ibuf : Array<Int>, startIndex : Int, decimationFactor : Float ) {
		var optimizedVbuf : hxd.FloatBuffer;
		decimationFactor = hxd.Math.clamp(decimationFactor);

		#if ( hl && hl_ver >= version("1.15.0") )
		var vertexSize = vertexFormat.stride << 2;
		var vertexCount = Std.int(vbuf.length / vertexFormat.stride);
		var vertices = new hl.Bytes(vertexCount * vertexSize);
		for ( i in 0...vbuf.length )
			vertices.setF32(i << 2, cast(vbuf[i], Single));
		var indexCount = ibuf.length;
		var indices = new hl.Bytes(indexCount * 4);
		for ( i => idx in ibuf )
			indices.setI32(i << 2, idx);

		var remap = new hl.Bytes(vertexCount * 4);
		var uniqueVertexCount = hxd.tools.MeshOptimizer.generateVertexRemap(remap, indices, indexCount, vertices, vertexCount, vertexSize);
		hxd.tools.MeshOptimizer.remapIndexBuffer(indices, indices, indexCount, remap);
		hxd.tools.MeshOptimizer.remapVertexBuffer(vertices, vertices, vertexCount, vertexSize, remap);
		vertexCount = uniqueVertexCount;
		if ( decimationFactor > 0.0 ) {
			var options = hxd.tools.MeshOptimizer.SimplifyOptions.LockBorder | hxd.tools.MeshOptimizer.SimplifyOptions.Prune;
			indexCount = hxd.tools.MeshOptimizer.simplify(indices, indices, indexCount, vertices, vertexCount, vertexSize, Std.int(indexCount * (1.0 - decimationFactor)), decimationFactor, options, null);
		}
		hxd.tools.MeshOptimizer.optimizeVertexCache(indices, indices, indexCount, vertexCount);
		hxd.tools.MeshOptimizer.optimizeOverdraw(indices, indices, indexCount, vertices, vertexCount, vertexSize, 1.05);
		vertexCount = hxd.tools.MeshOptimizer.optimizeVertexFetch(vertices, indices, indexCount, vertices, vertexCount, vertexSize);

		optimizedVbuf = new hxd.FloatBuffer();
		optimizedVbuf.resize(vertexCount * vertexFormat.stride);
		for ( i in 0...vertexCount * vertexFormat.stride )
			optimizedVbuf[i] = vertices.getF32(i << 2);
		ibuf.resize(indexCount);
		for ( i in 0...indexCount )
			ibuf[i] = indices.getI32(i << 2) + startIndex;

		#elseif (sys || nodejs)
		var fileName = tmpFile("meshTools_data");
		var outFile = fileName+".out";

		var vertexSize = vertexFormat.stride << 2;
		var vertexCount = Std.int(vbuf.length / vertexFormat.stride);

		var outputData = new haxe.io.BytesBuffer();
		outputData.addInt32(vertexCount);
		outputData.addInt32(vertexSize);
		for( v in vbuf )
			outputData.addFloat(v);
		var indexCount = ibuf.length;
		outputData.addInt32(indexCount);
		for( i in ibuf )
			outputData.addInt32(i);
		sys.io.File.saveBytes(fileName, outputData.getBytes());
		var ret = if (decimationFactor > 0.0)
			try Sys.command("meshTools",["simplify",fileName,outFile,'${Std.int(indexCount * (1.0 - decimationFactor))}','${decimationFactor}']) catch( e : Dynamic ) -1;
		else
			try Sys.command("meshTools",["optimize",fileName,outFile]) catch( e : Dynamic ) -1;

		if( ret != 0 ) {
			sys.FileSystem.deleteFile(fileName);
			throw "Failed to call 'meshTools' executable required to generate optimized mesh. Please ensure it's in your PATH"+(filePath == null ? "" : ' ($filePath)');
		}
		var input = sys.io.File.getBytes(outFile);
		var pos = 1;
		vertexCount = input.getInt32(0);
		optimizedVbuf = new hxd.FloatBuffer();
		optimizedVbuf.resize(vertexCount * vertexFormat.stride);
		for ( i in 0...vertexCount * vertexFormat.stride )
			optimizedVbuf[i] = input.getFloat(4 * pos++);
		indexCount = input.getInt32(4 * pos++);
		ibuf.resize(indexCount);
		for ( i in 0...indexCount )
			ibuf[i] = input.getInt32(4 * pos++) + startIndex;
		sys.FileSystem.deleteFile(fileName);
		sys.FileSystem.deleteFile(outFile);
		#else
		optimizedVbuf = vbuf;
		#end

		return optimizedVbuf;
	}

	/**
		Optimize (and optionally decimate) each index buffer of a geometry, returns the new vertex buffer
		or null if the resulting geometry is empty.
	**/
	function optimizeGeometry( g : Geometry, vbuf : hxd.FloatBuffer, ibufs : Array<Array<Int>>, decimationFactor : Float ) {
		var optimizedVbuf = new hxd.FloatBuffer();
		for( idx in ibufs ) {
			if ( idx == null )
				continue;
			var start = optimizedVbuf.length;
			var buf = optimize(vbuf, g.vertexFormat, idx, Std.int(start / g.vertexFormat.stride), decimationFactor );
			var length = buf.length;
			optimizedVbuf.resize(start + length);
			for ( i in 0...length )
				optimizedVbuf[start + i] = buf[i];
		}
		g.vertexCount = Std.int(optimizedVbuf.length / g.vertexFormat.stride);
		if ( g.vertexCount == 0 )
			return null;
		return optimizedVbuf;
	}

	function writeVertices( g : Geometry, vbuf : hxd.FloatBuffer ) : hxd.FloatBuffer {
		var positions = new hxd.FloatBuffer();
		var format = g.vertexFormat;
		var stride = format.stride;
		var inputs = [for( input in format.getInputs() ) input];
		g.vertexPosition = dataOut.length;
		for( index in 0...Std.int(vbuf.length / stride) ) {
			var i = index * stride;
			for( k => input in inputs ) {
				if( input.type == hxd.BufferFormat.InputFormat.DBytes4 ) {
					writeFloat(dataOut, vbuf[i++]);
					continue;
				}
				var size = input.type.getSize();
				for( _ in 0...size ) {
					var v = writePrec(dataOut, vbuf[i++], input.precision);
					if( k == 0 ) positions.push(v);
				}
				flushPrec(dataOut, input.precision, size);
			}
			if( i != (index + 1) * stride )
				throw "assert";
		}
		return positions;
	}

	function writeIndexes( g : Geometry, ibufs : Array<Array<Int>> ) : Array<Int> {
		g.indexPosition = dataOut.length;
		g.indexCounts = [];

		var matMap = [], matCount = 0;
		var is32 = g.vertexCount > 0x10000;

		for( idx in ibufs ) {
			if( idx == null ) {
				matCount++;
				continue;
			}
			matMap.push(matCount++);
			g.indexCounts.push(idx.length);
			if( is32 ) {
				for( i in idx )
					dataOut.writeInt32(i);
			} else {
				for( i in idx )
					dataOut.writeUInt16(i);
			}
		}
		return matMap;
	}


	function getLODInfos( modelName : String ) : { lodLevel : Int , modelName : String } {

		var keyword = "LOD";
		if ( modelName == null || modelName.length <= keyword.length )
			return { lodLevel : -1, modelName : null };

		// Test prefix
		if ( modelName.substr(0, keyword.length) == keyword ) {
			var parsedInt = Std.parseInt(modelName.charAt( keyword.length ));
			if (parsedInt != null) {
				if ( Std.parseInt( modelName.charAt( keyword.length + 1 ) ) != null )
					throw 'Did not expect a second number after LOD in ${modelName}';
				return { lodLevel : parsedInt, modelName : modelName.substr(keyword.length) };
			}
		}

		// Test suffix
		var maxCursor = modelName.length - keyword.length - 1;
		if ( modelName.substr( maxCursor, keyword.length ) == keyword ) {
			var parsedInt = Std.parseInt( modelName.charAt( modelName.length - 1) );
			if ( parsedInt != null ) {
				return { lodLevel : parsedInt, modelName : modelName.substr( 0, maxCursor ) };
			}
		}

		return { lodLevel : -1, modelName : null };
	}

	function compareLODNames( aName : String, bName : String ) {
		if (aName == null) return 0;
		var aIndexOf = aName.lastIndexOf("_LOD");
		var aLodLevel = Std.parseInt(aName.substr(aIndexOf + 4));
		aName = aName.substring(0, aIndexOf);

		if (bName == null) return 0;
		var bIndexOf = bName.lastIndexOf("_LOD");
		var bLodLevel = Std.parseInt(bName.substr(bIndexOf + 4));
		bName = bName.substring(0, bIndexOf);

		if (aName == bName && aLodLevel != null && bLodLevel != null) {
			return aLodLevel > bLodLevel ? 1 : -1;
		}
		else {
			return 0;
		}
	}

	function registerLOD( model : Model, hlods : Map<String, Array<Index<Model>>> ) {
		var lodsInfos = getLODInfos(model.name);
		var lodIndex = lodsInfos.lodLevel;
		var key = lodsInfos.modelName;
		if ( lodIndex < 0 )
			return false;
		var lods = hlods.get(key);
		if ( lods == null ) {
			lods = [];
			hlods.set(key, lods);
		}
		if ( lodIndex > 0 ) {
			lods[lodIndex - 1] = d.models.length-1;
			model.lods = [];
		} else {
			model.lods = lods;
		}
		if( model.props == null ) model.props = [];
		model.props.push(HasLod);
		return true;
	}

	/**
		Generate the LODs of a model by decimating its geometry using `lodsDecimation` factors.
	**/
	function addDecimatedLODs( model : Model, mids : Array<Int>, hgeomCol : Map<Int, GeometryCollideData>, buildGeom : Float -> BuiltGeometry ) {
		var modelName = model.name;
		model.name = model.toLODName(0);
		if( model.props == null ) model.props = [];
		model.props.push(HasLod);
		model.lods = [];
		for ( i => lods in lodsDecimation ) {
			var geom = buildGeom(lods);
			if ( geom == null )
				continue;
			var gdataCol = { gid : d.geometries.length, mids : mids, vbuf : geom.vbuf, ibufs : geom.ibufs };
			hgeomCol.set(gdataCol.gid, gdataCol);
			var lodModel = new Model();
			lodModel.name = modelName + 'LOD${i+1}';
			lodModel.props = model.props != null ? model.props.copy() : null;
			if ( lodModel.props != null ) {
				lodModel.props.remove(HasCollider);
				if ( lodModel.props.length == 0 )
					lodModel.props = [];
			}
			lodModel.parent = model.parent;
			lodModel.follow = model.follow;
			lodModel.position = model.position;
			lodModel.materials = model.materials;
			lodModel.skin = model.skin;
			lodModel.lods = [];
			lodModel.geometry = d.geometries.length;
			d.geometries.push(geom.g);
			model.lods.push(d.models.length);
			d.models.push(lodModel);
		}
	}


	function removeUselessRoot() {
		var rootIndex = -1;
		for (i => m in d.models) {
			if (m.parent == -1 && m.geometry == -1 && m.name == null && m.position.isIdentity()) {
				rootIndex = i;
				break;
			}
		}
		if (rootIndex == -1)
			return;
		var objectCount = 0;
		for (m in d.models) {
			if (!m.isLOD() && !m.isCollider() && m.parent == rootIndex)
				objectCount++;
			if (objectCount > 1)
				break;
		}
		if (objectCount != 1)
			return;
		d.models.remove(d.models[rootIndex]);
		for (m in d.models) {
			if (m.parent == rootIndex)
				m.parent = -1;
			else if (m.parent > rootIndex)
				m.parent--;
			if (m.lods != null) {
				for (i in 0...m.lods.length) {
					var lodIndex = m.lods[i];
					if (lodIndex > rootIndex)
						m.lods[i] = lodIndex - 1;
				}
			}
		}
	}


	function getColliderModelMatrix( colliderModel : Model, convexHulls : Bool ) {
		var mat = colliderModel.position.toMatrix();
		if (colliderModel.skin != null)
			mat.multiply(mat, colliderModel.skin.joints[0].position.toMatrix());
		return mat;
	}

	function buildGeomCollider( targetModel : Model, colliderModel : Model, vbuf : FloatBuffer, ibufs : Array<Array<Int>>, dataOut : haxe.io.BytesOutput ) : MeshCollider {
		var vertexCount = Std.int(vbuf.length / 3);
		var indexCount = 0;
		for( idx in ibufs ) {
			indexCount += idx == null ? 0 : idx.length;
		}

		function iterVertex(cb : Float -> Float -> Float -> Void) {
			for ( i in 0...vertexCount ) {
				var x = vbuf[i*3];
				var y = vbuf[i*3 + 1];
				var z = vbuf[i*3 + 2];
				cb(x, y, z);
			}
		}

		var collider = new MeshCollider();
		collider.vertexPosition = dataOut.length;
		collider.vertexCount = vertexCount;
		collider.indexCount = indexCount;
		var mat = getColliderModelMatrix(colliderModel, false);
		var invTargetModelMat = targetModel.position.toMatrix().getInverse();
		mat.multiply(mat, invTargetModelMat);
		var tmpVec = new h3d.Vector();
		iterVertex(function(x, y, z) {
			tmpVec.set(x, y, z);
			tmpVec.transform(mat);
			dataOut.writeFloat(tmpVec.x);
			dataOut.writeFloat(tmpVec.y);
			dataOut.writeFloat(tmpVec.z);
		});

		var is32 = vertexCount > 0x10000;
		collider.indexPosition = dataOut.length;
		for ( i => idx in ibufs ) {
			if( idx == null )
				continue;
			if( is32 ) {
				for( i in idx )
					dataOut.writeInt32(i);
			} else {
				for( i in idx )
					dataOut.writeUInt16(i);
			}
		}
		return collider;
	}

	function buildAutoColliders( targetModel : Model, colliderModel : Model, d : hxd.fmt.hmd.Data, vbuf : FloatBuffer, ibufs : Array<Array<Int>>, mids : Array<Int>, bounds : h3d.col.Bounds, generateCollides : CollideParams, dataOut : haxe.io.BytesOutput ) : ConvexHullsCollider {
		// Format data for our convex hull algorithm
		var vertices : Array<Float> = [];
		var indexes : Array<Int> = [];

		var vertexCount = Std.int(vbuf.length / 3);
		var indexCount = 0;
		for(idx in ibufs)
			indexCount += idx == null ? 0 : idx.length;

		var mat = getColliderModelMatrix(colliderModel, true);
		var invTargetModelMat = targetModel.position.toMatrix().getInverse();
		mat.multiply(mat, invTargetModelMat);
		var tmpVec = new h3d.Vector();
		for (i in 0...vertexCount) {
			var x = vbuf[i * 3];
			var y = vbuf[i * 3 + 1];
			var z = vbuf[i * 3 + 2];
			tmpVec.set(x, y, z);
			tmpVec.transform(mat);
			vertices.push(tmpVec.x);
			vertices.push(tmpVec.y);
			vertices.push(tmpVec.z);
		}

		for ( idx => ibuf in ibufs ) {
			if( ibuf == null )
				continue;
			if( ignoreCollides != null && idx < mids.length ) {
				var mat = mids[idx];
				var b = ignoreCollidesCache.get(mat);
				if( b == null ) {
					b = ignoreCollides.contains(d.materials[mat].name);
					ignoreCollidesCache.set(mat, b);
				}
				if( b == true )
					continue;
			}
			for (idx in ibuf)
				indexes.push(idx);
		}

		// Compute convex hulls shapes with hmd data
		var dim = bounds.dimension();
		if( generateCollides.unit == null || generateCollides.unit < 0 )
			throw 'Invalid collide unit ${generateCollides.unit} for ${colliderModel.getObjectName()} in $fileName';
		var resolution = Math.ceil(dim / generateCollides.unit);
		var params = { maxConvexHulls: generateCollides.maxConvexHulls, resolution: resolution };
		var convexHulls = hxd.fmt.hmd.Data.ConvexHullsCollider.buildConvexHulls(vertices, indexes, params);
		convexHulls = [ for (idx in 0...convexHulls.length) hxd.fmt.hmd.Data.ConvexHullsCollider.scale(convexHulls[idx].vertices, convexHulls[idx].indexes, generateCollides.scale) ];

		// Create convex hulls colliders
		var collider = new ConvexHullsCollider();
		collider.vertexCounts = [];
		collider.indexCounts = [];
		var is32 = [];

		collider.vertexPosition = dataOut.length;
		for ( i in 0...convexHulls.length ) {
			var vertices = convexHulls[i].vertices;
			var indexes = convexHulls[i].indexes;
			for ( v in vertices )
				dataOut.writeFloat(v);

			var vCount = Std.int(vertices.length / 3);
			collider.vertexCounts.push(vCount);
			collider.indexCounts.push(indexes.length);

			is32.push(vCount > 0x10000);
		}

		collider.indexPosition = dataOut.length;
		for ( i in 0...convexHulls.length ) {
			var is32 = is32[i];
			if( is32 ) {
				for( idx in convexHulls[i].indexes )
					dataOut.writeInt32(idx);
			} else {
				for( idx in convexHulls[i].indexes )
					dataOut.writeUInt16(idx);
			}
		}

		return collider;
	}

	function buildShapeColliders( shapes : Array<ShapeColliderParams> ) : GroupCollider {
		var group = new GroupCollider();
		group.colliders = [];
		function makeVector( dyn ) {
			var x : Float = dyn.x;
			var y : Float = dyn.y;
			var z : Float = dyn.z;
			return new h3d.Vector(x, y, z);
		}
		for( cp in shapes ) {
			switch( cp.type ) {
			case Sphere:
				var c = new SphereCollider();
				if( cp.position == null )
					throw "Invalid SphereCollider params";
				c.position = makeVector(cp.position);
				c.radius = cp.radius;
				group.colliders.push(c);
			case Box:
				var c = new BoxCollider();
				if( cp.position == null || cp.halfExtent == null )
					throw "Invalid BoxCollider params";
				c.position = makeVector(cp.position);
				c.halfExtent = makeVector(cp.halfExtent);
				c.rotation = makeVector(cp.rotation);
				group.colliders.push(c);
			case Capsule:
				var c = new CapsuleCollider();
				if( cp.position == null || cp.halfExtent == null )
					throw "Invalid CapsuleCollider params";
				c.position = makeVector(cp.position);
				c.halfExtent = makeVector(cp.halfExtent);
				c.radius = cp.radius;
				group.colliders.push(c);
			case Cylinder:
				var c = new CylinderCollider();
				if( cp.position == null || cp.halfExtent == null )
					throw "Invalid CapsuleCollider params";
				c.position = makeVector(cp.position);
				c.halfExtent = makeVector(cp.halfExtent);
				c.radius = cp.radius;
				group.colliders.push(c);
			}
		}
		return group;
	}

	function buildColliders( hgeomCol : Map<Int, GeometryCollideData> ) {
		d.colliders = [];
		for( model in d.models ) {
			if( model.geometry < 0 || model.isLOD() || model.isCollider() )
				continue;
			if( model.props == null ) model.props = [];

			var mname = model.getObjectName();
			var mcs = modelCollides.exists(mname) ? modelCollides.get(mname) : [{ useDefault : true }];
			if( mcs == null || mcs.length == 0 ) {
				var collider = new EmptyCollider();
				var colliderId = d.colliders.length;
				if( d.props == null ) d.props = [];
				if( !d.props.contains(HasCustomCollider) )
					d.props.push(HasCustomCollider);
				d.colliders.push(collider);
				model.collider = colliderId;
				model.props.push(HasCollider);
				continue;
			}

			for ( idx => mc in mcs ) {
				var isDefaultParams = mc != null && mc.useDefault;
				var params = isDefaultParams ? generateCollides : mc;
				var colliderType = hxd.fmt.hmd.Data.Collider.resolveColliderType(d, model, params, isDefaultParams, collisionThresholdHeight, collisionUseLowLod, noCollision);
				var collider : Collider = switch (colliderType) {
					case Empty:
						new EmptyCollider();
					case ConvexHulls(colliderModel):
						var gdataCol = hgeomCol.get(colliderModel.geometry);
						buildAutoColliders(model, colliderModel, d, gdataCol.vbuf, gdataCol.ibufs, gdataCol.mids, d.geometries[model.geometry].bounds, params, dataOut);
					case Mesh(colliderModel):
						var gdataCol = hgeomCol.get(colliderModel.geometry);
						buildGeomCollider(model, colliderModel, gdataCol.vbuf, gdataCol.ibufs, dataOut);
					case Shapes:
						buildShapeColliders(params.shapes);
					case null:
						null;
					default:
						null;
				};

				if( collider != null ) {
					var colliderId = d.colliders.length;
					if( collider.type != ConvexHulls ) {
						if( d.props == null ) d.props = [];
						if( !d.props.contains(HasCustomCollider) )
							d.props.push(HasCustomCollider);
					}
					d.colliders.push(collider);
					if( idx == 0 ) {
						model.collider = colliderId;
						model.props.push(HasCollider);
					} else {
						if( model.colliders == null ) {
							model.colliders = [model.collider];
							model.props.push(HasColliders);
						}
						model.colliders[idx] = colliderId;
					}
				}
			}
		}

		if( d.colliders.length == 0 )
			d.colliders = null;
	}


	function makeSkin( skin : h3d.anim.Skin ) {
		var s = new Skin();
		s.name = "Skin";
		s.joints = [];
		for( jo in skin.allJoints ) {
			var j = new SkinJoint();
			j.name = jo.name;
			j.parent = jo.parent == null ? -1 : jo.parent.index;
			j.bind = jo.bindIndex;
			j.position = makePosition(jo.defMat);
			if( jo.transPos != null ) {
				j.transpos = makePosition(jo.transPos);
				if( j.transpos.sx != 1 || j.transpos.sy != 1 || j.transpos.sz != 1 ) {
					// FIX : the scale is not correctly taken into account, this formula will extract it and fix things
					var tmp = jo.transPos.clone();
					tmp.transpose();
					var s = tmp.getScale();
					tmp.prependScale(1 / s.x, 1 / s.y, 1 / s.z);
					tmp.transpose();
					j.transpos = makePosition(tmp);
					j.transpos.sx = round(s.x);
					j.transpos.sy = round(s.y);
					j.transpos.sz = round(s.z);
				}
			}
			s.joints.push(j);
		}
		if( skin.splitJoints != null ) {
			s.split = [];
			for( sp in skin.splitJoints ) {
				var ss = new SkinSplit();
				ss.materialIndex = sp.material;
				ss.joints = [for( j in sp.joints ) j.index];
				s.split.push(ss);
			}
		}
		return s;
	}

	function makePosition( m : h3d.Matrix ) {
		var p = new Position();
		var s = m.getScale();
		var angles = m.getEulerAngles();
		var r = h3d.Matrix.R(angles.x, angles.y, angles.z);
		var q = new h3d.Quat();
		q.initRotateMatrix(r);
		if (Math.isNaN(q.x)) q.x = 0;
		if (Math.isNaN(q.y)) q.y = 0;
		if (Math.isNaN(q.z)) q.z = 0;
		if (q.w < 0) q.negate();
		p.sx = round(s.x);
		p.sy = round(s.y);
		p.sz = round(s.z);
		p.qx = round(q.x);
		p.qy = round(q.y);
		p.qz = round(q.z);
		p.x = round(m._41);
		p.y = round(m._42);
		p.z = round(m._43);
		return p;
	}


	function writeFrame( o : h3d.anim.LinearAnimation.LinearObject, fid : Int ) {
		if( d.version < 3 ) return;
		if( o.frames != null ) {
			var f = o.frames[fid];
			if( o.hasPosition ) {
				writeFloat(dataOut, f.tx);
				writeFloat(dataOut, f.ty);
				writeFloat(dataOut, f.tz);
			}
			if( o.hasRotation ) {
				var ql = Math.sqrt(f.qx * f.qx + f.qy * f.qy + f.qz * f.qz + f.qw * f.qw);
				if( ql * f.qw < 0 ) ql = -ql; // make sure normalized qw > 0
				writeFloat(dataOut, round(f.qx / ql));
				writeFloat(dataOut, round(f.qy / ql));
				writeFloat(dataOut, round(f.qz / ql));
			}
			if( o.hasScale ) {
				writeFloat(dataOut, f.sx);
				writeFloat(dataOut, f.sy);
				writeFloat(dataOut, f.sz);
			}
		}
		if( o.uvs != null ) {
			writeFloat(dataOut, o.uvs[fid<<1]);
			writeFloat(dataOut, o.uvs[(fid<<1)+1]);
		}
		if( o.alphas != null )
			writeFloat(dataOut, o.alphas[fid]);
		if( o.propValues != null )
			writeFloat(dataOut, o.propValues[fid]);
	}

	function makeAnimation( anim : h3d.anim.Animation ) {
		var a = new Animation();
		a.name = anim.name;
		a.loop = true;
		a.speed = 1;
		a.sampling = anim.sampling;
		a.frames = anim.frameCount;
		a.objects = [];
		a.dataPosition = dataOut.length;
		if( animationEvents != null )
			a.events = [for( a in animationEvents ) { var e = new AnimationEvent(); e.frame = a.frame; e.data = a.data; e; } ];
		var objects : Array<h3d.anim.LinearAnimation.LinearObject> = cast @:privateAccess anim.objects;
		objects.sort(function(o1, o2) return Reflect.compare(o1.objectName, o2.objectName));

		var animatedObjects = [];
		for( obj in objects ) {
			var o = new AnimationObject();
			var count = 0;
			o.name = obj.objectName;
			o.flags = new haxe.EnumFlags();
			o.props = [];
			if( obj.frames != null ) {
				count = obj.frames.length;
				if( obj.hasPosition || d.version < 3 )
					o.flags.set(HasPosition);
				if( obj.hasRotation )
					o.flags.set(HasRotation);
				if( obj.hasScale )
					o.flags.set(HasScale);
				if( d.version < 3 ) {
					for( f in obj.frames ) {
						if( o.flags.has(HasPosition) ) {
							writeFloat(dataOut, f.tx);
							writeFloat(dataOut, f.ty);
							writeFloat(dataOut, f.tz);
						}
						if( o.flags.has(HasRotation) ) {
							var ql = Math.sqrt(f.qx * f.qx + f.qy * f.qy + f.qz * f.qz + f.qw * f.qw);
							if( f.qw < 0 ) ql = -ql;
							writeFloat(dataOut, round(f.qx / ql));
							writeFloat(dataOut, round(f.qy / ql));
							writeFloat(dataOut, round(f.qz / ql));
						}
						if( o.flags.has(HasScale) ) {
							writeFloat(dataOut, f.sx);
							writeFloat(dataOut, f.sy);
							writeFloat(dataOut, f.sz);
						}
					}
				}
			}
			if( obj.uvs != null ) {
				o.flags.set(HasUV);
				if( count == 0 ) count = obj.uvs.length>>1 else if( count != obj.uvs.length>>1 ) throw "assert";
				if( d.version < 3 )
					for( f in obj.uvs )
						writeFloat(dataOut, f);
				}
			if( obj.alphas != null ) {
				o.flags.set(HasAlpha);
				if( count == 0 ) count = obj.alphas.length else if( count != obj.alphas.length ) throw "assert";
				if( d.version < 3 )
					for( f in obj.alphas )
						writeFloat(dataOut, f);
			}
			if( obj.propValues != null ) {
				o.flags.set(HasProps);
				o.props.push(obj.propName);
				if( count == 0 ) count = obj.propValues.length else if( count != obj.propValues.length ) throw "assert";
				if( d.version < 3 )
					for( f in obj.propValues )
						writeFloat(dataOut, f);
			}
			if( count == 0 )
				throw "assert"; // no data ?
			if( count == 1 ) {
				o.flags.set(SingleFrame);
				writeFrame(obj,0);
			} else {
				if( count != anim.frameCount ) throw "assert";
				animatedObjects.push(obj);
			}
			a.objects.push(o);
		}
		for( i in 0...anim.frameCount )
			for( obj in animatedObjects )
				writeFrame(obj,i);
		return a;
	}

}
