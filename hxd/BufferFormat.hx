package hxd;


enum abstract Precision(Int) {
	var F32 = 0;
	var F16 = 1;
	var U8 = 2;
	var S8 = 3;
	inline function new(v) {
		this = v;
	}
	public inline function getSize() {
		return SIZES[this];
	}
	public inline function toInt() {
		return this;
	}
	static inline function fromInt( v : Int ) : Precision {
		return new Precision(v);
	}
	public function toString() {
		return switch( new Precision(this) ) {
		case F32: "F32";
		case F16: "F16";
		case U8: "U8";
		case S8: "S8";
		}
	}
	static var SIZES = [4,2,1,1];
}

enum abstract InputFormat(Int) {

	public var DFloat = 1;
	public var DVec2 = 2;
	public var DVec3 = 3;
	public var DVec4 = 4;
	public var DBytes4 = 9;

	inline function new(v) {
		this = v;
	}

	public inline function getSize() {
		return this & 7;
	}

	public inline function toInt() {
		return this;
	}

	public function toString() {
		return switch( new InputFormat(this) ) {
		case DFloat: "DFloat";
		case DVec2: "DVec2";
		case DVec3: "DVec3";
		case DVec4: "DVec4";
		case DBytes4: "DBytes4";
		}
	}

	static inline function fromInt( v : Int ) : InputFormat {
		return new InputFormat(v);
	}

	public static function fromHXSL( t : hxsl.Ast.Type ) {
		return switch( t ) {
		case TVec(2, VFloat): DVec2;
		case TVec(3, VFloat): DVec3;
		case TVec(4, VFloat): DVec4;
		case TBytes(4): DBytes4;
		case TFloat: DFloat;
		default: throw "Unsupported buffer type " + t;
		}
	}

}

@:structInit
class BufferInput {
	public var name(default,null) : String;
	public var type(default,null) : InputFormat;
	public var precision(default,null) : Precision;
	public inline function new( name : String, type : InputFormat, precision = F32 ) {
		this.name = name;
		this.type = type;
		this.precision = precision;
	}
	public inline function getBytesSize() {
		return type.getSize() * precision.getSize();
	}
	public inline function equals(b:BufferInput) {
		return type == b.type && name == b.name && precision == b.precision;
	}
}

abstract BufferMapping(Int) {
	public var bufferIndex(get,never) : Int;
	public var offset(get,never) : Int;
	public var precision(get,never) : Precision;
	public function new(index,offset,prec:Precision) {
		this = (index << 3) | prec.toInt() | (offset << 16);
	}
	inline function get_bufferIndex() return (this >> 3) & 0xFF;
	inline function get_precision() return @:privateAccess new Precision(this & 7);
	inline function get_offset() return this >> 16;
}

class BufferFormat {

	static var _UID = 0;
	public var uid(default,null) : Int;
	public var stride(default,null) : Int;
	public var strideBytes(default,null) : Int;
	public var hasLowPrecision(default,null) : Bool;
	var inputs : Array<BufferInput>;
	var mappings : Array<Array<BufferMapping>>;

	function new( inputs : Array<BufferInput> ) {
		uid = _UID++;
		stride = strideBytes = 0;
		this.inputs = inputs.copy();
		hasLowPrecision = false;
		for( i in inputs ) {
			stride += i.type.getSize();
			strideBytes += i.getBytesSize();
			// 4 bytes align
			if( strideBytes & 3 != 0 )
				strideBytes += 4 - (strideBytes & 3);
			if( i.precision != F32 )
				hasLowPrecision = true;
		}
	}

	public function getInput( name : String ) {
		for( i in inputs )
			if( i.name == name )
				return i;
		return null;
	}

	public function calculateInputOffset( name : String ) {
		var offset = 0;
		for( i in inputs ) {
			if( i.name == name )
				return offset;
			offset += i.getBytesSize();
			if( offset & 3 != 0 ) offset += 4 - (offset & 3);
		}
		throw "Input not found : "+name;
	}

	public function hasInput( name : String, ?type : InputFormat ) {
		for( i in inputs )
			if( i.name == name )
				return type == null || type == i.type;
		return false;
	}

	public function append( name : String, type : InputFormat ) {
		var inputs = inputs.copy();
		inputs.push({ name : name, type : type });
		return make(inputs);
	}

