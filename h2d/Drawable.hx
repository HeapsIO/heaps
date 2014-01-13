package h2d;

/*
private class DrawableShader extends h3d.impl.Shader {

	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
			valpha : Float,
			vcolor : Float4,
		};
		var tuv : Float2;
		var tcolor : Float4;
		var talpha : Float;

		var hasVertexColor : Bool;
		var hasVertexAlpha : Bool;
		var uvScale : Float2;
		var uvPos : Float2;
		var skew : Float;
		var zValue : Float;

		function vertex( size : Float3, matA : Float3, matB : Float3 ) {
			var tmp : Float4;
			var spos = input.pos.xyw;
			if( size != null ) spos *= size;
			tmp.x = spos.dp3(matA);
			tmp.y = spos.dp3(matB);
			tmp.z = zValue;
			tmp.w = skew != null ? 1 - skew * input.pos.y : 1;
			out = tmp;
			var t = input.uv;
			if( uvScale != null ) t *= uvScale;
			if( uvPos != null ) t += uvPos;
			tuv = t;
			if( hasVertexColor ) tcolor = input.vcolor;
			if( hasVertexAlpha ) talpha = input.valpha;
		}
		
		var hasAlpha : Bool;
		var killAlpha : Bool;
		
		var alpha : Float;
		var colorAdd : Float4;
		var colorMul : Float4;
		var colorMatrix : M44;

		var hasAlphaMap : Bool;
		var alphaMap : Texture;
		var alphaUV : Float4;
		var filter : Bool;
		
		var sinusDeform : Float3;
		var tileWrap : Bool;

		var hasMultMap : Bool;
		var multMapFactor : Float;
		var multMap : Texture;
		var multUV : Float4;
		var hasColorKey : Bool;
		var colorKey : Int;

		function fragment( tex : Texture ) {
			var col = tex.get(sinusDeform != null ? [tuv.x + sin(tuv.y * sinusDeform.y + sinusDeform.x) * sinusDeform.z, tuv.y] : tuv, filter = ! !filter, wrap = tileWrap);
			if( hasColorKey ) {
				var cdiff = col.rgb - colorKey.rgb;
				kill(cdiff.dot(cdiff) - 0.00001);
			}
			if( killAlpha ) kill(col.a - 0.001);
			if( hasVertexAlpha ) col.a *= talpha;
			if( hasVertexColor ) col *= tcolor;
			if( hasAlphaMap ) col.a *= alphaMap.get(tuv * alphaUV.zw + alphaUV.xy).r;
			if( hasMultMap ) col *= multMap.get(tuv * multUV.zw + multUV.xy) * multMapFactor;
			if( hasAlpha ) col.a *= alpha;
			if( colorMatrix != null ) col *= colorMatrix;
			if( colorMul != null ) col *= colorMul;
			if( colorAdd != null ) col += colorAdd;
			out = col;
		}


	}
	
}
*/

class Drawable extends Sprite {
	
	public var color : h3d.Vector;
	public var alpha(get, set) : Float;
	public var blendMode : BlendMode;
	
	function new(parent) {
		super(parent);
		blendMode = Normal;
		color = new h3d.Vector(1, 1, 1, 1);
	}
	
	inline function get_alpha() {
		return color.a;
	}

	inline function set_alpha(v) {
		return color.a = v;
	}
	
	function emitTile( ctx : RenderContext, tile : Tile ) {
		if( tile == null )
			tile = new Tile(null, 0, 0, 5, 5);
		ctx.beginDraw(tile.getTexture(), 8);

		var ax = absX + tile.dx * matA + tile.dy * matC;
		var ay = absY + tile.dx * matB + tile.dy * matD;
		var buf = ctx.buffer;
		var pos = ctx.bufPos;
		buf.grow(pos + 4 * 8);
		
		inline function emit(v:Float) buf[pos++] = v;
		
		emit(ax);
		emit(ay);
		emit(tile.u);
		emit(tile.v);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);
		
		emit(ax + matA);
		emit(ay + matB);
		emit(tile.u2);
		emit(tile.v);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);
		
		emit(ax + matC);
		emit(ay + matD);
		emit(tile.u);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);

		emit(ax + matA + matC);
		emit(ay + matB + matD);
		emit(tile.u2);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);

		ctx.bufPos = pos;
	}

	/*
	function drawTile( engine, tile ) {
		//setupShader(engine, tile, HAS_SIZE | HAS_UV_POS | HAS_UV_SCALE);
		//engine.renderQuadBuffer(Tools.getCoreObjects().planBuffer);
	}

	/*
	function setupShader( engine : h3d.Engine, tile : h2d.Tile, options : Int ) {
		var core = Tools.getCoreObjects();
		var shader = shader;
		var mat = core.tmpMaterial;

		if( tile == null )
			tile = new Tile(core.getEmptyTexture(), 0, 0, 5, 5);

		switch( blendMode ) {
		case Normal:
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
		case None:
			mat.blend(One, Zero);
		case Add:
			mat.blend(SrcAlpha, One);
		case SoftAdd:
			mat.blend(OneMinusDstColor, One);
		case Multiply:
			mat.blend(DstColor, OneMinusSrcAlpha);
		case Erase:
			mat.blend(Zero, OneMinusSrcAlpha);
		}

		if( options & HAS_SIZE != 0 ) {
			var tmp = core.tmpSize;
			// adds 1/10 pixel size to prevent precision loss after scaling
			tmp.x = tile.width + 0.1;
			tmp.y = tile.height + 0.1;
			tmp.z = 1;
			shader.size = tmp;
		}
		if( options & HAS_UV_POS != 0 ) {
			core.tmpUVPos.x = tile.u;
			core.tmpUVPos.y = tile.v;
			shader.uvPos = core.tmpUVPos;
		}
		if( options & HAS_UV_SCALE != 0 ) {
			core.tmpUVScale.x = tile.u2 - tile.u;
			core.tmpUVScale.y = tile.v2 - tile.v;
			shader.uvScale = core.tmpUVScale;
		}
		
		if( shader.hasAlphaMap ) {
			shader.alphaMap = alphaMap.getTexture();
			shader.alphaUV = new h3d.Vector(alphaMap.u, alphaMap.v, (alphaMap.u2 - alphaMap.u) / tile.u2, (alphaMap.v2 - alphaMap.v) / tile.v2);
		}

		if( shader.hasMultMap ) {
			shader.multMap = multiplyMap.getTexture();
			shader.multUV = new h3d.Vector(multiplyMap.u, multiplyMap.v, (multiplyMap.u2 - multiplyMap.u) / tile.u2, (multiplyMap.v2 - multiplyMap.v) / tile.v2);
		}
		
		var cm = writeAlpha ? 15 : 7;
		if( mat.colorMask != cm ) mat.colorMask = cm;
		
		var tmp = core.tmpMatA;
		tmp.x = matA;
		tmp.y = matC;
		tmp.z = absX + tile.dx * matA + tile.dy * matC;
		shader.matA = tmp;
		var tmp = core.tmpMatB;
		tmp.x = matB;
		tmp.y = matD;
		tmp.z = absY + tile.dx * matB + tile.dy * matD;
		shader.matB = tmp;
		shader.tex = tile.getTexture();
		mat.shader = shader;
		engine.selectMaterial(mat);
	}*/
	
}
