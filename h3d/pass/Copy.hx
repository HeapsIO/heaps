package h3d.pass;

private class CopyShader extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			position : Vec2,
			uv : Vec2,
		};
		var output : {
			position : Vec4,
			color : Vec4,
		};

		@param var texture : Sampler2D;

		function vertex() {
			output.position = vec4(input.position, 0, 1);
		}
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