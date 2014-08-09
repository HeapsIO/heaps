package hxsl;

import hxsl.Ast;
import hxsl.RuntimeShader;
import format.agal.Data;

class AgalOut {
	
	static var COMPS = [X, Y, Z, W];

	var code : Array<Opcode>;
	var vertex : Bool;
	var version : Int;
	var opcodes : Array<Opcode>;
	var varMap : Map<Int, Reg>;
	var tmpCount : Int;
	var nullReg : Reg;

	public function new() {
	}

	public dynamic function error( msg : String, p : Position ) {
		throw msg;
	}
	
	public function compile( s : RuntimeShaderData, version ) : Data {
		vertex = s.vertex;
		nullReg = { t : RTemp, index : -1, swiz : null, access : null };
		this.version = version;
		opcodes = [];
		tmpCount = 0;
		varMap = new Map();
		
		var varying = [];
		var paramCount = 0, varCount = 0, inputCount = 0, outCount = 0, texCount = 0;
		for( v in s.data.vars ) {
			var r : Reg;
			switch( v.kind ) {
			case Param, Global:
				switch( v.type ) {
				case TArray(TSampler2D | TSamplerCube, SConst(n)):
					r = { t : RTexture, index : texCount, swiz : null, access : null };
					texCount += n;
				default:
					r = { t : RConst, index : paramCount, swiz : defSwiz(v.type), access : null };
					paramCount += regSize(v.type);
				}
			case Var:
				r = { t : RVar, index : varCount, swiz : defSwiz(v.type), access : null };
				varying.push(r);
				varCount += regSize(v.type);
			case Output:
				r = { t : ROut, index : outCount, swiz : defSwiz(v.type), access : null };
				outCount += regSize(v.type);
			case Input:
				r = { t : RAttr, index : inputCount, swiz : defSwiz(v.type), access : null };
				inputCount += regSize(v.type);
			case Local, Function:
				continue;
			}
			varMap.set(v.id, r);
		}
		if( paramCount != s.globalsSize + s.paramsSize )
			throw "assert";
		
		if( s.data.funs.length != 1 ) throw "assert";
		expr(s.data.funs[0].expr);
		
		// force write of all varying components
		for( v in varying ) {
			if( v.swiz == null ) continue;
			for( i in 0...opcodes.length )
				switch( opcodes[i] ) {
				case OMov(dst, val) if( dst == v ):
					var dst = Reflect.copy(dst);
					var val = Reflect.copy(val);
					val.swiz = null;
					dst.swiz = null;
					opcodes[i] = OMov(dst, val);
					break;
				default:
				}
		}
		return {
			fragmentShader : !vertex,
			version : version,
			code : opcodes,
		};
	}
	
	inline function mov(dst, src) {
		op(OMov(dst, src));
	}
	
	inline function op(o) {
		opcodes.push(o);
	}
	
	inline function swiz( r : Reg, sw : Array<C> ) : Reg {
		if( r.access != null || r.swiz != null ) throw "assert";
		return {
			t : r.t,
			index : r.index,
			swiz : sw,
			access : null
		};
	}
	
	function expr( e : TExpr ) : Reg {
		switch( e.e ) {
		case TVarDecl(v, init):
			if( init != null )
				mov(reg(v), expr(init));
			return nullReg;
		case TBlock(el):
			var r = nullReg;
			for( e in el )
				r = expr(e);
			return r;
		case TVar(v):
			return reg(v);
		case TBinop(bop, e1, e2):
			switch( bop ) {
			case OpAssign:
				var r = expr(e1);
				mov(r, expr(e2));
				return r;
			case OpAssignOp(op):
				var r1 = expr(e1);
				mov(r1, expr( { e : TBinop(op, e1, e2), t : e.t, p : e.p } ));
				return r1;
			case OpMult:
				var r = allocReg(e.t);
				op(OMul(r, expr(e1), expr(e2)));
				return r;
			default:
				throw "TODO " + bop;
			}
		case TCall(e, args):
			switch( e.e ) {
			case TGlobal(g):
				switch( [g, args] ) {
				case [Vec4, _]:
					var r = allocReg();
					var pos = 0;
					for( a in args ) {
						var e = expr(a);
						switch( a.t ) {
						case TFloat:
							mov(swiz(r, [COMPS[pos++]]), e);
						case TVec(2, VFloat):
							mov(swiz(r, [COMPS[pos++], COMPS[pos++]]), e);
						case TVec(3, VFloat):
							mov(swiz(r, [COMPS[pos++], COMPS[pos++], COMPS[pos++]]), e);
						case TVec(4, VFloat):
							mov(r, e);
						default:
							throw "assert " + e.t;
						}
					}
					return r;
				case [Texture2D, [t,uv]]:
					var t = expr(t);
					var uv = expr(uv);
					var r = allocReg();
					if( t.t != RTexture ) throw "assert";
					op(OTex(r, uv, { index : t.index, flags : [TIgnoreSampler] }));
					return r;
				default:
					throw "TODO " + g + ":" + args.length;
				}
			default:
				throw "TODO CALL " + e.e;
			}
		case TArray(e, index):
			switch( index.e ) {
			case TConst(CInt(v)):
				var r = expr(e);
				var stride = switch( e.t ) {
				case TArray(TSampler2D | TSamplerCube, _): 1;
				case TArray(t, _): regSize(t);
				default: throw "assert " + e.t;
				};
				return { t : r.t, index : r.index + v * stride, swiz : null, access : null };
			default:
				throw "TODO " + index.e;
			}
		case TSwiz(e, regs):
			var r = expr(e);
			return swiz(r, [for( r in regs ) COMPS[r.getIndex()]]);
		default:
			throw "TODO " + e.e;
		}
	}
	
	function regSize( t : Type ) {
		return switch( t ) {
		case TInt, TFloat, TVec(_), TBytes(_): 1;
		case TMat3, TMat3x4: 3;
		case TMat4: 4;
		case TArray(t, SConst(size)): regSize(t) * size;
		case TStruct(vl): throw "TODO";
		case TVoid, TString, TBool, TSampler2D, TSamplerCube, TFun(_), TArray(_): throw "assert "+t;
		}
	}
	
	function defSwiz( t : Type ) {
		return switch( t ) {
		case TInt, TFloat: [X];
		case TVec(2, _), TBytes(2): [X, Y];
		case TVec(3, _), TBytes(3): [X, Y, Z];
		default: null;
		}
	}
	
	function reg( v : TVar ) : Reg {
		var r = varMap.get(v.id);
		if( r != null ) return r;
		if( v.kind != Local ) throw "assert " + v;
		r = allocReg(v.type);
		varMap.set(v.id, r);
		return r;
	}
	
	function allocReg( ?t : Type ) : Reg {
		var r = { t : RTemp, index : tmpCount, swiz : t == null ? null : defSwiz(t), access : null };
		tmpCount += t == null ? 1 : regSize(t);
		return r;
	}
	
	public static function toAgal( shader, version ) {
		var a = new AgalOut();
		return a.compile(shader, version);
	}

}
