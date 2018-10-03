package h3d.shader.pbr;

class Brush extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;
		@const var normalize : Bool;
		@const var clamp : Bool;
		@const var generateIndex : Bool;

		@param var strength : Float;
		@param var weightTextures : Sampler2DArray;
		@param var weightCount : Int;
		@param var refIndex : Int;
		@param var targetIndex : Int;
		@param var size : Float;
		@param var pos : Vec3;
		@param var mask : Array<Vec4, 4>;

		function fragment() {
			if(clamp){
				var tileUV = pos.xy + calculatedUV * size;
				var count = 0;
				var smallestWeightIndex = -1;
				var smallestWeight = 1.0;
				for(i in 0 ... weightCount){
					var w = weightTextures.get(vec3(tileUV, i)).r;
					if(w > 0.0){
						count++;
						if(i != refIndex && smallestWeight > w){
							smallestWeight = w;
							smallestWeightIndex = i;
						}
					}
				}
				pixelColor = weightTextures.get(vec3(tileUV, targetIndex)).rgba;
				if(count > 3 && targetIndex == smallestWeightIndex)
					pixelColor = vec4(0);
			}
			else if(normalize){
				var tileUV = pos.xy + calculatedUV * size ;
				var refValue = weightTextures.get(vec3(tileUV, refIndex)).r;
				var sum = 0.0;
				for(i in 0 ... weightCount)
					if(i != refIndex) sum += weightTextures.get(vec3(tileUV, i)).r;
				var targetSum = 1 - refValue;
				pixelColor = vec4(vec3((weightTextures.get(vec3(tileUV, targetIndex)).rgb / sum) * targetSum), 1.0);

				if(targetIndex == refIndex){
					pixelColor = mix(vec4(1), vec4(refValue), ceil(min(1,sum)));
				}
			}
			else if(generateIndex){
				var tileUV = pos.xy + calculatedUV * size;
				var indexes = vec4(0);
				var curMask = 0;
				for(i in 0 ... weightCount){
					var w = weightTextures.get(vec3(tileUV, i)).r;
					if( w > 0 && curMask < 3){
						indexes += mask[curMask] * i / 255.0;
						curMask++;
					}
				}
				pixelColor = indexes;
			}
			else{
				pixelColor = vec4(textureColor * strength);
			}
		}
	}


}
