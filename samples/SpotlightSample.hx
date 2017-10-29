class SpotlightShader extends hxsl.Shader {
	static var SRC = {
		@param var lightPosition:Vec3;      // position of the light in world coordinates
		@param var lightConeDirection:Vec3; // direction the light is facing
		@param var lightConeAngle:Float;    // angle ("width") of the spotlight
		@param var lightColor:Vec3;         // color of the light

		var transformedNormal:Vec3;         // normal vector at pixel
		var pixelTransformedPosition:Vec3;  // position of pixel in world coordinates
		var lightPixelColor:Vec3;           // output pixel color

		function calculate():Vec3 {
			// Calculate vector between light and pixel. This vector points from the pixel to the light.
			var surfaceToLight = lightPosition - pixelTransformedPosition;
			// Determine length of that vector.
			var distanceToLight = length(surfaceToLight);
			// Normalize the vector.
			surfaceToLight = normalize(surfaceToLight);
			// Calculate the angle between inverse surfaceToLight vector (= pointing from light to the pixel)
			// and the light cone angle vector.
			var lightToSurfaceAngle = acos(dot(-surfaceToLight, normalize(lightConeDirection)));
			var attenuation:Float;
			// If the calculated angle is larger than the light cone angle, the pixel is not affected by the
			// spotlight. Set the attenuation to 0 accordingly.
			// In the following diagram, L is the light source, P is the current pixel and a is the angle
			// between the two vectors.
			//                         P
			//                    |   /
			// lightConeDirection |  / lightToSurface
			//                    |a/
			//                    |/
			//                    L
			if (lightToSurfaceAngle > lightConeAngle) {
				attenuation = 0.0;
			} else {
				attenuation = (1.0 + pow(distanceToLight, 2.0));
			}
			// Calculate diffuse normally: Determine angle between the normal vector and the surfaceToLight
			// vector (= pointing from pixel to the light).
			var diffuseCoefficient = max(0.0, dot(transformedNormal, surfaceToLight));
			var diffuse = diffuseCoefficient * lightColor;
			// Use attenuation as a factor to ignore diffuse value for pixels outside the cone.
			return attenuation * diffuse;
		}

		function fragment() {
			lightPixelColor += calculate();
		}
	};

	public function new() {
		super();
		lightColor.set(1, 1, 1);
	}
}

/**
	Spotlight is essentially the Haxe interface to the SpotlightShader. Its fields are properties that
	read from and write to the shader instance itself.
**/
class Spotlight extends h3d.scene.Light {
	var pshader:SpotlightShader;
	public var coneDirection(get, set):h3d.Vector;
	public var coneAngle(get, set):Float;

	public function new(coneDirection:h3d.Vector, coneAngle:Float, parent:h3d.scene.Object) {
		pshader = new SpotlightShader();
		this.coneDirection = coneDirection;
		this.coneAngle = coneAngle;
		super(pshader, parent);
	}

	inline function get_coneDirection() return pshader.lightConeDirection;
	inline function set_coneDirection(value) return pshader.lightConeDirection = value;
	inline function get_coneAngle() return pshader.lightConeAngle;
	inline function set_coneAngle(value) return pshader.lightConeAngle = value;
	override function get_color() return pshader.lightColor;

	override function emit(ctx) {
		// Tell the shader where our light is currently at.
		pshader.lightPosition.set(absPos._41, absPos._42, absPos._43);
		super.emit(ctx);
	}
}

class SpotlightSample extends SampleApp {
	function makeLight(x:Float, y:Float, z:Float, color:Int, direction:h3d.Vector, angle:Float) {
		// Create Spotlight instance and set initial parameters.
		var light = new Spotlight(direction, angle, s3d);
		light.color.setColor(color);
		light.setPos(x, y, z);

		// This is just a helper sphere to visualize where our light is coming from.
		var sphere = new h3d.prim.GeoSphere(4);
		var mesh = new h3d.scene.Mesh(sphere, light);
		mesh.scale(0.03);
		mesh.material.color.setColor(0xFF000000 | color);

		return light;
	}

	override function init() {
		super.init();

		// Build a wall
		var prim = new h3d.prim.Cube(5, 5, 0.1);
		prim.unindex();
		prim.translate(-2.5, -2.5, -0.01);
		prim.addNormals();
		var mesh = new h3d.scene.Mesh(prim, s3d);
		mesh.material.mainPass.enableLights = true;

		// Create the light
		var light = makeLight(0, 0, -1.5, 0xFF0000, new h3d.Vector(0, 0, 1), Math.PI / 18);

		// Add some UI
		addSlider("Direction X", () -> light.coneDirection.x, v -> light.coneDirection.x = v, -1, 1);
		addSlider("Direction Y", () -> light.coneDirection.y, v -> light.coneDirection.y = v, -1, 1);
		addSlider("Direction Z", () -> light.coneDirection.z, v -> light.coneDirection.z = v, 0.5, 1);
		addSlider("Angle", () -> light.coneAngle, v -> light.coneAngle = v, 0, Math.PI / 2);

		// Setup camera
		s3d.camera.up.set(0, 1, 0);
		s3d.camera.target.set(0, 0, 0);
		s3d.camera.pos.set(5, 5, -10);
		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	static function main() {
		new SpotlightSample();
	}
}