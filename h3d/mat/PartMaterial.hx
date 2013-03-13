package h3d.mat;

private class PartShader extends hxsl.Shader {

	static var SRC = {

		var input : {
			pos : Float3,
			uv : Float2,
			alpha : Float,
			frame : Float,
			rotation : Float,
			size : Float,
		};
		
		var tuv : Float2;
		var talpha : Float;
		var partSize : Float2;
		var frameCount : Float;
		
		var hasRotation : Bool;
		var hasSize : Bool;

		function vertex( mpos : M34, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			tpos.xyz = input.pos.xyzw * mpos;
			var tmp = tpos * mproj;
			var rpos = input.uv - 0.5;
			if( hasRotation ) {
				var cr = input.rotation.cos();
				var sr = input.rotation.sin();
				var tmp = rpos.x * cr + rpos.y * sr;
				rpos.y = rpos.y * cr - rpos.x * sr;
				rpos.x = tmp;
			}
			tmp.xy += rpos * (if( hasSize ) input.size * partSize else partSize);
			out = tmp;
			tuv = if( frameCount != null ) [input.uv.x*frameCount + input.frame,input.uv.y] else input.uv;
			talpha = input.alpha;
		}
		
		var killAlpha : Bool;
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
			var c = tex.get(tuv.xy,filter=!killAlpha);
			if( killAlpha ) kill(c.a - 0.001);
			if( colorAdd != null ) c += colorAdd;
			if( colorMul != null ) c = c * colorMul;
			if( colorMatrix != null ) c = c * colorMatrix;
			c.a *= talpha;
			out = c;
		}
	
	}
	
}

class PartMaterial extends Material {
	
	var pshader : PartShader;

	public var texture : Texture;
	public var killAlpha(get,set) : Bool;

	public var colorAdd(get,set) : Null<h3d.Vector>;
	public var colorMul(get,set) : Null<h3d.Vector>;
	public var colorMatrix(get,set) : Null<h3d.Matrix>;

	public function new(texture) {
		pshader = new PartShader();
		super(pshader);
		this.texture = texture;
		blend(SrcAlpha, One);
		culling = None;
		depthWrite = false;
		renderPass = 1;
	}
	
	override function clone( ?m : Material ) {
		var m = m == null ? new PartMaterial(texture) : cast m;
		super.clone(m);
		m.killAlpha = killAlpha;
		m.colorAdd = colorAdd;
		m.colorMul = colorMul;
		m.colorMatrix = colorMatrix;
		return m;
	}

	function setup( mpos, mproj, sizeX : Float, sizeY : Float, frameCount : Int, hasRotation, hasSize ) {
		pshader.mpos = mpos;
		pshader.mproj = mproj;
		pshader.tex = texture;
		pshader.hasRotation = hasRotation;
		pshader.hasSize = hasSize;
		pshader.partSize.x = sizeX;
		pshader.partSize.y = sizeY;
		pshader.frameCount = frameCount <= 1 ? null : 1 / frameCount;
	}
		
	inline function get_killAlpha() {
		return pshader.killAlpha;
	}

	inline function set_killAlpha(v) {
		return pshader.killAlpha = v;
	}

	inline function get_colorAdd() {
		return pshader.colorAdd;
	}

	inline function set_colorAdd(v) {
		return pshader.colorAdd = v;
	}

	inline function get_colorMul() {
		return pshader.colorMul;
	}

	inline function set_colorMul(v) {
		return pshader.colorMul = v;
	}

	inline function get_colorMatrix() {
		return pshader.colorMatrix;
	}

	inline function set_colorMatrix(v) {
		return pshader.colorMatrix = v;
	}
	
}