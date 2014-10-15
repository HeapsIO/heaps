package h3d.prim;

class MultiPrimitive extends Primitive {

	var primitives : Array<Primitive>;
	var bounds : h3d.col.Bounds;
	var current : Int = -1;

	public function new(primitives) {
		this.primitives = primitives;
	}

	override function triCount() {
		var t = 0;
		for( p in primitives )
			t += p.triCount();
		return t;
	}

	override function getBounds() : h3d.col.Bounds {
		if( bounds != null ) return bounds;
		bounds = new h3d.col.Bounds();
		for( p in primitives )
			bounds.add(p.getBounds());
		return bounds;
	}

	override function alloc( engine : h3d.Engine ) {
		for( p in primitives )
			p.alloc(engine);
	}

	override function selectMaterial( material : Int ) {
		current = material;
	}

	override function buildNormalsDisplay() : Primitive {
		return new MultiPrimitive([for( p in primitives ) p.buildNormalsDisplay()]);
	}

	override function render( engine : h3d.Engine ) {
		if( current < 0 )
			for( p in primitives )
				p.render(engine);
		else
			primitives[current].render(engine);
	}

	override function dispose() {
		for( p in primitives )
			p.dispose();
	}

}