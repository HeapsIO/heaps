package hxd.tools;

typedef ConvexHullData = { vertices : Array<Float>, indexes : Array<Int> };

/**
	The mesh processing of the FBX to HMD conversion : tangents, optimization and LODs, convex hulls.
	With the natives of HashLink in HL, the meshTools executable elsewhere (tools/meshTools, in the PATH).
	A platform that has these natives otherwise (a Node addon in Electron) replaces these functions.
**/
class MeshTools {

	/**
		The MikkTSpace tangents of `count` vertices of `stride` floats (position at `xPos`, normal at `normalPos`,
		uv at `uvPos`), one per index : the triangles are 0,1,2 then 3,4,5... Returns 4 floats per vertex :
		the tangent and its sign.
	**/
	public static dynamic function mikktspace( vertices : haxe.io.Bytes, count : Int, stride : Int, xPos : Int, normalPos : Int, uvPos : Int, threshold = 180. ) : haxe.io.Bytes {
		#if (hl && !hl_disable_mikkt)
		var tangents = haxe.io.Bytes.alloc(count << 4);
		tangents.fill(0, tangents.length, 0);
		for( i in 0...count )
			tangents.setFloat(i << 4, 1);
		var m = new Mikktspace();
		m.buffer = @:privateAccess vertices.b;
		m.stride = stride;
		m.xPos = xPos;
		m.normalPos = normalPos;
		m.uvPos = uvPos;
		var indexes = new hl.Bytes(count << 2);
		for( i in 0...count )
			indexes.setI32(i << 2, i);
		m.indexes = indexes;
		m.indices = count;
		m.tangents = @:privateAccess tangents.b;
		m.tangentStride = 4;
		m.tangentPos = 0;
		m.compute(threshold);
		return tangents;
		#elseif (sys || nodejs)
		var data = new haxe.io.BytesOutput();
		data.writeInt32(count);
		data.writeInt32(stride);
		data.writeInt32(xPos);
		data.writeInt32(normalPos);
		data.writeInt32(uvPos);
		data.writeFullBytes(vertices, 0, count * stride * 4);
		data.writeInt32(count);
		for( i in 0...count )
			data.writeInt32(i);
		return run("mikktspace", data.getBytes(), threshold == 180 ? [] : ['$threshold'], "Failed to call 'mikktspace' executable required to generate tangent data. Please ensure it's in your PATH");
		#else
		throw "Tangent generation is not supported on this platform";
		#end
	}

	/**
		Optimizes a mesh in place : merges its identical vertices, simplifies it to `targetIndexCount` indexes when it
		is not negative (the LODs, with `targetError` relative to its size), then orders it for the vertex cache, the
		overdraw and the vertex fetch. `vertices` holds `vertexCount` vertices of `vertexSize` bytes, position first,
		`indexes` holds `indexCount` Int32. Returns the new counts, the data at the start of the buffers, or null when
		the platform cannot optimize.
	**/
	public static dynamic function optimize( vertices : haxe.io.Bytes, vertexCount : Int, vertexSize : Int, indexes : haxe.io.Bytes, indexCount : Int, targetIndexCount = -1, targetError = 0. ) : { vertexCount : Int, indexCount : Int } {
		#if (hl && hl_ver >= version("1.15.0"))
		var v = @:privateAccess vertices.b;
		var idx = @:privateAccess indexes.b;
		var remap = new hl.Bytes(vertexCount << 2);
		var uniqueVertexCount = MeshOptimizer.generateVertexRemap(remap, idx, indexCount, v, vertexCount, vertexSize);
		MeshOptimizer.remapIndexBuffer(idx, idx, indexCount, remap);
		MeshOptimizer.remapVertexBuffer(v, v, vertexCount, vertexSize, remap);
		vertexCount = uniqueVertexCount;
		if( targetIndexCount >= 0 )
			indexCount = MeshOptimizer.simplify(idx, idx, indexCount, v, vertexCount, vertexSize, targetIndexCount, targetError, MeshOptimizer.SimplifyOptions.LockBorder | MeshOptimizer.SimplifyOptions.Prune, null);
		MeshOptimizer.optimizeVertexCache(idx, idx, indexCount, vertexCount);
		MeshOptimizer.optimizeOverdraw(idx, idx, indexCount, v, vertexCount, vertexSize, 1.05);
		vertexCount = MeshOptimizer.optimizeVertexFetch(v, idx, indexCount, v, vertexCount, vertexSize);
		return { vertexCount : vertexCount, indexCount : indexCount };
		#elseif (sys || nodejs)
		var data = new haxe.io.BytesOutput();
		data.writeInt32(vertexCount);
		data.writeInt32(vertexSize);
		data.writeFullBytes(vertices, 0, vertexCount * vertexSize);
		data.writeInt32(indexCount);
		data.writeFullBytes(indexes, 0, indexCount << 2);
		var error = "Failed to call 'meshTools' executable required to generate optimized mesh. Please ensure it's in your PATH";
		var out = targetIndexCount >= 0 ? run("simplify", data.getBytes(), ['$targetIndexCount', '$targetError'], error) : run("optimize", data.getBytes(), [], error);
		vertexCount = out.getInt32(0);
		vertices.blit(0, out, 4, vertexCount * vertexSize);
		var pos = 4 + vertexCount * vertexSize;
		indexCount = out.getInt32(pos);
		indexes.blit(0, out, pos + 4, indexCount << 2);
		return { vertexCount : vertexCount, indexCount : indexCount };
		#else
		return null;
		#end
	}

