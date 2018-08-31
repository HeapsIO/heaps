// NanoJPEG -- KeyJ's Tiny Baseline JPEG Decoder
// version 1.3 (2012-03-05)
// by Martin J. Fiedler <martin.fiedler@gmx.net>
//
// This software is published under the terms of KeyJ's Research License,
// version 0.2. Usage of this software is subject to the following conditions:
// 0. There's no warranty whatsoever. The author(s) of this software can not
//	be held liable for any damages that occur when using this software.
// 1. This software may be used freely for both non-commercial and commercial
//	purposes.
// 2. This software may be redistributed freely as long as no fees are charged
//	for the distribution and this license information is included.
// 3. This software may be modified freely except for this license information,
//	which must not be changed in any way.
// 4. If anything other than configuration, indentation or comments have been
//	altered in the code, the original author(s) must receive a copy of the
//	modified code.
/* Ported to Haxe by Nicolas Cannasse */
package hxd.res;

enum Filter {
	Fast;
	Chromatic;
}

private abstract FastBytes(haxe.io.Bytes) {
	public inline function new(b:haxe.io.Bytes) {
		this = b;
	}
	@:arrayAccess inline function get(i:Int) {
		return this.get(i);
	}
	@:arrayAccess inline function set(i:Int,v) {
		this.set(i,v);
	}
}

private class Component {
	public var cid : Int;
	public var ssx : Int;
	public var ssy : Int;
	public var width : Int;
	public var height : Int;
	public var stride : Int;
	public var qtsel : Int;
	public var actabsel : Int;
	public var dctabsel : Int;
	public var dcpred : Int;
	public var pixels : haxe.io.Bytes;
	public function new() {
	}
}

@:noDebug
class NanoJpeg {

	static inline var BLOCKSIZE = 64;

	var bytes : haxe.io.Bytes;
	var pos : Int;
	var size : Int;
	var length : Int;

	var width : Int;
	var height : Int;
	var ncomp : Int;
	var comps : haxe.ds.Vector<Component>;
	var counts : haxe.ds.Vector<Int>;
	var qtab : haxe.ds.Vector<haxe.ds.Vector<Int>>;
	var qtused : Int;
	var qtavail : Int;
	var vlctab : haxe.ds.Vector<haxe.io.Bytes>;
	var block : haxe.ds.Vector<Int>;
	var njZZ : haxe.ds.Vector<Int>;
	var progressive : Bool;

	var mbsizex : Int;
	var mbsizey : Int;
	var mbwidth : Int;
	var mbheight : Int;
	var rstinterval : Int;
	var buf : Int;
	var bufbits : Int;

	var pixels : haxe.io.Bytes;
	var filter : Filter;

	function new() {
		comps = haxe.ds.Vector.fromArrayCopy([
			new Component(),
			new Component(),
			new Component(),
		]);
		qtab = haxe.ds.Vector.fromArrayCopy([
			new haxe.ds.Vector(64),
			new haxe.ds.Vector(64),
			new haxe.ds.Vector(64),
			new haxe.ds.Vector(64),
		]);
		counts = new haxe.ds.Vector(16);
		block = new haxe.ds.Vector(BLOCKSIZE);
		njZZ = haxe.ds.Vector.fromArrayCopy([0, 1, 8, 16, 9, 2, 3, 10, 17, 24, 32, 25, 18, 11, 4, 5, 12, 19, 26, 33, 40, 48, 41, 34, 27, 20, 13, 6, 7, 14, 21, 28, 35, 42, 49, 56, 57, 50, 43, 36, 29, 22, 15, 23, 30, 37, 44, 51, 58, 59, 52, 45, 38, 31, 39, 46, 53, 60, 61, 54, 47, 55, 62, 63 ]);
		vlctab = haxe.ds.Vector.fromArrayCopy([null, null, null, null, null, null, null, null]);
	}

	inline function alloc( nbytes : Int ) {
		return haxe.io.Bytes.alloc(nbytes);
	}

