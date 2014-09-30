package h3d.shader;

class ZCut extends hxsl.Shader {

	static var SRC = {
		@:import h3d.shader.BaseMesh;

		@param var zMin : Float;
		@param var zMax : Float;

		function vertex() {
			var z = projectedPosition.z / projectedPosition.w;
			z -= min(z - zMin, 0.) * 1e8;
			z += min(zMax - z, 0.) * 1e8;
			projectedPosition.z = z * projectedPosition.w;
			pixelColor.rgb = z.xxx;
		}

	};

	public function new(zMin = 0., zMax = 1.) {
		super();
		this.zMin = zMin;
		this.zMax = zMax;
	}

}