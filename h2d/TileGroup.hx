package h2d;

private class TileLayerContent extends h3d.prim.Primitive {

	var tmp : hxd.FloatBuffer;
	
	public function new() {
		reset();
	}
	
	public function isEmpty() {
		return buffer == null;
	}
	
	public function reset() {
		tmp = new hxd.FloatBuffer();
		if( buffer != null ) buffer.dispose();
		buffer = null;
	}
	
	public function add( x : Int, y : Int, t : Tile ) {
		var sx = x + t.dx;
		var sy = y + t.dy;
		var sx2 = sx + t.width;
		var sy2 = sy + t.height;
		tmp.push(sx);
		tmp.push(sy);
		tmp.push(t.u);
		tmp.push(t.v);
		tmp.push(sx2);
		tmp.push(sy);
		tmp.push(t.u2);
		tmp.push(t.v);
		tmp.push(sx);
		tmp.push(sy2);
		tmp.push(t.u);
		tmp.push(t.v2);
		tmp.push(sx2);
		tmp.push(sy2);
		tmp.push(t.u2);
		tmp.push(t.v2);
	}
	
	override public function triCount() {
		return if( buffer == null ) tmp.length >> 3 else buffer.totalVertices() >> 1;
	}
	
	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) reset();
		buffer = h3d.Buffer.ofFloats(tmp, 4, [Quads]);
	}

	public function doRender(engine, min, len) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer, min, len);
	}
	
}

class TileGroup extends Drawable {
	
	var content : TileLayerContent;
	
	public var tile : Tile;
	public var rangeMin : Int;
	public var rangeMax : Int;
	
	public function new(t,?parent) {
		tile = t;
		rangeMin = rangeMax = -1;
		content = new TileLayerContent();
		super(parent);
	}
	
	public function reset() {
		content.reset();
	}
	
	override function onDelete() {
		content.dispose();
		super.onDelete();
	}
	
	public inline function add(x, y, t) {
		content.add(x, y, t);
	}
	
	/**
		Returns the number of tiles added to the group
	**/
	public function count() {
		return content.triCount() >> 1;
	}
		
	override function draw(ctx:RenderContext) {
		setupShader(ctx.engine, tile, 0);
		var min = rangeMin < 0 ? 0 : rangeMin * 2;
		var max = content.triCount();
		if( rangeMax > 0 && rangeMax < max * 2 ) max = rangeMax * 2;
		content.doRender(ctx.engine, min, max - min);
	}
}
