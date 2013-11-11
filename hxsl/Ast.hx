package hxsl;

enum Type {
	TVoid;
	TInt;
	TBool;
	TFloat;
	TString;
	TVec( size : Int, t : VecType );
	TMat3;
	TMat4;
	TMat3x4;
	TSampler2D;
	TSamplerCube;
	TStruct( vl : Array<TVar> );
	TFun( variants : Array<FunType> );
	TArray( t : Type, size : SizeDecl );
}

enum VecType {
	VInt;
	VFloat;
	VBool;
}

enum SizeDecl {
	SConst( v : Int );
	SVar( v : TVar );
}

typedef FunType = { args : Array<{ name : String, type : Type }>, ret : Type };

class Error {
	
	public var msg : String;
	public var pos : Position;
	
	public function new( msg, pos ) {
		this.msg = msg;
		this.pos = pos;
	}
	
	public static function t( msg : String, pos : Position ) : Dynamic {
		throw new Error(msg, pos);
		return null;
	}
}

typedef Position = haxe.macro.Expr.Position;

typedef Expr = { expr : ExprDef, pos : Position };

typedef Binop = haxe.macro.Expr.Binop;
typedef Unop = haxe.macro.Expr.Unop;

enum VarKind {
	Global;
	Input;
	Param;
	Var;
	Local;
}

enum VarQualifier {
	Const;
	Private;
	Nullable;
	Name( n : String );
}

typedef VarDecl = {
	var name : String;
	var type : Null<Type>;
	var kind : Null<VarKind>;
	var qualifiers : Array<VarQualifier>;
	var expr : Null<Expr>;
}

typedef FunDecl = {
	var name : String;
	var args : Array<VarDecl>;
	var ret : Null<Type>;
	var expr : Expr;
}

enum Const {
	CNull;
	CBool( b : Bool );
	CInt( v : Int );
	CFloat( v : Float );
	CString( v : String );
}

enum ExprDef {
 	EConst( c : Const );
	EIdent( i : String );
	EParenthesis( e : Expr );
	EField( e : Expr, f : String );
	EBinop( op : Binop, e1 : Expr, e2 : Expr );
	EUnop( op : Unop, e1 : Expr );
	ECall( e : Expr, args : Array<Expr> );
	EBlock( el : Array<Expr> );
	EVars( v : Array<VarDecl> );
	EFunction( f : FunDecl );
	EIf( econd : Expr, eif : Expr, eelse : Null<Expr> );
	EDiscard;
	EFor( v : String, loop : Expr, block : Expr );
	EReturn( ?e : Expr );
	EBreak;
	EContinue;
	EArray( e : Expr, eindex : Expr );
}

typedef TVar = {
	var name : String;
	var type : Type;
	var kind : VarKind;
	@:optional var parent : TVar;
	@:optional var qualifiers : Null<Array<VarQualifier>>;
}

typedef TFunction = {
	var name : String;
	var args : Array<TVar>;
	var ret : Type;
	var expr : TExpr;
}

enum TGlobal {
	Radians;
	Degrees;
	Sin;
	Cos;
	Tan;
	Asin;
	Acos;
	Atan;
	Pow;
	Exp;
	Log;
	Exp2;
	Log2;
	Sqrt;
	Inversesqrt;
	Abs;
	Sign;
	Floor;
	Ceil;
	Fract;
	Mod;
	Min;
	Max;
	//Clamp;
	//Mix;
	//Step;
	//SmoothStep;
	Length;
	Distance;
	Dot;
	Cross;
	Normalize;
	//Faceforward;
	//Reflect;
	//Refract;
	//MatrixCompMult;
	//Any;
	//All;
	Texture2D;
	TextureCube;
	// ...other texture* operations
	// constructors
	Vec2;
	Vec3;
	Vec4;
	IVec2;
	IVec3;
	IVec4;
	BVec2;
	BVec3;
	BVec4;
	Mat2;
	Mat3;
	Mat4;
	// extra (not in GLSL ES)
	Mat3x4;
	Saturate;
}

enum Component {
	X;
	Y;
	Z;
	W;
}

