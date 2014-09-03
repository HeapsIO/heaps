package h3d.shader;

class BaseMesh extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var inverseViewProj : Mat4;
			@var var dir : Vec3;
		};

		@global var global : {
			var time : Float;
			var flipY : Float;
			var pixelSize : Vec2;
			@perObject var modelView : Mat4;
			@perObject var modelViewInverse : Mat4;
		};

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
		};

		var output : {
			var position : Vec4;
			var color : Vec4;
			var distance : Vec4;
		};

		var transformedPosition : Vec3;
		var transformedNormal : Vec3;
		var projectedPosition : Vec4;
		var pixelColor : Vec4;
		var depth : Float;

		@param var color : Vec4;

		// each __init__ expr is out of order dependency-based
		function __init__() {
			transformedPosition = input.position * global.modelView.mat3x4();
			projectedPosition = vec4(transformedPosition, 1) * camera.viewProj;
			transformedNormal = (input.normal * global.modelView.mat3()).normalize();
			camera.dir = (camera.position - transformedPosition).normalize();
			pixelColor = color;
			depth = projectedPosition.z / projectedPosition.w;
		}

		function vertex() {
			output.position = projectedPosition;
			#if !flash
			// this is done to flip the rendering on render targets in openGL
			output.position.y *= global.flipY;
			#end
		}

		function fragment() {
			output.color = pixelColor;
			output.distance = pack(depth);
		}

	};

	public function new() {
		super();
		color.set(1, 1, 1);
	}

}
