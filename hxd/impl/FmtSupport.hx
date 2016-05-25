package hxd.impl;

#if hl

@:enum private abstract PixelFormat(Int) {
  var RGB = 0;
  var BGR = 1;
  var RGBX = 2;
  var BGRX = 3;
  var XBGR = 4;
  var XRGB = 5;
  var GRAY = 6;
  var RGBA = 7;
  var BGRA = 8;
  var ABGR = 9;
  var ARGB = 10;
  var CMYK = 11;
}

@:hlNative("fmt")
class FmtSupport {

	public static function decodeJPG( src : haxe.io.Bytes, width : Int, height : Int, fmt : hxd.PixelFormat, flipY : Bool ) {
		var ifmt : PixelFormat = switch( fmt ) {
		case RGBA: RGBA;
		case BGRA: BGRA;
		case ARGB: ARGB;
		default:
			fmt = BGRA;
			BGRA;
		};
		var dst = hxd.impl.Tmp.getBytes(width * height * 4);
		if( !jpg_decode(src.getData(), src.length, dst.getData(), width, height, width * 4, ifmt, (flipY?1:0)) ) {
			hxd.impl.Tmp.saveBytes(dst);
			return null;
		}
		var pix = new hxd.Pixels(width, height, dst, fmt);
		if( flipY ) pix.flags.set(FlipY);
		pix.convert(fmt);
		return pix;
	}

	static function jpg_decode( src : hl.types.Bytes, srcLen : Int, dst : hl.types.Bytes, width : Int, height : Int, stride : Int, format : PixelFormat, flags : Int ) : Bool {
		return false;
	}

	@:hlNative("fmt","img_scale")
	public static function scaleImage( out : hl.types.Bytes, outPos : Int,  outStride : Int, outWidth : Int, outHeight : Int, _in : hl.types.Bytes, inPos : Int,  inStride : Int, inWidth : Int, inHeight : Int, flags : Int ) {
	}

}
#end