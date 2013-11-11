package hxsl;
using hxsl.Ast;

class Serializer {

	var fmap : Map<TFunction,TFunction>;
	
	function new() {
		fmap = new Map();
	}
	
	function mapExpr( e : TExpr ) {
		var e = e.map(mapExpr);
		switch( e.e ) {
		case TFunVar(f):
			var f2 = fmap.get(f);
			if( f2 == null ) throw 'Missing function $f.name';
			e.e = TFunVar(f2);
		default:
		}
		#if macro
		e.p = cast haxe.macro.Context.getPosInfos(e.p);
		#end
		return e;
	}

	
	public static function run( s : ShaderData ) {
		#if macro
		var ser = new Serializer();
		var fout = [];
		for( f in s.funs ) {
			var f2 : TFunction = {
				name : f.name,
				expr : f.expr,
				args : f.args,
				ret : f.ret,
			};
			ser.fmap.set(f, f2);
			fout.push(f2);
		}
		for( f in s.funs )
			ser.fmap.get(f).expr = ser.mapExpr(f.expr);
		var s : ShaderData = {
			vars : s.vars,
			funs : fout,
		};
		#end
		var ser = new haxe.Serializer();
		ser.useCache = true;
		ser.useEnumIndex = true;
		ser.serialize(s);
		return ser.toString();
	}
	
}