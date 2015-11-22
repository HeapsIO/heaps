package h3d.pass;

private class CopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;
		@param var uvDelta : Vec2;

		function fragment() {
			output.color = texture.get(input.uv + uvDelta);
		}
	}
}

class Copy extends ScreenFx<CopyShader> {

	public function new() {
		super(new CopyShader());
	}

	public function apply( from, to, ?blend : h3d.mat.BlendMode, ?uvDelta : h3d.Vector ) {
		pass.setBlendMode(blend == null ? None : blend);
		engine.pushTarget(to);
		shader.texture = from;
		if( uvDelta == null ) shader.uvDelta.set(0, 0) else shader.uvDelta.set(uvDelta.x, uvDelta.y);
		render();
		shader.texture = null;
		engine.popTarget();
	}

	static var inst : Copy;
	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend, ?uvDelta : h3d.Vector ) {
		if( inst == null ) inst = new Copy();
		return inst.apply(from, to, blend, uvDelta);
	}

}