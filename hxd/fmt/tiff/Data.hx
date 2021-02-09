package hxd.fmt.tiff;

enum abstract TifTag(Int) {
	public var ImageWidth = 256;
	public var ImageHeight = 257;
	public var BitsPerSample = 258;
	public var Compression = 259;
	public var PhotometricInterpretation = 262;
	public var StripOffsets = 273;
	public var Orientation = 274;
	public var SamplesPerPixel = 277;
	public var RowsPerStrip = 278;
	public var StripByteCounts = 279;
	public var PlanarConfiguration = 284;
	public var SampleFormat = 339;
	public var ModelPixelScale = 33550;
	public var ModelTiepoint = 33922;
	public var GeoKeyDirectory = 34735;
	public var GeoDoubleParams = 34736;
	public var GeoAsciiParams = 34737;
	public inline function new(v) {
		this = v;
	}
	public inline function toInt() return this;
}

enum abstract TifType(Int) {
	public var Byte = 1;
	public var Ascii = 2;
	public var Short = 3;
	public var Long = 4;
	public var Rational = 5;
	public var SByte = 6;
	public var UndefByte = 7;
	public var SShort = 8;
	public var SLong = 9;
	public var SRational = 10;
	public var Float = 11;
	public var Double = 12;
	public inline function new(v) {
		this = v;
	}
	public inline function toInt() return this;


	public function getSize() {
		return switch( new TifType(this) ) {
		case Byte, Ascii, SByte, UndefByte: 1;
		case Short, SShort: 2;
		case Long, SLong, Float: 4;
		case Rational, SRational, Double: 8;
		default: throw "assert";
		}
	}

}

enum TifValue {
	VInt( v : Int );
	VFloat( v : Float );
	VString( s : String );
	VArray( a : Array<TifValue> );
}

typedef TifFile = {
	var tags : Array<{ tag : TifTag, type : TifType, value : TifValue }>;
	var data : Array<haxe.io.Bytes>;
}

class Utils {

	public static function get( f : TifFile, tag : TifTag ) {
		for( t in f.tags )
			if( t.tag == tag )
				return t.value;
		return null;
	}

	public static function getInt( f : TifFile, tag : TifTag ) : Null<Int> {
		var v = get(f, tag);
		if( v == null ) return null;
		return switch( v ) {
		case VInt(v): v;
		case VFloat(f): Std.int(f);
		default: throw "assert";
		}
	}

}