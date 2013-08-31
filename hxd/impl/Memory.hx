package hxd.impl;

class MemoryReader {

	public function new() {
	}
	
	public inline function b( addr : Int ) {
		return flash.Memory.getByte(addr);
	}
	
	public inline function wb( addr : Int, v : Int ) {
		flash.Memory.setByte(addr, v);
	}
	
	public inline function end() {
		@:privateAccess Memory.end();
	}

}

class Memory {

	static var stack = new Array<haxe.io.Bytes>();
	static var current : haxe.io.Bytes = null;
	static var inst = new MemoryReader();
	
	public static function select( b : haxe.io.Bytes ) {
		flash.Memory.select(b.getData());
		if( current != null ) stack.push(current);
		current = b;
		return inst;
	}
	
	static function end() {
		current = stack.pop();
		if( current != null )
			flash.Memory.select(current.getData());
	}

}