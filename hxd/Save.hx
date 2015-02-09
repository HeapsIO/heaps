package hxd;

class Save {

	static var cur = new Map<String,String>();
	#if flash
	static var saveObj : flash.net.SharedObject;
	static var curObj : String;
	static function getObj( name : String ) {
		if( curObj != name ) {
			curObj = name;
			saveObj = flash.net.SharedObject.getLocal(name);
		}
		return saveObj;
	}
	#end

	public static function load<T>( ?defValue : T, ?name = "save" ) : T {
		#if flash
		try {
			var data = Reflect.field(getObj(name).data, "data");
			cur.set(name, data);
			return haxe.Unserializer.run(data);
		} catch( e : Dynamic ) {
			return defValue;
		}
		#else
		return defValue;
		#end
	}

	public static function save( val : Dynamic, ?name = "save", ?quick : Bool ) {
		#if flash
		var data = haxe.Serializer.run(val);
		if( data == cur.get(name) )
			return false;
		cur.set(name, data);
		getObj(name).setProperty("data", data);
		if( !quick ) try saveObj.flush() catch( e : Dynamic ) throw "Can't write save (disk full ?)";
		return true;
		#else
		return false;
		#end
	}

}