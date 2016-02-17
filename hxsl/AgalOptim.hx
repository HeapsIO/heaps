package hxsl;
import format.agal.Data;

private class RegInfos {
	public var index : Int;
	public var swiz : Array<C>;
	public var values : Array<Reg>;
	public var prevRead : haxe.ds.Vector<Int>;
	public var prevWrite : haxe.ds.Vector<Int>;
	public var reads : haxe.ds.Vector<Int>;
	public var writes : haxe.ds.Vector<Int>;

	public var live : Array<Int>;
	public var invertSwiz : Array<Int>;

	public function new(i) {
		index = i;
		prevRead = new haxe.ds.Vector(4);
		prevWrite = new haxe.ds.Vector(4);
		reads = new haxe.ds.Vector(4);
		writes = new haxe.ds.Vector(4);
		reset();
	}

	public inline function reset() {
		live = [];
		swiz = null;
		invertSwiz = null;
		values = null;
		invertSwiz = [];
		for( i in 0...4 ) {
			prevRead[i] = -1;
			prevWrite[i] = -1;
			writes[i] = -1;
			reads[i] = -1;
		}
	}
}

@:noDebug
class AgalOptim {

	static var COMPS = [X, Y, Z, W];

	var code : Array<Opcode>;
	var codePos : Int;
	var prevRegs : Array<RegInfos>;
	var regs : Array<RegInfos>;
	var flag : Bool;
	var maxRegs : Int;
	var startReg : Int;
	var changed : Bool;
	var data : Data;
	var usedRegs : Array<Array<RegInfos>>;
	var packRegisters : Bool;
	var debug : Bool;

	public function new(debug = false) {
		this.debug = debug;
		regs = [];
	}

	function opStr(op) {
		return format.agal.Tools.opStr(op);
	}

	function isWriteMask( swiz : Array<C> ) {
		if( swiz == null || swiz.length == 1 )
			return true;
		for( i in 0...swiz.length )
			if( swiz[i] != COMPS[i] )
				return false;
		return true;
	}

	public function optimize( d : Data ) : Data {
		data = d;
		code = d.code.copy();

		var inputs = [];
		for( op in code ) iter(op, function(r, _) if( r.t == RAttr ) inputs[r.index] = true);

		while( true ) {
			//if( debug ) trace("OPTIM\n"+[for( op in code ) opStr(op)].join("\n"));
			changed = false;
			buildLive(true);
			splice();
			if( changed ) continue;
			optiMov();
			if( changed ) continue;
			optiDup();
			if( changed ) continue;
			break;
		}

		// added unread inputs
		for( op in code ) iter(op, function(r, _) if( r.t == RAttr ) inputs[r.index] = false);
		for( i in 0...inputs.length )
			if( inputs[i] ) {
				changed = true;
				code.push(OMov(allocTemp(4), new Reg(RAttr, i, null)));
			}

		// single writes for out/varying
		uniqueWrite(RVar);
		uniqueWrite(ROut);

		unoptim();
		if( changed )
			buildLive(false);

		var old = code;
		packRegisters = false;
		if( !allocRegs() ) {
			code = old;
			packRegisters = true;
			allocRegs();
		}

		optiMat();


		// write mask are just masks, not full swizzle, we then need to change all our writes
		//    for instance  V.zw = T.xy  actually mean  V.??zw = T.xyyy (? = ignore write)
		for( i in 0...code.length ) {
			var op = code[i];
			switch( op ) {
			case OMov(dst, v), ORcp(dst, v) if( !isWriteMask(dst.swiz) ):
				var dst = dst.clone();
				var v = v.clone();
				// reinterpret swizzling accordingly to write mask
				var last = X;
				v.swiz = [for( i in 0...4 ) {
					var k = dst.swiz.indexOf(COMPS[i]);
					if( k >= 0 ) last = v.swiz[k];
					last;
				}];
				code[i] = OMov(dst, v);
			case OIfe(_), OIne(_), OIfg(_), OIfl(_), OEls, OEif, OKil(_):
				// ignore
			default:
				var dst : Reg = op.getParameters()[0];
				if( !isWriteMask(dst.swiz) )
					throw "invalid write mask in "+format.agal.Tools.opStr(op);
			}
		}

		return {
			version : d.version,
			fragmentShader : d.fragmentShader,
			code : code,
		};
	}

