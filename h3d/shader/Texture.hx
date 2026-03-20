package h3d.shader;

class Texture extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var uv : Vec2;
		};
		
		#if anti_aliasing
		@global var global: { 
            var antiAliasing: Int; 
        };
		#end

		@const var additive : Bool;
		@const var killAlpha : Bool;
		@const var specularAlpha : Bool;
		@range(0,1) @param var killAlphaThreshold : Float;

		@param var texture : Sampler2D;
		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		var specColor : Vec3;

		function vertex() {
			calculatedUV = input.uv;
		}

		function fragment() {
			#if anti_aliasing
			var c = if (global.antiAliasing == 1) {
				var dx = dFdx(input.uv);
				var dy = dFdy(input.uv);
				var c0 = texture.get(input.uv + 0.25 * dx + 0.25 * dy);
				var c1 = texture.get(input.uv + 0.25 * dx - 0.25 * dy);
				var c2 = texture.get(input.uv - 0.25 * dx + 0.25 * dy);
				var c3 = texture.get(input.uv - 0.25 * dx - 0.25 * dy);
				(c0 + c1 + c2 + c3) * 0.25;
			} else {
				texture.get(calculatedUV);
			}
			#else
			var c = texture.get(calculatedUV);
			#end
			if( killAlpha && c.a - killAlphaThreshold < 0 ) discard;
			if( additive )
				pixelColor += c;
			else
				pixelColor *= c;
			if( specularAlpha )
				specColor *= c.aaa;
		}
	}


	public function new(?tex) {
		super();
		this.texture = tex;
		killAlphaThreshold = h3d.mat.Defaults.defaultKillAlphaThreshold;
	}

}