package hxsl;
using hxsl.Ast;
import hxsl.RuntimeShader;

class SearchMap {
	public var linked : RuntimeShader;
	public var next : Map<Int,SearchMap>;
	public function new() {
	}
}

class Cache {

	#if shader_debug_dump
	public static var DEBUG_IDS = false;
	public static var TRACE = true;
	#end

	var linkCache : SearchMap;
	var linkShaders : Map<String, Shader>;
	var batchShaders : Map<Int, { shader : SharedShader, params : RuntimeShader.AllocParam, size : Int }>;
	var byID : Map<String, RuntimeShader>;
	public var constsToGlobal : Bool;

	function new() {
		constsToGlobal = false;
		linkCache = new SearchMap();
		linkShaders = new Map();
		batchShaders = new Map();
		byID = new Map();
	}

	/**
		Creates a shader that generate the output requested.
	**/
	public function getLinkShader( vars : Array<Output> ) {
		var key = [for( v in vars ) Std.string(v)].join(",");
		var shader = linkShaders.get(key);
		if( shader != null )
			return shader;
		var s = new hxsl.SharedShader("");
		var id = haxe.crypto.Md5.encode(key).substr(0, 8);
		s.data = {
			name : "shaderLinker_"+id,
			vars : [],
			funs : [],
		};
		var pos = null;
		var outVars = new Map<String,TVar>();
		var outputCount = 0;
		var tvec4 = TVec(4, VFloat);
		function makeVec( g, size, args : Array<Output>, makeOutExpr : Output -> Int -> TExpr ) {
			var out = [];
			var rem = size;
			for( i in 0...args.length ) {
				var e = makeOutExpr(args[args.length - 1 - i], rem - (args.length - 1 - i));
				rem -= Tools.size(e.t);
				out.unshift(e);
			}
			return { e : TCall({ e : TGlobal(g), t : TVoid, p : pos }, out), t : TVec(size,VFloat), p : pos };
		}
		function makeVar( name : String, t, parent : TVar ) {
			var path = parent == null ? name : parent.getName() + "." + name;
			var v = outVars.get(path);
			if( v != null )
				return v;
			v = {
				id : Tools.allocVarId(),
				name : name,
				type : t,
				kind : Var,
				parent : parent,
			};
			if( parent == null )
				s.data.vars.push(v);
			else {
				switch( parent.type ) {
				case TStruct(vl): vl.push(v);
				default: throw "assert";
				}
			}
			outVars.set(path, v);
			return v;
		}

		function makeOutExpr( v : Output, rem : Int ) : TExpr {
			switch( v ) {
			case Const(v):
				return { e : TConst(CFloat(v)), t : TFloat, p : pos };
			case Vec2(args):
				return makeVec(Vec2, 2, args, makeOutExpr);
			case Vec3(args):
				return makeVec(Vec3, 3, args, makeOutExpr);
			case Vec4(args):
				return makeVec(Vec4, 4, args, makeOutExpr);
			case Value(vname,size):
				var v = outVars.get(vname);
				if( v != null )
					return { e : TVar(v), t : v.type, p : pos };
				var path = vname.split(".");
				var parent : TVar = null;
				while( path.length > 1 )
					parent = makeVar(path.shift(), TStruct([]), parent);
				if( size != null )
					rem = size;
				v = makeVar(path.shift(), rem == 1 ? TFloat : TVec(rem, VFloat), parent);
				return { e : TVar(v), t : v.type, p : pos };
			case PackNormal(v):
				return { e : TCall({ e : TGlobal(PackNormal), t : TVoid, p : pos }, [makeOutExpr(v,3)]), t : tvec4, p : pos };
			case PackFloat(v):
				return { e : TCall({ e : TGlobal(Pack), t : TVoid, p : pos }, [makeOutExpr(v, 1)]), t : tvec4, p : pos };
			case Swiz(v, comps):
				return { e : TSwiz(makeOutExpr(v,4), comps), t : TVec(comps.length, VFloat), p : pos };
			}
		}
		function makeOutput( v : Output ) : TExpr {
			var ov : TVar = {
				id : Tools.allocVarId(),
				type : tvec4,
				name : "OUTPUT" + (outputCount++),
				kind : Output,
			};
			s.data.vars.push(ov);
			return { e : TBinop(OpAssign,{ e : TVar(ov), t : tvec4, p : pos }, makeOutExpr(v,4)), t : TVoid, p : pos };
		}
		function defineFun( kind : FunctionKind, vars : Array<Output> ) {
			var fv : TVar = {
				id : Tools.allocVarId(),
				type : TFun([]),
				name : ("" + kind).toLowerCase(),
				kind : Function,
			};
			var f : TFunction = {
				kind : kind,
				ref : fv,
				args : [],
				ret : TVoid,
				expr : { e : TBlock([for( v in vars ) makeOutput(v)]), p : pos, t : TVoid },
			};
			s.data.funs.push(f);
		}
		defineFun(Vertex, [Value("output.position")]);
		defineFun(Fragment, vars);

		shader = std.Type.createEmptyInstance(Shader);
		@:privateAccess shader.shader = s;
		linkShaders.set(key, shader);
		@:privateAccess shader.updateConstantsFinal(null);

		return shader;
	}

