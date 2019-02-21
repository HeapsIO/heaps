package h3d.prim;

class Plane2D extends Primitive {

	public function new() {
	}

	override function triCount() {
		return 2;
	}

	override function vertexCount() {
		return 4;
	}

	override function alloc( engine : h3d.Engine ) {
		var v = new hxd.FloatBuffer();
		v.push( -1);
		v.push( -1);
		v.push( 0);
		v.push( 1 );

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

		buffer = h3d.Buffer.ofFloats(v, 4, [Quads, RawFormat]);
	}

	override function render(engine:h3d.Engine) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}

	public static function get() {
		var engine = h3d.Engine.getCurrent();
		var inst = @:privateAccess engine.resCache.get(Plane2D);
		if( inst == null ) {
			inst = new Plane2D();
			@:privateAccess engine.resCache.set(Plane2D, inst);
		}
		return inst;
	}

}