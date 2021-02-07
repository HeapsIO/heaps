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
	TBytes( size : Int );
	TSampler2D;
	TSampler2DArray;
	TSamplerCube;
	TStruct( vl : Array<TVar> );
	TFun( variants : Array<FunType> );
	TArray( t : Type, size : SizeDecl );
	TBuffer( t : Type, size : SizeDecl );
	TChannel( size : Int );
	TMat2;
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

	public function toString() {
		return "Error(" + msg + ")@" + pos;
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
	Output;
	Function;
}

enum VarQualifier {
	Const( ?max : Int );
	Private;
	Nullable;
	PerObject;
	Name( n : String );
	Shared;
	Precision( p : Prec );
	Range( min : Float, max : Float );
	Ignore; // the variable is ignored in reflection (inspector)
	PerInstance( v : Int );
	Doc( s : String );
	Borrow( source : String );
	Sampler( name : String );
}

enum Prec {
	Low;
	Medium;
	High;
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
	EArrayDecl( el : Array<Expr> );
	ESwitch( e : Expr, cases : Array<{ values : Array<Expr>, expr:Expr }>, def : Null<Expr> );
	EWhile( cond : Expr, loop : Expr, normalWhile : Bool );
	EMeta( name : String, args : Array<Expr>, e : Expr );
}

typedef TVar = {
	var id : Int;
	var name : String;
	var type : Type;
	var kind : VarKind;
	@:optional var parent : TVar;
	@:optional var qualifiers : Null<Array<VarQualifier>>;
}

typedef TFunction = {
	var kind : FunctionKind;
	var ref : TVar;
	var args : Array<TVar>;
	var ret : Type;
	var expr : TExpr;
}

enum FunctionKind {
	Vertex;
	Fragment;
	Init;
	Helper;
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
	Clamp;
	Mix;
	Step;
	Smoothstep;
	Length;
	Distance;
	Dot;
	Cross;
	Normalize;
	//Faceforward;
	LReflect;
	//Refract;
	//MatrixCompMult;
	//Any;
	//All;
	Texture;
	TextureLod;
	Texel;
	TextureSize;
	// ...other texture* operations
	// constructors
	ToInt;
	ToFloat;
	ToBool;
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
	Pack;
	Unpack;
	PackNormal;
	UnpackNormal;
	ScreenToUv;
	UvToScreen;
	// extensions
	DFdx;
	DFdy;
	Fwidth;
	// debug / internal
	ChannelRead;
	ChannelReadLod;
	ChannelFetch;
	ChannelTextureSize;
	Trace;
	// instancing
	VertexID;
	InstanceID;
	// gl globals
	FragCoord;
	FrontFacing;
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
	TArrayDecl( el : Array<TExpr> );
	TSwitch( e : TExpr, cases : Array<{ values : Array<TExpr>, expr:TExpr }>, def : Null<TExpr> );
	TWhile( e : TExpr, loop : TExpr, normalWhile : Bool );
	TMeta( m : String, args : Array<Const>, e : TExpr );
}

typedef TExpr = { e : TExprDef, t : Type, p : Position }

typedef ShaderData = {
	var name : String;
	var vars : Array<TVar>;
	var funs : Array<TFunction>;
}

class Tools {

	static var UID = 0;

	public static var SWIZ = Component.createAll();
	public static var MAX_CHANNELS_BITS = 3;

	public static function allocVarId() {
		// in order to prevent compile time ids to conflict with runtime allocated ones
		// let's use negative numbers for compile time ones
		#if macro
		return --UID;
		#else
		return ++UID;
		#end
	}

	public static function getName( v : TVar ) {
		if( v.qualifiers == null )
			return v.name;
		for( q in v.qualifiers )
			switch( q ) {
			case Name(n): return n;
			default:
			}
		return v.name;
	}

	public static function getDoc( v : TVar ) {
		if ( v.qualifiers == null )
			return null;
		for ( q in v.qualifiers )
			switch ( q ) {
			case Doc(s): return s;
			default:
			}
		return null;
	}

	public static function getConstBits( v : TVar ) {
		switch( v.type ) {
		case TBool:
			return 1;
		case TInt:
			for( q in v.qualifiers )
				switch( q ) {
				case Const(n):
					if( n != null ) {
						var bits = 0;
						while( n >= 1 << bits )
							bits++;
						return bits;
					}
					return 8;
				default:
				}
		case TChannel(_):
			return 3 + MAX_CHANNELS_BITS;
		default:
		}
		return 0;
	}

	public static function isConst( v : TVar ) {
		if( v.type.match(TChannel(_)) )
			return true;
		if( v.qualifiers != null )
			for( q in v.qualifiers )
				switch( q ) {
				case Const(_): return true;
				default:
				}
		return false;
	}

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

	public static function hasBorrowQualifier( v : TVar, path : String ) {
		if ( v.qualifiers != null )
			for( q in v.qualifiers )
				switch (q) {
					case Borrow(s): return path == s;
					default:
				}
		return false;
	}