	inline function free( bytes : haxe.io.Bytes ) {
	}

	function njInit( bytes, pos, size, filter ) {
		this.bytes = bytes;
		this.pos = pos;
		this.filter = filter == null ? Chromatic : filter;
		if( size < 0 ) size = bytes.length - pos;
		for( i in 0...4 )
			if( vlctab[i] == null )
				vlctab[i] = alloc(1 << 17);
		this.size = size;
		qtused = 0;
		qtavail = 0;
		rstinterval = 0;
		length = 0;
		buf = 0;
		bufbits = 0;
		progressive = false;
		for( i in 0...3 )
			comps[i].dcpred = 0;
	}

	function cleanup() {
		bytes = null;
		for( c in comps )
			if( c.pixels != null ) {
				free(c.pixels);
				c.pixels = null;
			}
		for( i in 0...8 )
			if( vlctab[i] != null ) {
				free(vlctab[i]);
				vlctab[i] = null;
			}
	}

	inline function njSkip(count) {
		pos += count;
		size -= count;
		length -= count;
		syntax( size < 0 );
	}

	inline function syntax( flag ) {
		#if debug
		if( flag ) throw "Invalid JPEG file";
		#end
	}

	inline function get(p) {
		return bytes.get(pos + p);
	}

	inline function njDecode16(p) {
		return (get(p) << 8) | get(p + 1);
	}

	inline function njByteAlign() {
		bufbits &= 0xF8;
	}

	function njShowBits(bits) {
		if( bits == 0 ) return 0;
		while( bufbits < bits ) {
			if(	size <= 0 ) {
				buf = (buf << 8) | 0xFF;
				bufbits += 8;
				continue;
			}
			var newbyte = get(0);
			pos++;
			size--;
			bufbits += 8;
			buf = (buf << 8) | newbyte;
			if( newbyte == 0xFF ) {
				syntax(size == 0);
				var marker = get(0);
				pos++;
				size--;
				switch (marker) {
				case 0x00, 0xFF:
				case 0xD9:
					size = 0;
				default:
					syntax( marker & 0xF8 != 0xD0 );
					buf = (buf << 8) | marker;
					bufbits += 8;
				}
			}
		}
		return (buf >> (bufbits - bits)) & ((1 << bits) - 1);
	}

	inline function njSkipBits(bits) {
		if( bufbits < bits )
			njShowBits(bits);
		bufbits -= bits;
	}

	inline function njGetBits(bits) {
		var r = njShowBits(bits);
		bufbits -= bits;
		return r;
	}

	inline function njDecodeLength() {
		syntax( size < 2 );
		length = njDecode16(0);
		syntax( length > size );
		njSkip(2);
	}

	inline function njSkipMarker() {
		njDecodeLength();
		njSkip(length);
	}

	function njDecodeSOF() {
		njDecodeLength();
		syntax( length < 9 );
		if( get(0) != 8 ) notSupported();
		height = njDecode16(1);
		width = njDecode16(3);
		ncomp = get(5);
		njSkip(6);
		switch( ncomp ) {
		case 1,3:
		default:
			notSupported();
		}
		syntax( length < ncomp * 3 );

		var ssxmax = 0, ssymax = 0;
		for( i in 0...ncomp ) {
			var c = comps[i];
			c.cid = get(0);
			c.ssx = get(1) >> 4;
			syntax(c.ssx == 0);
			if( c.ssx & (c.ssx - 1) != 0 ) notSupported();  // non-power of two
			c.ssy = get(1) & 15;
			syntax( c.ssy == 0 );
			if( c.ssy & (c.ssy - 1) != 0 ) notSupported();  // non-power of two
			c.qtsel = get(2);
			syntax(c.qtsel & 0xFC != 0 );
			njSkip(3);
			qtused |= 1 << c.qtsel;
			if (c.ssx > ssxmax) ssxmax = c.ssx;
			if (c.ssy > ssymax) ssymax = c.ssy;
		}
		if( ncomp == 1 ) {
			var c = comps[0];
			c.ssx = c.ssy = ssxmax = ssymax = 1;
		}
		mbsizex = ssxmax << 3;
		mbsizey = ssymax << 3;
		mbwidth = Std.int((width + mbsizex - 1) / mbsizex);
		mbheight = Std.int((height + mbsizey - 1) / mbsizey);
		for( i in 0...ncomp ) {
			var c = comps[i];
			c.width = Std.int((width * c.ssx + ssxmax - 1) / ssxmax);
			c.stride = (c.width + 7) & 0x7FFFFFF8;
			c.height = Std.int((height * c.ssy + ssymax - 1) / ssymax);
			c.stride = Std.int(mbwidth * mbsizex * c.ssx / ssxmax);
			if( (c.width < 3 && c.ssx != ssxmax) || (c.height < 3 && c.ssy != ssymax) ) notSupported();
			c.pixels = alloc(c.stride * Std.int(mbheight * mbsizey * c.ssy / ssymax));
		}
		njSkip(length);
	}

