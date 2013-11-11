package hxsl;
using hxsl.Ast;

@:autoBuild(hxsl.Macros.buildShader())
class Shader {
	
	var shader : Ast.ShaderData;
	
	public function new() {
		var cl : Dynamic = std.Type.getClass(this);
		shader = cl.SHADER;
		if( shader == null ) {
			shader = haxe.Unserializer.run(cl.SRC);
			cl.SHADER = shader;
		}
	}
	
	function initConst( v : Ast.TVar, e : hxsl.Eval ) {
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				initConst(v, e);
		default:
			if( v.hasQualifier(Const) ) {
				var value = switch( v.type ) {
				case TBool: CBool(false);
				case TInt: CInt(0);
				default: throw "Unsupported const " + v.type.toString();
				};
				e.setConstant(v, value);
			}
		}
	}
	
	public function compile() {
		var e = new hxsl.Eval();
		for( v in shader.vars )
			initConst(v, e);
		return e.eval(shader);
	}
	
	public function setup( globals : Globals ) {
	}
	
}