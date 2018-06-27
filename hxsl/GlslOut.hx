package hxsl;
import hxsl.Ast;

class GlslOut {

	static var KWD_LIST = [
		"input", "output", "discard",
		"dvec2", "dvec3", "dvec4", "hvec2", "hvec3", "hvec4", "fvec2", "fvec3", "fvec4",
		"int", "float", "bool", "long", "short", "double", "half", "fixed", "unsigned", "superp",
		"lowp", "mediump", "highp", "precision", "invariant", "discard",
		"struct", "asm", "union", "template", "this", "packed", "goto", "sizeof","namespace",
		"noline", "volatile", "external", "flat", "input", "output",
		"out","attribute","const","uniform","varying","inout","void",
	];
	static var KWDS = [for( k in KWD_LIST ) k => true];
	static var GLOBALS = {
		var m = new Map();
		for( g in hxsl.Ast.TGlobal.createAll() ) {
			var n = "" + g;
			n = n.charAt(0).toLowerCase() + n.substr(1);
			m.set(g, n);
		}
		m.set(ToInt, "int");
		m.set(ToFloat, "float");
		m.set(ToBool, "bool");
		m.set(LReflect, "reflect");
		m.set(Mat3x4, "_mat3x4");
		for( g in m )
			KWDS.set(g, true);
		m;
	};
	static var MAT34 = "struct _mat3x4 { vec4 a; vec4 b; vec4 c; };";

	var buf : StringBuf;
	var exprIds = 0;
	var exprValues : Array<String>;
	var locals : Map<Int,TVar>;
	var decls : Array<String>;
	var isVertex : Bool;
	var allNames : Map<String, Int>;
	var outIndexes : Map<Int, Int>;
	var intelDriverFix : Bool;
	var isES(get,never) : Bool;
	var isES2(get,never) : Bool;
	var uniformBuffer : Int = 0;
	public var varNames : Map<Int,String>;
	public var flipY : Bool;
	public var glES : Null<Float>;
	public var version : Null<Int>;

	public function new() {
		varNames = new Map();
		allNames = new Map();
		flipY = true;
	}

	inline function get_isES() return glES != null;
	inline function get_isES2() return glES != null && glES <= 2;

	inline function add( v : Dynamic ) {
		buf.add(v);
	}

	inline function ident( v : TVar ) {
		add(varName(v));
	}

	function decl( s : String ) {
		for( d in decls )
			if( d == s ) return;
		if( s.charCodeAt(0) == '#'.code )
			decls.unshift(s);
		else
			decls.push(s);
	}

	function addType( t : Type ) {
		switch( t ) {
		case TVoid:
			add("void");
		case TInt:
			add("int");
		case TBytes(n):
			add("vec");
			add(n);
		case TBool:
			add("bool");
		case TFloat:
			add("float");
		case TString:
			add("string");
		case TVec(size, k):
			switch( k ) {
			case VFloat:
			case VInt: add("i");
			case VBool: add("b");
			}
			add("vec");
			add(size);
		case TMat3:
			add("mat3");
		case TMat4:
			add("mat4");
		case TMat3x4:
			decl(MAT34);
			add("_mat3x4");
		case TSampler2D:
			add("sampler2D");
		case TSampler2DArray:
			add("sampler2DArray");
			if( isES )
				decl("precision lowp sampler2DArray;");
		case TSamplerCube:
			add("samplerCube");
		case TStruct(vl):
			add("struct { ");
			for( v in vl ) {
				addVar(v);
				add(";");
			}
			add(" }");
		case TFun(_):
			add("function");
		case TArray(t, size):
			addType(t);
			add("[");
			switch( size ) {
			case SVar(v):
				ident(v);
			case SConst(1) if( intelDriverFix ):
				add(2);
			case SConst(v):
				add(v);
			}
			add("]");
		case TBuffer(_):
			throw "assert";
		case TChannel(n):
			add("channel" + n);
		}
	}

