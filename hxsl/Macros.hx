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
		var globals = [], consts = [];
		for( v in shader.vars ) {
			var cpos = consts.length;
			getConsts(v, pos, consts);
			switch( v.kind ) {
			case Param:
				var t = makeType(v.type);
				var f : Field = {
					name : v.name,
					pos : pos,
					kind : FProp("get","set", t, makeDef(v.type,pos)),
					access : [APublic],
					meta : [{ name : ":isVar", pos : pos }],
				};
				var fget : Field = {
					name : "get_" + v.name,
					pos : pos,
					kind : FFun( {
						ret : t,
						args : [],
						expr : if( consts.length == cpos || (consts.length == cpos+1 && consts[cpos].v == v) )
							macro return $i{ v.name };
						else
							macro {
								constModified = true;
								return $i{ v.name };
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
							macro return $i{ v.name } = _v;
						else
							macro {
								constModified = true;
								return $i{ v.name } = _v;
							}
					}),
					access : [AInline],
				};
				fields.push(f);
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
				return { expr : haxe.macro.Expr.ExprDef.EConst(CIdent(v.name)), pos : pos };
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
	
}