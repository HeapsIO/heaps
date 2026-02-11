package hxsl;

#if (sys || nodejs)

@:structInit
private class ShaderListInfo {
	public var name : String;
	public var p : Int;
	public var constBits : Int;
}

@:access(hxsl.CacheFile2)
class CacheFile2Loader {
	var cache : CacheFile2;

	// Input from file
	public var lkInfos : Array<{ name : String, vars : Array<hxsl.Output> }> = [];
	public var bcMap : Map<String, { sign : String, params : hxsl.Cache.BatchInstanceParams }> = [];
	public var rtInfosDefault : Array<{ sign : String, sl : Array<ShaderListInfo> }> = [];
	public var rtInfosBatch : Array<{ sign : String, sl : Array<ShaderListInfo> }> = [];
	public var rtInfosCompute : Array<{ sign : String, sl : Array<ShaderListInfo> }> = [];
	public var bfMap : Map<Int, hxd.BufferFormat> = [];

	// Tmp used by run
	var onDone : Void -> Void;
	var ssMap : Map<String, SharedShader> = [];
	var slistsDefault : Array<{ sign : String, sl : ShaderList }> = [];
	var slistsBatch : Array<ShaderList> = [];
	var slistsCompute : Array<ShaderList> = [];
	var rtMap : Map<String, { rt : RuntimeShader, sl : hxsl.ShaderList }> = [];
	#if heaps_mt_hxsl_cache
	var workThread : sys.thread.Thread;
	var event : haxe.MainLoop.MainEvent = null;
	var rtMapReady : Bool = false;
	var bcListsReady : Bool = false;
	var linkDone : Bool = false;
	#end

	public function new( cache : CacheFile2 ) {
		this.cache = cache;
	}

	public function run( onDone : Void -> Void ) {
		this.onDone = onDone;

		// Build ShaderLinker
		for( lk in lkInfos ) {
			var shader = cache.getLinkShader(lk.vars);
			ssMap.set(lk.name, @:privateAccess shader.shader);
		}

		// Build ShaderList Default
		for( rtInfo in rtInfosDefault ) {
			var sl = makeShaderList(rtInfo.sl, Default);
			if( sl != null ) {
				slistsDefault.push({ sign : rtInfo.sign, sl : sl });
			}
		}

		// Build ShaderList Compute
		for( rtInfo in rtInfosCompute ) {
			var sl = makeShaderList(rtInfo.sl, Compute);
			if( sl != null ) {
				slistsCompute.push(sl);
			}
		}

		#if heaps_mt_hxsl_cache
		workThread = sys.thread.Thread.create(threadLoop, (e) -> { linkDone = true; });
		workThread.name = "CacheFile2Loader";
		event = haxe.MainLoop.add(update);
		#else
		threadLoop();
		if( this.onDone != null )
			this.onDone();
		#end
	}

	function threadLoop() {
		// Link ShaderList Default
		for( l in slistsDefault ) {
			var rts = cache.link(l.sl, Default);
			rtMap.set(l.sign, { rt : rts, sl : l.sl });
		}

		// Link ShaderList Compute
		for( sl in slistsCompute ) {
			var rts = cache.link(sl, Compute);
		}

		#if heaps_mt_hxsl_cache
		rtMapReady = true;
		while( !bcListsReady ) {
			Sys.sleep(0.1);
		}
		#else
		buildBatchShaders();
		#end

		// Link ShaderList Batch
		for( sl in slistsBatch ) {
			var rts = cache.link(sl, Batch);
		}

		#if heaps_mt_hxsl_cache
		linkDone = true;
		#end
	}

	#if heaps_mt_hxsl_cache
	function update() {
		if( !rtMapReady )
			return;
		if( !bcListsReady ) {
			buildBatchShaders();
			bcListsReady = true;
			return;
		}
		if( linkDone ) {
			if( this.onDone != null )
				this.onDone();
			event.stop();
			event = null;
		}
	}
	#end

	function buildBatchShaders() {
		for( rtInfo in rtInfosBatch ) {
			var sl = makeShaderList(rtInfo.sl, Batch);
			if( sl != null ) {
				slistsBatch.push(sl);
			}
		}
	}