	function uniqueWrite( t ) {
		var writes = [];
		for( op in code ) iter(op, function(r, w) if( r.t == t ) writes[r.index] += w ? 1 : (data.fragmentShader ? 0 : 2));
		for( i in 0...writes.length ) {
			if( writes[i] > 1 ) {
				var ri = allocTemp(4);
				for( op in code ) iter(op, function(r, _) if( r.t == t && r.index == i ) { r.t = RTemp; r.index = ri.index; } );
				code.push(OMov( new Reg(t, i, null), ri));
				changed = true;
			}
		}
	}

	function allocRegs() {
		for( r in regs )
			if( r != null ) {
				r.index = -1;
				// we extend the liveness of registers on their total lifetime
				// TODO : we should instead split the register into several different ones
				var allRegs = 0, first = -1, last = -1;
				for( i in 0...r.live.length ) {
					var v = r.live[i];
					if( v > 0 ) {
						allRegs |= v;
						if( first < 0 ) first = i;
						last = i;
					}
				}
				for( i in first...last + 1 )
					r.live[i] = allRegs;
			}
		startReg = 0;
		maxRegs = 0;
		var max = format.agal.Tools.getProps(RTemp, data.fragmentShader, data.version).count;
		usedRegs = [for( i in 0...max ) []];
		var ocode = [];
		for( i in 0...code.length ) {
			var o = code[i];
			codePos = i;
			if( o != OUnused )
				ocode.push(map(o, remapReg));
		}
		code = ocode;
		return usedRegs.length <= max;
	}

	function remapReg( r : Reg, write : Bool ) {
		var inf = getReg(r);
		if( inf == null ) {
			if( swizBits(r) == 228 )
				r.swiz = null;
			return r;
		}
		if( write && inf.index < 0 )
			assignReg(inf);
		var swiz = swiz(r);
		if( r.access != null )
			swiz = [r.access.comp];
		var sout = [];
		for( s in swiz ) {
			var s2 : Null<C> = inf.swiz[s.getIndex()];
			if( s2 == null ) {
				// reading from unassigned component can happen if we are padding a varying
				for( i in 0...4 ) {
					var s : Null<C> = inf.swiz[3 - i];
					if( s != null ) {
						s2 = s;
						break;
					}
				}
			}
			sout.push(s2);
		}
		var access = null;
		if( r.access != null ) {
			access = new RegAccess(r.access.t, sout[0], r.access.offset);
			sout = null;
		}
		var r = new Reg(RTemp, inf.index, sout, access);
		if( swizBits(r) == 228 ) r.swiz = null;
		return r;
	}

	function assignReg( inf : RegInfos ) {
		// make sure that we reserve all the components we will write
		var mask = 0, ncomps = 0;
		for( i in 0...4 )
			if( inf.writes[i] >= codePos ) {
				ncomps++;
				mask |= 1 << i;
			}
		// allocate a new temp id by looking the other live variable components
		var found : Null<Int> = null, reservedMask = 0, foundUsage = 10;
		for( td in 0...usedRegs.length ) {
			var rid = (startReg + td) % usedRegs.length;
			var reg = usedRegs[rid];

			// check current reserved components
			var rmask = 0;
			var available = 4;
			for( i in 0...4 ) {
				var t = reg[i];
				if( t == null ) continue;
				var b = t.live[codePos];
				if( b & (1 << t.invertSwiz[i]) == 0 ) continue;
				rmask |= 1 << i;
				available--;
			}

			// not enough components available
			if( available < ncomps )
				continue;

			// not first X components available
			// this is necessary for write masks
			if( ncomps > 1 && (rmask & ((1 << ncomps) - 1)) != 0 )
				continue;

			// if we have found a previous register that is better fit
			if( packRegisters && found != null && foundUsage <= available - ncomps )
				continue;

			found = rid;
			foundUsage = available - ncomps;
			reservedMask = rmask;
			// continue to look for best match
			if( !packRegisters ) {
				startReg = rid;
				break;
			}
		}
		if( found == null ) {
			reservedMask = 0;
			found = usedRegs.length;
			usedRegs.push([]);
		}
		var reg = usedRegs[found];
		inf.index = found;
		// list free components
		var all = [X, Y, Z, W];
		var comps = [];
		for( i in 0...4 )
			if( reservedMask & (1 << i) == 0 )
				comps.push(all[i]);
		// create component map
		inf.swiz = [];
		for( i in 0...4 )
			if( mask & (1 << i) != 0 ) {
				// if one single component, allocate from the end to keep free first registers
				var c = ncomps == 1 ? comps.pop() : comps.shift();
				inf.swiz[i] = c;
				inf.invertSwiz[c.getIndex()] = i;
				reg[c.getIndex()] = inf;
			}
	}

