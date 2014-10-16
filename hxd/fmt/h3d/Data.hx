package hxd.fmt.h3d;

enum GeometryDataFormat {
	DFloat;
	DVec2;
	DVec3;
	DVec4;
	DBytes4;
}

typedef DataPosition = Int;
typedef Index<T> = Int;

class Position {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var qx : Float;
	public var qy : Float;
	public var qz : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public function new() {
	}

	public function loadQuaternion( q : h3d.Quat ) {
		var qw = 1 - (qx * qx + qy * qy + qz * qz);
		q.x = qx;
		q.y = qy;
		q.z = qz;
		q.w = qw < 0 ? -Math.sqrt( -qw) : Math.sqrt(qw);
	}

	public function toMatrix() {
		var m = new h3d.Matrix();
		var q = QTMP;
		loadQuaternion(q);
		q.saveToMatrix(m);
		// prepend scale
		m._11 *= sx; m._12 *= sx; m._13 *= sx;
		m._21 *= sy; m._22 *= sy; m._23 *= sy;
		m._31 *= sz; m._32 *= sz; m._33 *= sz;
		m.translate(x, y, z);
		return m;
	}
	static var QTMP = new h3d.Quat();
}

class GeometryFormat {
	public var name : String;
	public var format : GeometryDataFormat;
	public function new(name, format) {
		this.name = name;
		this.format = format;
	}
}

class Geometry {
	public var vertexCount : Int;
	public var vertexStride : Int;
	public var vertexFormat : Array<GeometryFormat>;
	public var vertexPosition : DataPosition;
	public var indexCount : Int;
	public var indexPosition : DataPosition;
	public function new() {
	}
}

class Material {
	public var name : String;
	public var diffuseTexture : Null<String>;
	public var blendMode : h3d.mat.BlendMode;
	public var culling : h3d.mat.Data.Face;
	public var killAlpha : Null<Float>;
	public function new() {
	}
}

class Model {
	public var name : String;
	public var parent : Index<Model>;
	public var position : Position;
	public var geometries : Null<Array<Index<Geometry>>>;
	public var materials : Null<Array<Index<Material>>>;
	public function new() {
	}
}

enum AnimationFlag {
	HasPosition;
	HasRotation;
	HasScale;
	HasUV;
	HasAlpha;
}

class AnimationObject {
	public var name : String;
	public var flags : haxe.EnumFlags<AnimationFlag>;
	public function new() {
	}
}

class Animation {
	public var name : String;
	public var frames : Int;
	public var sampling : Float;
	public var speed : Float;
	public var loop : Bool;
	public var objects : Array<AnimationObject>;
	public var dataPosition : Int;
	public function new() {
	}
}

class Data {

	public var version : Int;
	public var geometries : Array<Geometry>;
	public var materials : Array<Material>;
	public var models : Array<Model>;
	public var animations : Array<Animation>;
	public var dataPosition : Int;
	public var data : haxe.io.Bytes;

	public function new() {
	}

}
