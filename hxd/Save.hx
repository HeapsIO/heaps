package hxd;

/**
	Save provides simple interface to save and load serialized user data.
	Data is serialized to String with `haxe.Serializer` and then stored in text form.
**/
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

	static var SALT = "s*al!t";

	static function makeCRC( data : String ) {
		return haxe.crypto.Sha1.encode(data + haxe.crypto.Sha1.encode(data + SALT)).substr(4, 32);
	}

	static function loadData( data : String, checkSum : Bool, defValue : Dynamic ) : Dynamic {
		if( checkSum ) {
			if( data.charCodeAt(data.length - 33) != '#'.code )
				throw "Missing CRC";
			var crc = data.substr(data.length - 32);
			data = data.substr(0, -33);
			if( makeCRC(data) != crc )
				throw "Invalid CRC";
		}
		var obj : Dynamic = haxe.Unserializer.run(data);

		// set all fields that were not set to default value (auto upgrade)
		if( defValue != null && Reflect.isObject(obj) && Reflect.isObject(defValue) ) {
			for( f in Reflect.fields(defValue) ) {
				if( Reflect.hasField(obj, f) ) continue;
				Reflect.setField(obj, f, Reflect.field(defValue,f));
			}
		}
		return obj;
	}

	static function saveData( value : Dynamic, checkSum : Bool ) : Dynamic {
		var data = haxe.Serializer.run(value);
		return checkSum ? data + "#" + makeCRC(data) : data;
	}

	/**
		Loads save with specified name. Returns `defValue` if save does not exists or could not be unserialized.
		@param defValue Fallback default save value
		@param name Name of the save
		@param checkSum Set to true if data expected to have crc checksum prepending the data. Should be set for entries saved with `checkSum = true`.
	**/
	public static function load<T>( ?defValue : T, ?name = "save", checkSum = false ) : T {
		#if flash
		try {
			var data = Reflect.field(getObj(name).data, "data");
			cur.set(name, data);
			return loadData(data,checkSum,defValue);
		} catch( e : Dynamic ) {
			return defValue;
		}
		#else
		return try loadData(readSaveData(name), checkSum, defValue) catch( e : Dynamic ) defValue;
		#end
	}

	/**
		Override this method to provide custom save lookup.
		By default it uses `name + ".sav"` for system targets and `localStorage.getItem(name)` on JS.
		Have no effect on flash (shared object is used).
		**Note:** This method is an utility method, to load data use `hxd.Save.load`
	**/
	@:noCompletion public static dynamic function readSaveData( name : String ) : String {
		#if sys
		return sys.io.File.getContent(name+".sav");
		#elseif js
		return js.Browser.window.localStorage.getItem(name);
		#else
		throw "Not implemented";
		return null;
		#end
	}

	/**
		Override this method to provide custom save storage.
		By default it stores saves in `name + ".sav"` file in current working directory on system targets and `localStorage.setItem(name)` on JS.
		Have no effect on flash (shared object is used)
		**Note:** This method is an utility method, to save data use `hxd.Save.save`
	**/
	@:noCompletion public static dynamic function writeSaveData( name : String, data : String ) {
		#if sys
		sys.io.File.saveContent(name+".sav", data);
		#elseif js
		js.Browser.window.localStorage.setItem(name, data);
		#else
		throw "Not implemented";
		#end
	}

	/**
		Deletes save with specified name.
		Override this method when using custom save lookup.
		Does not work on flash.
	**/
	public dynamic static function delete( name = "save" ) {
		#if flash
		throw "TODO";
		#elseif sys
		try sys.FileSystem.deleteFile(name+".sav") catch( e : Dynamic ) {}
		#elseif js
		try js.Browser.window.localStorage.removeItem(name) catch( e : Dynamic ) {}
		#end
	}

	/**
		Saves `val` under the specified name.
		@param checkSum When set, save data is prepended by salted crc checksum for data validation. When save is loaded, `checkSum` flag should be set accordingly.
	**/
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
