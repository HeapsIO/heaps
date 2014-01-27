package hxd.res;

class Image extends Resource {
	
	var needResize : Bool;
	var tex : h3d.mat.Texture;
	var inf : { width : Int, height : Int, isPNG : Bool };
	
	public function isPNG() {
		getSize();
		return inf.isPNG;
	}

	function checkResize() {
		if( !needResize ) return;
		var tw = tex.width, th = tex.height;
		@:privateAccess {
			tex.width = 1;
			tex.height = 1;
		}
		tex.resize(tw,th);
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
			var pixels = Pixels.alloc(inf.width, inf.height, BGRA);
			format.png.Tools.extract32(png.read(), pixels.bytes);
			return pixels;
		} else {
			var bytes = entry.getBytes();
			var p = NanoJpeg.decode(bytes);
			return new Pixels(p.width,p.height,p.pixels, BGRA);
		}
	}
	
	public function toBitmap() : hxd.BitmapData {
		getSize();
		var bmp = new hxd.BitmapData(inf.width, inf.height);
		var pixels = getPixels();
		bmp.setPixels(pixels);
		pixels.dispose();
		return bmp;
	}
	
	function loadTexture() {
		var tw = tex.width, th = tex.height;
		var w =	inf.width, h = inf.height;
		var isSquare = w == tw && h == th;
		if( inf.isPNG ) {
			function load() {
				checkResize();

				// immediately loading the PNG is faster than going through loadBitmap
				var pixels = getPixels();
				pixels.makeSquare();
				tex.uploadPixels(pixels);
				pixels.dispose();
			}
			if( entry.isAvailable )
				load();
			else
				entry.load(load);
		} else {
			// use native decoding
			entry.loadBitmap(function(bmp) {
				checkResize();

				if( isSquare )
					tex.uploadBitmap(bmp);
				else {
					var pixels = bmp.getPixels();
					pixels.makeSquare();
					tex.uploadPixels(pixels);
					pixels.dispose();
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
			tex = h3d.mat.Texture.fromColor(0xFF0000FF);
			needResize = true;
			@:privateAccess {
				tex.width = tw;
				tex.height = th;
			}
		}
		loadTexture();
		tex.setName(entry.path);
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