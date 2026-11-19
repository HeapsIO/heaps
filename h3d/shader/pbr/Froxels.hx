package h3d.shader.pbr;

class Froxel extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var position : Vec3;
			var viewProj : Mat4;
			var invProj : Mat4;
			var invView : Mat4;
			var inverseViewProj : Mat4;
			var previousViewProj : Mat4;
		};

		@global var froxels : {
			var size : Vec3;
			var near : Float;
			var far : Float;
		};
		@global var froxelIntegratedVolume : Sampler3D;

		function froxelSliceToViewZ( w : Float ) : Float {
			return froxels.near * pow(froxels.far / froxels.near, w);
		}

		function froxelViewZToSlice( viewZ : Float ) : Float {
			return log(max(viewZ, froxels.near) / froxels.near) / log(froxels.far / froxels.near);
		}

		function froxelToWorld( uvw : Vec3 ) : Vec3 {
			var viewZ = froxelSliceToViewZ(uvw.z);
			var p = vec4(uvToScreen(uvw.xy), 1.0, 1.0) * camera.invProj;
			var viewPos = p.xyz * (viewZ / p.z);
			return (vec4(viewPos, 1.0) * camera.invView).xyz;
		}

		function worldToFroxel( wpos : Vec3 ) : Vec3 {
			var clipPos = vec4(wpos, 1.0) * camera.viewProj;
			return vec3(screenToUv(clipPos.xy / clipPos.w), froxelViewZToSlice(clipPos.w));
		}

		function froxelFog( wpos : Vec3 ) : Vec4 {
			var clipPos = vec4(wpos, 1.0) * camera.viewProj;
			var uv = screenToUv(clipPos.xy / clipPos.w);
			var halfSlice = 0.5 / froxels.size.z;
			var fog = froxelIntegratedVolume.get(vec3(uv, max(froxelViewZToSlice(clipPos.w) - halfSlice, halfSlice)));
			return mix(vec4(0.0, 0.0, 0.0, 1.0), fog, saturate(clipPos.w / froxelSliceToViewZ(2.0 * halfSlice)));
		}
	}
}

class FroxelStore extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.pbr.Froxels.Froxel;

		@param var lightingVolume : RWTexture3D<Vec4>;
		@param var historyVolume : Sampler3D;
		@param var jitter : Vec3;
		@param var temporalBlend : Float;

		var froxelCell : IVec3;
		var froxelWorldPos : Vec3;
		var froxelLight : Vec3;
		var froxelAmbient : Vec3;
		var froxelEnvColor : Vec3;
		var fogExtinction : Float;
		var fogAlbedo : Vec3;
		var fogEmissive : Vec3;
		var fogAmbient : Float;
		var fogEnvTint : Float;

		function __init__() {
			setLayout(8, 8, 1);
			froxelCell = ivec3(computeVar.globalInvocation);
			froxelWorldPos = froxelToWorld((vec3(froxelCell) + jitter) / froxels.size);
			froxelLight = vec3(0.0);
			froxelAmbient = vec3(0.0);
			froxelEnvColor = vec3(1.0);
			fogExtinction = 0.0;
			fogAlbedo = vec3(1.0);
			fogEmissive = vec3(0.0);
			fogAmbient = 1.0;
			fogEnvTint = 0.0;
		}

		function main() {
			if( froxelCell.x < int(froxels.size.x) && froxelCell.y < int(froxels.size.y) ) {
				var tint = mix(vec3(1.0), saturate(froxelEnvColor), fogEnvTint);
				var light = (froxelLight + froxelAmbient * fogAmbient) * tint;
				var current = vec4(fogExtinction * (light * fogAlbedo + fogEmissive), fogExtinction);
				if( temporalBlend < 1.0 ) {
					var center = froxelToWorld((vec3(froxelCell) + 0.5) / froxels.size);
					var clipPos = vec4(center, 1.0) * camera.previousViewProj;
					if( clipPos.w > 0.0 ) {
						var uvw = vec3(screenToUv(clipPos.xy / clipPos.w), froxelViewZToSlice(clipPos.w));
						var edge = min(uvw, 1.0 - uvw);
						if( min(edge.x, min(edge.y, edge.z)) >= 0.0 )
							current = mix(historyVolume.getLod(uvw, 0.0), current, temporalBlend);
					}
				}
				lightingVolume.store(froxelCell, current);
			}
		}
	}
}

class FroxelIntegrate extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.pbr.Froxels.Froxel;

		@param var lightingVolume : Sampler3D;
		@param var integratedVolume : RWTexture3D<Vec4>;

		function main() {
			setLayout(8, 8, 1);
			var column = ivec2(computeVar.globalInvocation.xy);
			if( column.x >= int(froxels.size.x) || column.y >= int(froxels.size.y) )
				return;

			var p = vec4(uvToScreen((vec2(column) + 0.5) / froxels.size.xy), 1.0, 1.0) * camera.invProj;
			var rayLength = length(p.xyz / p.z);

			var inScatter = vec3(0.0);
			var transmittance = 1.0;
			var prevViewZ = 0.0;
			var sliceCount = int(froxels.size.z);
			for( s in 0...sliceCount ) {
				var viewZ = froxelSliceToViewZ(float(s + 1) / froxels.size.z);
				var d = (viewZ - prevViewZ) * rayLength;
				prevViewZ = viewZ;
				var v = lightingVolume.fetch(ivec3(column, s));
				var sigmaT = v.a;
				var sliceTransmittance = exp(-sigmaT * d);
				var sliceScatter = sigmaT > 1e-7 ? (v.rgb - v.rgb * sliceTransmittance) / sigmaT : v.rgb * d;
				inScatter += transmittance * sliceScatter;
				transmittance *= sliceTransmittance;
				integratedVolume.store(ivec3(column, s), vec4(inScatter, transmittance));
			}
		}
	}
}

