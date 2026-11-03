package h3d.prim;

class FullscreenTriangle extends Primitive {

	public function new() {
	}

	override function triCount() {
		return 1;
	}

	override function vertexCount() {
		return 3;
	}

	override function alloc( engine : h3d.Engine ) {
		var v = new hxd.FloatBuffer();
		v.push( -1);
		v.push( -1);
		v.push( 0);
		v.push( 1);

		v.push( -1);
		v.push( 3);
		v.push( 0);
		v.push( -1);

		v.push( 3);
		v.push( -1);
		v.push( 2);
		v.push( 1);

		buffer = h3d.Buffer.ofFloats(v, hxd.BufferFormat.XY_UV);
	}

	override function render(engine:h3d.Engine) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderTriBuffer(buffer);
	}

	public static function get() {
		var engine = h3d.Engine.getCurrent();
		var inst = @:privateAccess engine.resCache.get(FullscreenTriangle);
		if( inst == null ) {
			inst = new FullscreenTriangle();
			@:privateAccess engine.resCache.set(FullscreenTriangle, inst);
		}
		return inst;
	}

}
