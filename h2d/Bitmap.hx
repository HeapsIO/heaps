package h2d;

private class BitmapShader extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float2,
		};
		var tuv : Float2;
		function vertex( size : Float3, mat1 : Float3, mat2 : Float3, uvScale : Float2, uvPos : Float2 ) {
			var tmp : Float4;
			var spos = pos.xyw * size;
			tmp.x = spos.dp3(mat1);
			tmp.y = spos.dp3(mat2);
			tmp.z = 0;
			tmp.w = 1;
			out = tmp;
			tuv = pos * uvScale + uvPos;
		}
		function fragment( tex : Texture, color : Float4 ) {
			out = tex.get(tuv, nearest) * color;
		}
	}
}

class Bitmap extends Sprite {

	public var data : TilePos;
	public var color : h3d.Vector;
	public var alpha(get, set) : Float;
	
	public function new( ?data : TilePos, ?parent ) {
		super(parent);
		color = new h3d.Vector(1, 1, 1, 1);
		this.data = data;
	}
	
	static var BITMAP_OBJ : h3d.CustomObject<BitmapShader> = null;
	static var TMP_VECTOR = new h3d.Vector();
	
	override function draw( engine : h3d.Engine ) {
		if( data == null )
			return;
		var b = BITMAP_OBJ;
		if( b == null ) {
			var p = new h3d.prim.Quads([
				new h3d.Point(0, 0),
				new h3d.Point(1, 0),
				new h3d.Point(0, 1),
				new h3d.Point(1, 1),
			]);
			b = new h3d.CustomObject(p, new BitmapShader());
			b.material.blend(SrcAlpha, OneMinusSrcAlpha);
			b.material.culling = None;
			b.material.depth(false, Always);
		}
		var tmp = TMP_VECTOR;
		tmp.x = data.w;
		tmp.y = data.h;
		tmp.z = 1;
		b.shader.size = tmp;
		tmp.x = matA;
		tmp.y = matC;
		tmp.z = absX + data.dx * matA + data.dy * matC;
		b.shader.mat1 = tmp;
		tmp.x = matB;
		tmp.y = matD;
		tmp.z = absY + data.dx * matB + data.dy * matD;
		b.shader.mat2 = tmp;
		tmp.x = data.u;
		tmp.y = data.v;
		b.shader.uvPos = tmp;
		tmp.x = data.u2 - data.u;
		tmp.y = data.v2 - data.v;
		b.shader.uvScale = tmp;
		b.shader.color = color;
		b.shader.tex = data.tiles.getTexture(engine);
		b.render(engine);
	}
	
	inline function get_alpha() {
		return color.w;
	}

	inline function set_alpha(v) {
		return color.w = v;
	}
		
	public static function ofBitmap( bmp : flash.display.BitmapData ) {
		return new Bitmap(Tiles.fromBitmap(bmp).get(0));
	}
	
}