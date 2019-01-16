package h2d.uikit;

class InvalidProperty {
	public var message : String;
	public function new(?msg) {
		this.message = msg;
	}
}

class Property<T> {
	public var name(default,null) : String;
	public var id(default,null) : Int;
	public var defaultValue(default,null) : T;
	public var parser(default,null) : CssParser.Value -> Dynamic;
	var tag : Int = 0;

	public function new(name,parser,def) {
		if( MAP.exists(name) )
			throw "Duplicate property "+name;
		this.id = ALL.length;
		this.name = name;
		this.defaultValue = def;
		this.parser = parser;
		ALL.push(this);
		MAP.set(name, this);
	}

	public static function get( name : String ) {
		return MAP.get(name);
	}
	static var ALL = new Array<Property<Dynamic>>();
	static var MAP = new Map<String, Property<Dynamic>>();

}

class PValue<T> {
	public var p : Property<T>;
	public var v : T;
	public function new(p,v) {
		this.p = p;
		this.v = v;
	}
}