	public static function isSampler( t : Type ) {
		return switch( t ) {
		case TSampler2D, TSamplerCube, TSampler2DArray, TChannel(_):
			true;
		default:
			false;
		}
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
		case TBuffer(t, s): "buffer "+toString(t) + "[" + (switch( s ) { case SConst(i): "" + i; case SVar(v): v.name; } ) + "]";
		case TBytes(n): "Bytes" + n;
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

	public static function hasSideEffect( e : TExpr ) {
		switch( e.e ) {
		case TParenthesis(e):
			return hasSideEffect(e);
		case TBlock(el), TArrayDecl(el):
			for( e in el )
				if( hasSideEffect(e) )
					return true;
			return false;
		case TBinop(OpAssign | OpAssignOp(_), _, _):
			return true;
		case TBinop(_, e1, e2):
			return hasSideEffect(e1) || hasSideEffect(e2);
		case TUnop(_, e1):
			return hasSideEffect(e1);
		case TSwiz(e, _):
			return hasSideEffect(e);
		case TIf(econd, eif, eelse):
			return hasSideEffect(econd) || hasSideEffect(eif) || (eelse != null && hasSideEffect(eelse));
		case TFor(_, it, loop):
			return hasSideEffect(it) || hasSideEffect(loop);
		case TArray(e, index):
			return hasSideEffect(e) || hasSideEffect(index);
		case TConst(_), TVar(_), TGlobal(_):
			return false;
		case TCall(e, pl):
			if( !e.e.match(TGlobal(_)) )
				return true;
			for( p in pl )
				if( hasSideEffect(p) )
					return true;
			return false;
		case TVarDecl(_), TDiscard, TContinue, TBreak, TReturn(_):
			return true;
		case TSwitch(e, cases, def):
			for( c in cases ) {
				for( v in c.values ) if( hasSideEffect(v) ) return true;
				if( hasSideEffect(c.expr) ) return true;
			}
			return hasSideEffect(e) || (def != null && hasSideEffect(def));
		case TWhile(e, loop, _):
			return hasSideEffect(e) || hasSideEffect(loop);
		case TMeta(_, _, e):
			return hasSideEffect(e);
		}
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
		case TArrayDecl(el): for( e in el ) f(e);
		case TSwitch(e, cases, def):
			f(e);
			for( c in cases ) {
				for( v in c.values ) f(v);
				f(c.expr);
			}
			if( def != null ) f(def);
		case TWhile(e, loop, _):
			f(e);
			f(loop);
		case TConst(_), TVar(_), TGlobal(_), TDiscard, TContinue, TBreak:
		case TMeta(_, _, e): f(e);
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
		case TArray(e, index): TArray(f(e), f(index));
		case TArrayDecl(el): TArrayDecl([for( e in el ) f(e)]);
		case TSwitch(e, cases, def): TSwitch(f(e), [for( c in cases ) { values : [for( v in c.values ) f(v)], expr : f(c.expr) }], def == null ? null : f(def));
		case TWhile(e, loop, normalWhile): TWhile(f(e), f(loop), normalWhile);
		case TConst(_), TVar(_), TGlobal(_), TDiscard, TContinue, TBreak: e.e;
		case TMeta(m, args, e): TMeta(m, args, f(e)); // don't map args
		}
		return { e : ed, t : e.t, p : e.p };
	}

	public static function size( t : Type ) {
		return switch( t ) {
		case TVoid: 0;
		case TFloat, TInt: 1;
		case TVec(n, _), TChannel(n): n;
		case TStruct(vl):
			var s = 0;
			for( v in vl ) s += size(v.type);
			return s;
		case TMat2: 4;
		case TMat3: 9;
		case TMat4: 16;
		case TMat3x4: 12;
		case TBytes(s): s;
		case TBool, TString, TSampler2D, TSampler2DArray, TSamplerCube, TFun(_): 0;
		case TArray(t, SConst(v)), TBuffer(t, SConst(v)): size(t) * v;
		case TArray(_, SVar(_)), TBuffer(_): 0;
		}
	}

	#if !macro
	public static function evalConst( e : TExpr ) : Dynamic {
		return switch( e.e ) {
		case TConst(c):
			switch( c ) {
			case CNull: null;
			case CBool(b): b;
			case CInt(i): i;
			case CFloat(f): f;
			case CString(s): s;
			}
		case TCall({ e : TGlobal(Vec2 | Vec3 | Vec4) }, args):
			var vals = [for( a in args ) evalConst(a)];
			if( vals.length == 1 )
				return new Types.Vec(vals[0], vals[0], vals[0], vals[0]);
			return new Types.Vec(vals[0], vals[1], vals[2], vals[3]);
		default:
			throw "Unhandled constant init " + Printer.toString(e);
		}
	}
	#end

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
