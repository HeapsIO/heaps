package h3d.mat;
import h3d.mat.Data;
import h3d.mat.Pass;

class BaseMaterial {

	var passes : Pass;
	public var name : String;
	public var mainPass(get, never) : Pass;

	public var props(default,set) : MaterialProps;

	public function new(?shader:hxsl.Shader) {
		if( shader != null )
			addPass(new Pass("default",null)).addShader(shader);
	}

	function set_props(p) {
		this.props = p;
		if( p != null ) p.apply(this);
		return p;
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

	public function getPasses() {
		var p = passes;
		var out = [];
		while( p != null ) {
			out.push(p);
			p = p.nextPass;
		}
		return out.iterator();
	}

	public function getPass( name : String ) : Pass {
		var p = passes;
		while( p != null ) {
			if( p.name == name )
				return p;
			p = p.nextPass;
		}
		return null;
	}

	public function allocPass( name : String, ?inheritMain = true ) : Pass {
		var p = getPass(name);
		if( p != null ) return p;
		var p = new Pass(name, null, inheritMain ? mainPass : null);
		addPass(p);
		return p;
	}

	public function clone( ?m : BaseMaterial ) : BaseMaterial {
		if( m == null ) m = new BaseMaterial();
		m.mainPass.loadProps(mainPass);
		// DO NOT clone passes (it's up to the superclass to recreate the passes + shaders)
		m.name = name;
		return m;
	}

}