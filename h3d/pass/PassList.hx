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
	var discarded : PassObject;
	var lastDisc : PassObject;

	public function new(?current) {
		init(current);
	}

	/**
		Set the passes and empty the discarded list
	**/
	public inline function init(pass) {
		current = pass;
		discarded = lastDisc = null;
	}

	/**
		Put back discarded passes into the pass list
	**/
	public inline function reset() {
		if( discarded != null ) {
			lastDisc.next = current;
			current = discarded;
			discarded = lastDisc = null;
		}
	}

	/**
	 * Return the number of passes
	 */
	public inline function count() {
		var c = current;
		var n = 0;
		while( c != null ) {
			n++;
			c = c.next;
		}
		return n;
 	}

	/**
		Save the discarded list, allow to perfom some filters, then call "load" to restore passes
	**/
	public inline function save() {
		return lastDisc;
	}

	/**
		load state that was save() before
	**/
	public inline function load( p : PassObject ) {
		if( lastDisc != p ) {
			lastDisc.next = current;
			if( p == null ) {
				current = discarded;
				discarded = null;
			} else {
				current = p.next;
				p.next = null;
			}
			lastDisc = p;
		}
	}

	public inline function isEmpty() {
		return current == null;
	}

	/**
		Put all passes into discarded list
	**/
	public function clear() {
		if( current == null )
			return;
		if( discarded == null )
			discarded = current;
		else
			lastDisc.next = current;
		var p = current;
		while( p.next != null ) p = p.next;
		lastDisc = p;
		current = null;
	}

	public inline function sort( f : PassObject -> PassObject -> Int ) {
		current = haxe.ds.ListSort.sortSingleLinked(current, f);
	}

	/**
		Filter current passes, add results to discarded list
	**/
	public inline function filter( f : PassObject -> Bool ) {
		var head = null;
		var prev = null;
		var disc = discarded;
		var discQueue = lastDisc;
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
				if( disc == null )
					disc = discQueue = cur;
				else {
					discQueue.next = cur;
					discQueue = cur;
				}
			}
			cur = cur.next;
		}
		if( prev != null )
			prev.next = null;
		if( discQueue != null )
			discQueue.next = null;
		current = head;
		discarded = disc;
		lastDisc = discQueue;
	}

	public inline function iterator() {
		return new PassListIterator(current);
	}

	/**
		Iterate on all discarded elements, if any
	**/
	public inline function getFiltered() {
		return new PassListIterator(discarded);
	}

}