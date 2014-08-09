package hxsl;
using hxsl.Ast;

class Serializer {

	function new() {
	}

	#if macro
	function mapExpr( e : TExpr ) {
		var e = e.map(mapExpr);
		e.p = cast haxe.macro.Context.getPosInfos(e.p);
		return e;
	}
	#end

	public static function run( s : ShaderData ) {
		#if macro
		var ser = new Serializer();
		var s : ShaderData = {
			name : s.name,
			vars : s.vars,
			funs : [for( f in s.funs ) {
				kind : f.kind,
				ref : f.ref,
				args : f.args,
				ret : f.ret,
				expr : ser.mapExpr(f.expr),
			}],
		};
		#end
		var ser = new haxe.Serializer();
		ser.useCache = true;
		ser.useEnumIndex = true;
		ser.serialize(s);
		return ser.toString();
	}

}