	function addVar( v : TVar ) {
		switch( v.type ) {
		case TArray(t, size):
			var old = v.type;
			v.type = t;
			addVar(v);
			v.type = old;
			add("[");
			switch( size ) {
			case SVar(v): ident(v);
			case SConst(1) if( intelDriverFix ): add(2);
			case SConst(n): add(n);
			}
			add("]");
		case TBuffer(t, size):
			add("uniform_buffer"+(uniformBuffer++));
			add(" { ");
			v.type = TArray(t,size);
			addVar(v);
			v.type = TBuffer(t,size);
			add("; }");
		default:
			addType(v.type);
			add(" ");
			ident(v);
		}
	}

	function addValue( e : TExpr, tabs : String ) {
		switch( e.e ) {
		case TBlock(el):
			var name = "val" + (exprIds++);
			var tmp = buf;
			buf = new StringBuf();
			addType(e.t);
			add(" ");
			add(name);
			add("(void)");
			var el2 = el.copy();
			var last = el2[el2.length - 1];
			el2[el2.length - 1] = { e : TReturn(last), t : e.t, p : last.p };
			var e2 = {
				t : TVoid,
				e : TBlock(el2),
				p : e.p,
			};
			addExpr(e2, "");
			exprValues.push(buf.toString());
			buf = tmp;
			add(name);
			add("()");
		case TIf(econd, eif, eelse):
			add("( ");
			addValue(econd, tabs);
			add(" ) ? ");
			addValue(eif, tabs);
			add(" : ");
			addValue(eelse, tabs);
		case TMeta(_, _, e):
			addValue(e, tabs);
		default:
			addExpr(e, tabs);
		}
	}

	function addBlock( e : TExpr, tabs : String ) {
		addExpr(e, tabs);
	}

	function getFunName( g : TGlobal, args : Array<TExpr>, rt : Type ) {
		switch( g ) {
		case Mat3x4:
			decl(MAT34);
		case DFdx, DFdy, Fwidth:
			decl("#extension GL_OES_standard_derivatives:enable");
		case Pack:
			decl("vec4 pack( float v ) { vec4 color = fract(v * vec4(1, 255, 255.*255., 255.*255.*255.)); return color - color.yzww * vec4(1. / 255., 1. / 255., 1. / 255., 0.); }");
		case Unpack:
			decl("float unpack( vec4 color ) { return dot(color,vec4(1., 1. / 255., 1. / (255. * 255.), 1. / (255. * 255. * 255.))); }");
		case PackNormal:
			decl("vec4 packNormal( vec3 v ) { return vec4((v + vec3(1.)) * vec3(0.5),1.); }");
		case UnpackNormal:
			decl("vec3 unpackNormal( vec4 v ) { return normalize((v.xyz - vec3(0.5)) * vec3(2.)); }");
		case Texture:
			switch( args[0].t ) {
			case TSampler2D, TSampler2DArray, TChannel(_) if( !flipY ):
				if( isES2 )
					return "texture2D";
			case TSampler2D, TChannel(_):
				// convert S/T (bottom left) to U/V (top left)
				// we don't use 1. because of pixel rounding (fixes artifacts in blur)
				decl('vec4 _texture2D( sampler2D t, vec2 v ) { return ${isES2?"texture2D":"texture"}(t,vec2(v.x,0.999999-v.y)); }');
				return "_texture2D";
			case TSampler2DArray:
				decl('vec4 _texture2DArr( sampler2DArray t, vec3 v ) { return texture(t,vec3(v.x,0.999999-v.y,v.z)); }');
				return "_texture2DArr";
			case TSamplerCube:
				if( isES2 )
					return "textureCube";
			default:
				throw "assert";
			}
		case TextureLod:
			switch( args[0].t ) {
			case TSampler2D, TSampler2DArray, TChannel(_) if( !flipY ):
				if( isES2 ) {
					decl("#extension GL_EXT_shader_texture_lod : enable");
					return "texture2DLodEXT";
				}
			case TSampler2D, TChannel(_):
				var tlod = isES2 ? "texture2DLod" : "textureLod";
				decl('vec4 _texture2DLod( sampler2D t, vec2 v, float lod ) { return $tlod(t,vec2(v.x,0.999999-v.y)); }');
				return "_texture2DLod";
			case TSampler2DArray:
				decl('vec4 _texture2DArrLod( sampler2DArray t, vec3 v, float lod ) { return textureLod(t,vec3(v.x,0.999999-v.y,v.z)); }');
				return "_texture2DArrLod";
			case TSamplerCube:
				if( isES2 ) {
					decl("#extension GL_EXT_shader_texture_lod : enable");
					return "textureCubeLodEXT";
				}
			default:
				throw "assert";
			}
		case Mod if( rt == TInt && isES ):
			decl("int _imod( int x, int y ) { return int(mod(float(x),float(y))); }");
			return "_imod";
		case Mat3 if( args[0].t == TMat3x4 ):
			decl(MAT34);
			decl("mat3 _mat3( _mat3x4 v ) { return mat3(v.a.xyz,v.b.xyz,v.c.xyz); }");
			return "_mat3";
		default:
		}
		return GLOBALS.get(g);
	}

