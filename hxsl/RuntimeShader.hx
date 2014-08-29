package hxsl;

class AllocParam {
	public var name : String;
	public var pos : Int;
	public var instance : Int;
	public var index : Int;
	public var type : Ast.Type;
	public var perObjectGlobal : AllocGlobal;
	public function new(name, pos, instance, index, type) {
		this.name = name;
		this.pos = pos;
		this.instance = instance;
		this.index = index;
		this.type = type;
	}
}

class AllocGlobal {
	public var pos : Int;
	public var gid : Int;
	public var path : String;
	public var type : Ast.Type;
	public function new(pos, path, type) {
		this.pos = pos;
		this.path = path;
		this.gid = Globals.allocID(path);
		this.type = type;
	}
}

class RuntimeShaderData {
	public var vertex : Bool;
	public var data : Ast.ShaderData;
	public var params : Array<AllocParam>;
	public var paramsSize : Int;
	public var globals : Array<AllocGlobal>;
	public var globalsSize : Int;
	public var textures : Array<AllocParam>;
	public var consts : Array<Float>;
	public function new() {
	}
}

class RuntimeShader {

	static var UID = 0;
	public var id : Int;
	public var vertex : RuntimeShaderData;
	public var fragment : RuntimeShaderData;
	public var globals : Map<Int,Bool>;

	public function new() {
		id = UID++;
	}

	public inline function hasGlobal( gid : Int ) {
		return globals.exists(gid);
	}


}
