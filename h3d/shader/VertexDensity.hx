package h3d.shader;

class VertexDensity extends hxsl.Shader {
	static var SRC = {
		@global var camera : {
			var position : Vec3;
			var view : Mat4;
		};

		@param var areaScale : Float = 300;
		var transformedPosition : Vec3;
		@flat var flatPos : Vec3;
		var pixelColor : Vec4;

		function __init__vertex() {
			flatPos =  transformedPosition;
		}


		function ramp0(ft: Float) : Vec3 {
			var t = clamp(ft, 0.0,1.0);
			t *= 4.;
			return clamp(vec3(
				min(t-1.5, 4.5-t),
				min(t-0.5, 3.5-t),
				min(t+0.5, 2.5-t)),
			0.0, 1.0);
		}

		function fragment() {
			var v0 = vertexAt(flatPos, 0);
			var v1 = vertexAt(flatPos, 1);
			var v2 = vertexAt(flatPos, 2);

			var viewPos = vec4(v0, 1) * camera.view;
			
			var area = cross(v1 - v0, v2 - v0).length() * 0.5;
			var density = viewPos.z / (sqrt(area) * areaScale);

			pixelColor.rgb = ramp0(saturate(density));

			var minBary = min(barycentrics.x, min(barycentrics.y, barycentrics.z));
			var wire = smoothstep(0.0, fwidth(minBary) * 1.0, minBary);
			pixelColor.rgb = mix(pixelColor.rgb, vec3(0), wire * 0.25);
		}
	}
}