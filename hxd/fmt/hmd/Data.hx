package hxd.fmt.hmd;

@:enum abstract GeometryDataFormat(Int) {

	public var DFloat = 1;
	public var DVec2 = 2;
	public var DVec3 = 3;
	public var DVec4 = 4;
	public var DBytes4 = 9;

	inline function new(v) {
		this = v;
	}

	public inline function getSize() {
		return this & 7;
	}

	public inline function toInt() {
		return this;
	}

	public function toString() {
		return switch( new GeometryDataFormat(this) ) {
		case DFloat: "DFloat";
		case DVec2: "DVec2";
		case DVec3: "DVec3";
		case DVec4: "DVec4";
		case DBytes4: "DBytes4";
		}
	}

	public static inline function fromInt( v : Int ) : GeometryDataFormat {
		return new GeometryDataFormat(v);
	}
}

typedef DataPosition = Int;
typedef Index<T> = Int;

enum Property<T> {
	CameraFOVY( v : Float ) : Property<Float>;
}

typedef Properties = Null<Array<Property<Dynamic>>>;

class Position {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var qx : Float;
	public var qy : Float;
	public var qz : Float;
	public var qw(get, never) : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public function new() {
	}

	public inline function loadQuaternion( q : h3d.Quat ) {
		q.x = qx;
		q.y = qy;
		q.z = qz;
		q.w = qw;
	}

	function get_qw() {
		var qw = 1 - (qx * qx + qy * qy + qz * qz);
		return qw < 0 ? -Math.sqrt( -qw) : Math.sqrt(qw);
	}

	public function toMatrix(postScale=false) {
		var m = new h3d.Matrix();
		var q = QTMP;
		loadQuaternion(q);
		q.saveToMatrix(m);
		if( postScale ) {
			m.translate(x, y, z);
			m.scale(sx, sy, sz);
		} else {
			m._11 *= sx; m._12 *= sx; m._13 *= sx;
			m._21 *= sy; m._22 *= sy; m._23 *= sy;
			m._31 *= sz; m._32 *= sz; m._33 *= sz;
			m.translate(x, y, z);
		}
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
	public var props : Properties;
	public var vertexCount : Int;
	public var vertexStride : Int;
	public var vertexFormat : Array<GeometryFormat>;
	public var vertexPosition : DataPosition;
	public var indexCount(get, never) : Int;
	public var indexCounts : Array<Int>;
	public var indexPosition : DataPosition;
	public var bounds : h3d.col.Bounds;
	public function new() {
	}
	function get_indexCount() {
		var k = 0;
		for( i in indexCounts ) k += i;
		return k;
	}
}

class Material {
	public var name : String;
	public var props : Properties;
	public var diffuseTexture : Null<String>;
	public var blendMode : h3d.mat.BlendMode;
	public var culling : h3d.mat.Data.Face;
	public var killAlpha : Null<Float>;
	public function new() {
	}
}

class SkinJoint {
	public var name : String;
	public var props : Properties;
	public var parent : Index<SkinJoint>;
	public var position : Position;
	public var bind : Int;
	public var transpos : Null<Position>;
	public function new() {
	}
}

class SkinSplit {
	public var materialIndex : Int;
	public var joints : Array<Index<SkinJoint>>;
	public function new() {
	}
}

class Skin {
	public var name : String;
	public var props : Properties;
	public var joints : Array<SkinJoint>;
	public var split : Null<Array<SkinSplit>>;
	public function new() {
	}
}

class Model {
	public var name : String;
	public var props : Properties;
	public var parent : Index<Model>;
	public var follow : Null<String>;
	public var position : Position;
	public var geometry : Index<Geometry>;
	public var materials : Null<Array<Index<Material>>>;
	public var skin : Null<Skin>;
	public function new() {
	}
}

enum AnimationFlag {
	HasPosition;
	HasRotation;
	HasScale;
	HasUV;
	HasAlpha;
	SinglePosition;
	HasProps;
	Reserved;
}

class AnimationObject {
	public var name : String;
	public var flags : haxe.EnumFlags<AnimationFlag>;
	public var props : Array<String>;
	public function new() {
	}
}

class AnimationEvent {
	public var frame : Int;
	public var data : String;
	public function new() {
	}
}

class Animation {
	public var name : String;
	public var props : Properties;
	public var frames : Int;
	public var sampling : Float;
	public var speed : Float;
	public var loop : Bool;
	public var objects : Array<AnimationObject>;
	public var events : Null<Array<AnimationEvent>>;
	public var dataPosition : DataPosition;
	public function new() {
	}
}

class Data {

	public static inline var CURRENT_VERSION = 2;

	public var version : Int;
	public var props : Properties;
	public var geometries : Array<Geometry>;
	public var materials : Array<Material>;
	public var models : Array<Model>;
	public var animations : Array<Animation>;
	public var dataPosition : Int;
	public var data : haxe.io.Bytes;

	public function new() {
	}

}
