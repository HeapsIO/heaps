package h3d.shader;

class Base2d extends hxsl.Shader {

	static var SRC = {

		@input var input : {
			var position : Vec2;
			var uv : Vec2;
			var color : Vec4;
		};

		var output : {
			var position : Vec4;
			var color : Vec4;
		};

		@global var time : Float;
		@param var zValue : Float;
		@param var texture : Sampler2D;

		var spritePosition : Vec4;
		var absolutePosition : Vec4;
		var pixelColor : Vec4;
		var textureColor : Vec4;
		@var var calculatedUV : Vec2;

		@const var isRelative : Bool;
		@param var color : Vec4;
		@param var absoluteMatrixA : Vec3;
		@param var absoluteMatrixB : Vec3;
		@param var filterMatrixA : Vec3;
		@param var filterMatrixB : Vec3;
		@const var hasUVPos : Bool;
		@param var uvPos : Vec4;

		@const var killAlpha : Bool;
		@const var pixelAlign : Bool;
		@param var halfPixelInverse : Vec2;
		@param var viewport : Vec4;

		@param var cameraMatrixA : Vec3;
		@param var cameraMatrixB : Vec3;
		@param var cameraScroll : Vec2;

		var outputPosition : Vec4;

		function __init__() {
			spritePosition = vec4(input.position, zValue, 1);
			if( isRelative ) {
				absolutePosition.x = vec3(spritePosition.xy,1).dot(absoluteMatrixA);
				absolutePosition.y = vec3(spritePosition.xy,1).dot(absoluteMatrixB);
				absolutePosition.zw = spritePosition.zw;
			} else
				absolutePosition = spritePosition;

			calculatedUV = hasUVPos ? input.uv * uvPos.zw + uvPos.xy : input.uv;
			pixelColor = isRelative ? color * input.color : input.color;
			textureColor = texture.get(calculatedUV);
			pixelColor *= textureColor;
		}

		function vertex() {
			// transform from global to render texture coordinates
			var tmp = vec3(absolutePosition.xy, 1);
			outputPosition = vec4(
				tmp.dot(filterMatrixA),
				tmp.dot(filterMatrixB),
				absolutePosition.zw
			);
			tmp = vec3(outputPosition.xy, 1);
			outputPosition.x = tmp.dot(vec3(cameraMatrixA.xy, -cameraMatrixA.z * cameraScroll.x));
			outputPosition.y = tmp.dot(vec3(cameraMatrixB.xy, -cameraMatrixB.z * cameraScroll.y));

			// transform to viewport
			outputPosition.xy = (outputPosition.xy + viewport.xy) * viewport.zw;
			// http://msdn.microsoft.com/en-us/library/windows/desktop/bb219690(v=vs.85).aspx
			if( pixelAlign ) outputPosition.xy -= halfPixelInverse;
			output.position = outputPosition;
		}

		function fragment() {
			if( killAlpha && pixelColor.a < 0.001 ) discard;
			output.color = pixelColor;
		}

	};


}