package hxsl;
using hxsl.Ast;

class Serializer {

	var out : haxe.io.BytesBuffer;
	var input : haxe.io.BytesInput;
	var varMap : Map<Int, TVar>;
	var idMap : Map<Int,Int>;
	var typeIdMap : Map<Type,Int>;
	var types : Array<Type>;
	var uid = 1;
	var tid = 1;

	public function new() {
	}

	inline function writeArr<T>( arr : Array<T>, f : T -> Void ) {
		writeVarInt(arr.length);
		for( v in arr ) f(v);
	}

	inline function readArr<T>( f : Void -> T ) {
		return [for( i in 0...readVarInt() ) f()];
	}

	function readVarInt() {
		var b = input.readByte();
		if( b < 128 )
			return b;
		if( b == 0xFF )
			return input.readInt32();
		return ((b & 0x7F) << 8) | input.readByte();
	}

	function writeVarInt( id : Int ) {
		if( id < 128 )
			out.addByte(id);
		else {
			var n = id >> 8;
			if( n >= 127 ) {
				out.addByte(0xFF);
				out.addInt32(n);
			} else {
				out.addByte(n | 128);
				out.addByte(id & 0xFF);
			}
		}
	}

	function writeID( id : Int ) {
		var id2 = idMap.get(id);
		if( id2 == null ) {
			id2 = uid++;
			idMap.set(id,id2);
		}
		writeVarInt(id2);
	}


	inline function readID() {
		return readVarInt();
	}

	function writeTID( t : Type ) {
		var tid = typeIdMap.get(t);
		if( tid != null ) {
			writeVarInt(tid);
			return false;
		}
		tid = this.tid++;
		typeIdMap.set(t,tid);
		writeVarInt(tid);
		return true;
	}

	function writeType( t : Type ) {
		out.addByte(t.getIndex());
		switch (t) {
		case TVec(size, t):
			out.addByte(size | (t.getIndex() << 3));
		case TBytes(size):
			out.addInt32(size);
		case TStruct(vl):
			if( writeTID(t) )
				writeArr(vl,writeVar);
		case TFun(variants):
			// not serialized
		case TArray(t, size), TBuffer(t, size):
			writeType(t);
			switch (size) {
			case SConst(v): out.addByte(0); writeVarInt(v);
			case SVar(v): writeVar(v);
			}
		case TChannel(size):
			out.addByte(size);
		case TVoid, TInt, TBool, TFloat, TString, TMat2, TMat3, TMat4, TMat3x4, TSampler2D, TSampler2DArray, TSamplerCube:
		}
	}

	static var TVECS = new Map();

	function readType() : Type {
		return switch( input.readByte() ) {
		case 0: TVoid;
		case 1: TInt;
		case 2: TBool;
		case 3: TFloat;
		case 4: TString;
		case 5:
			var bits = input.readByte();
			var v = TVECS.get(bits);
			if( v == null ) {
				v = TVec(bits & 7, VecType.createByIndex(bits>>3));
				TVECS.set(bits, v);
			}
			v;
		case 6: TMat3;
		case 7: TMat4;
		case 8: TMat3x4;
		case 9: TBytes(input.readInt32());
		case 10: TSampler2D;
		case 11: TSampler2DArray;
		case 12: TSamplerCube;
		case 13:
			var id = readVarInt();
			var t = types[id];
			if( t != null ) return t;
			t = TStruct(readArr(readVar));
			types[id] = t;
			t;
		case 14:
			TFun(null);
		case 15:
			var t = readType();
			var v = readVar();
			TArray(t, v == null ? SConst(readVarInt()) : SVar(v));
		case 16:
			var t = readType();
			var v = readVar();
			TBuffer(t, v == null ? SConst(readVarInt()) : SVar(v));
		case 17:
			TChannel(input.readByte());
		case 18: TMat2;
		default:
			throw "assert";
		}
	}

	function writeString( s : String ) {
		var bytes = haxe.io.Bytes.ofString(s);
		writeVarInt(bytes.length);
		out.add(bytes);
	}

	function readString() {
		var len = readVarInt();
		var s = input.read(len).getString(0,len);
		return s;
	}

