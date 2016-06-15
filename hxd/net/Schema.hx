package hxd.net;

typedef FieldType = Macros.PropTypeDesc<FieldType>;

class Schema #if !macro implements Serializable #end {

	@:s @:notMutable public var fieldsNames : Array<String>;
	@:s @:notMutable public var fieldsTypes : Array<FieldType>;

	public function new() {
		fieldsNames = [];
		fieldsTypes = [];
	}

}