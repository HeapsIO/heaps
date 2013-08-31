package hxd.res;

class Texture extends Resource {
	
	var tex : h3d.mat.Texture;
	var size : { width : Int, height : Int };
	
	public function getSize() : { width : Int, height : Int } {
		if( size != null )
			return size;
		var f = new FileInput(entry);
		var width = 0, height = 0;
		switch( f.readUInt16() ) {
		case 0xD8FF: // JPG
			f.bigEndian = true;
			throw "TODO";
		case 0x5089: // PNG
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
			throw "Unsupported file format " + entry.name;
		}
		f.close();
		size = { width : width, height : height };
		return size;
	}
	
	function loadTexture() {
		var tw = tex.width, th = tex.height;
		var w =	size.width, h = size.height;
		var isSquare = w == tw && h == th;
		entry.loadBitmap(function(bmp) {
			if( isSquare )
				tex.uploadBitmap(bmp);
			else {
				var out = hxd.impl.Tmp.getBytes(tw * th * 4);
				var bmp = bmp.getBytes();
				var p = 0, b = 0;
				for( y in 0...h ) {
					for( x in 0...w * 4 )
						out.set(p++, bmp.get(b++));
					for( i in 0...(tw - w) * 4 )
						out.set(p++, 0);
				}
				for( i in 0...(th - h) * tw )
					out.set(p++, 0);
				hxd.impl.Tmp.saveBytes(bmp);
				tex.uploadBytes(out);
				hxd.impl.Tmp.saveBytes(out);
			}
			bmp.dispose();
		});
	}
	
	public function toTexture( ?hasAlpha : Bool ) : h3d.mat.Texture {
		if( tex != null && !tex.isDisposed() )
			return tex;
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		var size = getSize();
		var w = size.width, h = size.height;
		var tw = 1, th = 1;
		while( tw < w ) tw <<= 1;
		while( th < h ) th <<= 1;
		tex = h3d.Engine.getCurrent().mem.allocTexture(tw, th, false);
		loadTexture();
		tex.onContextLost = function() {
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