package h3d.shader;

class VolumeDecal extends hxsl.Shader {

	static var SRC = {

		@:import BaseMesh;

		@global var depthMap : Channel;

		@param var scale : Vec2;
		@param var normal : Vec3;
		@param var tangent : Vec3;
		@const var isCentered : Bool = true;
		var calculatedUV : Vec2;
		var transformedTangent : Vec4;

		function __init__vertex() {
			transformedNormal = (normal * global.modelView.mat3()).normalize();
			transformedTangent = vec4((tangent * global.modelView.mat3()).normalize(),1.);
		}

		function fragment() {
			var matrix = camera.inverseViewProj * global.modelViewInverse;
			var screenPos = projectedPosition.xy / projectedPosition.w;
			var ruv = vec4(
				screenPos,
				depthMap.get(screenToUv(screenPos)),
				1
			);
			var wpos = ruv * matrix;
			var ppos = ruv * camera.inverseViewProj;
			pixelTransformedPosition = ppos.xyz / ppos.w;
			calculatedUV = scale * (wpos.xy / wpos.w);
			if( isCentered ) calculatedUV += 0.5;
			if( min(min(calculatedUV.x, calculatedUV.y), min(1 - calculatedUV.x, 1 - calculatedUV.y)) < 0 )
				discard;
		}

	};

	public function new( objectWidth : Float, objectHeight : Float ) {
		super();
		normal.set(0, 0, 1);
		tangent.set(1, 0, 0);
		scale.set(1/objectWidth, 1/objectHeight);
	}

}