	function writeVar( v : TVar ) {
		if( v == null ) {
			out.addByte(0);
			return;
		}
		writeID(v.id);
		if( varMap.exists(v.id) ) return;
		varMap.set(v.id, v);
		writeString(v.name);
		writeType(v.type);
		out.addByte(v.kind.getIndex());
		writeVar(v.parent);
		if( v.qualifiers == null )
			out.addByte(0);
		else {
			out.addByte(v.qualifiers.length);
			for( q in v.qualifiers ) {
				out.addByte(q.getIndex());
				switch (q) {
				case Private, Nullable, PerObject, Shared, Ignore:
				case Const(max): out.addInt32(max == null ? 0 : max);
				case Name(n): writeString(n);
				case Precision(p): out.addByte(p.getIndex());
				case Range(min, max): out.addDouble(min); out.addDouble(max);
				case PerInstance(v): out.addInt32(v);
				case Doc(s): writeString(s);
				case Borrow(s): writeString(s);
				case Sampler(s): writeString(s);
				}
			}
		}
	}

	function writeFun( f : TFunction ) {
		out.addByte(f.kind.getIndex());
		writeVar(f.ref);
		writeArr(f.args, writeVar);
		writeType(f.ret);
		writeExpr(f.expr);
	}

	function writeConst( c : Const ) {
		out.addByte(c.getIndex());
		switch (c) {
		case CNull:
		case CBool(b): out.addByte(b?1:0);
		case CInt(v): out.addInt32(v);
		case CFloat(v): out.addDouble(v);
		case CString(v): writeString(v);
		}
	}

	function writeExpr( e : TExpr ) {
		if( e == null ) {
			out.addByte(0);
			return;
		}
		out.addByte(e.e.getIndex() + 1);
		switch (e.e) {
		case TConst(c):
			writeConst(c);
		case TVar(v):
			writeVar(v);
		case TGlobal(g):
			out.addByte(g.getIndex());
		case TParenthesis(e):
			writeExpr(e);
		case TBlock(el):
			writeArr(el, writeExpr);
		case TBinop(op, e1, e2):
			switch( op ) {
			case OpAssignOp(op):
				out.addByte(op.getIndex() | 128);
			default:
				out.addByte(op.getIndex());
			}
			writeExpr(e1);
			writeExpr(e2);
		case TUnop(op, e1):
			out.addByte(op.getIndex());
			writeExpr(e1);
		case TVarDecl(v, init):
			writeVar(v);
			writeExpr(init);
		case TCall(e, args):
			writeExpr(e);
			writeArr(args, writeExpr);
		case TSwiz(e, regs):
			writeExpr(e);
			if( regs.length == 0 ) throw "assert";
			var bits = regs.length - 1, k = 2;
			for( r in regs ) {
				bits |= r.getIndex() << k;
				k += 2;
			}
			out.addByte(bits & 0xFF);
			out.addByte(bits >> 8);
		case TIf(econd, eif, eelse):
			writeExpr(econd);
			writeExpr(eif);
			writeExpr(eelse);
		case TDiscard:
		case TReturn(e):
			writeExpr(e);
		case TFor(v, it, loop):
			writeVar(v);
			writeExpr(it);
			writeExpr(loop);
		case TContinue:
		case TBreak:
		case TArray(e, index):
			writeExpr(e);
			writeExpr(index);
		case TArrayDecl(el):
			writeArr(el, writeExpr);
		case TSwitch(e, cases, def):
			writeExpr(e);
			writeArr(cases, function(c) {
				writeArr(c.values, writeExpr);
				writeExpr(c.expr);
			});
			writeExpr(def);
		case TWhile(e, loop, normalWhile):
			writeExpr(e);
			writeExpr(loop);
			out.addByte(normalWhile ? 1 : 0);
		case TMeta(m, args, e):
			writeString(m);
			writeArr(args, writeConst);
			writeExpr(e);
		}
		writeType(e.t);
		// no position
	}

	function readConst() : Const {
		return switch( input.readByte() ) {
		case 0: CNull;
		case 1: CBool(input.readByte() != 0);
		case 2: CInt(input.readInt32());
		case 3: CFloat(input.readDouble());
		case 4: CString(readString());
		default: throw "assert";
		}
	}

	static var BOPS = {
		var ops = Binop.createAll();
		ops.insert(OpAssignOp(null).getIndex(),null);
		ops;
	};
	static var UNOPS = Unop.createAll();
	static var TGLOBALS = hxsl.TGlobal.createAll();
	static var TSWIZ = new Map();
	static var REGS = [X,Y,Z,W];

