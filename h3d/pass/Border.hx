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

	var width(default, null) : Int;
	var height(default, null) : Int;
	var size(default, null) : Int;

	public function new( width : Int, height : Int, size : Int = 1 ) {
		super(new BorderShader());
		this.width = width;
		this.height = height;
		this.size = size;
		shader.color.set(1,1,1,1);
	}

	function createPrimitive() {
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

		this.primitive = new h3d.prim.RawPrimitive({ vbuf : bbuf, format : hxd.BufferFormat.make([{ name : "position", type : DVec2 }]) }, true);
	}

	override function render() {
		if (primitive == null)
			createPrimitive();
		super.render();
	}

	override function dispose() {
		if (primitive != null)
			this.primitive.dispose();
		super.dispose();
	}

}