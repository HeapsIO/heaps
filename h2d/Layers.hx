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
		Adds a child object `s` at the end of the topmost layer.
		@param s An object to be added.
	**/
	@:dox(show)
	override function addChild(s) {
		add(s, -1);
	}

	/**
	 * Adds a child object `s` at the end of the given `layer`.
	 * @param s An object to be added.
	 * @param layer An index of the layer the object should be added at with 0 being the bottom-most layer. Pass -1 to use topmost layer.
	 * @param index An optional index at which the object should be inserted inside the layer. Pass -1 to append to the end.
	 */
	public function add( s : Object, layer : Int = -1, index : Int = -1) {
		if ( s.parent == this ) {
			// prevent calling onRemove
			var old = s.allocated;
			s.allocated = false;
			removeChild(s);
			s.allocated = old;
		}

		if ( layer == -1 ) layer = layerCount == 0 ? 0 : layerCount - 1;

		// Populate layer list
		while ( layer >= layerCount )
			layersIndexes[layerCount++] = children.length;
		
		if ( index != -1 ) {
			// Prevent inserting out of layer bounds.
			if ( layer == 0 )
				super.addChildAt(s, hxd.Math.imax(0, hxd.Math.imin(index, layersIndexes[layer])));
			else if ( index < 0 ) // clamp 0..
				super.addChildAt(s, layersIndexes[layer - 1]);
			else // clamp ..layerSize
				super.addChildAt(s, hxd.Math.imin(layersIndexes[layer - 1] + index, layersIndexes[layer]));
		} else {
			super.addChildAt(s, layersIndexes[layer]);
		}
		
		for ( i in layer...layerCount )
			layersIndexes[i]++;
		
	}

	/**
		Adds a child object `s` at specified `index` on the top topmost layer.

		Warning: Previous behavior of `Layers.addChildAt` is no longer applicable and `Layers.add` should be used instead.
		@param s The object to be added.
		@param index The position of the object in the layer.
	**/
	@:dox(show)
	override function addChildAt( s : Object, index : Int ) {
		add(s, -1, index);
	}

	override function removeChild( s : Object ) {
		// Full override due to child index being important for layer tracking.
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
				#if domkit
				if( s.dom != null ) s.dom.onParentChanged();
				#end
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
		Return the `n`th element among the immediate children list on the `layer`, or null if there is none.
		@param layer The layer children of which are used. Pass -1 to use the topmost layer.
	**/
	public function getChildAtLayer( n : Int, layer : Int ) : Object {
		if ( layer == -1 ) layer = layerCount == 0 ? 0 : layerCount - 1;
		if ( layer >= layerCount || n < 0 || n >= layersIndexes[layer] ) return null;
		if ( layer == 0 ) return children[n];
		return children[layersIndexes[layer - 1] + n];
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

	/**
		Return the index of the child within its respective layer.
		@param o The child to look up index of.
		@returns `-1` if object is not a child of Layers, index of the child within its current layer otherwise.
	**/
	public function getChildIndexInLayer( o : Object ):Int
	{
		if ( o.parent != this ) return -1;

		var index = children.indexOf(o);
		if ( index < layersIndexes[0] ) return index;
		for ( i in 1...layerCount )
			if ( layersIndexes[i] > index ) return index - layersIndexes[i - 1];
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