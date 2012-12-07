package h3d.impl;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import hxsl.Data;

class Macros {

	static function realType( t : VarType, p : Position ) : ComplexType {
		return TPath(switch( t ) {
		case TNull: throw "assert";
		case TBool: { pack : [], name : "Bool", params : [], sub : null };
		case TFloat: { pack : [], name : "Float", params : [], sub : null };
		case TFloat2, TFloat3, TFloat4: { pack : ["h3d"], name : "Vector", params : [], sub : null };
		case TInt: { pack : [], name : "Int", params : [], sub : null };
		case TMatrix(_): { pack : ["h3d"], name: "Matrix", params : [], sub : null };
		case TTexture(cube): { pack : ["h3d","mat"], name : "Texture", params : [], sub : null };
		case TArray(t, size): { pack : ["h3d"], name : "Shader", sub : "FixedArray", params : [TPType(realType(t,p)), TPExpr( { expr : EConst(CInt(""+size)), pos : p } )] };
		});
	}

	public static function buildShader() {
		var fields = Context.getBuildFields();
		var shaderCode = null;
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_, e):
					shaderCode = e;
				default:
				}
				fields.remove(f);
				// remove even if error
				haxe.macro.Compiler.removeField(Context.getLocalClass().toString(), "SRC", true);
				break;
			}
		var cl = switch( Context.getLocalType() ) {
		case TInst(c, _): c.get();
		default: throw "assert";
		}
		if( shaderCode == null ) {
			if( cl.meta.has(":skip") )
				return null;
			Context.error("Shader SRC not found", cl.pos);
		}
		
		var p = new hxsl.Parser();
		p.includeFile = function(file) {
			var f = Context.resolvePath(file);
			return Context.parse("{"+sys.io.File.getContent(f)+"}", Context.makePosition( { min : 0, max : 0, file : f } ));
		};

		var data = try p.parse(shaderCode) catch( e : hxsl.Data.Error ) haxe.macro.Context.error(e.message, e.pos);
		var c = new hxsl.Compiler();
		c.warn = Context.warning;
		var data = try c.compile(data) catch( e : hxsl.Data.Error ) haxe.macro.Context.error(e.message, e.pos);

		var pos = Context.currentPos();
		
		// store HXSL data for runtime compilation
		fields.push( {
			name : "HXSL",
			kind : FVar(null,{ expr : EConst(CString(hxsl.Serialize.serialize(data))), pos : pos }),
			access : [AStatic],
			pos : pos,
			meta : [ { name:":keep", params : [], pos : pos } ],
		});
		fields.push( {
			name : "GLOBALS",
			kind : FVar(macro : h3d.Shader.ShaderGlobals),
			access : [AStatic],
			pos : pos,
			meta : [ { name:":keep", params : [], pos : pos } ],
		});
		
		// create all the variables accessors
		var allVars = Tools.getAllVars(data);
		var constCount = 0, virtualIndex = 0, texCount = 0, updates = [];
		
		for( v in allVars ) {
			var pos = v.pos;
			switch( v.kind ) {
			case VConst, VParam:
				
				v.index = virtualIndex;
				if( v.type != TBool )
					virtualIndex += Tools.floatSize(v.type);
				
				var t = realType(v.type, pos);
				fields.push( {
					name : v.name,
					kind : FProp("get", "set", t),
					pos : pos,
					access : [APublic],
				});
				fields.push( {
					name : v.name+"_",
					kind : FVar(t),
					pos : pos,
					access : [],
				});

				var ev = { expr : EConst(CIdent("v")), pos : pos };
				var evar = { expr : EConst(CIdent(v.name + "_")), pos : pos };
				
				var set = [
					macro modified = true,
					{ expr : EBinop(OpAssign,evar, ev), pos : pos },
				];
				if( v.name == "m2pos" )
					trace(v.name+" "+v.kind);
				if( v.kind == VConst ) {
					if( constCount == 32 )
						Context.error("Too many constants for this shader (max 32)", Context.currentPos());
					var chk = v.type == TBool ? ev : { expr : EBinop(OpNotEq, ev, { expr : EConst(CIdent("null")), pos : pos } ), pos : pos };
					var count = { expr : EConst(CInt(""+constCount)), pos : pos };
					set.push(macro setConstFlag($count, $chk));
					constCount++;
				}
				set.push(macro return v);
				fields.push( {
					name : "set_" + v.name,
					kind : FFun( {
						ret : t,
						params : [],
						args : [{ name : "v",  type : t, opt : false }],
						expr : {
							expr : EBlock(set),
							pos : pos,
						},
					}),
					pos : pos,
					access : [],
				});
				
				var get = [];
				switch( v.type ) {
				case TInt, TFloat, TBool: // no allocation required
				default:
					function loadType( t : VarType, eindex, rec = 0 ) {
						var args = [{ expr : eindex, pos : pos }];
						var name = switch( t ) {
						case TBool, TNull, TTexture(_): throw "assert";
						case TInt: "Int";
						case TFloat: "Float";
						case TFloat2, TFloat3, TFloat4:
							args.push( { expr : EConst(CInt(Tools.floatSize(v.type) + "")), pos : pos } );
							"Floats";
						case TMatrix(r, c, t):
							args.push( { expr : EConst(CInt(r + "")), pos : pos } );
							args.push( { expr : EConst(CInt(c + "")), pos : pos } );
							if( t.t ) "MatrixT" else "Matrix";
						case TArray(t, size):
							var vi = "i" + rec;
							var ei = { expr : EConst(CIdent(vi)), pos : pos };
							var esize = { expr : EConst(CInt(size + "")), pos : pos };
							var stride = Tools.regSize(t);
							var load = loadType(t, EBinop(OpAdd, { expr : eindex, pos : pos }, { expr : EBinop(OpMult, { expr : EConst(CIdent(vi)), pos : pos }, { expr : EConst(CInt(stride + "")), pos : pos } ), pos : pos } ), rec + 1);
							return macro {
								var a = [];
								for( $ei in 0...$esize )
									a.push($load);
								a;
							}
						}
						return { expr : ECall( { expr : EConst(CIdent("load" + name)), pos : pos }, args), pos : pos };
					}
					var load = loadType(v.type, EConst(CInt(v.index + "")));
					get.push(macro if( $evar == null ) { $evar = $load; modified = true; });
				}
				get.push(macro return $evar);
				
				if( v.type != TBool ) {
					function saveType( t : VarType, eindex, evar, rec = 0 ) {
						var args = [{ expr : eindex, pos : pos }, evar];
						var name = switch( t ) {
						case TBool, TNull, TTexture(_): throw "assert";
						case TInt: "Int";
						case TFloat: "Float";
						case TFloat2, TFloat3, TFloat4:
							args.push( { expr : EConst(CInt(Tools.floatSize(v.type) + "")), pos : pos } );
							"Floats";
						case TMatrix(r, c, t):
							args.push( { expr : EConst(CInt(r + "")), pos : pos } );
							args.push( { expr : EConst(CInt(c + "")), pos : pos } );
							if( t.t ) "MatrixT" else "Matrix";
						case TArray(t, size):
							var vi = "i" + rec, vk = "k" + rec;
							var ei = { expr : EConst(CIdent(vi)), pos : pos };
							var ek = { expr : EConst(CIdent(vk)), pos : pos };
							var esize = { expr : EConst(CInt(size + "")), pos : pos };
							var stride = Tools.regSize(t);
							var save = saveType(
								t,
								EBinop(OpAdd, { expr : eindex, pos : pos }, { expr : EBinop(OpMult, { expr : EConst(CIdent(vi)), pos : pos }, { expr : EConst(CInt(stride + "")), pos : pos } ), pos : pos } ),
								ek,
								rec + 1
							);
							return macro {
								for( $ei in 0...$esize ) {
									var $vk = $evar[$ei];
									if( $ek == null ) break;
									$save;
								}
							}
						}
						return { expr : ECall( { expr : EConst(CIdent("save" + name)), pos : pos }, args), pos : pos };
					}
					var save = saveType(v.type, EConst(CInt(v.index + "")), evar);
					switch( v.type ) {
					case TFloat, TInt:
						updates.push(save);
					default:
						updates.push(macro if( $evar != null ) { $save; $evar = null; });
					}
				}
				
				fields.push({
					name : "get_" + v.name,
					kind : FFun( {
						ret : t,
						params : [],
						args : [],
						expr : { expr : EBlock(get), pos : pos },
					}),
					pos : v.pos,
					access : [],
				});
				
			case VTexture:
				var t = realType(v.type, pos);
				var tid = { expr : EConst(CInt("" + texCount++)), pos : pos };
				
				fields.push( {
					name : v.name,
					kind : FProp("get","set",t),
					pos : pos,
					access : [APublic],
				});
				
				fields.push({
					name : "get_" + v.name,
					kind : FFun( {
						ret : t,
						params : [],
						args : [],
						expr : macro return allTextures[$tid],
					}),
					pos : v.pos,
					access : [AInline],
				});

				fields.push({
					name : "set_" + v.name,
					kind : FFun( {
						ret : t,
						params : [],
						args : [{ name : "v", type : t, opt : false }],
						expr : macro { allTextures[$tid] = v; return v; },
					}),
					pos : v.pos,
					access : [AInline],
				});
			
			case VInput, VVar, VOut:
				// skip
			default:
				Context.warning(v.name, pos);
				throw "assert";
			}
		}
		
		fields.push({
			name : "updateParams",
			kind : FFun( {
				ret : null,
				args : [],
				params : [],
				expr : { expr : EBlock(updates), pos : pos },
			}),
			access : [AOverride],
			pos : pos,
		});
		
		return fields;
	}
	
}
#end
