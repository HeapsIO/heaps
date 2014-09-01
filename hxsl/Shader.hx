package hxsl;
using hxsl.Ast;

@:autoBuild(hxsl.Macros.buildShader())
class Shader {

	public var priority : Int = 0;
	var shader : SharedShader;
	var instance : SharedShader.ShaderInstance;
	var constBits : Int;
	var constModified : Bool;

	public function new() {
		var cl : Dynamic = std.Type.getClass(this);
		shader = cl.SHADER;
		constModified = true;
		if( shader == null ) {
			shader = new SharedShader(cl.SRC);
			cl.SHADER = shader;
		}
	}

	public function getParamValue( index : Int ) : Dynamic {
		throw "assert"; // will be subclassed in sub shaders
		return null;
	}

	public function updateConstants( globals : Globals ) {
		throw "assert";
	}

	function updateConstantsFinal( globals : Globals ) {
		for( c in shader.consts )
			if( c.globalId > 0 ) {
				var v : Dynamic = globals.fastGet(c.globalId);
				switch( c.v.type ) {
				case TInt:
					var v : Int = v;
					if( v >>> c.bits != 0 ) throw "Constant " + c.v.name + " is outside range (" + v + " > " + ((1 << c.bits) - 1) + ")";
					constBits |= v << c.pos;
				case TBool:
					var v : Bool = v;
					if( v ) constBits |= 1 << c.pos;
				default:
					throw "assert";
				}
			}
		instance = shader.getInstance(constBits);
	}

	public function clone() : Shader {
		return this;
	}

}