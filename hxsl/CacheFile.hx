package hxsl;
import hxsl.Ast.Tools;

private class NullShader extends hxsl.Shader {
	static var SRC = {
		var output : {
			var position : Vec4;
			var frag : Vec4;
		};
		function vertex() {
			output.position = vec4(0.);
		}
		function fragment() {
			output.frag = vec4(0.);
		}
	};
}

class CacheFile extends Cache {

	public static var FILENAME = "res/shaders.cache";

	var allowCompile : Bool;
	var recompileRT : Bool;
	var waitCount : Int = 0;
	var isLoading : Bool;
	var file : String;
	var sourceFile : String;

	// instances
	var shaders : Map<String,{ shader : SharedShader, version : String }> = new Map();
	var runtimeShaders : Array<RuntimeShader> = [];
	var linkers : Array<{ shader : Shader, vars : Array<hxsl.Output> }> = [];
	var batchers : Array<{ shader : SharedShader, rt : RuntimeShader }> = [];

	// sources
	var compiledSources : Map<String,{ vertex : String, fragment : String }> = new Map();
	var allSources : Map<String,String> = new Map();

	public var allowSave = #if usesys false #else true #end;

	public function new( allowCompile, recompileRT = false ) {
		super();
		this.allowCompile = allowCompile;
		this.recompileRT = recompileRT || allowCompile;
		this.file = FILENAME;
		sourceFile = this.file + "." + getPlatformTag();
		load();
	}

	function getPlatformTag() {
		#if usesys
		return Sys.systemName().toLowerCase();
		#elseif hlsdl
		return "gl";
		#elseif hldx
		return "dx";
		#else
		return "unk";
		#end
	}

	override function getLinkShader( vars : Array<hxsl.Output> ) {
		var shader = super.getLinkShader(vars);
		for( l in linkers )
			if( l.shader == shader )
				return shader;
		linkers.push({ shader : shader, vars : vars.copy() });
		return shader;
	}

	override function createBatchShader( rt, shaders ) {
		var b = super.createBatchShader(rt, shaders);
		batchers.push({ rt : rt, shader : b.shader });
		return b;
	}

	static var HEX = "0123456789abcdef";

	function load() {
		isLoading = true;
		var t0 = haxe.Timer.stamp();
		var wait = [];
		if( sys.FileSystem.exists(file) ) {
			loadShaders();
			if( sys.FileSystem.exists(sourceFile) )
				loadSources();
			else if( !allowCompile )
				throw "Missing " + sourceFile;

			if( allowCompile ) {
				// update missing shader sources (after platform switch)
				for( r in runtimeShaders )
					if( r.vertex.code == null || r.fragment.code == null )
						wait.push(r);
			}

			log(runtimeShaders.length+" shaders loaded in "+hxd.Math.fmt(haxe.Timer.stamp() - t0)+"s");
		} else if( !allowCompile )
			throw "Missing " + file;
		if( linkCache.linked == null ) {
			var rt = link(makeDefaultShader(), false);
			linkCache.linked = rt;
			if( rt.vertex.code == null || rt.fragment.code == null ) {
				wait.push(rt);
				if( !allowCompile ) throw "Missing default shader code";
			}
		}
		if( wait.length > 0 ) {
			waitCount += wait.length;
			#if hlmulti
			for( r in wait ) {
				addNewShader(r);
				hxd.System.timeoutTick();
			}
			#else
			haxe.Timer.delay(function() {
				for( r in wait ) {
					addNewShader(r);
					hxd.System.timeoutTick();
				}
			},1000); // wait until engine correctly initialized
			#end
		}
		isLoading = false;
	}

	function readString(f:haxe.io.Input) {
		var len = f.readByte();
		if( len == 0 ) return null;
		if( len == 0xFF ) len = f.readInt32();
		return f.readString(len - 1);
	}

