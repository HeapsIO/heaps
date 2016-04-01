package h3d.shader;

class GpuParticle extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@input var props : {
			var uv : Vec2;
			var time : Float;
			var life : Float;
			var init : Vec2;
			var delta : Vec2;
		};

		@param var fadePower : Float;
		@param var speedIncr : Float;

		var t : Float;

		function __init__() {
			t = (props.time + global.time) % props.life;
			transformedPosition = input.position + input.normal * t; // already transformed
			transformedNormal = camera.dir;
		}

		function vertex() {
			var current = props.init + props.delta * t;
			projectedPosition = vec4(transformedPosition, 1) * camera.viewProj;
			var size = (props.uv - 0.5) * current.y.max(0.);
			var rot = current.x;
			var crot = cos(rot), srot = sin(rot);
			projectedPosition.xy += vec2(size.x * crot - size.y * srot, size.x * srot + size.y * crot) * vec2(global.pixelSize.x / global.pixelSize.y, 1);
			pixelColor.a = 1 - abs((t / props.life) * 2 - 1).pow(fadePower);
		}

	};

}