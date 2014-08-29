package h3d.shader;

class Blur extends ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param @const var Quality : Int;
		@param @const var isDepth : Bool;
		@param var values : Array<Float,Quality>;
		@param var pixel : Vec2;

		function fragment() {
			if( isDepth ) {
				var val = 0.;
				for( i in -Quality+1...Quality )
					val += unpack(texture.get(input.uv + pixel * float(i))) * values[i < 0 ? -i : i];
				output.color = pack(val.min(0.9999999));
			} else {
				var color = vec4(0, 0, 0, 0);
				for( i in -Quality+1...Quality )
					color += texture.get(input.uv + pixel * float(i)) * values[i < 0 ? -i : i];
				output.color = color;
			}
		}
	}

}