package hxsl;
import format.agal.Data;

private class RegInfos {
	public var index : Int;
	public var values : Array<Reg>;
	public var prevRead : Array<Int>;
	public var reads : Array<Int>;
	public var writes : Array<Int>;
	public var live : Array<Int>;
	public function new(i) {
		index = i;
		live = [];
	}
}

class AgalOptim {

	static var ALL = [X, Y, Z, W];

	var code : Array<Opcode>;
	var codePos : Int;
	var regs : Array<RegInfos>;
	var flag : Bool;
	var tempCount = 0;
	var sizeReq = 1;
	var markRead = true;
	var changed : Bool;

	public function new() {
	}

	public function optimize( d : Data ) : Data {
		code = d.code.copy();

		while( true ) {
			changed = false;
			buildLive();
			splice();
			if( changed ) continue;
			optiMov();
			if( changed ) continue;
			break;
		}

		for( r in regs )
			if( r != null )
				r.index = -1;

		code = [for( o in code ) if( o != OUnused ) map(o, remap)];

		return {
			version : d.version,
			fragmentShader : d.fragmentShader,
			code : code,
		};
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
			case OMov(r1, r2):
				var i1 = getReg(r1);
				var i2 = getReg(r2);
				if( i1 == null || i2 == null ) continue;
				var sw1 = swiz(r1);
				var sw2 = swiz(r2);
				var rewrite = true;
				for( i in 0...sw1.length ) {
					var k2 = sw2[i].getIndex();

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
						return { t : RTemp, index : r1.index, swiz : sout, access : null };
					});
					code[wt] = op;
				}
				code[codePos] = OUnused;
				changed = true;

			default:
			}
		}
	}

	function buildLive() {
		regs = [];
		for( i in 0...code.length ) {
			codePos = i;
			code[i] = switch( code[i] ) {
			case OMov(r1, r2):
				checkMov(r1, r2);
			case op:
				map(op, checkValue);
			}
		}
	}

	function remap( r : Reg, _ ) {
		var inf = getReg(r);
		if( inf == null ) return r;
		if( inf.index < 0 ) {
			inf.index = tempCount;
			tempCount += sizeReq;
		}
		return { t : RTemp, index : inf.index, swiz : r.swiz, access : null };
	}

	function checkMov( r1 : Reg, r2 : Reg ) {

		r2 = checkValue(r2, false);

		var inf = getReg(r1);
		if( inf == null )
			return OMov(r1, r2);
		var swiz = swiz(r1);
		var swiz2 = this.swiz(r2);
		if( inf.values == null ) inf.values = [];
		for( i in 0...swiz.length ) {
			var s = swiz[i];
			inf.values[s.getIndex()] = { t : r2.t, index : r2.index, swiz : [swiz2[i]], access : null };
			inf.writes[s.getIndex()] = codePos;
		}
		return OMov(r1, r2);
	}

	inline function swiz( r : Reg ) {
		var s = r.swiz;
		if( s == null ) s = ALL;
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
			if( r.swiz == null ) {
				inf.values = null;
				for( i in 0...4 )
					inf.writes[i] = codePos;
			} else {
				for( s in r.swiz ) {
					if( inf.values != null )
						inf.values[s.getIndex()] = { t : RTemp, index : r.index, swiz : [s], access : null };
					inf.writes[s.getIndex()] = codePos;
				}
			}
			return r;
		}
		if( inf.values == null || sizeReq > 1 ) {
			read(r);
			return r;
		}
		var swiz = swiz(r);
		var reg = { t : null, index : 0, swiz : [], access : null };
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

	function read( r : Reg ) {
		if( !markRead )
			return;
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
			inf = new RegInfos(r.index);
			inf.values = null;
			inf.prevRead = [ -1, -1, -1, -1];
			inf.reads = [-1, -1, -1, -1];
			inf.writes = [ -1, -1, -1, -1];
			regs[r.index] = inf;
		}
		return inf;
	}

	function iter( op : Opcode, reg : Reg -> Bool -> Void ) {
		switch( op ) {
		case OUnused:
			// nothing
		case OKil(r):
			reg(r, false);
		case OMov(d, v):
			reg(v, false);
			reg(d, true);
		case OTex(d, v, _), ORcp(d, v), OFrc(d,v),OSqt(d,v), ORsq(d,v), OLog(d,v),OExp(d,v), ONrm(d,v), OSin(d,v), OCos(d,v), OAbs(d,v), ONeg(d,v), OSat(d,v):
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
		}
	}

	function map( op : Opcode, r : Reg -> Bool -> Reg ) {
		inline function unop(d, v, op) {
			v = r(v, false);
			return op(r(d, true), v);
		}
		inline function binop(d, a, b, op) {
			a = r(a, false);
			b = r(b, false);
			return op(r(d, true), a, b);
		}
		return switch( op ) {
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
		case OM33(d, a, b):
			a = r(a, false);
			sizeReq = 3;
			b = r(b, false);
			sizeReq = 1;
			OM33(r(d, true), a, b);
		case OM44(d, a, b):
			a = r(a, false);
			sizeReq = 4;
			b = r(b, false);
			sizeReq = 1;
			OM44(r(d, true), a, b);
		case OM34(d, a, b):
			a = r(a, false);
			sizeReq = 3;
			b = r(b, false);
			sizeReq = 1;
			OM34(r(d, true), a, b);
		case OKil(v):
			OKil(r(v, false));
		case OTex(d, v, t):
			v = r(v, false);
			OTex(r(d, true), v, t);
		case OSge(d, a, b): binop(d, a, b, OSge);
		case OSlt(d, a, b): binop(d, a, b, OSlt);
		case OUnused: OUnused;
		case OSeq(d, a, b): binop(d, a, b, OSeq);
		case OSne(d, a, b): binop(d, a, b, OSne);
		}
	}

	inline function offset( r : Reg, n : Int ) {
		if( r.access != null ) throw "assert";
		return { t : r.t, index : r.index + n, swiz : r.swiz == null ? null : r.swiz.copy(), access : null };
	}

}