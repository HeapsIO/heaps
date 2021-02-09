package h3d.shader.pbr;

class LightEvaluation extends hxsl.Shader {

	static var SRC = {

		/*
			UE4 [Karis12] "Real Shading in Unreal Engine 4"
			Modified with pointSize
		*/
		function pointLightIntensity( delta : Vec3, size : Float, invRange4 : Float ) : Float {
			var dist = delta.dot(delta);
			var falloff = saturate(1 - dist*dist * invRange4);
			if( size > 0 ) {
				dist = (dist.sqrt() - size).max(0.);
				dist *= dist;
			}
			falloff *= falloff;
			falloff *= 1 / (dist + 1);
			return falloff;
		}

		function spotLightIntensity( delta : Vec3, lightDir : Vec3, range : Float, invRange4 : Float, angleFallOff : Float, angle : Float ) : Vec2 {
			var dist = delta.dot(delta);
			var falloff = saturate(1 - dist*dist * invRange4);
			if( range > 0 ) {
				dist = (dist.sqrt() - range).max(0.);
				dist *= dist;
			}
			falloff *= falloff;
			falloff *= 1 / (dist + 1);

			var theta = dot(delta.normalize(), -lightDir);
			var epsilon = angleFallOff - angle;
			var angleFalloff = clamp((theta - angle) / epsilon, 0.0, 1.0);

			return vec2(falloff, angleFalloff);
		}


	};
}

class Light extends LightEvaluation {

	static var SRC = {

		var pbrLightDirection : Vec3;
		var pbrLightColor : Vec3;
		var pbrOcclusionFactor : Float;
		var transformedPosition : Vec3;
		var occlusion : Float;

		@param var lightColor = vec3(0.5, 0.5, 0.5);
		@param var occlusionFactor = 0.0;
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
			var delta = lightPos - transformedPosition;
			pbrLightDirection = delta.normalize();
			var fallOffInfo =  spotLightIntensity(delta, spotDir, range, invLightRange4, fallOff, angle);
			var fallOff = fallOffInfo.x;
			var fallOffInfoAngle = fallOffInfo.y;
			pbrLightColor = fallOff * lightColor;
			pbrOcclusionFactor = occlusionFactor;

			if( useCookie ) {
				var posLightSpace = vec4(transformedPosition, 1.0) * lightProj;
				var posUV = screenToUv(posLightSpace.xy/posLightSpace.w);
				if(posUV.x > 1 || posUV.x < 0 || posUV.y > 1 || posUV.y < 0)
					discard;
				var cookie = cookieTex.get(posUV).rgba;
				pbrLightColor *= cookie.rgb * cookie.a;
			}
			else
				pbrLightColor *= fallOffInfoAngle;
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
			pbrLightColor = pointLightIntensity(delta, pointSize, invLightRange4) * lightColor;
			pbrOcclusionFactor = occlusionFactor;
		}
	};
}

class DirLight extends Light {

	static var SRC = {

		@param var lightDir : Vec3;

		function fragment() {
			pbrLightDirection = lightDir;
			pbrLightColor = lightColor;
			pbrOcclusionFactor = occlusionFactor;
		}
	};
}
