package hxd;

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
	public inline function new( name : String, type : InputFormat ) {
		this.name = name;
		this.type = type;
	}
}

class BufferFormat {

	static var _UID = 0;
	public var uid : Int;
	public var stride(default,null) : Int;
	var inputs : Array<BufferInput>;
	var offsets : Map<Int, Array<Int>>;

	function new( inputs : Array<BufferInput> ) {
		uid = _UID++;
		stride = 0;
		this.inputs = inputs.copy();
		for( i in inputs )
			stride += i.type.getSize();
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

	public function getMatchingOffsets( target : BufferFormat ) {
		var offs = offsets == null ? null : offsets.get(target.uid);
		if( offs != null )
			return offs;
		offs = [];
		for( i in target.inputs ) {
			var v = 0;
			for( i2 in inputs ) {
				if( i2.name == i.name ) {
					offs.push(v);
					v = -1;
					break;
				}
				v += i2.type.getSize();
			}
			if( v >= 0 ) throw "Missing buffer input '"+i.name+"'";
		}
		if( offsets == null ) offsets = new Map();
		offsets.set(target.uid, offs);
		return offs;
	}

	public inline function getInputs() {
		return inputs.iterator();
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
				if( inputs[i].type != fmt.inputs[i].type ) {
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

}