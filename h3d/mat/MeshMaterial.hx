package h3d.mat;

typedef LightSystem = {
	var ambient : h3d.Vector;
	var dirs : Array<{ dir : h3d.Vector, color : h3d.Vector }>;
	var points : Array<{ pos : h3d.Vector, color : h3d.Vector, att : h3d.Vector }>;
}

typedef ShadowMap = {
	var lightProj : h3d.Matrix;
	var lightCenter : h3d.Matrix;
	var color : h3d.Vector;
	var texture : Texture;
}

private class MeshShader extends hxsl.Shader {
	
	static var SRC = {

		var input : {
			pos : Float3,
			uv : Float2,
			normal : Float3,
			color : Float3,
			colorAdd : Float3,
			blending : Float,
			weights : Float3,
			indexes : Int,
		};
		
		var tuv : Float2;
		
		var uvScale : Float2;
		var uvDelta : Float2;
		var hasSkin : Bool;
		var hasVertexColor : Bool;
		var hasVertexColorAdd : Bool;
		var skinMatrixes : M34<34>;

		var tcolor : Float3;
		var acolor : Float3;
		var talpha : Float;
		
		var zBias : Float;
		var hasZBias : Bool;
		
		var alphaMap : Texture;
		var hasAlphaMap : Bool;
		
		var lightSystem : Param < {
			var ambient : Float3;
			var dirs : Array<{ dir : Float3, color : Float3 }>;
			var points : Array<{ pos : Float3, color : Float3, att : Float3 }>;
		}>;
		
		var fog : Float4;
		
		var glowTexture : Texture;
		var glowAmount : Float;
		var hasGlow : Bool;
		
		var blendTexture : Texture;
		var hasBlend : Bool;
		var tblend : Float;

		var hasShadowMap : Bool;
		var shadowLightProj : Matrix;
		var shadowLightCenter : Matrix;
		var shadowColor : Float4;
		var shadowTexture : Texture;
		var tshadowPos : Float4;
		
		var mposInv : Matrix;
		
		function vertex( mpos : Matrix, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			if( hasSkin )
				tpos.xyz = tpos * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + tpos * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + tpos * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
			else if( mpos != null )
				tpos *= mpos;
			var ppos = tpos * mproj;
			if( hasZBias ) ppos.z += zBias;
			out = ppos;
			var t = input.uv;
			if( uvScale != null ) t *= uvScale;
			if( uvDelta != null ) t += uvDelta;
			tuv = t;
			if( lightSystem != null ) {
				// calculate normal
				var n = input.normal;
				if( mpos != null ) n *= mpos;
				if( hasSkin ) {
					n = n * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + n * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + n * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
					if( mpos != null ) n = n * mposInv;
				}
				var col = lightSystem.ambient;
				n = n.normalize();
				for( d in lightSystem.dirs )
					col += d.color * n.dot(-d.dir).max(0);
				for( p in lightSystem.points ) {
					var d = tpos.xyz - p.pos;
					var dist2 = d.dot(d);
					var dist = dist2.sqt();
					col += p.color * (n.dot(d).max(0) / (p.att.x * dist + p.att.y * dist2 + p.att.z * dist2 * dist));
				}
				if( hasVertexColor )
					tcolor = col * input.color;
				else
					tcolor = col;
			} else if( hasVertexColor )
				tcolor = input.color;
			if( hasVertexColorAdd )
				acolor = input.colorAdd;
			if( fog != null ) {
				var dist = tpos.xyz - fog.xyz;
				talpha = (fog.w * dist.dot(dist).rsqrt()).min(1);
			}
			if( hasBlend ) tblend = input.blending;
			if( hasShadowMap )
				tshadowPos = tpos * shadowLightProj * shadowLightCenter;
		}
		
		var killAlpha : Bool;
		var killAlphaThreshold : Float;
		var isDXT1 : Bool;
		var isDXT5 : Bool;
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
			var c = tex.get(tuv.xy,type=isDXT1 ? 1 : isDXT5 ? 2 : 0);
			if( fog != null ) c.a *= talpha;
			if( hasAlphaMap ) c.a *= alphaMap.get(tuv.xy,type=isDXT1 ? 1 : isDXT5 ? 2 : 0).b;
			if( killAlpha ) kill(c.a - killAlphaThreshold);
			if( hasBlend ) c.rgb = c.rgb * (1 - tblend) + tblend * blendTexture.get(tuv.xy,type=isDXT1 ? 1 : isDXT5 ? 2 : 0).rgb;
			if( colorAdd != null ) c += colorAdd;
			if( colorMul != null ) c = c * colorMul;
			if( colorMatrix != null ) c = c * colorMatrix;
			if( hasVertexColorAdd )
				c.rgb += acolor;
			if( lightSystem != null || hasVertexColor )
				c.rgb *= tcolor;
			if( hasShadowMap ) {
				// ESM filtering
				var shadow = exp( shadowColor.w * (tshadowPos.z - shadowTexture.get(tshadowPos.xy).dot([1, 1 / 255, 1 / (255 * 255), 1 / (255 * 255 * 255)]))).sat();
				c.rgb *= (1 - shadow) * shadowColor.rgb + shadow.xxx;
			}
			if( hasGlow ) c.rgb += glowTexture.get(tuv.xy).rgb * glowAmount;
			out = c;
		}
		
	}
	
}

