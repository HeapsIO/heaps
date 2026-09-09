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
	function get_length() : Int {
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

	var medianValues : Array<Float> = [];
	public function getMedian() : Float {
		function fillMedianValues() {
			if(medianValues.length != arr.length){
				medianValues.resize(arr.length);
			}
			var cursor = 0;
			if(head > tail) {
				for(i in tail...head)
					medianValues[cursor++] = arr[i];
			} else {
				for(i in tail...max)
					medianValues[cursor++] = arr[i];
				for(i in 0...head)
					medianValues[cursor++] = arr[i];
			}
			return cursor;
		}

		var n = fillMedianValues();
		medianValues.slice(0,n).sort(function(a: Float, b: Float) return a > b ? 1 : (a < b ? -1 : 0));
		return medianValues[Std.int(n / 2)];
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