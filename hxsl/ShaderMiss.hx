package hxsl;
using hxsl.Ast;

typedef ShaderMissInstance = {
	var name : String;
	var index : Int;
	var bits : Int;
	var consts : Array<String>;
}

class ShaderMiss {

	public static inline var PREFIX = "[ShaderMiss] ";
	public static var onMiss : ShaderMiss -> Void;
	static var reported : Map<String, ShaderMiss> = [];
	#if heaps_mt_hxsl_cache
	static var mutex = new sys.thread.Mutex();
	#end

	public var mode : String;
	public var instances : Array<ShaderMissInstance>;
	public var context : String;

	function new() {
	}

	public static function report( rt : RuntimeShader ) : ShaderMiss {
		if( onMiss == null )
			return null;
		#if heaps_mt_hxsl_cache
		mutex.acquire();
		#end
		var m = reported.get(rt.spec.signature);
		if( m == null ) {
			m = describe(rt);
			reported.set(rt.spec.signature, m);
			try onMiss(m) catch( e : Dynamic ) {}
		}
		#if heaps_mt_hxsl_cache
		mutex.release();
		#end
		return m;
	}

	static function describe( rt : RuntimeShader ) {
		var m = new ShaderMiss();
		m.mode = rt.mode.getName();
		m.instances = [for( i in rt.spec.instances ) { name : i.shader.data.name, index : i.index, bits : i.bits, consts : decodeConsts(i.shader, i.bits) }];
		return m;
	}

	static function decodeConsts( s : SharedShader, bits : Int ) {
		var out = [];
		var c = s.consts;
		while( c != null ) {
			var v = (bits >>> c.pos) & ((1 << c.bits) - 1);
			var value = switch( c.v.type ) {
			case TBool: v != 0 ? "true" : "false";
			case TBuffer(_): formatName(hxd.BufferFormat.fromID(v));
			default: "" + v;
			}
			out.push(c.v.getName() + "=" + value);
			c = c.next;
		}
		out.reverse();
		return out;
	}

	static function formatName( fmt : hxd.BufferFormat ) {
		if( fmt == null )
			return "?";
		return "[" + [for( i in fmt.getInputs() ) i.name + ":" + i.type.toString() + ":" + i.precision.toString()].join(" ") + "]";
	}

	public function toString() {
		return PREFIX + haxe.Json.stringify({ mode : mode, instances : instances, context : context });
	}
}
