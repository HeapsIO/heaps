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
		@param var texture : Sampler2D;

		@param var time : Float;
		@param var loopCounter : Float;

		// animation
		@param var animationRepeat : Float;
		@param var animationFixedFrame : Float;
		@param var totalFrames : Float;
		@param var frameSize : Vec2;
		@param var frameDivision : Vec3;
		@param var transform : Mat3x4;

		// clip
		@const var clipBounds : Bool;
		@param var volumeMin : Vec3;
		@param var volumeSize : Vec3;
		@param var offset : Vec3;

		@param var cameraRotation : Mat3;
		@const var transform3D : Bool;

		var t : Float;
		var normT : Float;
		var randProp : Float;

		var frame : Float;
		var frameBlending : Float;
		var calculatedUV : Vec2;

		var colorUV : Vec2;
		var frameUV : Vec2;
		var frameUV2 : Vec2;

		function __init__() {
			t = (props.time + time) % (props.life * loopCounter);
			normT = t / props.life;
			randProp = -props.time / props.life;
			transformedPosition = input.position + (input.normal * (1 + speedIncr * t)) * t + offset;
			if( clipBounds )
				transformedPosition = (transformedPosition - volumeMin) % volumeSize + volumeMin;
			transformedPosition *= transform;
			transformedPosition.z -= gravity * t * t;
			transformedNormal = camera.dir;
			calculatedUV = vec2(props.uv.x, 1 - props.uv.y);
			{
				frame = (t / props.life) * animationRepeat + float(int(animationFixedFrame * randProp));
				frameBlending = frame.fract();
				frame -= frameBlending;
				frame %= totalFrames;
				var nextFrame = (frame + 1) % totalFrames;
				var delta = vec2( frame % frameDivision.x, float(int(frame / frameDivision.x)) );
				frameUV = (calculatedUV + delta) * frameDivision.yz;
				var delta = vec2( nextFrame % frameDivision.x, float(int(nextFrame / frameDivision.x)) );
				frameUV2 = (calculatedUV + delta) * frameDivision.yz;
			}
		}

		function vertex() {
			var current = props.init + props.delta * t;
			var size = (props.uv - 0.5) * current.y.max(0.);
			var rot = current.x;
			var crot = cos(rot), srot = sin(rot);
			var dist = vec2(size.x * crot - size.y * srot, size.x * srot + size.y * crot) * vec2(global.pixelSize.x / global.pixelSize.y, 1);
			if( transform3D ) {
				transformedPosition += vec3(0., dist.x, dist.y) * cameraRotation;
			} else {
				projectedPosition = vec4(transformedPosition, 1) * camera.viewProj;
				projectedPosition.xy += dist;
			}
			var comp = vec2(normT, 1 - fadeOut) < vec2(fadeIn, normT);
			pixelColor.a *= 1 - comp.x * (1 - (t / fadeIn).pow(fadePower)) - comp.y * ((normT - 1 + fadeOut) / fadeOut).pow(fadePower);
			colorUV = vec2(normT, randProp);
		}

		function fragment() {
			pixelColor *= color.get(colorUV);
			pixelColor *= mix( texture.get(frameUV) , texture.get(frameUV2), frameBlending );
		}

	};

}