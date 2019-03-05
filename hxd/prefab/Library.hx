package hxd.prefab;

class Library extends Prefab {

	public function new() {
		super(null);
		type = "prefab";
	}

	override function load( obj : Dynamic ) {
	}

	override function save() {
		return {};
	}

	/**
		Returns the prefab within children that matches the given absolute path
	**/
	public function getFromPath( path : String ) : Prefab {
		var parts = path.split(".");
		var cur : Prefab = this;
		for( p in parts ) {
			var found = false;
			for( c in cur.children )
				if( c.name == p ) {
					found = true;
					cur = c;
					break;
				}
			if( !found ) return null;
		}
		return cur;
	}

	static var registeredElements = new Map<String,{ cl : Class<Prefab> #if editor, inf : hide.prefab.HideProps #end }>();
	static var registeredExtensions = new Map<String,String>();

	public static function getRegistered() {
		return registeredElements;
	}

	public static function isOfType( prefabKind : String, cl : Class<Prefab> ) {
		var inf = registeredElements.get(prefabKind);
		if( inf == null ) return false;
		var c : Class<Dynamic> = inf.cl;
		while( c != null ) {
			if( c == cl ) return true;
			c = Type.getSuperClass(c);
		}
		return false;
	}

	public static function register( type : String, cl : Class<Prefab>, ?extension : String ) {
		registeredElements.set(type, { cl : cl #if editor, inf : Type.createEmptyInstance(cl).getHideProps() #end });
		if( extension != null ) registeredExtensions.set(extension, type);
		return true;
	}

	public static function create( extension : String ) {
		var type = getPrefabType(extension);
		var p : hxd.prefab.Prefab;
		if( type == null )
			p = new Library();
		else
			p = Type.createInstance(registeredElements.get(type).cl,[]);
		return p;
	}

	public static function getPrefabType(path: String) {
		var extension = path.split(".").pop().toLowerCase();
		return registeredExtensions.get(extension);
	}

	static var _ = hxd.prefab.Library.register("prefab", Library, "prefab");

}