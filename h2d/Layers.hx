package h2d;

/**
 * `h2d.Layers` allows to hierarchically organize objects on different layers and supports Y-sorting.
 */
class Layers extends Object {

	// the per-layer insert position
	var layersIndexes : Array<Int>;
	var layerCount : Int;

	/**
		The default layer to which new objects are added.

		`Layers.getChildAt`, `Layers.addChild` and `Layers.addChildAt` will use that layer index when adding children.
	**/
	public var defaultLayer : Int = 0;

	public function new(?parent) {
		super(parent);
		layersIndexes = [];
		layerCount = 0;
	}

	/**
	 * Adds a child `h2d.Object` at `layer:Int`. 
	 * `h2d.Layers.addChildAt` can be used as an alternative.
	 * @param s `h2d.Object` child to be added.
	 * @param layer `Int` index of the layer, 0 is the bottom layer.
	 */
	public function add( s : Object, layer : Int = -1, index : Int = 0) {
		if ( s.parent == this ) {
			var old = s.allocated;
			removeChild(s);
			s.allocated = old;
		}

		if ( layer == -1 ) layer = defaultLayer;

		// Populate layer list
		while ( layer >= layerCount )
			layersIndexes[layerCount++] = children.length;
		
		// Prevent inserting out of layer bounds.
		if ( layer == 0 )
			super.addChildAt(s, hxd.Math.imin(layersIndexes[0], index));
		else
			super.addChildAt(s, hxd.Math.imin(layersIndexes[layer - 1] + index, layersIndexes[layer]));
		
		for ( i in layer...layerCount )
			layersIndexes[i]++;
		
	}

	/**
		Adds a child object `s` at specified `index` in the `Layers.defaultLayer`.
		@param s The object to be added.
		@param index The position of the object in the layer.
	**/
	override function addChildAt( s : Object, index : Int ) {
		add(s, -1, index);
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
	 * Moves an `h2d.Object` to the bottom of its layer (rendered first, behind the other Objects in layer).
	 * @param s `h2d.Object` to be moved.
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
	 * Moves an `h2d.Object` to the top of its layer (rendered last, in front of other Objects in layer).
	 * @param s `h2d.Object` to be moved.
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
	 * Returns an `Iterator<h2d.Object>` contained in specified layer.  
	 * Returns empty iterator if layer does not exists.  
	 * Objects added or removed from Layers during iteration are not added/removed from the `Iterator`.
	 * @param layer `Int` index of the desired layer.
	 * @return `Iterator<Object>`
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
		Return the `n`th element among the immediate children list on the `Layers.defaultLayer`, or null if there is no.
	**/
	override public function getChildAt(n:Int):Object
	{
		return getChildAtLayer(n);
	}

	/**
		Return the `n`th element among the immediate children list on the `layer`, or null if there is no.
	**/
	public function getChildAtLayer( n : Int, layer : Int = -1 ) : Object {
		if ( layer == -1 ) layer = defaultLayer;
		if ( layer >= layerCount || n < 0 || n >= layersIndexes[layer] ) return null;
		if ( layer == 0 ) return children[n];
		return children[layersIndexes[layer - 1] + n];
	}

	/**
	 * Returns the layer on which the child `h2d.Object` resides.  
	 * @param s `h2d.Object` 
	 * @return `Int` index of the layer where `s:h2d.Object` resides or -1 if it's not a child.
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
	override public function getChildIndex( o : Object ):Int
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
	 * Sorts specified layer based on Y value of it's children.
	 * @param layer `Int` index of the layer.
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