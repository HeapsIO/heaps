package hxd;

class Rand {

	var seed : Int;
	var seed2 : Int;

	public function new( seed : Int ) {
		init(seed);
	}

	public function init(seed : Int) {
		this.seed = seed;
		this.seed2 = hash(seed);
		if( this.seed == 0 ) this.seed = 1;
		if( this.seed2 == 0 ) this.seed2 = 1;
	}

	// this is the Murmur3 hashing function which has both excellent distribution and good randomness
	public static function hash(n, seed = 5381) {
		return inlineHash(n, seed);
	}

	public static inline function inlineHash(n:Int, seed:Int) : Int {
		var n : haxe.Int32 = n;
		n *= 0xcc9e2d51;
		n = (n << 15) | (n >>> 17);
		n *= 0x1b873593;
		var h : haxe.Int32 = seed;
		h ^= n;
		h = (h << 13) | (h >>> 19);
		h = h*5 + 0xe6546b64;
		h ^= h >> 16;
		h *= 0x85ebca6b;
		h ^= h >> 13;
		h *= 0xc2b2ae35;
		h ^= h >> 16;
		return h;
	}

	public inline function random( n ) {
		return uint() % n;
	}

	public inline function shuffle<T>( a : Array<T> ) {
		var len = a.length;
		for( i in 0...len ) {
			var x = random(len);
			var y = random(len);
			var tmp = a[x];
			a[x] = a[y];
			a[y] = tmp;
		}
	}

	public inline function rand() {
		// we can't use a divider > 16807 or else two consecutive seeds
		// might generate a similar float
		return (uint() % 10007) / 10007.0;
	}

	public inline function srand(scale=1.0) {
		return ((int() % 10007) / 10007.0) * scale;
	}

	// this is two Marsaglia Multiple-with-Carry (MWC) generators combined
	inline function int() : Int {
		seed = 36969 * (seed & 0xFFFF) + (seed >> 16);
		seed2 = 18000 * (seed2 & 0xFFFF) + (seed2 >> 16);
		return ((seed<<16) + seed2) #if js | 0 #end;
	}

	inline function uint() {
		return int() & 0x3FFFFFFF;
	}

}
