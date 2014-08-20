package h3d.mat;
import h3d.mat.Data;
import h3d.mat.Pass;

class Material {

	var passes : Pass;
	public var mainPass(get, never) : Pass;
	public var shadows(get, set) : Bool;
	public var castShadows(default, set) : Bool;
	public var receiveShadows(default, set) : Bool;

	public function new(?shader:hxsl.Shader) {
		if( shader != null )
			addPass(new Pass("default",null)).addShader(shader);
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

	public function getPass( name : String ) : Pass {
		var p = passes;
		while( p != null ) {
			if( p.name == name )
				return p;
			p = p.nextPass;
		}
		return null;
	}

	public function allocPass< T:(Pass, { function new(?parent:Pass) : Void; }) >( name : String, ?c : Class<T> ) : T {
		var p = getPass(name);
		if( p != null ) return cast p;
		if( c == null ) return null;
		var p = Type.createInstance(c, [passes]);
		addPass(p);
		return p;
	}

	public function clone( ?m : Material ) : Material {
		if( m == null ) m = new Material();
		#if debug
		if( Type.getClass(m) != Type.getClass(this) ) throw this + " is missing clone()";
		#end
		var p = passes;
		while( p != null ) {
			m.addPass(p.clone());
			p = p.nextPass;
		}
		m.castShadows = castShadows;
		m.receiveShadows = receiveShadows;
		return m;
	}

	inline function get_shadows() {
		return castShadows && receiveShadows;
	}

	inline function set_shadows(v) {
		castShadows = v;
		receiveShadows = v;
		return v;
	}

	function set_castShadows(v) {
		if( castShadows == v )
			return v;
		if( v )
			addPass(new Pass("shadow", null, mainPass));
		else
			removePass(getPass("shadow"));
		return castShadows = v;
	}

	function set_receiveShadows(v) {
		if( v == receiveShadows )
			return v;
		var shadows = h3d.pass.Params.shadowShader;
		if( v )
			mainPass.addShader(shadows);
		else
			mainPass.removeShader(shadows);
		return receiveShadows = v;
	}

}