package hxsl;
using hxsl.Ast;

class WgslOut {

	static var KWD_LIST = ["alias","const","const_assert","continuing","diagnostic","enable","fn","let","loop","requires","struct"];
	static var KWDS = [for( k in KWD_LIST ) k => true];
	static var GLOBALS = {
		var m = new Map();
		for( g in hxsl.Ast.TGlobal.createAll() ) {
			var n = "" + g;
			n = n.charAt(0).toLowerCase() + n.substr(1);
			m.set(g, n);
		}
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
	var hasVarying : Bool;
	public var varNames : Map<Int,String>;
	public var paramsGroup : Int = 0;
	public var paramsBinding : Int = 0;
	public var globalsGroup : Int = 0;
	public var globalsBinding : Int = 0;

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
			add("i32");
		case TBytes(n):
			add('vec$n<ui32>');
		case TBool:
			add("bool");
		case TFloat:
			add("f32");
		case TString:
			add("string");
		case TVec(size, k):
			add('vec$size<');
			switch( k ) {
			case VFloat: add("f32");
			case VInt: add("i32");
			case VBool: add("bool");
			}
			add('>');
		case TMat2:
			add("mat2x2f");
		case TMat3:
			add("mat3x3f");
		case TMat4:
			add("mat4x4f");
		case TMat3x4:
			add("mat3x4f");
		case TSampler2D:
			add("Texture2D");
		case TSamplerCube:
			add("TextureCube");
		case TSampler2DArray:
			add("Texture2DArray");
		case TStruct(vl):
			add("struct { ");
			for( v in vl ) {
				addVar(v);
				add(";");
			}
			add(" }");
		case TFun(_):
			add("fn ");
		case TArray(t, size), TBuffer(t,size):
			add("array<");
			addType(t);
			add(",");
			switch( size ) {
			case SVar(v):
				ident(v);
			case SConst(v):
				add(v);
			}
			add(">");
		case TChannel(n):
			add("channel" + n);
		}
	}

	function addArraySize( size ) {
		add("[");
		switch( size ) {
		case SVar(v): ident(v);
		case SConst(n): add(n);
		}
		add("]");
	}

	function addVar( v : TVar ) {
		ident(v);
		add(" : ");
		addType(v.type);
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
		case TMeta(m,args,e):
			handleMeta(m, args, addValue, e, tabs);
		default:
			addExpr(e, tabs);
		}
	}

	function handleMeta( m, args : Array<Ast.Const>, callb, e, tabs ) {
		switch( [m, args] ) {
		default:
			callb(e,tabs);
		}
	}

	function addBlock( e : TExpr, tabs ) {
		if( e.e.match(TBlock(_)) )
			addExpr(e,tabs);
		else {
			add("{");
			addExpr(e,tabs);
			if( !isBlock(e) )
				add(";");
			add("}");
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
			var acc = varAccess.get(v.id);
			if( acc != null ) add(acc);
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
		case TVarDecl(v, { e : TArrayDecl(el) }):
			locals.set(v.id, v);
			for( i in 0...el.length ) {
				ident(v);
				add("[");
				add(i);
				add("] = ");
				addExpr(el[i], tabs);
				newLine(el[i]);
			}
		case TBinop(OpAssign,evar = { e : TVar(_) },{ e : TArrayDecl(el) }):
			for( i in 0...el.length ) {
				addExpr(evar, tabs);
				add("[");
				add(i);
				add("] = ");
				addExpr(el[i], tabs);
			}
		case TArrayDecl(el):
			add("{");
			var first = true;
			for( e in el ) {
				if( first ) first = false else add(", ");
				addValue(e,tabs);
			}
			add("}");
		case TBinop(op, e1, e2):
			switch( [op, e1.t, e2.t] ) {
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
			default: throw "assert"; // OpSpread for Haxe4.2+
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
			addBlock(eif, tabs);
			if( eelse != null ) {
				add(" else ");
				addBlock(eelse, tabs);
			}
		case TDiscard:
			add("discard");
		case TReturn(e):
			if( e == null )
				add("return _out");
			else {
				add("return ");
				addValue(e, tabs);
			}
		case TFor(v, it, loop):
			locals.set(v.id, v);
			switch( it.e ) {
			case TBinop(OpInterval, e1, e2):
				add("[loop] for(");
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
			add("[loop] do ");
			addBlock(loop,tabs);
			add(" while( ");
			addValue(e,tabs);
			add(" )");
		case TWhile(e, loop, _):
			add("[loop] while( ");
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
			switch( e.t ) {
			default:
				addValue(e, tabs);
				add("[");
				addValue(index, tabs);
				add("]");
			}
		case TMeta(m, args, e):
			handleMeta(m, args, addExpr, e, tabs);
		}
	}

	function varName( v : TVar ) {
		var n = varNames.get(v.id);
		if( n != null )
			return n;
		n = v.name;
		while( KWDS.exists(n) )
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
		case TIf(_,eif,eelse):
			return isBlock(eelse == null ? eif : eelse);
		case TBlock(_):
			return true;
		default:
			return false;
		}
	}

	function collectGlobals( m : Map<TGlobal,Bool>, e : TExpr ) {
		switch( e.e )  {
		case TGlobal(g): m.set(g,true);
		default: e.iter(collectGlobals.bind(m));
		}
	}

	function initVars( s : ShaderData ) {
		var index = 0;
		function declVar(prefix:String, v : TVar ) {
			add("\t");
			addVar(v);
			add(",\n");
			varAccess.set(v.id, prefix);
		}

		var foundGlobals = new Map();
		for( f in s.funs )
			collectGlobals(foundGlobals, f.expr);

		hasVarying = false;
		for( v in s.vars )
			if( v.kind == Var ) {
				hasVarying = true;
				break;
			}

		if( isVertex || hasVarying ) {
			add("struct s_input {\n");
			var index = 0;
			for( v in s.vars )
				if( v.kind == Input || (v.kind == Var && !isVertex) ) {
					add('@location(${index++}) ');
					declVar("_in.", v);
				}
			add("};\n\n");
		}

		add("struct s_output {\n");
		var index = 0;
		for( v in s.vars )
			if( v.kind == Output || (v.kind == Var && isVertex) ) {
				if( v.kind == Output && isVertex )
					add('@builtin(position) ');
				else
					add('@location(${index++}) ');
				declVar("_out.", v);
			}
		add("};\n\n");
	}

	function initGlobals( s : ShaderData ) {
		var found = false;
		for( v in s.vars )
			if( v.kind == Global ) {
				found = true;
				break;
			}
		if( !found )
			return;

		for( v in s.vars )
			if( v.kind == Global ) {
				add('@group(${globalsGroup}) @binding(${globalsBinding}) var<uniform> ');
				addVar(v);
				add(";\n");
			}
	}

	function initParams( s : ShaderData ) {
		var found = false;
		for( v in s.vars )
			if( v.kind == Param ) {
				found = true;
				break;
			}
		if( !found )
			return;

		var textures = [];
		var buffers = [];
		for( v in s.vars )
			if( v.kind == Param ) {
				switch( v.type ) {
				case TArray(t, _) if( t.isSampler() ):
					textures.push(v);
					continue;
				case TBuffer(_):
					buffers.push(v);
					continue;
				default:
					if( v.type.isSampler() ) {
						textures.push(v);
						continue;
					}
				}
				add('@group($paramsGroup) @binding($paramsBinding) var<uniform> ');
				addVar(v);
				add(";\n");
			}

		var bufCount = 0;
		for( b in buffers ) {
			add('cbuffer _buffer$bufCount { ');
			addVar(b);
			add("; };\n");
			bufCount++;
		}
		if( bufCount > 0 ) add("\n");

		var texCount = 0;
		for( v in textures ) {
			addVar(v);
			add(' : register(t${texCount});\n');
			switch( v.type ) {
			case TArray(_,SConst(n)): texCount += n;
			default: texCount++;
			}
		}
	}

	function initStatics( s : ShaderData ) {
		if( isVertex || hasVarying )
			add("var<private> _in : s_input;\n");
		add("var<private> _out : s_output;\n");

		add("\n");
		for( v in s.vars )
			if( v.kind == Local ) {
				add("var<private> ");
				addVar(v);
				add(";\n");
			}
		add("\n");
	}

	function emitMain( s : ShaderData, expr : TExpr ) {
		add(isVertex ? "@vertex " : "@fragment ");
		if( isVertex || hasVarying ) {
			add("fn main( in__ : s_input ) -> s_output {\n");
			add("\t_in = in__;\n");
		} else {
			add("fn main() -> s_output {\n");
		}
		switch( expr.e ) {
		case TBlock(el):
			for( e in el ) {
				add("\t");
				addExpr(e, "\t");
				newLine(e);
			}
		default:
			addExpr(expr, "");
		}
		add("\treturn _out;\n");
		add("}");
	}

	function initLocals() {
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
		initVars(s);
		initGlobals(s);
		initParams(s);
		initStatics(s);

		var tmp = buf;
		buf = new StringBuf();
		emitMain(s, f.expr);
		exprValues.push(buf.toString());
		buf = tmp;

		initLocals();

		decls.push(buf.toString());
		buf = null;
		return decls.join("\n");
	}

}