	function resolveShader( name : String ) : hxsl.Shader {
		var cl = Type.resolveClass(name);
		if( cl == null )
			return null;
		var shader : hxsl.Shader = Type.createEmptyInstance(cl);
		@:privateAccess shader.initialize();
		return shader;
	}

	function loadShaders() {

		var f = new haxe.io.BytesInput(sys.io.File.getBytes(file));
		var version = f.readInt32();

		function readString() {
			return this.readString(f);
		}

		function unserialize() {
			return haxe.Unserializer.run(readString());
		}

		function readIntHex() {
			var len = f.readByte();
			if( len == 0 )
				return 0;
			var x = 0;
			for( i in 0...len ) {
				var c = f.readByte();
				if( c >= "0".code && c <= "9".code )
					c -= "0".code;
				else if( c >= "a".code && c <= "f".code )
					c -= "a".code - 10;
				else
					c -= "A".code - 10;
				x |= c << ((len - 1 - i) * 4);
			}
			return x;
		}

		function skip() {
			if( f.readByte() != "\n".code ) throw "assert";
		}

		linkers = [];
		var linkMap = new Map();
		while( true ) {
			skip();
			var name = readString();
			if( name == null ) break;
			var vars : Array<hxsl.Output> = unserialize();
			var shader = getLinkShader(vars);
			linkMap.set(name, shader);
		}

		batchers = [];
		var batchMap = new Map();
		while( true ) {
			skip();
			var name = readString();
			if( name == null ) break;
			var rt = readString();
			batchMap.set(name, rt);
		}

		shaders = new Map();
		while( true ) {
			skip();
			var name = readString();
			if( name == null ) break;
			var version = readString();
			var shader = linkMap.get(name);
			if( shader == null ) {
				shader = resolveShader(name);
				if( shader == null ) {
					log("Missing shader " + name);
					continue;
				}
			}
			var shader = @:privateAccess shader.shader;
			if( getShaderVersion(shader) != version ) {
				Sys.println("Shader " + name+" version differs");
				continue;
			}

			shaders.set(name, { shader : shader, version : version });
		}

		// read runtime shaders specs
		var runtimes = [];
		while( true ) {
			skip();
			var specSign = readString();
			if( specSign == null )
				break;
			var missingShader = false;
			var inst = [for( i in 0...f.readByte() ) {
				var name = readString();
				var shader = shaders.get(name);
				var batch = null;
				if( shader == null ) {
					batch = batchMap.get(name);
					if( batch == null ) missingShader = true;
				}
				{ shader : shader, batch : batch, bits : readIntHex(), index : f.readByte() };
			}];
			var sign = readString();
			if( missingShader ) continue;
			//log("Loading shader "+[for( i in inst ) (i.shader == null ? i.batch : i.shader.shader.data.name)+(i.bits == 0 ? "" : ":"+StringTools.hex(i.bits))].toString());
			runtimes.push({ signature : sign, specSign : specSign, inst: inst });
		}


		// recompile or load runtime shaders
		runtimeShaders = [];
		var rttMap = new Map<String,{ rt : RuntimeShader, shaders : hxsl.ShaderList }>();
		if( recompileRT ) {

			for( r in runtimes ) {
				var shaderList = null;
				var batchMode = false;
				r.inst.reverse();
				for( i in r.inst ) {
					var s = Type.createEmptyInstance(hxsl.Shader);
					@:privateAccess {
						if( i.shader == null ) {
							var rt = rttMap.get(i.batch);
							if( rt == null ) {
								r = null; // was modified
								break;
							}
							var sh = makeBatchShader(rt.rt, rt.shaders);
							i.shader = { version : null, shader : sh.shader };
							batchMode = true;
						}
						s.constBits = i.bits;
						s.shader = i.shader.shader;
						s.instance = i.shader.shader.getInstance(i.bits);
						s.priority = i.index;
					}
					shaderList = new hxsl.ShaderList(s, shaderList);
				}
				if( r == null ) continue;
				//log("Recompile "+[for( s in shaderList ) shaderName(s)]);
				var rt = link(shaderList, batchMode); // will compile + update linkMap
				if( rt.spec.signature != r.specSign ) {
					var signParts = [for( i in rt.spec.instances ) i.shader.data.name+"_" + i.bits + "_" + i.index];
					throw "assert";
				}
				var rt2 = rttMap.get(r.specSign);
				if( rt2 != null ) throw "assert";
				runtimeShaders.push(rt);
				rttMap.set(r.specSign, { rt : rt, shaders : shaderList });
			}

		} else {

			var rtMap = new Map();
			for( r in runtimes )
				rtMap.set(r.specSign, r);
			while( true ) {
				skip();
				var sdata = readString();
				if( sdata == null ) break;
				var r : RuntimeShader = haxe.Unserializer.run(sdata);
				var spec = rtMap.get(r.signature);

				// shader was modified
				if( spec == null )
					continue;

				r.signature = spec.signature;
				var shaderList = null;
				spec.inst.reverse();
				for( i in spec.inst ) {
					var s = Type.createEmptyInstance(hxsl.Shader);
					@:privateAccess {
						if( i.shader == null ) {
							var rt = rttMap.get(i.batch);
							if( rt == null ) {
								r = null; // was modified
								break;
							}
							var sh = makeBatchShader(rt.rt, rt.shaders);
							i.shader = { version : null, shader : sh.shader };
							r.batchMode = true;
						}
						// pseudo instance
						var scache = i.shader.shader.instanceCache;
						var inst = scache.get(i.bits);
						if( inst == null ) {
							inst = new hxsl.SharedShader.ShaderInstance(i.shader.shader.data);
							scache.set(i.bits, inst);
						}
						s.constBits = i.bits;
						s.shader = i.shader.shader;
						s.instance = inst;
						s.priority = i.index;
					}
					shaderList = new hxsl.ShaderList(s, shaderList);
				}
				if( r == null ) continue;
				addToCache(r, shaderList);
				reviveRuntime(r);
				runtimeShaders.push(r);
				rttMap.set(spec.specSign, { rt : r, shaders : shaderList });
			}

		}
	}

