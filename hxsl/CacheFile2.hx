package hxsl;

#if (sys || nodejs)

@:access(hxsl.CacheFile2)
class CacheFile2Loader {
	var cache : CacheFile2;

	// Input from file
	public var lkInfos : Array<{ name : String, vars : Array<hxsl.Output> }> = [];
	public var bcMap : Map<String, { sign : String, params : hxsl.Cache.BatchInstanceParams }> = [];
	public var rtInfos : Array<{ sign : String, sl : Array<{ name : String, p : Int, constBits : Int }>, mode : RuntimeShader.LinkMode }> = [];

	// Tmp used by run
	var onDone : Void -> Void;
	var ssMap : Map<String, SharedShader> = [];
	var slists : Array<{ sl : ShaderList, mode : RuntimeShader.LinkMode }> = [];
	var rtMap : Map<String, { rt : RuntimeShader, sl : hxsl.ShaderList }> = [];
	#if heaps_mt_hxsl_cache
	var workThread : sys.thread.Thread;
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

		// Build ShaderList
		for( rtInfo in rtInfos ) {
			var sign = rtInfo.sign;
			var mode = rtInfo.mode;
			var sl = null;
			var slinfo = null;
			while( (slinfo = rtInfo.sl.pop()) != null ) {
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
			if( sl != null ) {
				slists.push({ sl : sl, mode : mode });
			}
		}

		#if heaps_mt_hxsl_cache
		workThread = sys.thread.Thread.create(threadLoop);
		workThread.name = "CacheFile2Loader";
		#else
		threadLoop();
		#end
	}

	function threadLoop() {
		// Link ShaderList
		for( l in slists ) {
			var rts = cache.link(l.sl, l.mode);
			// if( l.mode == Default ) {
			// 	rtMap.set(sign, { rt : rts, sl : l.sl });
			// }
		}

		if( this.onDone != null )
			this.onDone();
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
	var allowSave : Bool;

	var isLoading : Bool = false;
	var isDirty(default, set) : Bool = false;
	var runtimesDefault : Array<RuntimeShader> = [];
	var runtimesBatch : Array<RuntimeShader> = [];
	var runtimesCompute : Array<RuntimeShader> = [];
	var linkers : Array<{ name : String, vars : Array<hxsl.Output> }> = [];
	var batchers : Array<{ name : String, rt : RuntimeShader, params : hxsl.Cache.BatchInstanceParams }> = [];

	public function new( file : String, allowSave : Bool ) {
		super();
		this.file = file;
		this.allowSave = allowSave;
		load();
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
		// var name = b.shader.data.name;
		// batchers.push({ name : name, rt : rt, params : params });
		return b;
	}

	override function compileRuntimeShader( shaders : hxsl.ShaderList, mode ) {
		var rt = super.compileRuntimeShader(shaders, mode);
		if( DEBUG && !isLoading ) {
			log("Compiled runtime shader (" + mode.getName() + "): " + rt.spec.signature + ":" + [for( inst in rt.spec.instances ) @:privateAccess inst.shader.data.name].join(":"));
		}
		switch( mode ) {
			case Default:
				runtimesDefault.push(rt);
				isDirty = true;
			case Batch:
				// runtimesBatch.push(rt); // TODO fix multithread
			case Compute:
				// runtimesCompute.push(rt); // TODO fix Null access .inputs on getInstance
		}
		return rt;
	}

	inline function log( str : String ) {
		Sys.println("[CacheFile2] " + str);
	}

	function load() {
		isLoading = true;
		if( !sys.FileSystem.exists(file) ) {
			isLoading = false;
			return;
		}

		var tLoadStart = haxe.Timer.stamp();
		var f = new haxe.io.BytesInput(sys.io.File.getBytes(file));
		var magic = f.readLine();
		if( !StringTools.startsWith(magic, "CF2-1") ) {
			log("Invalid cache file, skipped");
			isLoading = false;
			return;
		}

		var loader = new CacheFile2Loader(this);

		while( true ) {
			var line = f.readLine();
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
			var line = f.readLine();
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
			var line = f.readLine();
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
			var sl = [];
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
				loader.rtInfos.push({ sign : sign, sl : sl, mode : mode });
			}
		}

		f.close();

		loader.run(function() {
			var tLoadEnd = haxe.Timer.stamp();
			var dt = tLoadEnd - tLoadStart;
			CacheFile2.LOAD_TIME = dt;
			log('${runtimesDefault.length + runtimesBatch.length} shaders loaded in ${hxd.Math.fmt(dt)}s');
			isLoading = false;
		});
	}

	function saveIfModified() {
		if( this.isDirty ) {
			this.isDirty = false;
			save();
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
				}
				out.writeString("\n");
			}
			out.writeString("\n");
		}
		// Batch should be after Default for reconstruction
		writeRtArr(runtimesDefault);
		writeRtArr(runtimesBatch);
		writeRtArr(runtimesCompute);

		sys.io.File.saveBytes(file, out.getBytes());
		if( DEBUG )
			log("Cache file saved to " + file);
	}
}

#end
