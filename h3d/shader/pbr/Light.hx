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

		function closestPointOnSegment( a : Vec3, b : Vec3, c : Vec3) : Vec3 {
			var ab = b - a;
			var t = dot(c - a, ab) / dot(ab, ab);
			return a + saturate(t) * ab;
		}

		var pixelColor : Vec4;
		var view : Vec3;
		function fragment() {
			var P0 = lightPos - halfLength * left;
			var P1 = lightPos + halfLength * left;

			// Diffuse: place a point light on the closest point on the sphere placed on the closest position on the segment.
			var spherePos = closestPointOnSegment(P0, P1, transformedPosition);
			var delta = spherePos - transformedPosition;
			pbrLightDirection = delta.normalize();
			var closestPointDiffuse = spherePos - pbrLightDirection * saturate((length(delta) - 1e-5) / radius) * radius;
			delta = closestPointDiffuse - transformedPosition;
			pbrLightDirection = normalize(delta);

			// Attenuation.
			var falloff = pointLightIntensity(delta, radius, invRange4);

			// Specular.
			var R = view - 2.0 * dot(view, normal) * normal;
			var posToLight = lightPos - transformedPosition;
			// Intersect a light plane with reflected ray and place a sphere on the closest point on segment.
			var onPlane = transformedPosition + R * dot(posToLight, R);
			var spherePosSpec = closestPointOnSegment(P0, P1, onPlane);
			pbrSpecularLightDirection = normalize(spherePosSpec - transformedPosition);
			// Get closest point on the sphere.
			var closestPointSpecular = spherePosSpec - pbrSpecularLightDirection * saturate(length(spherePosSpec - transformedPosition) - 1e-5 / radius) * radius;
			pbrSpecularLightDirection = normalize(closestPointSpecular - transformedPosition);

			pbrLightColor = falloff * lightColor;
			pbrOcclusionFactor = occlusionFactor;
		}
	};
}

class RectangleLight extends Light {
	static var SRC = {
		@param var lightDir : Vec3;
		@param var lightPos : Vec3;
		@param var p0 : Vec3;
		@param var p1 : Vec3;
		@param var p2 : Vec3;
		@param var p3 : Vec3;
		@param var width : Float;
		@param var height : Float;
		@param var horizontalAngle : Float;
		@param var verticalAngle : Float;
		@param var verticalFallOff : Float;
		@param var horizontalFallOff : Float;
		@param var range : Float;
		@param var invLightRange4 : Float; // 1 / range^4

		var view : Vec3;
		var normal : Vec3;

		function getIntersectionPoint(rayOrigin : Vec3, rayDirection : Vec3, p0 : Vec3, p1 : Vec3, p2 : Vec3) : Vec3 {
			var planeNormal = cross(p1 - p0, p2 - p1).normalize();
			return tracePlane(rayOrigin, rayDirection, p0, planeNormal);
		}

		function closestPointOnSegment( a : Vec3, b : Vec3, c : Vec3) : Vec3 {
			var ab = b - a;
			var t = dot(c - a, ab) / dot(ab, ab);
			return a + saturate(t) * ab;
		}

		function tracePlane(rayOrigin : Vec3, rayDirection : Vec3, planeOrigin : Vec3, planeNormal : Vec3) : Vec3 {
			var distanceToPlane = dot(planeNormal, (planeOrigin - rayOrigin) / dot(planeNormal, rayDirection));
			return rayOrigin + rayDirection * distanceToPlane;
		}

		function traceTriangle(rayOrigin : Vec3, rayDirection : Vec3, p0 : Vec3, p1 : Vec3, p2 : Vec3) : Bool {
			var p = getIntersectionPoint(rayOrigin, rayDirection, p0, p1, p2);
			var n1 = cross(p1 - p0, p - p1).normalize();
			var n2 = cross(p2 - p1, p - p2).normalize();
			var n3 = cross(p0 - p2, p - p0).normalize();
			var d0 = dot(n1, n2);
			var d1 = dot(n2, n3);
			return (d0 > 0.1) && (d1 > 0.1);
		}

		function getClosestPointOnRectangle(rayOrigin : Vec3, rayDirection : Vec3, p0 : Vec3, p1 : Vec3, p2 : Vec3, p3 : Vec3) : Vec3 {
			var int = getIntersectionPoint(rayOrigin, rayDirection, p0, p1, p3);
			var closestPoint = vec3(0, 0, 0);
			if (traceTriangle(rayOrigin, rayDirection, p0, p3, p2)) {
				closestPoint = getIntersectionPoint(rayOrigin, rayDirection, p0, p3, p2);
			}
			else if (traceTriangle(rayOrigin, rayDirection, p0, p1, p3)) {
				closestPoint = getIntersectionPoint(rayOrigin, rayDirection, p0, p1, p3);
			}
			else {
				var p = int - lightPos;
				var right = (p1 - p0).normalize();
				var up = (p2 - p0).normalize();
				var intRight = clamp(dot(p, right), -width * 0.5, width * 0.5) * right;
				var intUp = clamp(dot(p, up), -height * 0.5, height * 0.5) * up;
				closestPoint = lightPos + intRight + intUp;
			}

			return closestPoint;
		}

		function fragment() {
			pbrOcclusionFactor = occlusionFactor;

			var right = (p1 - p0).normalize();
			var up = (p2 - p0).normalize();
			var invLightDir = -lightDir;

			// Diffuse
			var closestPointDiffuse = getClosestPointOnRectangle(transformedPosition, normal, p0, p1, p2, p3);
			var delta = closestPointDiffuse - transformedPosition;
			pbrLightDirection = normalize(delta);

			var xyEpsilon = horizontalFallOff - horizontalAngle;
			var xyLightDir = invLightDir - dot(invLightDir, up) * up;
			var xyDelta = delta - dot(delta, up) * up;
			var xyTheta = dot(xyDelta.normalize(), xyLightDir.normalize());
			var horizontalFalloff = saturate((xyTheta - horizontalAngle) / xyEpsilon);

			var xzEpsilon = verticalFallOff - verticalAngle;
			var xzLightDir = invLightDir - dot(invLightDir, right) * right;
			var xzDelta = delta - dot(delta, right) * right;
			var xzTheta = dot(xzDelta.normalize(), xzLightDir.normalize());
			var verticalFalloff = saturate((xzTheta - verticalAngle) / xzEpsilon);

			var falloff = verticalFalloff * horizontalFalloff * pointLightIntensity(delta, range, invLightRange4);
			pbrLightColor = falloff * lightColor;

			// Specular
			var r = reflect(-view, normal);
			var closestPointSpec = getClosestPointOnRectangle(transformedPosition, r, p0, p1, p2, p3);
			var delta = normalize(closestPointSpec - transformedPosition);
			pbrSpecularLightDirection = delta;
		}
	}
}
