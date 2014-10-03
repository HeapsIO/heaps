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
	public var rx : Float;
	public var ry : Float;
	public var rz : Float;
	public var sx : Float;
	public var sy : Float;
	public var sz : Float;
	public function new() {
	}
}

class GeometryFormat {
	public var name : String;
	public var format : GeometryDataFormat;
	public function new() {
	}
}

class Geometry {
	public var vertexPosition : DataPosition;
	public var vertexCount : Int;
	public var vertexStride : Int;
	public var vertexFormat : Array<GeometryFormat>;
	public var indexPosition : DataPosition;
	public var indexCount : Int;
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

class Data {

	public var version : Int;
	public var geometries : Array<Geometry>;
	public var materials : Array<Material>;
	public var models : Array<Model>;
	public var data : haxe.io.Bytes;

	public function new() {
	}

}
