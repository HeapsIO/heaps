package h2d.uikit;

class InvalidProperty {
	public var message : String;
	public function new(?msg) {
		this.message = msg;
	}
}

class Property {
	public var name(default,null) : String;
	public var id(default,null) : Int;
	@:allow(h2d.uikit.CssStyle) var tag : Int = 0;

	function new(name) {
		this.id = ALL.length;
		this.name = name;
		ALL.push(this);
		MAP.set(name, this);
	}

	public static function get( name : String, create = true ) {
		if( MAP == null ) {
			MAP = new Map();
			ALL = [];
		}
		var p = MAP.get(name);
		if( p == null && create )
			p = new Property(name);
		return p;
	}

	@:persistent static var ALL : Array<Property>;
	@:persistent static var MAP : Map<String, Property>;

}