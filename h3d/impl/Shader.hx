package h3d.impl;

#if flash
typedef Shader = hxsl.Shader;
#else
class Shader implements Dynamic {
	
	#if js
	var program : js.html.webgl.Program;
	var attribs : Array<js.html.webgl.ActiveInfo>;
	var uniforms : Array<js.html.webgl.ActiveInfo>;
	#end
	
	public function new() {
	}
}
#end