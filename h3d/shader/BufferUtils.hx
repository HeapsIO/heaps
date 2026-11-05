package h3d.shader;

class BufferUtils extends hxsl.Shader {
	static var SRC = {
		function getMat4( b : StorageBuffer<Vec4>, pos : Int ) : Mat4 {
			return mat4(b[pos], b[pos + 1], b[pos + 2], b[pos + 3]);
		}

		function readMat4( b : RWBuffer<Vec4>, pos : Int ) : Mat4 {
			return mat4(b[pos], b[pos + 1], b[pos + 2], b[pos + 3]);
		}

		function writeMat4( b : RWBuffer<Vec4>, pos : Int, m : Mat4 ) {
			b[pos] = m[0];
			b[pos + 1] = m[1];
			b[pos + 2] = m[2];
			b[pos + 3] = m[3];
		}
	}
}
