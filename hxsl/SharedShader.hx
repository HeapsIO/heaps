package hxsl;
using hxsl.Ast;

class ShaderInstance {
	public var id : Int;
	public var shader : ShaderData;
	public var params : Map<Int,Int>;
	public function new(shader) {
		id = Tools.allocVarId();
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

	public static var UNROLL_LOOPS = #if flash true #else false #end;

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

	function makeInstance( constBits : Int )  {
		var eval = new hxsl.Eval();
		var c = consts;
		while( c != null ) {
			eval.setConstant(c.v, switch( c.v.type ) {
			case TBool: CBool((constBits >>> c.pos) & 1 != 0);
			case TInt, TChannel(_): CInt((constBits >>> c.pos) & ((1 << c.bits) - 1));
			default: throw "assert";
			});
			c = c.next;
		}
		eval.inlineCalls = true;
		#if flash
		eval.eliminateConditionals = true;
		#end
		eval.unrollLoops = UNROLL_LOOPS;
		var i = new ShaderInstance(eval.eval(data));
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

	function browseVar( v : TVar, ?path : String ) {
		v.id = Tools.allocVarId();
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

}
