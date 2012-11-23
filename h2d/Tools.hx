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

class Tools {

	static var BITMAP_OBJ : h3d.CustomObject<BitmapShader> = null;
	static var TMP_VECTOR = new h3d.Vector();
		
	@:allow(h2d)
	static function drawTile( engine : h3d.Engine, spr : Sprite, tile : Tile, color : h3d.Color, blendMode : BlendMode ) {
		var b = BITMAP_OBJ;
		if( b == null ) {
			var p = new h3d.prim.Quads([
				new h3d.Point(0, 0),
				new h3d.Point(1, 0),
				new h3d.Point(0, 1),
				new h3d.Point(1, 1),
			]);
			b = new h3d.CustomObject(p, new BitmapShader());
			b.material.culling = None;
			b.material.depth(false, Always);
			BITMAP_OBJ = b;
		}
		setBlendMode(b.material, blendMode);
		if( tile == null )
			tile = new Tile(emptyTexture(), 0, 0, 5, 5);
		var tmp = TMP_VECTOR;
		// adds 1/10 pixel size to prevent precision loss after scaling
		tmp.x = tile.width + 0.1;
		tmp.y = tile.height + 0.1;
		tmp.z = 1;
		b.shader.size = tmp;
		tmp.x = spr.matA;
		tmp.y = spr.matC;
		tmp.z = spr.absX + tile.dx * spr.matA + tile.dy * spr.matC;
		b.shader.mat1 = tmp;
		tmp.x = spr.matB;
		tmp.y = spr.matD;
		tmp.z = spr.absY + tile.dx * spr.matB + tile.dy * spr.matD;
		b.shader.mat2 = tmp;
		tmp.x = tile.u;
		tmp.y = tile.v;
		b.shader.uvPos = tmp;
		tmp.x = tile.u2 - tile.u;
		tmp.y = tile.v2 - tile.v;
		b.shader.uvScale = tmp;
		if( color == null ) {
			tmp.x = 1;
			tmp.y = 1;
			tmp.z = 1;
			tmp.w = 1;
			b.shader.color = tmp;
		} else
			b.shader.color = color.toVector();
		b.shader.tex = tile.getTexture();
		b.render(engine);
	}

	@:allow(h2d)
	static function setBlendMode( mat : h3d.mat.Material, b : BlendMode ) {
		switch( b ) {
		case Normal:
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
		case None:
			mat.blend(One, Zero);
		case Add:
			mat.blend(SrcAlpha, One);
		case Multiply:
			mat.blend(DstColor, OneMinusSrcAlpha);
		case Erase:
			mat.blend(Zero, OneMinusSrcAlpha);
		}
	}

	static var ETEX : h3d.mat.Texture = null;
	public static function emptyTexture() {
		if( ETEX == null || ETEX.isDisposed() ) {
			ETEX = h3d.Engine.getCurrent().mem.allocTexture(1, 1);
			var o = haxe.io.Bytes.alloc(4);
			o.set(0, 0xFF);
			o.set(2, 0xFF);
			o.set(3, 0xFF);
			ETEX.uploadBytes(o);
		}
		return ETEX;
	}
	
}