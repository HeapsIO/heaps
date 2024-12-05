package hxsl;
using hxsl.Ast;

class ShaderInstance {
	static var UID = 0;
	public var id : Int;
	public var shader : ShaderData;
	public var params : Map<Int,Int>;
	public function new(shader) {
		id = ++UID;
		this.shader = shader;
		params = new Map();
	}
}

class ShaderGlobal {
	public var v : TVar;
	public var globalId : Int;
	public function new(v, gid) {
		this.v = v;
		this.globalId = gid;
	}
}

class ShaderConst {
	public var v : TVar;
	public var pos : Int;
	public var bits : Int;
	public var globalId : Int;
	public var next : ShaderConst;
	public function new(v, pos, bits) {
		this.v = v;
		this.pos = pos;
		this.bits = bits;
	}
}

class SharedShader {

	public static var UNROLL_LOOPS = false;

	public var data : ShaderData;
	public var globals : Array<ShaderGlobal>;
	public var consts : ShaderConst;
	var instanceCache : Map<Int,ShaderInstance>;
	var paramsCount : Int;

	public function new(src:String) {
		instanceCache = new Map();
		consts = null;
		globals = [];
		if( src == "" )
			return;
		data = new hxsl.Serializer().unserialize(src);
		for( v in data.vars )
			initVarId(v);
		data = compactMem(data);
		initialize();
	}

	function initialize() {
		for( v in data.vars )
			browseVar(v);
		// don't try to optimize if consts is null, we need to do a few things in Eval
	}

	public inline function getInstance( constBits : Int ) {
		var i = instanceCache.get(constBits);
		return if( i == null ) makeInstance(constBits) else i;
	}

	function makeBufferType( v : TVar, tbuf : hxsl.Ast.Type, fmt : hxd.BufferFormat ) : hxsl.Ast.Type {
		var name = v.name;
		switch( tbuf ) {
		case TStruct(vl):
			var inputs = [for( i in fmt.getInputs() ) i];
			var vli : Array<TVar> = [];
			var p = 0;
			while( p < inputs.length ) {
				var i = inputs[p++];
				var name = i.name;
				var t = switch( i.type ) {
				case DVec2: TVec(2,VFloat);
				case DVec3: TVec(3,VFloat);
				case DVec4: TVec(4,VFloat);
				case DFloat: TFloat;
				case DBytes4: TBytes(4);
				}
				if( StringTools.endsWith(i.name,"__m0") ) {
					var h = i.type.getSize();
					var w = 2;
					while( inputs[p+w-1] != null && StringTools.endsWith(inputs[p+w-1].name,"__m"+w) )
						w++;
					t = switch( [w,h] ) {
					case [2,2]: TMat2;
					case [3,3]: TMat3;
					case [3,4]: TMat3x4;
					case [4,4]: TMat4;
					default: throw "Unsupported matrix format";
					}
					name = i.name.substr(0,-4);
					p += w - 1;
				}
				vli.push({
					id : Tools.allocVarId(),
					name : name,
					type : t,
					kind : v.kind,
					parent : v,
				});
			}
			for( v in vl ) {
				var found = false;
				for( v2 in vli )
					if( v.name == v2.name ) {
						switch( [v.type, v2.type] ) {
						case [TFloat, TFloat]:
						case [TVec(a,VFloat), TVec(b,VFloat)] if( a <= b ):
						default:
							if( !v.type.equals(v2.type) )
								throw "Buffer "+data.name+"."+v.name+":"+v.type.toString()+" should be "+v2.type.toString();
						}
						found = true;
						break;
					}
				if( !found )
					throw "Buffer is missing "+data.name+"."+v.name+":"+v.type.toString();
			}
			return TStruct(vli);
		default:
			throw "assert";
		}
	}

	function makeInstance( constBits : Int )  {
		var eval = new hxsl.Eval();
		var c = consts;
		var buffers : Array<TVar> = [];
		while( c != null ) {
			switch( c.v.type ) {
			case TBool:
				eval.setConstant(c.v, CBool((constBits >>> c.pos) & 1 != 0));
			case TInt, TChannel(_):
				eval.setConstant(c.v, CInt((constBits >>> c.pos) & ((1 << c.bits) - 1)));
			case TBuffer(t, size, kind):
				var bits = (constBits >>> c.pos) & ((1 << c.bits) - 1);
				var fmt = hxd.BufferFormat.fromID(bits);
				var v : TVar = {
					id : c.v.id,
					name : c.v.name,
					kind : c.v.kind,
					type : null,
				};
				var fullT = makeBufferType(v, t, fmt);
				v.type = TBuffer(fullT, size, switch( kind ) {
					case Partial: Uniform;
					case StoragePartial: Storage;
					case RWPartial: RW;
					default: throw "assert";
				});
				eval.varMap.set(c.v, v);
				buffers.push(v);
			default: throw "assert";
			}
			c = c.next;
		}
		for ( v in buffers ) {
			switch ( v.type ) {
			case TBuffer(t, SVar(vs), kind):
				var c = @:privateAccess eval.constants.get(vs.id);
				if ( c != null ) {
					switch ( c ) {
					case TConst(CInt(i)):
						v.type = TBuffer(t, SConst(i), kind);
					default:
					}
				}
			default:
			}
		} 
		eval.inlineCalls = true;
		eval.unrollLoops = UNROLL_LOOPS;
		var edata = eval.eval(data);
		edata = compactMem(edata);
		var i = new ShaderInstance(edata);
		#if debug
		Printer.check(i.shader, [data]);
		#end
		paramsCount = 0;
		for( v in data.vars )
			addParam(eval, i, v);
		instanceCache.set(constBits, i);
		return i;
	}

	function addSelfParam( i : ShaderInstance, v : TVar ) {
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				addSelfParam(i, v);
		default:
			if( v.kind == Param ) {
				i.params.set( v.id,  paramsCount );
				paramsCount++;
			}
		}
	}

	function addParam( eval : Eval, i : ShaderInstance, v : TVar ) {
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				addParam(eval, i, v);
		default:
			if( v.kind == Param ) {
				i.params.set( eval.varMap.get(v).id,  paramsCount );
				paramsCount++;
			}
		}
	}

	function initVarId( v : TVar ) {
		v.id = Tools.allocVarId();
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				initVarId(v);
		default:
		}
	}

	function browseVar( v : TVar, ?path : String ) {
		if( path == null )
			path = v.getName();
		else
			path += "." + v.name;
		switch( v.type ) {
		case TStruct(vl):
			for( vs in vl )
				browseVar(vs,path);
		default:
			var globalId = 0;
			if( v.kind == Global ) {
				globalId = Globals.allocID(path);
				globals.push(new ShaderGlobal(v,globalId));
			}
			if( !v.isConst() )
				return;
			var bits = v.getConstBits();
			if( bits > 0 ) {
				var pos = consts == null ? 0 : consts.pos + consts.bits;
				var c = new ShaderConst(v, pos, bits);
				c.globalId = globalId;
				c.next = consts;
				consts = c;
			}
		}
	}

	public static function compactMem<T>( mem : T ) {
		#if (hl && heaps_compact_mem)
		mem = hl.Api.compact(mem, null, 0, null);
		#end
		return mem;
	}

}
