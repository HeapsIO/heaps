package h3d.shader.pbr;

class ClusterCull extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var invProj : Mat4;
		}

		@param var lightInfos : Buffer<Vec4, 4096>;
		@param var clusterData : RWBuffer<Int>;

		// Keep in sync with h3d.shader.pbr.DefaultForward.
		final POINT_LIGHT_STRIDE   : Int = 2;
		final SPOT_LIGHT_STRIDE    : Int = 3;
		final CAPSULE_LIGHT_STRIDE : Int = 3;
		final RECT_LIGHT_STRIDE    : Int = 6;

		final CLUSTER_X : Int = 16;
		final CLUSTER_Y : Int = 9;
		final CLUSTER_Z : Int = 24;
		final CLUSTER_STRIDE : Int = 128;

		@param var pointLightOffset : Int;
		@param var pointStart : Int;
		@param var pointEnd : Int;
		@param var spotLightOffset : Int;
		@param var spotStart : Int;
		@param var spotEnd : Int;
		@param var capsuleLightOffset : Int;
		@param var capsuleStart : Int;
		@param var capsuleEnd : Int;
		@param var rectLightOffset : Int;
		@param var rectStart : Int;
		@param var rectEnd : Int;

		@param var clusterNear : Float;
		@param var clusterFarOverNear : Float;
		@param var clusterLastSliceFar : Float;

		var aabbMin : Vec3;
		var aabbMax : Vec3;
		var count : Int;
		var typeCount : Int;
		var base : Int;

		function unproject( ndc : Vec2, z : Float ) : Vec3 {
			var p = vec4(ndc, z, 1.0) * camera.invProj;
			return p.xyz / p.w;
		}

		function rayAtDepth( ndc : Vec2, z : Float ) : Vec3 {
			var a = unproject(ndc, 0.0);
			var b = unproject(ndc, 0.5);
			return mix(a, b, (z - a.z) / (b.z - a.z));
		}

		function addCorner( ndc : Vec2, z0 : Float, z1 : Float ) {
			var p0 = rayAtDepth(ndc, z0);
			var p1 = rayAtDepth(ndc, z1);
			aabbMin = min(aabbMin, min(p0, p1));
			aabbMax = max(aabbMax, max(p0, p1));
		}

		function sphereTest( center : Vec3, radius : Float ) : Bool {
			var d = max(aabbMin - center, vec3(0.0)) + max(center - aabbMax, vec3(0.0));
			return dot(d, d) <= radius * radius;
		}

		function toView( p : Vec3 ) : Vec3 {
			return (vec4(p, 1.0) * camera.view).xyz;
		}

		function dirToView( d : Vec3 ) : Vec3 {
			return (vec4(d, 0.0) * camera.view).xyz;
		}

		function rangeFromInv4( invRange4 : Float ) : Float {
			return pow(invRange4, -0.25) * 1.001;
		}

		function pushLight( index : Int ) {
			if( count < CLUSTER_STRIDE - 1 ) {
				clusterData[base + 1 + count] = index;
				count += 1;
				typeCount += 1;
			}
		}

		function main() {
			setLayout(64, 1, 1);
			var id = computeVar.globalInvocation.x;
			if( id >= CLUSTER_X * CLUSTER_Y * CLUSTER_Z )
				return;

			var tx = id % CLUSTER_X;
			var ty = (id / CLUSTER_X) % CLUSTER_Y;
			var tz = id / (CLUSTER_X * CLUSTER_Y);
			base = id * CLUSTER_STRIDE;

			var ndcMin = vec2(float(tx) / float(CLUSTER_X), float(ty) / float(CLUSTER_Y)) * 2.0 - 1.0;
			var ndcMax = vec2(float(tx + 1) / float(CLUSTER_X), float(ty + 1) / float(CLUSTER_Y)) * 2.0 - 1.0;

			var z0 = tz == 0 ? 0.0 : clusterNear * pow(clusterFarOverNear, float(tz) / float(CLUSTER_Z));
			var z1 = tz == CLUSTER_Z - 1 ? clusterLastSliceFar : clusterNear * pow(clusterFarOverNear, float(tz + 1) / float(CLUSTER_Z));

			aabbMin = vec3(1e30);
			aabbMax = vec3(-1e30);
			addCorner(ndcMin, z0, z1);
			addCorner(vec2(ndcMax.x, ndcMin.y), z0, z1);
			addCorner(vec2(ndcMin.x, ndcMax.y), z0, z1);
			addCorner(ndcMax, z0, z1);
			var pad = (aabbMax - aabbMin) * 0.001;
			aabbMin -= pad;
			aabbMax += pad;

			count = 0;
			var counts = 0;

			typeCount = 0;
			for( l in pointStart...pointEnd ) {
				var i = pointLightOffset + l * POINT_LIGHT_STRIDE;
				if( sphereTest(toView(lightInfos[i+1].xyz), rangeFromInv4(lightInfos[i+1].a)) )
					pushLight(l);
			}
			counts = typeCount;

			typeCount = 0;
			for( l in spotStart...spotEnd ) {
				var i = spotLightOffset + l * SPOT_LIGHT_STRIDE;
				var pos = toView(lightInfos[i+1].xyz);
				var range = lightInfos[i+2].a * 1.001;
				if( sphereTest(pos, range) ) {
					var dir = dirToView(lightInfos[i+2].xyz);
					var cosAngle = lightInfos[i].b;
					var sinAngle = sqrt(max(1.0 - cosAngle * cosAngle, 0.0));
					var center = (aabbMin + aabbMax) * 0.5;
					var radius = length(aabbMax - center);
					var v = center - pos;
					var vLen2 = dot(v, v);
					var v1 = dot(v, dir);
					var distClosest = cosAngle * sqrt(max(vLen2 - v1 * v1, 0.0)) - v1 * sinAngle;
					if( !(distClosest > radius || v1 < -radius) )
						pushLight(l);
				}
			}
			counts |= typeCount << 8;

			typeCount = 0;
			for( l in capsuleStart...capsuleEnd ) {
				var i = capsuleLightOffset + l * CAPSULE_LIGHT_STRIDE;
				var halfLength = lightInfos[i].a;
				if( sphereTest(toView(lightInfos[i+1].xyz), rangeFromInv4(lightInfos[i+1].a) + halfLength) )
					pushLight(l);
			}
			counts |= typeCount << 16;

			typeCount = 0;
			for( l in rectStart...rectEnd ) {
				var i = rectLightOffset + l * RECT_LIGHT_STRIDE;
				var pos = toView(lightInfos[i+1].xyz);
				var halfSize = vec2(lightInfos[i].b, lightInfos[i].a);
				if( sphereTest(pos, lightInfos[i+2].a * 1.001 + length(halfSize)) ) {
					var cull = false;
					if( lightInfos[i+3].a >= 0.0 && lightInfos[i+5].r >= 0.0 ) {
						var n = dirToView(lightInfos[i+2].xyz);
						var support = vec3(n.x > 0.0 ? aabbMax.x : aabbMin.x, n.y > 0.0 ? aabbMax.y : aabbMin.y, n.z > 0.0 ? aabbMax.z : aabbMin.z);
						cull = dot(support - pos, n) < 0.0;
					}
					if( !cull )
						pushLight(l);
				}
			}
			counts |= typeCount << 24;

			clusterData[base] = counts;
		}
	};
}
