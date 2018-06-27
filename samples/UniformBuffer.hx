class TestShader extends hxsl.Shader {

	static var SRC = {

		@param var colorMatrix : Buffer<Vec4,4>;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor *= mat4(colorMatrix[0],colorMatrix[1],colorMatrix[2],colorMatrix[3]);
			pixelColor.r += 0.1;
			pixelColor.a = 1;
		}

	};

}

class UniformBuffer extends hxd.App {

	var hue : Float = 0.;
	var shader : TestShader;

	override function init() {
		var bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000,128,128),s2d);
		shader = bmp.addShader(new TestShader());
		shader.colorMatrix = new h3d.Buffer(4,4,[UniformBuffer,Dynamic]);
	}

	override function update(dt:Float) {
		hue += dt * 0.1;
		var m = new h3d.Matrix();
		m.identity();
		m.colorHue(hue);

		var buf = new hxd.FloatBuffer();
		for( v in m.getFloats() )
			buf.push(v);
		shader.colorMatrix.uploadVector(buf, 0, 4);
	}

	static function main() {
		new UniformBuffer();
	}

}