package h3d.shader;

class ParticleShader extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var viewProj : Mat4;
		};

		@global var global : {
			@perObject var modelView : Mat4;
		};

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var size : Vec2;
			var uv : Vec2;
		};

		var transformedPosition : Vec3;
		var transformedNormal : Vec3;
		var projectedPosition : Vec4;

		// we store the corner coordinates and rotation in the input.normal

		@param var size : Vec2;
		@const var is3D : Bool;
		@const var isAbsolute : Bool;

		function vertex() {
			if( isAbsolute )
				transformedPosition = input.position;
			var rpos = input.normal.xy;
			var rot = input.normal.z;
			var cr = rot.cos();
			var sr = rot.sin();
			var rtmp = rpos.x * cr + rpos.y * sr;
			rpos.y = rpos.y * cr - rpos.x * sr;
			rpos.x = rtmp;
			if( is3D ) {
				rpos.xy *= input.size * size;
				transformedPosition.x += rpos.x;
				transformedPosition.z += rpos.y;
				projectedPosition = vec4(transformedPosition,1) * camera.viewProj;
			} else {
				projectedPosition = vec4(transformedPosition,1) * camera.viewProj;
				projectedPosition.xy += rpos * input.size * size;
			}
			transformedNormal = vec3(0, 0, -1);
		}

	}

}
