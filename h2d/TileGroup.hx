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
	
	public function add( x : Int, y : Int, t : Tile ) {
		var sx = x + t.dx;
		var sy = y + t.dy;
		var sx2 = sx + t.width + 0.1;
		var sy2 = sy + t.height + 0.1;
		tmp[pos++] = sx;
		tmp[pos++] = sy;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v;
		tmp[pos++] = sx2;
		tmp[pos++] = sy;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v;
		tmp[pos++] = sx;
		tmp[pos++] = sy2;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v2;
		tmp[pos++] = sx2;
		tmp[pos++] = sy2;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v2;
	}
	
	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) reset();
		buffer = engine.mem.allocVector(tmp, 4, 4);
	}

	override function render(engine) {
		if( buffer == null ) alloc(engine);
		engine.renderIndexes(buffer, engine.mem.quadIndexes, 2);
	}
	
}

class TileGroup extends Sprite {
	
	var content : TileLayerContent;
	
	public var tile : Tile;
	public var color(default, null) : h3d.Color;
	
	public function new(t,?parent) {
		tile = t;
		color = new h3d.Color(1, 1, 1, 1);
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
	
	function set_color(c) {
		color = c;
		return c;
	}
	
	override function draw(engine:h3d.Engine) {
		var core = Tools.getCoreObjects();
		var shader = core.tileObj.shader;
		var tmp = core.tmpVector;
		tmp.set(matA, matC, absX);
		shader.mat1 = tmp;
		tmp.set(matB, matD, absY);
		shader.mat2 = tmp;
		tmp.set(color.r, color.g, color.b);
		shader.color = tmp;
		shader.tex = tile.getTexture();
		Tools.setBlendMode(core.tileObj.material, blendMode);
		engine.selectMaterial(core.tileObj.material);
		content.render(engine);
	}
}
