package h3d.shader.pbr;

class LightEvaluation extends hxsl.Shader {

	static var SRC = {

		// Helpers
		function closestPointLineToPoint( l0 : Vec3, l1 : Vec3, p : Vec3) : Vec3 {
			var l01 = l1 - l0;
			var t = dot(p - l0, l01) / dot(l01, l01);
			return l0 + saturate(t) * l01;
		}

		function closestPointLineToRay( l0 : Vec3, l1 : Vec3, r : Vec3 ) : Vec3 {
			var l01 = l1 - l0;
			var a = dot(l01, l01);
			var b = dot(r, l01);
			var t = saturate(dot(l0, b * r - l01) / ( a - b*b) );

			return l0 + t * l01;
		}

		function tracePlane(rayOrigin : Vec3, rayDirection : Vec3, planeOrigin : Vec3, planeNormal : Vec3) : Vec3 {
			var distanceToPlane = dot(planeNormal, (planeOrigin - rayOrigin) / dot(planeNormal, rayDirection));
			return rayOrigin + rayDirection * distanceToPlane;
		}

		function closestPointOnRectangle( center : Vec3, normal : Vec3, right : Vec3, up : Vec3, halfSize : Vec2, rayOrigin : Vec3, rayDirection : Vec3 ) : Vec3 {
			var p = tracePlane(rayOrigin, rayDirection, center, normal) - center;
			return center + clamp(dot(p, right), -halfSize.x, halfSize.x) * right
			              + clamp(dot(p, up), -halfSize.y, halfSize.y) * up;
		}

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

		function rectangleLightIntensity( delta : Vec3, lightDir : Vec3, right : Vec3, up : Vec3, angles : Vec4 ) : Float {
			var epsilon = 0.00001;
			var invLightDir = -lightDir;

			var xyEpsilon = angles.y - angles.x + epsilon;
			var xyLightDir = invLightDir - dot(invLightDir, up) * up;
			var xyDelta = delta - dot(delta, up) * up;
			var xyTheta = dot(xyDelta.normalize(), xyLightDir.normalize());
			var horizontalFalloff = saturate((xyTheta - angles.x) / xyEpsilon);

			var xzEpsilon = angles.w - angles.z + epsilon;
			var xzLightDir = invLightDir - dot(invLightDir, right) * right;
			var xzDelta = delta - dot(delta, right) * right;
			var xzTheta = dot(xzDelta.normalize(), xzLightDir.normalize());
			var verticalFalloff = saturate((xzTheta - angles.z) / xzEpsilon);

			return verticalFalloff * horizontalFalloff;
		}

		function capsuleLightDiffuse( lightPos : Vec3, left : Vec3, halfLength : Float, radius : Float, invRange4 : Float, position : Vec3 ) : Vec4 {
			var spherePos = closestPointLineToPoint(lightPos - halfLength * left, lightPos + halfLength * left, position);
			var delta = spherePos - position;
			return vec4(delta.normalize(), pointLightIntensity(delta, radius, invRange4));
		}

		function capsuleLightSpecularDir( lightPos : Vec3, left : Vec3, halfLength : Float, radius : Float, position : Vec3, r : Vec3 ) : Vec3 {
			var l0 = lightPos - halfLength * left - position;
			var l1 = lightPos + halfLength * left - position;
			var closestPoint = closestPointLineToRay(l0, l1, r);
			var centerToRay = dot(closestPoint, r) * r - closestPoint;
			closestPoint = closestPoint + centerToRay * saturate(radius / length(centerToRay));
			return normalize(closestPoint);
		}

		function rectangleLightDiffuse( center : Vec3, lightDir : Vec3, right : Vec3, up : Vec3, halfSize : Vec2, angles : Vec4, range : Float, invRange4 : Float, position : Vec3, surfaceNormal : Vec3 ) : Vec4 {
			var delta = closestPointOnRectangle(center, lightDir, right, up, halfSize, position, surfaceNormal) - position;
			var intensity = rectangleLightIntensity(delta, lightDir, right, up, angles) * pointLightIntensity(delta, range, invRange4);
			return vec4(normalize(delta), intensity);
		}

		function rectangleLightSpecularDir( center : Vec3, lightDir : Vec3, right : Vec3, up : Vec3, halfSize : Vec2, position : Vec3, r : Vec3 ) : Vec3 {
			return normalize(closestPointOnRectangle(center, lightDir, right, up, halfSize, position, r) - position);
		}
	};
}

class Light extends LightEvaluation {

	static var SRC = {

		var pbrLightDirection : Vec3;
		var pbrSpecularLightDirection : Vec3;
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
			var fallOffInfo = spotLightIntensity(delta, spotDir, range, invLightRange4, fallOff, angle);
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

class Performance extends hxsl.Shader {
	static var SRC = {
		@param var maxLights : Int;
		var pixelColor : Vec4;
		var pbrLightColor : Vec3;
		var shadow : Float;
		function fragment() {
			var d = vec3(1.0 / maxLights);
			// prevent missing texture from generated shader.
			pixelColor.rgb = ((pixelColor.r) > 0.0 ? vec3(0.0) : vec3(0.0)) + ((pbrLightColor.r + pbrLightColor.g + pbrLightColor.b) > 0.0 ? d : vec3(0.0));
		}
	}
}

class CapsuleLight extends Light {

	static var SRC = {
		var normal : Vec3;

		@param var lightPos : Vec3;
		@param var radius : Float;
		@param var invRange4 : Float;
		@param var halfLength : Float;
		@param var left : Vec3;

		var view : Vec3;
		function fragment() {
			var light = capsuleLightDiffuse(lightPos, left, halfLength, radius, invRange4, transformedPosition);
			pbrLightDirection = light.xyz;
			pbrLightColor = light.w * lightColor;
			pbrSpecularLightDirection = capsuleLightSpecularDir(lightPos, left, halfLength, radius, transformedPosition, reflect(-view, normal));
			pbrOcclusionFactor = occlusionFactor;
		}
	};
}

class RectangleLight extends Light {
	static var SRC = {
		@param var lightDir : Vec3;
		@param var lightPos : Vec3;
		@param var right : Vec3;
		@param var up : Vec3;
		@param var halfSize : Vec2;
		@param var horizontalAngle : Float;
		@param var verticalAngle : Float;
		@param var verticalFallOff : Float;
		@param var horizontalFallOff : Float;
		@param var range : Float;
		@param var invLightRange4 : Float; // 1 / range^4

		var view : Vec3;
		var normal : Vec3;

		function fragment() {
			var angles = vec4(horizontalAngle, horizontalFallOff, verticalAngle, verticalFallOff);
			var light = rectangleLightDiffuse(lightPos, lightDir, right, up, halfSize, angles, range, invLightRange4, transformedPosition, normal);
			pbrLightDirection = light.xyz;
			pbrLightColor = light.w * lightColor;
			pbrSpecularLightDirection = rectangleLightSpecularDir(lightPos, lightDir, right, up, halfSize, transformedPosition, reflect(-view, normal));
			pbrOcclusionFactor = occlusionFactor;
		}
	}
}
