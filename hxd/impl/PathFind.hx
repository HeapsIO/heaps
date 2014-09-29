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
			if( p != 0 ) return false;
			if( collide(x, y) ) {
				t[a] = -k;
				return k == 1;
			}
			t[a] = k;
			return true;
		});
	}

	/**
		The collide function will return the allowed movements for a given position as a set of bits 1|2|4|8 for Up|Down|Left|Right
	**/
	public inline function build4Dirs( x : Int, y : Int, collide : Int -> Int -> Int ) {
		var tmp = new FastIO.FastIntIO();
		var k = 0;
		tmp.add2d(x, y, bits);
		while( true ) {
			tmp.flushMax(4);
			if( !tmp.hasNext() )
				break;
			for( id in tmp ) {
				var x = id & ((1 << bits) - 1);
				var y = id >>> bits;
				var col = collide(x, y);

				var a = x + y * width;
				var p = t[a];
				if( p != 0 ) continue;

				var k = k + 1;
				var col = collide(x, y);

				if( y > 0 ) {
					if( col & 1 != 0 )
						tmp.add2d(x, y - 1, bits);
					else if( t[a - width] == 0 )
						t[a - width] = -k;
				}

				if( y < height - 1 ) {
					if( col & 2 != 0 )
						tmp.add2d(x, y + 1, bits);
					else if( t[a + width] == 0 )
						t[a + width] = -k;
				}

				if( x > 0 ) {
					if( col & 4 != 0 )
						tmp.add2d(x - 1, y, bits);
					else if( t[a - 1] == 0 )
						t[a - 1] = -k;
				}

				if( x < width - 1 ) {
					if( col & 8 != 0 )
						tmp.add2d(x + 1, y, bits);
					else if( t[a + 1] == 0 )
						t[a + 1] = -k;
				}

				t[a] = k;
			}
			k++;
		}
	}

	public function getPath( x : Int, y : Int, ?prefDir : hxd.Direction ) {
		var a = x + y * width;
		var k = Math.iabs(t[a]);
		if( k == 0 ) return null;
		var path = [];
		var dir : hxd.Direction = prefDir == null ? Direction.Down : prefDir;
		while( k > 1 ) {
			k--;

			// check with previous dir
			var tx = x + dir.x, ty = y + dir.y, ta = a + dir.x + dir.y * width;
			if( tx > 0 && tx < width && ty > 0 && ty < height && t[ta] == k ) {
				x += dir.x;
				y += dir.y;
				a = ta;
				path.push( { x:x, y:y } );
				continue;
			}

			if( x > 0 && t[a - 1] == k ) {
				x--;
				a--;
				dir = Left;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y > 0 && t[a - width] == k ) {
				y--;
				a -= width;
				dir = Up;
				path.push( { x:x, y:y } );
				continue;
			}
			if( x < width-1 && t[a + 1] == k ) {
				x++;
				a++;
				dir = Right;
				path.push( { x:x, y:y } );
				continue;
			}
			if( y < height - 1 && t[a + width] == k ) {
				y++;
				a += width;
				dir = Down;
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
				a += width;
				path.push( { x:x, y:y } );
				continue;
			}
			throw "assert";
		}
		return path;
	}

}