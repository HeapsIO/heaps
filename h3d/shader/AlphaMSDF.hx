package h3d.shader;

class AlphaMSDF extends hxsl.Shader {
    static var SRC = {  
		
		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		@input var input : { uv : Vec2 };
		@const @param var useSourceUVs : Bool = true;		

		@param var texture : Sampler2D;
		@param var blur : Float = 1;
		@const var useColor : Bool = false;
		@param var color : Vec3;

		function median(r : Float, g : Float, b : Float) : Float {
		    return max(min(r, g), min(max(r, g), b));
		}

		function screenPxRange( uv : Vec2 ) : Float {
			var unitRange = vec2(blur)/vec2(texture.size());
			var screenTexSize = vec2(1.0)/fwidth(uv);
			return max(0.5*dot(unitRange, screenTexSize), 1.0);
		}

		function fragment() {
			var uv = useSourceUVs ? input.uv : calculatedUV;
			var sample = texture.get(uv);
			var sd = median(sample.r, sample.g, sample.b);
    		var screenPxDistance = screenPxRange(uv)*(sd - 0.5);
    		pixelColor.a = clamp(screenPxDistance + 0.5, 0.0, 1.0);
			if (useColor)
				pixelColor.rgb = color;
		}
    }
}