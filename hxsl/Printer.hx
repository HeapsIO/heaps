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
			addVar(v, null);
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
				case Precision(p): p.getName().toLowerCase() + "p";
				case Range(min, max): "range(" + min + "," + max + ")";
				case Ignore: "ignore";
				case PerInstance(n): "perInstance("+n+")";
				case Doc(s): "doc(\"" + StringTools.replace(s, '"', '\\"') + "\")";
				case Borrow(s): "borrow(" + s + ")";
				case Sampler(s): "sampler("+ s + ")";
				}) + " ");
		}
		if( v.kind != defKind )
			switch( v.kind ) {
			case Local:
				add("@local ");
			case Global:
				add("@global ");
			case Var:
				add("@varying ");
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

	static var SWIZ = ["x", "y", "z", "w"];

	function addConst( c : Const ) {
		add(switch(c) {
		case CNull: "null";
		case CBool(b): b;
		case CInt(i): i;
		case CFloat(f): f;
		case CString(s): '"' + s + '"';
		});
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
				add(SWIZ[r.getIndex()]);
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
			add("for( ");
			addVarName(v);
			add(" in ");
			addExpr(it, tabs);
			add(" ) ");
			addExpr(loop, tabs);
		case TSwitch(e, cases, def):
			add("switch( ");
			addExpr(e, tabs);
			add(") {");
			var old = tabs;
			for( c in cases ) {
				add("\n" + tabs);
				add("case ");
				var first = true;
				for( v in c.values ) {
					if( first ) first = false else add(", ");
					addExpr(v, tabs);
				}
				tabs += "\t";
				add(":\n"+tabs);
				addExpr(c.expr, tabs);
				tabs = old;
			}
			if( def != null ) {
				add("\n" + tabs);
				tabs += "\t";
				add("default:\n" + tabs);
				addExpr(def, tabs);
				tabs = old;
			}
			add("\n" + tabs + "}");
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
			default: throw "assert"; // OpSpread for Haxe4.2+
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
			addConst(c);
		case TArrayDecl(el):
			add("[");
			var first = true;
			for( e in el ) {
				if( first ) first = false else add(", ");
				addExpr(e,tabs);
			}
			add("]");
		case TWhile(e, loop, false):
			var old = tabs;
			tabs += "\t";
			add("do {\n" + tabs);
			addExpr(loop,tabs);
			tabs = old;
			add("\n" + tabs + "} while( ");
			addExpr(e,tabs);
			add(" )");
		case TWhile(e, loop, _):
			add("while( ");
			addExpr(e, tabs);
			var old = tabs;
			tabs += "\t";
			add(" ) {\n" + tabs);
			addExpr(loop,tabs);
			tabs = old;
			add("\n" + tabs + "}");
		case TMeta(m, args, e):
			add("@");
			add(m);
			if( args.length > 0 ) {
				add("(");
				var first = true;
				for( c in args ) {
					if( first ) first = false else add(", ");
					addConst(c);
				}
				add(")");
			}
			add(" ");
			addExpr(e, tabs);
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
		#if (haxe_ver >= 4)
		case OpIn: " in ";
		#end
		}
	}

	public static function toString( e : TExpr, varId = false ) {
		return new Printer(varId).exprString(e);
	}

	public static function shaderToString( s : ShaderData, varId = false ) {
		return new Printer(varId).shaderString(s);
	}

	public static function check( s : ShaderData, ?from : Array<ShaderData> ) {
		try {
			var vars = new Map();
			var regVars = [];
			function regVar( v : TVar, reg ) {
				if( reg ) {
					if( vars.exists(v.id) ) throw "Duplicate var " + v.id;
					vars.set(v.id, v);
					regVars.push(v);
				}
				else
					vars.remove(v.id);
				switch( v.type ) {
				case TStruct(vl):
					for( v in vl )
						regVar(v, reg);
				default:
				}
			}
			function checkExpr( e : TExpr ) {
				switch( e.e ) {
				case TVar(v):
					if( !vars.exists(v.id) ) throw "Unbound var " + v.name+"@" + v.id;
				case TVarDecl(v, init):
					if( init != null ) checkExpr(init);
					regVar(v, true);
				case TBlock(el):
					var old = regVars;
					regVars = [];
					for( e in el )
						checkExpr(e);
					for( v in regVars )
						regVar(v, false);
					regVars = old;
				case TFor(v, it, loop):
					checkExpr(it);
					regVar(v, true);
					checkExpr(loop);
					regVar(v, false);
				default:
					Tools.iter(e, checkExpr);
				}
			}
			for( v in s.vars )
				regVar(v, true);
			for( f in s.funs ) {
				for( v in f.args )
					regVar(v, true);
				checkExpr(f.expr);
				for( v in f.args )
					regVar(v, false);
			}
		} catch( e : String ) {
			var msg = e+"\n    in\n" + shaderToString(s, true);
			if( from != null )
				msg += "\n    from\n\n" + [for( s in from ) shaderToString(s, true)].join("\n\n");
			throw msg;
		}
	}

}