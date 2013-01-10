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
	
	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) reset();
		buffer = engine.mem.allocVector(tmp, 8, 4);
	}

	public function doRender(engine, min, len) {
		if( buffer == null ) alloc(engine);
		engine.renderQuadBuffer(buffer, min, len);
	}
	
}

class TileColorGroup extends Drawable {
	
	var content : TileLayerContent;
	var curColor : h3d.Color;
	
	public var tile : Tile;
	public var rangeMin : Int;
	public var rangeMax : Int;
	
	public function new(t,?parent) {
		super(parent);
		tile = t;
		rangeMin = rangeMax = -1;
		shader.hasVertexColor = true;
		curColor = new h3d.Color(1, 1, 1, 1);
		content = new TileLayerContent();
	}
	
	public function reset() {
		content.reset();
	}
	
	override function onDelete() {
		content.dispose();
		super.onDelete();
	}
	
	public function setDefaultColor( rgb : Int, alpha = 1.0 ) {
		curColor.r = ((rgb >> 16) & 0xFF) / 255;
		curColor.g = ((rgb >> 8) & 0xFF) / 255;
		curColor.b = (rgb & 0xFF) / 255;
		curColor.a = alpha;
	}
	
	public inline function add(x, y, t) {
		content.add(x, y, curColor.r, curColor.g, curColor.b, curColor.a, t);
	}
	
	public inline function addColor(x, y, r, g, b, a, t) {
		content.add(x, y, r, g, b, a, t);
	}
	
	override function draw(engine:h3d.Engine) {
		setupShader(engine, tile, 0);
		var min = rangeMin < 0 ? 0 : rangeMin * 2;
		var max = content.triCount();
		if( rangeMax > 0 && rangeMax < max * 2 ) max = rangeMax * 2;
		content.doRender(engine, min, max - min);
	}
}
