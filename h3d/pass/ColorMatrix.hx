package h3d.pass;

class ColorMatrixShader extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var matrix : Mat4;

		function fragment() {
			output.color = texture.get(input.uv) * matrix;
		}

	};

}

class ColorMatrix extends ScreenFx<ColorMatrixShader> {

	public var matrix(get, set) : h3d.Matrix;

	public function new( ?m : h3d.Matrix ) {
		super(new ColorMatrixShader());
		if( m != null ) shader.matrix = m;
	}

	inline function get_matrix() return shader.matrix;
	inline function set_matrix(m) return shader.matrix = m;

	public function apply( src : h3d.mat.Texture, out : h3d.mat.Texture ) {
		var old = engine.setTarget(out);
		shader.texture = src;
		render();
		engine.setTarget(old);
	}

}