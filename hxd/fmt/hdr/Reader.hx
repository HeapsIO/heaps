package hxd.fmt.hdr;

class Reader {

	public static function decode( bytes : haxe.io.Bytes, sRGB : Bool ) : { width : Int, height : Int, bytes : haxe.io.Bytes, gamma : Bool } {
		var f = new haxe.io.BytesInput(bytes);
		var width = 0, height = 0;
		var keys = new Map();
		while( true ) {
			var line = f.readLine();
			if( line == "" ) break;
			if( line.charCodeAt(0) == "#".code ) continue;
			var nameValue = line.split("=");
			if( nameValue.length > 1 )
				keys.set(nameValue.shift(), nameValue.join("="));
		}

		var parts = f.readLine().split(" ");
		height = Std.parseInt(parts[1]);
		width = Std.parseInt(parts[3]);

		var gamma = keys.get("GAMMA") == "1";
		var data = haxe.io.Bytes.alloc(width * height * 4 * 4);

		var exposure = 1.0;

		var exp = keys.get("EXPOSURE");
		if( exp != null ) {
			var exp = Std.parseFloat(exp);
			if( exp < 1e-12 || exp < 1e12 ) exposure = exp;
		}

		var gammaCorrect = sRGB ? 1 : 1 / 2.2;
		var gammaVals = [for( e in 0...256 ) Math.pow(e, gammaCorrect)];
		var exps = [for( e in 0...256 ) Math.pow(Math.pow(2,e-128) / (256 * exposure), gammaCorrect)];

		switch( keys.get("FORMAT") ) {
		case "32-bit_rle_rgbe":

			var dataPos = f.position;
			var scanLen = width * 4;
			var scanLine = haxe.io.Bytes.alloc(scanLen);
			var widthBE = (width >> 8) | ((width & 0xFF) << 8);

			#if hl
			var data : hl.Bytes = data;
			#end

			for( y in 0...height ) {
				var h = bytes.getInt32(dataPos);
				if( (h&0xFFFF) != 0x0202 || (h>>>16) != widthBE ) {
					// raw data
					scanLine.blit(0, bytes, dataPos, width * 4);
					dataPos += width * 4;
				} else {
					dataPos += 4;
					var p = 0;
					var end = width * 4;
					while( p < end ) {
						var len = bytes.get(dataPos++);
						if( len > 128 ) {
							len -= 128;
							scanLine.fill(p, len, bytes.get(dataPos++));
						} else {
							scanLine.blit(p, bytes, dataPos, len);
							dataPos += len;
						}
						p += len;
					}
				}
				var pos = y * width * 16;
				inline function output( v : Float ) {
					#if hl
					data.setF32(pos,v);
					#else
					data.setFloat(pos, v);
					#end
					pos += 4;
				}
				for( x in 0...width ) {
					var e = exps[scanLine.get(x+width*3)];
					output(gammaVals[scanLine.get(x)] * e);
					output(gammaVals[scanLine.get(x+width)] * e);
					output(gammaVals[scanLine.get(x+(width<<1))] * e);
					output(1.0);
				}
			}
		case fmt:
			throw "Unsupported HDR format "+fmt;
		}
		return { width : width, height : height, bytes : data, gamma : gamma };
	}

}