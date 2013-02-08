package h3d.mat;

typedef LightSystem = {
	var ambient : h3d.Vector;
	var dirs : Array<{ pos : h3d.Vector, color : h3d.Vector }>;
	var points : Array<{ pos : h3d.Vector, color : h3d.Vector }>;
}

private class MeshShader extends hxsl.Shader {
	
	static var SRC = {

		var input : {
			pos : Float3,
			uv : Float2,
			normal : Float3,
			color : Float3,
			colorAdd : Float3,
			weights : Float3,
			indexes : Int,
		};
		
		var tuv : Float2;
		
		var uvScale : Float2;
		var uvDelta : Float2;
		var hasSkin : Bool;
		var hasVertexColor : Bool;
		var hasVertexColorAdd : Bool;
		var texWrap : Bool;
		var skinMatrixes : M34<35>;

		var tcolor : Float3;
		var acolor : Float3;
		var talpha : Float;
		
		var zBias : Float;
		var hasZBias : Bool;
		
		var alphaMap : Texture;
		var hasAlphaMap : Bool;
		
		var lightSystem : Param<{
			var ambient : Float3;
			var dirs : Array<{ pos : Float3, color : Float3 }>;
			var points : Array<{ pos : Float3, color : Float4 }>;
		}>;
		
		var fog : Float4;
		
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
				var col = lightSystem.ambient;
				var n = if( mpos != null ) input.normal * mpos else input.normal;
				n = n.normalize();
				for( d in lightSystem.dirs )
					col += d.pos.dot(n).max(0) * d.color;
				if( hasVertexColor )
					tcolor = col * input.color;
				else
					tcolor = col;
				var acol = [0, 0, 0];
				for( p in lightSystem.points ) {
					var dist = tpos.xyz - p.pos;
					acol += p.color.rgb * (dist.dot(dist) + p.color.a).inv();
				}
				if( hasVertexColorAdd )
					acolor = acol + input.colorAdd;
				else
					acolor = acol;
			} else {
				if( hasVertexColor )
					tcolor = input.color;
				if( hasVertexColorAdd )
					acolor = input.colorAdd;
			}
			if( fog != null ) {
				var dist = tpos.xyz - fog.xyz;
				talpha = (fog.w * dist.dot(dist).rsqrt()).min(1);
			}
		}
		
		var killAlpha : Bool;
		var texNearest : Bool;
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
			var c = tex.get(tuv.xy, filter = !(killAlpha || texNearest), wrap = (texWrap || uvDelta != null));
			if( fog != null ) c.a *= talpha;
			if( hasAlphaMap ) c.a *= alphaMap.get(tuv.xy,filter = !(killAlpha || texNearest)).b;
			if( killAlpha ) kill(c.a - 0.001);
			if( colorAdd != null ) c += colorAdd;
			if( colorMul != null ) c = c * colorMul;
			if( colorMatrix != null ) c = c * colorMatrix;
			if( lightSystem != null ) {
				c.rgb *= tcolor;
				c.rgb += acolor;
			} else {
				if( hasVertexColor )
					c.rgb *= tcolor;
				if( hasVertexColorAdd )
					c.rgb += acolor;
			}
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

	public var hasVertexColor(get, set) : Bool;
	public var hasVertexColorAdd(get,set) : Bool;
	
	public var colorAdd(get,set) : Null<h3d.Vector>;
	public var colorMul(get,set) : Null<h3d.Vector>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;
	
	public var hasSkin(get,set) : Bool;
	public var skinMatrixes(get,set) : Array<h3d.Matrix>;
	
	public var lightSystem(get, set) : LightSystem;
	
	public var alphaMap(get, set): Texture;
	
	public var fog : Null<Float>;
	public var zBias(get,set) : Null<Float>;
	
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
		m.texNearest = texNearest;
		m.texWrap = texWrap;
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
		return m;
	}
	
	function setup( camera : h3d.Camera, mpos ) {
		mshader.fog = fog == null ? null : new h3d.Vector(camera.pos.x, camera.pos.y, camera.pos.z, fog);
		mshader.mpos = useMatrixPos ? mpos : null;
		mshader.mproj = camera.m;
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
	
	inline function get_lightSystem() {
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
	
}
