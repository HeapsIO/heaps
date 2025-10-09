package hxd;

class FloatBufferLoader {
	public var buf(default, null) : FloatBuffer;
	public var pos : Int;

	public inline function new(b : FloatBuffer, p : Int){
		buf = b;
		pos = p;
	}

	public inline function loadMatrix(m:h3d.Matrix) {
		buf[pos++] = m._11;
		buf[pos++] = m._21;
		buf[pos++] = m._31;
		buf[pos++] = m._41;
		buf[pos++] = m._12;
		buf[pos++] = m._22;
		buf[pos++] = m._32;
		buf[pos++] = m._42;
		buf[pos++] = m._13;
		buf[pos++] = m._23;
		buf[pos++] = m._33;
		buf[pos++] = m._43;
		buf[pos++] = m._14;
		buf[pos++] = m._24;
		buf[pos++] = m._34;
		buf[pos++] = m._44;
	}

	public inline function loadFloat(v : Float) {
		buf[pos++] = v;
	}

	public inline function loadVec2(v : h3d.Vector) {
		buf[pos++] = v.x;
		buf[pos++] = v.y;
	}

	public inline function loadVec3(v : h3d.Vector) {
		buf[pos++] = v.x;
		buf[pos++] = v.y;
		buf[pos++] = v.z;
	}

	public inline function loadVec4(v : h3d.Vector4) {
		buf[pos++] = v.x;
		buf[pos++] = v.y;
		buf[pos++] = v.z;
		buf[pos++] = v.w;
	}
}