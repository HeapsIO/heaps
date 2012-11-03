package h2d;

private class TileShader2D extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
			color : Float4,
		};
		var tuv : Float2;
		var tcolor : Float4;
		function vertex( mat1 : Float3, mat2 : Float3 ) {
			var tmp : Float4;
			tmp.x = pos.xyw.dp3(mat1);
			tmp.y = pos.xyw.dp3(mat2);
			tmp.z = 0;
			tmp.w = 1;
			out = tmp;
			tcolor = color;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv, nearest) * tcolor;
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
	
	public function add( x : Int, y : Int, r : Float, g : Float, b : Float, a : Float, t : TilePos ) {
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
		tmp[pos++] = sx + t.w + 0.1;
		tmp[pos++] = sy;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx;
		tmp[pos++] = sy + t.h + 0.1;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v2;
		tmp[pos++] = r;
		tmp[pos++] = g;
		tmp[pos++] = b;
		tmp[pos++] = a;
		tmp[pos++] = sx + t.w + 0.1;
		tmp[pos++] = sy + t.h + 0.1;
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
		engine.renderIndexes(buffer, engine.mem.quadIndexes, 2);
	}
	
}

class TileColorGroup extends Sprite {
	
	static var SHADER : TileShader2D = null;

	var object : h3d.Object;
	var content : TileLayerContent;
	var curColor : h3d.Color;
	
	public var tiles : Tiles;
	
	public function new(t,?parent) {
		super(parent);
		tiles = t;
		curColor = new h3d.Color(1, 1, 1, 1);
		content = new TileLayerContent();
		if( SHADER == null )
			SHADER = new TileShader2D();
		object = new h3d.Object(content, new h3d.mat.Material(SHADER));
		object.material.depth(false, Always);
		object.material.culling = None;
		setTransparency(true);
	}
	
	public function reset() {
		content.reset();
	}
	
	override function onRemove() {
		object.primitive.dispose();
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
	
	public function setTransparency(a) {
		if( a )
			object.material.blend(SrcAlpha, OneMinusSrcAlpha);
		else
			object.material.blend(One,Zero);
	}
	
	override function draw(engine:h3d.Engine) {
		var shader = SHADER;
		shader.tex = tiles.getTexture(engine);
		shader.mat1 = new h3d.Vector(matA, matC, absX);
		shader.mat2 = new h3d.Vector(matB, matD, absY);
		object.render(engine);
	}
}