	function splice() {
		for( i in 0...code.length ) {
			codePos = i;
			flag = false;
			iter(code[i], checkUseful);
			if( flag ) {
				code[i] = OUnused;
				changed = true;
			}
		}
	}

	function allocTemp( size : Int ) : Reg {
		var r = new Reg(RTemp, regs.length, size == 4 ? null : [for( i in 0...size ) COMPS[i]]);
		regs.push(null);
		return r;
	}

	function unoptim() {
		// expand invalid AGAL opcodes with additional MOV
		var out = [];
		for( i in 0...code.length ) {
			var op = code[i];
			switch( op ) {
			case OMov(_), OTex(_):
				out.push(op);
				continue;
			default:
			}
			var args : Array<Reg> = cast op.getParameters();
			switch( args.length ) {
			case 0, 1:
				// nothing
			case 2:
				// unop with a const
				if( args[1].t == RConst && args[1].access == null ) {
					var r = allocTemp(swiz(args[1]).length);
					out.push(OMov(r, args[1]));
					out.push(Opcode.createByIndex(op.getIndex(), [args[0], r]));
					changed = true;
					continue;
				}
			default:
				// binop with two consts
				switch( [args[1].t, args[2].t] ) {
				case [RConst, RConst]:
					var r = allocTemp(swiz(args[1]).length);
					out.push(OMov(r, args[1]));
					out.push(Opcode.createByIndex(op.getIndex(), [args[0], r, args[2]]));
					changed = true;
					continue;
				default:
				}
			}
			out.push(op);
		}
		code = out;
	}