	function addToCache( r : RuntimeShader, shaders : hxsl.ShaderList ) {
		var c = linkCache;
		for( s in shaders ) {
			var i = @:privateAccess s.instance;
			if( c.next == null ) c.next = new Map();
			var cs = c.next.get(i.id);
			if( cs == null ) {
				cs = new Cache.SearchMap();
				c.next.set(i.id, cs);
			}
			c = cs;
		}
		c.linked = r;
	}

	function loadSources() {
		var f = new haxe.io.BytesInput(sys.io.File.getBytes(sourceFile));
		var version = f.readInt32();
		var runtimeMap = new Map();
		for( r in runtimeShaders )
			runtimeMap.set(r.signature, r);

		function readString() {
			return this.readString(f);
		}

		function skip() {
			if( f.readByte() != "\n".code ) throw "assert";
		}

		compiledSources = new Map();
		var allSigns = new Map();
		while( true ) {
			skip();
			var sign = readString();
			if( sign == null )
				break;
			var vertex = readString();
			var fragment = readString();
			if( compiledSources.exists(sign) ) throw "assert";
			if( !runtimeMap.exists(sign) )
				continue; // runtime shader was removed
			allSigns.set(vertex, true);
			allSigns.set(fragment, true);
			compiledSources.set(sign, { vertex : vertex, fragment : fragment });
		}

		allSources = new Map();
		var sourceMap = new Map();
		while( true ) {
			skip();
			var src = readString();
			if( src == null )
				break;
			var sign = getSourceSign(src);
			if( !allSigns.exists(sign) )
				continue;
			allSources.set(src, sign);
			sourceMap.set(sign, src);
		}

		// assign to runtime instances
		for( r in runtimeShaders ) {
			var s = compiledSources.get(r.signature);
			if( s == null ) {
				if( !recompileRT ) throw "Shader " + r.signature+" is missing source";
				continue;
			}
			r.vertex.code = sourceMap.get(s.vertex);
			r.fragment.code = sourceMap.get(s.fragment);
			if( r.vertex.code == null ) throw "Source " + r.signature + " is missing code " + s.vertex;
			if( r.fragment.code == null ) throw "Source " + r.signature + " is missing code " + s.fragment;
		}
	}

