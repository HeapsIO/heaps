class TestUniformBuffer extends hxsl.Shader {

	static var SRC = {

		@param var colorMatrix : Buffer<Vec4,4>;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor *= mat4(colorMatrix[0],colorMatrix[1],colorMatrix[2],colorMatrix[3]);
		}

	};

}

class TestTextureArray extends hxsl.Shader {

	static var SRC = {

		@const var COUNT : Int = 3;
		@param var time : Float;
		@param var textures : Sampler2DArray;
		var calculatedUV : Vec2;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor *= textures.get(vec3(calculatedUV, int((calculatedUV.x + calculatedUV.y) * COUNT + time) % COUNT));
		}

	};

}

class ShaderAdvanced extends hxd.App {

	var updates : Array<Float -> Void> = [];

	override function init() {
		engine.backgroundColor = 0xFF202020;

		// uniform buffer
		var bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000,128,128),s2d);
		var ubuffer = bmp.addShader(new TestUniformBuffer());
		ubuffer.colorMatrix = new h3d.Buffer(4,4,[UniformBuffer,Dynamic]);
		var hue : Float = 0.;
		updates.push(function(dt) {
			hue += dt * 0.1;
			var m = new h3d.Matrix();
			m.identity();
			m.colorHue(hue);

			var buf = new hxd.FloatBuffer();
			for( v in m.getFloats() )
				buf.push(v);
			ubuffer.colorMatrix.uploadVector(buf, 0, 4);
		});

		// texture array
		var bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF,128,128), s2d);
		var tarr = bmp.addShader(new TestTextureArray());
		bmp.x = 128;
		updates.push(function(dt) {
			tarr.time += dt / 60;
		});
		tarr.textures = new h3d.mat.TextureArray(1,1,3,[Target]);
		tarr.textures.clear(0xFF4040,1,0);
		tarr.textures.clear(0x40FF40,1,1);
		tarr.textures.clear(0x4040FF,1,2);

		// rgba 32F read/write
		var tex = new h3d.mat.Texture(1,1,[Target],RGBA32F);
		tex.clear(0x804020,1);
		var pixels : hxd.Pixels.PixelsFloat = tex.capturePixels();
		var color = pixels.getPixelF(0,0).toColor();
		if( color != 0xFF804020 ) throw StringTools.hex(color);
		pixels.setPixelF(0,0,new h3d.Vector(1,2,3,4));
		tex.uploadPixels(pixels);
		pixels = tex.capturePixels();
		var v = pixels.getPixelF(0,0);
		if( v.r != 1 || v.g != 2 || v.b != 3 || v.a != 4 ) throw v.toString();

	}

	override function update(dt:Float) {
		for( f in updates )
			f(dt);
	}

	static function main() {
		new ShaderAdvanced();
	}

}