package hxsl;

enum Type {
	TVoid;
	TInt;
	TBool;
	TFloat;
	TString;
	TVec2;
	TVec3;
	TVec4;
	TMat3;
	TMat4;
	TMat3x4;
	TSampler2D;
	TSamplerCube;
	TUntypedStruct( vl : Array<VarDecl> );
	TStruct( vl : Array<TVar> );
	TFun( variants : Array<FunType> );
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
}

typedef VarDecl = {
	var name : String;
	var type : Null<Type>;
	var kind : Null<VarKind>;
	var qualifiers : Array<VarQualifier>;
	var expr : Null<Expr>;
	@:optional var realName : Null<String>;
}

typedef FunDecl = {
	var name : String;
	var args : Array<VarDecl>;
	var ret : Null<Type>;
	var expr : Expr;
}

enum Const {
	CNull;
	CTrue;
	CFalse;
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
	Vec2;
	Vec3;
	Vec4;
	Mat3;
	Mat3x4;
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
}

typedef TExpr = { e : TExprDef, t : Type, p : Position }

typedef Shader = {
	var vars : Array<TVar>;
	var funs : Array<TFunction>;
}

class Tools {
	
	public static function isStruct( v : TVar ) {
		return switch( v.type ) { case TStruct(_): true; default: false; }
	}
	
	public static function toString( t : Type ) {
		return switch( t ) {
		case TUntypedStruct(vl): "{" + [for( v in vl ) v.name + " : " + toString(v.type)].join(",") + "}";
		case TStruct(vl):"{" + [for( v in vl ) v.name + " : " + toString(v.type)].join(",") + "}";
		default: t.getName().substr(1);
		}
	}

}

class Tools2 {

	public static function toString( g : TGlobal ) {
		var n = g.getName();
		return n.charAt(0).toLowerCase() + n.substr(1);
	}

}