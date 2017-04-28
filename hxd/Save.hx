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

	#if sys
	static function savePath( name : String ) {
		return name + ".sav";
	}
	#end

	static function makeCRC( data : String ) {
		return haxe.crypto.Sha1.encode(data + haxe.crypto.Sha1.encode(data + "s*al!t")).substr(4, 32);
	}

	static function loadData( data : String, checkSum : Bool ) : Dynamic {
		if( data.charCodeAt(data.length - 33) != '#'.code )
			throw "Missing CRC";
		var crc = data.substr(data.length - 32);
		var data = data.substr(0, -33);
		if( makeCRC(data) != crc )
			throw "Invalid CRC";
		return haxe.Unserializer.run(data);
	}

	static function saveData( value : Dynamic, checkSum : Bool ) : Dynamic {
		var data = haxe.Serializer.run(value);
		return checkSum ? data + "#" + makeCRC(data) : data;
	}

	public static function load<T>( ?defValue : T, ?name = "save", checkSum = false ) : T {
		#if flash
		try {
			var data = Reflect.field(getObj(name).data, "data");
			cur.set(name, data);
			return loadData(data,checkSum);
		} catch( e : Dynamic ) {
			return defValue;
		}
		#elseif sys
		return try loadData(sys.io.File.getContent(savePath(name)),checkSum) catch( e : Dynamic ) defValue;
		#else
		return defValue;
		#end
	}

	public static function save( val : Dynamic, ?name = "save", checkSum = false ) {
		#if flash
		var data = saveData(val, checkSum);
		if( data == cur.get(name) )
			return false;
		cur.set(name, data);
		getObj(name).setProperty("data", data);
		try saveObj.flush() catch( e : Dynamic ) throw "Can't write save (disk full ?)";
		return true;
		#elseif sys
		var data = saveData(val,checkSum);
		var file = savePath(name);
		try if( sys.io.File.getContent(file) == data ) return false catch( e : Dynamic ) {};
		sys.io.File.saveContent(file, data);
		return true;
		#else
		return false;
		#end
	}

}