package h3d;

typedef FixedArray<T,Const> = Array<T>;

typedef ShaderInfos = {
	var stride : Int;
	var format : Int;
	var vertex : Array<Float>;
	var fragment : Array<Float>;
	var textures : Int;
}

class ShaderData {
	
	public var program : flash.display3D.Program3D;
	public var stride(default, null) : Int;
	public var bufferFormat(default, null) : Int;
	
	public var vertexVarsChanged : Bool;
	public var fragmentVarsChanged : Bool;
	public var texturesChanged : Bool;
	public var vertexVars : flash.Vector<Float>;
	public var fragmentVars : flash.Vector<Float>;
	public var textures : flash.Vector<flash.display3D.textures.TextureBase>;
	
	public function new( infos : ShaderInfos ) {
		this.stride = infos.stride;
		this.bufferFormat = infos.format;
		this.vertexVars = flash.Vector.ofArray(infos.vertex);
		this.fragmentVars = flash.Vector.ofArray(infos.fragment);
		this.textures = new flash.Vector(infos.textures);
	}
	
}

@:autoBuild(h3d.impl.Macros.buildShader())
class Shader {
	
	var data : ShaderData;
	
	public function new() {
		data = new ShaderData(getShaderInfos());
	}
	
	public inline function getData() {
		return data;
	}
	
	public function getShaderInfos() : ShaderInfos {
		throw "assert";
		return null;
	}
	
	public function getVertexProgram() : haxe.io.Bytes {
		throw "assert";
		return null;
	}

	public function getFragmentProgram() : haxe.io.Bytes {
		throw "assert";
		return null;
	}
	
	public function toString() {
		return Type.getClassName(Type.getClass(this));
	}
	
}