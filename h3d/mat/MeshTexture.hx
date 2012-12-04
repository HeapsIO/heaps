package h3d.mat;

private class MeshShader extends h3d.Shader {
	
	static var SRC = {

		var input : {
			pos : Float3,
			uv : Float2,
		};
		
		var tuv : Float2;
		
		var useMatrixPos : Bool;
		var uvScale : Float2;
		var uvDelta : Float2;
		
		function vertex( mpos : Matrix, mproj : Matrix ) {
			out = if( useMatrixPos ) (pos.xyzw * mpos) * mproj else pos.xyzw * mproj;
			var t = uv;
			if( uvScale != null ) t *= uvScale;
			if( uvDelta != null ) t += uvDelta;
			tuv = t;
		}
		
		function fragment( tex : Texture, killAlpha : Bool, colorDelta : Float4, colorMult : Float4, colorMatrix : M44 ) {
			var c = tex.get(tuv.xy);
			if( killAlpha ) kill(c.a - 0.001);
			if( colorDelta != null ) c += colorDelta;
			if( colorMult != null ) c = c * colorMult;
			if( colorMatrix != null ) c = c * colorMatrix;
			out = c;
		}
		
	}
	
}

class MeshTexture extends MeshMaterial {

	var mshader : MeshShader;
	
	public var texture : Texture;

	public var useMatrixPos : Bool;
	public var uvScale(get,set) : Null<h3d.Vector>;
	public var uvDelta(get,set) : Null<h3d.Vector>;

	public var killAlpha(get,set) : Bool;

	public var colorDelta(get,set) : Null<h3d.Color>;
	public var colorMult(get,set) : Null<h3d.Color>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;
	
	public function new(texture) {
		mshader = new MeshShader();
		super(mshader);
		this.texture = texture;
		useMatrixPos = true;
	}
	
	public override function setMatrixes( mpos, mproj ) {
		mshader.mpos = useMatrixPos ? mpos : null;
		mshader.mproj = mproj;
		mshader.tex = texture;
	}
	
	inline function get_uvScale() {
		return mshader.uvScale;
	}

	inline function set_uvScale(v) {
		mshader.uvScale = v;
		return v;
	}

	inline function get_uvDelta() {
		return mshader.uvDelta;
	}

	inline function set_uvDelta(v) {
		mshader.uvDelta = v;
		return v;
	}

	inline function get_killAlpha() {
		return mshader.killAlpha;
	}

	inline function set_killAlpha(v) {
		mshader.killAlpha = v;
		return v;
	}

	inline function get_colorDelta() {
		return mshader.colorDelta;
	}

	inline function set_colorDelta(v) {
		mshader.colorDelta = v;
		return v;
	}

	inline function get_colorMult() {
		return mshader.colorMult;
	}

	inline function set_colorMult(v) {
		mshader.colorMult = v;
		return v;
	}

	inline function get_colorMatrix() {
		return mshader.colorMatrix;
	}

	inline function set_colorMatrix(v) {
		mshader.colorMatrix = v;
		return v;
	}
	
}
