package h3d.shader.pbr;

class Brush extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;
		@const var normalize : Bool;

		@param var strength : Float;
		@param var weightTextures : Sampler2DArray;
		@param var weightCount : Int;
		@param var refIndex : Int;
		@param var targetIndex : Int;
		@param var size : Float;
		@param var pos : Vec3;

		function fragment() {
			if(normalize){
				var tileUV = pos.xy + calculatedUV * size ;
				var refValue = weightTextures.get(vec3(tileUV, refIndex)).r;
				var sum = 0.0;
				for(i in 0 ... weightCount)
					if(i != refIndex) sum += weightTextures.get(vec3(tileUV, i)).r;
				var targetSum = min(1 - refValue, sum);

				pixelColor = vec4(vec3((weightTextures.get(vec3(tileUV, targetIndex)).rgb / sum) * targetSum), 1.0);
			}
			else{
				pixelColor = vec4(textureColor * strength);
			}
		}
	}
}
