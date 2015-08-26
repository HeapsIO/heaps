package h3d.shader;

class SinusDeform extends hxsl.Shader {

	static var SRC = {

		@global var time : Float;
		@param var speed : Float;
		@param var frequency : Float;
		@param var amplitude : Float;

		var calculatedUV : Vec2;

		function fragment() {
			calculatedUV.x += sin(calculatedUV.y * frequency + time * speed) * amplitude;
		}

	};

	public function new( frequency = 10., amplitude = 0.01, speed = 1. ) {
		super();
		this.frequency = frequency;
		this.amplitude = amplitude;
		this.speed = speed;
	}

}