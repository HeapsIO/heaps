package hxsl;
using hxsl.Ast;

class Samplers {

	public var count : Int;
	var named : Map<String, Int>;

	public function new() {
		count = 0;
		named = new Map();
	}

	public function make( v : TVar, arr : Array<Int> ) : Array<Int> {

		var ntex = switch( v.type ) {
		case TArray(t, SConst(k)) if( t.isTexture() ): k;
		case t if( t.isTexture() ): 1;
		default:
			return null;
		}

		var names = null;
		if( v.qualifiers != null ) {
			for( q in v.qualifiers ) {
				switch( q ) {
				case Sampler(nl): names = nl.split(",");
				default:
				}
			}
		}
		for( i in 0...ntex ) {
			if( names == null || names[i] == "" )
				arr.push(count++);
			else {
				var idx = named.get(names[i]);
				if( idx == null ) {
					idx = count++;
					named.set(names[i], idx);
				}
				arr.push(idx);
			}
		}
		return arr;
	}

}

class HlslOut {

	static var KWD_LIST = [
		"s_input", "s_output", "_in", "_out", "in", "out", "mul", "matrix", "vector", "export", "half", "half2", "half3", "half4", "float", "double", "line", "linear", "point", "precise",
		"sample" // pssl
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
		m.set(LReflect, "reflect");
		m.set(Fract, "frac");
		m.set(Mix, "lerp");
		m.set(Inversesqrt, "rsqrt");
		m.set(IVec2, "int2");
		m.set(IVec3, "int3");
		m.set(IVec4, "int4");
		m.set(BVec2, "bool2");
		m.set(BVec3, "bool3");
		m.set(BVec4, "bool4");
		m.set(FragCoord,"_in.__pos__");
		m.set(FloatBitsToInt, "asint");
		m.set(FloatBitsToUint, "asuint");
		m.set(IntBitsToFloat, "asfloat");
		m.set(UintBitsToFloat, "_uintBitsToFloat");
		m.set(RoundEven, "round");
		m.set(GroupMemoryBarrier, "GroupMemoryBarrier");
		for( g in m )
			KWDS.set(g, true);
		m;
	};

	var SV_POSITION = "SV_POSITION";
	var SV_TARGET = "SV_TARGET";
	var STATIC = "static ";
	var CONST = "const ";
	var buf : StringBuf;
	var exprIds = 0;
	var exprValues : Array<String>;
	var locals : Map<Int,TVar>;
	var decls : Array<String>;
	var kind : FunctionKind;
	var allNames : Map<String, Int>;
	var samplers : Map<Int, Array<Int>>;
	var computeLayout = [1,1,1];
	public var varNames : Map<Int,String>;
	public var baseRegister : Int = 0;

	var varAccess : Map<Int,String>;
	var isVertex(get,never) : Bool;
	var isCompute(get,never) : Bool;

	inline function get_isCompute() return kind == Main;
	inline function get_isVertex() return kind == Vertex;

	public function new() {
		varNames = new Map();
		allNames = new Map();
	}

