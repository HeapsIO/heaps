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

		@param var fadeIn : Float;
		@param var fadeOut : Float;
		@param var fadePower : Float;
		@param var speedIncr : Float;
		@param var gravity : Float;
		@param var color : Sampler2D;

		var t : Float;
		var normT : Float;

		function __init__() {
			t = (props.time + global.time) % props.life;
			normT = t / props.life;
			transformedPosition = input.position + (input.normal * (1 + speedIncr*t)) * t; // already transformed
			transformedPosition.z -= gravity * t * t;
			transformedNormal = camera.dir;
		}

		function vertex() {
			var current = props.init + props.delta * t;
			projectedPosition = vec4(transformedPosition, 1) * camera.viewProj;
			var size = (props.uv - 0.5) * current.y.max(0.);
			var rot = current.x;
			var crot = cos(rot), srot = sin(rot);
			projectedPosition.xy += vec2(size.x * crot - size.y * srot, size.x * srot + size.y * crot) * vec2(global.pixelSize.x / global.pixelSize.y, 1);
			var comp = vec2(normT, 1 - fadeOut) < vec2(fadeIn, normT);
			pixelColor.a *= 1 - comp.x * (1 - (t / fadeIn).pow(fadePower)) - comp.y * ((normT - 1 + fadeOut) / fadeOut).pow(fadePower);
		}

		function fragment() {
			pixelColor *= color.get(vec2(normT, props.time / props.life));
		}

	};

}