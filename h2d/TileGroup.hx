package h2d;

private class TileShader2D extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( mat1 : Float3, mat2 : Float3 ) {
			var tmp : Float4;
			tmp.x = pos.xyw.dp3(mat1);
			tmp.y = pos.xyw.dp3(mat2);
			tmp.z = 0;
			tmp.w = 1;
			out = tmp;
			tuv = uv;
		}
		function fragment( tex : Texture, color : Float4 ) {
			out = tex.get(tuv, nearest) * color;
		}
	}
}

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
	
	static var SHADER : TileShader2D = null;

	var object : h3d.Object;
	var content : TileLayerContent;
	
	public var tile : Tile;
	public var color(default, null) : h3d.Color;
	
	public function new(t,?parent) {
		tile = t;
		color = new h3d.Color(1, 1, 1, 1);
		content = new TileLayerContent();
		if( SHADER == null )
			SHADER = new TileShader2D();
		object = new h3d.Object(content, new h3d.mat.Material(SHADER));
		object.material.depth(false, Always);
		object.material.culling = None;
		super(parent);
	}
	
	public function reset() {
		content.reset();
	}
	
	override function onDelete() {
		object.primitive.dispose();
		super.onDelete();
	}
	
	public inline function add(x, y, t) {
		content.add(x, y, t);
	}
	
	function set_color(c) {
		color = c;
		return c;
	}
	
	override function set_blendMode(b) {
		this.blendMode = b;
		Tools.setBlendMode(object.material, b);
		return b;
	}
	
	override function draw(engine:h3d.Engine) {
		var shader = SHADER;
		shader.tex = tile.getTexture();
		shader.mat1 = new h3d.Vector(matA, matC, absX);
		shader.mat2 = new h3d.Vector(matB, matD, absY);
		shader.color = color.toVector();
		object.render(engine);
	}
}