	function optiMov() {
		// additional remove of operations of this kind :
		//    mul t0.x, a, b
		//    mul t1.x, c, d
		//    mov t2.x, t0.x
		//    mov t2.y, t1.x
		//
		//    we will optimize as:
		//
		//	  mul t2.x, a, b
		//    mul t2.y, c, d
		for( i in 0...code.length ) {
			codePos = i;
			switch( code[i] ) {

			case OMov(r1, r2) if( r2.access != null ):
				var i2 = getReg(r2);
				if( i2 == null || i2.values == null ) continue;
				// optimize
				// 		mov a, b
				//		mov c, X[a]
				//  into
				//		mov c, X[b]
				var v = i2.values[r2.access.comp.getIndex()];
				if( v == null || (v.index == r2.index && v.t == r2.t) ) continue;
				code[i] = OMov(r1, new Reg(v.t, v.index, r2.swiz, new RegAccess(r2.access.t, v.swiz[0], r2.access.offset)));
				changed = true;

			case OMov(r1, r2):
				var i1 = getReg(r1);
				var i2 = getReg(r2);
				if( i1 == null || i2 == null ) continue;
				var sw1 = swiz(r1);
				var sw2 = swiz(r2);
				var used = [];
				var rewrite = true;
				for( i in 0...sw1.length ) {
					var k2 = sw2[i].getIndex();

					// we don't support mov A.xy, B.xx atm
					if( used[k2] ) {
						rewrite = false;
						break;
					}
					used[k2] = true;

					// if we have written after now, we can't tell the real write pos
					var wt = i2.writes[k2];
					if( wt >= codePos ) {
						rewrite = false;
						break;
					}

					// if we read after write, we can't opt since it's needed elsewhere
					if( i2.reads[k2] != codePos || (i2.prevRead[k2] != -1 && i2.prevRead[k2] > wt) ) {
						rewrite = false;
						break;
					}

					// make sure the component we will write is not live between write and mov
					var k1 = sw1[i].getIndex();
					for( p in wt + 1...codePos )
						if( i1.live[p] & (1 << k1) != 0 ) {
							rewrite = false;
							break;
						}
					if( !rewrite ) break;
				}

				if( rewrite ) {
					// if we have written at the same time one other component that we don't use,
					// we can't remap the mov since this will write more components than we want
					// e.g.
					//	mov a.xyz, E
					//  op b, E
					//  mov a.w, b.x
					//
					//  we can't do "op a.wwww, E" since that will be E.w and not E.x
					for( i in 0...sw1.length ) {
						var k2 = sw2[i].getIndex();
						var wt = i2.writes[k2];
						for( i in 0...4 )
							if( !used[i] && i2.writes[i] == wt ) {
								rewrite = false;
								break;
							}
						if( !rewrite )
							break;
					}
				}

				if( !rewrite ) continue;

				// perform rewrite
				for( i in 0...sw1.length ) {
					var k2 = sw2[i].getIndex();
					var wt = i2.writes[k2];
					var op = map(code[wt], function(r, w) {
						if( !w ) return r;
						var sout = [];
						for( s in swiz(r) ) {
							var idx = sw2.indexOf(s);
							sout.push(sw1[idx]);
						}
						return new Reg(RTemp, r1.index, sout);
					});
					code[wt] = op;
				}
				code[codePos] = OUnused;
				changed = true;
			default:
			}
			// we can't perform several changes since this will break live bits
			if( changed ) return;
		}
	}

	function buildLive(check) {
		prevRegs = regs;
		regs = [];
		for( i in 0...code.length ) {
			codePos = i;
			code[i] = switch( code[i] ) {
			case OMov(r1, r2) if( check ):
				checkMov(r1, r2);
			case op:
				map(op, checkValue);
			}
		}
	}

	function checkMov( r1 : Reg, r2 : Reg ) {

		r2 = checkValue(r2, false);

		var inf = getReg(r1);
		if( inf == null )
			return OMov(r1, r2);
		if( r2.access != null ) {
			inf.values = null;
			write(r1);
			return OMov(r1, r2);
		}
		var swiz = swiz(r1);
		var swiz2 = this.swiz(r2);
		if( inf.values == null ) inf.values = [];
		for( i in 0...swiz.length ) {
			var s = swiz[i];
			inf.values[s.getIndex()] = new Reg(r2.t, r2.index, [swiz2[i]]);
		}
		write(r1);
		return OMov(r1, r2);
	}

	inline function swiz( r : Reg ) {
		var s = r.swiz;
		if( s == null ) s = COMPS;
		return s;
	}

	function checkUseful( r : Reg, write : Bool ) {
		if( write ) {
			var inf = getReg(r);
			if( inf == null ) return;
			var sw = swiz(r);
			var mask = 0;
			for( s in swiz(r) )
				mask |= 1 << s.getIndex();
			if( inf.live[codePos + 1] & mask == 0 )
				flag = true;
		}
	}

	function checkValue( r : Reg, write : Bool ) {
		var inf = getReg(r);
		if( inf == null ) return r;
		if( write ) {
			if( r.swiz == null )
				inf.values = null;
			else if( inf.values != null )
				for( s in r.swiz )
					inf.values[s.getIndex()] = new Reg(RTemp, r.index, [s]);
			this.write(r);
			return r;
		}
		if( inf.values == null ) {
			read(r);
			return r;
		}
		var swiz = swiz(r);
		var reg = new Reg(null, 0, []);
		for( s in swiz ) {
			var v = inf.values[s.getIndex()];
			if( v == null ) {
				read(r);
				return r;
			}
			if( reg.t == null ) {
				reg.t = v.t;
				reg.index = v.index;
			} else if( reg.t != v.t || reg.index != v.index ) {
				read(r);
				return r;
			}
			reg.swiz.push(v.swiz[0]);
		}
		read(reg);
		return reg;
	}

