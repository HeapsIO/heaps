package h3d.shader;

class Shadow extends hxsl.Shader {

	static var SRC = {
		@global var shadow : {
			map : Sampler2D,
			proj : Mat3x4,
			color : Vec3,
			power : Float,
		};
		var pixelColor : Vec4;
		var transformedPosition : Vec3;
		@private var shadowPos : Vec3;
		
		function vertex() {
			shadowPos = transformedPosition * shadow.proj * vec3(0.5, -0.5, 0.999) + vec3(0.5, 0.5, 0);
		}
		
		function fragment() {
			var shade = exp( shadow.power * (shadowPos.z - shadow.map.get(shadowPos.xy).dot(vec4(1.,1. / 255., 1. / (255. * 255.), 1. / (255. * 255. * 255.))))).saturate();
			pixelColor.rgb *= (1. - shade) * shadow.color.rgb + shade;
		}
	};
	
	public function new() {
		super();
	}
	
}