	function addExpr( e : TExpr, tabs : String ) {
		switch( e.e ) {
		case TConst(c):
			switch( c ) {
			case CInt(v): add(v);
			case CFloat(f):
				var str = "" + f;
				add(str);
				if( str.indexOf(".") == -1 && str.indexOf("e") == -1 )
					add(".");
			case CString(v): add('"' + v + '"');
			case CNull: add("null");
			case CBool(b): add(b);
			}
		case TVar(v):
			ident(v);
		case TGlobal(g):
			add(GLOBALS.get(g));
		case TParenthesis(e):
			add("(");
			addValue(e,tabs);
			add(")");
		case TBlock(el):
			add("{\n");
			var t2 = tabs + "\t";
			for( e in el ) {
				add(t2);
				addExpr(e, t2);
				newLine(e);
			}
			add(tabs);
			add("}");
		case TBinop(op, e1, e2):
			switch( [op, e1.t, e2.t] ) {
			case [OpAssignOp(OpMult) | OpMult, TVec(3,VFloat), TMat3x4]:
				decl(MAT34);
				decl("vec3 m3x4mult( vec3 v, _mat3x4 m) { vec4 ve = vec4(v,1.0); return vec3(dot(m.a,ve),dot(m.b,ve),dot(m.c,ve)); }");
				if( op.match(OpAssignOp(_)) ) {
					addValue(e1, tabs);
					add(" = ");
				}
				add("m3x4mult(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpAssignOp(OpMod) | OpMod, _, _]:
				if( op.match(OpAssignOp(_)) ) {
					addValue(e1, tabs);
					add(" = ");
				}
				addExpr({ e : TCall({ e : TGlobal(Mod), t : TFun([]), p : e.p }, [e1, e2]), t : e.t, p : e.p }, tabs);
			case [OpUShr, _, _]:
				decl("int _ushr( int i, int j ) { return int(uint(i) >> uint(j)); }");
				add("_ushr(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpEq | OpNotEq | OpLt | OpGt | OpLte | OpGte, TVec(n, _), TVec(_)]:
				add("vec" + n + "(");
				add(switch( op ) {
				case OpEq: "equal";
				case OpNotEq: "notEqual";
				case OpLt: "lessThan";
				case OpGt: "greaterThan";
				case OpLte: "lessThanEqual";
				case OpGte: "greaterThanEqual";
				default: throw "assert";
				});
				add("(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add("))");
			default:
				addValue(e1, tabs);
				add(" ");
				add(Printer.opStr(op));
				add(" ");
				addValue(e2, tabs);
			}
		case TUnop(op, e1):
			add(switch(op) {
			case OpNot: "!";
			case OpNeg: "-";
			case OpIncrement: "++";
			case OpDecrement: "--";
			case OpNegBits: "~";
			});
			addValue(e1, tabs);
		case TVarDecl(v, init):
			locals.set(v.id, v);
			if( init != null ) {
				ident(v);
				add(" = ");
				addValue(init, tabs);
			} else {
				add("/*var*/");
			}
		case TCall( { e : TGlobal(Saturate) }, [e]):
			add("clamp(");
			addValue(e, tabs);
			add(", 0., 1.)");
		case TCall(v, args):
			switch( v.e ) {
			case TGlobal(g):
				add(getFunName(g,args, e.t));
			default:
				addValue(v, tabs);
			}
			add("(");
			var first = true;
			for( e in args ) {
				if( first ) first = false else add(", ");
				addValue(e, tabs);
			}
			add(")");
		case TSwiz(e, regs):
			switch( e.t ) {
			case TFloat:
				for( r in regs ) if( r != X ) throw "assert";
				switch( regs.length ) {
				case 1:
					addValue(e, tabs);
				case 2:
					decl("vec2 _vec2( float v ) { return vec2(v,v); }");
					add("_vec2(");
					addValue(e, tabs);
					add(")");
				case 3:
					decl("vec3 _vec3( float v ) { return vec3(v,v,v); }");
					add("_vec3(");
					addValue(e, tabs);
					add(")");
				case 4:
					decl("vec4 _vec4( float v ) { return vec4(v,v,v,v); }");
					add("_vec4(");
					addValue(e, tabs);
					add(")");
				default:
					throw "assert";
				}
			default:
				addValue(e, tabs);
				add(".");
				for( r in regs )
					add(switch(r) {
					case X: "x";
					case Y: "y";
					case Z: "z";
					case W: "w";
					});
			}
		case TIf(econd, eif, eelse):
			add("if( ");
			addValue(econd, tabs);
			add(") ");
			addExpr(eif, tabs);
			if( eelse != null ) {
				if( !isBlock(eif) ) add(";");
				add(" else ");
				addExpr(eelse, tabs);
			}
		case TDiscard:
			add("discard");
		case TReturn(e):
			if( e == null )
				add("return");
			else {
				add("return ");
				addValue(e, tabs);
			}
		case TFor(v, it, loop):
			locals.set(v.id, v);
			switch( it.e ) {
			case TBinop(OpInterval, e1, e2):
				add("for(");
				add(v.name+"=");
				addValue(e1,tabs);
				add(";"+v.name+"<");
				addValue(e2,tabs);
				add(";" + v.name+"++) ");
				addBlock(loop, tabs);
			default:
				throw "assert";
			}
		case TWhile(e, loop, false):
			var old = tabs;
			tabs += "\t";
			add("do ");
			addBlock(loop,tabs);
			add(" while( ");
			addValue(e,tabs);
			add(" )");
		case TWhile(e, loop, _):
			add("while( ");
			addValue(e, tabs);
			add(" ) ");
			addBlock(loop,tabs);
		case TSwitch(_):
			add("switch(...)");
		case TContinue:
			add("continue");
		case TBreak:
			add("break");
		case TArray(e, index):
			addValue(e, tabs);
			add("[");
			addValue(index, tabs);
			add("]");
		case TArrayDecl(el):
			add("[");
			var first = true;
			for( e in el ) {
				if( first ) first = false else add(", ");
				addValue(e,tabs);
			}
			add("]");
		case TMeta(_, _, e):
			addExpr(e, tabs);
		}
	}

	function varName( v : TVar ) {
		if( v.kind == Output ) {
			if( isVertex )
				return "gl_Position";
			if( isES2 ) {
				if( outIndexes == null )
					return "gl_FragColor";
				return 'gl_FragData[${outIndexes.get(v.id)}]';
			}
		}
		var n = varNames.get(v.id);
		if( n != null )
			return n;
		n = v.name;
		if( KWDS.exists(n) )
			n = "_" + n;
		if( allNames.exists(n) ) {
			var k = 2;
			n += "_";
			while( allNames.exists(n + k) )
				k++;
			n += k;
		}
		varNames.set(v.id, n);
		allNames.set(n, v.id);
		return n;
	}

	function newLine( e : TExpr ) {
		if( isBlock(e) )
			add("\n");
		else
			add(";\n");
	}

	function isBlock( e : TExpr ) {
		switch( e.e ) {
		case TFor(_, _, loop), TWhile(_,loop,true):
			return isBlock(loop);
		case TBlock(_):
			return true;
		default:
			return false;
		}
	}

	public function run( s : ShaderData ) {
		locals = new Map();
		decls = [];
		buf = new StringBuf();
		exprValues = [];

		/*
			Intel HD driver fix:
				single element arrays are interpreted as not arrays, creating mismatch when
				handling uniforms/textures. The fix changes decl[1] into decl[2] with one unused element

				This fix is only for desktop, WebGL has errors with Cube Textures if there's
				both Texture2D and TextureCube arrays in shader.
				Also disable it for third party GL implementations (consoles)
		*/
		#if !(usegl || js)
		intelDriverFix = true;
		#end

		decl("precision mediump float;");

		if( s.funs.length != 1 ) throw "assert";
		var f = s.funs[0];
		isVertex = f.kind == Vertex;

		var outIndex = 0;
		uniformBuffer = 0;
		outIndexes = new Map();
		for( v in s.vars ) {
			switch( v.kind ) {
			case Param, Global:
				if( v.type.match(TBuffer(_)) )
					add("layout(std140) ");
				add("uniform ");
			case Input:
				add( isES2 ? "attribute " : "in ");
			case Var:
				add( isES2 ? "varying " : (isVertex ? "out " : "in "));
			case Output:
				if( isES2 ) {
					outIndexes.set(v.id, outIndex++);
					continue;
				}
				if( isVertex ) continue;
				if( isES )
					add('layout(location=${outIndex++}) ');
				add("out ");
			case Function:
				continue;
			case Local:
			}
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case Precision(p):
						switch( p ) {
						case Low: add("lowp ");
						case Medium: add("mediump ");
						case High: add("highp ");
						}
					default:
					}
			addVar(v);
			add(";\n");
		}
		add("\n");

		if( outIndex < 2 )
			outIndexes = null;
		else if( !isVertex && isES2 )
			decl("#extension GL_EXT_draw_buffers : enable");

		var tmp = buf;
		buf = new StringBuf();
		add("void main(void) {\n");
		switch( f.expr.e ) {
		case TBlock(el):
			for( e in el ) {
				add("\t");
				addExpr(e, "\t");
				newLine(e);
			}
		default:
			addExpr(f.expr, "");
		}
		add("}");
		exprValues.push(buf.toString());
		buf = tmp;

		var locals = Lambda.array(locals);
		locals.sort(function(v1, v2) return Reflect.compare(v1.name, v2.name));
		for( v in locals ) {
			addVar(v);
			add(";\n");
		}
		add("\n");

		for( e in exprValues ) {
			add(e);
			add("\n\n");
		}

		if( isES )
			decl("#version "+version+(version > 150 ? " es" : ""))
		else if( version != null )
			decl("#version " + (version > 150 ? 150 : version));
		else
			decl("#version 130"); // OpenGL 3.0

		decls.push(buf.toString());
		buf = null;
		return decls.join("\n");
	}

	public static function compile( s : ShaderData ) {
		var out = new GlslOut();
		#if js
		out.glES = 1;
		out.version = 100;
		#end
		return out.run(s);
	}

}