	function save() {
		if( !allowSave ) return;

		var out = new haxe.io.BytesOutput();
		out.writeInt32(1); // version

		function separator() {
			out.writeByte("\n".code);
		}

		function writeString(str:String) {
			if( str == null ) {
				out.writeByte(0);
				return;
			}
			var bytes = haxe.io.Bytes.ofString(str);
			if( bytes.length < 254 )
				out.writeByte(bytes.length + 1);
			else {
				out.writeByte(0xFF);
				out.writeInt32(bytes.length + 1);
			}
			out.write(bytes);
		}

		function serialize(v:Dynamic) {
			var s = new haxe.Serializer();
			s.useCache = true;
			s.useEnumIndex = true;
			s.serialize(v);
			writeString(s.toString());
		}

		function writeIntHex( i : Int ) {
			if( i == 0 ) {
				out.writeByte(0);
				return;
			}
			// make it readable
			var str = StringTools.hex(i);
			out.writeByte(str.length);
			out.writeString(str);
		}

		// linkers
		linkers.sort(function(l1, l2) return @:privateAccess Reflect.compare(l1.shader.shader.data.name,l2.shader.shader.data.name));
		for( l in linkers ) {
			separator();
			writeString(@:privateAccess l.shader.shader.data.name);
			serialize(l.vars);
		}
		separator();
		writeString(null);

		// batchers
		batchers.sort(function(l1, l2) return @:privateAccess Reflect.compare(l1.shader.data.name,l2.shader.data.name));
		for( b in batchers ) {
			separator();
			writeString(@:privateAccess b.shader.data.name);
			writeString(@:privateAccess b.rt.spec.signature);
		}
		separator();
		writeString(null);

		// shaders
		var shaders = [for( s in shaders ) s];
		shaders.sort(function(s1, s2) return Reflect.compare(s1.version, s2.version));
		for( s in shaders ) {
			separator();
			writeString(s.shader.data.name);
			writeString(s.version);
		}
		separator();
		writeString(null);

		// runtime shaders
		runtimeShaders.sort(sortBySpec);
		for( r in runtimeShaders ) {
			separator();
			writeString(r.spec.signature);
			if( r.spec.instances.length >= 255 ) throw "assert";
			out.writeByte(r.spec.instances.length);
			for( s in r.spec.instances ) {
				writeString(s.shader.data.name);
				writeIntHex(s.bits);
				out.writeByte(s.index);
			}
			writeString(r.signature);
		}
		separator();
		writeString(null);

		// save runtime shaders data
		for( r in runtimeShaders ) {
			separator();
			var r = cleanRuntime(r);
			var s = new haxe.Serializer();
			s.useCache = true;
			s.useEnumIndex = true;
			s.serialize(r);
			writeString(s.toString());
		}
		separator();
		writeString(null);

		try sys.FileSystem.createDirectory(new haxe.io.Path(file).dir) catch( e : Dynamic ) {};
		sys.io.File.saveBytes(file, out.getBytes());

		out = new haxe.io.BytesOutput();
		out.writeInt32(1); // version
		var sources = [for( k in compiledSources.keys() ) k];
		sources.sort(Reflect.compare);
		for( s in sources ) {
			separator();
			writeString(s);
			var src = compiledSources.get(s);
			writeString(src.vertex);
			writeString(src.fragment);
		}
		separator();
		writeString(null);

		var sources = [for( s in allSources.keys() ) s];
		sources.sort(Reflect.compare);
		for( s in sources ) {
			separator();
			writeString(s);
		}
		separator();
		writeString(null);

		sys.io.File.saveBytes(sourceFile, out.getBytes());
	}

