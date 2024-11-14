package h3d.shader;

class CheckerboardDepth extends h3d.shader.ScreenShader {
	static var SRC = {

		@param var source : Sampler2D;
		@param var texRatio : Float;

		final offsets : Array<Vec2, 4> = [
			vec2(0, 0), vec2(0, 1),
			vec2(1, 0), vec2(1, 1)
		];

		function fragment() {
			var invDimensions = 1.0 / source.size();
			var pixels = floor(fragCoord.xy);
			var upscalePixels = pixels * texRatio + vec2(0.5);
			var s00 = source.get( ( upscalePixels + offsets[0] ) * invDimensions );
			var s01 = source.get( ( upscalePixels + offsets[1] ) * invDimensions );
			var s10 = source.get( ( upscalePixels + offsets[2] ) * invDimensions );
			var s11 = source.get( ( upscalePixels + offsets[3] ) * invDimensions );
            #if js
			if ( mod(pixels.x, 2) != mod(pixels.y, 2) )
            #else
			if ( (int(pixels.x) & 1) != (int(pixels.y) & 1) )
            #end
				pixelColor = max(s00, max(s01, max(s10, s11)));
			else
				pixelColor = min(s00, min(s01, min(s10, s11)));

		}

	}
}