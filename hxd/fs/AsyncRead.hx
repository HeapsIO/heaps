package hxd.fs;

#if (haxe_ver >= 5)
private typedef ThreadLoop = haxe.EventLoop;
#elseif target.threaded
private typedef ThreadLoop = sys.thread.EventLoop;
#else
private typedef ThreadLoop = Dynamic;
#end

enum abstract AsyncReadState(Int) {
	var Pending;
	var Reading;
	var Done;
	var Cancelled;
}

/**
	A pending asynchronous read, returned by `FileEntry.readBytesAsync`.
	The `out` bytes must not be accessed until the read is done.
**/
class AsyncRead {

	public var entry(default, null) : FileEntry;
	public var out(default, null) : haxe.io.Bytes;
	public var outPos(default, null) : Int;
	public var pos(default, null) : Int;
	public var len(default, null) : Int;
	/**
		Requests with higher priority are read first. Can be modified while the request is pending.
	**/
	public var priority : Float;
	public var state(default, null) : AsyncReadState = Pending;
	/**
		Number of bytes read, once the read is done.
	**/
	public var bytesRead(default, null) : Int = 0;

	var onDone : Int -> Void;
	var error : Dynamic;
	var loop : ThreadLoop;

	function new(entry, out, outPos, pos, len, onDone, priority) {
		this.entry = entry;
		this.out = out;
		this.outPos = outPos;
		this.pos = pos;
		this.len = len;
		this.onDone = onDone;
		this.priority = priority;
	}

	/**
		Cancel the read : the onDone callback will not be called.
		If the read was already in progress, the `out` bytes might still be written until it completes.
	**/
	public function cancel() {
		AsyncReader.cancel(this);
	}

	function finish() {
		if( state == Cancelled ) return;
		state = Done;
		if( error != null ) {
			var e = error;
			error = null;
			throw e;
		}
		onDone(bytesRead);
	}

}

/**
	Reads file data asynchronously : a single IO thread is shared by all file systems,
	reading the pending requests by priority order.

	The completion callback is called in the thread that requested the read, through its event loop
	(the main thread loop is run by heaps, other threads need to have an event loop running).

	When async reads are not supported (non-threaded target, or ENABLED=false),
	the reads are emulated : they are done synchronously at the next event loop of the calling thread,
	in requests order, and the callbacks are called the same way.
**/
@:access(hxd.fs.AsyncRead)
class AsyncReader {

	/**
		Set to false to emulate all async reads synchronously.
	**/
	public static var ENABLED = true;

	static var inst : AsyncReader;

	var pending : Array<AsyncRead> = [];
	#if target.threaded
	var mutex : sys.thread.Mutex;
	var signal : sys.thread.Lock;
	#end

	function new() {
		#if target.threaded
		mutex = new sys.thread.Mutex();
		signal = new sys.thread.Lock();
		sys.thread.Thread.create(threadLoop);
		#end
	}

	public static function isAsync() {
		return #if target.threaded ENABLED #else false #end;
	}

	public static function read( entry : FileEntry, out : haxe.io.Bytes, outPos : Int, pos : Int, len : Int, onDone : Int -> Void, priority : Float ) {
		var r = new AsyncRead(entry, out, outPos, pos, len, onDone, priority);
		r.loop = currentLoop();
		promise(r.loop);
		#if target.threaded
		if( isAsync() ) {
			if( inst == null ) inst = new AsyncReader();
			inst.mutex.acquire();
			inst.pending.push(r);
			inst.mutex.release();
			inst.signal.release();
			return r;
		}
		#end
		post(r.loop, function() {
			if( r.state == Pending ) {
				r.state = Reading;
				doRead(r);
			}
			r.finish();
		});
		return r;
	}

	@:allow(hxd.fs.AsyncRead) static function cancel( r : AsyncRead ) {
		if( inst != null ) inst.lock();
		switch( r.state ) {
		case Pending:
			// emulated reads are not in the pending list, they will be skipped when run
			if( inst != null && inst.pending.remove(r) )
				post(r.loop, function() {}); // deliver the promise
			r.state = Cancelled;
		case Reading:
			r.state = Cancelled;
		default:
		}
		if( inst != null ) inst.unlock();
	}

	static inline function currentLoop() : ThreadLoop {
		#if (haxe_ver >= 5)
		return haxe.EventLoop.current;
		#elseif target.threaded
		return sys.thread.Thread.current().events;
		#else
		return null;
		#end
	}

	/**
		Prevents the requesting thread event loop from terminating while the read is pending.
	**/
	static inline function promise( loop : ThreadLoop ) {
		#if (haxe_ver >= 5 || target.threaded)
		loop.promise();
		#end
	}

	/**
		Runs the callback in the requesting thread event loop and delivers the promise.
	**/
	static function post( loop : ThreadLoop, callb : Void -> Void ) {
		#if (haxe_ver >= 5)
		loop.run(function() {
			loop.deliver();
			callb();
		});
		#elseif target.threaded
		loop.runPromised(callb);
		#else
		haxe.MainLoop.runInMainThread(callb);
		#end
	}

	inline function lock() {
		#if target.threaded mutex.acquire(); #end
	}

	inline function unlock() {
		#if target.threaded mutex.release(); #end
	}

	function popNext() {
		var best = null;
		var bestIndex = -1;
		for( i in 0...pending.length ) {
			var r = pending[i];
			if( best == null || r.priority > best.priority ) {
				best = r;
				bestIndex = i;
			}
		}
		if( best != null ) {
			pending.splice(bestIndex, 1);
			best.state = Reading;
		}
		return best;
	}

	static function doRead( r : AsyncRead ) {
		try {
			r.bytesRead = r.entry.readBytes(r.out, r.outPos, r.pos, r.len);
		} catch( e : Dynamic ) {
			r.error = e;
		}
	}

	#if target.threaded
	function threadLoop() {
		#if hl
		hl.Profile.event(-8); // mark thread as invisible for debugger
		#end
		while( true ) {
			signal.wait();
			mutex.acquire();
			var r = popNext();
			mutex.release();
			if( r == null ) continue; // cancelled
			doRead(r);
			post(r.loop, r.finish);
		}
	}
	#end

}
