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

	public function remove( callb : Float->Bool ) {
		for( e in updateList )
			if( Reflect.compareMethods(e, callb) ) {
				updateList.remove(e);
				return true;
			}
		return false;
	}

	public function wait( time : Float, callb : Void -> Void ) {
		function tmp(dt:Float) {
			time -= dt;
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
		var i = 0;
		while (i < updateList.length) {
			var f = updateList[i];
			if(f(dt))
				updateList.remove(f);
			else
				++i;
		}
	}
}