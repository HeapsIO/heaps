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

	public function new( width : Int, height : Int, size : Int = 1 ) {
		super(new BorderShader());

		var bbuf = new hxd.FloatBuffer();
		inline function add(x, y) {
			bbuf.push((x / width) * 2 - 1);
			bbuf.push(1 - (y / height) * 2);
		}
		add(0, 0);
		add(width, 0);
		add(0, size);
		add(width, size);

		add(0, 0);
		add(size, 0);
		add(0, height);
		add(size, height);

		add(0, height-size);
		add(width, height-size);
		add(0, height);
		add(width, height);

		add(width-size, 0);
		add(width, 0);
		add(width-size, height);
		add(width, height);

		var plan = new h3d.prim.RawPrimitive(engine, bbuf, 2);
		plan.buffer.flags.unset(Triangles);
		plan.buffer.flags.set(Quads);
		this.plan.dispose();
		this.plan = plan;
		shader.color.set(1,1,1,1);
	}


}