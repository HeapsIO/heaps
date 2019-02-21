package h3d.shader.pbr;

class ComputeSH extends h3d.shader.ScreenShader {
	static var SRC = {

		@param var environment : SamplerCube;
		@param var width : Int;
		@param var cubeDir : Array<Mat3, 6>;
		@const var ORDER : Int;

		@param var PI = 3.1416;

		var shCoefL00 : Float;
		var shCoefL1n1: Float;
		var shCoefL10 : Float;
		var shCoefL11 : Float;
		var shCoefL2n2 : Float;
		var shCoefL2n1 : Float;
		var shCoefL20 : Float;
		var shCoefL21 : Float;
		var shCoefL22 : Float;

		var coefL00Final : Vec3;
		var coefL1n1Final: Vec3;
		var coefL10Final : Vec3;
		var coefL11Final : Vec3;
		var coefL2n2Final : Vec3;
		var coefL2n1Final : Vec3;
		var coefL20Final : Vec3;
		var coefL21Final : Vec3;
		var coefL22Final : Vec3;

		function vertex(){
			var position = vec3(input.position.x, input.position.y * flipY, 0);
			output.position = vec4(position, 1.0);
		}

		function evalSH(dir:Vec3) {

			if (ORDER >= 1){
				shCoefL00 = evalCoefL00(dir);
			}
			if (ORDER >= 2){
				shCoefL1n1 = evalCoefL1n1(dir);
				shCoefL10 = evalCoefL10(dir);
				shCoefL11 = evalCoefL11(dir);
			}
			if (ORDER >= 3){
				shCoefL2n2 = evalCoefL2n2(dir);
				shCoefL2n1 = evalCoefL2n1(dir);
				shCoefL20 = evalCoefL20(dir);
				shCoefL21 = evalCoefL21(dir);
				shCoefL22 = evalCoefL22(dir);
			}
		}

		function getDir(u: Float, v:Float, face:Int) : Vec3 {
			var dir = vec3(u, v, 1) * cubeDir[face];
			dir.normalize();
			return dir;
		}

		function evalCoefL00(dir: Vec3) : Float { return 0.282095; }
		function evalCoefL1n1(dir: Vec3) : Float { return -0.488603 * dir.y; }
		function evalCoefL10(dir: Vec3) : Float { return 0.488603 * dir.z; }
		function evalCoefL11(dir: Vec3) : Float { return -0.488603 * dir.x; }
		function evalCoefL2n2(dir: Vec3) : Float { return 1.092548 * dir.y * dir.x; }
		function evalCoefL2n1(dir: Vec3) : Float { return -1.092548 * dir.y * dir.z; }
		function evalCoefL20(dir: Vec3) : Float { return 0.315392 * (-dir.x * dir.x - dir.y * dir.y + 2.0 * dir.z * dir.z); }
		function evalCoefL21(dir: Vec3) : Float { return -1.092548 * dir.x * dir.z; }
		function evalCoefL22(dir: Vec3) : Float { return 0.546274 * (dir.x * dir.x - dir.y * dir.y); }

		var out : {
			position : Vec4,
			coefL00 : Vec3,
			coefL1n1: Vec3,
			coefL10 : Vec3,
			coefL11 : Vec3,
			coefL2n2 : Vec3,
			coefL2n1 : Vec3,
			coefL20 : Vec3,
			coefL21 : Vec3,
			coefL22 : Vec3,
		};

		function fragment() {

			if (ORDER >= 1){
				coefL00Final = vec3(0);
			}
			if (ORDER >= 2){
				coefL1n1Final = vec3(0);
				coefL10Final = vec3(0);
				coefL11Final = vec3(0);
			}
			if (ORDER >= 3){
				coefL2n2Final = vec3(0);
				coefL2n1Final = vec3(0);
				coefL20Final = vec3(0);
				coefL21Final = vec3(0);
				coefL22Final = vec3(0);
			}

			var weightSum = 0.0;
			var fWidth : Float = width;
			var invWidth : Float = 1.0 / fWidth;

			for(f in 0...6) {
				for (u in 0...width) {
					var fU : Float = (u / fWidth - 0.5) * 2.0;// Texture coordinate U in range [-1 to 1]
					fU *= fU;
					var uCoord = 2.0 * u * invWidth + invWidth;
					for (v in 0...width) {
						var fV : Float = (v / fWidth - 0.5) * 2.0;// Texture coordinate V in range [-1 to 1]
						fV *= fV;
						var vCoord = 2.0 * v * invWidth + invWidth;

						var dir = getDir(uCoord, vCoord, f);// Get direction from center of cube texture to current texel

						var diffSolid = 4.0 / ((1.0 + fU + fV) * sqrt(1.0 + fU + fV));	// Scale factor depending on distance from center of the face
						weightSum += diffSolid;

						var flippedDir = vec3(dir.x, dir.y, -dir.z);
						var color : Vec3 = environment.get(-flippedDir).rgb;// Get color from texture

						evalSH(dir);// Calculate coefficients of spherical harmonics for current direction

						if (ORDER >= 1){
							coefL00Final += shCoefL00 * color * diffSolid;
						}
						if (ORDER >= 2){
							coefL1n1Final += shCoefL1n1 * color * diffSolid;
							coefL10Final += shCoefL10 * color * diffSolid;
							coefL11Final += shCoefL11 * color * diffSolid;
						}
						if (ORDER >= 3){
							coefL2n2Final += shCoefL2n2 * color * diffSolid;
							coefL2n1Final += shCoefL2n1 * color * diffSolid;
							coefL20Final += shCoefL20 * color * diffSolid;
							coefL21Final += shCoefL21 * color * diffSolid;
							coefL22Final += shCoefL22 * color * diffSolid;
						}
					}
				}
			}

			// Final scale for coefficients
			var normProj = (4.0 * PI) / weightSum;

			if (ORDER >= 1){
				out.coefL00 = coefL00Final * normProj;
			}

			if (ORDER >= 2){
				out.coefL1n1 = coefL1n1Final * normProj;
				out.coefL10 = coefL10Final * normProj;
				out.coefL11 = coefL11Final * normProj;
			}
			else{ out.coefL1n1 = vec3(0); out.coefL10 = vec3(0); out.coefL11 = vec3(0); }

			if (ORDER >= 3){
				out.coefL2n2 = coefL2n2Final * normProj;
				out.coefL2n1 = coefL2n1Final * normProj;
				out.coefL20 = coefL20Final * normProj;
				out.coefL21 = coefL21Final * normProj;
				out.coefL22 = coefL22Final * normProj;
			}
			else{ out.coefL2n2 = vec3(0); out.coefL2n1 = vec3(0); out.coefL20 = vec3(0); out.coefL21 = vec3(0); out.coefL22 = vec3(0); }
		}
	}

}
