package h3d.shader.pbr;

/* Follows Skyth's implementation from Godot */

class SSRResolve extends h3d.shader.ScreenShader {
	static var SRC = {
		@param var ssrMipLevel : Sampler2D;
		@param var ssrColor : Sampler2D;

		function fragment() {
			var mipLevel = ssrMipLevel.getLod(calculatedUV, 0).x * 14.0;
			output.color = ssrColor.getLod(calculatedUV, mipLevel);
		}
	}
}

class SSRFilter extends h3d.shader.ScreenShader {
	static var SRC = {
		@param var ssrColor : Sampler2D;
		@param var mipLevel : Float;
		@param var invSize : Vec2;

		final weights : Array<Float, 7> = [
			0.07130343198685299,
			0.1315141208431224,
			0.18987923288883812,
			0.21460642856237303,
			0.18987923288883812,
			0.1315141208431224,
			0.07130343198685299
		];

		function getWeight( c : Vec4 ) : Float {
			return mix(saturate(mipLevel * 0.2), 1.0, c.a);
		}

		function fragment() {
			var sum = vec4(0.0);
			for ( i in 0...7 ) {
				for ( j in 0...7 ) {
					var tc = calculatedUV + invSize * vec2(i - 3, j - 3);
					var c = ssrColor.getLod(tc, 0.0);
					sum += weights[i] * weights[j] * c * getWeight(c);
				}
			}
			output.color = sum;
		}
	}
}

