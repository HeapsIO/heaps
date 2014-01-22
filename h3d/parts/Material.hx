package h3d.parts;

private class PartShader extends h3d.impl.Shader {

#if flash
	static var SRC = {

		var input : {
			pos : Float3,
			delta : Float2,
			rotation : Float,
			size : Float2,
			uv : Float2,
			color : Float4,
		};
		
		var tuv : Float2;
		var tcolor : Float4;
		var partSize : Float2;
		
		var hasColor : Bool;
		var is3D : Bool;
		
		var isAlphaMap : Bool;

		function vertex( mpos : M34, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			tpos.xyz = input.pos.xyzw * mpos;
			var rpos = input.delta;
			var cr = input.rotation.cos();
			var sr = input.rotation.sin();
			var rtmp = rpos.x * cr + rpos.y * sr;
			rpos.y = rpos.y * cr - rpos.x * sr;
			rpos.x = rtmp;
			if( is3D ) {
				rpos.xy *= input.size * partSize;
				tpos.x += rpos.x;
				tpos.z += rpos.y;
				out = tpos * mproj;
			} else {
				var tmp = tpos * mproj;
				tmp.xy += rpos * input.size * partSize;
				out = tmp;
			}
			tuv = input.uv;
			if( hasColor ) tcolor = input.color;
		}
		
		function fragment( tex : Texture ) {
			var c = tex.get(tuv.xy);
			if( hasColor ) c *= tcolor;
			if( isAlphaMap ) {
				c.a *= c.rgb.dot([1 / 3, 1 / 3, 1 / 3]);
				c.rgb = [1, 1, 1];
			}
			out = c;
		}
	
	}
#else
	static var VERTEX = "";
	static var FRAGMENT = "";
#end

}

class Material extends h3d.mat.Material {
	
	var pshader : PartShader;
	public var texture(default,set) : h3d.mat.Texture;

	public function new(?texture) {
		pshader = new PartShader();
		super(pshader);
		this.texture = texture;
		blend(SrcAlpha, One);
		culling = None;
		depthWrite = false;
	}
	
	override function clone( ?m : h3d.mat.Material ) {
		var m = m == null ? new Material(texture) : cast m;
		super.clone(m);
		return m;
	}

	inline function set_texture(t) {
		return pshader.tex = t;
	}
	
}