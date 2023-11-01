package hxd.impl;

abstract BitSet(haxe.io.Bytes) {

	public function new(count:Int) {
		this = haxe.io.Bytes.alloc((count + 7) >> 3);
	}

	public function get(index:Int) {
		return this.get(index>>3) & (1 << (index&7)) != 0;
	}

	public function set(index:Int) {
		var p = index >> 3;
		this.set(p, this.get(p) | (1 << (index&7)));
	}

	public function unset(index:Int) {
		var p = index >> 3;
		this.set(p, this.get(p) & ~(1 << (index&7)));
	}

	public function toggle(index:Int, b : Bool) {
		var p = index >> 3;
		var v = this.get(p);
		var mask = 1 << (index&7);
		this.set(p, b ? v | mask : v & ~mask);
	}

	public function clear(b=false) {
		this.fill(0,this.length,b?0xFF:0);
	}

}