	function njDecodeDQT() {
		njDecodeLength();
		while( length >= 65 ) {
			var i = get(0);
			syntax( i & 0xFC != 0 );
			qtavail |= 1 << i;
			var t = qtab[i];
			for( k in 0...64 )
				t[k] = get(k + 1);
			njSkip(65);
		}
		syntax( length != 0 );
	}

	function njDecodeDHT() {
		njDecodeLength();
		while( length >= 17 ) {
			var i = get(0);
			syntax( i & 0xEC != 0 );
			i = ((i >> 4) & 1) | ((i & 3) << 1);  // combined DC/AC + tableid value (put DC/AC in lower bit)
			for( codelen in 0...16)
				counts[codelen] = get(codelen+1);
			njSkip(17);
			var vlc = vlctab[i];
			var vpos = 0;
			var remain = 65536, spread = 65536;
			for( codelen in 1...17 ) {
				spread >>= 1;
				var currcnt = counts[codelen - 1];
				if( currcnt == 0 ) continue;
				syntax( length < currcnt );
				remain -= currcnt << (16 - codelen);
				syntax( remain < 0 );
				for( i in 0...currcnt ) {
					var code = get(i);
					for( j in 0...spread ) {
						vlc.set(vpos++, codelen);
						vlc.set(vpos++, code);
					}
				}
				njSkip(currcnt);
			}
			while( remain-- != 0 ) {
				vlc.set(vpos, 0);
				vpos += 2;
			}
		}
		syntax( length != 0 );
	}

	function njDecodeDRI() {
		njDecodeLength();
		syntax(length < 2);
		rstinterval = njDecode16(0);
		njSkip(length);
	}


	var vlcCode : Int;

	inline function njGetVLC( vlc : haxe.io.Bytes ) {
		var value = njShowBits(16);
		var bits = vlc.get(value<<1);
		syntax( bits == 0 );
		njSkipBits(bits);
		value = vlc.get((value<<1) | 1);
		vlcCode = value;
		bits = value & 15;
		if( bits == 0 ) return 0;
		value = njGetBits(bits);
		if (value < (1 << (bits - 1)))
			value += ((-1) << bits) + 1;
		return value;
	}

	static inline var W1 = 2841;
	static inline var W2 = 2676;
	static inline var W3 = 2408;
	static inline var W5 = 1609;
	static inline var W6 = 1108;
	static inline var W7 = 565;