	function write( r : Reg ) {
		var inf = getReg(r);
		if( inf == null ) return;
		for( s in swiz(r) ) {
			var b = s.getIndex();
			var r = inf.writes[b];
			if( r < codePos ) inf.prevWrite[b] = r;
			inf.writes[b] = codePos;
		}
	}

	function read( r : Reg ) {
		var inf = getReg(r);
		if( inf == null ) return;
		var minPos = 10000000, mask = 0;
		for( s in swiz(r) ) {
			var b = s.getIndex();
			var r = inf.reads[b];
			if( r < codePos ) inf.prevRead[b] = r;
			inf.reads[b] = codePos;
			var w = inf.writes[b];
			if( w < minPos ) minPos = w;
			mask |= 1 << b;
		}
		for( p in minPos+1...codePos+1 )
			inf.live[p] |= mask;
	}

	function getReg( r : Reg ) {
		if( r.t != RTemp ) return null;
		var inf = regs[r.index];
		if( inf == null ) {
			inf = prevRegs[r.index];
			if( inf != null )
				inf.reset();
			else
				inf = new RegInfos(r.index);
			regs[r.index] = inf;
		}
		return inf;
	}

	function swizBits( r : Reg ) {
		if( r.swiz == null ) return 228;
		var b = 0;
		for( i in 0...r.swiz.length )
			b |= r.swiz[i].getIndex() << (i * 2);
		return b;
	}

	inline function same( a : Reg, b : Reg ) {
		return dist(a, b) == 0;
	}

	inline function sameTex( ta : Tex, tb : Tex ) {
		return ta.index == tb.index && (ta.flags == tb.flags || ta.flags.join("") == tb.flags.join(""));
	}

	inline function dist( a : Reg, b : Reg ) {
		return a.t == b.t && a.access == null && b.access == null ? b.index - a.index : 1000;
	}

	inline function noSwiz( r : Reg ) {
		return new Reg(r.t, r.index, null);
	}

	function regSign(r:Reg) {
		return (r.index << 8) | swizBits(r);
	}

	function getSign( op : Opcode ) {
		var ra = 0, rb = 0;
		inline function regSign(r:Reg) {
			return ((r.index << 4)&511) ^ swizBits(r);
		}
		inline function unop(_, a, _) {
			ra = regSign(a);
		}
		inline function binop(_, a, b, _) {
			ra = regSign(a);
			rb = regSign(b);
		}
		switch( op ) {
		case OMov(_): return -1;
		case OAdd(d, a, b): binop(d, a, b, OAdd);
		case OSub(d, a, b): binop(d, a, b, OSub);
		case OMul(d, a, b): binop(d, a, b, OMul);
		case ODiv(d, a, b): binop(d, a, b, ODiv);
		case ORcp(d, v): unop(d, v, ORcp);
		case OMin(d, a, b): binop(d, a, b, OMin);
		case OMax(d, a, b): binop(d, a, b, OMax);
		case OFrc(d, v): unop(d, v, OFrc);
		case OSqt(d, v): unop(d, v, OSqt);
		case ORsq(d, v): unop(d, v, ORsq);
		case OPow(d, a, b): binop(d, a, b, OPow);
		case OLog(d, v): unop(d, v, OLog);
		case OExp(d, v): unop(d, v, OExp);
		case ONrm(d, v): unop(d, v, ONrm);
		case OSin(d, v): unop(d, v, OSin);
		case OCos(d, v): unop(d, v, OCos);
		case OCrs(d, a, b): binop(d, a, b, OCrs);
		case ODp3(d, a, b): binop(d, a, b, ODp3);
		case ODp4(d, a, b): binop(d, a, b, ODp4);
		case OAbs(d, v): unop(d, v, OAbs);
		case ONeg(d, v): unop(d, v, ONeg);
		case OSat(d, v): unop(d, v, OSat);
		case OM33(d, a, b): binop(d, a, b, OM33);
		case OM44(d, a, b): binop(d, a, b, OM44);
		case OM34(d, a, b): binop(d, a, b, OM34);
		case ODdx(d, v): unop(d, v, ODdx);
		case ODdy(d, v): unop(d, v, ODdy);
		case OIfe(_), OIne(_), OIfg(_), OIfl(_), OEls, OEif, OUnused, OKil(_):
			return -1;
		case OTex(_,a,tex):
			ra = regSign(a);
			rb = tex.index;
			return -1;
		case OSge(d, a, b): binop(d, a, b, OSge);
		case OSlt(d, a, b): binop(d, a, b, OSlt);
		case OSgn(d, v): unop(d, v, OSgn);
		case OSeq(d, a, b): binop(d, a, b, OSeq);
		case OSne(d, a, b): binop(d, a, b, OSne);
		}
		return (op.getIndex() << 26) | (ra << 13) | rb;
	}

