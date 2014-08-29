package h3d.pass;

private class CopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;

		function fragment() {
			output.color = texture.get(input.uv);
		}
	}
}

class Copy extends ScreenFx<CopyShader> {

	public function new() {
		super(new CopyShader());
	}

	public function apply( from, to ) {
		engine.setTarget(to);
		shader.texture = from;
		render();
		shader.texture = null;
		engine.setTarget(null);
	}

	static var inst : Copy;
	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture ) {
		if( inst == null ) inst = new Copy();
		return inst.apply(from, to);
	}

}