	function makeShaderList( slinfos : Array<ShaderListInfo>, mode : RuntimeShader.LinkMode ) {
		var sl = null;
		var i = slinfos.length;
		while( i > 0 ) {
			i--;
			var slinfo = slinfos[i];
			var name = slinfo.name;
			var priority = slinfo.p;
			var constBits = slinfo.constBits;
			var ssd = ssMap.get(name);
			if( ssd == null && mode == Batch ) {
				var bcinfo = bcMap.get(name);
				if( bcinfo != null ) {
					var rts = rtMap.get(bcinfo.sign);
					if( rts == null ) {
						cache.log("Base shader not found for " + name);
						sl = null;
						break;
					}
					var b = cache.makeBatchShader(rts.rt, rts.sl.next, bcinfo.params);
					ssd = @:privateAccess b.shader;
				}
			}
			if( ssd == null ) {
				var sd = resolveShader(name);
				if( sd == null ) {
					cache.log("Missing shader " + name);
					sl = null;
					break;
				}
				ssd = @:privateAccess sd.shader;
				ssMap.set(name, ssd);
			}
			// Remap constBits based on BufferFormat
			var remapFailed = false;
			var c = ssd.consts;
			while( c != null ) {
				switch( c.v.type ) {
				case TBuffer(_, _, _):
					var bits = (constBits >>> c.pos) & ((1 << c.bits) - 1);
					var fmt = bfMap.get(bits);
					if( fmt == null ) {
						remapFailed = true;
						break;
					}
					constBits ^= bits << c.pos;
					constBits |= fmt.uid << c.pos;
				default:
				}
				c = c.next;
			}
			if( remapFailed ) {
				cache.log('Remap BufferFormat failed $name(${StringTools.hex(constBits)})');
				sl = null;
				break;
			}
			var s = Type.createEmptyInstance(hxsl.Shader);
			@:privateAccess {
				s.priority = priority;
				s.constBits = constBits;
				s.shader = ssd;
				try {
					s.instance = ssd.getInstance(constBits);
				} catch( e ) {
					cache.log('Can\'t instance shader $name(${StringTools.hex(constBits)}): ' + e.toString());
					sl = null;
					break;
				}
			}
			sl = new ShaderList(s, sl);
		}
		return sl;
	}

	function resolveShader( name : String ) : hxsl.Shader {
		if ( StringTools.endsWith(name, ".shgraph") ) {
			#if hide
			var shgraph : hrt.shgraph.ShaderGraph = try cast hxd.res.Loader.currentInstance.load(name).toPrefab().load() catch( e : hxd.res.NotFound ) null;
			if (shgraph == null)
				return null;
			return shgraph.makeShaderInstance();
			#else
			return null;
			#end
		}
		var cl = Type.resolveClass(name);
		if( cl == null )
			return null;
		var shader : hxsl.Shader = Type.createEmptyInstance(cl);
		@:privateAccess shader.initialize();
		return shader;
	}
}

/**
	Similar to CacheFile, but save only platform-independent RuntimeShader data (shader list).
**/
class CacheFile2 extends Cache {
	static var DEBUG : Bool = false;
	static var LOAD_TIME : Float = 0.0;

	var file : String;
	var outFile : String;
	var allowSave : Bool;

	var isLoading : Bool = false;
	var isDirty(default, set) : Bool = false;
	var runtimesDefault : Array<RuntimeShader> = [];
	var runtimesBatch : Array<RuntimeShader> = [];
	var runtimesCompute : Array<RuntimeShader> = [];
	var linkers : Array<{ name : String, vars : Array<hxsl.Output> }> = [];
	var batchers : Array<{ name : String, rt : RuntimeShader, params : hxsl.Cache.BatchInstanceParams }> = [];
	#if heaps_mt_hxsl_cache
	var rtMutex : sys.thread.Mutex;
	#end

	public function new( file : String, allowSave : Bool, ?outFile : String ) {
		super();
		this.file = file;
		this.outFile = outFile != null ? outFile : file;
		this.allowSave = allowSave;
		#if heaps_mt_hxsl_cache
		rtMutex = new sys.thread.Mutex();
		#end
		#if !shader_debug_dump
		load();
		#end
	}

	function set_isDirty( b : Bool ) {
		if( isLoading )
			return isDirty;
		if( allowSave && !isDirty && b ) {
			haxe.Timer.delay(saveIfModified, 1000);
		}
		return isDirty = b;
	}

	override function createLinkShader( key : String, vars : Array<hxsl.Output>, vertexOutputName ) {
		var shader = super.createLinkShader(key, vars, vertexOutputName);
		var name = shader.data.name;
		linkers.push({ name : name, vars : vars.copy() });
		return shader;
	}

