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
		@perInstance @param var startFrame : Float = 0.0;
		@param var speed : Float;
		@param var frameDivision : Vec2;
		@param var totalFrames : Float;
		@perInstance @param var startTime : Float;
		@const var loop : Bool;

		@private var blendFactor : Float;

		var textureColor : Vec4;

		function vertex() {

			var frame = (global.time - startTime) * speed + float(int(startFrame));
			blendFactor = frame.fract();
			frame -= blendFactor;
			if( loop ) frame %= totalFrames else frame = min(frame, totalFrames - 1);
			var nextFrame = if( loop ) (frame + 1) % totalFrames else min(frame + 1, totalFrames - 1);

			var delta = vec2( frame % frameDivision.x, float(int(frame / frameDivision.x)) );
			calculatedUV = (input.uv + delta) / frameDivision;
			var delta = vec2( nextFrame % frameDivision.x, float(int(nextFrame / frameDivision.x)) );
			calculatedUV2 = (input.uv + delta) / frameDivision;
		}

		function __init__fragment() {
			textureColor = mix( texture.get(calculatedUV) , texture.get(calculatedUV2), blendFactor);
		}

		function fragment() {
			pixelColor *= textureColor;
		}

	};


	public function new( texture, frameDivisionX : Int, frameDivisionY : Int, totalFrames = -1, ?speed = 1.) {
		super();
		this.texture = texture;
		if( totalFrames < 0 ) totalFrames = frameDivisionX * frameDivisionY;
		this.frameDivision.set(frameDivisionX,frameDivisionY);
		this.totalFrames = totalFrames;
		this.speed = speed;
		this.loop = true;
	}

}