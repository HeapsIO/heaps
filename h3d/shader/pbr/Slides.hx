package h3d.shader.pbr;

enum abstract DebugMode(Int) {
	var Full = 0;
	var Albedo = 1;
	var Normal = 2;
	var Depth = 3;
	var Metalness = 4;
	var Roughness = 5;
	var AO = 6;
	var Emissive = 7;
	var Shadow = 8;
	var Velocity = 9;
}

class Slides extends ScreenShader {

	static var SRC = {

		var albedo : Vec3;
		var depth : Float;
		var normal : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var custom1 : Float = 0.0;
		var custom2 : Float = 0.0;

		@param var shadowMap : Channel;
		@param var shadowMapCube : SamplerCube;
		@param var velocity : Sampler2D;
		@const var shadowIsCube : Bool;
		@const var smode : Int;
		@const var HAS_VELOCITY : Bool;

		function getColor(x:Float,y:Float) : Vec3 {
			var color : Vec3;
			if( y < 1 ) {
				if( x < 1 )
					color = albedo.sqrt();
				else if( x < 2 )
					color = packNormal(normal).rgb;
				else
					color = depth.xxx;
			} else if ( y < 2 )  {
				if( x < 1 )
					color = metalness.xxx;
				else if( x < 2 )
					color = roughness.xxx;
				else if( x < 3 )
					color = occlusion.xxx;
			} else {
				if ( x < 1 )
					color = vec3(emissive, custom1, custom2);
				else if ( x < 2 ) {
					var uv = vec2(x-1,y-2);
					if( shadowIsCube ) {
						var phi = (1 - uv.x)*3.1415*2;
						var theta = (-uv.y+0.5)*3.1415;
						var dir = vec3(cos(phi)*cos(theta),sin(phi)*cos(theta),sin(theta));
						color = shadowMapCube.get(dir).xxx;
					} else
						color = shadowMap.get(uv).xxx;
				} else if (HAS_VELOCITY) {
					color = packNormal(velocity.get(input.uv).xyz * 100.0).xyz;
				}
			}
			return color;
		}

		function fragment() {
			var color : Vec3;
			var x = input.uv.x * 3;
			var y = input.uv.y * 3;
			if( smode == 0 )
				color = getColor(x,y);
			else
				color = getColor( (smode - 1)%3 + input.uv.x, int((smode - 1) / 3) + input.uv.y );
			pixelColor = vec4(color, 1.);
		}
	};

	public var mode(get,set) : DebugMode;

	function get_mode() : DebugMode { return cast smode; }
	function set_mode(m:DebugMode) { smode = cast m; return m; }

}
