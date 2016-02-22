package hxsl;
import hxsl.Ast;

class GlslOut {

	static var KWD_LIST = [
		"input", "output", "discard",
		"dvec2", "dvec3", "dvec4",
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
		m.set(Texture2D, "_texture2D");
		m.set(LReflect, "reflect");
		for( g in m )
			KWDS.set(g, true);
		m;
	};
	static var MAT34 = "struct mat3x4 { vec4 a; vec4 b; vec4 c; };";

	var buf : StringBuf;
	var exprIds = 0;
	var exprValues : Array<String>;
	var locals : Map<Int,TVar>;
	var decls : Array<String>;
	var isVertex : Bool;
	var allNames : Map<String, Int>;
	public var varNames : Map<Int,String>;
	public var flipY : Bool;

	public function new() {
		varNames = new Map();
		allNames = new Map();
		flipY = true;
	}

	inline function add( v : Dynamic ) {
		buf.add(v);
	}

	inline function ident( v : TVar ) {
		add(varName(v));
	}

	function decl( s : String ) {
		for( d in decls )
			if( d == s ) return;
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
			add("mat3x4");
		case TSampler2D:
			add("sampler2D");
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
			case SConst(v):
				add(v);
			}
			add("]");
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
			case SConst(n): add(n);
			}
			add("]");
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
		default:
			addExpr(e, tabs);
		}
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
			case Texture2D:
				// convert S/T (bottom left) to U/V (top left)
				// we don't use 1. because of pixel rounding (fixes artifacts in blur)
				decl("vec4 _texture2D( sampler2D t, vec2 v ) { return texture2D(t,vec2(v.x,"+(flipY?"0.999999-v.y":"v.y")+")); }");
			default:
			}
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
				add(";\n");
			}
			add(tabs);
			add("}");
		case TBinop(op, e1, e2):
			switch( [op, e1.t, e2.t] ) {
			case [OpMult, TVec(3,VFloat), TMat3x4]:
				decl(MAT34);
				decl("vec3 m3x4mult( vec3 v, mat3x4 m) { vec4 ve = vec4(v,1.0); return vec3(dot(m.a,ve),dot(m.b,ve),dot(m.c,ve)); }");
				add("m3x4mult(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpMod, _, _]:
				add("mod(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
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
		case TCall( { e : TGlobal(Mat3) }, [e]) if( e.t == TMat3x4 ):
			decl("mat3 _mat3( mat3x4 v ) { return mat3(v.a.xyz,v.b.xyz,v.c.xyz); }");
			add("_mat3(");
			addValue(e, tabs);
			add(")");
		case TCall( { e : TGlobal(Saturate) }, [e]):
			add("clamp(");
			addValue(e, tabs);
			add(", 0., 1.)");
		case TCall(e, args):
			addValue(e, tabs);
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
			add("for(...)");
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
		}
	}

	function varName( v : TVar ) {
		if( v.kind == Output )
			return isVertex ? "gl_Position" : "gl_FragColor";
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

	public function run( s : ShaderData ) {
		locals = new Map();
		decls = [];
		buf = new StringBuf();
		exprValues = [];
		decls.push("precision mediump float;");

		if( s.funs.length != 1 ) throw "assert";
		var f = s.funs[0];
		isVertex = f.kind == Vertex;

		for( v in s.vars ) {
			switch( v.kind ) {
			case Param, Global:
				add("uniform ");
			case Input:
				add("attribute ");
			case Var:
				add("varying ");
			case Function, Output: continue;
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

		var tmp = buf;
		buf = new StringBuf();
		add("void main(void) {\n");
		switch( f.expr.e ) {
		case TBlock(el):
			for( e in el ) {
				add("\t");
				addExpr(e, "\t");
				add(";\n");
			}
		default:
			addExpr(f.expr, "");
		}
		add("}");
		exprValues.push(buf.toString());
		buf = tmp;

		for( v in locals ) {
			addVar(v);
			add(";\n");
		}
		add("\n");

		for( e in exprValues ) {
			add(e);
			add("\n\n");
		}
		decls.push(buf.toString());
		buf = null;
		return decls.join("\n");
	}

	public static function toGlsl( s : ShaderData ) {
		return new GlslOut().run(s);
	}

}