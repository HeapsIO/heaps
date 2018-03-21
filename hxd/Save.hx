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
		#if usesys
		name = haxe.System.savePathPrefix + name;
		#end
		return name + ".sav";
	}
	#end

	static function makeCRC( data : String ) {
		return haxe.crypto.Sha1.encode(data + haxe.crypto.Sha1.encode(data + "s*al!t")).substr(4, 32);
	}

	static function loadData( data : String, checkSum : Bool ) : Dynamic {
		if( checkSum ) {
			if( data.charCodeAt(data.length - 33) != '#'.code )
				throw "Missing CRC";
			var crc = data.substr(data.length - 32);
			data = data.substr(0, -33);
			if( makeCRC(data) != crc )
				throw "Invalid CRC";
		}
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
		#else
		return try loadData(readSaveData(name), checkSum) catch( e : Dynamic ) defValue;
		#end
	}

	@:noCompletion public static dynamic function readSaveData( name : String ) : String {
		#if sys
		return sys.io.File.getContent(savePath(name));
		#elseif js
		return js.Browser.window.localStorage.getItem(name);
		#else
		throw "Not implemented";
		return null;
		#end
	}

	@:noCompletion public static dynamic function writeSaveData( name : String, data : String ) {
		#if sys
		sys.io.File.saveContent(savePath(name), data);
		#elseif js
		js.Browser.window.localStorage.setItem(name, data);
		#else
		throw "Not implemented";
		#end
	}

	public dynamic static function delete( name = "save" ) {
		#if flash
		throw "TODO";
		#elseif sys
		try sys.FileSystem.deleteFile(savePath(name)) catch( e : Dynamic ) {}
		#elseif js
		try js.Browser.window.localStorage.removeItem(name) catch( e : Dynamic ) {}
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
		#else
		var data = saveData(val,checkSum);
		try if( readSaveData(name) == data ) return false catch( e : Dynamic ) {};
		writeSaveData(name, data);
		return true;
		#end
	}

}