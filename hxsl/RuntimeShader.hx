package hxsl;

class AllocParam {
	public var name : String;
	public var pos : Int;
	public var instance : Int;
	public var index : Int;
	public var type : Ast.Type;
	public var perObjectGlobal : AllocGlobal;
	public var next : AllocParam;
	public function new(name, pos, instance, index, type) {
		this.name = name;
		this.pos = pos;
		this.instance = instance;
		this.index = index;
		this.type = type;
	}
	public function clone( resetGID = false ) {
		var p = new AllocParam(name,pos,instance,index,type);
		if( perObjectGlobal != null ) p.perObjectGlobal = perObjectGlobal.clone(resetGID);
		if( next != null ) p.next = next.clone(resetGID);
		return p;
	}
}

class AllocGlobal {
	public var pos : Int;
	public var gid : Int;
	public var path : String;
	public var type : Ast.Type;
	public var next : AllocGlobal;
	public function new(pos, path, type) {
		this.pos = pos;
		this.path = path;
		this.gid = Globals.allocID(path);
		this.type = type;
	}
	public function clone( resetGID = false ) {
		var g = new AllocGlobal(pos, path, type);
		if( next != null ) g.next = next.clone(resetGID);
		if( resetGID ) g.gid = 0;
		return g;
	}
}

class RuntimeShaderData {
	public var vertex : Bool;
	public var data : Ast.ShaderData;
	public var code : String;
	public var params : AllocParam;
	public var paramsSize : Int;
	public var globals : AllocGlobal;
	public var globalsSize : Int;
	public var textures : AllocParam;
	public var texturesCount : Int;
	public var buffers : AllocParam;
	public var bufferCount : Int;
	public var consts : Array<Float>;
	public function new() {
	}
}

class ShaderInstanceDesc {
	public var shader : SharedShader;
	public var bits : Int;
	public var index : Int;
	public function new(shader, bits) {
		this.shader = shader;
		this.bits = bits;
	}
}

class RuntimeShader {

	static var UID = 0;
	public var id : Int;
	public var vertex : RuntimeShaderData;
	public var fragment : RuntimeShaderData;
	public var globals : Map<Int,Bool>;

	/**
		Signature of the resulting HxSL code.
		Several shaders with the different specification might still get the same resulting signature.
	**/
	public var signature : String;
	public var batchMode : Bool;
	public var spec : { instances : Array<ShaderInstanceDesc>, signature : String };

	public function new() {
		id = UID++;
	}

	public inline function hasGlobal( gid : Int ) {
		return globals.exists(gid);
	}


}
