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
	}
	
	public function add( x : Int, y : Int, t : TilePos ) {
		var sx = x + t.dx;
		var sy = y + t.dy;
		tmp[pos++] = sx;
		tmp[pos++] = sy;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v;
		tmp[pos++] = sx + t.w + 0.1;
		tmp[pos++] = sy;
		tmp[pos++] = t.u2;
		tmp[pos++] = t.v;
		tmp[pos++] = sx;
		tmp[pos++] = sy + t.h + 0.1;
		tmp[pos++] = t.u;
		tmp[pos++] = t.v2;
		tmp[pos++] = sx + t.w + 0.1;
		tmp[pos++] = sy + t.h + 0.1;
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
	
	var object : h3d.Object;
	var shader : TileShader2D;
	var content : TileLayerContent;
	
	public var tiles : Tiles;
	public var alpha(default, setAlpha) : Bool;
	public var color(default, setColor) : Null<h3d.Vector>;
	
	public function new(t,?parent) {
		super(parent);
		tiles = t;
		content = new TileLayerContent();
		object = new h3d.Object(content, new h3d.mat.Material(null));
		object.material.depth(false, Always);
		object.material.culling = None;
	}
	
	public function reset() {
		content.reset();
	}
	
	public inline function add(x, y, t) {
		content.add(x, y, t);
	}
	
	function killShader() {
		if( shader != null ) {
			shader.dispose();
			shader = null;
		}
	}
	
	function setColor(c) {
		color = c;
		killShader();
		return c;
	}
	
	function setAlpha(a) {
		if( a )
			object.material.blend(SrcAlpha, OneMinusSrcAlpha);
		else
			object.material.blend(One,Zero);
		alpha = a;
		return a;
	}
	
	override function draw(engine:h3d.Engine) {
		if( shader == null ) {
			shader = new TileShader2D();
			object.material.shader = shader;
		}
		shader.tex = tiles.getTexture(engine);
		shader.mat1 = new h3d.Vector(matA, matC, absX);
		shader.mat2 = new h3d.Vector(matB, matD, absY);
		shader.color = color == null ? new h3d.Vector(1,1,1,1) : color;
		object.render(engine);
	}
}
