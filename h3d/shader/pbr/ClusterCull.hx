package h3d.shader.pbr;

class ClusterCull extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var invProj : Mat4;
			@const var reverseDepth : Bool;
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

		@const var USE_HZB : Bool;
		@param var hzb : Sampler2D;
		@param var hzbSize : Vec2;

		// Lights hidden behind the depth buffer, from ClusterLightOcclusion : one int per light, point then spot, capsule, rect
		@const var USE_OCCLUSION : Bool;
		@param var lightVisible : StorageBuffer<Int>;
		@param var spotSlot : Int;
		@param var capsuleSlot : Int;
		@param var rectSlot : Int;

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

		function tileFarDepth( tx : Int, ty : Int ) : Float {
			var tileSize = hzbSize / vec2(float(CLUSTER_X), float(CLUSTER_Y));
			var lod = max(0.0, floor(log2(min(tileSize.x, tileSize.y))));
			var texel = exp2(lod);
			var mipSize = max(vec2(1.0), floor(hzbSize / texel));
			var pixelMin = vec2(float(tx), float(CLUSTER_Y - 1 - ty)) * tileSize;
			var texelMin = ivec2(floor(pixelMin / texel));
			var texelMax = ivec2(min(ceil((pixelMin + tileSize) / texel), mipSize) - 1.0);
			var depth = camera.reverseDepth ? 1.0 : 0.0;
			for( y in texelMin.y ... texelMax.y + 1 )
				for( x in texelMin.x ... texelMax.x + 1 ) {
					var d = hzb.fetchLod(ivec2(x, y), int(lod)).x;
					depth = camera.reverseDepth ? min(depth, d) : max(depth, d);
				}
			var p = vec4(0.0, 0.0, depth, 1.0) * camera.invProj;
			return p.z / p.w;
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
			if( USE_HZB ) {
				var far = tileFarDepth(tx, ty) * 1.001;
				if( z0 > far ) {
					clusterData[base] = 0;
					return;
				}
				z1 = min(z1, far);
			}

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
				if( USE_OCCLUSION && lightVisible[l] == 0 )
					continue;
				var i = pointLightOffset + l * POINT_LIGHT_STRIDE;
				if( sphereTest(toView(lightInfos[i+1].xyz), rangeFromInv4(lightInfos[i+1].a)) )
					pushLight(l);
			}
			counts = typeCount;

			typeCount = 0;
			for( l in spotStart...spotEnd ) {
				if( USE_OCCLUSION && lightVisible[spotSlot + l] == 0 )
					continue;
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
				if( USE_OCCLUSION && lightVisible[capsuleSlot + l] == 0 )
					continue;
				var i = capsuleLightOffset + l * CAPSULE_LIGHT_STRIDE;
				var halfLength = lightInfos[i].a;
				if( sphereTest(toView(lightInfos[i+1].xyz), rangeFromInv4(lightInfos[i+1].a) + halfLength) )
					pushLight(l);
			}
			counts |= typeCount << 16;

			typeCount = 0;
			for( l in rectStart...rectEnd ) {
				if( USE_OCCLUSION && lightVisible[rectSlot + l] == 0 )
					continue;
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

class ClusterLightOcclusion extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var invProj : Mat4;
			@const var reverseDepth : Bool;
		}

		@param var lightInfos : Buffer<Vec4, 4096>;
		@param var lightVisible : RWBuffer<Int>;
		@param var hzb : Sampler2D;
		@param var hzbSize : Vec2;

		// Keep in sync with h3d.shader.pbr.DefaultForward.
		final POINT_LIGHT_STRIDE   : Int = 2;
		final SPOT_LIGHT_STRIDE    : Int = 3;
		final CAPSULE_LIGHT_STRIDE : Int = 3;
		final RECT_LIGHT_STRIDE    : Int = 6;

		@param var pointLightOffset : Int;
		@param var pointCount : Int;
		@param var spotLightOffset : Int;
		@param var spotCount : Int;
		@param var capsuleLightOffset : Int;
		@param var capsuleCount : Int;
		@param var rectLightOffset : Int;
		@param var rectCount : Int;

		function rangeFromInv4( invRange4 : Float ) : Float {
			return pow(invRange4, -0.25) * 1.001;
		}

		function farDepth( ndcMin : Vec2, ndcMax : Vec2 ) : Float {
			var pixelMin = vec2(ndcMin.x * 0.5 + 0.5, 0.5 - ndcMax.y * 0.5) * hzbSize;
			var pixelMax = vec2(ndcMax.x * 0.5 + 0.5, 0.5 - ndcMin.y * 0.5) * hzbSize;
			var size = max(pixelMax - pixelMin, vec2(1.0));
			var lod = max(0.0, ceil(log2(max(size.x, size.y))) - 1.0);
			var texel = exp2(lod);
			var mipSize = max(vec2(1.0), floor(hzbSize / texel));
			var texelMin = ivec2(clamp(floor(pixelMin / texel), vec2(0.0), mipSize - 1.0));
			var texelMax = ivec2(clamp(ceil(pixelMax / texel) - 1.0, vec2(0.0), mipSize - 1.0));
			var depth = camera.reverseDepth ? 1.0 : 0.0;
			for( y in texelMin.y ... texelMax.y + 1 )
				for( x in texelMin.x ... texelMax.x + 1 ) {
					var d = hzb.fetchLod(ivec2(x, y), int(lod)).x;
					depth = camera.reverseDepth ? min(depth, d) : max(depth, d);
				}
			var p = vec4(0.0, 0.0, depth, 1.0) * camera.invProj;
			return p.z / p.w;
		}

		function sphereVisible( center : Vec3, radius : Float ) : Bool {
			var c = (vec4(center, 1.0) * camera.view).xyz;
			var visible = true;
			if( c.z - radius > 1e-3 ) {
				var ndcMin = vec2(1e30);
				var ndcMax = vec2(-1e30);
				for( k in 0...8 ) {
					var corner = c + vec3(float((k & 1) * 2 - 1), float(((k >> 1) & 1) * 2 - 1), float(((k >> 2) & 1) * 2 - 1)) * radius;
					var p = vec4(corner, 1.0) * camera.proj;
					ndcMin = min(ndcMin, p.xy / p.w);
					ndcMax = max(ndcMax, p.xy / p.w);
				}
				ndcMin = max(ndcMin, vec2(-1.0));
				ndcMax = min(ndcMax, vec2(1.0));
				if( ndcMin.x < ndcMax.x && ndcMin.y < ndcMax.y )
					visible = c.z - radius <= farDepth(ndcMin, ndcMax) * 1.001;
			}
			return visible;
		}

		function main() {
			setLayout(64, 1, 1);
			var id = computeVar.globalInvocation.x;
			var total = pointCount + spotCount + capsuleCount + rectCount;
			if( id >= total )
				return;

			var center = vec3(0.0);
			var radius = 0.0;
			if( id < pointCount ) {
				var i = pointLightOffset + id * POINT_LIGHT_STRIDE;
				center = lightInfos[i+1].xyz;
				radius = rangeFromInv4(lightInfos[i+1].a);
			} else if( id < pointCount + spotCount ) {
				var i = spotLightOffset + (id - pointCount) * SPOT_LIGHT_STRIDE;
				center = lightInfos[i+1].xyz;
				radius = lightInfos[i+2].a * 1.001;
			} else if( id < pointCount + spotCount + capsuleCount ) {
				var i = capsuleLightOffset + (id - pointCount - spotCount) * CAPSULE_LIGHT_STRIDE;
				center = lightInfos[i+1].xyz;
				radius = rangeFromInv4(lightInfos[i+1].a) + lightInfos[i].a;
			} else {
				var i = rectLightOffset + (id - pointCount - spotCount - capsuleCount) * RECT_LIGHT_STRIDE;
				center = lightInfos[i+1].xyz;
				radius = lightInfos[i+2].a * 1.001 + length(vec2(lightInfos[i].b, lightInfos[i].a));
			}
			lightVisible[id] = sphereVisible(center, radius) ? 1 : 0;
		}
	};
}
