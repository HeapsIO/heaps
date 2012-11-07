package h2d;

private class BitmapMatrixShader extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float2,
		};
		var tuv : Float2;
		function vertex( size : Float3, mat1 : Float3, mat2 : Float3, uvScale : Float2 ) {
			var tmp : Float4;
			var spos = pos.xyw * size;
			tmp.x = spos.dp3(mat1);
			tmp.y = spos.dp3(mat2);
			tmp.z = 0;
			tmp.w = 1;
			out = tmp;
			tuv = pos * uvScale;
		}
		function fragment( tex : Texture, mcolor : M44, acolor : Float4 ) {
			out = tex.get(tuv, nearest) * mcolor + acolor;
		}
	}
}

class CachedBitmap extends Sprite {

	var tex : h3d.mat.Texture;
	public var width(default, set) : Int;
	public var height(default, set) : Int;
	public var freezed : Bool;
	public var colorMatrix : Null<h3d.Matrix>;
	public var colorAdd : Null<h3d.Color>;
	
	var renderDone : Bool;
	var realWidth : Int;
	var realHeight : Int;
	var tile : TilePos;
	
	public function new( ?parent, width = -1, height = -1 ) {
		super(parent);
		this.width = width;
		this.height = height;
	}
	
	override function onDelete() {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		super.onDelete();
	}
	
	function set_width(w) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		width = w;
		return w;
	}

	function set_height(h) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		height = h;
		return h;
	}

	static var BITMAP_OBJ : h3d.CustomObject<BitmapMatrixShader> = null;
	static var TMP_VECTOR = new h3d.Vector();
	
	override function draw( engine : h3d.Engine ) {
		if( colorMatrix == null && colorAdd == null ) {
			Tools.drawTile(engine, this, tile, new h3d.Color(1, 1, 1, 1), blendMode);
			return;
		}
		var b = BITMAP_OBJ;
		if( b == null ) {
			var p = new h3d.prim.Quads([
				new h3d.Point(0, 0),
				new h3d.Point(1, 0),
				new h3d.Point(0, 1),
				new h3d.Point(1, 1),
			]);
			b = new h3d.CustomObject(p, new BitmapMatrixShader());
			b.material.culling = None;
			b.material.depth(false, Always);
			BITMAP_OBJ = b;
		}
		Tools.setBlendMode(b.material,blendMode);
		var tmp = TMP_VECTOR;
		tmp.x = tile.w;
		tmp.y = tile.h;
		tmp.z = 1;
		b.shader.size = tmp;
		tmp.x = matA;
		tmp.y = matC;
		tmp.z = absX + tile.dx * matA + tile.dy * matC;
		b.shader.mat1 = tmp;
		tmp.x = matB;
		tmp.y = matD;
		tmp.z = absY + tile.dx * matB + tile.dy * matD;
		b.shader.mat2 = tmp;
		tmp.x = tile.u2 - tile.u;
		tmp.y = tile.v2 - tile.v;
		b.shader.uvScale = tmp;
		b.shader.mcolor = colorMatrix == null ? h3d.Matrix.I() : colorMatrix;
		if( colorAdd == null ) {
			tmp.x = 0;
			tmp.y = 0;
			tmp.z = 0;
			tmp.w = 0;
		} else {
			tmp.x = colorAdd.r;
			tmp.y = colorAdd.g;
			tmp.z = colorAdd.b;
			tmp.w = colorAdd.a;
		}
		b.shader.acolor = tmp;
		b.shader.tex = tile.tiles.getTexture(engine);
		b.render(engine);
	}
	
	override function render( engine : h3d.Engine ) {
		updatePos();
		if( tex != null && ((width < 0 && tex.width < engine.width) || (height < 0 && tex.height < engine.height)) ) {
			tex.dispose();
			tex = null;
		}
		if( tex == null ) {
			var tw = 1, th = 1;
			realWidth = width < 0 ? engine.width : width;
			realHeight = height < 0 ? engine.height : height;
			while( tw < realWidth ) tw <<= 1;
			while( th < realHeight ) th <<= 1;
			tex = engine.mem.allocTargetTexture(tw, th);
			renderDone = false;
			tile = Tiles.fromTexture(tex).create(0, 0, realWidth, realHeight);
		}
		if( !freezed || !renderDone ) {
			var oldA = matA, oldB = matB, oldC = matC, oldD = matD, oldX = absX, oldY = absY;
			
			// init matrix without rotation
			matA = 1;
			matB = 0;
			matC = 0;
			matD = 1;
			absX = 0;
			absY = 0;
			
			// adds a pixels-to-viewport transform
			var w = 2 / tex.width;
			var h = -2 / tex.height;
			absX = absX * w - 1;
			absY = absY * h + 1;
			matA *= w;
			matB *= h;
			matC *= w;
			matD *= h;
			
			engine.setTarget(tex);
			engine.setRenderZone(0, 0, realWidth, realHeight);
			for( c in childs )
				c.render(engine);
			engine.setTarget(null);
			engine.setRenderZone();
			
			// restore
			matA = oldA;
			matB = oldB;
			matC = oldC;
			matD = oldD;
			absX = oldX;
			absY = oldY;
			
			renderDone = true;
		}

		draw(engine);
		posChanged = false;
	}
	
}