	public function pop() {
		var inputs = inputs.copy();
		inputs.pop();
		return make(inputs);
	}

	public function isSubSet( fmt : BufferFormat ) {
		if( fmt == this )
			return true;
		if( inputs.length >= fmt.inputs.length )
			return false;
		for( i in 0...inputs.length ) {
			var i1 = inputs[i];
			var i2 = fmt.inputs[i];
			if( i1.name != i2.name || i1.type != i2.type )
				return false;
		}
		return true;
	}

	public function resolveMapping( target : BufferFormat ) {
		var m = mappings == null ? null : mappings[target.uid];
		if( m != null )
			return m;
		m = [];
		for( i in target.inputs ) {
			var found = false;
			for( i2 in inputs ) {
				if( i2.name == i.name && i2.type == i.type ) {
					m.push(new BufferMapping(0,calculateInputOffset(i2.name),i2.precision));
					found = true;
					break;
				}
			}
			if( !found ) throw "Missing buffer input '"+i.name+"'";
		}
		if( mappings == null ) mappings = [];
		mappings[target.uid] = m;
		return m;
	}

	public inline function getInputs() {
		return inputs.iterator();
	}

	public function toString() {
		return [for( i in inputs ) i.name+":"+i.type.toString()+(i.precision == F32?"":"."+i.precision.toString().toLowerCase())].toString();
	}

	/**
		Alias for XY_UV_RGBA
	**/
	public static var H2D(get,never) : BufferFormat;
	public static var XY_UV_RGBA(get,null) : BufferFormat;
	public static var XY_UV(get,null) : BufferFormat;
	public static var POS3D(get,null) : BufferFormat;
	public static var POS3D_NORMAL(get,null) : BufferFormat;
	public static var POS3D_UV(get,null) : BufferFormat;
	public static var POS3D_NORMAL_UV(get,null) : BufferFormat;
	public static var POS3D_NORMAL_UV_RGBA(get,null) : BufferFormat;

	static inline function get_H2D() return XY_UV_RGBA;
	static function get_XY_UV_RGBA() {
		if( XY_UV_RGBA == null ) XY_UV_RGBA = make([{ name : "position", type : DVec2 },{ name : "uv", type : DVec2 },{ name : "color", type : DVec4 }]);
		return XY_UV_RGBA;
	}
	static function get_XY_UV() {
		if( XY_UV == null ) XY_UV = make([{ name : "position", type : DVec2 },{ name : "uv", type : DVec2 }]);
		return XY_UV;
	}
	static function get_POS3D() {
		if( POS3D == null ) POS3D = make([{ name : "position", type : DVec3 }]);
		return POS3D;
	}
	static function get_POS3D_NORMAL() {
		if( POS3D_NORMAL == null ) POS3D_NORMAL = make([{ name : "position", type : DVec3 },{ name : "normal", type : DVec3 }]);
		return POS3D_NORMAL;
	}
	static function get_POS3D_NORMAL_UV() {
		if( POS3D_NORMAL_UV == null ) POS3D_NORMAL_UV = make([{ name : "position", type : DVec3 },{ name : "normal", type : DVec3 },{ name : "uv", type : DVec2 }]);
		return POS3D_NORMAL_UV;
	}
	static function get_POS3D_NORMAL_UV_RGBA() {
		if( POS3D_NORMAL_UV_RGBA == null ) POS3D_NORMAL_UV_RGBA = POS3D_NORMAL_UV.append("color",DVec4);
		return POS3D_NORMAL_UV_RGBA;
	}
	static function get_POS3D_UV() {
		if( POS3D_UV == null ) POS3D_UV = make([{ name : "position", type : DVec3 },{ name : "uv", type : DVec2 }]);
		return POS3D_UV;
	}

	static var ALL_FORMATS = new Map<String,Array<BufferFormat>>();
	public static function make( inputs : Array<BufferInput> ) {
		var names = [];
		for( b in inputs )
			names.push(b.name);
		var key = names.join("|");
		var arr = ALL_FORMATS.get(key);
		if( arr == null ) {
			arr = [];
			ALL_FORMATS.set(key,arr);
		}
		for( fmt in arr ) {
			var found = true;
			for( i in 0...inputs.length )
				if( !inputs[i].equals(fmt.inputs[i]) ) {
					found = false;
					break;
				}
			if( found )
				return fmt;
		}
		var fmt = new BufferFormat(inputs);
		arr.push(fmt);
		return fmt;
	}

