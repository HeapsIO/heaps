package h3d.shader.pbr;

@:enum abstract DebugMode(Int) {
	var Full = 0;
	var Albedo = 1;
	var Normal = 2;
	var Roughness = 3;
	var Metalness = 4;
	var Emmissive = 5;
	var Depth = 6;
	var AO = 7;
	var Shadow = 8;
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

		@param var shadowMap : Channel;
		@param var shadowMapCube : SamplerCube;
		@const var shadowIsCube : Bool;
		@const var smode : Int;

		function getColor(x:Float,y:Float) : Vec3 {
			var color : Vec3;
			if( y < 3 ) {
				if( x < 1 )
					color = albedo.sqrt();
				else if( x < 2 )
					color = packNormal(normal).rgb;
				else if( x < 3 )
					color = roughness.xxx;
				else
					color = metalness.xxx;
			} else {
				if( x < 1 )
					color = emissive.xxx;
				else if( x < 2 )
					color = depth.xxx;
				else if( x < 3 )
					color = occlusion.xxx;
				else {
					var uv = vec2(x,y) - 3;
					if( shadowIsCube ) {
						var phi = uv.x*3.1415*2;
						var theta = (-uv.y+0.5)*3.1415;
						var dir = vec3(cos(phi)*cos(theta),sin(theta),sin(phi)*cos(theta));
						color = shadowMapCube.get(dir).xxx;
					} else
						color = shadowMap.get(uv).xxx;
				}
			}
			return color;
		}

		function fragment() {
			var color : Vec3;
			var x = input.uv.x * 4;
			var y = input.uv.y * 4;
			if( smode == 0 )
				color = getColor(x,y);
			else
				color = getColor( (smode - 1)%4 + input.uv.x, int((smode - 1) / 4) * 3 + input.uv.y );
			pixelColor = vec4(color, 1.);
		}
	};

	public var mode(get,set) : DebugMode;

	function get_mode() : DebugMode { return cast smode; }
	function set_mode(m:DebugMode) { smode = cast m; return m; }

}
