package h3d.prim;

class Plan2D extends Primitive {
	
	public function new() {
	}
	
	override function alloc( engine : h3d.Engine ) {
		var v = new hxd.FloatBuffer();
		v.push( -1);
		v.push( -1);
		v.push( 0);
		v.push( 1);

		v.push( -1);
		v.push( 1);
		v.push( 0);
		v.push( 0);

		v.push( 1);
		v.push( -1);
		v.push( 1);
		v.push( 1);

		v.push( 1);
		v.push( 1);
		v.push( 1);
		v.push( 0);
		
		buffer = h3d.Buffer.ofFloats(v, 4, [Quads]);
	}
	
	override function render(engine:h3d.Engine) {
		if( buffer == null ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}
	
}