package h3d.shader;

class Blendshape extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var relativePosition : Vec3;

		@param var shapeCount : Int;
		@param var vcount : Int;
		@param var offsets : StorageBuffer<Float>;
		@param var weights : StorageBuffer<Float>;

		function vertex() {
			for (idx in 0...shapeCount) {
				var offsetPos = vec3(offsets[(idx * vcount * 3) + (vertexID * 3)], offsets[(idx * vcount * 3) + (vertexID * 3) + 1], offsets[(idx * vcount * 3) + (vertexID * 3) + 2]);
				relativePosition = relativePosition + offsetPos * weights[idx];
			}
		}
	};
}