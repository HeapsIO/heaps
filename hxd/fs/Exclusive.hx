package hxd.fs;

class Exclusive {

	#if heaps_mt_loader
	static var e_lock = new sys.thread.Mutex();
	#end

	public static inline function lock<T>( f : Void -> T ) {
		#if heaps_mt_loader
		e_lock.acquire();
		#end
		var ret = f();
		#if heaps_mt_loader
		e_lock.release();
		#end
		return ret;
	}

}