	/**
		Returns a stripped down runtime shader that will not have enough data to be
		recompiled but will still allow to be used at runtime.
	**/
	function cleanRuntime( r : RuntimeShader ) {
		var rc = new RuntimeShader();
		@:privateAccess RuntimeShader.UID--; // unalloc id
		rc.id = 0;
		rc.signature = r.spec.signature; // store by spec, not by sign (dups)
		rc.vertex = cleanRuntimeData(r.vertex);
		rc.fragment = cleanRuntimeData(r.fragment);
		return rc;
	}

	function cleanRuntimeData(r:hxsl.RuntimeShader.RuntimeShaderData) {
		var rc = new hxsl.RuntimeShader.RuntimeShaderData();
		rc.vertex = r.vertex;
		rc.data = {
			name : null,
			vars : [],
			funs : null,
		};
		for( v in r.data.vars )
			if( v.kind == (r.vertex ? Input : Output) ) {
				rc.data.vars.push({
					id : v.id,
					name : v.name,
					kind : v.kind,
					type : v.type,
				});
			}
		rc.paramsSize = r.paramsSize;
		rc.globalsSize = r.globalsSize;
		rc.texturesCount = r.texturesCount;
		rc.bufferCount = r.bufferCount;
		if( r.params != null )
			rc.params = r.params.clone(true);
		if( r.globals != null )
			rc.globals = r.globals.clone(true);
		if( r.textures != null )
			rc.textures = r.textures.clone(true);
		if( r.buffers != null )
			rc.buffers = r.buffers.clone(true);
		return rc;
	}


	/**
		Puts things back after we load a cleaned up runtime shader
	**/
	function reviveRuntime( r : RuntimeShader ) {
		r.id = @:privateAccess hxsl.RuntimeShader.UID++;
		r.globals = new Map();
		reviveRuntimeData(r, r.vertex);
		reviveRuntimeData(r, r.fragment);
	}

	function reviveRuntimeData( r : RuntimeShader, rd : hxsl.RuntimeShader.RuntimeShaderData ) {
		function rvGlobal( g : RuntimeShader.AllocGlobal ) {
			if( g == null ) return;
			g.gid = Globals.allocID(g.path);
			rvGlobal(g.next);
		}
		function rvParam( a : RuntimeShader.AllocParam ) {
			if( a == null ) return;
			rvGlobal(a.perObjectGlobal);
			rvParam(a.next);
		}
		rvParam(rd.params);
		rvParam(rd.textures);
		rvParam(rd.buffers);
		rvGlobal(rd.globals);
		initGlobals(r, rd);
	}

	function sortBySpec( r1 : RuntimeShader, r2 : RuntimeShader ) {
		if( r1.batchMode != r2.batchMode )
			return r1.batchMode ? 1 : -1;
		var minLen = hxd.Math.imin(r1.spec.instances.length, r2.spec.instances.length);
		for( i in 0...minLen ) {
			var i1 = r1.spec.instances[i];
			var i2 = r1.spec.instances[i];
			if( i1.shader != i2.shader )
				return Reflect.compare(i1.shader.data.name, i2.shader.data.name);
		}
		for( i in 0...minLen ) {
			var i1 = r1.spec.instances[i];
			var i2 = r1.spec.instances[i];
			if( i1.bits != i2.bits )
				return i1.bits - i2.bits;
		}
		return r1.spec.instances.length - r2.spec.instances.length;
	}

	function makeDefaultShader() {
		var link = getLinkShader([Value("output.frag")]);
		var def = new NullShader();
		def.updateConstants(null);
		return new hxsl.ShaderList(link, new hxsl.ShaderList(def));
	}

