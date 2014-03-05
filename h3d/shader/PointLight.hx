package h3d.shader;

class PointLight extends hxsl.Shader {

	static var SRC = {
		
		var pixelColor : Vec4;
		var transformedPosition : Vec3;
		var transformedNormal : Vec3;
		@param var color : Vec3;
		@param var params : Vec3;
		@param var lightPosition : Vec3;
		
		function fragment() {
			var dvec = transformedPosition - lightPosition;
			var dist2 = dvec.dot(dvec);
			var dist = dist2.sqrt();
			pixelColor.rgb += color * (transformedNormal.dot(dvec).max(0.) / vec3(dist,dist2,dist*dist2).dot(params));
		}
		
	};
	
	public function new() {
		super();
		color.set(1, 1, 1);
		params.set(0, 1, 0);
	}
	
}