package h3d.mat;
import h3d.mat.Data;
import h3d.mat.Pass;

class Material {
	
	var passes : Pass;
	public var mainPass(get, never) : Pass;
	
	public function new(passes) {
		this.passes = passes;
	}
	
	public function addPass<T:Pass>( p : T ) : T {
		var prev = null, cur = passes;
		while( cur != null ) {
			prev = cur;
			cur = cur.nextPass;
		}
		if( prev == null )
			passes = p;
		else
			prev.nextPass = p;
		p.nextPass = null;
		return p;
	}
	
	public function removePass( p : Pass ) {
		var prev : Pass = null, cur = passes;
		while( cur != null ) {
			if( cur == p ) {
				if( prev == null )
					passes = p.nextPass;
				else
					prev.nextPass = p.nextPass;
				p.nextPass = null;
				return true;
			}
			prev = cur;
			cur = cur.nextPass;
		}
		return false;
	}
	
	inline function get_mainPass() {
		return passes;
	}
	
	public function getPass< T:(Pass, { function new(?parent:Pass) : Void; }) >( name : String, c : Class<T> ) : T {
		var p = passes;
		while( p != null ) {
			if( p.name == name )
				return cast p;
			p = p.nextPass;
		}
		var p = Type.createInstance(c, [passes]);
		addPass(p);
		return p;
	}
	
	public function clone() {
		throw "TODO";
	}

}