package hxsl;
import haxe.macro.Context;
import haxe.macro.Expr;
using hxsl.Ast;

class Macros {

	static function makeType( t : Type ) : ComplexType {
		return switch( t ) {
		case TVoid: macro : Void;
		case TVec(_, t):
			switch( t ) {
			case VFloat:
				macro : hxsl.Types.Vec;
			case VInt:
				macro : hxsl.Types.IVec;
			case VBool:
				macro : hxsl.Types.BVec;
			}
		case TStruct(vl):
			TAnonymous([for( v in vl ) { pos : Context.currentPos(), name : v.name, kind : FVar(makeType(v.type)) } ]);
		case TSampler2D:
			macro : hxsl.Types.Sampler2D;
		case TSamplerCube:
			macro : hxsl.Types.SamplerCube;
		case TMat3, TMat3x4, TMat4:
			macro : hxsl.Types.Matrix;
		case TString:
			macro : String;
		case TInt:
			macro : Int;
		case TFloat:
			macro : Float;
		case TBool:
			macro : Bool;
		case TArray(t, _):
			var t = makeType(t);
			macro : Array<$t>;
		case TFun(_):
			throw "assert";
		}
	}
	
	static function makeDef( t : Type, pos : Position ) : haxe.macro.Expr {
		return switch( t ) {
		case TFloat, TInt: macro 0;
		case TVec(_, t):
			switch( t ) {
			case VFloat:
				macro new hxsl.Types.Vec();
			case VInt:
				macro new hxsl.Types.IVec();
			case VBool:
				macro new hxsl.Types.BVec();
			}
		case TStruct(vl):
			{ expr : EObjectDecl([for( v in vl ) { field : v.name, expr : makeDef(v.type, pos) } ]), pos : pos };
		case TArray(_):
			macro new Array();
		default:
			null;
		}
	}
	
