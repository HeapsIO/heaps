package hxd.tools;

/**
 * Workaround to use lib format where a variable format is present
 */
class Format {
	#if hl
	public static inline function decodeDXT(src:hl.Bytes, dst:hl.Bytes, width:Int, height:Int, dxtFormat:Int):Bool {
		return format.hl.Native.decodeDXT(src, dst, width, height, dxtFormat);
	}
	#end
}
