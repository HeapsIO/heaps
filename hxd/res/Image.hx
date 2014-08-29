package hxd.res;

class Image extends Resource {

	/**
		Specify if we will automatically convert non-power-of-two textures to power-of-two.
	**/
	public static var ALLOW_NPOT = #if flash11_8 true #else false #end;
	public static var DEFAULT_FILTER : h3d.mat.Data.Filter = Linear;

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

	function watchCallb() {
		var w = inf.width, h = inf.height;
		inf = null;
		var s = getSize();
		if( w != s.width || h != s.height )
			tex.resize(w, h);
		tex.realloc = null;
		loadTexture();
	}

	function loadTexture() {
		if( inf.isPNG ) {
			function load() {
				// immediately loading the PNG is faster than going through loadBitmap
				tex.alloc();
				var pixels = getPixels();
				if( pixels.width != tex.width || pixels.height != tex.height )
					pixels.makeSquare();
				tex.uploadPixels(pixels);
				pixels.dispose();
				tex.realloc = loadTexture;
				watch(watchCallb);
			}
			if( entry.isAvailable )
				load();
			else
				entry.load(load);
		} else {
			// use native decoding
			entry.loadBitmap(function(bmp) {
				var bmp = bmp.toBitmap();
				tex.alloc();
				if( bmp.width != tex.width || bmp.height != tex.height ) {
					var pixels = bmp.getPixels();
					pixels.makeSquare();
					tex.uploadPixels(pixels);
					pixels.dispose();
				} else
					tex.uploadBitmap(bmp);
				bmp.dispose();
				tex.realloc = loadTexture;
				watch(watchCallb);
			});
		}
	}

	public function toTexture() : h3d.mat.Texture {
		if( tex != null )
			return tex;
		getSize();
		var width = inf.width, height = inf.height;
		if( !ALLOW_NPOT ) {
			var tw = 1, th = 1;
			while( tw < width ) tw <<= 1;
			while( th < height ) th <<= 1;
			width = tw;
			height = th;
		}
		tex = new h3d.mat.Texture(width, height, [NoAlloc]);
		if( DEFAULT_FILTER != Linear ) tex.filter = DEFAULT_FILTER;
		tex.setName(entry.path);
		loadTexture();
		return tex;
	}

	public function toTile() : h2d.Tile {
		var size = getSize();
		return h2d.Tile.fromTexture(toTexture()).sub(0, 0, size.width, size.height);
	}

}