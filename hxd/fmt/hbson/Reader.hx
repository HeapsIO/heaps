package hxd.fmt.hbson;

class Reader {

	static var GLOBAL_STR_MAP : Map<String,String> = [];

	var input : haxe.io.BytesInput;
	var stringTbl : Array<String>;
	var globalStrings : Bool;

	public function new( data : haxe.io.Bytes, globalStrings ) {
		stringTbl = [];
		input = new haxe.io.BytesInput(data,6);
		this.globalStrings = globalStrings;
	}

	function readString() : String {
		var index = input.readInt32();
		if( index & 0xC0000000 != 0 ) {
			var str = input.readString(index & 0x3FFFFFFF);
			if( index & 0x40000000 != 0 ) {
				if( globalStrings ) {
					var str2 = GLOBAL_STR_MAP.get(str);
					if( str2 != null )
						str = str2;
					else
						GLOBAL_STR_MAP.set(str, str);
				}
				stringTbl.push(str);
			}
			return str;
		}
		var str = stringTbl[index];
		if( str == null ) throw "assert";
		return str;
	}

	public function read() : Dynamic {
		var code = input.readByte();
		switch( code ) {
		case 0:
			return 0;
		case 1:
			return input.readByte();
		case 2:
			return input.readInt32();
		case 3:
			return input.readDouble();
		case 4:
			return true;
		case 5:
			return false;
		case 6:
			return null;
		case 7:
			return {};
		case 8, 9:
			var obj = {};
			for( i in 0...(code == 8 ? input.readByte() : input.readInt32()) )
				Reflect.setField(obj, readString(), read());
			return obj;
		case 10:
			return readString();
		case 11:
			return [];
		case 12, 13:
			var arr : Array<Dynamic> = [];
			var len = code == 12 ? input.readByte() : input.readInt32();
			arr[len-1] = null;
			for( i in 0...len )
				arr[i] = read();
			return arr;
		default:
			throw "assert";
		}
	}

}