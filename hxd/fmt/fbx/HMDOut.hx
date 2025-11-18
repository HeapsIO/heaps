package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;
import hxd.fmt.fbx.BaseLibrary;
import hxd.fmt.hmd.Data;
import hxd.BufferFormat;

typedef CollideParams = {
	?useDefault : Bool,
	?precision : Float,
	?maxSubdiv : Int,
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

class HMDOut extends BaseLibrary {
	var d : Data;
	var dataOut : haxe.io.BytesOutput;
	var filePath : String;
	var tmp = haxe.io.Bytes.alloc(4);
	var midsSortRemap : Map<Int, Int>;
	var lod0Mids : Array<Int>;
	public var absoluteTexturePath : Bool;
	public var optimizeSkin = true;
	public var optimizeMesh = false;
	public var generateNormals = false;
	public var generateTangents = false;
	public var generateCollides : CollideParams;
	public var modelCollides : Map<String, Array<CollideParams>> = [];
	public var ignoreCollides : Array<String>;
	var ignoreCollidesCache : Map<Int,Bool> = [];
	public var collisionThresholdHeight : Float;
	public var collisionUseLowLod : Bool;
	public var lowPrecConfig : Map<String,Precision>;
	public var lodsDecimation : Array<Float>;

	function int32tof( v : Int ) : Float {
		tmp.set(0, v & 0xFF);
		tmp.set(1, (v >> 8) & 0xFF);
		tmp.set(2, (v >> 16) & 0xFF);
		tmp.set(3, v >>> 24);
		return tmp.getFloat(0);
	}

	override function keepJoint(j:h3d.anim.Skin.Joint) {
		if( !optimizeSkin )
			return true;
		// remove these unskinned terminal bones if they are not named in a special manner
		if( ~/^Bip00[0-9] /.match(j.name) || ~/^Bone[0-9][0-9][0-9]$/.match(j.name) )
			return false;
		return true;
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

	function buildTangents( geom : hxd.fmt.fbx.Geometry ) {
		var verts = geom.getVertices();
		var normals = geom.getNormals();
		var uvs = geom.getUVs();
		var index = geom.getIndexes();

		if ( index.vidx.length > 0 && uvs[0] == null ) @:privateAccess
			throw "Need UVs to build tangents" + (geom.lib != null ? ' in ${geom.lib.fileName}' : '');

		#if (hl && !hl_disable_mikkt)
		var m = new hxd.tools.Mikktspace();
		m.buffer = new hl.Bytes(8 * 4 * index.vidx.length);
		m.stride = 8;
		m.xPos = 0;
		m.normalPos = 3;
		m.uvPos = 6;

		m.indexes = new hl.Bytes(4 * index.vidx.length);
		m.indices = index.vidx.length;

		m.tangents = new hl.Bytes(4 * 4 * index.vidx.length);
		(m.tangents:hl.Bytes).fill(0,4 * 4 * index.vidx.length,0);
		m.tangentStride = 4;
		m.tangentPos = 0;

		var out = 0;
		for( i in 0...index.vidx.length ) {
			var vidx = index.vidx[i];
			m.buffer[out++] = verts[vidx*3];
			m.buffer[out++] = verts[vidx*3+1];
			m.buffer[out++] = verts[vidx*3+2];

			m.buffer[out++] = normals[i*3];
			m.buffer[out++] = normals[i*3+1];
			m.buffer[out++] = normals[i*3+2];
			var uidx = uvs[0].index[i];

			m.buffer[out++] = uvs[0].values[uidx*2];
			m.buffer[out++] = uvs[0].values[uidx*2+1];

			m.tangents[i<<2] = 1;

			m.indexes[i] = i;
		}

		m.compute();
		return m.tangents;
		#elseif (sys || nodejs)
		var fileName = tmpFile("mikktspace_data");
		var outFile = fileName+".out";
		var outputData = new haxe.io.BytesBuffer();
		outputData.addInt32(index.vidx.length);
		outputData.addInt32(8);
		outputData.addInt32(0);
		outputData.addInt32(3);
		outputData.addInt32(6);
		for( i in 0...index.vidx.length ) {
			inline function w(v:Float) outputData.addFloat(v);
			var vidx = index.vidx[i];
			w(verts[vidx*3]);
			w(verts[vidx*3+1]);
			w(verts[vidx*3+2]);

			w(normals[i*3]);
			w(normals[i*3+1]);
			w(normals[i*3+2]);
			var uidx = uvs[0].index[i];

			w(uvs[0].values[uidx*2]);
			w(uvs[0].values[uidx*2+1]);
		}
		outputData.addInt32(index.vidx.length);
		for( i in 0...index.vidx.length )
			outputData.addInt32(i);
		sys.io.File.saveBytes(fileName, outputData.getBytes());
		var ret = try Sys.command("meshTools",["mikktspace",fileName,outFile]) catch( e : Dynamic ) -1;
		if( ret != 0 ) {
			sys.FileSystem.deleteFile(fileName);
			throw "Failed to call 'mikktspace' executable required to generate tangent data. Please ensure it's in your PATH"+(filePath == null ? "" : ' ($filePath)');
		}
		var bytes = sys.io.File.getBytes(outFile);
		var size = index.vidx.length*4;
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
			if ( idx == null ) {
				trace("Empty list of vertex indexes");
				continue;
			}
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

	function buildGeom( geom : hxd.fmt.fbx.Geometry, skin : h3d.anim.Skin, dataOut : haxe.io.BytesOutput, genTangents : Bool, decimationFactor : Float = 0.0 ) {
		var g = new Geometry();

		var verts = geom.getVertices();
		var normals = geom.getNormals();
		var uvs = geom.getUVs();
		var colors = geom.getColors();
		var mats = geom.getMaterials();
		var index = geom.getPolygons();

		// remove empty color data
		if( colors != null ) {
			var hasData = false;
			for( v in colors.values )
				if( v < 0.99 ) {
					hasData = true;
					break;
				}
			if( !hasData )
				colors = null;
		}

		// generate tangents
		var tangents = genTangents ? buildTangents(geom) : null;

		inline function getPrec(n) {
			var p = lowPrecConfig == null ? null : lowPrecConfig.get(n);
			if( p == null ) p = F32;
			return p;
		}
		var ppos = getPrec("position");
		var pnormal = getPrec("normal");
		var pcolor = getPrec("color");
		var puv = getPrec("uv");
		var pweight = getPrec("weights");

		// build format
		var format = [];
		inline function addFormat(name,type,prec) {
			format.push(new hxd.BufferFormat.BufferInput(name,type,prec));
		}
		addFormat("position", DVec3, ppos);
		if( normals != null )
			addFormat("normal", DVec3, pnormal);
		if( tangents != null )
			addFormat("tangent", DVec3, pnormal);
		for( i in 0...uvs.length )
			addFormat("uv"+(i == 0 ? "" : ""+(i+1)), DVec2, puv);
		if( colors != null )
			addFormat("color", DVec3, pcolor);

		if( skin != null ) {
			if(fourBonesByVertex)
				g.props = [FourBonesByVertex];
			addFormat("weights", DVec3, pweight);  // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
			format.push(new GeometryFormat("indexes", DBytes4));
		}

		if( generateNormals )
			addFormat("logicNormal", DVec3, pnormal);
		g.vertexFormat = hxd.BufferFormat.make(format);
		g.vertexCount = 0;

		// build geometry
		var gm = geom.getGeomMatrix();
		var vbuf = new hxd.FloatBuffer();
		var ibufs = [];

		if( skin != null && skin.isSplit() ) {
			for( _ in skin.splitJoints )
				ibufs.push([]);
		}

		var shapes = geom.getRoot().getAll("Shape");
		var shapeIndexes = []; // Indexes of vertex used in blendshapes
		var remappedShapes = [];
		for ( sIdx => s in shapes ) {
			shapeIndexes.push(s.get("Indexes").getInts());
			remappedShapes.push([]);
			for (i in 0...shapeIndexes[sIdx].length)
				remappedShapes[remappedShapes.length - 1].push([]);
		}

		g.bounds = new h3d.col.Bounds();
		var stride = g.vertexFormat.stride;
		var tmpBuf = new hxd.impl.TypedArray.Float32Array(stride);
		var vertexRemap = new Array<Int>();
		var count = 0, matPos = 0, stri = 0;
		var lookup = new Map();
		var tmp = new h3d.col.Point();
		for( pos in 0...index.length ) {
			var i = index[pos];
			count++;
			if( i >= 0 )
				continue;
			index[pos] = -i - 1;
			var start = pos - count + 1;
			for( n in 0...count ) {
				var k = n + start;
				var vidx = index[k];
				var p = 0;

				var x = verts[vidx * 3];
				var y = verts[vidx * 3 + 1];
				var z = verts[vidx * 3 + 2];
				if( gm != null ) {
					tmp.set(x, y, z);
					tmp.transform(gm);
					x = tmp.x;
					y = tmp.y;
					z = tmp.z;
				}
				tmpBuf[p++] = x;
				tmpBuf[p++] = y;
				tmpBuf[p++] = z;
				g.bounds.addPos(x, y, z);

				if( normals != null ) {
					var nx = normals[k * 3];
					var ny = normals[k * 3 + 1];
					var nz = normals[k * 3 + 2];
					tmpBuf[p++] = nx;
					tmpBuf[p++] = ny;
					tmpBuf[p++] = nz;
				}

				if( tangents != null ) {
					tmpBuf[p++] = round(tangents[k * 4]);
					tmpBuf[p++] = round(tangents[k * 4 + 1]);
					tmpBuf[p++] = round(tangents[k * 4 + 2]);
					if( tangents[k*4+3] < 0 ) {
						tmpBuf[p-3] *= 0.5;
						tmpBuf[p-2] *= 0.5;
						tmpBuf[p-1] *= 0.5;
					}
				}

				for( tuvs in uvs ) {
					var iuv = tuvs.index[k];
					tmpBuf[p++] = tuvs.values[iuv * 2];
					tmpBuf[p++] = 1 - tuvs.values[iuv * 2 + 1];
				}

				if( colors != null ) {
					var icol = colors.index[k];
					tmpBuf[p++] = colors.values[icol * 4];
					tmpBuf[p++] = colors.values[icol * 4 + 1];
					tmpBuf[p++] = colors.values[icol * 4 + 2];
				}

				if( skin != null ) {
					var k = vidx * skin.bonesPerVertex;
					var idx = 0;
					if(!(skin.bonesPerVertex == 3 || skin.bonesPerVertex == 4)) throw "assert";
					for( i in 0...3 )  // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
						tmpBuf[p++] = skin.vertexWeights[k + i];
					for( i in 0...skin.bonesPerVertex )
						idx = (skin.vertexJoints[k + i] << (8*i)) | idx;
					tmpBuf[p++] = int32tof(idx);
				}

				if( generateNormals ) {
					tmpBuf[p++] = 0;
					tmpBuf[p++] = 0;
					tmpBuf[p++] = 0;
				}

				var total = 0.;
				for( i in 0...stride )
					total += tmpBuf[i];
				var itotal = Std.int((total * 100) % 0x0FFFFFFF);

				// look if the vertex already exists
				var found : Null<Int> = null;
				var vids = lookup.get(itotal);
				if( vids == null ) {
					vids = [];
					lookup.set(itotal, vids);
				}
				var inBlendShape = false;
				for ( s in shapeIndexes ) {
					if ( s.contains(vidx) ) {
						inBlendShape = true;
						break;
					}
				}
				if ( !inBlendShape ) { // vertices referenced by blend shapes can't be merged
					for( vid in vids ) {
						var same = true;
						var p = vid * stride;
						for( i in 0...stride )
							if( vbuf[p++] != tmpBuf[i] ) {
								same = false;
								break;
							}
						if( same ) {
							found = vid;
							break;
						}
					}
				}
				if( found == null ) {
					found = g.vertexCount;
					g.vertexCount++;
					for( i in 0...stride )
						vbuf.push(tmpBuf[i]);
					vids.push(found);
				}

				vertexRemap.push(found);

				for ( s in 0...shapeIndexes.length ) {
					for (idx in 0...shapeIndexes[s].length) {
						if (shapeIndexes[s][idx] == vidx) {
							remappedShapes[s][idx].push(found);
						}
					}
				}
			}

			// by-skin-group index
			if( skin != null && skin.isSplit() ) {
				for( n in 0...count - 2 ) {
					var idx = ibufs[skin.triangleGroups[stri++]];
					idx.push(vertexRemap[start + n]);
					idx.push(vertexRemap[start + count - 1]);
					idx.push(vertexRemap[start + n + 1]);
				}
			}
			// by-material index
			else {
				var mid;
				if( mats == null )
					mid = 0;
				else {
					mid = midsSortRemap != null ? midsSortRemap.get(mats[matPos]) : mats[matPos];
					if( mats.length > 1 ) matPos++;
				}
				var idx = ibufs[mid];
				if( idx == null ) {
					idx = [];
					ibufs[mid] = idx;
				}
				for( n in 0...count - 2 ) {
					idx.push(vertexRemap[start + n]);
					idx.push(vertexRemap[start + count - 1]);
					idx.push(vertexRemap[start + n + 1]);
				}
			}

			index[pos] = i; // restore
			count = 0;
		}

		if( generateNormals )
			updateNormals(g,vbuf,ibufs);

		if ( optimizeMesh || decimationFactor > 0.0 ) {
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
			vbuf = optimizedVbuf;
			g.vertexCount = Std.int(optimizedVbuf.length / g.vertexFormat.stride);
			if ( g.vertexCount == 0 )
				return null;
		}

		// write data
		var colVBuf = new FloatBuffer();
		g.vertexPosition = dataOut.length;
		if( lowPrecConfig == null ) {
			for( i in 0...vbuf.length )
				writeFloat(dataOut, vbuf[i]);
		} else {
			for( index in 0...Std.int(vbuf.length / stride) ) {
				var i = index * stride;
				var x = writePrec(dataOut, vbuf[i++], ppos);
				var y = writePrec(dataOut, vbuf[i++], ppos);
				var z = writePrec(dataOut, vbuf[i++], ppos);
				colVBuf.push(x);
				colVBuf.push(y);
				colVBuf.push(z);
				flushPrec(dataOut, ppos,3);
				if( normals != null ) {
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					flushPrec(dataOut, pnormal,3);
				}
				if( tangents != null ) {
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					flushPrec(dataOut, pnormal,3);
				}
				for( k in 0...uvs.length ) {
					writePrec(dataOut, vbuf[i++], puv);
					writePrec(dataOut, vbuf[i++], puv);
					flushPrec(dataOut, puv,2);
				}
				if( colors != null ) {
					writePrec(dataOut, vbuf[i++], pcolor);
					writePrec(dataOut, vbuf[i++], pcolor);
					writePrec(dataOut, vbuf[i++], pcolor);
					flushPrec(dataOut, pcolor,3);
				}
				if( skin != null ) {
					writePrec(dataOut, vbuf[i++], pweight);
					writePrec(dataOut, vbuf[i++], pweight);
					writePrec(dataOut, vbuf[i++], pweight);
					flushPrec(dataOut, pweight,3);
					writeFloat(dataOut, vbuf[i++]);
				}
				if( generateNormals ) {
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					writePrec(dataOut, vbuf[i++], pnormal);
					flushPrec(dataOut, pnormal,3);
				}
				if( i != (index + 1) * stride )
					throw "assert";
			}
		}
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

		if( skin != null && skin.isSplit() )
			matMap = null;

		for ( i in 0...shapes.length ) {
			var remapped = remappedShapes[i];
			var s = shapes[i];
			var shape = new BlendShape();
			shape.name = s.props != null && s.props.length > 0 ? s.props[0].toString() : s.name;
			shape.geom = -1;
			var indexes = s.get("Indexes").getFloats();
			var verts = s.get("Vertices").getFloats();
			var normals = s.get("Normals").getFloats();
			var uvs = s.get("UVs", true)?.getFloats();
			var colors = s.get("Colors", true)?.getFloats();
			format = [];
			addFormat("position", DVec3, ppos);
			if( normals != null )
				addFormat("normal", DVec3, pnormal);
			if( tangents != null )
				addFormat("tangent", DVec3, pnormal);
			if( uvs != null )
				addFormat("uv", DVec2, puv);
			if( colors != null )
				addFormat("color", DVec3, pcolor);
			shape.indexCount = remapped.length;
			shape.vertexCount = indexes.length;
			shape.vertexFormat = hxd.BufferFormat.make(format);
			shape.vertexPosition = dataOut.length;

			var vbuf = new hxd.FloatBuffer();
			for ( i in 0...shape.vertexCount ) {
				vbuf.push(verts[i * 3]);
				vbuf.push(verts[i * 3 + 1]);
				vbuf.push(verts[i * 3 + 2]);
				if ( normals != null ) {
					vbuf.push(normals[i * 3]);
					vbuf.push(normals[i * 3 + 1]);
					vbuf.push(normals[i * 3 + 2]);
				}
				if ( uvs != null ) {
					vbuf.push(uvs[i * 2]);
					vbuf.push(uvs[i * 2 + 1]);
				}
				if ( colors != null ) {
					vbuf.push(colors[i * 3]);
					vbuf.push(colors[i * 3 + 1]);
					vbuf.push(colors[i * 3 + 1]);
				}
			}
			if( lowPrecConfig == null ) {
				for( i in 0...vbuf.length )
					writeFloat(dataOut, vbuf[i]);
			} else {
				for( index in 0...Std.int(vbuf.length / stride) ) {
					var i = index * stride;
					writePrec(dataOut, vbuf[i++], ppos);
					writePrec(dataOut, vbuf[i++], ppos);
					writePrec(dataOut, vbuf[i++], ppos);
					flushPrec(dataOut, ppos,3);
					if( normals != null ) {
						writePrec(dataOut, vbuf[i++], pnormal);
						writePrec(dataOut, vbuf[i++], pnormal);
						writePrec(dataOut, vbuf[i++], pnormal);
						flushPrec(dataOut, pnormal,3);
					}
					if( tangents != null ) {
						writePrec(dataOut, vbuf[i++], pnormal);
						writePrec(dataOut, vbuf[i++], pnormal);
						writePrec(dataOut, vbuf[i++], pnormal);
						flushPrec(dataOut, pnormal,3);
					}
					for( k in 0...uvs.length ) {
						writePrec(dataOut, vbuf[i++], puv);
						writePrec(dataOut, vbuf[i++], puv);
						flushPrec(dataOut, puv,2);
					}
					if( colors != null ) {
						writePrec(dataOut, vbuf[i++], pcolor);
						writePrec(dataOut, vbuf[i++], pcolor);
						writePrec(dataOut, vbuf[i++], pcolor);
						flushPrec(dataOut, pcolor,3);
					}
					if( i != (index + 1) * stride )
						throw "assert";
				}
			}

			shape.remapPosition = dataOut.length;
			for ( i in 0...remapped.length ) {
				for (j in 0...remapped[i].length) {
					var toWrite = remapped[i][j];

					// We don't support models vertex count > 2^32 - 1 because we use
					// the 32th bit for a flag to indicate that it is the last index
					// affected by this offset
					if (toWrite > Math.pow(2, 32) - 1)
						throw ("Not supported, too much vertex");

					if (j == remapped[i].length -1)
						toWrite = toWrite | (1 << 31);

					dataOut.writeInt32(toWrite);
				}
			}
			d.shapes.push(shape);
		}
		return { g : g, materials : matMap, vbuf : colVBuf, ibufs : ibufs };
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

	function buildGeomCollider( vbuf : FloatBuffer, ibufs : Array<Array<Int>>, dataOut : haxe.io.BytesOutput ) : MeshCollider {
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
		iterVertex(function(x, y, z) {
			dataOut.writeFloat(x);
			dataOut.writeFloat(y);
			dataOut.writeFloat(z);
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


	function buildAutoColliders( d : hxd.fmt.hmd.Data, vbuf : FloatBuffer, ibufs : Array<Array<Int>>, mids : Array<Int>, bounds : h3d.col.Bounds, generateCollides : CollideParams, dataOut : haxe.io.BytesOutput ) : ConvexHullsCollider {
		// Format data for our convex hull algorithm
		var vertices : Array<Float> = [];
		var indexes : Array<Int> = [];

		var vertexCount = Std.int(vbuf.length / 3);
		var indexCount = 0;
		for(idx in ibufs)
			indexCount += idx == null ? 0 : idx.length;

		for (i in 0...vertexCount) {
			var x = vbuf[i * 3];
			var y = vbuf[i * 3 + 1];
			var z = vbuf[i * 3 + 2];
			vertices.push(x);
			vertices.push(y);
			vertices.push(z);
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
		var prec = Math.min(dim, generateCollides.precision);
		var subdiv = Math.ceil(dim / prec);
		subdiv = Math.imin(subdiv, generateCollides.maxSubdiv);

		var params = { maxConvexHulls: generateCollides.maxConvexHulls, maxResolution: subdiv * subdiv * subdiv };
		var convexHulls = hxd.fmt.hmd.Data.ConvexHullsCollider.buildConvexHulls(vertices, indexes, params);

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

	function addModels(includeGeometry) {

		var root = buildHierarchy().root;
		var objects = [], joints = [], skins = [], foundSkin : Array<TmpObject> = null;
		var uid = 0;
		function indexRec( t : TmpObject ) {
			if( t.isJoint ) {
				joints.push(t);
			} else {
				var isSkin = false;
				if( foundSkin == null ) {
					for( c in t.childs )
						if( c.isJoint ) {
							isSkin = true;
							break;
						}
				} else
					isSkin = foundSkin.indexOf(t) >= 0;
				if( isSkin ) {
					skins.push(t);
				} else
					objects.push(t);
			}
			for( c in t.childs )
				indexRec(c);
		}
		indexRec(root);

		// create joints
		for( o in joints ) {
			if( o.isMesh ) throw "assert";
			var j = new h3d.anim.Skin.Joint();
			getDefaultMatrixes(o.model); // store for later usage in animation
			j.index = o.model.getId();
			j.name = o.model.getName();
			o.joint = j;
			if( o.parent != null ) {
				j.parent = o.parent.joint;
				if( o.parent.isJoint ) o.parent.joint.subs.push(j);
			}
		}

		// mark skin references
		foundSkin = [];
		for( o in skins ) {
			function loopRec( o : TmpObject ) {
				for( j in o.childs ) {
					if( !j.isJoint ) continue;
					var s = getParent(j.model, "Deformer", true);
					if( s != null ) return s;
					s = loopRec(j);
					if( s != null ) return s;
				}
				return null;
			}
			var subDef = loopRec(o);
			// skip skin with no skinned bone
			if( subDef == null )
				continue;
			var def = getParent(subDef, "Deformer");
			var geoms = getParents(def, "Geometry");
			if( geoms.length == 0 ) continue;
			if( geoms.length > 1 ) throw "Single skin applied to multiple geometries not supported";
			var models = getParents(geoms[0],"Model");
			if( models.length == 0 ) continue;
			if( models.length > 1 ) throw "Single skin applied to multiple models not supported";
			var m = models[0];
			for( o2 in objects )
				if( o2.model == m ) {
					foundSkin.push(o);
					o2.skin = o;
					if( o.model == null ) o.model = m;
					ignoreMissingObject(m.getId()); // make sure we don't store animation for the model (only skin object has one)
					// copy parent
					var p = o.parent;
					if( p != o2 ) {
						o2.parent.childs.remove(o2);
						o2.parent = p;
						if( p != null ) p.childs.push(o2) else root = o2;
					}
					// remove skin from hierarchy
					if( p != null ) p.childs.remove(o);
					// move not joint to new parent
					// (only first level, others will follow their respective joint)
					for( c in o.childs.copy() )
						if( !c.isJoint ) {
							o.childs.remove(c);
							o2.childs.push(c);
							c.parent = o2;
						}
					break;
				}
		}

		// we need to have ignored skins objects anims first
		if( !includeGeometry )
			return;

		objects = [];
		if( root.childs.length <= 1 && root.model == null ) {
			root = root.childs[0];
			root.parent = null;
		}
		if( root != null ) indexRec(root); // reorder after we have changed hierarchy

		var hskins = new Map(), tmpGeom = new Map();
		// prepare things for skinning
		for( g in this.root.getAll("Objects.Geometry") )
			tmpGeom.set(g.getId(), { setSkin : function(_) { }, vertexCount : function() return Std.int(new hxd.fmt.fbx.Geometry(this, g).getVertices().length/3) } );

		var hgeom = new Map();
		var hgeomCol = new Map();
		var hmat = new Map<Int,Int>();
		var hlods = new Map<String, Array<Index<Model>>>();
		var index = 0;
		for( o in objects ) {

			o.index = index++;

			var model = new Model();
			var ref = o.skin == null ? o : o.skin;

			model.name = o.model == null ? null : o.model.getName();
			model.parent = o.parent == null || o.parent.isJoint ? -1 : o.parent.index;
			model.follow = o.parent != null && o.parent.isJoint ? o.parent.model.getName() : null;
			var m = ref.model == null ? new hxd.fmt.fbx.BaseLibrary.DefaultMatrixes() : getDefaultMatrixes(ref.model);
			var p = new Position();
			p.x = m.trans == null ? 0 : -m.trans.x;
			p.y = m.trans == null ? 0 : m.trans.y;
			p.z = m.trans == null ? 0 : m.trans.z;
			p.sx = m.scale == null ? 1 : m.scale.x;
			p.sy = m.scale == null ? 1 : m.scale.y;
			p.sz = m.scale == null ? 1 : m.scale.z;

			if( o.model != null && o.model.getType() == "Camera" ) {
				var props = getChild(o.model, "NodeAttribute");
				var fov = 45., ratio = 16 / 9;
				for( p in props.getAll("Properties70.P") ) {
					switch( p.props[0].toString() ) {
					case "FilmAspectRatio":
						ratio = p.props[4].toFloat();
					case "FieldOfView":
						fov = p.props[4].toFloat();
					default:
					}
				}
				var fovY = 2 * Math.atan( Math.tan(fov * 0.5 * Math.PI / 180) / ratio ) * 180 / Math.PI;
				if( model.props == null ) model.props = [];
				model.props.push(CameraFOVY(fovY));
			}

			var q = m.toQuaternion(true);
			q.normalize();
			if( q.w < 0 ) q.negate();
			p.qx = q.x;
			p.qy = q.y;
			p.qz = q.z;
			model.position = p;
			model.geometry = -1;
			d.models.push(model);

			if( !o.isMesh ) continue;

			var mids : Array<Int> = [];
			var hasNormalMap = false;
			for( m in getChilds(o.model, "Material") ) {
				var mid = hmat.get(m.getId());
				if( mid != null ) {
					mids.push(mid);
					var m = d.materials[mid];
					hasNormalMap = m.normalMap != null;
					continue;
				}
				var mat = new Material();
				mid = d.materials.length;
				mids.push(mid);
				hmat.set(m.getId(), mid);
				d.materials.push(mat);

				mat.name = m.getName();
				mat.blendMode = null;

				// if there's a slight amount of opacity on the material
				// it's usually meant to perform additive blending on 3DSMax
				for( p in m.getAll("Properties70.P") ) {
					var pval = p.props[4];
					switch( p.props[0].toString() ) {
					case "Opacity":
						var v = pval.toFloat();
						if( v < 1 && v > 0.98 && mat.blendMode == null ) mat.blendMode = Add;
					default:
					}
				}

				// get texture
				var texture = getSpecChild(m, "DiffuseColor");
				if( texture != null ) {
					var path = makeTexturePath(texture);
					if( path != null ) mat.diffuseTexture = path;
				}

				// get other textures
				mat.normalMap = makeTexturePath(getSpecChild(m, "NormalMap"));
				if( mat.normalMap != null )
					hasNormalMap = true;
				var spec = getSpecChild(m, "SpecularFactor"); // 3dsMax
				if( spec == null ) spec = getSpecChild(m, "SpecularColor"); // maya
				mat.specularTexture = makeTexturePath(spec);
				if( mat.normalMap != null || mat.specularTexture != null ) {
					if( mat.props == null ) mat.props = [];
					mat.props.push(HasExtraTextures);
				}

				// get alpha map
				var transp = getSpecChild(m, "TransparentColor");
				if( transp != null ) {
					var path = transp.get("FileName").props[0].toString();
					if( path != "" ) {
						path = path.toLowerCase();
						var ext = path.split(".").pop();
						if( texture != null && path == texture.get("FileName").props[0].toString().toLowerCase() ) {
							// if that's the same file, we're doing alpha blending
							if( mat.blendMode == null && ext != "jpg" && ext != "jpeg" ) mat.blendMode = Alpha;
						} else
							throw "Alpha texture that is different from diffuse is not supported in HMD";
					}
				}

				if( mat.blendMode == null ) mat.blendMode = None;
			}

			var g = getChild(o.model, "Geometry");

			var skin = null;
			if( o.skin != null ) {
				var rootJoints = [];
				for( c in o.skin.childs )
					if( c.isJoint )
						rootJoints.push(c.joint);
				skin = createSkin(hskins, tmpGeom, rootJoints);
				if( skin.boundJoints.length > maxBonesPerSkin ) {
					var g = new hxd.fmt.fbx.Geometry(this, g);
					var idx = g.getIndexes();
					skin.split(maxBonesPerSkin, [for( i in idx.idx ) idx.vidx[i]], mids.length > 1 ? g.getMaterialByTriangle() : null);
				}
				model.skin = makeSkin(skin, o.skin);
			}

			// Reorder materials to ensure there are in the same order for lods
			var lodsInfos = getLODInfos(model.name);
			if (lodsInfos.lodLevel != -1) {
				midsSortRemap = new Map<Int, Int>();
				for (idx in 0...mids.length) {
					midsSortRemap.set(idx, mids[idx]);
					mids[idx] = idx;
				}
			}

			var gdata = hgeom.get(g.getId());
			if( gdata == null ) {
				var geomData = new hxd.fmt.fbx.Geometry(this, g);

				var geom = buildGeom(geomData, skin, dataOut, hasNormalMap || generateTangents);

				gdata = { gid : d.geometries.length, materials : geom.materials };
				var gdataCol = { gid : d.geometries.length, mids : mids, vbuf : geom.vbuf, ibufs : geom.ibufs };
				d.geometries.push(geom.g);
				hgeom.set(g.getId(), gdata);
				hgeomCol.set(gdataCol.gid, gdataCol);
				for ( s in d.shapes ) {
					if (s.geom == -1)
						s.geom = gdata.gid;
				}
			}
			model.geometry = gdata.gid;

			if( mids.length == 0 ) {
				var mat = new Material();
				mat.blendMode = None;
				mat.name = "default";
				var mid = d.materials.length;
				d.materials.push(mat);
				mids = [mid];
			}
			if( gdata.materials == null )
				model.materials = mids;
			else if (lod0Mids != null && lodsInfos.lodLevel > 0)
				model.materials = [for( id in gdata.materials ) lod0Mids[id]];
			else
				model.materials = [for( id in gdata.materials ) mids[id]];

			if (lodsInfos.lodLevel == 0)
				lod0Mids = mids;
			var lodsInfos = getLODInfos(model.name);
			var lodIndex = lodsInfos.lodLevel;
			var key = lodsInfos.modelName;
			if ( lodIndex >= 0 ) {
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
			} else if ( lodsDecimation != null && model.skin == null && !model.isCollider() ) {
				var modelName = model.name;
				model.name = model.toLODName(0);
				if( model.props == null ) model.props = [];
				model.props.push(HasLod);
				model.lods = [];
				for ( i => lods in lodsDecimation ) {
					var geom = buildGeom(new hxd.fmt.fbx.Geometry(this, g), skin, dataOut, hasNormalMap || generateTangents, lods);
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
		}

		// Make colliders
		d.colliders = [];
		for( model in d.models ) {
			if( model.geometry < 0 || model.isLOD() || model.isCollider() )
				continue;
			if( model.props == null ) model.props = [];

			function findMeshModel( name : String ) {
				if( name == null )
					return null;
				for( model in d.models ) {
					if( model.geometry >= 0 && model.name == name )
						return model;
				}
				return null;
			}

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

			for( idx => mc in mcs ) {
				var params = mc == null && mc.useDefault ? generateCollides : mc;
				var colliderType = hxd.fmt.hmd.Data.Collider.resolveColliderType(d, model, mc, collisionThresholdHeight, collisionUseLowLod);
				var collider : Collider = switch (colliderType) {
					case Empty:
						new EmptyCollider();
					case ConvexHulls(model):
						var gdataCol = hgeomCol.get(model.geometry);
						buildAutoColliders(d, gdataCol.vbuf, gdataCol.ibufs, gdataCol.mids, d.geometries[model.geometry].bounds, params, dataOut);
					case Mesh(model):
						var gdataCol = hgeomCol.get(model.geometry);
						buildGeomCollider(gdataCol.vbuf, gdataCol.ibufs, dataOut);
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
	}

	function makeTexturePath( tex : FbxNode ) {
		if( tex == null )
			return null;
		var path = tex.get("FileName").props[0].toString();
		if( path == "" )
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

	function makeSkin( skin : h3d.anim.Skin, obj : TmpObject ) {
		var s = new Skin();
		s.name = obj.model.getName();
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
		var q = new h3d.Quat();
		q.initRotateMatrix(m);
		q.normalize();
		if( q.w < 0 ) q.negate();
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

	public static inline function writeFloat(d : haxe.io.BytesOutput, f : Float ) {
		d.writeFloat( f == 0 ? 0 : f ); // prevent negative zero
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

	public function toHMD( filePath : String, includeGeometry : Bool ) : Data {

		// if we have only animation data, make sure to export all joints positions
		// because they might be applied to a different model at runtime
		if( !includeGeometry )
			optimizeSkin = false;

		leftHandConvert();
		autoMerge();

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

		addModels(includeGeometry);

		var names = getAnimationNames();
		for ( animName in names ) {
			var anim = loadAnimation(animName);
			if(anim != null)
				d.animations.push(makeAnimation(anim));
		}

		d.data = dataOut.getBytes();
		return d;
	}

}