	inline function njRowIDCT( bp ) {
		var x0, x1, x2, x3, x4, x5, x6, x7, x8;
		if( ((x1 = block[bp+4] << 11)
		| (x2 = block[bp+6])
		| (x3 = block[bp+2])
		| (x4 = block[bp+1])
		| (x5 = block[bp+7])
		| (x6 = block[bp+5])
		| (x7 = block[bp+3])) == 0 ) {
			block[bp+0] = block[bp+1] = block[bp+2] = block[bp+3] = block[bp+4] = block[bp+5] = block[bp+6] = block[bp+7] = block[bp+0] << 3;
			return;
		}
		x0 = (block[bp+0] << 11) + 128;
		x8 = W7 * (x4 + x5);
		x4 = x8 + (W1 - W7) * x4;
		x5 = x8 - (W1 + W7) * x5;
		x8 = W3 * (x6 + x7);
		x6 = x8 - (W3 - W5) * x6;
		x7 = x8 - (W3 + W5) * x7;
		x8 = x0 + x1;
		x0 -= x1;
		x1 = W6 * (x3 + x2);
		x2 = x1 - (W2 + W6) * x2;
		x3 = x1 + (W2 - W6) * x3;
		x1 = x4 + x6;
		x4 -= x6;
		x6 = x5 + x7;
		x5 -= x7;
		x7 = x8 + x3;
		x8 -= x3;
		x3 = x0 + x2;
		x0 -= x2;
		x2 = (181 * (x4 + x5) + 128) >> 8;
		x4 = (181 * (x4 - x5) + 128) >> 8;
		block[bp+0] = (x7 + x1) >> 8;
		block[bp+1] = (x3 + x2) >> 8;
		block[bp+2] = (x0 + x4) >> 8;
		block[bp+3] = (x8 + x6) >> 8;
		block[bp+4] = (x8 - x6) >> 8;
		block[bp+5] = (x0 - x4) >> 8;
		block[bp+6] = (x3 - x2) >> 8;
		block[bp+7] = (x7 - x1) >> 8;
	}

	inline function njColIDCT( bp, out : FastBytes, po, stride ) {
		var x0, x1, x2, x3, x4, x5, x6, x7, x8;
		if ( ((x1 = block[bp+8*4] << 8)
			| (x2 = block[bp+8*6])
			| (x3 = block[bp+8*2])
			| (x4 = block[bp+8*1])
			| (x5 = block[bp+8*7])
			| (x6 = block[bp+8*5])
			| (x7 = block[bp+8*3])) == 0 )
		{
			x1 = njClip(((block[bp+0] + 32) >> 6) + 128);
			for( i in 0...8 ) {
				out[po] = x1;
				po += stride;
			}
			return;
		}
		x0 = (block[bp+0] << 8) + 8192;
		x8 = W7 * (x4 + x5) + 4;
		x4 = (x8 + (W1 - W7) * x4) >> 3;
		x5 = (x8 - (W1 + W7) * x5) >> 3;
		x8 = W3 * (x6 + x7) + 4;
		x6 = (x8 - (W3 - W5) * x6) >> 3;
		x7 = (x8 - (W3 + W5) * x7) >> 3;
		x8 = x0 + x1;
		x0 -= x1;
		x1 = W6 * (x3 + x2) + 4;
		x2 = (x1 - (W2 + W6) * x2) >> 3;
		x3 = (x1 + (W2 - W6) * x3) >> 3;
		x1 = x4 + x6;
		x4 -= x6;
		x6 = x5 + x7;
		x5 -= x7;
		x7 = x8 + x3;
		x8 -= x3;
		x3 = x0 + x2;
		x0 -= x2;
		x2 = (181 * (x4 + x5) + 128) >> 8;
		x4 = (181 * (x4 - x5) + 128) >> 8;
		out[po] = njClip(((x7 + x1) >> 14) + 128);  po += stride;
		out[po] = njClip(((x3 + x2) >> 14) + 128);  po += stride;
		out[po] = njClip(((x0 + x4) >> 14) + 128);  po += stride;
		out[po] = njClip(((x8 + x6) >> 14) + 128);  po += stride;
		out[po] = njClip(((x8 - x6) >> 14) + 128);  po += stride;
		out[po] = njClip(((x0 - x4) >> 14) + 128);  po += stride;
		out[po] = njClip(((x3 - x2) >> 14) + 128);  po += stride;
		out[po] = njClip(((x7 - x1) >> 14) + 128);
	}

