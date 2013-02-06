package h3d.mat;

private class MeshShader extends hxsl.Shader {
	
	static var SRC = {

		var input : {
			pos : Float3,
			normal : Float3,
			uv : Float2,
			weights : Float3,
			indexes : Int,
		};
		
		var tuv : Float2;
		
		var uvScale : Float2;
		var uvDelta : Float2;
		var hasSkin : Bool;
		var texWrap : Bool;
		var skinMatrixes : M34<39>;
		var tcolor : Float3;
		
		var lightSystem : Param<{
			var ambient : Float3;
			var dirs : Array<{ pos : Float3, color : Float3 }>;
			var points : Array<{ pos : Float3, pow : Float, color : Float3 }>;
		}>;
		
		function vertex( mpos : Matrix, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			if( hasSkin )
				tpos.xyz = tpos * input.weights.x * skinMatrixes[input.indexes.x * (255 * 3)] + tpos * input.weights.y * skinMatrixes[input.indexes.y * (255 * 3)] + tpos * input.weights.z * skinMatrixes[input.indexes.z * (255 * 3)];
			else if( mpos != null )
				tpos *= mpos;
			out = tpos * mproj;
			var t = input.uv;
			if( uvScale != null ) t *= uvScale;
			if( uvDelta != null ) t += uvDelta;
			tuv = t;
			if( lightSystem != null ) {
				var col = lightSystem.ambient;
				var n = if( mpos != null ) input.normal * mpos else input.normal;
				n = n.normalize();
				for( d in lightSystem.dirs )
					col += d.pos.dot(n).max(0) * d.color;
				for( p in lightSystem.points ) {
					var dist = tpos.xyz - p.pos;
					col += pow(dist.dot(dist), p.pow) * p.color;
				}
				tcolor = col;
			}
		}
		
		var killAlpha : Bool;
		var texNearest : Bool;
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
			var c = tex.get(tuv.xy,filter=!(killAlpha || texNearest),wrap=(texWrap || uvDelta != null));
			if( killAlpha ) kill(c.a - 0.001);
			if( colorAdd != null ) c += colorAdd;
			if( colorMul != null ) c = c * colorMul;
			if( colorMatrix != null ) c = c * colorMatrix;
			if( lightSystem != null ) c.rgb *= tcolor;
			out = c;
		}
		
	}
	
}

class MeshMaterial extends Material {

	var mshader : MeshShader;
	
	public var texture : Texture;

	public var useMatrixPos : Bool;
	public var uvScale(get,set) : Null<h3d.Vector>;
	public var uvDelta(get,set) : Null<h3d.Vector>;

	public var killAlpha(get,set) : Bool;
	public var texNearest(get, set) : Bool;
	public var texWrap(get, set) : Bool;

	public var colorAdd(get,set) : Null<h3d.Vector>;
	public var colorMul(get,set) : Null<h3d.Vector>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;
	
	public var hasSkin(get,set) : Bool;
	public var skinMatrixes(get,set) : Array<h3d.Matrix>;
	
	public var lightSystem(get,set) : {
		var ambient : h3d.Vector;
		var dirs : Array<{ pos : h3d.Vector, color : h3d.Vector }>;
		var points : Array<{ pos : h3d.Vector, pow : Float, color : h3d.Vector }>;
	};
	
	public function new(texture) {
		mshader = new MeshShader();
		super(mshader);
		this.texture = texture;
		useMatrixPos = true;
	}
	
	override function clone( ?m : Material ) {
		var m = m == null ? new MeshMaterial(texture) : cast m;
		super.clone(m);
		m.useMatrixPos = useMatrixPos;
		m.uvScale = uvScale;
		m.uvDelta = uvDelta;
		m.killAlpha = killAlpha;
		m.colorAdd = colorAdd;
		m.colorMul = colorMul;
		m.colorMatrix = colorMatrix;
		m.hasSkin = hasSkin;
		m.skinMatrixes = skinMatrixes;
		return m;
	}
	
	function setup( mpos, mproj ) {
		mshader.mpos = useMatrixPos ? mpos : null;
		mshader.mproj = mproj;
		mshader.tex = texture;
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

	inline function get_texNearest() {
		return mshader.texNearest;
	}

	inline function set_texNearest(v) {
		return mshader.texNearest = v;
	}

	inline function get_texWrap() {
		return mshader.texWrap;
	}

	inline function set_texWrap(v) {
		return mshader.texWrap = v;
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
	
	inline function get_skinMatrixes() {
		return mshader.skinMatrixes;
	}
	
	inline function set_skinMatrixes(v) {
		return mshader.skinMatrixes = v;
	}
	
	inline function get_lightSystem() {
		return mshader.lightSystem;
	}

	inline function set_lightSystem(v) {
		return mshader.lightSystem = v;
	}
	
}
