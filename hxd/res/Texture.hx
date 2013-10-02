package hxd.res;

class Texture extends Resource {
	
	static var TMP = {
		var b = haxe.io.Bytes.alloc(4);
		b.set(0, 0xFF);
		b.set(1, 0x80);
		b.set(2, 0x80);
		b.set(3, 0xFF);
		b;
	}
	
	var needResize : Bool;
	var tex : h3d.mat.Texture;
	var inf : { width : Int, height : Int, isPNG : Bool };
	
	public function isPNG() {
		getSize();
		return inf.isPNG;
	}
	
	public function getSize() : { width : Int, height : Int } {
		if( inf != null )
			return inf;
		var f = new FileInput(entry);
		var width = 0, height = 0, isPNG = false;
		switch( f.readUInt16() ) {
		case 0xD8FF: // JPG
			f.bigEndian = true;
			while( true ) {
				switch( f.readUInt16() ) {
				case 0xFFC2, 0xFFC0:
					var len = f.readUInt16();
					var prec = f.readByte();
					height = f.readUInt16();
					width = f.readUInt16();
					break;
				default:
					f.skip(f.readUInt16() - 2);
				}
			}
		case 0x5089: // PNG
			isPNG = true;
			var TMP = hxd.impl.Tmp.getBytes(256);
			f.bigEndian = true;
			f.readBytes(TMP, 0, 6);
			while( true ) {
				var dataLen = f.readInt32();
				if( f.readInt32() == ('I'.code << 24) | ('H'.code << 16) | ('D'.code << 8) | 'R'.code ) {
					width = f.readInt32();
					height = f.readInt32();
					break;
				}
				// skip data
				while( dataLen > 0 ) {
					var k = dataLen > TMP.length ? TMP.length : dataLen;
					f.readBytes(TMP, 0, k);
					dataLen -= k;
				}
				var crc = f.readInt32();
			}
			hxd.impl.Tmp.saveBytes(TMP);
		default:
			throw "Unsupported texture format " + entry.path;
		}
		f.close();
		inf = { width : width, height : height, isPNG : isPNG };
		return inf;
	}
	
	public function getPixels() {
		getSize();
		if( inf.isPNG ) {
			var png = new format.png.Reader(new haxe.io.BytesInput(entry.getBytes()));
			png.checkCRC = false;
			var bytes = hxd.impl.Tmp.getBytes(inf.width * inf.height * 4);
			format.png.Tools.extract32(png.read(), bytes);
			return bytes;
		} else {
			throw "getPixels not supported for " + name;
			return null;
		}
	}
	
	public function toBitmap() : hxd.BitmapData {
		var bmp = null;
		#if flash
		var size = getSize();
		bmp = new flash.display.BitmapData(size.width, size.height, true, 0);
		var bytes = getPixels();
		bmp.setPixels(bmp.rect, bytes.getData());
		hxd.impl.Tmp.saveBytes(bytes);
		#end
		return hxd.BitmapData.fromNative(bmp);
	}
	
	function makeSquare( bmp : haxe.io.Bytes ) {
		var tw = tex.width, th = tex.height, w = inf.width, h = inf.height;
		var out = hxd.impl.Tmp.getBytes(tw * th * 4);
		var p = 0, b = 0;
		for( y in 0...h ) {
			out.blit(p, bmp, b, w * 4);
			p += w * 4;
			b += w * 4;
			for( i in 0...(tw - w) * 4 )
				out.set(p++, 0);
		}
		for( i in 0...(th - h) * tw * 4 )
			out.set(p++, 0);
		hxd.impl.Tmp.saveBytes(bmp);
		return out;
	}
	
	function loadTexture() {
		var tw = tex.width, th = tex.height;
		var w =	inf.width, h = inf.height;
		var isSquare = w == tw && h == th;
		if( inf.isPNG ) {
			function load() {
				if( needResize ) {
					tex.resize(tw, th);
					needResize = false;
				}
				// immediately loading the PNG is faster than going through loadBitmap
				var bytes = getPixels();
				if( !isSquare ) bytes = makeSquare(bytes);
				tex.uploadBytes(bytes);
				hxd.impl.Tmp.saveBytes(bytes);
			}
			if( entry.isAvailable )
				load();
			else
				entry.load(load);
		} else {
			// use native decoding
			entry.loadBitmap(function(bmp) {
				if( needResize ) {
					tex.resize(tw, th);
					needResize = false;
				}
				if( isSquare )
					tex.uploadBitmap(bmp);
				else {
					var bytes = makeSquare(bmp.getBytes());
					tex.uploadBytes(bytes);
					hxd.impl.Tmp.saveBytes(bytes);
				}
				bmp.dispose();
			});
		}
	}
	
	public function toTexture() : h3d.mat.Texture {
		if( tex != null && !tex.isDisposed() )
			return tex;
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		getSize();
		var w = inf.width, h = inf.height;
		var tw = 1, th = 1;
		while( tw < w ) tw <<= 1;
		while( th < h ) th <<= 1;

		if( inf.isPNG && entry.isAvailable ) {
			// direct upload
			needResize = false;
			tex = h3d.Engine.getCurrent().mem.allocTexture(tw, th, false);
		} else {
			// create a temp 1x1 texture while we're loading
			needResize = true;
			tex = h3d.Engine.getCurrent().mem.allocTexture(1, 1, false);
			tex.uploadBytes(TMP);
			@:privateAccess {
				tex.width = tw;
				tex.height = th;
			}
		}
		
		loadTexture();
		tex.onContextLost = function() {
			needResize = false;
			loadTexture();
			return true;
		};
		return tex;
	}
	
	public function toTile() : h2d.Tile {
		var size = getSize();
		return h2d.Tile.fromTexture(toTexture()).sub(0, 0, size.width, size.height);
	}
	
}