class MeshMaterial extends Material {

	var mshader : MeshShader;
	
	public var texture : Texture;
	public var glowTexture(get,set) : Texture;
	public var glowAmount(get,set) : Float;

	public var useMatrixPos : Bool;
	public var uvScale(get,set) : Null<h3d.Vector>;
	public var uvDelta(get,set) : Null<h3d.Vector>;

	public var killAlpha(get,set) : Bool;

	public var hasVertexColor(get, set) : Bool;
	public var hasVertexColorAdd(get,set) : Bool;
	
	public var colorAdd(get,set) : Null<h3d.Vector>;
	public var colorMul(get,set) : Null<h3d.Vector>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;
	
	public var hasSkin(get,set) : Bool;
	public var skinMatrixes(get,set) : Array<h3d.Matrix>;
	
	public var lightSystem(get, set) : LightSystem;
	
	public var alphaMap(get, set): Texture;
	
	public var fog(get, set) : h3d.Vector;
	public var zBias(get, set) : Null<Float>;
	
	public var blendTexture(get, set) : Texture;
	
	public var killAlphaThreshold(get, set) : Float;
	
	
	public var shadowMap(null, set) : ShadowMap;
	
	public function new(texture) {
		mshader = new MeshShader();
		super(mshader);
		this.texture = texture;
		useMatrixPos = true;
		killAlphaThreshold = 0.001;
	}
	
	override function clone( ?m : Material ) {
		var m = m == null ? new MeshMaterial(texture) : cast m;
		super.clone(m);
		m.useMatrixPos = useMatrixPos;
		m.uvScale = uvScale;
		m.uvDelta = uvDelta;
		m.killAlpha = killAlpha;
		m.hasVertexColor = hasVertexColor;
		m.hasVertexColorAdd = hasVertexColorAdd;
		m.colorAdd = colorAdd;
		m.colorMul = colorMul;
		m.colorMatrix = colorMatrix;
		m.hasSkin = hasSkin;
		m.skinMatrixes = skinMatrixes;
		m.lightSystem = lightSystem;
		m.alphaMap = alphaMap;
		m.fog = fog;
		m.zBias = zBias;
		m.blendTexture = blendTexture;
		m.killAlphaThreshold = killAlphaThreshold;
		return m;
	}
	
	function setup( camera : h3d.Camera, mpos ) {
		mshader.mpos = useMatrixPos ? mpos : null;
		mshader.mproj = camera.m;
		if( mshader.hasSkin && useMatrixPos && mshader.lightSystem != null ) {
			var tmp = new h3d.Matrix();
			tmp.inverse(mpos);
			mshader.mposInv = tmp;
			trace(tmp);
		}
		mshader.tex = texture;
	}
	
	/**
		Set the DXT compression access mode for all textures of this material.
	**/
	public function setDXTSupport( enable : Bool, alpha = false ) {
		if( !enable ) {
			mshader.isDXT1 = false;
			mshader.isDXT5 = false;
		} else {
			mshader.isDXT1 = !alpha;
			mshader.isDXT5 = alpha;
		}
	}
	
