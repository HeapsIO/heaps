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
		addChildAt(s, layers.length);
	}
	
	public inline function add(s, layer) {
		return addChildAt(s, layer);
	}
	
	override function addChildAt( s : Sprite, layer : Int ) {
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
				s.parent = null;
				if( s.allocated ) s.onDelete();
				var k = layerCount - 1;
				while( k >= 0 && layers[k] > i ) {
					layers[k]--;
					k--;
				}
				break;
			}
		}
	}
	
	public function ysort( layer : Int ) {
		// TODO
	}

	
}