class FroxelLighting extends h3d.shader.pbr.DefaultForward.DefaultForwardBase {

	static var SRC = {

		@const var POINT_LIGHTS : Bool;
		@const var SPOT_LIGHTS : Bool;

		var froxelWorldPos : Vec3;
		var froxelLight : Vec3;
		var froxelAmbient : Vec3;
		var froxelEnvColor : Vec3;

		function directLighting( lightColor : Vec3, lightDirection : Vec3, specularDirection : Vec3 ) : Vec3 {
			return lightColor;
		}

		function skipClusterLights( type : Int ) {
			if( CLUSTERED )
				clusterStart += (clusterCounts >> ((type - LIGHT_POINT) * 8)) & 0xFF;
		}

		function main() {
			transformedPosition = froxelWorldPos;
			var toCamera = normalize(cameraPosition - froxelWorldPos);
			transformedNormal = toCamera;
			init();
			var light = accumulateLights(vec3(0.0), LIGHT_DIR, dirShadowCount, dirLightCount, MAX_DIR_SHADOW_COUNT);
			if( POINT_LIGHTS || SPOT_LIGHTS ) {
				if( CLUSTERED ) {
					var cluster = clusterIndex();
					clusterCounts = clusterData[cluster];
					clusterStart = cluster + 1;
				}
				if( POINT_LIGHTS )
					light = accumulateLights(light, LIGHT_POINT, pointShadowCount, pointLightCount, MAX_POINT_SHADOW_COUNT);
				else
					skipClusterLights(LIGHT_POINT);
				if( SPOT_LIGHTS )
					light = accumulateLights(light, LIGHT_SPOT, spotShadowCount, spotLightCount, MAX_SPOT_SHADOW_COUNT);
				else
					skipClusterLights(LIGHT_SPOT);
				if( POINT_LIGHTS ) {
					light = accumulateLights(light, LIGHT_CAPSULE, capsuleShadowCount, capsuleLightCount, MAX_CAPSULE_SHADOW_COUNT);
					light = accumulateLights(light, LIGHT_RECT, rectShadowCount, rectLightCount, MAX_RECT_SHADOW_COUNT);
				}
			}
			if( HAS_CASCADE ) {
				var c = evaluateCascadeLight();
				if( dot(c, c) > 1e-6 )
					c *= evaluateCascadeShadow();
				light += c;
			}
			froxelLight = light;
			if( USE_INDIRECT ) {
				froxelEnvColor = irrDiffuse.getLod(rotateNormal(toCamera), 0.0).rgb;
				froxelAmbient = froxelEnvColor * irrPower;
			}
		}
	}
}

class FroxelConstantMedium extends hxsl.Shader {

	static var SRC = {

		@param var extinction : Float;
		@param var albedo : Vec3;

		var fogExtinction : Float;
		var fogAlbedo : Vec3;

		function main() {
			fogExtinction = extinction;
			fogAlbedo = albedo;
		}
	}
}

class FroxelApply extends h3d.shader.ScreenShader {

	static var SRC = {

		@:import h3d.shader.pbr.Froxels.Froxel;

		@const var RAYMARCH_BLEND : Bool;
		@param var depthTexture : Sampler2D;

		function fragment() {
			var depthSize = depthTexture.size();
			var depth = depthTexture.fetch(ivec2(min(calculatedUV * depthSize, depthSize - 1.0))).r;
			var p = vec4(uvToScreen(calculatedUV), depth, 1.0) * camera.inverseViewProj;
			var fog = froxelFog(p.xyz / p.w);
			pixelColor = RAYMARCH_BLEND ? vec4(fog.rgb * (1.0 - fog.a), 1.0 - fog.a) : fog;
		}
	}
}

class FroxelDebug extends h3d.shader.ScreenShader {

	static var SRC = {

		@:import h3d.shader.pbr.Froxels.Froxel;

		@const var SHOW_INTEGRATED : Bool;
		@param var depthTexture : Sampler2D;
		@param var lightingVolume : Sampler3D;
		@param var integratedVolume : Sampler3D;

		function fragment() {
			var depthSize = depthTexture.size();
			var depth = depthTexture.fetch(ivec2(min(calculatedUV * depthSize, depthSize - 1.0))).r;
			var p = vec4(uvToScreen(calculatedUV), depth, 1.0) * camera.inverseViewProj;
			var uvw = worldToFroxel(p.xyz / p.w);
			var g = uvw * froxels.size;
			var f = fract(g);
			var fw = fwidth(g);
			if( !(uvw.z < 1.0) )
				discard;

			var cell = min(floor(g), froxels.size - 1.0);
			var color = vec3(0.0);
			var alpha = 0.0;
			if( SHOW_INTEGRATED ) {
				var integrated = integratedVolume.fetch(ivec3(cell));
				color = integrated.rgb / (1.0 + integrated.rgb);
				alpha = 1.0 - integrated.a;
			} else {
				var stored = lightingVolume.fetch(ivec3(cell));
				var lit = stored.a > 0.0 ? stored.rgb / stored.a : vec3(0.0);
				alpha = mix(0.3, 0.6, mod(cell.x + cell.y + cell.z, 2.0));
				color = lit / (1.0 + lit) * alpha;
			}
			if( f.x < fw.x || f.y < fw.y ) {
				color = vec3(0.3);
				alpha = 0.3;
			}
			if( f.z < fw.z ) {
				color = vec3(0.8, 0.8, 0.0);
				alpha = 0.8;
			}
			pixelColor = vec4(color, alpha);
		}
	}
}
