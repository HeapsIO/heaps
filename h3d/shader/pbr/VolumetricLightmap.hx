package  h3d.shader.pbr;

class VolumetricLightmap extends hxsl.Shader {

	static var SRC =
	{
		function getCoef(shCoords : Vec3, band : Int) : Vec3 {
			var u = (shCoords.x + band * lightmapSize.x ) * texelSize.x + texelSize.x / 2.0;
			var v = (shCoords.y + shCoords.z * lightmapSize.y)  * texelSize.y  + texelSize.y / 2.0;
			return lightProbeTexture.get(vec2(u, v)).rgb;
		}

		function getCoefFinal(band : Int) : Vec3 {
			var p00 = mix(getCoef(p000, band), getCoef(p100, band), dist.x);
			var p01 = mix(getCoef(p001, band), getCoef(p101, band), dist.x);
			var p10 = mix(getCoef(p010, band), getCoef(p110, band), dist.x);
			var p11 = mix(getCoef(p011, band), getCoef(p111, band), dist.x);
			var p0 = mix(p00, p10 , dist.y);
			var p1 = mix(p01, p11 , dist.y);
			var p = mix(p0, p1 , dist.z);
			return p;
		}

		function computeIrradiance(norm : Vec3) : Vec3 {
		// An Efficient Representation for Irradiance Environment Maps
		// Ravi Ramamoorthi Pat Hanrahan

			var c1 = 0.429043;
			var c2 = 0.511664;
			var c3 = 0.743125;
			var c4 = 0.886227;
			var c5 = 0.247708;

			var irradiance = vec3(0,0,0);

			if (ORDER >= 1){
				var L00 = getCoefFinal(0);
				irradiance += c4 * L00;
			}
			if (ORDER >= 2){
				var L1n1 = getCoefFinal(1);
				var L10 = getCoefFinal(2);
				var L11 = getCoefFinal(3);
				irradiance += 2 * c2 * (L11 * norm.x + L1n1 * norm.y + L10 * norm.z);
			}
			if(ORDER >= 3){
				var L2n2 = getCoefFinal(4);
				var L2n1 = getCoefFinal(5);
				var L20 = getCoefFinal(6);
				var L21 = getCoefFinal(7);
				var L22 = getCoefFinal(8);
				irradiance += c1 * L22 * (norm.x*norm.x - norm.y*norm.y) + c3 * L20  * (norm.z * norm.z) - c5 * L20 +
				2 * c1 * (L2n2 * (norm.x*norm.y) + L21 * (norm.x*norm.z) + L2n1 * (norm.y*norm.z));
			}
			return irradiance / 3.14;
		}

		function getLightProbeIndex( coords : Vec3 ) : Int {
			return int(floor(coords.x + lightmapSize.x * coords.y + lightmapSize.y * lightmapSize.x * coords.z));
		}

		function getVoxelCoords(pos : Vec3 ) : Vec3 {
			posLightmapSpace = (vec4(pos, 1) * lightmapInvPos).xyz;
			return floor(posLightmapSpace * (lightmapSize - vec3(1,1,1)));
		}

		function getLightProbePosition( coords : Vec3 ) : Vec3 {
			return coords * voxelSize;
		}

		function getPixelPosition() : Vec3 {
			var uv2 = (screenUV - 0.5) * vec2(2, -2);
			var temp = vec4(uv2, depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function getClampedCoords(coords : Vec3) : Vec3{
			return min(lightmapSize - vec3(1,1,1), max( vec3(0,0,0), coords));
		}

		@const var ORDER : Int;
		@const(327676) var SIZE : Int;

		@param var lightProbeBuffer : Buffer<Vec4,SIZE>;
		@param var lightProbeTexture : Sampler2D;
		@param var lightmapInvPos : Mat4;
		@param var lightmapSize : Vec3;
		@param var voxelSize : Vec3;
		@param var strength : Float;

		@param var cameraInverseViewProj : Mat4;
		@param var cameraPos : Vec3;

		var transformedPosition : Vec3;
		var screenUV : Vec2;

		var depth : Float;
		var normal : Vec3;
		var position : Vec3;
		var posLightmapSpace : Vec3;
		var voxelCoords : Vec3;
		var albedo : Vec3;
		var occlusion : Float;
		var roughness : Float;
		var metalness : Float;

		var probeCount : Float;
		var coefCount : Float;
		var texelSize : Vec2;
		var dist : Vec3;

		var p000 : Vec3;
		var p100 : Vec3;
		var p010 : Vec3;
		var p001 : Vec3;
		var p110 : Vec3;
		var p101 : Vec3;
		var p011 : Vec3;
		var p111 : Vec3;

		var output : {
			color : Vec4
		};


		function fragment(){

			position = getPixelPosition();
			voxelCoords = getVoxelCoords(position);
			probeCount = lightmapSize.x * lightmapSize.y * lightmapSize.z;
			coefCount = float(ORDER * ORDER);

			texelSize = vec2(1/(lightmapSize.x * coefCount), 1/(lightmapSize.y * lightmapSize.z));

			if(posLightmapSpace.x < 0 || posLightmapSpace.y < 0 || posLightmapSpace.z < 0 ||
			posLightmapSpace.x > 1 || posLightmapSpace.y > 1 || posLightmapSpace.z > 1)
				discard;

			p000 = getClampedCoords(voxelCoords + vec3(0,0,0));
			p100 = getClampedCoords(voxelCoords + vec3(1,0,0));
			p010 = getClampedCoords(voxelCoords + vec3(0,1,0));
			p001 = getClampedCoords(voxelCoords + vec3(0,0,1));
			p110 = getClampedCoords(voxelCoords + vec3(1,1,0));
			p101 = getClampedCoords(voxelCoords + vec3(1,0,1));
			p011 = getClampedCoords(voxelCoords + vec3(0,1,1));
			p111 = getClampedCoords(voxelCoords + vec3(1,1,1));

			var voxelPos = (voxelCoords) / (lightmapSize - vec3(1,1,1));
			dist = (posLightmapSpace - voxelPos) * (lightmapSize - vec3(1,1,1));

			var irradiance : Vec3 = computeIrradiance(normal) * min(vec3(1),albedo) * occlusion;

			var NdV = dot(normal, normalize(cameraPos - position));
			var F0 = mix(vec3(0.04), albedo, metalness);
			var F = F0 + (max(vec3(1 - roughness), F0) - F0) * exp2( ( -5.55473 * NdV - 6.98316) * NdV );
			var indirect = (irradiance * (1 - metalness) * (1 - F) ) * strength;

			output.color = vec4(indirect, 1.0);
		}
	}
}