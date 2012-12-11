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
		tmp[pos++] = sx + t.width + 0.1;
		tmp[pos++] = sy;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx;
		tmp[pos++] = sy + t.height + 0.1;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v2;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx + t.width + 0.1;
		tmp[pos++] = sy + t.height + 0.1;
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

	override function render(engine) {
		if( buffer == null ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}
	
}

class TileColorGroup extends Sprite {
	
	var content : TileLayerContent;
	var curColor : h3d.Color;
	
	public var tile : Tile;
	
	public function new(t,?parent) {
		super(parent);
		tile = t;
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
	
	public function setColor( rgb : Int, alpha = 1.0 ) {
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
		var core = Tools.getCoreObjects();
		var shader = core.tileColorObj.shader;
		shader.tex = tile.getTexture();
		var tmp = core.tmpMat1;
		tmp.set(matA, matC, absX);
		shader.mat1 = tmp;
		var tmp = core.tmpMat2;
		tmp.set(matB, matD, absY);
		shader.mat2 = tmp;
		Tools.setBlendMode(core.tileColorObj.material, blendMode);
		engine.selectMaterial(core.tileColorObj.material);
		content.render(engine);
	}
}
