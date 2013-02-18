package h2d;

private class DrawableShader extends hxsl.Shader {
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

		function vertex( size : Float3, mat1 : Float3, mat2 : Float3 ) {
			var tmp : Float4;
			var spos = input.pos.xyw;
			if( size != null ) spos *= size;
			tmp.x = spos.dp3(mat1);
			tmp.y = spos.dp3(mat2);
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
		var alphaKill : Bool;
		
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

		function fragment( tex : Texture ) {
			var col = tex.get(sinusDeform != null ? [tuv.x + sin(tuv.y*sinusDeform.y + sinusDeform.x) * sinusDeform.z, tuv.y] : tuv, filter = ! !filter, wrap=tileWrap);
			if( alphaKill ) kill(col.a - 0.001);
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

class Drawable extends Sprite {
	
	static inline var HAS_SIZE = 1;
	static inline var HAS_UV_SCALE = 2;
	static inline var HAS_UV_POS = 4;

	var shader : DrawableShader;
	
	public var alpha(get, set) : Float;
	public var skew(get, set) : Null<Float>;
	
	public var filter(get, set) : Bool;
	public var color(get, set) : h3d.Vector;
	public var colorAdd(get, set) : h3d.Vector;
	public var colorMatrix(get, set) : h3d.Matrix;
	
	public var blendMode(default, set) : BlendMode;
	
	public var alphaMap(default, set) : h2d.Tile;

	public var sinusDeform(get, set) : h3d.Vector;
	public var tileWrap(get, set) : Bool;

	public var multiplyMap(default, set) : h2d.Tile;
	public var multiplyFactor(get, set) : Float;
	
	function new(parent) {
		super(parent);
		shader = new DrawableShader();
		shader.alpha = 1;
		shader.zValue = 0;
		blendMode = Normal;
	}
	
	inline function get_alpha() {
		return shader.alpha;
	}
	
	function set_alpha( v : Null<Float> ) {
		shader.alpha = v;
		shader.hasAlpha = v < 1;
		return v;
	}
	
	function set_blendMode(b) {
		blendMode = b;
		return b;
	}
	
	inline function get_skew() : Null<Float> {
		return shader.skew;
	}
	
	inline function set_skew(v : Null<Float> ) {
		return shader.skew = skew;
	}

	inline function get_multiplyFactor() {
		return shader.multMapFactor;
	}

	inline function set_multiplyFactor(v) {
		return shader.multMapFactor = v;
	}
	
	function set_multiplyMap(t:h2d.Tile) {
		multiplyMap = t;
		shader.hasMultMap = t != null;
		return t;
	}
	
	function set_alphaMap(t:h2d.Tile) {
		alphaMap = t;
		shader.hasAlphaMap = t != null;
		return t;
	}
	
	inline function get_sinusDeform() {
		return shader.sinusDeform;
	}

	inline function set_sinusDeform(v) {
		return shader.sinusDeform = v;
	}
	
	inline function get_colorMatrix() {
		return shader.colorMatrix;
	}
	
	inline function set_colorMatrix(m) {
		return shader.colorMatrix = m;
	}

	inline function set_colorAdd(m) {
		return shader.colorAdd = m;
	}

	inline function get_colorAdd() {
		return shader.colorAdd;
	}
	
	inline function get_color() {
		return shader.colorMul;
	}
	
	inline function set_color(m) {
		return shader.colorMul = m;
	}

	inline function get_filter() {
		return shader.filter;
	}
	
	inline function set_filter(v) {
		return shader.filter = v;
	}

	inline function get_tileWrap() {
		return shader.tileWrap;
	}
	
	inline function set_tileWrap(v) {
		return shader.tileWrap = v;
	}
	
	function drawTile( engine, tile ) {
		setupShader(engine, tile, HAS_SIZE | HAS_UV_POS | HAS_UV_SCALE);
		engine.renderQuadBuffer(Tools.getCoreObjects().planBuffer);
	}
	
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
		case Multiply:
			mat.blend(DstColor, OneMinusSrcAlpha);
		case Erase:
			mat.blend(Zero, OneMinusSrcAlpha);
		case Hide:
			mat.blend(Zero, One);
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
		
		var tmp = core.tmpMat1;
		tmp.x = matA;
		tmp.y = matC;
		tmp.z = absX + tile.dx * matA + tile.dy * matC;
		shader.mat1 = tmp;
		var tmp = core.tmpMat2;
		tmp.x = matB;
		tmp.y = matD;
		tmp.z = absY + tile.dx * matB + tile.dy * matD;
		shader.mat2 = tmp;
		shader.tex = tile.getTexture();
		mat.shader = shader;
		engine.selectMaterial(mat);
	}
	
}