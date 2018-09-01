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

class CubeMinMaxShader extends ScreenShader {

	static var SRC = {

		@param var texA : SamplerCube;
		@param var texB : SamplerCube;
		@const var isMax : Bool;
		@param var mat : Mat3;

		function fragment() {
			var uv = calculatedUV * 2.0 - 1.0;
			var dir = vec3(uv , 1) * mat;
			var a = texA.get(dir);
			var b = texB.get(dir);
			pixelColor = isMax ? max(a,b) : min(a,b);
		}
	};
}
