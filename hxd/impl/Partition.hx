package hxd.impl;

@:generic class PartitionChunk<T> {
	public var x : Int;
	public var y : Int;
	public var px : Int;
	public var py : Int;
	public var elements : T;
	public function new(x, y, px, py) {
		this.x = x;
		this.y = y;
		this.px = px;
		this.py = py;
		elements = null;
	}
}

@:generic class PartitionIterator < T: { partQueryNext:T } > {
	var cur : T;
	public inline function new(e) {
		this.cur = e;
	}
	public inline function hasNext() {
		return cur != null;
	}
	public inline function next() {
		var e = cur;
		cur = e.partQueryNext;
		return e;
	}
}

/**
	Partition will segment a 2D space into chunks of 2^N size and keep track of each entity position.
	It allows to perform efficient queries without checking all the entities.
**/
@:generic
@:allow(hxd.impl.PartitionChunk)
class Partition<T : { x : Float, y : Float, partChunk : Int, partNext : T, partQueryNext : T }> {

	var chunks : haxe.ds.Vector<PartitionChunk<T>>;
	var pbits : Int;
	var psize : Int;
	var pwidth : Int;
	var pheight : Int;

	/**
		Creates a new partition for the given world size.
		PBits tells the number of bits for the chunk size.
		Using too large chunks will not perform well if there's too many entities into them.
		Using too small chunks will require more often to move entities between chunks for each sync()
	**/
	public function new(width:Int, height:Int, pbits:Int) {
		this.pbits = pbits;
		this.psize = 1 << pbits;
		this.pwidth = Math.ceil(width / psize);
		this.pheight = Math.ceil(height / psize);
		chunks = new haxe.ds.Vector(pwidth * pheight);
		for( y in 0...pheight ) {
			for( x in 0...pwidth ) {
				var c = new PartitionChunk<T>(x, y, x * psize, y * psize);
				chunks[x + y * pwidth] = c;
			}
		}
	}

	/**
		Query a list of entities found within the given disc.
		Important : query results are optimized to perform zero allocation, so making a query will overwrite the results from a previous one.
		Make sure not to make a second query before the first one is fully processed.
	**/
	public inline function query( x : Float, y : Float, ray : Float ) : PartitionIterator<T> {
		var q = runQueryDist(x, y, ray);
		return new PartitionIterator(q);
	}

	function runQueryDist(x, y, r) {
		return runQueryInline(x, y, r, function(e) { var dx = e.x - x; var dy = e.y - y; return dx * dx + dy * dy; } );
	}

	inline function runQueryInline(x:Float, y:Float, r:Float, calcDistSq : T -> Float ) : T {
		var xMin = Math.floor(x - r) >> pbits;
		var yMin = Math.floor(y - r) >> pbits;
		var xMax = (Math.ceil(x + r) + (psize-1)) >> pbits;
		var yMax = (Math.ceil(y + r) + (psize-1)) >> pbits;
		xMin -= 1;
		yMin -= 1;
		xMax += 2;
		yMax += 2;
		if( xMin < 0 ) xMin = 0;
		if( yMin < 0 ) yMin = 0;
		if( xMax > pwidth ) xMax = pwidth;
		if( yMax > pheight ) yMax = pheight;
		var rr = r * r;
		var r : T = null, last : T = null;
		for( cy in yMin...yMax ) {
			var cid = cy * pwidth + xMin;
			for( cx in xMin...xMax ) {
				var c = chunks[cid++];
				var e = c.elements;
				if( e == null ) continue;
				while( e != null ) {
					var d = calcDistSq(e);
					if( d <= rr && d >= 0. ) {
						if( r == null ) {
							r = last = e;
						} else {
							last.partQueryNext = e;
							last = e;
						}
					}
					e = e.partNext;
				}
			}
		}
		if( last != null )
			last.partQueryNext = null;
		return r;
	}


