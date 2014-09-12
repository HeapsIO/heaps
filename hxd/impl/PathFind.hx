package hxd.impl;

class PathFind {

	// 0 - unreachable
	// positive - dist+1 to reach
	// negative - -(dist+1) : collides but reachable

	var t : haxe.ds.Vector<Int>;
	var bits : Int;
	var init : Bool;
	var width : Int;
	var height : Int;

	public function new(width, height) {
		this.width = width;
		this.height = height;
		t = new haxe.ds.Vector<Int>(width * height);
		bits = 0;
		while( width >= 1 << bits )
			bits++;
	}

	public function clear() {
		for( i in 0...width * height )
			t[i] = 0;
	}

	public inline function build( x : Int, y : Int, collide : Int -> Int -> Bool ) {
		var tmp = new FastIO.FastIntIO();
		tmp.rec2dk(x, y, bits, function(x, y, k) {
			if( x < 0 || y < 0 || x >= width || y >= height ) return false;
			k++;
			var a = x + y * width;
			var p = t[a];
			if( p != 0 && Math.iabs(p) <= k ) return false;
			if( collide(x, y) ) {
				t[a] = -k;
				return k == 1;
			}
			t[a] = k;
			return true;
		});
	}

	public function getPath( x : Int, y : Int ) {
		var a = x + y * width;
		var k = Math.iabs(t[a]);
		if( k == 0 ) return null;
		var path = [];
		while( k > 1 ) {
			k--;
			if( x > 0 && t[a - 1] == k ) {
				x--;
				a--;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y > 0 && t[a - width] == k ) {
				y--;
				a-=width;
				path.push( { x:x, y:y } );
				continue;
			}
			if( x < width-1 && t[a + 1] == k ) {
				x++;
				a++;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y < height - 1 && t[a + width] == k ) {
				y++;
				a+=width;
				path.push( { x:x, y:y } );
				continue;
			}
			// target collides
			if( k != 1 ) throw "assert "+k;
			k = -1;
			if( x > 0 && t[a - 1] == k ) {
				x--;
				a--;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y > 0 && t[a - width] == k ) {
				y--;
				a-=width;
				path.push( { x:x, y:y } );
				continue;
			}
			if( x < width-1 && t[a + 1] == k ) {
				x++;
				a++;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y < height - 1 && t[a + width] == k ) {
				y++;
				a+=width;				path.push( { x:x, y:y } );
				continue;
			}
			throw "assert";
		}
		return path;
	}

}