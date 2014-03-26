package h3d.shader;

class BlurShader extends hxsl.Shader {

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
		@param @const var Quality : Int;
		@param @const var isDepth : Bool;
		@param var values : Array<Float,Quality>;
		@param var pixel : Vec2;
		
		function vertex() {
			output.position = vec4(input.position, 0, 1);
		}
		function fragment() {
			if( isDepth ) {
				var val = 0.;
				for( i in -Quality+1...Quality )
					val += unpack(texture.get(input.uv + pixel * i.toFloat())) * values[i < 0 ? -i : i];
				output.color = pack(val.min(0.9999999));
			} else {
				var color = vec4(0, 0, 0, 0);
				for( i in -Quality+1...Quality )
					color += texture.get(input.uv + pixel * i.toFloat()) * values[i < 0 ? -i : i];
				output.color = color;
			}
		}
	}
	
}