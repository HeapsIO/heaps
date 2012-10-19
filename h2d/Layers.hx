package h2d;

class Layers extends Sprite {
	
	var layers : Array<Array<Sprite>>;
	
	public function new(?parent) {
		super(parent);
		layers = [];
	}
	
	public function add( s : Sprite, layer : Int ) {
		var l = layers[layer];
		if( l == null ) {
			l = [];
			layers[layer] = l;
		}
		s.remove();
		l.push(s);
		s.parent = this;
	}
	
	public function ysort( layer : Int ) {
		var l = layers[layer];
		if( l == null ) return;
		l.sort(sortSprites);
	}
	
	function sortSprites(s1:Sprite, s2:Sprite) {
		var d = s1.y - s2.y;
		if( d == 0 ) return 0;
		return d > 0 ? 1 : -1;
	}
	
	public function render( engine : h3d.Engine ) {
		updatePos();
		draw(engine);
		for( l in layers )
			for( c in l )
				c.render(engine);
		posChanged = false;
	}
	
}