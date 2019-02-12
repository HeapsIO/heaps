package h3d.pass;

class PassListIterator {
	var o : PassObject;
	public inline function new(o) {
		this.o = o;
	}
	public inline function hasNext() {
		return o != null;
	}
	public inline function next() {
		var tmp = o;
		o = @:privateAccess o.next;
		return tmp;
	}
}

@:access(h3d.pass.PassObject)
class PassList {
	var current : PassObject;
	var whole : PassObject;
	var lastWhole : PassObject;

	public function new(?current) {
		init(current);
	}

	public inline function init(pass) {
		current = pass;
		whole = lastWhole = null;
	}

	public inline function reset() {
		if( whole != null ) {
			current = whole;
			whole = lastWhole = null;
		}
	}

	public inline function isEmpty() {
		return current == null;
	}

	public function clear() {
		if( whole == null )
			whole = current;
		else if( current != null ) {
			lastWhole.next = current;
			lastWhole = current;
		}
		current = null;
	}

	public inline function sort( f : PassObject -> PassObject -> Int ) {
		current = haxe.ds.ListSort.sortSingleLinked(current, f);
		if( lastWhole != null ) lastWhole.next = current;
	}

	public inline function filter( f : PassObject -> Bool ) {
		var head = null;
		var prev = null;
		var discarded = whole;
		var discardedQueue = lastWhole;
		var cur = current;
		while( cur != null ) {
			if( f(cur) ) {
				if( head == null )
					head = prev = cur;
				else {
					prev.next = cur;
					prev = cur;
				}
			} else {
				if( discarded == null )
					discarded = discardedQueue = cur;
				else {
					discardedQueue.next = cur;
					discardedQueue = cur;
				}
			}
			cur = cur.next;
		}
		if( prev != null )
			prev.next = null;
		if( discardedQueue != null )
			discardedQueue.next = head;
		current = head;
		whole = discarded;
		lastWhole = discardedQueue;
	}

	public inline function iterator() {
		return new PassListIterator(current);
	}

}