	function getAssignedReg( op : Opcode ) {
		return switch( op ) {
		case OMov(r, _), ORcp(r, _), ORsq(r, _), OFrc(r, _), OSqt(r, _), OLog(r, _), OExp(r, _), ONrm(r, _), OSin(r, _), OCos(r, _), OAbs(r, _), ONeg(r, _), OSat(r, _), ODdx(r, _), ODdy(r, _): r;
		case OAdd(r, _, _), OSub(r, _, _), OMul(r, _, _), ODiv(r, _, _), OMin(r, _, _), OMax(r, _ , _), OPow(r, _, _), OCrs(r, _, _), ODp3(r, _, _), ODp4(r, _, _), OM33(r, _, _), OM44(r, _, _), OM34(r, _, _), OTex(r, _, _): r;
		case OIfe(_), OIne(_), OIfg(_), OIfl(_), OEls, OEif, OUnused, OKil(_), OSge(_), OSlt(_), OSgn(_), OSeq(_), OSne(_): null;
		}
	}

	function optiDup() {
		// optimize duplication of code
		var opIds = new Map();

		// use prevWrite to store our last opcode signature
		for( r in regs )
			if( r != null ) {
				r.prevWrite[0] = -1;
				r.prevWrite[1] = -1;
				r.prevWrite[2] = -1;
				r.prevWrite[3] = -1;
			}

		for( i in 0...code.length ) {
			var op1 = code[i];
			var sign = getSign(op1);

			inline function clearReg() {
				// clear previous operation from cache (register has been modified)
				var r = getAssignedReg(op1);
				if( r != null && r.t == RTemp ) {
					var ops = regs[r.index].prevWrite;
					var sw = r.swiz == null ? COMPS : r.swiz;
					for( c in sw ) {
						var id = ops[c.getIndex()];
						if( id != -1 ) opIds.remove(id);
						ops[c.getIndex()] = sign;
					}
				}
			}

			if( sign == -1 ) {
				clearReg();
				continue;
			}
			var prev = sign;
			while( true ) {
				var prev = opIds.get(sign);
				if( prev == null ) {
					clearReg();
					opIds.set(sign, i);
					break;
				}
				var op2 = code[prev];
				if( op1.getIndex() != op2.getIndex() ) {
					sign = sign * 1103515245 + 12345;
					continue;
				}

				var params1 = op1.getParameters();
				var params2 = op2.getParameters();
				var ok = true;

				// additional check
				if( !same(params1[1], params2[1]) )
					ok = false;
				else switch( op1 ) {
				case OTex(_):
					if( !sameTex(params1[2], params2[2]) )
						ok = false;
				default:
					if( !same(params1[2], params2[2]) )
						ok = false;
				}

				if( ok ) {
					var pos = i;
					code[i] = OMov(params1[0], params2[0]);
					changed = true;
					break;
				}
				sign = sign * 1103515245 + 12345;
			}
		}
	}

