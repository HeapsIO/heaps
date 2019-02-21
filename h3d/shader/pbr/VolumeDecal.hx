package h3d.shader.pbr;

class DecalOverlay extends hxsl.Shader {
	static var SRC = {

		@global var global : {
			var time : Float;
			var pixelSize : Vec2;
			@perObject var modelView : Mat4;
			@perObject var modelViewInverse : Mat4;
		};

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projFlip : Float;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var inverseViewProj : Mat4;
			var zNear : Float;
			var zFar : Float;
			@var var dir : Vec3;
		};

		var output : {
			color : Vec4
		};

		@const var CENTERED : Bool;

		@global var depthMap : Channel;

		@param var maxAngle : Float;
		@param var fadePower : Float;
		@param var fadeStart : Float;
		@param var fadeEnd : Float;
		@param var emissive : Float;

		@param var colorTexture : Sampler2D;

		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		var pixelTransformedPosition : Vec3;
		var projectedPosition : Vec4;
		var localPos : Vec3;

		function outsideBounds() : Bool {
			return ( localPos.x > 0.5 || localPos.x < -0.5 || localPos.y > 0.5 || localPos.y < -0.5 || localPos.z > 0.5 || localPos.z < -0.5 );
		}

		function fragment() {

			var matrix = camera.inverseViewProj * global.modelViewInverse;
			var screenPos = projectedPosition.xy / projectedPosition.w;
			var depth = depthMap.get(screenToUv(screenPos));
			var ruv = vec4( screenPos, depth, 1 );
			var wpos = ruv * matrix;
			var ppos = ruv * camera.inverseViewProj;

			pixelTransformedPosition = ppos.xyz / ppos.w;
			localPos = (wpos.xyz / wpos.w);
			calculatedUV = localPos.xy;
			var fadeFactor = 1 - clamp( pow( max( 0.0, abs(localPos.z * 2) - fadeStart) / (fadeEnd - fadeStart), fadePower), 0, 1);

			if( CENTERED )
				calculatedUV += 0.5;

			if(	outsideBounds() )
				discard;

			var color = colorTexture.get(calculatedUV);
			pixelColor.rgb = color.rgb + color.rgb * emissive;
			pixelColor.a = max(max(pixelColor.r, pixelColor.g), pixelColor.b) * fadeFactor;
		}
	}

	public function new( ) {
		super();
	}
}

class DecalPBR extends hxsl.Shader {

	static var SRC = {

		@global var global : {
			var time : Float;
			var pixelSize : Vec2;
			@perObject var modelView : Mat4;
			@perObject var modelViewInverse : Mat4;
		};

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projFlip : Float;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var inverseViewProj : Mat4;
			var zNear : Float;
			var zFar : Float;
			@var var dir : Vec3;
		};

		var output : {
			color : Vec4,
			normal : Vec3,
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
			albedoStrength : Float,
			normalStrength : Float,
			pbrStrength : Float,
			emissiveStrength : Float,
			//depth : Float,
		};

		@const var CENTERED : Bool;
		@const var USE_ALBEDO : Bool;
		@const var USE_NORMAL : Bool;
		@const var USE_PBR : Bool;

		@param var albedoStrength : Float;
		@param var normalStrength : Float;
		@param var pbrStrength : Float;

		@global var depthMap : Channel;

		@param var normal : Vec3;
		@param var tangent : Vec3;

		@param var minBound : Vec3;
		@param var maxBound : Vec3;
		@param var maxAngle : Float;
		@param var fadePower : Float;
		@param var fadeStart : Float;
		@param var fadeEnd : Float;
		@param var emissive : Float;

		@param var albedoTexture : Sampler2D;
		@param var normalTexture : Sampler2D;
		@param var pbrTexture : Sampler2D;

		var calculatedUV : Vec2;
		var transformedTangent : Vec4;
		var transformedNormal : Vec3;
		var pixelTransformedPosition : Vec3;
		var projectedPosition : Vec4;
		var pixelColor : Vec4;
		var prbValues : Vec4;
		var strength : Vec4;
		var localPos : Vec3;
		var alpha : Float;

		function __init__vertex() {
			transformedNormal = (normal * global.modelView.mat3()).normalize();
			transformedTangent = vec4((tangent * global.modelView.mat3()).normalize(),1.);
		}

		function __init__fragment() {

		}

		function getWorlPos( pos : Vec2 ) : Vec3{
			var depth = depthMap.get(screenToUv(pos)).r;
			var ruv = vec4( pos, depth, 1 );
			var wpos = ruv * camera.inverseViewProj;
			var result = (wpos.xyz / wpos.w);
			return result;
		}

		function outsideBounds() : Bool {
			return ( localPos.x > 0.5 || localPos.x < -0.5 || localPos.y > 0.5 || localPos.y < -0.5 || localPos.z > 0.5 || localPos.z < -0.5 );
		}

		function fragment() {

			var matrix = camera.inverseViewProj * global.modelViewInverse;
			var screenPos = projectedPosition.xy / projectedPosition.w;
			var depth = depthMap.get(screenToUv(screenPos));
			var ruv = vec4( screenPos, depth, 1 );
			var wpos = ruv * matrix;
			var ppos = ruv * camera.inverseViewProj;
			alpha = 1.0;

			pixelTransformedPosition = ppos.xyz / ppos.w;
			localPos = (wpos.xyz / wpos.w);
			calculatedUV = localPos.xy;
			var fadeFactor = 1 - clamp( pow( max( 0.0, abs(localPos.z * 2) - fadeStart) / (fadeEnd - fadeStart), fadePower), 0, 1);

			if( CENTERED )
				calculatedUV += 0.5;

			if(	outsideBounds() )
				discard;

			strength = vec4(0,0,0,0);
			prbValues = vec4(0,0,0,0);

			if( USE_ALBEDO ) {
				var albedo = albedoTexture.get(calculatedUV);
				pixelColor = albedo;
				strength.r = albedoStrength * albedo.a;
				alpha = albedo.a;
			}

			if( USE_NORMAL ) {
				var worldPos = getWorlPos(screenPos);
				var ddx = worldPos - getWorlPos(screenPos + vec2(global.pixelSize.x, 0));
				var ddy = worldPos - getWorlPos(screenPos + vec2(0, global.pixelSize.y));
				var worldNormal = normalize(cross(ddy, ddx));
				var worldTangent = cross(worldNormal, vec3(0,1,0));
				var normal = normalTexture.get(calculatedUV).rgba;
				var n = worldNormal;
				var nf = unpackNormal(normal);
				var tanX = worldTangent.xyz.normalize();
				var tanY = n.cross(tanX) * -1;
				transformedNormal = (nf.x * tanX + nf.y * tanY + nf.z * n).normalize();
				strength.g = normalStrength * alpha;
			}

			if( USE_PBR ) {
				var pbr = pbrTexture.get(calculatedUV).rgba;
				prbValues.r = pbr.r;
				prbValues.g = 1 - pbr.g * pbr.g;
				prbValues.b = pbr.b;
				strength.b = pbrStrength * alpha;
			}

			//output.color = pixelColor; // Allow override
			output.normal = transformedNormal;
			output.metalness = prbValues.r;
			output.roughness = prbValues.g;
			output.occlusion = prbValues.b;
			output.emissive = emissive * alpha;
			output.albedoStrength = strength.r * fadeFactor;
			output.normalStrength = strength.g * fadeFactor;
			output.pbrStrength = strength.b * fadeFactor;
			output.emissiveStrength = 0;
			//output.depth = 0; // Dont draw depth again
		}
	};

	public function new( ) {
		super();
		CENTERED = true;
	}
}