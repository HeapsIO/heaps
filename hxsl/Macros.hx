package hxsl;
import haxe.macro.Context;
import haxe.macro.Expr;
using hxsl.Ast;

class Macros {
	#if macro
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
			var fields = [];
			var pos = Context.currentPos();
			for( v in vl ) {
				fields.push({ pos : pos, name : v.name, kind : FVar(makeType(v.type)) });
				if( v.type.match(TChannel(_)) )
				fields.push({ pos : pos, name : v.name+"Channel", kind : FVar(macro : hxsl.Channel) });
			}
			TAnonymous(fields);
		case TSampler2D:
			macro : hxsl.Types.Sampler2D;
		case TSampler2DArray:
			macro : hxsl.Types.Sampler2DArray;
		case TSamplerCube:
			macro : hxsl.Types.SamplerCube;
		case TMat2, TMat3, TMat3x4, TMat4:
			macro : hxsl.Types.Matrix;
		case TString:
			macro : String;
		case TInt, TBytes(_):
			macro : Int;
		case TFloat:
			macro : Float;
		case TBool:
			macro : Bool;
		case TArray(t, _):
			var t = makeType(t);
			macro : Array<$t>;
		case TChannel(_):
			macro : hxsl.Types.ChannelTextureType;
		case TFun(_):
			throw "assert";
		case TBuffer(_):
			macro : hxsl.Types.Buffer;
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
		case TMat3, TMat3x4, TMat4:
			macro new hxsl.Types.Matrix();
		default:
			null;
		}
	}

	static function makeInit( e : Ast.TExpr ) : haxe.macro.Expr {
		return switch( e.e ) {
		case TConst(c):
			{
				expr : EConst(switch( c ) {
					case CNull: CIdent("null");
					case CBool(b): CIdent(b?"true":"false");
					case CFloat(f): CFloat("" + f);
					case CInt(i): CInt(""+i);
					case CString(s): CString(s);
				}),
				pos : e.p,
			};
		case TCall({ e : TGlobal(g = (Vec2 | Vec3 | Vec4)) }, args):
			if( args.length == 1 )
				args = switch( g ) {
					case Vec2: [args[0], args[0]];
					case Vec3: [args[0], args[0], args[0]];
					case Vec4: [args[0], args[0], args[0], args[0]];
					default: throw "assert";
				};
			{
				expr : ENew({ pack : ["h3d"], name : "Vector" }, [for( a in args ) makeInit(a)]),
				pos : e.p,
			}
		default:
			Error.t("Unsupported init expr", e.p);
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

	static function addParamRec( eparams : Array<haxe.macro.Expr>, tparams : Array<Type>, e : haxe.macro.Expr, t : Type ) {
		switch( t ) {
		case TStruct(vl):
			for( v in vl )
				addParamRec(eparams, tparams, { expr : EField(e, v.name), pos : e.pos }, v.type);
		default:
			eparams.push(e);
			tparams.push(t);
		}
	}

	static function buildFields( shader : ShaderData, inits : Array<{ v : TVar, e : Ast.TExpr }>, pos : Position ) {
		var fields = new Array<Field>();
		var globals = [], consts = [], params = [], eparams = [], tparams = [];
		var metas = [{ name : ":noCompletion", pos : pos }, { name : ":keep", pos : pos }];
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
					doc: v.getDoc(),
				};
				var name = v.name + "__";
				var initVal = null;
				for( i in inits )
					if( i.v == v )
						initVal = i.e;
				var f2 : Field = {
					name : name,
					pos : pos,
					kind : FVar(t, initVal != null ? makeInit(initVal) : makeDef(v.type, pos)),
					meta : metas,
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
					meta : metas,
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
					meta : metas,
				};
				fields.push(f);
				fields.push(f2);
				params.push(name);
				addParamRec(eparams, tparams, { expr : EConst(CIdent(name)), pos:pos }, v.type);
				fields.push(fget);
				fields.push(fset);

				if( v.type.match(TChannel(_)) ) {
					var sel = v.name+"Channel";
					var selVar = sel + "__";
					var get_sel = "get_" + sel;
					var set_sel = "set_" + sel;
					var sfields = macro class {
						var $selVar : hxsl.Channel = Unknown;
						public var $sel(get, set) : hxsl.Channel;
						inline function $get_sel() return $i{selVar};
						inline function $set_sel(v) { constModified = true; return $i{selVar} = v; }
					};
					for( f in sfields.fields )
						fields.push(f);
				}

			case Global:
				globals.push(v);
			default:
			}
		}
		// updateConstants
		var exprs = [];
		function getPath(v:TVar,?suffix) {
			var name = suffix == null ? v.name : v.name + suffix;
			if( v.parent == null )
				return { expr : haxe.macro.Expr.ExprDef.EConst(CIdent(name+"__")), pos : pos };
			return { expr : haxe.macro.Expr.ExprDef.EField(getPath(v.parent), name), pos : pos };
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
			case TChannel(n):
				var psel = getPath(c.v, "Channel");
				var defFormat = macro throw $v{c.v.name} +"Channel is not set";
				switch(n) {
				case 1: defFormat = macro if( hxsl.Types.ChannelTools.isPackedFormat($p) ) $psel = PackedFloat else $defFormat;
				case 3: defFormat = macro if( hxsl.Types.ChannelTools.isPackedFormat($p) ) $psel = PackedNormal else $defFormat;
				default: macro throw $v{c.v.name} +"Channel is not set";
				}
				exprs.push(macro {
					if( $p == null ) $psel = Unknown else if( $psel == Unknown ) $defFormat;
					constBits |= ((globals.allocChannelID($p) << 3) | Type.enumIndex($psel)) << $v{ c.pos };
				});
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
					updateConstantsFinal(globals);
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
						{ expr : ESwitch(macro index, [for( p in eparams ) { values : [macro $v{ index++ } ], expr : macro return $p } ], macro {}), pos : pos },
						macro return null,
					]),
					pos : pos,
				},
			}),
			access : [AOverride],
		});
		fields.push( {
			name : "getParamFloatValue",
			pos : pos,
			kind : FFun( {
				ret : macro : Float,
				args : [ { name : "index", type : macro : Int } ],
				expr : {
					expr : EBlock([
						{ expr : ESwitch(macro index, [for( i in 0...tparams.length ) if( tparams[i] == TFloat ) { values : [macro $v{i}], expr : macro return ${eparams[i]} }], macro {}), pos : pos },
						macro return 0.,
					]),
					pos : pos,
				},
			}),
			access : [AOverride],
		});
		if( params.length > 0 ) {
			var cexpr = [];
			var type = Context.getLocalClass().toString().split(".").pop();
			var ctype : ComplexType = TPath({ name : type, pack : [] });
			cexpr.push(macro var s : $ctype = Type.createEmptyInstance($i { type } ));
			cexpr.push(macro {
				s.shader = shader;
			});
			for( p in params ) {
				cexpr.push(macro s.$p = $i{p});
			}
			cexpr.push(macro return s);
			fields.push({
				name : "clone",
				pos : pos,
				kind : FFun({
					ret : macro : hxsl.Shader,
					args : [],
					expr : { expr : EBlock(cexpr), pos : pos },
				}),
				access : [AOverride],
			});
		}

		fields.push( {
			name : "_SHADER",
			kind : FVar(macro : hxsl.SharedShader),
			pos : pos,
			access : [AStatic],
			meta : [{ name : ":keep", pos : pos }],
		});

		return fields;
	}

	static function loadShader( path : String ) {
		var m = Context.follow(Context.getType(path));
		switch( m ) {
		case TInst(c, _):
			var c = c.get();
			for( m in c.meta.get() )
				if( m.name == ":src" )
					return new MacroParser().parseExpr(m.params[0]);
		default:
		}
		throw path + " is not a shader";
		return null;
	}

	public static function buildShader() {
		var fields = Context.getBuildFields();
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_, expr) if( expr != null ):
					var pos = expr.pos;
					if( !Lambda.has(f.access, AStatic) ) f.access.push(AStatic);
					Context.getLocalClass().get().meta.add(":src", [expr], pos);
					try {
						var shader = new MacroParser().parseExpr(expr);
						var c = Context.getLocalClass();
						var csup = c.get().superClass;
						var supFields = new Map();
						// add auto extends
						do {
							var sup = Std.string(csup.t);
							if( sup == "hxsl.Shader" ) break;
							var tsup = csup.t.get();
							for( f in tsup.fields.get() )
								supFields.set(f.name, true);
							if( tsup.module != sup && tsup.module != Context.getLocalModule() )
								sup = tsup.module+"."+tsup.name;
							shader = { expr : EBlock([ { expr : ECall( { expr : EIdent("extends"), pos : pos }, [ { expr : EConst(CString(sup)), pos : pos } ]), pos : pos }, shader]), pos : pos };
							supFields.remove("updateConstants");
							supFields.remove("getParamValue");
							supFields.remove("getParamFloatValue");
							supFields.remove("clone");
							csup = tsup.superClass;
						} while( true);
						var name = Std.string(c);
						var check = new Checker();
						check.loadShader = loadShader;
						check.warning = function(msg,pos) {
							haxe.macro.Context.warning(msg, pos);
						};
						var shader = check.check(name, shader);
						//Printer.check(shader);
						var str = Context.defined("display") ? "" : Serializer.run(shader);
						f.kind = FVar(null, { expr : EConst(CString(str)), pos : pos } );
						f.meta.push({
							name : ":keep",
							pos : pos,
						});
						for( f in buildFields(shader, check.inits, pos) )
							if( !supFields.exists(f.name) )
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
			if( f.meta == null ) continue;
			for( m in f.meta ) {
				if( m.name == "global" )
					switch( [f.kind, m.params[0].expr] ) {
					case [FVar(t, set), EConst(CString(name))]:
						var id = f.name + "_id";
						fields.push({
							name : id,
							kind : FVar(macro : hxsl.Globals.GlobalSlot<$t>),
							pos : f.pos,
							meta : [{ name : ":noCompletion", pos : f.pos }],
						});
						f.kind = FProp("get", "set", t);
						fields.push({
							name : "get_" + f.name,
							kind : FFun({
								args : [],
								ret : t,
								expr : macro return $i{id}.get(globals),
							}),
							pos : f.pos,
							access : [AInline],
						});
						fields.push({
							name : "set_" + f.name,
							kind : FFun({
								args : [{ name : "v", type : t }],
								ret : t,
								expr : macro { $i{ id }.set(globals, v); return v; },
							}),
							pos : f.pos,
							access : [AInline],
						});
						globals.push(macro $i{id} = new hxsl.Globals.GlobalSlot($v{ name }));
						if( set != null )
							sets.push(macro $i{f.name} = $set);
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
	#end
}