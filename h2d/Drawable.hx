package h2d;

private class DrawableShader extends h3d.impl.Shader {
	#if flash
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
				kill(cdiff.dot(cdiff) - 0.001);
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
	
	#elseif js
	
	public var hasColorKey : Bool;
	
	// not supported
	public var skew : Float;
	public var sinusDeform : h3d.Vector;
	public var hasAlphaMap : Bool;
	public var hasMultMap : Bool;
	public var multMap : h3d.mat.Texture;
	public var multUV : h3d.Vector;
	public var multMapFactor : Float;
	public var alphaMap : h3d.mat.Texture;
	public var alphaUV : h3d.Vector;
	// --
	
	public var filter : Bool;
	public var tileWrap : Bool;
	public var killAlpha : Bool;
	public var hasAlpha : Bool;
	public var hasVertexAlpha : Bool;
	
	override function customSetup(driver:h3d.impl.WebglDriver) {
		driver.setupTexture(tex, None, filter ? Linear : Nearest, tileWrap ? Repeat : Clamp);
	}
	
	override function getConstants( vertex : Bool ) {
		var cst = [];
		if( vertex ) {
			if( size != null ) cst.push("#define hasSize");
			if( uvScale != null ) cst.push("#define hasUVScale");
			if( uvPos != null ) cst.push("#define hasUVPos");
		} else {
			if( killAlpha ) cst.push("#define killAlpha");
			if( hasColorKey ) cst.push("#define hasColorKey");
			if( hasAlpha ) cst.push("#define hasAlpha");
			if( colorMatrix != null ) cst.push("#define hasColorMatrix");
			if( colorMul != null ) cst.push("#define hasColorMul");
			if( colorAdd != null ) cst.push("#define hasColorAdd");
		}
		if( hasVertexAlpha ) cst.push("#define hasVertexAlpha");
		return cst.join("\n");
	}
	
	static var VERTEX = "
	
		attribute vec2 pos;
		attribute vec2 uv;
		#if hasVertexAlpha
		attribute float alpha;
		varying lowp float talpha;
		#end

		uniform vec3 size;
		uniform vec3 matA;
		uniform vec3 matB;
		uniform lowp float zValue;
		
		uniform vec2 uvPos;
		uniform vec2 uvScale;
		
		varying lowp vec2 tuv;

		void main(void) {
			vec3 spos = vec3(pos.xy, 1.0);
			#if hasSize
				spos = spos * size;
			#end
			vec4 tmp;
			tmp.x = dot(spos,matA);
			tmp.y = dot(spos,matB);
			tmp.z = zValue;
			tmp.w = 1.;
			gl_Position = tmp;
			vec2 t = uv;
			#if hasUVScale
				t *= uvScale;
			#end
			#if hasUVPos
				t += uvPos;
			#end
			tuv = t;
			#if hasVertexAlpha
				talpha = alpha;
			#end
		}

	";
	
	static var FRAGMENT = "
	
		varying lowp vec2 tuv;
		uniform sampler2D tex;
		
		#if hasVertexAlpha
		varying lowp float talpha;
		#end
		
		uniform lowp float alpha;
		uniform lowp vec3 colorKey/*byte4*/;
	
		uniform lowp vec4 colorAdd;
		uniform lowp vec4 colorMul;
		uniform mediump mat4 colorMatrix;

		void main(void) {
			lowp vec4 col = texture2D(tex, tuv);
			#if killAlpha
				if( c.a - 0.001 ) discard;
			#end
			#if hasColorKey
				if( col.rgb == colorKey ) discard;
			#end
			#if hasAlpha
				col.w *= alpha;
			#end
			#if hasVertexAlpha
				col.a *= talpha;
			#end
			#if hasColorMatrix
				col = colorMatrix * col;
			#end
			#if hasColorMul
				col *= colorMul;
			#end
			#if hasColorAdd
				col += colorAdd;
			#end
			gl_FragColor = col;
		}
			
	";
	
	#end
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
	public var killAlpha(get, set) : Bool;

	public var multiplyMap(default, set) : h2d.Tile;
	public var multiplyFactor(get, set) : Float;
	
	public var colorKey(get, set) : Int;
	
	public var writeAlpha : Bool;
	
	function new(parent) {
		super(parent);
		shader = new DrawableShader();
		shader.alpha = 1;
		shader.zValue = 0;
		writeAlpha = true;
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

	inline function get_killAlpha() {
		return shader.killAlpha;
	}
	
	inline function set_killAlpha(v) {
		return shader.killAlpha = v;
	}

	inline function get_colorKey() {
		return shader.colorKey;
	}
	
	inline function set_colorKey(v) {
		shader.hasColorKey = true;
		return shader.colorKey = v;
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
	}
	
}