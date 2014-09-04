package h2d;

class Layers extends Sprite {

	// the per-layer insert position
	var layers : Array<Int>;
	var layerCount : Int;

	public function new(?parent) {
		super(parent);
		layers = [];
		layerCount = 0;
	}

	override function addChild(s) {
		addChildAt(s, 0);
	}

	public inline function add(s, layer) {
		return addChildAt(s, layer);
	}

	override function addChildAt( s : Sprite, layer : Int ) {
		if( s.parent == this ) {
			var old = s.allocated;
			s.allocated = false;
			removeChild(s);
			s.allocated = old;
		}
		// new layer
		while( layer >= layerCount )
			layers[layerCount++] = childs.length;
		super.addChildAt(s,layers[layer]);
		for( i in layer...layerCount )
			layers[i]++;
	}

	override function removeChild( s : Sprite ) {
		for( i in 0...childs.length ) {
			if( childs[i] == s ) {
				childs.splice(i, 1);
				if( s.allocated ) s.onDelete();
				s.parent = null;
				var k = layerCount - 1;
				while( k >= 0 && layers[k] > i ) {
					layers[k]--;
					k--;
				}
				break;
			}
		}
	}

	public function under( s : Sprite ) {
		for( i in 0...childs.length )
			if( childs[i] == s ) {
				var pos = 0;
				for( l in layers )
					if( l > i )
						break;
					else
						pos = l;
				var p = i;
				while( p > pos ) {
					childs[p] = childs[p - 1];
					p--;
				}
				childs[pos] = s;
				break;
			}
	}

	public function over( s : Sprite ) {
		for( i in 0...childs.length )
			if( childs[i] == s ) {
				for( l in layers )
					if( l > i ) {
						for( p in i...l-1 )
							childs[p] = childs[p + 1];
						childs[l - 1] = s;
						break;
					}
				break;
			}
	}

	public function getLayer( layer : Int ) : Iterator<Sprite> {
		var a;
		if( layer >= layerCount )
			a = [];
		else {
			var start = layer == 0 ? 0 : layers[layer - 1];
			var max = layers[layer];
			a = childs.slice(start, max);
		}
		return new hxd.impl.ArrayIterator(a);
	}

	public function ysort( layer : Int ) {
		if( layer >= layerCount ) return;
		var start = layer == 0 ? 0 : layers[layer - 1];
		var max = layers[layer];
		if( start == max )
			return;
		var pos = start;
		var ymax = childs[pos++].y;
		while( pos < max ) {
			var c = childs[pos];
			if( c.y < ymax ) {
				var p = pos - 1;
				while( p >= start ) {
					var c2 = childs[p];
					if( c.y >= c2.y ) break;
					childs[p + 1] = c2;
					p--;
				}
				childs[p + 1] = c;
			} else
				ymax = c.y;
			pos++;
		}
	}


}