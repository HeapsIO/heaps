package h3d.pass;

private class CopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;

		var pixelColor : Vec4;

		function __init__fragment() {
			pixelColor = texture.get(input.uv);
		}

		function fragment() {
			output.color = pixelColor;
		}
	}
}

class Copy extends ScreenFx<CopyShader> {

	public function new() {
		super(new CopyShader());
	}

	public function apply( from, to, ?blend : h3d.mat.BlendMode, ?customPass : h3d.mat.Pass ) {
		engine.pushTarget(to);
		shader.texture = from;
		if( customPass != null ) {
			var old = pass;
			pass = customPass;
			pass.addShaderAt(shader, 0);
			if( blend != null ) pass.setBlendMode(blend);
			render();
			pass.removeShader(shader);
			pass = old;
		} else {
			pass.setBlendMode(blend == null ? None : blend);
			render();
		}
		shader.texture = null;
		engine.popTarget();
	}

	static var inst : Copy;
	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend, ?pass : h3d.mat.Pass ) {
		if( inst == null ) inst = new Copy();
		return inst.apply(from, to, blend, pass);
	}

}