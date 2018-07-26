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

		// various formats read/write
		var d = engine.driver;
		var values : Map<hxd.PixelFormat,String> = [
			R8 => "ff",
			RG8 => "ff7f",
			RGB8 => "ff7f40",
			RGBA => "ff7f4020",
			R16F => "003c",
			RG16F => "003c0038",
			RGB16F => "003c00380034",
			RGBA16F => "003c003800340030",
			R32F => "0000803f",
			RG32F => "0000803f0000003f",
			RGB32F => "0000803f0000003f0000803e",
			RGBA32F => "0000803f0000003f0000803e0000003e",
			SRGB => #if hlsdl "ffba8800" #else "ffbc8900" #end,
			SRGB_ALPHA => #if hlsdl "ffba8820" #else "ffbc8920" #end,
			RGB10A2 => "ffff0710",
			RG11B10UF => "c0031c68",
		];
		for( fmt in hxd.PixelFormat.createAll() ) {
			if( !d.isSupportedFormat(fmt) ) {
				trace("Skipping "+fmt);
				continue;
			}
			try {
				var t = new h3d.mat.Texture(1,1,[Target],fmt);
				d.setRenderTarget(t);
				d.clear(new h3d.Vector(1,0.5,0.25,0.125));
				d.setRenderTarget(null);
				var pix = t.capturePixels();
				var hex = pix.bytes.toHex();

				if( values.get(fmt) != hex )
					throw hex+" should be "+values.get(fmt);

				d.setRenderTarget(t);
				d.clear(new h3d.Vector(0,0,0,0));
				d.setRenderTarget(null);

				t.uploadPixels(pix);
				var pix2 = t.capturePixels();
				var hex2 = pix2.bytes.toHex();
				if( hex != hex2 )
					throw hex+" has been uploaded but we get "+hex2;
			} catch( e : Dynamic ) {
 				trace(fmt,e);
			}
		}

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
	}

	override function update(dt:Float) {
		for( f in updates )
			f(dt);
	}

	static function main() {
		new ShaderAdvanced();
	}

}