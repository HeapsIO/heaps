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
		shader = cl._SHADER;
		constModified = true;
		if( shader == null ) {
			var curClass : Dynamic = cl;
			while( curClass != null && curClass.SRC == null )
				curClass = std.Type.getSuperClass(curClass);
			if( curClass == null )
				throw std.Type.getClassName(cl) + " has no shader source";
			shader = curClass._SHADER;
			if( shader == null ) {
				shader = new SharedShader(curClass.SRC);
				curClass._SHADER = shader;
			}
		}
	}

	public function getParamValue( index : Int ) : Dynamic {
		throw "assert"; // will be subclassed in sub shaders
		return null;
	}

	public function getParamFloatValue( index : Int ) : Float {
		throw "assert"; // will be subclassed in sub shaders
		return 0.;
	}

	public function updateConstants( globals : Globals ) {
		throw "assert";
	}

	function updateConstantsFinal( globals : Globals ) {
		var c = shader.consts;
		while( c != null ) {
			if( c.globalId == 0 ) {
				c = c.next;
				continue;
			}
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
			c = c.next;
		}
		instance = shader.getInstance(constBits);
	}

	public function clone() : Shader {
		return this;
	}

}