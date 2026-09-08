package h3d.impl;

class FrameDataImpl {
	var arr : Array<Float>;
	var max : Int;
	var head : Int;
	var tail : Int;
	var full : Bool;
	public var length(get, null) : Int;
	public function new( max : Int ) {
		this.max = max;
		arr = [];
		arr.resize(max);
		head = 0;
		tail = 0;
		full = false;
	}
	function get_length() {
		return full ? max : ( head >= tail ? head - tail : max + head - tail );
	}
	public function push( v : Float ) {
		arr[head] = v;
		head = incIndex(head);
		if( full )
			tail = incIndex(tail);
		if( !full )
			full = head == tail;
	}
	inline function incIndex( index : Int ) {
		index += 1;
		if( index == max )
			index = 0;
		return index;
	}
	public inline function get( index : Int ) : Float {
		var i = tail + index;
		if( i >= max )
			i -= max;
		return arr[i];
	}
}

@:forward abstract FrameData(FrameDataImpl) {
	public function new( max : Int ) {
		this = new FrameDataImpl(max);
	}
	@:arrayAccess public inline function get( index : Int ) : Float {
		return this.get(index);
	}
}