class SSR extends hxsl.Shader {
	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var invProj : Mat4;
			var zNear : Float;
			@const var reverseDepth : Bool;
		}

		@param var hdrMap : Sampler2D;
		@param var depthMap : Sampler2D;
		@param var normalMap : Sampler2D;
		@param var roughnessMap : Sampler2D;

		@param var outputMipLevel : RWTexture2D<Float>;
		@param var outputColor : RWTexture2D<Vec4>;

		@param var screenSize : Vec2;
		@param var mipMaps : Int;
		@param var stepCount : Int;
		@param var fadeInExponent : Float;
		@param var fadeOutExponent : Float;
		@param var depthTolerance : Float;
		@param var distanceBias : Float;
		@param var distancePowerBias : Float;
		@param var marginSize : Float;
		@const var ORTHOGONAL : Bool = false;

		@const var DEBUG : Bool = false;
		@param var debugSSR : RWTexture2D<Vec4>;
		@param var debugPixelX : Int;
		@param var debugPixelY : Int;
		@param var debugRoughnessFactor : Float;
		@param var debugIteration : Int;

		function linearizeDepth(depth : Float) : Float {
			var pos = vec4(0.0, 0.0, depth, 1.0);
			pos = pos * camera.invProj;
			return pos.z / pos.w;
		}

		function computeViewPos(screenPos : Vec3) : Vec3 {
			var pos = vec4(uvToScreen(screenPos.xy), screenPos.z, 1.0);
			pos = pos * camera.invProj;
			return pos.xyz / pos.w;
		}

		function computeScreenPos(pos : Vec3) : Vec3 {
			var screenPos = vec4(pos, 1.0) * camera.proj;
			screenPos.xyz /= screenPos.w;
			screenPos.xy = screenToUv(screenPos.xy);
			return screenPos.xyz;
		}

		function computeGeometricNormal( pixelPos : IVec2, depthC : Float, viewC : Vec3, pixelOffset : Float ) : Vec3 {
			var h = vec4(
				depthMap.fetch(pixelPos + ivec2(-1, 0)).x,
				depthMap.fetch(pixelPos + ivec2(-2, 0)).x,
				depthMap.fetch(pixelPos + ivec2(1, 0)).x,
				depthMap.fetch(pixelPos + ivec2(2, 0)).x
			);

			var v = vec4(
				depthMap.fetch(pixelPos + ivec2(0, -1)).x,
				depthMap.fetch(pixelPos + ivec2(0, -2)).x,
				depthMap.fetch(pixelPos + ivec2(0, 1)).x,
				depthMap.fetch(pixelPos + ivec2(0, 2)).x
			);

			var he = abs((2.0 * h.xz - h.yw) - depthC);
			var ve = abs((2.0 * v.xz - v.yw) - depthC);

			var hSign = he.x < he.y ? -1.0 : 1.0;
			var vSign = ve.x < ve.y ? -1.0 : 1.0;

			var viewH = computeViewPos(vec3((vec2(pixelPos) + vec2(hSign, 0) + pixelOffset) / screenSize, h[1+int(hSign)]));
			var viewV = computeViewPos(vec3((vec2(pixelPos) + vec2(0, vSign) + pixelOffset) / screenSize, v[1+int(vSign)]));

			var hDer = hSign * (viewH - viewC);
			var vDer = vSign * (viewV - viewC);

			return cross(hDer, vDer);
		}

		function computeCellCount(level : Int) : Vec2 {
			var cellCountX = max(1, int(screenSize.x) >> level);
			var cellCountY = max(1, int(screenSize.y) >> level);
			return vec2(cellCountX, cellCountY);
		}

		function computeCellIndex(screenPos : Vec2, cellCount : Vec2) : Vec2 {
			return floor(screenPos * cellCount);
		}

		function drawPixel( pixelPos : IVec2, radius : Int, color : Vec4 ) {
			for ( xOffset in -radius+1...radius ) {
				for ( yOffset in -radius+1...radius ) {
					var pos = min(max(pixelPos + ivec2(xOffset,yOffset), ivec2(0.0)), ivec2(screenSize));
					debugSSR.store(pos, color);
				}
			}
		}

		function drawCell(cellPos : IVec2, level : Int, color : Vec4) {
			var pixelSize = 1 << level;
			var xStart = cellPos.x - (cellPos.x % pixelSize);
			var yStart = cellPos.y - (cellPos.y % pixelSize);
			var cellStart = ivec2(xStart, yStart);
			for ( xOffset in 0...pixelSize ) {
				for ( yOffset in 0...pixelSize ) {
					var pos = min(max(cellStart + ivec2(xOffset,yOffset), ivec2(0.0)), ivec2(screenSize));
					debugSSR.store(pos, color);
				}
			}
		}

		var isDebugPixel = false;
		function drawDebug(iteration : Int, screenPos : Vec3, screenRayDir : Vec3, curScreenPos : Vec3, nextT : Float, rejectedT : Float, curLevel : Int, hit : Bool) {
			var curDebugIter = stepCount - iteration;
			var shouldDebug = isDebugPixel && curDebugIter <= debugIteration;
			if ( shouldDebug ) {
				var isLastDebugIteration = curDebugIter == debugIteration;

				var curCellPos = ivec2(computeCellIndex(curScreenPos.xy, screenSize));
				var nextScreenPos = screenPos + screenRayDir * nextT;
				var nextCellPos = ivec2(computeCellIndex(nextScreenPos.xy, screenSize));

				var rejectedNextScreenPos = screenPos + screenRayDir * rejectedT;
				var rejectedNextCellPos = ivec2(computeCellIndex(rejectedNextScreenPos.xy, screenSize));

				var alpha = (1.0 - curLevel / 16.0) * (isLastDebugIteration ? 0.5 : 0.2);
				if ( isLastDebugIteration && !hit )
					drawCell(nextCellPos.xy, curLevel, vec4(0.0, 1.0, 1.0, alpha));
				drawCell(curCellPos.xy, curLevel, hit ? vec4(0.0, 1.0, 0.0, alpha) : vec4(1.0, 0.0, 0.0, alpha));

				if ( isLastDebugIteration ) {
					drawPixel(curCellPos, 3, vec4(1.0, 0.0, 1.0, 1.0));
					if ( !hit ) {
						drawPixel(nextCellPos, 3, vec4(0.0, 1.0, 0.0, 1.0));
						drawPixel(rejectedNextCellPos, 3, vec4(1.0, 1.0, 0.0, 1.0));
					}
				}
			}
		}

		function main() {
			setLayout(8, 8, 1);

			var pixelPos = ivec2(computeVar.globalInvocation.xy);
			isDebugPixel = pixelPos.x == debugPixelX && pixelPos.y == debugPixelY;
			var width = int(screenSize.x);
			var height = int(screenSize.y);
			if ( pixelPos.x >= width || pixelPos.y >= height )
				return;

			var color = vec4(0.0);
			var mipLevel = 0.0;
			var farPlane = camera.reverseDepth ? 0.0 : 1.0;

			var screenPos = vec3(((vec2(pixelPos) + 0.5)/screenSize), depthMap.fetch(pixelPos).x);

			var shouldTrace = screenPos.z != farPlane;
			if ( shouldTrace ) {
				var viewPos = computeViewPos(screenPos);

				var viewNormal = normalMap.fetch(pixelPos).xyz * camera.view.mat3();
				var roughness = roughnessMap.fetch(pixelPos).y;
				if ( DEBUG )
					roughness *= debugRoughnessFactor;

				if ( roughness >= 0.7 ) {
					outputColor.store(pixelPos, vec4(0.0));
					outputMipLevel.store(pixelPos, 0.0);
					return;
				}

				var geomViewNormal = normalize(computeGeometricNormal(pixelPos, screenPos.z, viewPos, 0.5));
				viewPos += viewNormal * 1.0 * (1.0 - pow(saturate(dot(viewNormal, geomViewNormal)), 8.0));
				screenPos = computeScreenPos(viewPos);

				var viewDir = ORTHOGONAL ? vec3(0.0, 0.0, 1.0) : normalize(viewPos);
				var viewRayDir = normalize(reflect(viewDir, viewNormal));

				if ( dot(viewRayDir, geomViewNormal) < 0.0 )
					viewRayDir = normalize(reflect(viewRayDir, geomViewNormal));

				var secondViewPos = viewPos + viewRayDir;
				var secondScreenPos = computeScreenPos(secondViewPos);

				var screenRayDir = secondScreenPos - screenPos;
				screenRayDir /= abs(screenRayDir.z);

				var facingCamera = camera.reverseDepth ? screenRayDir.z >= 0.0 : screenRayDir.z <= 0.0;

				var t0 = (vec2(0.0) - screenPos.xy) / screenRayDir.xy;
				var t1 = (vec2(1.0) - screenPos.xy) / screenRayDir.xy;
				var t2 = max(t0, t1);
				var tMax = min(t2.x, t2.y);

				var crossStep = vec2(screenRayDir.x < 0.0 ? -1.0 : 1.0, screenRayDir.y < 0.0 ? -1.0 : 1.0);
				var crossOffset = crossStep * 0.000001;
				crossStep = saturate(crossStep);

				var curLevel = 0;
				var curIteration = stepCount;

				var t : Float;
				{
					var cellCount = computeCellCount(curLevel);
					var cellIndex = computeCellIndex(screenPos.xy, cellCount);
					var newCellIndex = cellIndex + crossStep;
					var newCellPos = (newCellIndex / cellCount) + crossOffset;
					var posT = (newCellPos - screenPos.xy) / screenRayDir.xy;
					var edgeT = min(posT.x, posT.y);

					t = edgeT;
				}

				while (curLevel >= 0 && curIteration > 0 && t < tMax) {
					var curScreenPos = screenPos + screenRayDir * t;

					var cellCount = computeCellCount(curLevel);
					var cellIndex = computeCellIndex(curScreenPos.xy, cellCount);
					var cellDepth = depthMap.fetchLod(ivec2(cellIndex), curLevel).x;
					var tDepth = (cellDepth - screenPos.z) * screenRayDir.z;

					var newCellIndex = cellIndex + crossStep;
					var newCellPos = (newCellIndex / cellCount) + crossOffset;
					var tNewCell = (newCellPos - screenPos.xy) / screenRayDir.xy;
					var tNextBounds = min(tNewCell.x , tNewCell.y);

					var hit = facingCamera ? (t <= tDepth) : (tDepth <= tNextBounds);
					var mipOffset = hit ? -1 : 1;

					if ( curLevel == 0 && hit ) {
						var z0 = linearizeDepth(cellDepth);
						var z1 = linearizeDepth(curScreenPos.z);

						if ( z1 - z0 > depthTolerance ) {
							hit = false;
							mipOffset = 0;
						}
					}

					if ( !hit )
						t = tNextBounds;

					if ( DEBUG )
						drawDebug(curIteration, screenPos, screenRayDir, curScreenPos, t, max(tNewCell.x, tNewCell.y), curLevel, hit);

					curLevel = min(curLevel + mipOffset, mipMaps - 1);
					--curIteration;
				}

				var curScreenPos = screenPos + screenRayDir * t;

				var validity = 1.0;

				var curPixelPos = ivec2(curScreenPos.xy * screenSize);
				var hitDepth = depthMap.fetch(curPixelPos).x;
				if ( t >= tMax || hitDepth == farPlane )
					validity = 0.0;

				var hitNormal = normalMap.fetch(curPixelPos).xyz * camera.view.mat3();
				if ( dot(viewRayDir, hitNormal) >= 0.0 )
					validity = 0.0;

				var curViewPos = computeViewPos(curScreenPos);
				var hitViewPos = computeViewPos(vec3(curScreenPos.xy, hitDepth));

				var distance = length(curViewPos - hitViewPos);
				var tolerance = depthTolerance + distanceBias * pow(curViewPos.z, distancePowerBias);
				var confidence = 1.0 - step(tolerance, distance);
				validity *= saturate(confidence * confidence);

				var marginBlend = 1.0;
				var margin = vec2((screenSize.x + screenSize.y) * marginSize);
				{
					var curPixelPos = vec2(curPixelPos);
					var marginGrad = mix(screenSize - curPixelPos, curPixelPos, vec2(curPixelPos.x < screenSize.x * 0.5 ? 1.0 : 0.0, curPixelPos.y < screenSize.y * 0.5 ? 1.0 : 0.0));
					marginBlend = smoothstep(0.0, margin.x * margin.y, marginGrad.x * marginGrad.y);
				}

				var rayLength = length(screenRayDir.xy * t);

				var fadeIn = fadeInExponent == 0.0 ? 1.0 : pow(saturate(rayLength), fadeInExponent);
				var fadeOut = fadeOutExponent == 0.0 ? 1.0 : pow(saturate(1.0 - rayLength), fadeOutExponent);
				var fade = fadeIn * fadeOut;

				if ( fade > 0.999)
					fade = 1.0;
				validity *= marginBlend * fade;

				if ( validity > 0.0 )
					color = vec4(hdrMap.getLod(curScreenPos.xy, 0).xyz, 1.0) * validity;

				if ( roughness > 0.001 ) {
					var coneAngle = min(roughness, 0.999) * PI * 0.5;
					var coneLen = rayLength;
					var opLen = 2.0 * tan(coneAngle) * coneLen;
					var blurRadius : Float;
					{
						var a = opLen;
						var h = coneLen;
						var a2 = a * a;
						var fh2 = 4.0 * h * h;
						blurRadius = (a * (sqrt(a2 + fh2) - a)) / (4.0 * h);
					}

					mipLevel = clamp(log2(blurRadius * max(screenSize.x, screenSize.y) / 16.0), 0.0, float(mipMaps - 1));
				}
				mipLevel *= pow(clamp(1.25 - rayLength, 0.0, 1.0), 0.2);
			}

			outputColor.store(pixelPos, color);
			outputMipLevel.store(pixelPos, mipLevel / 14.0);
		}
	}
}