	/**
		The convex hulls (V-HACD) of a mesh : `vertices` holds `vertexCount` positions of 3 Float32, `indexes` holds
		`triangleCount` triangles of 3 Int32.
	**/
	public static dynamic function convexHulls( vertices : haxe.io.Bytes, vertexCount : Int, indexes : haxe.io.Bytes, triangleCount : Int, maxConvexHulls : Int, resolution : Int ) : Array<ConvexHullData> {
		var out : Array<ConvexHullData> = [];
		#if (hl && hl_ver >= version("1.15.0"))
		var vhacd = new VHACD();
		var p = new VHACD.Parameters();
		p.maxConvexHulls = maxConvexHulls;
		p.maxResolution = resolution;
		vhacd.compute(@:privateAccess vertices.b, vertexCount, @:privateAccess indexes.b, triangleCount, p);
		var convexHullCount = vhacd.getConvexHullCount();
		if( convexHullCount == 0 )
			return null;
		var convexHull = new VHACD.ConvexHull();
		for( i in 0...convexHullCount ) {
			vhacd.getConvexHull(i, convexHull);
			var points = convexHull.points;
			var vertices = [for( k in 0...convexHull.pointCount * 3 ) points.getF64(k << 3)];
			var triangles = convexHull.triangles;
			var indexes = [for( k in 0...convexHull.triangleCount * 3 ) triangles.getI32(k << 2)];
			out.push({ vertices : vertices, indexes : indexes });
		}
		vhacd.release();
		#elseif (sys || nodejs)
		var data = new haxe.io.BytesOutput();
		data.writeInt32(vertexCount);
		data.writeFullBytes(vertices, 0, vertexCount * 12);
		data.writeInt32(triangleCount);
		data.writeFullBytes(indexes, 0, triangleCount * 12);
		var bytes = run("vhacd", data.getBytes(), ['$maxConvexHulls', '$resolution'], "Failed to call 'meshTools' executable required to generate collision data. Please ensure it's in your PATH (see tools/meshTools for build)");
		var pos = 0;
		inline function int() { var v = bytes.getInt32(pos); pos += 4; return v; }
		var convexHullCount = int();
		for( _ in 0...convexHullCount ) {
			var pointCount = int();
			var vertices = [for( k in 0...pointCount * 3 ) bytes.getDouble(pos + (k << 3))];
			pos += pointCount * 24;
			var triangleCount = int();
			var indexes = [for( k in 0...triangleCount * 3 ) bytes.getInt32(pos + (k << 2))];
			pos += triangleCount * 12;
			out.push({ vertices : vertices, indexes : indexes });
		}
		#end
		return out;
	}

	#if (sys || nodejs)
	static function run( command : String, data : haxe.io.Bytes, args : Array<String>, error : String ) : haxe.io.Bytes {
		var fileName = tmpFile(command + "_data");
		var outFile = fileName + ".out";
		sys.io.File.saveBytes(fileName, data);
		#if nodejs
		// no console window on Windows (an Electron app)
		var ret : Null<Int> = js.node.ChildProcess.spawnSync("meshTools", [command, fileName, outFile].concat(args), cast { stdio : "inherit", windowsHide : true }).status;
		if( ret == null ) ret = -1;
		#else
		var ret = try Sys.command("meshTools", [command, fileName, outFile].concat(args)) catch( e : Dynamic ) -1;
		#end
		sys.FileSystem.deleteFile(fileName);
		if( ret != 0 )
			throw error;
		var bytes = sys.io.File.getBytes(outFile);
		sys.FileSystem.deleteFile(outFile);
		return bytes;
	}

	static function tmpFile( name : String ) {
		var tmp = Sys.getEnv("TMPDIR");
		if( tmp == null ) tmp = Sys.getEnv("TMP");
		if( tmp == null ) tmp = Sys.getEnv("TEMP");
		if( tmp == null ) tmp = ".";
		return tmp+"/"+name+Date.now().getTime()+"_"+Std.random(0x1000000)+".bin";
	}
	#end

}
