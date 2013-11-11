package hxsl;
using hxsl.Ast;

class Linker {

	public function new() {
	}
	
	public function link( shaders : Array<ShaderData>, startFun : String, outVar : String ) {
		for( s in shaders )
			for( v in s.vars )
				trace(v.name);
		return shaders[0];
	}
	
}