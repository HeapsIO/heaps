package hxd.fmt.hbson;

class Writer {

	var out : haxe.io.Output;
	var stringCount : Int;
	var stringMap : Map<String,Int>;

	public function new( out : haxe.io.Output ) {
		this.out = out;
		stringCount = 0;
		stringMap = [];
		out.writeString("HBSON");
		out.writeByte(0);
	}

	public function write( json : Dynamic ) {
		writeRec(json);
	}

	function isAscii(str:String) {
		for( i in 0...str.length )
			if( str.charCodeAt(i) > 127 )
				return false;
		return true;
	}

	function writeString( str : String ) {
		if( str.length <= 16 && isAscii(str) ) {
			var index = stringMap.get(str);
			if( index == null ) {
				index = stringCount++;
				stringMap.set(str,index);
				out.writeInt32(str.length | 0x40000000);
				out.writeString(str);
			} else
				out.writeInt32(index);
		} else {
			var bytes = haxe.io.Bytes.ofString(str);
			out.writeInt32(bytes.length | 0x80000000);
			out.write(bytes);
		}
	}

	function writeRec(value:Dynamic) {
		switch( Type.typeof(value) ) {
		case TInt:
			var value : Int = value;
			if( value == 0 )
				out.writeByte(0);
			else if( value >= 0 && value <= 255 ) {
				out.writeByte(1);
				out.writeByte(value);
			} else {
				out.writeByte(2);
				out.writeInt32(value);
			}
		case TFloat:
			out.writeByte(3);
			out.writeDouble(value);
		case TBool:
			out.writeByte((value:Bool) ? 4 : 5);
		case TNull:
			out.writeByte(6);
		case TObject:
			var fields = Reflect.fields(value);
			if( fields.length == 0 ) {
				out.writeByte(7);
			} else if( fields.length < 256 ) {
				out.writeByte(8);
				out.writeByte(fields.length);
			} else {
				out.writeByte(9);
				out.writeInt32(fields.length);
			}
			for( f in fields ) {
				writeString(f);
				writeRec(Reflect.field(value,f));
			}
		case TClass(c):
			if( c == String ) {
				out.writeByte(10);
				writeString(value);
			} else if( c == Array ) {
				var value : Array<Dynamic> = value;
				if( value.length == 0 ) {
					out.writeByte(11);
				} else if( value.length < 256 ) {
					out.writeByte(12);
					out.writeByte(value.length);
				} else {
					out.writeByte(13);
					out.writeInt32(value.length);
				}
				for( v in value )
					writeRec(v);
			} else
				throw "Unsupported "+value;
		default:
			throw "Unsupported "+value;
		}
	}

}