	function njDecodeBlock( c : Component, po ) {
		var out = new FastBytes(c.pixels);
		var value, coef = 0;
		for( i in 0...BLOCKSIZE )
			block[i] = 0;
		c.dcpred += njGetVLC(vlctab[c.dctabsel]);
		var qt = qtab[c.qtsel];
		var at = vlctab[c.actabsel];
		block[0] = c.dcpred * qt[0];
		do {
			value = njGetVLC(at);
			if( vlcCode == 0 ) break;  // EOB
			syntax( vlcCode & 0x0F == 0 && vlcCode != 0xF0 );
			coef += (vlcCode >> 4) + 1;
			syntax( coef > 63 );
			block[njZZ[coef]] = value * qt[coef];
		} while (coef < 63);
		for( coef in 0...8 )
			njRowIDCT(coef * 8);
		for( coef in 0...8 )
			njColIDCT(coef, out, coef + po, c.stride);
	}

	function notSupported() {
		throw "This JPG file is not supported";
	}

	function njDecodeScan() {
		njDecodeLength();
		syntax( length < 4 + 2 * ncomp );
		if( get(0) != ncomp ) notSupported();
		njSkip(1);
		for( i in 0...ncomp ) {
			var c = comps[i];
			syntax(get(0) != c.cid);
			syntax(get(1) & 0xEC != 0);
			c.dctabsel = (get(1) >> 4) << 1;
			c.actabsel = ((get(1) & 3) << 1) | 1;
			njSkip(2);
		}
		var start = get(0);
		var count = get(1);
		var other = get(2);
		if( (!progressive && start != 0) || (count != 63 - start) || other != 0 ) notSupported();
		njSkip(length);

		var mbx = 0, mby = 0;
		var rstcount = rstinterval, nextrst = 0;
		while( true ) {
			for( i in 0...ncomp ) {
				var c = comps[i];
				for( sby in 0...c.ssy )
					for( sbx in 0...c.ssx )
						njDecodeBlock(c, ((mby * c.ssy + sby) * c.stride + mbx * c.ssx + sbx) << 3);
			}
			if( ++mbx >= mbwidth ) {
				mbx = 0;
				if( ++mby >= mbheight ) break;
			}
			if( rstinterval != 0 && --rstcount == 0 ) {
				njByteAlign();
				var i = njGetBits(16);
				syntax( i & 0xFFF8 != 0xFFD0 || i & 7 != nextrst );
				nextrst = (nextrst + 1) & 7;
				rstcount = rstinterval;
				for( i in 0...3 )
					comps[i].dcpred = 0;
			}
		}
	}


	static inline var CF4A = -9;
	static inline var CF4B = 111;
	static inline var CF4C = 29;
	static inline var CF4D = -3;
	static inline var CF3A = 28;
	static inline var CF3B = 109;
	static inline var CF3C = -9;
	static inline var CF3X = 104;
	static inline var CF3Y = 27;
	static inline var CF3Z = -3;
	static inline var CF2A = 139;
	static inline var CF2B = -11;
	static inline function CF(x) return njClip(((x) + 64) >> 7);

	inline static function njClip(x) {
		return x < 0 ? 0 : x > 0xFF ? 0xFF : x;
	}

