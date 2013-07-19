package h3d.impl;

#if flash
typedef Shader = hxsl.Shader;
#else
class Shader implements Dynamic {
	public function new() {
	}
}
#end