package hxsl;
import hxsl.Ast;

class HlslOut {

	static var KWD_LIST = [
		"s_input", "s_output", "_in", "_out", "in", "out", "mul",
	];
	static var KWDS = [for( k in KWD_LIST ) k => true];
	static var GLOBALS = {
		var m = new Map();
		for( g in hxsl.Ast.TGlobal.createAll() ) {
			var n = "" + g;
			n = n.charAt(0).toLowerCase() + n.substr(1);
			m.set(g, n);
		}
		m.set(ToInt, "(int)");
		m.set(ToFloat, "(float)");
		m.set(ToBool, "(bool)");
		m.set(Vec2, "float2");
		m.set(Vec3, "float3");
		m.set(Vec4, "float4");
		for( g in m )
			KWDS.set(g, true);
		m;
	};

	var buf : StringBuf;
	var exprIds = 0;
	var exprValues : Array<String>;
	var locals : Map<Int,TVar>;
	var decls : Array<String>;
	var isVertex : Bool;
	var allNames : Map<String, Int>;
	public var varNames : Map<Int,String>;

	var varAccess : Map<Int,String>;

	public function new() {
		varNames = new Map();
		allNames = new Map();
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
			case VFloat: add("float");
			case VInt: add("int");
			case VBool: add("bool");
			}
			add(size);
		case TMat3:
			add("float3x3");
		case TMat4:
			add("float4x4");
		case TMat3x4:
			add("float4x3");
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
			case SConst(1):
				add(2); // intel HD driver fix
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
			case SConst(1): add(2); // intel HD driver fix
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
			var acc = varAccess.get(v.id);
			if( acc != null ) add(acc);
			ident(v);
		case TGlobal(g):
			switch( g ) {
			case Mat3x4:
				// float4x3 constructor uses row-order, we want column order here
				decl("float4x3 mat3x4( float4 a, float4 b, float4 c ) { float4x3 m; m._m00_m10_m20_m30 = a; m._m01_m11_m21_m31 = b; m._m02_m12_m22_m32 = c; return m; }");
			case Mat4:
				decl("float4x4 mat4( float4 a, float4 b, float4 c, float4 d ) { float4x4 m; m._m00_m10_m20_m30 = a; m._m01_m11_m21_m31 = b; m._m02_m12_m22_m32 = c; m._m03_m13_m23_m33 = d; return m; }");
			case Mat3:
				decl("float3x3 mat3( float4x4 m ) { return (float3x3)m; }");
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
				newLine(e);
			}
			add(tabs);
			add("}");
		case TBinop(op, e1, e2):
			switch( [op, e1.t, e2.t] ) {
			case [OpAssignOp(OpMod) | OpMod, _, _]:
				if( op.match(OpAssignOp(_)) ) {
					addValue(e1, tabs);
					add(" = ");
				}
				add("mod(");
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
			case [OpMult, TVec(_), TMat3x4]:
				add("mul(float4(");
				addValue(e1, tabs);
				add(",1.),");
				addValue(e2, tabs);
				add(")");
			case [OpMult, TVec(_), TMat3 | TMat4]:
				add("mul(");
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
			addValue(e, tabs);
			add(".");
			for( r in regs )
				add(switch(r) {
				case X: "x";
				case Y: "y";
				case Z: "z";
				case W: "w";
				});
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

		if( s.funs.length != 1 ) throw "assert";
		var f = s.funs[0];
		isVertex = f.kind == Vertex;

		varAccess = new Map();

		add("struct s_input {\n");
		if( !isVertex )
			add("\tfloat4 __pos__ : SV_POSITION;\n");
		var index = 0;
		for( v in s.vars ) {
			if( v.kind == Input || (v.kind == Var && !isVertex) ) {
				add("\t");
				addVar(v);
				add(" : " + v.name);
				add(";\n");
				varAccess.set(v.id, "_in.");
			}
		}
		add("};\n\n");

		add("struct s_output {\n");
		var index = 0;
		for( v in s.vars ) {
			if( v.kind == Output || (v.kind == Var && isVertex) ) {
				add("\t");
				addVar(v);
				if( v.kind == Output )
					add(" : " + (isVertex ? "SV_POSITION" : "SV_TARGET" + (index++)));
				else
					add(" : " + v.name);
				add(";\n");
				varAccess.set(v.id, "_out.");
			}
		}
		add("};\n\n");

		add("cbuffer _globals : register(b0) {\n");
		for( v in s.vars )
			if( v.kind == Global ) {
				add("\t");
				addVar(v);
				add(";\n");
			}
		add("};\n\n");


		add("cbuffer _params : register(b1) {\n");
		for( v in s.vars )
			if( v.kind == Param ) {
				add("\t");
				addVar(v);
				add(";\n");
			}
		add("};\n\n");

		add("static s_input _in;\n");
		add("static s_output _out;\n");

		add("\n");
		for( v in s.vars )
			if( v.kind == Local ) {
				add("static ");
				addVar(v);
				add(";\n");
			}
		add("\n");

		var tmp = buf;
		buf = new StringBuf();
		add("s_output main( s_input __in ) {\n");
		add("\t_in = __in;\n");
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
		add("\treturn _out;\n");
		add("}");
		exprValues.push(buf.toString());
		buf = tmp;

		for( v in locals ) {
			add("static ");
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

}