enum TExprDef {
	TConst( c : Const );
	TVar( v : TVar );
	TFunVar( f : TFunction );
	TGlobal( g : TGlobal );
	TParenthesis( e : TExpr );
	TBlock( el : Array<TExpr> );
	TBinop( op : Binop, e1 : TExpr, e2 : TExpr );
	TUnop( op : Unop, e1 : TExpr );
	TVarDecl( v : TVar, ?init : TExpr );
	TCall( e : TExpr, args : Array<TExpr> );
	TSwiz( e : TExpr, regs : Array<Component> );
	TIf( econd : TExpr, eif : TExpr, eelse : Null<TExpr> );
	TDiscard;
	TReturn( ?e : TExpr );
	TFor( v : TVar, it : TExpr, loop : TExpr );
	TContinue;
	TBreak;
	TArray( e : TExpr, index : TExpr );
}

typedef TExpr = { e : TExprDef, t : Type, p : Position }

typedef ShaderData = {
	var vars : Array<TVar>;
	var funs : Array<TFunction>;
}

class Tools {
	
	public static function isStruct( v : TVar ) {
		return switch( v.type ) { case TStruct(_): true; default: false; }
	}

	public static function isArray( v : TVar ) {
		return switch( v.type ) { case TArray(_): true; default: false; }
	}

	public static function hasQualifier( v : TVar, q ) {
		if( v.qualifiers != null )
			for( q2 in v.qualifiers )
				if( q2 == q )
					return true;
		return false;
	}

	public static function toString( t : Type ) {
		return switch( t ) {
		case TVec(size, t):
			var prefix = switch( t ) {
			case VFloat: "";
			case VInt: "I";
			case VBool: "B";
			}
			prefix + "Vec" + size;
		case TStruct(vl):"{" + [for( v in vl ) v.name + " : " + toString(v.type)].join(",") + "}";
		case TArray(t, s): toString(t) + "[" + (switch( s ) { case SConst(i): "" + i; case SVar(v): v.name; } ) + "]";
		default: t.getName().substr(1);
		}
	}

	public static function toType( t : VecType ) {
		return switch( t ) {
		case VFloat: TFloat;
		case VBool: TBool;
		case VInt: TInt;
		};
	}
	
	public static function iter( e : TExpr, f : TExpr -> Void ) {
		switch( e.e ) {
		case TParenthesis(e): f(e);
		case TBlock(el): for( e in el ) f(e);
		case TBinop(_, e1, e2): f(e1); f(e2);
		case TUnop(_, e1): f(e1);
		case TVarDecl(_,init): if( init != null ) f(init);
		case TCall(e, args): f(e); for( a in args ) f(a);
		case TSwiz(e, _): f(e);
		case TIf(econd, eif, eelse): f(econd); f(eif); if( eelse != null ) f(eelse);
		case TReturn(e): if( e != null ) f(e);
		case TFor(_, it, loop): f(it); f(loop);
		case TArray(e, index): f(e); f(index);
		case TConst(_),TVar(_),TFunVar(_), TGlobal(_), TDiscard, TContinue, TBreak:
		}
	}

	public static function map( e : TExpr, f : TExpr -> TExpr ) : TExpr {
		var ed = switch( e.e ) {
		case TParenthesis(e): TParenthesis(f(e));
		case TBlock(el): TBlock([for( e in el ) f(e)]);
		case TBinop(op, e1, e2): TBinop(op, f(e1), f(e2));
		case TUnop(op, e1): TUnop(op, f(e1));
		case TVarDecl(v,init): TVarDecl(v, if( init != null ) f(init) else null);
		case TCall(e, args): TCall(f(e),[for( a in args ) f(a)]);
		case TSwiz(e, c): TSwiz(f(e), c);
		case TIf(econd, eif, eelse): TIf(f(econd),f(eif),if( eelse != null ) f(eelse) else null);
		case TReturn(e): TReturn(if( e != null ) f(e) else null);
		case TFor(v, it, loop): TFor(v, f(it), f(loop));
		case TArray(e, index): TArray(f(e),f(index));
		case TConst(_), TVar(_), TFunVar(_), TGlobal(_), TDiscard, TContinue, TBreak: e.e;
		}
		return { e : ed, t : e.t, p : e.p };
	}

}

class Tools2 {

	public static function toString( g : TGlobal ) {
		var n = g.getName();
		return n.charAt(0).toLowerCase() + n.substr(1);
	}

}

class Tools3 {

	public static function toString( s : ShaderData ) {
		return Printer.shaderToString(s);
	}

}

class Tools4 {

	public static function toString( e : TExpr ) {
		return Printer.toString(e);
	}

}