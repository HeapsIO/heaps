package hxd;

class Save {
	
	static var cur = new Map();
	
	public static function load<T>( ?defValue : T, ?name = "save" ) : T {
		#if flash
		var saveObj = flash.net.SharedObject.getLocal(name);
		try {
			var data = Reflect.field(saveObj.data, "data");
			cur.set(name, data);
			return haxe.Unserializer.run(data);
		} catch( e : Dynamic ) {
			return defValue;
		}
		#else
		return defValue;
		#end
	}
	
	public static function save( val : Dynamic, ?name = "save" ) {
		#if flash
		var data = haxe.Serializer.run(val);
		if( data == cur.get(name) )
			return false;
		cur.set(name, data);
		var saveObj = flash.net.SharedObject.getLocal(name);
		saveObj.setProperty("data", data);
		saveObj.flush();
		return true;
		#else
		return false;
		#end
	}
	
}