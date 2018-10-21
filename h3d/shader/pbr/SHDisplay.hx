package h3d.shader.pbr;

class SHDisplay extends hxsl.Shader {
	static var SRC = {

		function computeIrradiance(norm : Vec3) : Vec3 {
			// An Efficient Representation for Irradiance Environment Maps
			// Ravi Ramamoorthi Pat Hanrahan

			var c1 = 0.429043;
			var c2 = 0.511664;
			var c3 = 0.743125;
			var c4 = 0.886227;
			var c5 = 0.247708;

			var irradiance = vec3(0,0,0);

			if (order >= 1){
				var L00 = vec3(shCoefsRed[0], shCoefsGreen[0], shCoefsBlue[0]);
				irradiance += c4 * L00;
			}

			if (order >= 2){
				var L1n1 = vec3(shCoefsRed[1], shCoefsGreen[1], shCoefsBlue[1]);
				var L10 = vec3(shCoefsRed[2], shCoefsGreen[2], shCoefsBlue[2]);
				var L11 = vec3(shCoefsRed[3], shCoefsGreen[3], shCoefsBlue[3]);
				irradiance += 2 * c2 * (L11 * norm.x + L1n1 * norm.y + L10 * norm.z);
			}

			if(order >= 3){
				var L2n2 = vec3(shCoefsRed[4], shCoefsGreen[4], shCoefsBlue[4]);
				var L2n1 = vec3(shCoefsRed[5], shCoefsGreen[5], shCoefsBlue[5]);
				var L20 = vec3(shCoefsRed[6], shCoefsGreen[6], shCoefsBlue[6]);
				var L21 = vec3(shCoefsRed[7], shCoefsGreen[7], shCoefsBlue[7]);
				var L22 = vec3(shCoefsRed[8], shCoefsGreen[8], shCoefsBlue[8]);
				irradiance += c1 * L22 * (norm.x*norm.x - norm.y*norm.y) + c3 * L20  * (norm.z * norm.z) - c5 * L20 +
				2 * c1 * (L2n2 * (norm.x*norm.y) + L21 * (norm.x*norm.z) + L2n1 * (norm.y*norm.z));
			}

			return irradiance;
		}

		@const var order : Int;
		@const var SIZE : Int; // Equal to order*order

		@param var shCoefsRed : Array<Float,SIZE>;
		@param var shCoefsGreen : Array<Float,SIZE>;
		@param var shCoefsBlue : Array<Float,SIZE>;
		@param var strength : Float;

		var transformedNormal : Vec3;

		var output : {
			color : Vec4
		};

		function fragment() {
			var normal = vec4(transformedNormal.x, transformedNormal.y, transformedNormal.z, 1.0);
			output.color = vec4(computeIrradiance(normal.xyz) / 3.14 * strength, 1.0);
		}
	}

	public function new(){
		super();
		strength = 1.0;
	}

}
