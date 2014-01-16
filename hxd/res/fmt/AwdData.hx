package hxd.res.fmt;

class Block {
	public var id : Int;
	public var attributes : Null<Map<String,Dynamic>>;
	public var name : Null<String>;
	
	public function new(id) {
		this.id = id;
	}

	public inline function to<T:Block>( k : Class<T> ) : T {
		return Std.instance(this, k);
	}
	
	function toString() {
		return Type.getClass(this) + "#" + id + (name == null ? "" : "(" + name + ")");
	}
}

class SceneElement extends Block {
	public var parent : SceneElement;
	public var transform : h3d.Matrix;
}

class Instance extends SceneElement {
	public var geometry : TriangleGeometry;
	public var materials : Array<SimpleMaterial>;
}

class Joint extends Block {
	public var parent : Joint;
	public var bindPos : h3d.Matrix;
}

class Skeleton extends Block {
	public var joints : Map<Int,Joint>;
	public function new(id) {
		super(id);
		joints = new Map();
	}
}

class BitmapTexture extends Block {
	public var data : haxe.io.Bytes;
	public var url : String;
}

class SimpleMaterial extends Block {
	public var color : Int;
	public var texture : BitmapTexture;
	public function new(id) {
		super(id);
		color = 0xFFFFFFFF;
	}
}

class TriangleGeometry extends Block {
	public var subMeshes : Array<SubMesh>;
}

class SubMesh {
	public var vertexData : haxe.io.Bytes;
	public var indexes : haxe.io.Bytes;
	public var uvs : haxe.io.Bytes;
	public function new() {
	}
}