	function optiMat() {
		var XYZ = 36;
		var XYZW = 228;
		// group contiguous dp into matrix macros
		// should be purely cosmetic
		for( i in 0...code.length - 2 ) {
			switch( code[i] ) {
			// disable for Temps, since we can't swiz on [b.XYZ], and since we are not sure W is written (and it's rejected by AGAL!)
			case ODp3(dst, a, b) if( swizBits(dst) == 0 && swizBits(b) & 63 == XYZ && b.t != RTemp ):
				var sa = swizBits(a) & 63;
				switch( [code[i + 1], code[i + 2]] ) {
				case [ODp3(d2, a2, b2), ODp3(d3, a3, b3)]:
					if( same(dst, d2) && same(dst, d3) && same(a, a2) && same(a, a3) && swizBits(a2)&63 == sa && swizBits(a3)&63 == sa && dist(b, b2) == 1 && dist(b, b3) == 2 && swizBits(d2) == 1 && swizBits(d3) == 2 && swizBits(b2)&63 == XYZ && swizBits(b3)&63 == XYZ ) {
						var dst = dst.clone();
						dst.swiz = [X, Y, Z];
						code[i] = OM33(dst, a, noSwiz(b));
						code[i + 1] = OUnused;
						code[i + 2] = OUnused;
					}
				default:
				}
			case ODp4(dst, a, b) if( swizBits(dst) == 0 && swizBits(b) == XYZW ):
				var sa = swizBits(a);
				switch( [code[i + 1], code[i + 2]] ) {
				case [ODp4(d2, a2, b2), ODp4(d3, a3, b3)]:
					if( same(dst, d2) && same(dst, d3) && same(a, a2) && same(a, a3) && swizBits(a2) == sa && swizBits(a3) == sa && dist(b, b2) == 1 && dist(b, b3) == 2 && swizBits(d2) == 1 && swizBits(d3) == 2 && swizBits(b2) == XYZW && swizBits(b3) == XYZW ) {
						var m44 = false;
						if( i + 3 < code.length )
							switch( code[i + 3] ) {
							case ODp4(d4, a4, b4):
								if( same(dst, d4) && same(a, a4) && swizBits(a4) == sa && dist(b, b4) == 3 && swizBits(d4) == 3 && swizBits(b4) == XYZW )
									m44 = true;
							default:
							}
						var dst = dst.clone();
						dst.swiz = m44 ? null : [X,Y,Z];
						code[i] = (m44?OM44:OM34)(dst, sa == XYZW ? noSwiz(a) : a, noSwiz(b));
						code[i + 1] = OUnused;
						code[i + 2] = OUnused;
						if( m44 ) code[i + 3] = OUnused;
					}
				default:
				}
			default:
			}
		}
		while( code.remove(OUnused) )
			continue;
	}

	public function iter( op : Opcode, reg : Reg -> Bool -> Void ) {
		switch( op ) {
		case OUnused:
			// nothing
		case OKil(r):
			reg(r, false);
		case OMov(d, v):
			if( v.access != null )
				reg( new Reg(v.t, v.index, [v.access.comp]), false );
			else
				reg(v, false);
			reg(d, true);
		case OTex(d, v, _), ORcp(d, v), OFrc(d,v),OSqt(d,v), ORsq(d,v), OLog(d,v),OExp(d,v), ONrm(d,v), OSin(d,v), OCos(d,v), OAbs(d,v), ONeg(d,v), OSat(d,v), OSgn(d,v):
			reg(v,false);
			reg(d,true);
		case OAdd(d, a, b), OSub(d, a, b), OMul(d, a, b), ODiv(d, a, b), OMin(d, a, b), OMax(d, a, b),
			OPow(d, a, b), OCrs(d, a, b), ODp3(d, a, b), OSge(d, a, b), OSlt(d, a, b), OSne(d,a,b), OSeq(d,a,b), ODp4(d,a,b):
			reg(a,false);
			reg(b,false);
			reg(d,true);
		case OM33(d, a, b),  OM34(d, a, b):
			reg(a, false);
			reg(b, false);
			reg(offset(b, 1), false);
			reg(offset(b, 2), false);
			reg(d, true);
		case OM44(d, a, b):
			reg(a, false);
			reg(b, false);
			reg(offset(b, 1), false);
			reg(offset(b, 2), false);
			reg(offset(b, 3), false);
			reg(d, true);
		case OIne(a, b), OIfe(a, b), OIfg(a, b), OIfl(a, b):
			reg(a, false);
			reg(b, false);
		case ODdx(d, v), ODdy(d,v):
			reg(v, false);
			reg(d, true);
		case OEls, OEif:
		}
	}