	function getSVName( g : TGlobal ) {
		return switch( g ) {
		case VertexID: "SV_VertexID";
		case InstanceID: "SV_InstanceID";
		case FrontFacing: "SV_IsFrontFace";
		case ComputeVar_GlobalInvocation: "SV_DispatchThreadID";
		case ComputeVar_LocalInvocation: "SV_GroupThreadID";
		case ComputeVar_WorkGroup: "SV_GroupID";
		case ComputeVar_LocalInvocationIndex: "SV_GroupIndex";
		default: null;
		}
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
			add("uint"+n);
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
		case TMat2:
			add("float2x2");
		case TMat3:
			add("float3x3");
		case TMat4:
			add("float4x4");
		case TMat3x4:
			add("float4x3");
		case TSampler(_), TRWTexture(_):
			add(getTexType(t));
		case TStruct(vl):
			add("struct { ");
			for( v in vl ) {
				addVar(v);
				add(";");
			}
			add(" }");
		case TFun(_):
			add("function");
		case TArray(t, size), TBuffer(t,size,_):
			addType(t);
			addArraySize(size);
		case TChannel(n):
			add("channel" + n);
		}
	}

	function addArraySize( size ) {
		add("[");
		switch( size ) {
		case SVar(v): ident(v);
		case SConst(0):
		case SConst(n): add(n);
		}
		add("]");
	}

	function addVar( v : TVar ) {
		switch( v.type ) {
		case TArray(t, size), TBuffer(t,size,Uniform):
			addVar({
				id : v.id,
				name : v.name,
				type : t,
				kind : v.kind,
			});
			addArraySize(size);
		case TBuffer(t, size, Storage):
			add('StructuredBuffer<');
			addType(t);
			add('> ');
			ident(v);
		case TBuffer(t, size, RW):
			add('RWStructuredBuffer<');
			addType(t);
			add('> ');
			ident(v);
		default:
			addType(v.type);
			add(" ");
			ident(v);
		}
	}

	function addValue( e : TExpr, tabs : String ) {
		switch( e.e ) {
		case TBlock(el):
			var name = "_val" + (exprIds++);
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

	function declMods() {
		// unsigned mod like GLSL
		decl("float mod(float x, float y) { return x - y * floor(x/y); }");
		decl("float2 mod(float2 x, float2 y) { return x - y * floor(x/y); }");
		decl("float3 mod(float3 x, float3 y) { return x - y * floor(x/y); }");
		decl("float4 mod(float4 x, float4 y) { return x - y * floor(x/y); }");
	}

	function getTexType( t : Type ) {
		return switch( t ) {
		case TSampler(dim, arr): "Texture"+dim.getName().substr(1)+(arr?"Array":"");
		case TRWTexture(dim, arr, chans): "RWTexture"+dim.getName().substr(1)+(arr?"Array":"")+"<"+(chans==1?"float":"float"+chans)+">";
		default: throw "assert";
		}
	}

	function declGlobal( g : TGlobal, args : Array<TExpr> ) {
		switch( g ) {
		case Mat3x4:
			// float4x3 constructor uses row-order, we want column order here
			decl("float4x3 mat3x4( float4 a, float4 b, float4 c ) { float4x3 m; m._m00_m10_m20_m30 = a; m._m01_m11_m21_m31 = b; m._m02_m12_m22_m32 = c; return m; }");
			decl("float4x3 mat3x4( float4x4 m ) { float4x3 m2; m2._m00_m10_m20_m30 = m._m00_m10_m20_m30; m2._m01_m11_m21_m31 = m._m01_m11_m21_m31; m2._m02_m12_m22_m32 = m._m02_m12_m22_m32; return m2; }");
		case Mat4:
			decl("float4x4 mat4( float4 a, float4 b, float4 c, float4 d ) { float4x4 m; m._m00_m10_m20_m30 = a; m._m01_m11_m21_m31 = b; m._m02_m12_m22_m32 = c; m._m03_m13_m23_m33 = d; return m; }");
		case Mat3:
			decl("float3x3 mat3( float4x4 m ) { return (float3x3)m; }");
			decl("float3x3 mat3( float4x3 m ) { return (float3x3)m; }");
			decl("float3x3 mat3( float3 a, float3 b, float3 c ) { float3x3 m; m._m00_m10_m20 = a; m._m01_m11_m21 = b; m._m02_m12_m22 = c; return m; }");
			decl("float3x3 mat3( float c00, float c01, float c02, float c10, float c11, float c12, float c20, float c21, float c22 ) { float3x3 m = { c00, c10, c20, c01, c11, c21, c02, c12, c22 }; return m; }");
		case Mat2:
			decl("float2x2 mat2( float4x4 m ) { return (float2x2)m; }");
			decl("float2x2 mat2( float4x3 m ) { return (float2x2)m; }");
			decl("float2x2 mat2( float3x3 m ) { return (float2x2)m; }");
			decl("float2x2 mat2( float2 a, float2 b ) { float2x2 m; m._m00_m10 = a; m._m01_m11 = b; return m; }");
			decl("float2x2 mat2( float c00, float c01, float c10, float c11 ) { float2x2 m = { c00, c10, c01, c11 }; return m; }");
		case Mod:
			declMods();
		case Pow:
			// negative power might not work
			decl("#pragma warning(disable:3571)");
		case Pack:
			decl("float4 pack( float v ) { float4 color = frac(v * float4(1, 255, 255.*255., 255.*255.*255.)); return color - color.yzww * float4(1. / 255., 1. / 255., 1. / 255., 0.); }");
		case Unpack:
			decl("float unpack( float4 color ) { return dot(color,float4(1., 1. / 255., 1. / (255. * 255.), 1. / (255. * 255. * 255.))); }");
		case PackNormal:
			decl("float4 packNormal( float3 n ) { return float4((n + 1.) * 0.5,1.); }");
		case UnpackNormal:
			decl("float3 unpackNormal( float4 p ) { return normalize(p.xyz * 2. - 1.); }");
		case Atan:
			decl("float atan( float y, float x ) { return atan2(y,x); }");
		case ScreenToUv:
			decl("float2 screenToUv( float2 v ) { return v * float2(0.5, -0.5) + float2(0.5,0.5); }");
		case UvToScreen:
			decl("float2 uvToScreen( float2 v ) { return v * float2(2.,-2.) + float2(-1., 1.); }");
		case DFdx:
			decl("float dFdx( float v ) { return ddx(v); }");
			decl("float2 dFdx( float2 v ) { return ddx(v); }");
			decl("float3 dFdx( float3 v ) { return ddx(v); }");
		case DFdy:
			decl("float dFdy( float v ) { return ddy(v); }");
			decl("float2 dFdy( float2 v ) { return ddy(v); }");
			decl("float3 dFdy( float3 v ) { return ddy(v); }");
		case UintBitsToFloat:
			decl("float _uintBitsToFloat( int v ) { return asfloat(asuint(v)); }");
			decl("float2 _uintBitsToFloat( int2 v ) { return asfloat(asuint(v)); }");
			decl("float3 _uintBitsToFloat( int3 v ) { return asfloat(asuint(v)); }");
			decl("float4 _uintBitsToFloat( int4 v ) { return asfloat(asuint(v)); }");
		case AtomicAdd:
			decl("int atomicAdd( RWStructuredBuffer<int> buf, int index, int data ) { int val; InterlockedAdd(buf[index], data, val); return val; }");
		case TextureSize:
			var tt = args[0].t;
			var tstr = getTexType(tt);
			switch( tt ) {
			case TSampler(dim, arr) if( args.length > 1 ):
				var size = Tools.getDimSize(dim, arr);
				switch( size ) {
				case 1:
					decl('float textureSize($tstr tex, int lod) { float w; float levels; tex.GetDimensions((uint)lod,w,levels); return w; }');
				case 2:
					decl('float2 textureSize($tstr tex, int lod) { float w; float h; float levels; tex.GetDimensions((uint)lod,w,h,levels); return float2(w, h); }');
				case 3:
					decl('float3 textureSize($tstr tex, int lod) { float w; float h; float els; float levels; tex.GetDimensions((uint)lod,w,h,els,levels); return float3(w, h, els); }');
				}
			case TSampler(dim,arr), TRWTexture(dim, arr, _):
				var size = Tools.getDimSize(dim, arr);
				switch( size ) {
				case 1:
					decl('float textureSize($tstr tex) { float w; tex.GetDimensions(w); return w; }');
				case 2:
					decl('float2 textureSize($tstr tex) { float w; float h; tex.GetDimensions(w,h); return float2(w, h); }');
				case 3:
					decl('float3 textureSize($tstr tex) { float w; float h; float els; tex.GetDimensions(w,h,els); return float3(w, h, els); }');
				}
			default:
				throw "assert";
			}
		case Vec2 if( args.length == 1 && args[0].t == TFloat ):
			decl("float2 vec2( float v ) { return float2(v,v); }");
		case Vec3 if( args.length == 1 && args[0].t == TFloat ):
			decl("float3 vec3( float v ) { return float3(v,v,v); }");
		case Vec4 if( args.length == 1 && args[0].t == TFloat ):
			decl("float4 vec4( float v ) { return float4(v,v,v,v); }");
		case IVec2 if( args.length == 1 && args[0].t.match(TInt | TFloat)):
			decl("int2 ivec2( int v ) { return int2(v,v); }");
		case IVec3 if( args.length == 1 && args[0].t.match(TInt | TFloat)):
			decl("int3 ivec3( int v ) { return int3(v,v,v); }");
		case IVec4 if( args.length == 1 && args[0].t.match(TInt | TFloat)):
			decl("int4 ivec4( int v ) { return int4(v,v,v,v); }");
		default:
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
		case TCall({ e : TGlobal(SetLayout) },_):
			// ignore
		case TCall({ e : TGlobal(g = (Texture | TextureLod)) }, args):
			addValue(args[0], tabs);
			switch( g ) {
			case Texture:
				add(isVertex ? ".SampleLevel(" : ".Sample(");
			case TextureLod:
				add(".SampleLevel(");
			default:
				throw "assert";
			}
			var offset = 0;
			var expr = switch( args[0].e ) {
			case TArray(e,{ e : TConst(CInt(i)) }): offset = i; e;
			case TArray(e,{ e : TBinop(OpAdd,{e:TVar(_)},{e:TConst(CInt(_))}) }): throw "Offset in texture access: need loop unroll?";
			default: args[0];
			}
			switch( expr.e ) {
			case TVar(v):
				var samplers = samplers.get(v.id);
				if( samplers == null ) throw "assert";
				add('__Samplers[${samplers[offset]}]');
			default: throw "assert";
			}
			for( i in 1...args.length ) {
				add(",");
				addValue(args[i],tabs);
			}
			if( g == Texture && isVertex )
				add(",0");
			add(")");
		case TCall({ e : TGlobal(ImageStore) }, [tex,uv,color]):
			addValue(tex, tabs);
			add("[");
			addValue(uv, tabs);
			add("] = ");
			addValue(color, tabs);
		case TCall({ e : TGlobal(g = (Texel)) }, args):
			addValue(args[0], tabs);
			add(".Load(");
			switch( args[1].t ) {
			case TSampler(dim,arr):
				var size = Tools.getDimSize(dim, arr) + 1;
				add("int"+size+"(");
			default:
				throw "assert";
			}
			addValue(args[1],tabs);
			if ( args.length != 2 ) {
				// with LOD argument
				add(", ");
				addValue(args[2], tabs);
			} else {
				add(", 0");
			}
			add("))");
		case TCall(e = { e : TGlobal(g) }, args):
			declGlobal(g, args);
			switch( [g,args] ) {
			case [Vec2|Vec3|Vec4, [{ t : TFloat }]]:
				add(g.getName().toLowerCase());
			case [IVec2|IVec3|IVec4, [{ t : TInt }]|[{ t : TFloat }]]:
				add(g.getName().toLowerCase());
			default:
				addValue(e,tabs);
			}
			add("(");
			var first = true;
			for( e in args ) {
				if( first ) first = false else add(", ");
				addValue(e, tabs);
			}
			add(")");
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
				if( i < el.length - 1 ) {
					newLine(el[i]);
					add(tabs);
				}
			}
		case TBinop(OpAssign,evar = { e : TVar(_) },{ e : TArrayDecl(el) }):
			for( i in 0...el.length ) {
				addExpr(evar, tabs);
				add("[");
				add(i);
				add("] = ");
				addExpr(el[i], tabs);
				if( i < el.length - 1 ) {
					newLine(el[i]);
					add(tabs);
				}
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
			case [OpAssignOp(OpMod) | OpMod, _, _]:
				if( op.match(OpAssignOp(_)) ) {
					addValue(e1, tabs);
					add(" = ");
				}
				declMods();
				add("mod(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpAssignOp(op), TVec(_), TMat3x4 | TMat3 | TMat4]:
				addValue(e1, tabs);
				add(" = ");
				addValue({ e : TBinop(op, e1, e2), t : e.t, p : e.p }, tabs);
			case [OpMult, TVec(_), TMat3x4]:
				add("mul(float4(");
				addValue(e1, tabs);
				add(",1.),");
				addValue(e2, tabs);
				add(")");
			case [OpMult, TVec(_), TMat2 | TMat3 | TMat4]:
				add("mul(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpMult, TMat3 | TMat3x4 | TMat4, TMat3 | TMat3x4 | TMat4]:
				add("mul(");
				addValue(e1, tabs);
				add(",");
				addValue(e2, tabs);
				add(")");
			case [OpUShr, _, _]:
				decl("int _ushr( int a, int b) { return (int)(((unsigned int)a) >> b); }");
				add("_ushr(");
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
			case TMat2, TMat3, TMat3x4, TMat4:
				switch( e.t ) {
				case TMat2:
					decl("float2 _matarr( float2x2 m, int idx ) { return float2(m[0][idx],m[1][idx]); }");
				case TMat3:
					decl("float3 _matarr( float3x3 m, int idx ) { return float3(m[0][idx],m[1][idx],m[2][idx]); }");
				case TMat3x4:
					decl("float4 _matarr( float3x4 m, int idx ) { return float4(m[0][idx],m[1][idx],m[2][idx],m[3][idx]); }");
				case TMat4:
					decl("float4 _matarr( float4x4 m, int idx ) { return float4(m[0][idx],m[1][idx],m[2][idx],m[3][idx]); }");
				default:
				}
				add("_matarr(");
				addValue(e,tabs);
				add(",");
				addValue(index,tabs);
				add(")");
			default:
				addValue(e, tabs);
				add("[");
				addValue(index, tabs);
				add("]");
			}
		case TMeta(m, args, e):
			handleMeta(m, args, addExpr, e, tabs);
		case TField(e, f):
			addValue(e, tabs);
			add(".");
			add(f);
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

	function collectGlobals( m : Map<TGlobal,Type>, e : TExpr ) {
		switch( e.e )  {
		case TGlobal(g): m.set(g,e.t);
		case TCall({ e : TGlobal(SetLayout) }, [{ e : TConst(CInt(x)) }, { e : TConst(CInt(y)) }, { e : TConst(CInt(z)) }]):
			computeLayout = [x,y,z];
		case TCall({ e : TGlobal(SetLayout) }, [{ e : TConst(CInt(x)) }, { e : TConst(CInt(y)) }]):
			computeLayout = [x,y,1];
		case TCall({ e : TGlobal(SetLayout) }, [{ e : TConst(CInt(x)) }]):
			computeLayout = [x,1,1];
		default: e.iter(collectGlobals.bind(m));
		}
	}

	function initVars( s : ShaderData ) {
		var index = 0;
		function declVar(prefix:String, v : TVar ) {
			add("\t");
			addVar(v);
			if( v.kind == Output )
				add(" : " + (isVertex ? SV_POSITION : SV_TARGET + (index++)));
			else
				add(" : " + semanticName(v.name));
			add(";\n");
			varAccess.set(v.id, prefix);
		}

		var foundGlobals = new Map();
		for( f in s.funs )
			collectGlobals(foundGlobals, f.expr);

		add("struct s_input {\n");
		if( kind == Fragment )
			add("\tfloat4 __pos__ : "+SV_POSITION+";\n");
		for( v in s.vars )
			if( v.kind == Input || (v.kind == Var && !isVertex) )
				declVar("_in.", v);
		for( g in foundGlobals.keys() ) {
			var sv = getSVName(g);
			if( sv == null ) continue;
			add("\t");
			switch( g ) {
			case InstanceID:
				add("uint");
			default:
				addType(foundGlobals.get(g));
			}
			var name = g.getName().split("_").pop();
			name = name.charAt(0).toLowerCase()+name.substr(1);
			add(" "+name);
			add(" : ");
			add(sv);
			add(";\n");
			GLOBALS.set(g, "_in."+name);
		}
		add("};\n\n");

		if( !isCompute ) {
			add("struct s_output {\n");
			for( v in s.vars )
				if( v.kind == Output )
					declVar("_out.", v);
			for( v in s.vars )
				if( v.kind == Var && isVertex )
					declVar("_out.", v);
			add("};\n\n");
		}
	}

	function initGlobals( s : ShaderData ) {
		add('cbuffer _globals : register(b$baseRegister) {\n');
		for( v in s.vars )
			if( v.kind == Global ) {
				add("\t");
				addVar(v);
				add(";\n");
			}
		add("};\n\n");
	}

	function initParams( s : ShaderData ) {
		var textures = [];
		var buffers = [];
		var uavs = [];
		add('cbuffer _params : register(b${baseRegister+1}) {\n');
		for( v in s.vars )
			if( v.kind == Param ) {
				switch( v.type ) {
				case TArray(TRWTexture(_), _):
					uavs.push(v);
					continue;
				case TArray(t, _) if( t.isTexture() ):
					textures.push(v);
					continue;
				case TBuffer(_):
					buffers.push(v);
					continue;
				default:
					if( v.type.isTexture() ) {
						textures.push(v);
						continue;
					}
				}
				add("\t");
				addVar(v);
				add(";\n");
			}
		add("};\n\n");

		var regCount = baseRegister + 2;
		var storageRegister = 0;
		for( b in buffers.concat(uavs) ) {
			switch( b.type ) {
			case TBuffer(t, size, Uniform):
				add('cbuffer _buffer$regCount : register(b${regCount++}) { ');
				addVar(b);
				add("; };\n");
			case TBuffer(t, size, Storage):
				addVar(b);
				add(' : register(t${storageRegister++});\n');
			default:
				addVar(b);
				add(' : register(u${regCount++});\n');
			}
		}
		if( buffers.length + uavs.length > 0 ) add("\n");

		var ctx = new Samplers();
		var texCount = storageRegister;
		for( v in textures ) {
			addVar(v);
			add(' : register(t${texCount});\n');
			switch( v.type ) {
			case TArray(_,SConst(n)): texCount += n;
			default: texCount++;
			}
			samplers.set(v.id, ctx.make(v, []));
		}

		if( ctx.count > 0 )
			add('SamplerState __Samplers[${ctx.count}] : register(s0);\n');
	}

	function initStatics( s : ShaderData ) {
		add(STATIC + "s_input _in;\n");
		if( !isCompute )
			add(STATIC + "s_output _out;\n");

		add("\n");
		for( v in s.vars )
			if( v.kind == Local ) {
				var isConst = v.qualifiers != null && v.qualifiers.indexOf(Final) >= 0;
				add(STATIC);
				if( isConst )
					add(CONST);
				addVar(v);
				if( isConst ) {
					var found = null;
					for( f in s.funs ) {
						switch( f.expr.e ) {
						case TBlock(el):
							for( e in el ) {
								switch( e.e ) {
								case TBinop(OpAssign, { e : TVar(v2) }, einit) if( v2 == v ):
									found = einit;
									break;
								default:
								}
							}
						default:
						}
					}
					if( found == null )
						throw "Constant variable "+v.name+" is missing initializer";
					add(" = ");
					addExpr(found,"");
				}
				add(";\n");
			}
		add("\n");
	}

	function emitMain( expr : TExpr ) {
		if( isCompute )
			add('[numthreads(${computeLayout[0]},${computeLayout[1]},${computeLayout[2]})] void ');
		else
			add('s_output ');
		add("main( s_input __in ) {\n");
		add("\t_in = __in;\n");
		switch( expr.e ) {
		case TBlock(el):
			for( e in el ) {
				switch( e.e ) {
				case TBinop(OpAssign,evar = { e : TVar(v) },_) if( v.qualifiers != null && v.qualifiers.indexOf(Final) >= 0 ):
					// ignore (is a static const)
					continue;
				default:
				}
				add("\t");
				addExpr(e, "\t");
				newLine(e);
			}
		default:
			addExpr(expr, "");
		}
		if( !isCompute )
			add("\treturn _out;\n");
		add("}");
	}

	function initLocals() {
		var locals = Lambda.array(locals);
		locals.sort(function(v1, v2) return Reflect.compare(v1.name, v2.name));
		for( v in locals ) {
			add(STATIC);
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
		kind = f.kind;
		varAccess = new Map();
		samplers = new Map();
		initVars(s);
		initGlobals(s);
		initParams(s);
		initStatics(s);

		var tmp = buf;
		buf = new StringBuf();
		emitMain(f.expr);
		exprValues.push(buf.toString());
		buf = tmp;

		initLocals();

		decls.push(buf.toString());
		buf = null;
		return decls.join("\n");
	}

	public static function semanticName( name : String ) {
		if( name.length == 0 || (name.charCodeAt(name.length - 1) >= '0'.code && name.charCodeAt(name.length - 1) <= '9'.code) )
			name += "_";
		return name;
	}

}
