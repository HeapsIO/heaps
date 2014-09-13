package hxsl;
using hxsl.Ast;

class Printer {

	var buffer : StringBuf;
	var varId : Bool;

	public function new(varId = false) {
		this.varId = varId;
	}

	inline function add(v:Dynamic) {
		buffer.add(v);
	}

	public function shaderString( s : ShaderData ) {
		buffer = new StringBuf();
		for( v in s.vars ) {
			addVar(v, Var);
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
		addVar(v, null);
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

	function addVar( v : TVar, defKind : VarKind, tabs = "", ?parent ) {
		if( v.qualifiers != null ) {
			for( q in v.qualifiers )
				add("@" + (switch( q ) {
				case Const(max): "const" + (max == null ? "" : "("+max+")");
				case Private: "private";
				case Nullable: "nullable";
				case PerObject: "perObject";
				case Name(n): "name('" + n + "')";
				case Shared: "shared";
				case Precision(p): Std.string(p).toLowerCase() + "p";
				}) + " ");
		}
		if( v.kind != defKind )
			switch( v.kind ) {
			case Local:
				add("@local ");
			case Global:
				add("@global ");
			case Var:
				add("@var ");
			case Param:
				add("@param ");
			case Input:
				add("@input ");
			case Function:
				add("@function ");
			case Output:
				add("@output ");
			}
		add("var ");
		if( v.parent == parent )
			add(v.name + (varId?"@" + v.id:""));
		else
			addVarName(v);
		add(" : ");
		switch( v.type ) {
		case TStruct(vl):
			add("{");
			var first = true;
			for( v in vl ) {
				if( first ) first = false else add(", ");
				addVar(v,v.kind,tabs,v);
			}
			add("}");
		default:
			add(v.type.toString());
		}
	}

	function addFun( f : TFunction ) {
		add("function " + f.ref.name + "(");
		var first = true;
		for( a in f.args ) {
			if( first ) {
				add(" ");
				first = false;
			} else
				add(", ");
			addVar(a, Local);
		}
		if( f.args.length > 0 ) add(" ");
		add(") : "+f.ret.toString()+" ");
		addExpr(f.expr,"");
	}

	function addVarName( v : TVar ) {
		if( v.parent != null ) {
			addVarName(v.parent);
			add(".");
		}
		add(v.name);
		if( varId )
			add("@" + v.id);
	}

	function addExpr( e : TExpr, tabs : String ) : Void {
		switch( e.e ) {
		case TVar(v):
			addVarName(v);
		case TVarDecl(v, init):
			addVar(v, Local, tabs);
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
			add(switch( op ) {
			case OpNot:"!";
			case OpNeg:"-";
			case OpNegBits:"~";
			case OpIncrement:"++";
			case OpDecrement:"--";
			});
			addExpr(e, tabs);
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
		case TArrayDecl(el):
			add("[");
			var first = true;
			for( e in el ) {
				if( first ) first = false else add(", ");
				addExpr(e,tabs);
			}
			add("]");
		}
	}

	public static function opStr( op : Ast.Binop ) {
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

	public static function toString( e : TExpr, varId = false ) {
		return new Printer(varId).exprString(e);
	}

	public static function shaderToString( s : ShaderData, varId = false ) {
		return new Printer(varId).shaderString(s);
	}

}