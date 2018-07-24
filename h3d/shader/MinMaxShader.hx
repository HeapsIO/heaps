package h3d.shader;

class MinMaxShader extends ScreenShader {

	static var SRC = {

		@param var texA : Sampler2D;
		@param var texB : Sampler2D;
		@const var isMax : Bool;

		function fragment() {
			var a = texA.get(calculatedUV);
			var b = texB.get(calculatedUV);
			pixelColor = isMax ? max(a,b) : min(a,b);
		}

	};


}
