package h2d;

private class TileLayerContent extends h3d.prim.Primitive {

	var tmp : flash.Vector<Float>;
	var pos : Int;

	public function new() {
		reset();
	}

	public function reset() {
		tmp = new flash.Vector();
		pos = 0;
		if( buffer != null ) buffer.dispose();
		buffer = null;
	}

	override public function triCount() {
		if( buffer == null )
			return tmp.length >> 4;
		var v = 0;
		var b = buffer;
		while( b != null ) {
			v += b.nvert;
			b = b.next;
		}
		return v >> 1;
	}

	public function add( x : Int, y : Int, r : Float, g : Float, b : Float, a : Float, t : Tile ) {
		var sx = x + t.dx;
		var sy = y + t.dy;
		tmp[pos++] = sx;
		tmp[pos++] = sy;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx + t.width;
		tmp[pos++] = sy;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx;
		tmp[pos++] = sy + t.height;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v2;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx + t.width;
		tmp[pos++] = sy + t.height;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v2;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
	}
	
	public function addPoint( x : Float, y : Float, color : Int ) {
		tmp[pos++] = x;
		tmp[pos++] = y;
		tmp[pos++] = 0;
		tmp[pos++] = 0;
		insertColor(color);
	}

	inline function insertColor( c : Int ) {
		tmp[pos++] = ((c >> 16) & 0xFF) / 255.;
		tmp[pos++] = ((c >> 8) & 0xFF) / 255.;
		tmp[pos++] = (c & 0xFF) / 255.;
		tmp[pos++] = (c >>> 24) / 255.;
	}

	public inline function rectColor( x : Float, y : Float, w : Float, h : Float, color : Int ) {
		tmp[pos++] = x;
		tmp[pos++] = y;
		tmp[pos++] = 0;
		tmp[pos++] = 0;
		insertColor(color);
		tmp[pos++] = x + w;
		tmp[pos++] = y;
		tmp[pos++] = 1;
		tmp[pos++] = 0;
		insertColor(color);
		tmp[pos++] = x;
		tmp[pos++] = y + h;
		tmp[pos++] = 0;
		tmp[pos++] = 1;
		insertColor(color);
		tmp[pos++] = x + w;
		tmp[pos++] = y + h;
		tmp[pos++] = 1;
		tmp[pos++] = 1;
		insertColor(color);
	}

	public inline function rectGradient( x : Float, y : Float, w : Float, h : Float, ctl : Int, ctr : Int, cbl : Int, cbr : Int ) {
		tmp[pos++] = x;
		tmp[pos++] = y;
		tmp[pos++] = 0;
		tmp[pos++] = 0;
		insertColor(ctl);
		tmp[pos++] = x + w;
		tmp[pos++] = y;
		tmp[pos++] = 1;
		tmp[pos++] = 0;
		insertColor(ctr);
		tmp[pos++] = x;
		tmp[pos++] = y + h;
		tmp[pos++] = 0;
		tmp[pos++] = 1;
		insertColor(cbl);
		tmp[pos++] = x + w;
		tmp[pos++] = y + h;
		tmp[pos++] = 1;
		tmp[pos++] = 0;
		insertColor(cbr);
	}

	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) reset();
		buffer = engine.mem.allocVector(tmp, 8, 4);
	}

	public function doRender(engine, min, len) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer, min, len);
	}

}

class TileColorGroup extends Drawable {

	var content : TileLayerContent;
	var curColor : h3d.Vector;

	public var tile : Tile;
	public var rangeMin : Int;
	public var rangeMax : Int;

	public function new(t,?parent) {
		super(parent);
		tile = t;
		rangeMin = rangeMax = -1;
		shader.hasVertexColor = true;
		curColor = new h3d.Vector(1, 1, 1, 1);
		content = new TileLayerContent();
	}

	public function reset() {
		content.reset();
	}

	/**
		Returns the number of tiles added to the group
	**/
	public function count() {
		return content.triCount() >> 1;
	}

	override function onDelete() {
		content.dispose();
		super.onDelete();
	}

	public function setDefaultColor( rgb : Int, alpha = 1.0 ) {
		curColor.x = ((rgb >> 16) & 0xFF) / 255;
		curColor.y = ((rgb >> 8) & 0xFF) / 255;
		curColor.z = (rgb & 0xFF) / 255;
		curColor.w = alpha;
	}

	public inline function add(x, y, t) {
		content.add(x, y, curColor.x, curColor.y, curColor.z, curColor.w, t);
	}

	public inline function addColor(x, y, r, g, b, a, t) {
		content.add(x, y, r, g, b, a, t);
	}

	override function draw(ctx:RenderContext) {
		setupShader(ctx.engine, tile, 0);
		var min = rangeMin < 0 ? 0 : rangeMin * 2;
		var max = content.triCount();
		if( rangeMax > 0 && rangeMax < max * 2 ) max = rangeMax * 2;
		content.doRender(ctx.engine, min, max - min);
	}
}