	function log( str : String ) {
		Sys.println(str);
	}

	function shaderName( s : hxsl.Shader ) @:privateAccess {
		var name = s.instance.shader.name;
		if( s.constBits != 0 )
			name += ":" + StringTools.hex(s.constBits);
		if( s.priority != 0 )
			name += "("+s.priority+")";
		if( s.constBits != 0 ) {
			var c = s.shader.consts;
			var consts = [];
			while( c != null ) {
				var bits = (s.constBits >> c.pos) & ((1 << c.bits) - 1);
				if( bits > 0 ) {
					switch( c.v.type ) {
					case TBool:
						consts.push(c.v.name);
					case TChannel(_):
						consts.push(c.v.name+"="+hxsl.Channel.createByIndex(bits&7)+"@"+(bits>>3));
					default:
						consts.push(c.v.name+"="+bits);
					}
				}
				c = c.next;
			}
			if( consts.length > 0 )
				name += consts.toString();
		}
		return name;
	}

	public dynamic function onMissingShader(shaders:hxsl.ShaderList) {
		log("Missing shader " + [for( s in shaders ) shaderName(s)]);
		return link(null, false); // default fallback
	}

	public dynamic function onNewShader(r:RuntimeShader) {
		log("Compiled " + [for( i in r.spec.instances ) i.shader.data.name+(i.bits == 0 ? "" : ":" + StringTools.hex(i.bits))].join(" "));
	}

	override function compileRuntimeShader(shaders:hxsl.ShaderList, batchMode) {
		if( isLoading )
			return super.compileRuntimeShader(shaders, batchMode);
		if( allowCompile ) {
			// was not found in previous cache, let's compile and cache it
			var s = super.compileRuntimeShader(shaders, batchMode);
			onNewShader(s);
			waitCount++;
			haxe.Timer.delay(function() addNewShader(s), 0);
			return s;
		}
		return onMissingShader(shaders);
	}

	function getShaderVersion( s : SharedShader ) {
		return haxe.crypto.Md5.encode(Printer.shaderToString(s.data));
	}

	function addNewShader( s : RuntimeShader ) {
		if( runtimeShaders.indexOf(s) < 0 )
			runtimeShaders.push(s);
		if( allowSave ) addSource(s);
		for( i in s.spec.instances ) {
			var inst = shaders.get(i.shader.data.name);
			if( inst == null ) {
				if( s.batchMode && StringTools.startsWith(i.shader.data.name,"batchShader_") )
					continue;
				var version = getShaderVersion(i.shader);
				inst = { shader : i.shader, version : version };
				shaders.set(i.shader.data.name, inst);
			}
		}
		waitCount--;
		if( waitCount == 0 ) save();
	}

	function allocSource( s : String ) {
		var sign = allSources.get(s);
		if( sign == null ) {
			sign = getSourceSign(s);
			allSources.set(s, sign);
		}
		return sign;
	}

	function getSourceSign( s : String ) {
		return haxe.crypto.Md5.encode(s).substr(0,8);
	}

	function addSource( s : RuntimeShader ) {
		// true if already matches another combination
		if( !compiledSources.exists(s.signature) ) {
			// shader was selected by not compiled by driver, let's force-compile it by hand!
			if( s.vertex.code == null || s.fragment.code == null ) {
				var engine = h3d.Engine.getCurrent();
				if( engine == null ) engine = @:privateAccess new h3d.Engine();
				engine.driver.selectShader(s);
			}
			// same shader id is shared between multiple runtime shaders because they have the same signature
			// hopefully, the other shader will make it through addSource just a bit after
			if( s.vertex.code == null || s.fragment.code == null )
				return;
			compiledSources.set(s.signature, { vertex : allocSource(s.vertex.code), fragment : allocSource(s.fragment.code) });
		}
	}

}