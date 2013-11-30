package hxsl;
using hxsl.Ast;

class ShaderInstance {
	public var id : Int;
	public var shader : ShaderData;
	public function new(shader) {
		id = Tools.allocVarId();
		this.shader = shader;
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
	public function new(v, pos, bits) {
		this.v = v;
		this.pos = pos;
		this.bits = bits;
	}
}

class SharedShader {
	
	public var data : ShaderData;
	public var globals : Array<ShaderGlobal>;
	public var consts : Array<ShaderConst>;
	var instanceCache : Map<Int,ShaderInstance>;
	
	public function new(src:String) {
		instanceCache = new Map();
		data = haxe.Unserializer.run(src);
		consts = [];
		globals = [];
		for( v in data.vars )
			browseVar(v);
		if( consts.length == 0 )
			instanceCache.set(0, new ShaderInstance(data));
	}
	
	public function getInstance( constBits : Int ) {
		var i = instanceCache.get(constBits);
		if( i != null )
			return i;
		var e = new hxsl.Eval();
		for( c in consts )
			e.setConstant(c.v, switch( c.v.type ) {
			case TBool: CBool((constBits >>> c.pos) & 1 != 0);
			case TInt: CInt((constBits >>> c.pos) & ((1 << c.bits) - 1));
			default: throw "assert";
			});
		i = new ShaderInstance(e.eval(data));
		instanceCache.set(constBits, i);
		return i;
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
				var prev = consts[consts.length - 1];
				var pos = prev == null ? 0 : prev.pos + prev.bits;
				var c = new ShaderConst(v, pos, bits);
				c.globalId = globalId;
				consts.push(c);
			}
		}
	}

}
