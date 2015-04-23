package hxd;

class WaitEvent {

	var updateList : Array<Float -> Bool> ;

	public function new() {
		updateList = [];
	}

	public inline function hasEvent() {
		return updateList.length > 0;
	}

	public function clear() {
		updateList = [];
	}

	public function add( callb ) {
		updateList.push(callb);
	}

	public function remove(callb) {
		updateList.remove(callb);
	}

	public function wait( time : Float, callb ) {
		function tmp(_) {
			time -= hxd.Timer.deltaT;
			if( time < 0 ) {
				callb();
				return true;
			}
			return false;
		}
		updateList.push(tmp);
	}

	public function waitUntil( callb ) {
		updateList.push(callb);
	}

	public function update(dt:Float) {
		if( updateList.length == 0 ) return;
		for( f in updateList.copy() )
			if( f(dt) )
				updateList.remove(f);
	}

}