	function readExpr() : TExpr {
		var k = input.readByte();
		if( k-- == 0 )
			return null;
		var e : TExprDef = switch( k ) {
		case 0: TConst(readConst());
		case 1: TVar(readVar());
		case 2: TGlobal(TGLOBALS[input.readByte()]);
		case 3: TParenthesis(readExpr());
		case 4: TBlock(readArr(readExpr));
		case 5:
			var op = input.readByte();
			TBinop(op >= 128 ? OpAssignOp(BOPS[op&127]) : BOPS[op], readExpr(), readExpr());
		case 6: TUnop(UNOPS[input.readByte()], readExpr());
		case 7: TVarDecl(readVar(), readExpr());
		case 8: TCall(readExpr(), readArr(readExpr));
		case 9:
			var e = readExpr();
			var bits = input.readUInt16();
			var swiz = TSWIZ.get(bits);
			if( swiz == null ) {
				swiz = [for( i in 0...(bits&3)+1 ) REGS[(bits>>(i*2+2))&3]];
				TSWIZ.set(bits, swiz);
			}
			TSwiz(e, swiz);
		case 10: TIf(readExpr(), readExpr(), readExpr());
		case 11: TDiscard;
		case 12: TReturn(readExpr());
		case 13: TFor(readVar(), readExpr(), readExpr());
		case 14: TContinue;
		case 15: TBreak;
		case 16: TArray(readExpr(), readExpr());
		case 17: TArrayDecl(readArr(readExpr));
		case 18: TSwitch(readExpr(), readArr(function() {
					return {
						values : readArr(readExpr),
						expr : readExpr(),
					};
				}), readExpr());
		case 19: TWhile(readExpr(), readExpr(), input.readByte() != 0);
		case 20: TMeta(readString(), readArr(readConst), readExpr());
		default: throw "assert";
		}
		return {
			e : e,
			t : readType(),
			p : null,
		}
	}

	static var VKINDS = VarKind.createAll();
	static var PRECS = Prec.createAll();

	function readVar() : TVar {
		var id = readID();
		if( id == 0 )
			return null;
		var v = varMap.get(id);
		if( v != null ) return v;
		v = {
			id : Tools.allocVarId(),
			name : readString(),
			type : null,
			kind : null,
		}
		varMap.set(id, v);
		v.type = readType();
		v.kind = VKINDS[input.readByte()];
		v.parent = readVar();
		var nq = input.readByte();
		if( nq > 0 ) {
			v.qualifiers = [];
			for( i in 0...nq ) {
				var qid = input.readByte();
				var q = switch( qid ) {
				case 0: var n = input.readInt32(); Const(n == 0 ? null : n);
				case 1: Private;
				case 2: Nullable;
				case 3: PerObject;
				case 4: Name(readString());
				case 5: Shared;
				case 6: Precision(PRECS[input.readByte()]);
				case 7: Range(input.readDouble(), input.readDouble());
				case 8: Ignore;
				case 9: PerInstance(input.readInt32());
				case 10: Doc(readString());
				case 11: Borrow(readString());
				case 12: Sampler(readString());
				default: throw "assert";
				}
				v.qualifiers.push(q);
			}
		}
		return v;
	}

	static var FKIND = FunctionKind.createAll();

	function readFun() : TFunction {
		return {
			kind : FKIND[input.readByte()],
			ref : readVar(),
			args : readArr(readVar),
			ret : readType(),
			expr : readExpr(),
		};
	}

	static var SIGN = 0x8B741D; // will be encoded to HXSL

	public function unserialize( data : String ) : ShaderData {
		input = new haxe.io.BytesInput(haxe.crypto.Base64.decode(data,false));
		if( input.readByte() != (SIGN & 0xFF) || input.readByte() != (SIGN >> 8) & 0xFF || input.readByte() != (SIGN >> 16) & 0xFF )
			throw "Invalid HXSL data";
		varMap = new Map();
		types = [];
		return {
			name : readString(),
			vars : readArr(readVar),
			funs : readArr(readFun),
		};
	}

	public function serialize( s : ShaderData ) {
		varMap = new Map();
		idMap = new Map();
		typeIdMap = new Map();
		out = new haxe.io.BytesBuffer();
		out.addByte(SIGN & 0xFF);
		out.addByte((SIGN >> 8) & 0xFF);
		out.addByte((SIGN >> 16) & 0xFF);
		writeString(s.name);
		writeArr(s.vars, writeVar);
		writeArr(s.funs, writeFun);
		return haxe.crypto.Base64.encode(out.getBytes(),false);
	}

	public static function run( s : ShaderData ) {
		return new Serializer().serialize(s);
	}

}