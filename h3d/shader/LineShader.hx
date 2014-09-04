package h3d.shader;

class LineShader extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var viewProj : Mat4;
		};

		@global var global : {
			var pixelSize : Vec2;
			@perObject var modelView : Mat4;
		};

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var uv : Vec2;
		}

		var output : {
			var position : Vec4;
		};

		var transformedNormal : Vec3;
		var transformedPosition : Vec3;
		var projectedPosition : Vec4;

		@param var lengthScale : Float;
		@param var width : Float;

		var pdir : Vec4;

		function __init__() {
			{
				var dir = input.normal * global.modelView.mat3(); // keep scale
				pdir = vec4(dir * mat3(camera.view), 1) * camera.proj;
				pdir.xy *= 1 / sqrt(pdir.x * pdir.x + pdir.y * pdir.y);
				transformedPosition += dir * input.uv.x * lengthScale;
				transformedNormal = dir.normalize();
			}
		}

		function vertex() {
			projectedPosition.xy += (pdir.yx * vec2(1,-1)) * (input.uv.y - 0.5) * projectedPosition.z * global.pixelSize * width;
		}

	};

	public function new( width = 1.5, lengthScale = 1. ) {
		super();
		this.width = width;
		this.lengthScale = lengthScale;
	}

}