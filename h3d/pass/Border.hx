package h3d.pass;

private class BorderShader extends h3d.shader.ScreenShader {
	static var SRC = {

		@param var color : Vec4;

		function fragment() {
			pixelColor = color;
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

		this.primitive = new h3d.prim.RawPrimitive({ vbuf : bbuf, stride : 2, quads : true }, true);
		shader.color.set(1,1,1,1);
	}

	override function dispose() {
		super.dispose();
		this.primitive.dispose();
	}

}