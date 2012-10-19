// Parker-Miller-Carta LCG


class Rand {

	var seed : Float;

	public function new( seed : Int ) {
		this.seed = hash(((seed < 0) ? -seed : seed) + 151);
	}

	public static function hash(n) {
		for( i in 0...5 ) {
			n ^= (n << 7) & 0x2b5b2500;
			n ^= (n << 15) & 0x1b8b0000;
			n ^= n >>> 16;
			n &= 0x3FFFFFFF;
			var h = 5381;
			h = (h << 5) + h + (n & 0xFF);
			h = (h << 5) + h + ((n >> 8) & 0xFF);
			h = (h << 5) + h + ((n >> 16) & 0xFF);
			h = (h << 5) + h + (n >> 24);
			n = h & 0x3FFFFFFF;
		}
		return n;
	}

	public inline function random( n ) {
		return int() % n;
	}

	public inline function rand() {
		// we can't use a divider > 16807 or else two consecutive seeds
		// might generate a similar float
		return (int() % 10007) / 10007.0;
	}

	inline function int() : Int {
		return Std.int(seed = (seed * 16807.0) % 2147483647.0) & 0x3FFFFFFF;
	}

}
