package hxd.prefab;

@:final class Context {

	public var local2d : h2d.Sprite;
	public var local3d : h3d.scene.Object;
	public var shared : ContextShared;
	public var custom : Dynamic;
	public var isRef : Bool = false;

	public function new() {
	}

	public function init() {
		if( shared == null )
			shared = new ContextShared();
		local2d = shared.root2d;
		local3d = shared.root3d;
	}

	public function clone( p : Prefab ) {
		var c = new Context();
		c.shared = shared;
		c.local2d = local2d;
		c.local3d = local3d;
		c.custom = custom;
		c.isRef = isRef;
		if( p != null ) {
			if(!isRef)
				shared.contexts.set(p, c);
			else {
				if(!shared.references.exists(p))
					shared.references.set(p, [c])
				else
					shared.references[p].push(c);
			}
		}
		return c;
	}

	public dynamic function onError( e : Dynamic ) {
		#if editor
		js.Browser.window.alert(e);
		#else
		throw e;
		#end
	}

	public function loadModel( path : String ) {
		return shared.loadModel(path);
	}

	public function loadAnimation( path : String ) {
		return shared.loadAnimation(path);
	}

	public function loadTexture( path : String ) {
		return shared.loadTexture(path);
	}

	public function loadShader( name : String ) {
		return shared.loadShader(name);
	}

	public function locateObject( path : String ) {
		if( path == null )
			return null;
		var parts = path.split(".");
		var root = shared.root3d;
		while( parts.length > 0 ) {
			var v = null;
			var pname = parts.shift();
			for( o in root )
				if( o.name == pname ) {
					v = o;
					break;
				}
			if( v == null ) {
				v = root.getObjectByName(pname);
				if( v != null && v.parent != root ) v = null;
			}
			if( v == null ) {
				var parts2 = path.split(".");
				for( i in 0...parts.length ) parts2.pop();
				onError("Object not found " + parts2.join("."));
				return null;
			}
			root = v;
		}
		return root;
	}

}