	public inline function queryNearest( x : Float, y : Float, ray : Float, calcDistSq : T -> Float ) : T {
		var xMin = Math.floor(x - ray) >> pbits;
		var yMin = Math.floor(y - ray) >> pbits;
		var xMax = (Math.ceil(x + ray) + (psize-1)) >> pbits;
		var yMax = (Math.ceil(y + ray) + (psize-1)) >> pbits;
		var best : T = null, bestD = ray * ray;
		xMin -= 1;
		yMin -= 1;
		xMax += 2;
		yMax += 2;
		if( xMin < 0 ) xMin = 0;
		if( yMin < 0 ) yMin = 0;
		if( xMax > pwidth ) xMax = pwidth;
		if( yMax > pheight ) yMax = pheight;
		for( cy in yMin...yMax ) {
			var cid = cy * pwidth + xMin;
			for( cx in xMin...xMax ) {
				var c = chunks[cid++];
				var e = c.elements;
				if( e == null ) continue;
				while( e != null ) {
					var d = calcDistSq(e);
					if( d <= bestD && d >= 0. ) {
						best = e;
						bestD = d;
					}
					e = e.partNext;
				}
			}
		}
		return best;
	}


	/**
		Adds an entity to our partition system.
		If the entity is already present, it will sync() it, but in a less efficient manner.
		If an entity is outside of world bounds, an error is throw in debug, otherwise the result is unspecified.
	**/
	public function add( e : T ) {
		var cx = Std.int(e.x) >> pbits;
		var cy = Std.int(e.y) >> pbits;
		#if debug
		if( cx < 0 || cy < 0 || cx >= pwidth || cy >= pheight ) throw "Position outside partition " + Std.int(e.x) + "," + Std.int(e.y);
		#end
		var cid = cx + cy * pwidth;
		if( e.partChunk == cid && e.partChunk != 0 )
			return;
		remove(e);
		var c = chunks[cid];
		e.partChunk = cid;
		e.partNext = c.elements;
		c.elements = e;
	}

	inline function removeFromChunk( c : PartitionChunk<T>, e : T ) {
		var prev : T = null;
		var cur = c.elements;
		while( cur != null ) {
			if( cur == e ) {
				if( prev == null )
					c.elements = e.partNext;
				else
					prev.partNext = e.partNext;
				break;
			}
			prev = cur;
			cur = cur.partNext;
		}
	}


	/**
		Removes an entity to our partition system.
		Multiple removes of the same entity does not have any side effect.
	**/
	public function remove( e : T ) {
		if( e.partChunk < 0 ) return;
		var c = chunks[e.partChunk];
		removeFromChunk(c, e);
		e.partChunk = -1;
	}

	/**
		After your entity position have changed, you can either call syncAll() or sync() for the entities that have moved.
		Please note that you don't have to call sync() for each change, but at least when the entity has moved a distance of the chunk size.
	**/
	public inline function sync( e : T ) {
		var cx = Std.int(e.x) >> pbits;
		var cy = Std.int(e.y) >> pbits;
		var cid = cx + cy * pwidth;
		if( e.partChunk != cid ) moveTo(e, cx, cy);
	}

	/**
		Force a complete refresh of entities partition. If only a few entities are moving, using sync() will be more efficient.
		If most of the entities are moving each frame, it is more efficient to call syncAll()
	**/
	public function syncAll() {
		for( c in chunks ) {
			var e = c.elements;
			var prev = null;
			var ox = c.x;
			var oy = c.y;
			while( e != null ) {
				var cx = Std.int(e.x) >> pbits;
				var cy = Std.int(e.y) >> pbits;
				if( cx == ox && cy == oy ) {
					prev = e;
					e = e.partNext;
					continue;
				}
				#if debug
				if( cx < 0 || cy < 0 || cx >= pwidth || cy >= pheight ) throw "Position outside partition " + Std.int(e.x) + "," + Std.int(e.y);
				#end

				// faster remove
				var next = e.partNext;
				if( prev == null )
					c.elements = next;
				else
					prev.partNext = next;

				var cid = cx + cy * pwidth;
				var cnew = chunks[cid];
				e.partChunk = cid;
				e.partNext = cnew.elements;
				cnew.elements = e;
				e = next;
			}
		}
	}

	function moveTo(e:T, cx, cy) {
		#if debug
		if( cx < 0 || cy < 0 || cx >= pwidth || cy >= pheight ) throw "Position outside partition " + Std.int(e.x) + "," + Std.int(e.y);
		var dx = (e.partChunk % pwidth) - cx;
		var dy = Std.int(e.partChunk / pwidth) - cy;
		if( dx < -1 || dx > 1 || dy < -1 || dy > 1 ) trace(e+" moved move than one chunk since last sync : might skip collide checks");
		#end
		removeFromChunk(chunks[e.partChunk], e);
		var cid = cx + cy * pwidth;
		var c = chunks[cid];
		e.partChunk = cid;
		e.partNext = c.elements;
		c.elements = e;
	}

}