	inline function map( mop : Opcode, r : Reg -> Bool -> Reg ) {
		inline function unop(d, v, op) {
			var v2 = r(v, false);
			var d2 = r(d, true);
			return if( v == v2 && d == d2 ) mop else op(d2,v2);
		}
		inline function binop(d, a, b, op) {
			var a2 = r(a, false);
			var b2 = r(b, false);
			var d2 = r(d, true);
			return if( a == a2 && b == b2 && d == d2 ) mop else op(d2, a2, b2);
		}
		inline function cond(a, b, op) {
			var a2 = r(a, false);
			var b2 = r(b, false);
			return if( a2 == a && b2 == b ) mop else op(a2, b2);
		}
		return switch( mop ) {
		case OMov(d, v): unop(d, v, OMov);
		case OAdd(d, a, b): binop(d, a, b, OAdd);
		case OSub(d, a, b): binop(d, a, b, OSub);
		case OMul(d, a, b): binop(d, a, b, OMul);
		case ODiv(d, a, b): binop(d, a, b, ODiv);
		case ORcp(d, v): unop(d, v, ORcp);
		case OMin(d, a, b): binop(d, a, b, OMin);
		case OMax(d, a, b): binop(d, a, b, OMax);
		case OFrc(d, v): unop(d, v, OFrc);
		case OSqt(d, v): unop(d, v, OSqt);
		case ORsq(d, v): unop(d, v, ORsq);
		case OPow(d, a, b): binop(d, a, b, OPow);
		case OLog(d, v): unop(d, v, OLog);
		case OExp(d, v): unop(d, v, OExp);
		case ONrm(d, v): unop(d, v, ONrm);
		case OSin(d, v): unop(d, v, OSin);
		case OCos(d, v): unop(d, v, OCos);
		case OCrs(d, a, b): binop(d, a, b, OCrs);
		case ODp3(d, a, b): binop(d, a, b, ODp3);
		case ODp4(d, a, b): binop(d, a, b, ODp4);
		case OAbs(d, v): unop(d, v, OAbs);
		case ONeg(d, v): unop(d, v, ONeg);
		case OSat(d, v): unop(d, v, OSat);
		case OM33(d, a, b): binop(d, a, b, OM33);
		case OM44(d, a, b): binop(d, a, b, OM44);
		case OM34(d, a, b): binop(d, a, b, OM34);
		case ODdx(d, v): unop(d, v, ODdx);
		case ODdy(d, v): unop(d, v, ODdy);
		case OIfe(a, b): cond(a, b, OIfe);
		case OIne(a, b): cond(a, b, OIne);
		case OIfg(a, b): cond(a, b, OIfg);
		case OIfl(a, b): cond(a, b, OIfl);
		case OEls: OEls;
		case OEif: OEif;
		case OUnused: OUnused;
		case OKil(v):
			OKil(r(v, false));
		case OTex(d, v, t):
			v = r(v, false);
			OTex(r(d, true), v, t);
		case OSge(d, a, b): binop(d, a, b, OSge);
		case OSlt(d, a, b): binop(d, a, b, OSlt);
		case OSgn(d, v): unop(d, v, OSgn);
		case OSeq(d, a, b): binop(d, a, b, OSeq);
		case OSne(d, a, b): binop(d, a, b, OSne);
		}
	}

	inline function rswiz( r : Reg, s : Array<C> ) : Reg {
		if( r.access != null ) throw "assert";
		var swiz = swiz(r);
		return new Reg(r.t, r.index, [for( s in s ) swiz[s.getIndex()]]);
	}

	inline function offset( r : Reg, n : Int ) : Reg {
		if( r.access != null ) throw "assert";
		return new Reg(r.t, r.index + n, r.swiz == null ? null : r.swiz.copy());
	}

}