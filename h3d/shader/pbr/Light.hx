package h3d.shader.pbr;

class Light extends hxsl.Shader {

	static var SRC = {

		var pbrLightDirection : Vec3;
		var pbrLightColor : Vec3;
		var transformedPosition : Vec3;
		var occlusion : Float;

		@param var lightColor = vec3(0.5, 0.5, 0.5);

	};
}

class SpotLight extends Light {

	static var SRC = {

		@param var spotDir : Vec3;
		@param var lightPos : Vec3;
		@param var angle : Float;
		@param var fallOff : Float;
		@param var invLightRange4 : Float; // 1 / range^4
		@param var range : Float;
		@param var lightProj : Mat4;

		@const var useCookie : Bool;
		@param var cookieTex : Sampler2D;

		function fragment() {
			pbrLightDirection = normalize(lightPos - transformedPosition);

			var delta = lightPos - transformedPosition;
			/*
				UE4 [Karis12] "Real Shading in Unreal Engine 4"
				Modified with pointSize
			*/
			var dist = delta.dot(delta);
			var falloff = saturate(1 - dist*dist * invLightRange4);
			if( range > 0 ) {
				dist = (dist.sqrt() - range).max(0.);
				dist *= dist;
			}
			falloff *= falloff;
			falloff *= 1 / (dist + 1);

			pbrLightColor = lightColor * falloff;

			if(useCookie){
				var posLightSpace = vec4(transformedPosition, 1.0) * lightProj;
				var posUV = screenToUv(posLightSpace.xy/posLightSpace.w);
				if(posUV.x > 1 || posUV.x < 0 || posUV.y > 1 || posUV.y < 0)
					discard;
				var cookie = cookieTex.get(posUV).rgba;
				pbrLightColor *= cookie.rgb * cookie.a;
			}
			else{
				var theta = dot(pbrLightDirection, -spotDir);
				var epsilon = fallOff - angle;
				var intensity = clamp((theta - angle) / epsilon, 0.0, 1.0);
				pbrLightColor *= intensity;
			}
		}
	}
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