	inline function get_uvScale() {
		return mshader.uvScale;
	}

	inline function set_uvScale(v) {
		return mshader.uvScale = v;
	}

	inline function get_uvDelta() {
		return mshader.uvDelta;
	}

	inline function set_uvDelta(v) {
		return mshader.uvDelta = v;
	}

	inline function get_killAlpha() {
		return mshader.killAlpha;
	}

	inline function set_killAlpha(v) {
		return mshader.killAlpha = v;
	}

	inline function get_colorAdd() {
		return mshader.colorAdd;
	}

	inline function set_colorAdd(v) {
		return mshader.colorAdd = v;
	}

	inline function get_colorMul() {
		return mshader.colorMul;
	}

	inline function set_colorMul(v) {
		return mshader.colorMul = v;
	}

	inline function get_colorMatrix() {
		return mshader.colorMatrix;
	}

	inline function set_colorMatrix(v) {
		return mshader.colorMatrix = v;
	}
	
	inline function get_hasSkin() {
		return mshader.hasSkin;
	}
	
	inline function set_hasSkin(v) {
		return mshader.hasSkin = v;
	}

	inline function get_hasVertexColor() {
		return mshader.hasVertexColor;
	}
	
	inline function set_hasVertexColor(v) {
		return mshader.hasVertexColor = v;
	}
	
	inline function get_hasVertexColorAdd() {
		return mshader.hasVertexColorAdd;
	}
	
	inline function set_hasVertexColorAdd(v) {
		return mshader.hasVertexColorAdd = v;
	}
	
	inline function get_skinMatrixes() {
		return mshader.skinMatrixes;
	}
	
	inline function set_skinMatrixes( v : Array<h3d.Matrix> ) {
		if( v != null && v.length > 35 )
			throw "Maximum 35 bones are allowed for skinning (has "+v.length+")";
		return mshader.skinMatrixes = v;
	}
	
	inline function get_lightSystem() : LightSystem {
		return mshader.lightSystem;
	}

	inline function set_lightSystem(v:LightSystem) {
		if( v != null && hasSkin && v.dirs.length + v.points.length > 6 )
			throw "Maximum 6 lights are allowed with skinning ("+(v.dirs.length+v.points.length)+" set)";
		return mshader.lightSystem = v;
	}
	
	inline function get_alphaMap() {
		return mshader.alphaMap;
	}
	
	inline function set_alphaMap(m) {
		mshader.hasAlphaMap = m != null;
		return mshader.alphaMap = m;
	}
	
	inline function get_zBias() {
		return mshader.hasZBias ? mshader.zBias : null;
	}

	inline function set_zBias(v : Null<Float>) {
		mshader.hasZBias = v != null;
		mshader.zBias = v;
		return v;
	}
	
	inline function get_glowTexture() {
		return mshader.glowTexture;
	}

	inline function set_glowTexture(t) {
		mshader.hasGlow = t != null;
		return mshader.glowTexture = t;
	}
	
	inline function get_glowAmount() {
		return mshader.glowAmount;
	}

	inline function set_glowAmount(v) {
		return mshader.glowAmount = v;
	}

	inline function get_fog() {
		return mshader.fog;
	}

	inline function set_fog(v) {
		return mshader.fog = v;
	}
	
	inline function get_blendTexture() {
		return mshader.blendTexture;
	}
	
	inline function set_blendTexture(v) {
		mshader.hasBlend = v != null;
		return mshader.blendTexture = v;
	}
	
	inline function get_killAlphaThreshold() {
		return mshader.killAlphaThreshold;
	}
	
	inline function set_killAlphaThreshold(v) {
		return mshader.killAlphaThreshold = v;
	}
	
	inline function set_shadowMap(v:ShadowMap) {
		if( v != null ) {
			mshader.hasShadowMap = true;
			mshader.shadowColor = v.color;
			mshader.shadowTexture = v.texture;
			mshader.shadowLightProj = v.lightProj;
			mshader.shadowLightCenter = v.lightCenter;
		} else
			mshader.hasShadowMap = false;
		return v;
	}
	
	
}
