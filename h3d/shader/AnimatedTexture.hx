package h3d.shader;

class AnimatedTexture extends hxsl.Shader {

	static var SRC = {


		@input var input : {
			var uv : Vec2;
		};

		@param var texture : Sampler2D;
		var pixelColor : Vec4;

		var calculatedUV : Vec2;
		var calculatedUV2 : Vec2;

		@global var global : {
			var time : Float;
		};
		@param var speed : Float;
		@param var frameDivision : Float;
		@param var totalFrames : Float;
		@param var startTime : Float;
		@const var loop : Bool;

		@private var blendFactor : Float;

		function vertex() {

			var frame = (global.time - startTime) * speed;
			blendFactor = frame.fract();
			frame -= blendFactor;
			if( loop ) frame %= totalFrames else frame = min(frame, totalFrames - 1);
			var nextFrame = if( loop ) (frame + 1) % totalFrames else min(frame + 1, totalFrames - 1);

			var delta = vec2(1. / frameDivision, 1. / frameDivision) * vec2( frame % frameDivision, float(int(frame / frameDivision)) );
			calculatedUV = input.uv + delta;
			var delta = vec2(1. / frameDivision, 1. / frameDivision) * vec2( nextFrame % frameDivision, float(int(nextFrame / frameDivision)) );
			calculatedUV2 = input.uv + delta;
		}

		function fragment() {
			var c = mix( texture.get(calculatedUV) , texture.get(calculatedUV2), blendFactor);
			pixelColor *= c;
		}

	};


	public function new( texture, frameDivision : Int, totalFrames = -1, ?speed = 1.) {
		super();
		this.texture = texture;
		if( totalFrames < 0 ) totalFrames = frameDivision;
		this.frameDivision = frameDivision;
		this.totalFrames = totalFrames;
		this.speed = speed;
		this.loop = true;
	}

}