	@:noDebug
	public function link( shaders : hxsl.ShaderList, batchMode : Bool ) {
		var c = linkCache;
		for( s in shaders ) {
			var i = @:privateAccess s.instance;
			if( c.next == null ) c.next = new Map();
			var cs = c.next.get(i.id);
			if( cs == null ) {
				cs = new SearchMap();
				c.next.set(i.id, cs);
			}
			c = cs;
		}
		if( c.linked == null )
			c.linked = compileRuntimeShader(shaders, batchMode);
		return c.linked;
	}

	function compileRuntimeShader( shaders : hxsl.ShaderList, batchMode : Bool ) {
		var shaderDatas = [];
		var index = 0;
		for( s in shaders ) {
			var i = @:privateAccess s.instance;
			shaderDatas.push( { inst : i, p : s.priority, index : index++ } );
		}
		shaderDatas.reverse(); // default is reverse order
		/*
			Our shader list is supposedly already sorted. However some shaders
			with high priority might be prepended at later stage (eg: Base2D)
			So let's sort again just in case.
		*/
		haxe.ds.ArraySort.sort(shaderDatas, function(s1, s2) return s2.p - s1.p);

		#if debug
		for( s in shaderDatas ) Printer.check(s.inst.shader);
		#end

		#if shader_debug_while
		for( s in shaders ) {
			function checkRec( e : TExpr ) {
				switch( e.e ) {
				case TWhile(cond,_,_):
					var name = @:privateAccess s.shader.data.name;
					haxe.Log.trace("FOUND SHADER while( "+Printer.toString(cond)+")", { fileName : name, methodName : "", lineNumber : 0, className : name });
				default:
				}
				e.iter(checkRec);
			}
			for( f in @:privateAccess s.instance.shader.funs )
				checkRec(f.expr);
		}
		#end

		#if shader_debug_dump
		var shaderId = @:privateAccess RuntimeShader.UID;
		if( shaderId == 0 ) try sys.FileSystem.createDirectory("shaders") catch( e : Dynamic ) {};
		var dbg = sys.io.File.write("shaders/"+shaderId+"_dump.c");
		var oldTrace = haxe.Log.trace;
		haxe.Log.trace = function(msg,?pos) dbg.writeString(haxe.Log.formatOutput(msg,pos)+"\n");
		if( dbg != null ) {
			dbg.writeString("----- DATAS ----\n\n");
			for( s in shaderDatas ) {
				dbg.writeString("\t\t**** " + s.inst.shader.name + (s.p == 0 ? "" : " P="+s.p)+ " *****\n");
				dbg.writeString(Printer.shaderToString(s.inst.shader,DEBUG_IDS)+"\n\n");
			}
		}
		//TRACE = shaderId == 0;
		#end

		var linker = new hxsl.Linker(batchMode);
		var s = try linker.link([for( s in shaderDatas ) s.inst.shader]) catch( e : Error ) {
			var shaders = [for( s in shaderDatas ) Printer.shaderToString(s.inst.shader)];
			e.msg += "\n\nin\n\n" + shaders.join("\n-----\n");
			throw e;
		}

		if( batchMode ) {
			function checkRec( v : TVar ) {
				if( v.qualifiers != null && v.qualifiers.indexOf(PerObject) >= 0 ) {
					if( v.qualifiers.length == 1 ) v.qualifiers = null else {
						v.qualifiers = v.qualifiers.copy();
						v.qualifiers.remove(PerObject);
					}
					if( v.kind != Var ) v.kind = Local;
				}
				switch( v.type ) {
				case TStruct(vl):
					for( v in vl )
						checkRec(v);
				default:
				}
			}
			for( v in s.vars )
				checkRec(v);
		}

		#if debug
		Printer.check(s,[for( s in shaderDatas ) s.inst.shader]);
		#end

		#if shader_debug_dump
		if( dbg != null ) {
			dbg.writeString("----- LINK ----\n\n");
			dbg.writeString(Printer.shaderToString(s,DEBUG_IDS)+"\n\n");
		}
		#end

		// params tracking
		var paramVars = new Map();
		for( v in linker.allVars )
			if( v.v.kind == Param ) {
				switch( v.v.type ) {
				case TStruct(_): continue;
				default:
				}
				var inf = shaderDatas[v.instanceIndex];
				paramVars.set(v.id, { instance : inf.index, index : inf.inst.params.get(v.merged[0].id) } );
			}

		var prev = s;
		var s = try new hxsl.Splitter().split(s) catch( e : Error ) { e.msg += "\n\nin\n\n"+Printer.shaderToString(s); throw e; };

		#if debug
		Printer.check(s.vertex,[prev]);
		Printer.check(s.fragment,[prev]);
		#end

		#if shader_debug_dump
		if( dbg != null ) {
			dbg.writeString("----- SPLIT ----\n\n");
			dbg.writeString(Printer.shaderToString(s.vertex, DEBUG_IDS) + "\n\n");
			dbg.writeString(Printer.shaderToString(s.fragment, DEBUG_IDS) + "\n\n");
		}
		#end

		var prev = s;
		var s = new hxsl.Dce().dce(s.vertex, s.fragment);

		#if debug
		Printer.check(s.vertex,[prev.vertex]);
		Printer.check(s.fragment,[prev.fragment]);
		#end

		#if shader_debug_dump
		if( dbg != null ) {
			dbg.writeString("----- DCE ----\n\n");
			dbg.writeString(Printer.shaderToString(s.vertex, DEBUG_IDS) + "\n\n");
			dbg.writeString(Printer.shaderToString(s.fragment, DEBUG_IDS) + "\n\n");
		}
		#end

		var r = buildRuntimeShader(s.vertex, s.fragment, paramVars);

		#if shader_debug_dump
		if( dbg != null ) {
			dbg.writeString("----- FLATTEN ----\n\n");
			dbg.writeString(Printer.shaderToString(r.vertex.data, DEBUG_IDS) + "\n\n");
			dbg.writeString(Printer.shaderToString(r.fragment.data,DEBUG_IDS)+"\n\n");
		}
		#end

		r.spec = { instances : @:privateAccess [for( s in shaders ) new ShaderInstanceDesc(s.shader, s.constBits)], signature : null };

		for( i in 0...shaderDatas.length ) {
			var s = shaderDatas[shaderDatas.length - 1 - i];
			r.spec.instances[s.index].index = i;
		}

		var signParts = [for( i in r.spec.instances ) i.shader.data.name+"_" + i.bits + "_" + i.index];
		r.spec.signature = haxe.crypto.Md5.encode(signParts.join(":"));
		r.signature = haxe.crypto.Md5.encode(Printer.shaderToString(r.vertex.data) + Printer.shaderToString(r.fragment.data));
		r.batchMode = batchMode;

		var r2 = byID.get(r.signature);
		if( r2 != null )
			r.id = r2.id; // same id but different variable mapping
		else
			byID.set(r.signature, r);

		#if shader_debug_dump
		dbg.writeString("---- OUTPUT -----\n\n");
		dbg.writeString(h3d.Engine.getCurrent().driver.getNativeShaderCode(r)+"\n\n");
		if( dbg != null ) dbg.close();
		haxe.Log.trace = oldTrace;
		#end

		return r;
	}

