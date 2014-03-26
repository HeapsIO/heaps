package h3d.prim;

class Plan3D extends Primitive {
	
	public var width(default,set) : Float;
	public var height(default,set) : Float;
	
	public function new(width = 1.0, height = 1.0) {
		this.width = width;
		this.height = height;
	}

	function set_width(w) {
		width = w;
		dispose();
		return w;
	}
	
	function set_height(h) {
		height = h;
		dispose();
		return h;
	}
	
	override function getBounds() {
		var b = new h3d.col.Bounds();
		b.xMin = 0;
		b.xMax = width;
		b.yMin = 0;
		b.yMax = height;
		b.zMin = b.zMax = 0;
		return b;
	}

	override function alloc( engine : h3d.Engine ) {
		var v = new hxd.FloatBuffer();
		var hw = width * 0.5, hh = height * 0.5;
		v.push( -hw);
		v.push( -hh);
		v.push( 0);
		v.push( 0);
		v.push( 1);

		v.push( 0);
		v.push( 0);
		v.push( 1);
		
		v.push( -hw);
		v.push( hh);
		v.push( 0);
		v.push( 0);
		v.push( 0);
		
		v.push( 0);
		v.push( 0);
		v.push( 1);
		
		v.push( hw);
		v.push( -hh);
		v.push( 1);
		v.push( 1);

		v.push( 0);
		v.push( 0);
		v.push( 1);
		
		v.push( hw);
		v.push( hh);
		v.push( 1);
		v.push( 0);
		
		v.push( 0);
		v.push( 0);
		v.push( 1);
		
		buffer = h3d.Buffer.ofFloats(v, 8, [Quads]);
	}
	
	override function render(engine:h3d.Engine) {
		if( buffer == null ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}
	
}