	override function createBatchShader( rt, shaders, params ) {
		var b = super.createBatchShader(rt, shaders, params);
		var name = b.shader.data.name;
		batchers.push({ name : name, rt : rt, params : params });
		return b;
	}

	override function compileRuntimeShader( shaders : hxsl.ShaderList, mode ) {
		var rt = super.compileRuntimeShader(shaders, mode);
		if( !isLoading ) {
			log("Compiled runtime shader (" + mode.getName() + "): " + rt.spec.signature + ":" + [for( inst in rt.spec.instances ) @:privateAccess inst.shader.data.name].join(":"));
		}
		#if heaps_mt_hxsl_cache
		var acquired = false;
		if( isLoading ) {
			rtMutex.acquire();
			acquired = true;
		}
		#end
		switch( mode ) {
		case Default: runtimesDefault.push(rt);
		case Batch: runtimesBatch.push(rt);
		case Compute: runtimesCompute.push(rt);
		}
		isDirty = true;
		#if heaps_mt_hxsl_cache
		if( acquired )
			rtMutex.release();
		#end
		return rt;
	}

	inline function log( str : String ) {
		if( DEBUG )
			Sys.println("[CacheFile2] " + str);
	}

	function load() {
		isLoading = true;

		var tLoadStart = haxe.Timer.stamp();
		var loader = new CacheFile2Loader(this);

		loadFile(loader, file);
		if( outFile != file ) {
			loadFile(loader, outFile);
		}

		loader.run(function() {
			var tLoadEnd = haxe.Timer.stamp();
			var dt = tLoadEnd - tLoadStart;
			CacheFile2.LOAD_TIME = dt;
			log('${runtimesDefault.length + runtimesBatch.length} shaders loaded in ${hxd.Math.fmt(dt)}s');
			isLoading = false;
		});
	}

	static function loadFile( loader : CacheFile2Loader, file : String ) : Bool {
		if( !sys.FileSystem.exists(file) ) {
			return false;
		}

		var f = new haxe.io.BytesInput(sys.io.File.getBytes(file));

		inline function readLine() {
			return f.position < f.length ? f.readLine() : "";
		}

		var magic = readLine();
		if( !StringTools.startsWith(magic, "CF2-1") ) {
			f.close();
			return false;
		}

		while( true ) {
			var line = readLine();
			if( line.length == 0 )
				break;
			var lkinfo = line.split(";");
			if( lkinfo.length < 2 )
				continue;
			var name = lkinfo[0];
			var vars = haxe.Unserializer.run(lkinfo[1]);
			loader.lkInfos.push({ name : name, vars : vars });
		}

		while( true ) {
			var line = readLine();
			if( line.length == 0 )
				break;
			var bcinfo = line.split(";");
			if( bcinfo.length < 3 )
				continue;
			var name = bcinfo[0];
			var sign = bcinfo[1];
			var forced = [];
			for( s in bcinfo[2].split(":") ) {
				if( s.length == 0 )
					break;
				var v = s.split("=");
				forced.push({ shader : v[0], params : v[1].split(",")});
			}
			var params = forced.length == 0 ? null : new hxsl.Cache.BatchInstanceParams(forced);
			loader.bcMap.set(name, { sign : sign, params : params });
		}

		var mode : RuntimeShader.LinkMode = Default;
		while( true ) {
			var line = readLine();
			if( line.length == 0 ) {
				switch( mode ) {
				case Default:
					mode = Batch;
					continue;
				case Batch:
					mode = Compute;
					continue;
				case Compute:
				}
				break;
			}
			// Reconstruct ShaderList
			var sl : Array<ShaderListInfo> = [];
			var parts = line.split(";");
			var sign = parts[0];
			var slinfos = parts[1].split(":");
			for( part in slinfos ) {
				var slinfo = part.split(",");
				if( slinfo.length < 3 )
					continue;
				var name = slinfo[0];
				var priority = Std.parseInt(slinfo[1]);
				var constBits = Std.parseInt(slinfo[2]);
				sl.push({ name : name, p : priority, constBits : constBits });
			}
			if( sl.length != 0 ) {
				switch( mode ) {
				case Default: loader.rtInfosDefault.push({ sign : sign, sl : sl });
				case Batch: loader.rtInfosBatch.push({ sign : sign, sl : sl });
				case Compute: loader.rtInfosCompute.push({ sign : sign, sl : sl });
				}
			}
		}

		while( true ) {
			var line = readLine();
			if( line.length == 0 )
				break;
			var bfinfo = line.split(";");
			if( bfinfo.length < 2 )
				continue;
			var uid = Std.parseInt(bfinfo[0]);
			var inputs : Array<hxd.BufferFormat.BufferInput> = [];
			var inputInfos = bfinfo[1].split(":");
			for( part in inputInfos ) {
				var iinfo = part.split(",");
				if( iinfo.length < 3 )
					continue;
				var name = iinfo[0];
				var type = hxd.BufferFormat.InputFormat.fromInt(Std.parseInt(iinfo[1]));
				var precision = hxd.BufferFormat.Precision.fromInt(Std.parseInt(iinfo[2]));
				inputs.push({ name : name, type : type, precision : precision });
			}
			var format = hxd.BufferFormat.make(inputs);
			loader.bfMap.set(uid, format);
		}

		f.close();
		return true;
	}

