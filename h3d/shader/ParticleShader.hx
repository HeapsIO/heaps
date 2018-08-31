package h3d.shader;

class ParticleShader extends hxsl.Shader {

	static var SRC = {

		@global var camera : {
			var viewProj : Mat4;
			var position : Vec3;
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
		@param var rotationAxis : Mat3;

		// we store the corner coordinates and rotation in the input.normal

		@param var size : Vec2;
		@const var is3D : Bool;
		@const var isAbsolute : Bool;

		function __init__() {
			if( isAbsolute ) transformedPosition = input.position;
		}

		function vertex() {
			var rpos = input.normal.xy;
			var rot = input.normal.z;
			var cr = rot.cos();
			var sr = rot.sin();
			var pos = input.size * rpos;
			if( is3D ) pos *= size;
			var rtmp = pos.x * cr + pos.y * sr;
			pos.y = pos.y * cr - pos.x * sr;
			pos.x = rtmp;
			if( is3D ) {
				transformedPosition += vec3(pos,0) * rotationAxis;
			} else {
				projectedPosition = vec4(transformedPosition,1) * camera.viewProj;
				projectedPosition.xy += pos * size;
			}
			transformedNormal = (transformedPosition - camera.position).normalize();
		}

	}

	public function new() {
		super();
		rotationAxis.initRotationAxis(new h3d.Vector(1, 0, 0), Math.PI / 2);
	}

}
