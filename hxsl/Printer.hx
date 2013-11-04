package hxsl;
using hxsl.Ast;

class Printer {
	
	var buffer : StringBuf;

	public function new() {
	}
	
	inline function add(v:Dynamic) {
		buffer.add(v);
	}
	
	public function shaderString( s : ShaderData ) {
		buffer = new StringBuf();
		for( v in s.vars ) {
			addVar(v, true);
			add(";\n");
		}
		if( s.vars.length > 0 )
			add("\n");
		for( f in s.funs ) {
			addFun(f);
			add("\n\n");
		}
		return buffer.toString();
	}
	
	public function varString( v : TVar ) {
		buffer = new StringBuf();
		addVar(v);
		return buffer.toString();
	}

	public function funString( f : TFunction ) {
		buffer = new StringBuf();
		addFun(f);
		return buffer.toString();
	}

	public function exprString( e : TExpr ) {
		buffer = new StringBuf();
		addExpr(e,"");
		return buffer.toString();
	}

	function addVar( v : TVar, isDecl = false, tabs = "" ) {
		if( v.qualifiers != null ) {
			for( q in v.qualifiers )
				add("@" + (switch( q ) {
				case Const: "const";
				case Private: "private";
				case Nullable: "nullable";
				case Name(n): "name('" + n + "')";
				}) + " ");
		}
		switch( v.kind ) {
		case Local:
			if( isDecl ) add("@local ");
		case Global:
			add("@global ");
		case Var:
			if( !isDecl ) add("@var ");
		case Param:
			add("@param ");
		case Input:
			add("@input ");
		}
		add("var " + v.name + " : " + v.type.toString());
	}
	
	function addFun( f : TFunction ) {
		add("function " + f.name + "(");
		var first = true;
		for( a in f.args ) {
			if( first ) {
				add(" ");
				first = false;
			} else
				add(", ");
			addVar(a);
		}
		if( f.args.length > 0 ) add(" ");
		add(") : "+f.ret.toString()+" ");
		addExpr(f.expr,"");
	}
	
	function addExpr( e : TExpr, tabs : String ) : Void {
		switch( e.e ) {
		case TVar(v):
			add(v.name);
		case TVarDecl(v, init):
			addVar(v, false, tabs);
			if( init != null ) {
				add(" = ");
				addExpr(init, tabs);
			}
		case TSwiz(e, regs):
			addExpr(e,tabs);
			add(".");
			for( r in regs )
				add(Std.string(r).toLowerCase());
		case TReturn(e):
			add("return");
			if( e != null ) {
				add(" ");
				addExpr(e,tabs);
			}
		case TIf(cond, eif, eelse):
			add("if( ");
			addExpr(cond, tabs);
			add(" ) ");
			addExpr(eif,tabs);
			if( eelse != null ) {
				add(" else ");
				addExpr(eelse,tabs);
			}
		case TGlobal(g):
			add(g.toString());
		case TCall(e, el):
			addExpr(e, tabs);
			add("(");
			var first = true;
			for( e in el ) {
				if( first ) first = false else add(", ");
				addExpr(e, tabs);
			}
			add(")");
		case TFunVar(f):
			add(f.name);
		case TFor(v, it, loop):
			add("for( " + v.name + " in ");
			addExpr(it, tabs);
			add(") ");
			addExpr(loop, tabs);
		case TContinue:
			add("continue");
		case TBreak:
			add("break");
		case TDiscard:
			add("discard");
		case TBlock(el):
			add("{");
			tabs += "\t";
			for( e in el ) {
				add("\n" + tabs);
				addExpr(e,tabs);
				add(";");
			}
			tabs = tabs.substr(1);
			if( el.length > 0 )
				add("\n" + tabs);
			add("}");
		case TUnop(op, e):
			(switch( op ) {
			case OpNot:"!";
			case OpNeg:"-";
			case OpNegBits:"~";
			case OpIncrement:"++";
			case OpDecrement:"--";
			}) + addExpr(e, tabs);
		case TBinop(op, e1, e2):
			addExpr(e1, tabs);
			add(" "+opStr(op)+" ");
			addExpr(e2, tabs);
		case TArray(e1, e2):
			addExpr(e1,tabs);
			add("[");
			addExpr(e2, tabs);
			add("]");
		case TParenthesis(e):
			add("(");
			addExpr(e, tabs);
			add(")");
		case TConst(c):
			add(switch(c) {
			case CNull: "null";
			case CBool(b): b;
			case CInt(i): i;
			case CFloat(f): f;
			case CString(s): '"' + s + '"';
			});
		}
	}
	
	function opStr( op : Ast.Binop ) {
		return switch(op) {
		case OpAdd:"+";
		case OpSub:"-";
		case OpMult:"*";
		case OpDiv:"/";
		case OpMod:"%";
		case OpEq:"==";
		case OpNotEq:"!=";
		case OpGt:">";
		case OpLt:"<";
		case OpGte:">=";
		case OpLte:"<=";
		case OpXor:"^";
		case OpOr:"|";
		case OpAnd:"&";
		case OpShl:"<<";
		case OpShr:">>";
		case OpUShr:">>>";
		case OpBoolAnd:"&&";
		case OpBoolOr:"||";
		case OpAssign:"=";
		case OpAssignOp(op):opStr(op) + "=";
		case OpArrow:"=>";
		case OpInterval:"...";
		}
	}

	public static function toString( e : TExpr ) {
		return new Printer().exprString(e);
	}

	public static function shaderToString( s : ShaderData ) {
		return new Printer().shaderString(s);
	}
	
}