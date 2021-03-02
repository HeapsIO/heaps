package h2d;

/**
	A layer-based container for Objects.

	Hierarchically organizes objects based on their layer.
	Supports per-layer Y-sorting through `Layers.ysort`.
**/
class Layers extends Object {

	// the per-layer insert position
	var layersIndexes : Array<Int>;
	var layerCount : Int;

	/**
		Create a new Layers instance.
		@param parent An optional parent `h2d.Object` instance to which Layers adds itself if set.
	**/
	public function new(?parent) {
		super(parent);
		layersIndexes = [];
		layerCount = 0;
	}

	/**
		Adds a child object `s` at the end of the layer 0.
		@param s An object to be added.
	**/
	override function addChild(s) {
		addChildAt(s, 0);
	}

	/**
		Adds a child object `s` at the end of the given `layer`.
		`h2d.Layers.addChildAt` can be used as an alternative.
		@param s An object to be added.
		@param layer An index of the layer, 0 is the bottom-most layer.
	**/
	public inline function add(s, layer) {
		return addChildAt(s, layer);
	}

	/**
		Adds a child object `s` at the end of the given `layer`.
		`h2d.Layers.addChildAt` can be used as an alternative.
		@param s An object to be added.
		@param layer An index of the layer, 0 is the bottom-most layer.
	**/
	override function addChildAt( s : Object, layer : Int ) {
		if( s.parent == this ) {
			var old = s.allocated;
			s.allocated = false;
			removeChild(s);
			s.allocated = old;
		}
		// new layer
		while( layer >= layerCount )
			layersIndexes[layerCount++] = children.length;
		super.addChildAt(s,layersIndexes[layer]);
		for( i in layer...layerCount )
			layersIndexes[i]++;
	}

	override function removeChild( s : Object ) {
		for( i in 0...children.length ) {
			if( children[i] == s ) {
				children.splice(i, 1);
				if( s.allocated ) s.onRemove();
				s.parent = null;
				s.posChanged = true;
				if( s.parentContainer != null ) s.setParentContainer(null);
				var k = layerCount - 1;
				while( k >= 0 && layersIndexes[k] > i ) {
					layersIndexes[k]--;
					k--;
				}
				onContentChanged();
				break;
			}
		}
	}

	/**
		Moves an object `s` to the bottom of its layer (rendered first, behind the other Objects in the layer).
		Causes `Object.onHierarchyMoved` on the Object.
		@param s An object to be moved.
	 */
	public function under( s : Object ) {
		for( i in 0...children.length )
			if( children[i] == s ) {
				var pos = 0;
				for( l in layersIndexes )
					if( l > i )
						break;
					else
						pos = l;
				var p = i;
				while( p > pos ) {
					children[p] = children[p - 1];
					p--;
				}
				children[pos] = s;
				// Force Interactive to reattach to scene in order to keep interaction order.
				if ( s.allocated )
					s.onHierarchyMoved(false);
				return;
			}
	}

	/**
		Moves an object `s` to the top of its layer (rendered last, in front of other Objects in layer).
		Causes `Object.onHierarchyMoved` on the Object.
		@param s An object to be moved.
	 */
	public function over( s : Object ) {
		for( i in 0...children.length )
			if( children[i] == s ) {
				for( l in layersIndexes )
					if( l > i ) {
						for( p in i...l-1 )
							children[p] = children[p + 1];
						children[l - 1] = s;
						// Force Interactive to reattach to scene in order to keep interaction order.
						if ( s.allocated )
							s.onHierarchyMoved(false);
						return;
					}
				return;
			}
	}

	/**
		Returns an Iterator with objects in a specified `layer`.
		Returns an empty iterator if no objects are present in the layer.

		Objects added or removed from Layers during iteration do not affect the output of the Iterator.

		@param layer A layer index to iterate over.
	 */
	public function getLayer( layer : Int ) : Iterator<Object> {
		var a;
		if( layer >= layerCount )
			a = [];
		else {
			var start = layer == 0 ? 0 : layersIndexes[layer - 1];
			var max = layersIndexes[layer];
			a = children.slice(start, max);
		}
		return new hxd.impl.ArrayIterator(a);
	}

	/**
		Returns the layer on which the child `s` resides on.
		@param s An object to look up to.
		@return An index of the layer where the object resides on or `-1` if `s` is not a child of the Layers.
	 */
	public function getChildLayer( s : Object ) : Int {
		if ( s.parent != this ) return -1;

		var index = children.indexOf(s);
		for ( i in 0...layerCount )
			if ( layersIndexes[i] > index ) return i;
		return -1;
	}

	function drawLayer( ctx : RenderContext, layer : Int ) {
		if( layer >= layerCount )
			return;
		var old = ctx.globalAlpha;
		ctx.globalAlpha *= alpha;
		var start = layer == 0 ? 0 : layersIndexes[layer - 1];
		var max = layersIndexes[layer];
		if( ctx.front2back ) {
			for( i in start...max ) children[max - 1 - i].drawRec(ctx);
		} else {
			for( i in start...max ) children[i].drawRec(ctx);
		}
		ctx.globalAlpha = old;
	}

	/**
		Sorts specified layer based on `Object.y` value of it's children.
		Causes `Object.onHierarchyChanged` on moved children.
		@param layer An index of the layer to sort.
	 */
	public function ysort( layer : Int ) {
		if( layer >= layerCount ) return;
		var start = layer == 0 ? 0 : layersIndexes[layer - 1];
		var max = layersIndexes[layer];
		if( start == max )
			return;
		var pos = start;
		var ymax = children[pos++].y;
		while( pos < max ) {
			var c = children[pos];
			if( c.y < ymax ) {
				var p = pos - 1;
				while( p >= start ) {
					var c2 = children[p];
					if( c.y >= c2.y ) break;
					children[p + 1] = c2;
					p--;
				}
				children[p + 1] = c;
				if ( c.allocated )
					c.onHierarchyMoved(false);
			} else
				ymax = c.y;
			pos++;
		}
	}

}