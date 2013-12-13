package hxd;

import haxe.ds.StringMap;
import haxe.Timer;

/**
 * author Motion-Twin
 */
class Profiler{
	public static var enable : Bool = true;
	
	static var inst : Profiler;
	static var min_limit = 0.0001;
	static var h : StringMap< { start:Null<Float>, total:Float, hit : Int}> = new haxe.ds.StringMap();
	
	public static inline 
	function begin( tag )
	{
		if ( enable )
		{
			var t = Timer.stamp();
			
			var ent = h.get( tag );
			if (null==ent)
			{
				ent = { start:null, total:0.0, hit:0 };
				h.set( tag,ent );
			}

			ent.start = t;
			ent.hit++;
		}
	}
	
	public static inline 
	function end( tag )
	{
		if ( enable )
		{
			var t = Timer.stamp();
			var ent = h.get( tag );
			
			if (null!=ent)
				if ( ent.start != null )
					ent.total += (t ) - ent.start;
		}
	}
	
	/**
	 * Clears a single tag
	 */
	public static inline 
	function clear( tag )
	{
		if ( enable )
		{
			h.remove( tag);
		}
	}

	/**
	 * Cleans the whole data set
	 */
	public static inline 
	function clean()
	{
		if ( enable )
		{
			h = new StringMap();
		}
	}
	
	public static inline 
	function spent( tag )
	{
		if ( !enable ) return 0.0;
		return h.get( tag ).total;
	}
	
	public static inline 
	function hit( tag )
	{
		if ( !enable ) return 0.0;
		return h.get( tag ).hit;
	}
	
	public static inline 
	function dump( ?trunkValues = true ) : String
	{
		var s = "";
		var trunk = function(v:Float) return trunkValues ? (Std.int( v * 10000.0 ) * 0.0001) : v;
		for(k in h.keys())
		{
			var sp = spent(k);
			var ht = hit(k);
			
			if (sp <= min_limit ) continue;
			
			s+=("tag: "+k+" spent: " + trunk(sp))+" hit:"+ht+" avg time: "+ trunk(sp/ht) +"<br/>";
		}
		return s;
	}
}