package h3d.shader;

class VolumeDecal extends hxsl.Shader {

	static var SRC = {

		@:import BaseMesh;

		@const var isCentered : Bool;
		@global var depthMap : Channel;

		@param var scale : Vec2;
		@param var normal : Vec3;
		@param var tangent : Vec3;

		@param var min : Vec3;
		@param var max : Vec3;
		@param var maxAngle : Float;

		var calculatedUV : Vec2;
		var transformedTangent : Vec4;

		function __init__vertex() {
			transformedNormal = (normal * global.modelView.mat3()).normalize();
			transformedTangent = vec4((tangent * global.modelView.mat3()).normalize(),1.);
		}

		function getWorlPos( pos : Vec2 ) : Vec3{
			var depth = depthMap.get(screenToUv(pos)).r;
			var ruv = vec4( pos, depth, 1 );
			var wpos = ruv * camera.inverseViewProj;
			var result = (wpos.xyz / wpos.w);
			return result;
		}

		function outsideBounds() : Bool {
			return (pixelTransformedPosition.x < min.x || pixelTransformedPosition.x > max.x ||
					pixelTransformedPosition.y < min.y || pixelTransformedPosition.y > max.y ||
			 		pixelTransformedPosition.z < min.z || pixelTransformedPosition.z > max.z );
		}

		function fragment() {

			var matrix = camera.inverseViewProj * global.modelViewInverse;
			var screenPos = projectedPosition.xy / projectedPosition.w;
			var depth = depthMap.get(screenToUv(screenPos));
			var ruv = vec4( screenPos, depth, 1 );
			var wpos = ruv * matrix;
			var ppos = ruv * camera.inverseViewProj;

			var worldPos = getWorlPos(screenPos);
			var ddx = worldPos - getWorlPos(screenPos + vec2(global.pixelSize.x, 0));
			var ddy = worldPos - getWorlPos(screenPos + vec2(0, global.pixelSize.y));
			var worldNormal = normalize(cross(ddy, ddx));
			//transformedNormal = worldNormal;

			var angle = acos(dot(worldNormal, normal));
			if( angle > maxAngle )
				discard;

			pixelTransformedPosition = ppos.xyz / ppos.w;
			calculatedUV = scale * (wpos.xy / wpos.w);

			if( isCentered )
				calculatedUV += 0.5;

			if(	outsideBounds() )
				discard;
		}
	};

	public function new( objectWidth : Float, objectHeight : Float ) {
		super();
		normal.set(0, 0, 1);
		tangent.set(1, 0, 0);
		scale.set(1/objectWidth, 1/objectHeight);
		isCentered = true;
	}
}