	public static function float32to16( v : Float, denormalsAreZero : Bool = false ) : Int {
		var i = haxe.io.FPHelper.floatToI32(v);
		var sign = (i & 0x80000000) >>> 16;
		var exp = (i & 0x7f800000) >>> 23;
		var bits = i & 0x7FFFFF;
		if( exp > 112 )
			return sign | (((exp - 112) << 10)&0x7C00) | (bits>>13);
		if( exp < 113 && exp > 101 && !denormalsAreZero )
			return sign | ((((0x7FF000+bits)>>(125-exp))+1)>>1);
		if( exp > 143 )
			return sign | 0x7FFF;
		return 0;
	}

	public static function float16to32( v : Int ) : Float {
		var sign = (v & 0x8000) << 16;
		var bits = (v & 0x3FF) << 13;
		var exp = (v & 0x7C00) >> 10;
		if( exp != 0 )
			return haxe.io.FPHelper.i32ToFloat(sign | ((exp + 112) << 23) | bits);
		if( bits == 0 )
			return 0;
		var bitcount = haxe.io.FPHelper.floatToI32(bits) >> 23; // hack to get exp (number of leading zeros)
		return haxe.io.FPHelper.i32ToFloat(sign | ((bitcount - 37) << 23) | ((bits<<(150-bitcount))&0x7FE000));
	}

	public static function float32toS8( v : Float ) : Int {
		var i = Math.floor(v * 128);
		if( i >= 127 )
			return 0x7F;
		if( i <= -127 )
			return 0x80;
		return i >= 0 ? i : (0x7F + i) | 0x80;
	}

	public static function floatS8to32( v : Int ) {
		return (v & 0x80 != 0 ? -1 : 1) * ((v&0x7F)/127);
	}

	public static function float32toU8( v : Float ) : Int {
		if( v < 0 )
			return 0;
		if( v >= 1 )
			return 0xFF;
		return Math.floor(v * 256);
	}

	public inline static function floatU8to32( v : Int ) {
		return (v & 0xFF) / 255;
	}

}

typedef MultiFormatCache = Map<Int, { found : MultiFormat, nexts : MultiFormatCache }>;

class MultiFormat {

	static var UID = 0;
	static var CACHE = new MultiFormatCache();

	static var _UID = 0;
	public var uid(default,null) : Int;
	var formats : Array<BufferFormat>;
	var mappings : Array<Array<BufferMapping>> = [];

	function new( formats : Array<BufferFormat> ) {
		uid = _UID++;
		this.formats = formats;
	}

	public inline function resolveMapping( format : hxd.BufferFormat ) {
		var m = mappings[format.uid];
		if( m == null )
			m = makeMapping(format);
		return m;
	}

	function makeMapping( format : hxd.BufferFormat ) {
		var m = [];
		for( input in format.getInputs() ) {
			var found = false, match = null;
			for( idx => f in formats ) {
				var i = f.getInput(input.name);
				if( i != null ) {
					match = i;
					if( i.type != input.type ) continue;
					var offset = f.calculateInputOffset(i.name);
					m.push(new BufferMapping(idx,offset,i.precision));
					found = true;
					break;
				}
			}
			if( !found ) {
				if( match != null )
					throw "Shader buffer "+input.name+" was requested with "+input.type+" but found with "+match.type;
				throw "Missing shader buffer "+input.name;
			}
		}
		mappings[format.uid] = m;
		return m;
	}

	public static var MAX_FORMATS = 16;
	public static function make( formats : Array<BufferFormat> ) : MultiFormat {
		if( formats.length > MAX_FORMATS )
			throw "Too many formats (addBuffer leak?) "+[for( f in formats ) f.toString()];
		var c = { found : null, nexts : CACHE };
		for( f in formats ) {
			var c2 = c.nexts.get(f.uid);
			if( c2 == null ) {
				c2 = { found : null, nexts : new Map() };
				c.nexts.set(f.uid, c2);
			}
			c = c2;
		}
		if( c.found == null )
			c.found = new MultiFormat(formats);
		return c.found;
	}

}

