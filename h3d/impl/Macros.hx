package h3d.impl;
import haxe.macro.Context;
import haxe.macro.Expr;
import format.hxsl.Data;

class Macros {

	static function realType( t : VarType, p : Position ) : ComplexType {
		return TPath(switch( t ) {
		case TFloat: { pack : [], name : "Float", params : [], sub : null };
		case TFloat2, TFloat3, TFloat4: { pack : ["h3d"], name : "Vector", params : [], sub : null };
		case TInt: { pack : [], name : "Int", params : [], sub : null };
		case TMatrix(_): { pack : ["h3d"], name: "Matrix", params : [], sub : null };
		case TTexture(cube): { pack : ["flash","display3D","textures"], name : cube ? "CubeTexture" : "Texture", params : [], sub : null };
		case TArray(t, size): { pack : ["h3d"], name : "Shader", sub : "FixedArray", params : [TPType(realType(t,p)), TPExpr( { expr : EConst(CInt(""+size)), pos : p } )] };
		});
	}

	static function makeShaderVars( shader : Code, fields : Array<Field> ) {
		var pos = 0;
		var fset = shader.vertex ? "data.vertexVars" : "data.fragmentVars";
		for( c in shader.args.concat(shader.tex) ) {
			var set = [];
			var old = pos;
			function add(e) {
				set.push(fset + "[" + pos + "]=" + e + ";");
				pos++;
			}
			function addType(n:String,t:VarType) {
				switch( t ) {
				case TFloat:
					add(n);
					add(n);
					add(n);
					add(n);
				case TFloat2:
					add(n + ".x");
					add(n + ".y");
					add("1.");
					add("1.");
				case TFloat3:
					add(n + ".x");
					add(n + ".y");
					add(n + ".z");
					add("1.");
				case TFloat4:
					add(n + ".x");
					add(n + ".y");
					add(n + ".z");
					add(n + ".w");
				case TMatrix(w,h,t):
					for( y in 1...w+1 )
						for( x in 1...h+1 ) {
							if( t.t )
								add(n+"._"+x+y);
							else
								add(n+"._"+y+x);
						}
				case TTexture(_):
					set.push("data.textures[" + c.index + "] = " + n + ";");
					set.push("data.texturesChanged = true;");
				case TInt:
					add("((" + n + ">>16) & 0xFF) / 255.0");
					add("((" + n + ">>8) & 0xFF) / 255.0");
					add("(" + n + " & 0xFF) / 255.0");
					add("(" + n + ">>>24) / 255.0");
				case TArray(t, count):
					var old = pos;
					set.push("for( _i in 0..." + count + " ) {");
					addType(n + "[_i]", t);
					set.push("}");
					pos += (pos - old) * (count - 1);
				}
			}
			addType(c.name, c.type);
			if( pos > old )
				set.push(fset + "Changed=true;");
			set.push("return " + c.name + ";");
			
			var t = realType(c.type,c.pos);
			fields.push( {
				name : c.name,
				access : [APublic],
				kind : FProp("null", "set_" + c.name, t),
				pos : c.pos,
			});
			fields.push( {
				name : "set_" + c.name,
				access : [APrivate],
				kind : FFun( {
					params : [],
					args : [ { name : c.name, type : t, opt : false, value : null } ],
					ret : t,
					expr : Context.parse("{"+set.join("")+"}",c.pos),
				}),
				pos : c.pos,
			});
		}
		var cst = [];
		for( i in 0...pos )
			cst.push("0.");
		for( c in shader.consts ) {
			for( i in 0...4 ) {
				var v = c[i];
				if( v == null ) v = "0";
				cst.push(v);
			}
		}
		return cst;
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
		if( shaderCode == null )
			Context.error("Shader SRC not found", cl.pos);
		
		var p = new format.hxsl.Parser();
		p.includeFile = function(file) {
			var f = Context.resolvePath(file);
			return Context.parse("{"+neko.io.File.getContent(f)+"}", Context.makePosition( { min : 0, max : 0, file : f } ));
		};
		var v = try p.parse(shaderCode) catch( e : format.hxsl.Data.Error ) haxe.macro.Context.error(e.message, e.pos);
		var c = new format.hxsl.Compiler();
		c.warn = Context.warning;
		var v = try c.compile(v) catch( e : format.hxsl.Data.Error ) haxe.macro.Context.error(e.message, e.pos);

		var c = new format.agal.Compiler();
		c.error = Context.error;

		var vscode = c.compile(v.vertex);
		var fscode = c.compile(v.fragment);

		var o = new haxe.io.BytesOutput();
		new format.agal.Writer(o).write(vscode);
		var vsbytes = haxe.Serializer.run(o.getBytes());

		var o = new haxe.io.BytesOutput();
		new format.agal.Writer(o).write(fscode);
		var fsbytes = haxe.Serializer.run(o.getBytes());
		
		var max = 200;
		if( vscode.code.length > max )
			Context.error("This vertex shader uses " + vscode.code.length + " opcodes but only " + max + " are allowed by Flash11", v.vertex.pos);
		if( fscode.code.length > max )
			Context.error("This fragment shader uses " + fscode.code.length + " opcodes but only " + max + " are allowed by Flash11", v.fragment.pos);
	
		var stride = 0;
		var fmt = 0;
		var pos = 0;
		for( i in v.input ) {
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
		
		return fields;
	}
	
}