	function njUpsampleH( c : Component ) {
		var xmax = c.width - 3;
		//unsigned char *out, *lin, *lout;
		//int x, y;
		var cout = alloc((c.width * c.height) << 1);
		var lout = new FastBytes(cout);
		var lin = new FastBytes(c.pixels);
		var pi = 0, po = 0;
		for( y in 0...c.height ) {
			lout[po] = CF(CF2A * lin[pi] + CF2B * lin[pi+1]);
			lout[po+1] = CF(CF3X * lin[pi] + CF3Y * lin[pi+1] + CF3Z * lin[pi+2]);
			lout[po+2] = CF(CF3A * lin[pi] + CF3B * lin[pi+1] + CF3C * lin[pi+2]);
			for( x in 0...xmax ) {
				lout[po + (x << 1) + 3] = CF(CF4A * lin[pi+x] + CF4B * lin[pi + x + 1] + CF4C * lin[pi + x + 2] + CF4D * lin[pi + x + 3]);
				lout[po + (x << 1) + 4] = CF(CF4D * lin[pi+x] + CF4C * lin[pi + x + 1] + CF4B * lin[pi + x + 2] + CF4A * lin[pi + x + 3]);
			}
			pi += c.stride;
			po += c.width << 1;
			lout[po-3] = CF(CF3A * lin[pi-1] + CF3B * lin[pi-2] + CF3C * lin[pi-3]);
			lout[po-2] = CF(CF3X * lin[pi-1] + CF3Y * lin[pi-2] + CF3Z * lin[pi-3]);
			lout[po-1] = CF(CF2A * lin[pi-1] + CF2B * lin[pi-2]);
		}
		c.width <<= 1;
		c.stride = c.width;
		free(c.pixels);
		c.pixels = cout;
	}


	function njUpsampleV( c : Component ) {
		var w = c.width, s1 = c.stride, s2 = s1 + s1;
		var out = alloc((c.width * c.height) << 1);
		var pi = 0, po = 0;
		var cout = new FastBytes(out);
		var cin = new FastBytes(c.pixels);
		for( x in 0...w ) {
			pi = po = x;
			cout[po] = CF(CF2A * cin[pi] + CF2B * cin[pi+s1]);  po += w;
			cout[po] = CF(CF3X * cin[pi] + CF3Y * cin[pi+s1] + CF3Z * cin[pi+s2]);  po += w;
			cout[po] = CF(CF3A * cin[pi] + CF3B * cin[pi+s1] + CF3C * cin[pi+s2]);  po += w;
			pi += s1;
			for( y in 0...c.height-2 ) {
				cout[po] = CF(CF4A * cin[pi-s1] + CF4B * cin[pi] + CF4C * cin[pi+s1] + CF4D * cin[pi+s2]);  po += w;
				cout[po] = CF(CF4D * cin[pi-s1] + CF4C * cin[pi] + CF4B * cin[pi+s1] + CF4A * cin[pi+s2]);  po += w;
				pi += s1;
			}
			pi += s1;
			cout[po] = CF(CF3A * cin[pi] + CF3B * cin[pi-s1] + CF3C * cin[pi-s2]);  po += w;
			cout[po] = CF(CF3X * cin[pi] + CF3Y * cin[pi-s1] + CF3Z * cin[pi-s2]);  po += w;
			cout[po] = CF(CF2A * cin[pi] + CF2B * cin[pi-s1]);
		}
		c.height <<= 1;
		c.stride = c.width;
		free(c.pixels);
		c.pixels = out;
	}

	function njUpsample( c : Component ) {
		var xshift = 0, yshift = 0;
		while( c.width < width ) { c.width <<= 1; ++xshift; }
		while( c.height < height ) { c.height <<= 1; ++yshift; }
		var out = alloc(c.width * c.height);
		var lin = new FastBytes(c.pixels);
		var pout = 0;
		#if flash
		var dat = out.getData();
		if( dat.length < 1024 ) dat.length = 1024;
		flash.Memory.select(dat);
		inline function write(pos, v) {
			flash.Memory.setByte(pos, v);
		}
		#else
		var lout = new FastBytes(out);
		inline function write(pos, v) {
			lout[pos] = v;
		}
		#end
		for( y in 0...c.height ) {
			var pin = (y >> yshift) * c.stride;
			for( x in 0...c.width )
				write(pout++, lin[(x >> xshift) + pin]);
		}
		c.stride = c.width;
		free(c.pixels);
		c.pixels = out;
	}

