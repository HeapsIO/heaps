package hxd.prefab;

class Library extends Prefab {

	var inRec = false;

	public function new() {
		super(null);
		type = "prefab";
	}

	// hacks to use directly non-recursive api

	override function load( obj : Dynamic ) {
		if( inRec )
			return;
		var children : Array<Dynamic> = obj.children;
		if( children != null )
			for( v in children )
				Prefab.loadRec(v, this);
	}

	override function reload(v:Dynamic) {
		inRec = true;
		super.reload(v);
		inRec = false;
	}

	override function save() {
		if( inRec )
			return {};
		inRec = true;
		var obj = saveRec();
		inRec = false;
		return obj;
	}

	override function makeInstance(ctx:Context):Context {
		if( inRec )
			return ctx;
		inRec = true;
		makeInstanceRec(ctx);
		inRec = false;
		return ctx;
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
		var type = registeredExtensions.get(extension);
		var p : hxd.prefab.Prefab;
		if( type == null )
			p = new Library();
		else
			p = Type.createInstance(registeredElements.get(type).cl,[]);
		return p;
	}

}