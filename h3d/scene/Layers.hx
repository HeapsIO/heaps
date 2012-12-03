package h3d.scene;

class Layers extends Object {
	
	// the per-layer insert position
	var layers : Array<Int>;
	var layerCount : Int;
	
	public function new(?parent) {
		super(parent);
		layers = [];
		layerCount = 0;
	}
	
	override function addChild(o) {
		addChildAt(o, layers.length);
	}
	
	public inline function add(o, layer) {
		return addChildAt(o, layer);
	}
	
	override function addChildAt( o : Object, layer : Int ) {
		// new layer
		while( layer >= layerCount )
			layers[layerCount++] = childs.length;
		super.addChildAt(o,layers[layer]);
		for( i in layer...layerCount )
			layers[i]++;
	}
	
	override function removeChild( o : Object ) {
		for( i in 0...childs.length ) {
			if( childs[i] == o ) {
				childs.splice(i, 1);
				o.parent = null;
				var k = layerCount - 1;
				while( k >= 0 && layers[k] > i ) {
					layers[k]--;
					k--;
				}
				break;
			}
		}
	}
	
}