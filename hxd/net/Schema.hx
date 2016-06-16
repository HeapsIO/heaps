package hxd.net;

typedef FieldType = Macros.PropTypeDesc<FieldType>;

#if !macro
class Schema implements Serializable {

	public var checkSum(get,never) : Int;
	@:s @:notMutable public var fieldsNames : Array<String>;
	@:s @:notMutable public var fieldsTypes : Array<FieldType>;

	public function new() {
		fieldsNames = [];
		fieldsTypes = [];
	}

	function get_checkSum() {
		var s = new Serializer();
		s.begin();
		var old = __uid;
		__uid = 0;
		s.addKnownRef(this);
		__uid = old;
		var bytes = s.end();
		return haxe.crypto.Crc32.make(bytes);
	}

}
#end