	function saveIfModified() {
		if( this.isDirty ) {
			this.isDirty = false;
			#if !shader_debug_dump
			save();
			#end
		}
	}

	function save() {
		if( !allowSave ) return;

		var out = new haxe.io.BytesOutput();
		out.writeString("CF2-1\n", UTF8); // magic-version

		linkers.sort((l1, l2) -> Reflect.compare(l1.name, l2.name));
		for( lk in linkers ) {
			var serializer = new haxe.Serializer();
			serializer.useCache = true;
			serializer.useEnumIndex = true;
			serializer.serialize(lk.vars);
			out.writeString('${lk.name};${serializer.toString()}\n');
		}
		out.writeString("\n");

		batchers.sort((b1, b2) -> Reflect.compare(b1.name, b2.name));
		for( bc in batchers ) {
			var name = bc.name;
			var slsign = bc.rt.spec.signature;
			var params = bc.params == null ? [] : [for( s in @:privateAccess bc.params.forcedPerInstance ) s.shader+"="+s.params.join(",")];
			out.writeString('${name};${slsign};${params.join(":")}\n');
		}
		out.writeString("\n");

		runtimesDefault.sort((rt1, rt2) -> Reflect.compare(rt1.spec.signature, rt2.spec.signature));
		runtimesBatch.sort((rt1, rt2) -> Reflect.compare(rt1.spec.signature, rt2.spec.signature));
		runtimesCompute.sort((rt1, rt2) -> Reflect.compare(rt1.spec.signature, rt2.spec.signature));
		var formatRemap : Map<Int, hxd.BufferFormat> = [];
		function collectRemapConstBits( ssd : SharedShader, constBits : Int ) {
			var c = ssd.consts;
			while( c != null ) {
				switch( c.v.type ) {
				case TBuffer(_, _, _):
					var bits = (constBits >>> c.pos) & ((1 << c.bits) - 1);
					var fmt = hxd.BufferFormat.fromID(bits);
					formatRemap.set(bits, fmt);
				default:
				}
				c = c.next;
			}
			return constBits;
		}
		function writeRtArr( rtArr : Array<RuntimeShader> ) {
			for( rt in rtArr ) {
				if( rt.spec.instances.length == 0 )
					continue;
				out.writeString(rt.spec.signature + ";");
				for( inst in rt.spec.instances ) {
					var name = @:privateAccess inst.shader.data.name;
					var priority = inst.index;
					var constBits = inst.bits;
					out.writeString('${name},${priority},${constBits}:');
					collectRemapConstBits(inst.shader, constBits);
				}
				out.writeString("\n");
			}
			out.writeString("\n");
		}
		// Batch should be after Default for reconstruction
		writeRtArr(runtimesDefault);
		writeRtArr(runtimesBatch);
		writeRtArr(runtimesCompute);

		var formats = [ for( uid => v in formatRemap ) { uid : uid, format : [for( i in v.getInputs() ) '${i.name},${i.type.toInt()},${i.precision.toInt()}'].join(":") } ];
		formats.sort((f1, f2) -> Reflect.compare(f1.format, f2.format));
		for( f in formats ) {
			out.writeString('${f.uid};${f.format}\n');
		}
		out.writeString("\n");

		sys.io.File.saveBytes(outFile, out.getBytes());
		log("Cache file saved to " + outFile);
	}
}

#end
