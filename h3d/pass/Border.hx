package h3d.pass;

private class BorderShader extends hxsl.Shader {
	static var SRC = {

		@param var color : Vec4;

		@input var input : {
			var position : Vec2;
		};

		var output : {
			var position : Vec4;
			var color : Vec4;
		};

		function vertex() {
			output.position = vec4(input.position, 0, 1);
		}

		function fragment() {
			output.color = color;
		}

	}
}

class Border extends ScreenFx<BorderShader> {

	public function new( size : Int ) {
		super(new BorderShader());

		var bbuf = new hxd.FloatBuffer();
		inline function add(x, y) {
			bbuf.push((x / size) * 2 - 1);
			bbuf.push(1 - (y / size) * 2);
		}
		add(0, 0);
		add(size, 0);
		add(0, 1);
		add(size, 1);

		add(0, 0);
		add(1, 0);
		add(0, size);
		add(1, size);

		add(0, size-1);
		add(size, size-1);
		add(0, size);
		add(size, size);

		add(size-1, 0);
		add(size, 0);
		add(size-1, size);
		add(size, size);

		var plan = new h3d.prim.RawPrimitive(engine, bbuf, 2);
		plan.buffer.flags.unset(Triangles);
		plan.buffer.flags.set(Quads);
		this.plan = plan;
		shader.color.set(1,1,1,1);
	}


}