	function buildRuntimeShader( vertex : ShaderData, fragment : ShaderData, paramVars ) {
		var r = new RuntimeShader();
		r.vertex = flattenShader(vertex, Vertex, paramVars);
		r.vertex.vertex = true;
		r.fragment = flattenShader(fragment, Fragment, paramVars);
		r.globals = new Map();
		initGlobals(r, r.vertex);
		initGlobals(r, r.fragment);

		#if debug
		Printer.check(r.vertex.data,[vertex]);
		Printer.check(r.fragment.data,[fragment]);
		#end
		return r;
	}

	function initGlobals( r : RuntimeShader, s : RuntimeShaderData ) {
		var p = s.globals;
		while( p != null ) {
			r.globals.set(p.gid, true);
			p = p.next;
		}
		var p = s.params;
		while( p != null ) {
			if( p.perObjectGlobal != null )
				r.globals.set(p.perObjectGlobal.gid, true);
			p = p.next;
		}
	}

	function getPath( v : TVar ) {
		if( v.parent == null )
			return v.name;
		return getPath(v.parent) + "." + v.name;
	}

	function flattenShader( s : ShaderData, kind : FunctionKind, params : Map<Int,{ instance:Int, index:Int }> ) {
		var flat = new Flatten();
		var c = new RuntimeShaderData();
		var data = flat.flatten(s, kind, constsToGlobal);
		var textures = [];
		c.consts = flat.consts;
		c.texturesCount = 0;
		for( g in flat.allocData.keys() ) {
			var alloc = flat.allocData.get(g);
			switch( g.kind ) {
			case Param:
				var out = [];
				var count = 0;
				for( a in alloc ) {
					if( a.v == null ) continue; // padding
					var p = params.get(a.v.id);
					if( p == null ) {
						var ap = new AllocParam(a.v.name, a.pos, -1, -1, a.v.type);
						ap.perObjectGlobal = new AllocGlobal( -1, getPath(a.v), a.v.type);
						out.push(ap);
						count++;
						continue;
					}
					var ap = new AllocParam(a.v.name, a.pos, p.instance, p.index, a.v.type);
					switch( a.v.type ) {
					case TArray(t,_) if( t.isSampler() ):
						// hack to mark array of texture, see ShaderManager.fillParams
						ap.pos = -a.size;
						count += a.size;
					default:
						count++;
					}
					out.push(ap);
				}
				for( i in 0...out.length - 1 )
					out[i].next = out[i + 1];
				switch( g.type ) {
				case TArray(t, _) if( t.isSampler() ):
					textures.push({ t : t, all : out });
					c.texturesCount += count;
				case TArray(TVec(4, VFloat), SConst(size)):
					c.params = out[0];
					c.paramsSize = size;
				case TArray(TBuffer(_), _):
					c.buffers = out[0];
					c.bufferCount = out.length;
				default: throw "assert";
				}
			case Global:
				var out = [for( a in alloc ) if( a.v != null ) new AllocGlobal(a.pos, getPath(a.v), a.v.type)];
				for( i in 0...out.length - 1 )
					out[i].next = out[i + 1];
				switch( g.type ) {
				case TArray(TVec(4, VFloat),SConst(size)):
					c.globals = out[0];
					c.globalsSize = size;
				default:
					throw "assert";
				}
			default: throw "assert";
			}
		}
		if( textures.length > 0 ) {
			// relink in order based on type
			textures.sort(function(t1,t2) return t1.t.getIndex() - t2.t.getIndex());
			c.textures = textures[0].all[0];
			for( i in 1...textures.length ) {
				var prevAll = textures[i-1].all;
				var prev = prevAll[prevAll.length - 1];
				prev.next = textures[i].all[0];
			}
		}
		if( c.globals == null )
			c.globalsSize = 0;
		if( c.params == null )
			c.paramsSize = 0;
		if( c.buffers == null )
			c.bufferCount = 0;
		c.data = data;
		return c;
	}

