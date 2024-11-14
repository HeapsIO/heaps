package h3d.shader;

class BaseMesh extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projFlip : Float;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var previousViewProj : Mat4;
			var inverseViewProj : Mat4;
			var zNear : Float;
			var zFar : Float;
			@var var dir : Vec3;
			var jitterOffsets : Vec4;
		};

		@global var global : {
			var time : Float;
			var pixelSize : Vec2;
			@perObject var modelView : Mat4;
			@perObject var modelViewInverse : Mat4;
			@perObject var previousModelView : Mat4;
		};

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
		};

		var output : {
			var position : Vec4;
			var color : Vec4;
			var depth : Float;
			var normal : Vec3;
			var worldDist : Float;
			var velocity : Vec2;
		};

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var previousTransformedPosition : Vec3;
		var pixelTransformedPosition : Vec3;
		var transformedNormal : Vec3;
		var projectedPosition : Vec4;
		var previousProjectedPosition : Vec4;
		var pixelColor : Vec4;
		var depth : Float;
		var ndcPosition : Vec2;
		var previousNdcPosition : Vec2;
		var screenUV : Vec2;
		var specPower : Float;
		var specColor : Vec3;
		var worldDist : Float;
		var pixelVelocity : Vec2;

		@param var color : Vec4;
		@range(0,100) @param var specularPower : Float;
		@range(0,10) @param var specularAmount : Float;
		@param var specularColor : Vec3;

		// each __init__ expr is out of order dependency-based
		function __init__() {
			relativePosition = input.position;
			transformedPosition = relativePosition * global.modelView.mat3x4();
			projectedPosition = vec4(transformedPosition, 1) * camera.viewProj;
			previousTransformedPosition = relativePosition * global.previousModelView.mat3x4();
			previousProjectedPosition = vec4(previousTransformedPosition, 1) * camera.previousViewProj;
			transformedNormal = (input.normal * global.modelView.mat3()).normalize();
			camera.dir = (camera.position - transformedPosition).normalize();
			pixelColor = color;
			specPower = specularPower;
			specColor = specularColor * specularAmount;
			screenUV = screenToUv(projectedPosition.xy / projectedPosition.w);
			depth = projectedPosition.z / projectedPosition.w;
			worldDist = length(transformedPosition - camera.position) / camera.zFar;
		}

		function __init__fragment() {
			transformedNormal = transformedNormal.normalize();
			// same as __init__, but will force calculus inside fragment shader, which limits varyings
			ndcPosition = projectedPosition.xy / projectedPosition.w;
			previousNdcPosition = previousProjectedPosition.xy / previousProjectedPosition.w;
			screenUV = screenToUv(ndcPosition);
			depth = projectedPosition.z / projectedPosition.w; // in case it's used in vertex : we don't want to interpolate in screen space
			specPower = specularPower;
			specColor = specularColor * specularAmount;
			ndcPosition -= camera.jitterOffsets.xy;
			previousNdcPosition -= camera.jitterOffsets.zw;
			pixelVelocity = ( previousNdcPosition - ndcPosition ) * vec2(0.5, -0.5);
		}

		function vertex() {
			output.position = projectedPosition * vec4(1, camera.projFlip, 1, 1);
			pixelTransformedPosition = transformedPosition;
		}

		function fragment() {
			output.color = pixelColor;
			output.depth = depth;
			output.normal = #if MRT_low packNormal(transformedNormal).rgb #else transformedNormal #end;
			output.worldDist = worldDist;
			output.velocity = pixelVelocity;
		}

	};

	public function new() {
		super();
		color.set(1, 1, 1);
		specularColor.set(1, 1, 1);
		specularPower = 50;
		specularAmount = 1;
	}

}
