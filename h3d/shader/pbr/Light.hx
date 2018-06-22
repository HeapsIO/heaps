package h3d.shader.pbr;

class Light extends hxsl.Shader {
	static var SRC = {
		var pbrLightDirection : Vec3;
		var pbrLightColor : Vec3;
		var transformedPosition : Vec3;
		var occlusion : Float;

		/**
			Tells that we need to keep occlusion / shadow map.
		**/
		@param var lightColor = vec3(0.5, 0.5, 0.5);

	};
}


class PointLight extends Light {

	static var SRC = {

		@param var lightPos : Vec3;
		@param var invLightRange4 : Float; // 1 / range^4
		@param var pointSize : Float;

		function fragment() {
			var delta = lightPos - transformedPosition;
			pbrLightDirection = delta.normalize();
			/*
				UE4 [Karis12] "Real Shading in Unreal Engine 4"
				Modified with pointSize
			*/
			var dist = delta.dot(delta);
			var falloff = saturate(1 - dist*dist * invLightRange4);
			if( pointSize > 0 ) {
				dist = (dist.sqrt() - pointSize).max(0.);
				dist *= dist;
			}
			falloff *= falloff;
			falloff *= 1 / (dist + 1);
			pbrLightColor = lightColor * falloff;
		}

	};

}


class DirLight extends Light {

	static var SRC = {

		@param var lightDir : Vec3;

		function fragment() {
			pbrLightDirection = lightDir;
			pbrLightColor = lightColor;
		}

	};

}