	public function makeBatchShader( rt : RuntimeShader, shaders ) : BatchShader {
		var sh = batchShaders.get(rt.id);
		if( sh == null ) {
			sh = createBatchShader(rt, shaders);
			batchShaders.set(rt.id,sh);
		}
		var shader = std.Type.createEmptyInstance(BatchShader);
		@:privateAccess shader.shader = sh.shader;
		shader.params = sh.params;
		shader.paramsSize = sh.size;
		return shader;
	}

	function isPerInstance(v:TVar) {
		if( v.qualifiers == null )
			return false;
		for( q in v.qualifiers )
			if( q.match(PerInstance(_) | PerObject) )
				return true;
		return false;
	}

	function createBatchShader( rt : RuntimeShader, shaders : hxsl.ShaderList ) : { shader : SharedShader, params : RuntimeShader.AllocParam, size : Int } {
		var s = new hxsl.SharedShader("");
		var id = rt.spec.signature.substr(0, 8);

		function declVar( name, t, kind ) : TVar {
			return {
				id : Tools.allocVarId(),
				type : t,
				name : name,
				kind : kind,
			};
		}

		var pos = null;
		var vcount = declVar("Batch_Count",TInt,Param);
		var vbuffer = declVar("Batch_Buffer",TBuffer(TVec(4,VFloat),SVar(vcount)),Param);
		var voffset = declVar("Batch_Offset", TInt, Local);
		var ebuffer = { e : TVar(vbuffer), p : pos, t : vbuffer.type };
		var eoffset = { e : TVar(voffset), p : pos, t : voffset.type };
		var tvec4 = TVec(4,VFloat);
		var countBits = 16;
		vcount.qualifiers = [Const(1 << countBits)];

		s.data = {
			name : "batchShader_"+id,
			vars : [vcount,vbuffer,voffset],
			funs : [],
		};

		function getVarRec( v : TVar, name, kind ) {
			if( v.kind == kind && v.name == name )
				return v;
			switch( v.type ) {
			case TStruct(vl):
				for( v in vl ) {
					var v = getVarRec(v, name, kind);
					if( v != null ) return v;
				}
			default:
			}
			return null;
		}

		function getVar( p : RuntimeShader.AllocParam ) {
			var s = shaders;
			if( p.perObjectGlobal != null ) {
				var path = p.perObjectGlobal.path.split(".");
				while( s != null ) {
					for( v in @:privateAccess s.s.shader.data.vars ) {
						if( v.name != path[0] ) continue;
						var v = getVarRec(v, p.name, Global);
						if( v != null ) return v;
					}
					s = s.next;
				}
			} else {
				var i = p.instance - 1;
				while( i > 0 ) {
					i--;
					s = s.next;
				}
				var name = p.name;
				while( true ) {
					for( v in @:privateAccess s.s.shader.data.vars ) {
						var v = getVarRec(v, name, Param);
						if( v != null ) return v;
					}
					var cc = name.charCodeAt(name.length - 1);
					if( cc >= '0'.code && cc <= '9'.code ) name = name.substr(0,-1) else break;
				}
			}
			throw "Var not found "+p.name;
		}

		var params = null;
		var used = [];

		function addParam(p:RuntimeShader.AllocParam) {
			var size = switch( p.type ) {
				case TMat4: 4 * 4;
				case TVec(n,VFloat): n;
				case TFloat: 1;
				default: throw "Unsupported batch var type "+p.type;
			}
			var index;
			if( size >= 4 ) {
				index = used.length << 2;
				for( i in 0...size>>2 )
					used.push(15);
			} else if( size == 1 ) {
				var best = -1;
				for( i in 0...used.length )
					if( used[i] != 15 && (best < 0 || used[best] < used[i]) )
						best = i;
				if( best < 0 ) {
					best = used.length;
					used.push(0);
				}
				index = best << 2;
				for( k in 0...4 ) {
					var bit = 3 - k;
					if( used[best] & (1 << bit) == 0 ) {
						used[best] |= 1 << bit;
						index += bit;
						break;
					}
				}
			} else {
				var k = size == 2 ? 3 : 7;
				var best = -1;
				for( i in 0...used.length )
					if( used[i] & k == 0 ) {
						used[i] |= k;
						best = i;
						break;
					}
				if( best < 0 ) {
					best = used.length;
					used.push(k);
				}
				index = best << 2;
			}
			var p2 = new AllocParam(p.name, index, p.instance, p.index, p.type);
			p2.perObjectGlobal = p.perObjectGlobal;
			p2.next = params;
			params = p2;
		}

		var p = rt.vertex.params;
		while( p != null ) {
			var v = getVar(p);
			if( isPerInstance(v) )
				addParam(p);
			p = p.next;
		}
		var p = rt.fragment.params;
		while( p != null ) {
			var v = getVar(p);
			if( isPerInstance(v) )
				addParam(p);
			p = p.next;
		}


		var parentVars = new Map();
		var swiz = [[X],[Y],[Z],[W]];

		function readOffset( index : Int ) : TExpr {
			return { e : TArray(ebuffer,{ e : TBinop(OpAdd,eoffset,{ e : TConst(CInt(index)), t : TInt, p : pos }), t : TInt, p : pos }), t : tvec4, p : pos };
		}

		function extractVar( v : AllocParam ) {
			var vreal : TVar = declVar(v.name, v.type, Local);
			if( v.perObjectGlobal != null ) {
				var path = v.perObjectGlobal.path.split(".");
				path.pop();
				var cur = vreal;
				while( path.length > 0 ) {
					var key = path.join(".");
					var name = path.pop();
					var vp = parentVars.get(path);
					if( vp == null ) {
						vp = declVar(name,TStruct([]),Local);
						parentVars.set(path,vp);
					}
					switch( vp.type ) {
					case TStruct(vl): vl.push(cur);
					default:
					}
					cur.parent = vp;
					cur = vp;
				}
			}
			s.data.vars.push(vreal);
			var index = (v.pos>>2);
			var extract = switch( v.type ) {
			case TMat4:
				{ p : pos, t : v.type, e : TCall({ e : TGlobal(Mat4), t : TVoid, p : pos },[
					readOffset(index),
					readOffset(index + 1),
					readOffset(index + 2),
					readOffset(index + 3),
				]) };
			case TVec(4,VFloat):
				readOffset(index);
			case TVec(3,VFloat):
				{ p : pos, t : v.type, e : TSwiz(readOffset(index),v.pos&3 == 0 ? [X,Y,Z] : [Y,Z,W]) };
			case TVec(2,VFloat):
				var swiz = switch( v.pos & 3 ) {
				case 0: [X,Y];
				case 1: [Y,Z];
				default: [Z,W];
				}
				{ p : pos, t : v.type, e : TSwiz(readOffset(index),swiz) };
			case TFloat:
				{ p : pos, t : v.type, e : TSwiz(readOffset(index),swiz[v.pos&3]) }
			default:
				throw "assert";
			}
			return { p : pos, e : TBinop(OpAssign, { e : TVar(vreal), p : pos, t : v.type }, extract), t : TVoid };
		}

		var exprs = [];
		var stride = used.length;
		var p = params;
		while( p != null ) {
			exprs.push(extractVar(p));
			p = p.next;
		}

		exprs.unshift({
			p : pos,
			e : TBinop(OpAssign, eoffset, { p : pos, t : TInt, e : TBinop(OpMult,{ e : TGlobal(InstanceID), t : TInt, p : pos },{ e : TConst(CInt(stride)), p : pos, t : TInt }) }),
			t : TVoid,
		});

		var fv : TVar = declVar("init",TFun([]), Function);
		var f : TFunction = {
			kind : Init,
			ref : fv,
			args : [],
			ret : TVoid,
			expr : { e : TBlock(exprs), p : pos, t : TVoid },
		};
		s.data.funs.push(f);
		s.consts = new SharedShader.ShaderConst(vcount,0,countBits);
		s.consts.globalId = 0;

		return { shader : s, params : params, size : stride };
	}

	static var INST : Cache;
	public static function get() : Cache {
		var c = INST;
		if( c == null )
			INST = c = new Cache();
		return c;
	}

	public static function set(c) {
		INST = c;
	}

	public static function clear() {
		INST = null;
	}

}