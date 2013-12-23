package hxsl;
import hxsl.Ast;

class GlslOut {

	var buf : StringBuf;
	var keywords : Map<String,Bool>;
	var exprValues : Array<String>;
	var locals : Array<TVar>;
	var globalNames : Map<TGlobal,String>;
	
	public function new() {
		keywords = [ "input" => true, "output" => true, "discard" => true ];
		globalNames = new Map();
		for( g in hxsl.Ast.TGlobal.createAll() ) {
			var n = "" + g;
			n = n.charAt(0).toLowerCase() + n.substr(1);
			globalNames.set(g, n);
		}
	}
	
	inline function add( v : Dynamic ) {
		buf.add(v);
	}
	
	function ident( i : String ) {
		add(keywords.exists(i) ? "_" + i : i);
	}
	
	function addType( t : Type ) {
		switch( t ) {
		case TVoid:
			add("void");
		case TInt:
			add("int");
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
				ident(v.name);
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
			case SVar(v): ident(v.name);
			case SConst(n): add(n);
			}
			add("]");
		default:
			addType(v.type);
			add(" ");
			ident(v.name);
		}
	}
	
	function addValue( e : TExpr, tabs : String ) {
		switch( e.e ) {
		case TBlock(el):
			var name = "val" + exprValues.length;
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
			ident(v.name);
		case TGlobal(g):
			add(globalNames.get(g));
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
			case [OpMult, TMat3x4, TVec(3,VFloat)]:
				add("m3x4mult(");
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
			locals.push(v);
			if( init != null ) {
				ident(v.name);
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
	
	public function run( s : ShaderData ) {
		locals = [];
		buf = new StringBuf();
		exprValues = [];
		add("precision mediump float;\n");
		add("struct mat3x4 { vec4 a; vec4 b; vec4 c; };\n");
		add("vec3 m3x4mult( mat3x4 m, vec3 v ) { vec4 ve = vec4(v,1.0); return vec3(dot(m.a,ve),dot(m.b,ve),dot(m.c,ve)); }\n");

		if( s.funs.length != 1 ) throw "assert";
		var f = s.funs[0];
		
		for( v in s.vars ) {
			switch( v.kind ) {
			case Param, Global:
				add("uniform ");
			case Input:
				add("attribute ");
			case Var:
				add("varying ");
			case Function: continue;
			case Output:
				switch( f.kind ) {
				case Vertex:
					v.name = "gl_Position";
				case Fragment:
					v.name = "gl_FragColor";
				default:
					throw "assert";
				}
				continue;
			case Local:
			}
			addVar(v);
			add(";\n");
		}
		add("\n");
		
		var tmp = buf;
		buf = new StringBuf();
		add("void main(void) ");
		addExpr(f.expr, "");
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
		var content = buf.toString();
		buf = null;
		return content;
	}
	
	public static function toGlsl( s : ShaderData ) {
		return new GlslOut().run(s);
	}
	
}