	static function getConsts( v : TVar, p : Position, consts : Array<{ pos : Int, bits : Int, v : TVar }> ) {
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				getConsts(v, p, consts);
		default:
			if( v.isConst() ) {
				var bits = v.getConstBits();
				if( bits == 0 )
					Error.t("Unsupported @const type "+v.type.toString(), p);
				var prev = consts[consts.length - 1];
				var pos = prev == null ? 0 : prev.pos + prev.bits;
				if( pos + bits > 32 )
					Error.t("Too many constants for this shader, reduce int size by specifiying @const(max-value)", p);
				consts.push({ pos : pos, bits : bits, v : v });
			}
		}
	}
	
	static function buildFields( shader : ShaderData, pos : Position ) {
		var fields = new Array<Field>();
		var globals = [], consts = [], params = [];
		for( v in shader.vars ) {
			var cpos = consts.length;
			getConsts(v, pos, consts);
			switch( v.kind ) {
			case Param:
				var t = makeType(v.type);
				var f : Field = {
					name : v.name,
					pos : pos,
					kind : FProp("get","set", t),
					access : [APublic],
				};
				var name = v.name + "__";
				var f2 : Field = {
					name : name,
					pos : pos,
					kind : FVar(t,makeDef(v.type,pos)),
				};
				var fget : Field = {
					name : "get_" + v.name,
					pos : pos,
					kind : FFun( {
						ret : t,
						args : [],
						expr : if( consts.length == cpos || (consts.length == cpos+1 && consts[cpos].v == v) )
							macro return $i{ name };
						else
							macro {
								constModified = true;
								return $i{ name };
							},
					}),
					access : [AInline],
				};
				var fset : Field = {
					name : "set_" + v.name,
					pos : pos,
					kind : FFun( {
						ret : t,
						args : [ { name : "_v", type : t } ],
						expr : if( consts.length == cpos )
							macro return $i{ name } = _v;
						else
							macro {
								constModified = true;
								return $i{ name } = _v;
							}
					}),
					access : [AInline],
				};
				fields.push(f);
				fields.push(f2);
				params.push(name);
				fields.push(fget);
				fields.push(fset);
			case Global:
				globals.push(v);
			default:
			}
		}
		// updateConstants
		var exprs = [];
		function getPath(v:TVar) {
			if( v.parent == null )
				return { expr : haxe.macro.Expr.ExprDef.EConst(CIdent(v.name+"__")), pos : pos };
			return { expr : haxe.macro.Expr.ExprDef.EField(getPath(v.parent), v.name), pos : pos };
		}
		for( c in consts ) {
			if( c.v.kind == Global ) continue;
			var p = getPath(c.v);
			switch( c.v.type ) {
			case TInt:
				exprs.push(macro {
					var v : Int = $p;
					if( v >>> $v{ c.bits } != 0 ) throw $v{ c.v.name } +" is out of range " + v + ">" + $v{ (1 << c.bits) - 1 };
					constBits |= v << $v{ c.pos };
				});
			case TBool:
				exprs.push(macro if( $p ) constBits |= 1 << $v{ c.pos } );
			default:
				throw "assert";
			}
		}
		fields.push( {
			name : "updateConstants",
			pos : pos,
			kind : FFun({
				ret : macro : Void,
				args : [ { name : "globals", type : macro : hxsl.Globals } ],
				expr : macro {
					constBits = 0;
					{$a{ exprs }};
					super.updateConstants(globals);
				},
			}),
			access : [AOverride],
		});
		var index = 0;
		fields.push( {
			name : "getParamValue",
			pos : pos,
			kind : FFun( {
				ret : macro : Dynamic,
				args : [ { name : "index", type : macro : Int } ],
				expr : {
					expr : EBlock([
						{ expr : ESwitch(macro index, [for( p in params ) { values : [macro $v{ index++ } ], expr : macro return $i{ p } } ], macro {}), pos : pos },
						macro return null,
					]),
					pos : pos,
				},
			}),
			access : [AOverride],
		});
		return fields;
	}
	
	public static function buildShader() {
		var fields = Context.getBuildFields();
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_, expr) if( expr != null ):
					var pos = expr.pos;
					if( !Lambda.has(f.access, AStatic) ) f.access.push(AStatic);
					try {
						var shader = new MacroParser().parseExpr(expr);
						var name = Std.string(Context.getLocalClass());
						var shader = new Checker().check(name,shader);
						var str = Serializer.run(shader);
						f.kind = FVar(null, { expr : EConst(CString(str)), pos : pos } );
						f.meta.push({
							name : ":keep",
							pos : pos,
						});
						for( f in buildFields(shader,pos) )
							fields.push(f);
					} catch( e : Ast.Error ) {
						fields.remove(f);
						Context.error(e.msg, e.pos);
					}
				default:
				}
			}
		return fields;
	}
	
	public static function buildGlobals() {
		var fields = Context.getBuildFields();
		var globals = [];
		var sets = [];
		for( f in fields ) {
			for( m in f.meta ) {
				if( m.name == "global" )
					switch( [f.kind, m.params[0].expr] ) {
					case [FVar(t, set), EConst(CString(name))]:
						f.kind = FVar(macro : hxsl.Globals.GlobalSlot<$t>);
						globals.push(macro $i{ f.name } = new hxsl.Globals.GlobalSlot($v { name } ));
						if( set != null )
							sets.push(macro $i{ f.name }.set(globals, $set));
					default:
					}
			}
		}
		var p = Context.currentPos();
		fields.push({
			name : "initGlobals",
			kind : FFun({
				ret : null,
				expr : { expr : EBlock(globals), pos : p },
				args : [],
			}),
			pos : p,
		});
		fields.push({
			name : "setGlobals",
			kind : FFun({
				ret : null,
				expr : { expr : EBlock(sets), pos : p },
				args : [],
			}),
			pos : p,
		});
		return fields;
	}
	
}