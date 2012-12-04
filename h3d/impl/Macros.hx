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
		});
		
		// create all the variables accessors
		var allVars = data.globals.concat(data.vertex.args).concat(data.fragment.args);
		for( v in data.vertex.tex.concat(data.fragment.tex) )
			allVars.push(v);
		for( v in allVars ) {
			switch( v.kind ) {
			case VConst, VParam:
				fields.push( {
					name : v.name,
					kind : FProp("never", "set", realType(v.type, v.pos)),
					pos : v.pos,
					access : [APublic],
				});
				/*
				fields.push({
					name : "get_" + v.name,
					kind : FFun({
					}),
					pos : v.pos,
					access : [AInline],
				});
				fields.push( {
					name : "set_" + v.name,
					kind : FFun( {
						ret : null,
						params : [ { ]],
						expr :
					}),
					pos : v.pos,
					access : [AInline],
				});
				*/
			case VTexture:
				fields.push( {
					name : v.name,
					kind : FProp("never", "set", realType(v.type, v.pos)),
					pos : v.pos,
					access : [APublic],
				});
				/*
				fields.push( {
					name : "set_" + v.name,
					kind : FFun({
					}),
					pos : v.pos,
					access : [AInline],
				});
				*/
			case VInput, VVar, VOut:
				// skip
			default:
				Context.warning(v.name, v.pos);
				throw "assert";
			}
		}
		
		
		
		/*
		var stride = 0;
		var fmt = 0;
		var pos = 0;
		for( i in v ) {
			function add(size) {
				fmt |= size << (pos * 3);
				pos++;
				stride += size;
			}
			function addType(t:VarType) {
				switch( t ) {
				case TMatrix(r, c, t):
					if( t.t ) {
						var tmp = r;
						r = c;
						c = tmp;
					}
					for( i in 0...r )
						add(c);
				case TInt:
					add(0);
					stride++;
				case TFloat: add(1);
				case TFloat2: add(2);
				case TFloat3: add(3);
				case TFloat4: add(4);
				case TArray(t, size):
					for( i in 0...size )
						addType(t);
				case TTexture(_): throw "assert";
				}
			}
			addType(i.type);
		}
		var max = 8;
		if( pos > max )
			Context.error("This shader uses to many input components, only " + max + " are allowed by Flash11", v.vertex.pos);
		
		var vvars = makeShaderVars(v.vertex,fields);
		var fvars = makeShaderVars(v.fragment, fields);
		
		fields.push( {
			name : "getShaderInfos",
			pos : cl.pos,
			access : [APublic,AOverride],
			kind : FFun( {
				args : [],
				params : [],
				expr : Context.parse("return {stride:" + stride + ",format:"+fmt+",vertex:"+vvars+",fragment:"+fvars+",textures:"+v.fragment.tex.length+"}", cl.pos),
				ret : TPath({ sub : "ShaderInfos", name : "Shader", pack : ["h3d"], params : [] }),
			}),
		});
		
		var tbytes = TPath( { pack : ["haxe", "io"], name : "Bytes", params : [] } );
		fields.push( {
			name : "getVertexProgram",
			pos : cl.pos,
			access : [APublic, AOverride],
			kind : FFun( {
				args : [],
				params : [],
				expr : Context.parse("return haxe.Unserializer.run('" + vsbytes + "')", cl.pos),
				ret : tbytes,
			}),
		});
		fields.push( {
			name : "getFragmentProgram",
			pos : cl.pos,
			access : [APublic, AOverride],
			kind : FFun( {
				args : [],
				params : [],
				expr : Context.parse("return haxe.Unserializer.run('" + fsbytes + "')", cl.pos),
				ret : tbytes,
			}),
		});
		*/
		
		
		return fields;
	}
	
}
#end
