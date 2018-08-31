package hxsl;
using hxsl.Ast;

@:autoBuild(hxsl.Macros.buildShader())
class Shader {

	public var priority(default,null) : Int = 0;
	var shader : SharedShader;
	var instance : SharedShader.ShaderInstance;
	var constBits : Int;
	var constModified : Bool;

	public function new() {
		initialize();
	}

	function initialize() {
		constModified = true;
		if( shader != null )
			return;
		var cl : Dynamic = std.Type.getClass(this);
		shader = cl._SHADER;
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

	/**
		Shader priority should only be changed *before* the shader is added to a material.
	**/
	public function setPriority(v) {
		priority = v;
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
			case TChannel(count):
				if( v == null ) {
					c = c.next;
					continue;
				}
				var v : hxsl.ChannelTexture = v;
				var sel = v.channel;
				if( v.texture == null )
					sel = Unknown
				else if( sel == null || sel == Unknown ) {
					switch( count ) {
					case 1 if( hxsl.Types.ChannelTools.isPackedFormat(v.texture) ): sel = PackedFloat;
					case 3 if( hxsl.Types.ChannelTools.isPackedFormat(v.texture) ): sel = PackedNormal;
					default:
						throw "Constant " + c.v.name+" does not define channel select value";
					}
				}
				constBits |= ((globals.allocChannelID(v.texture) << 3) | sel.getIndex()) << c.pos;
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

	public function toString() {
		return std.Type.getClassName(std.Type.getClass(this));
	}

}