	function njConvert() {
		for( i in 0...ncomp ) {
			var c = comps[i];
			switch( filter ) {
			case Fast:
				if( c.width < width || c.height < height )
					njUpsample(c);
			case Chromatic:
				while( c.width < width || c.height < height ) {
					if( c.width < width ) njUpsampleH(c);
					if( c.height < height ) njUpsampleV(c);
				}
			}
			if( c.width < width || c.height < height ) throw "assert";
		}
		var pixels = alloc(width * height * 4);
		if( ncomp == 3 ) {
			// convert to RGB
			var py = new FastBytes(comps[0].pixels);
			var pcb = new FastBytes(comps[1].pixels);
			var pcr = new FastBytes(comps[2].pixels);
			#if flash
			var dat = pixels.getData();
			if( dat.length < 1024 ) dat.length = 1024;
			flash.Memory.select(dat);
			inline function write(out, c) {
				flash.Memory.setByte(out, c);
			}
			#else
			var pix = new FastBytes(pixels);
			inline function write(out, c) {
				pix[out] = c;
			}
			#end
			var k1 = 0, k2 = 0, k3 = 0, out = 0;
			for( yy in 0...height ) {
				for( x in 0...width ) {
					var y = py[k1++] << 8;
					var cb = pcb[k2++] - 128;
					var cr = pcr[k3++] - 128;
					var r = njClip((y + 359 * cr + 128) >> 8);
					var g = njClip((y -  88 * cb - 183 * cr + 128) >> 8);
					var b = njClip((y + 454 * cb + 128) >> 8);
					write(out++, b);
					write(out++, g);
					write(out++, r);
					write(out++, 0xFF);
				}
				k1 += comps[0].stride - width;
				k2 += comps[1].stride - width;
				k3 += comps[2].stride - width;
			}
		} else {
			// grayscale -> only remove stride
			throw "TODO";
			/*
			unsigned char *pin = &nj.comp[0].pixels[nj.comp[0].stride];
			unsigned char *pout = &nj.comp[0].pixels[nj.comp[0].width];
			int y;
			for (y = nj.comp[0].height - 1;  y;  --y) {
				njCopyMem(pout, pin, nj.comp[0].width);
				pin += nj.comp[0].stride;
				pout += nj.comp[0].width;
			}
			nj.comp[0].stride = nj.comp[0].width;
			*/
		}
		return pixels;
	}

	function njDecode() {
		if( size < 2 || get(0) != 0xFF || get(1) != 0xD8 ) throw "This file is not a JPEG";
		njSkip(2);
		while( true ) {
			syntax( size < 2 || get(0) != 0xFF );
			njSkip(2);
			switch( get(-1) ) {
			case 0xC0:
				njDecodeSOF();
			case 0xC2:
				progressive = true;
				if( progressive ) throw "Unsupported progressive JPG";
				for( i in 4...8 )
					if( vlctab[i] == null )
						vlctab[i] = alloc(1 << 17);
				njDecodeSOF();
			case 0xDB: njDecodeDQT();
			case 0xC4: njDecodeDHT();
			case 0xDD: njDecodeDRI();
			case 0xDA:
				njDecodeScan();
				break; // DONE
			case 0xFE: njSkipMarker(); // comment
			case 0xC3: throw "Unsupported lossless JPG";
			default:
				switch( get( -1) & 0xF0 ) {
				case 0xE0:
					njSkipMarker();
				case 0xC0:
					throw "Unsupported jpeg type " + (get( -1) & 0xF);
				default:
					throw "Unsupported jpeg tag 0x" + StringTools.hex(get( -1), 2);
				}
			}
		}
		var pixels = njConvert();
		cleanup();
		return { pixels : pixels, width : width, height : height };
	}

	static var inst : NanoJpeg = null;
	public static function decode( bytes : haxe.io.Bytes, ?filter, position : Int = 0, size : Int = -1 ) {
		if( inst == null ) inst = new NanoJpeg();
		inst.njInit(bytes, position, size, filter);
		return inst.njDecode();
	}

}
