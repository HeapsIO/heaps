package h3d.dae;

using h3d.dae.Tools;

class Mesh {
	public var name(default,null) : String;
	public var root : DAE;
	public var controller : DAE;
	
	public function new( n : DAE ) {
		root = n;
		name = n.attr("name").toString();
	}
	
}