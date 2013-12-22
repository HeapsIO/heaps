package hxsl;
import hxsl.Ast;

class GlslOut {

	var buf : StringBuf;
	var prec : String;
	var keywords : Map<String,Bool>;
	var exprValues : Array<String>;
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
	
	public function run( s : ShaderData ) : { vertex : String, fragment : String } {
		return {
			vertex : make(s, "vertex"),
			fragment : make(s,"fragment"),
		};
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
			add(prec);
			add("float");
		case TString:
			add("string");
		case TVec(size, k):
			switch( k ) {
			case VFloat: add(prec);
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
				add(Printer.opStr(op));
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
			addVar(v);
			if( init != null ) {
				add(" = ");
				addValue(init, tabs);
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
	
	function make( s : ShaderData, func : String ) {
		prec = "mediump ";
		buf = new StringBuf();
		exprValues = [];
		add("struct mat3x4 { "+prec+"vec4 a; "+prec+"vec4 b; "+prec+"vec4 c; };\n");
		add(prec+"vec3 m3x4mult( mat3x4 m, "+prec+"vec3 v ) { "+prec+"vec4 ve = vec4(v,1.0); return vec3(dot(m.a,ve),dot(m.b,ve),dot(m.c,ve)); }\n");
		for( v in s.vars ) {
			switch( v.kind ) {
			case Param, Global:
				add("uniform ");
			case Input:
				if( func == "fragment" ) continue;
				add("attribute ");
			case Var:
				add("varying ");
			case Function: continue;
			case Local: throw "assert";
			}
			addVar(v);
			add(";\n");
		}
		add("\n");
		var found = false;
		for( f in s.funs ) {
			if( f.ref.name == func ) {
				var tmp = buf;
				buf = new StringBuf();
				found = true;
				add("void main(void) ");
				addExpr(f.expr, "");
				exprValues.push(buf.toString());
				buf = tmp;
			}
		}
		for( e in exprValues ) {
			add(e);
			add("\n\n");
		}
		if( !found ) throw func + " not found in shader";
		var content = buf.toString();
		buf = null;
		return content;
	}
	
	public static function toGlsl( s : ShaderData ) {
		return new GlslOut().run(s);
	}
	
}