package hxd.fmt.scn;
import hxd.fmt.scn.Data;

class Reader {

	var i : haxe.io.Input;

	public function new( i : haxe.io.Input ) {
		this.i = i;
	}

	public function read() : Data {
		return {
			version : i.readByte(),
			ops : [for( i in 0...i.readInt32() ) readOp()]
		};
	}

	function readOp() {
		var tag = i.readByte();
		return switch( tag ) {
		case 0:
			Log(i.readString(i.readInt32()));
		case 1:
			Begin;
		case 2:
			var bits = i.readByte();
			Clear(
				bits & 1 == 0 ? null : new h3d.Vector(i.readFloat(), i.readFloat(), i.readFloat(), i.readFloat()),
				bits & 2 == 0 ? null : i.readFloat(),
				bits & 4 == 0 ? null : i.readInt32()
			);
		case 3:
			Reset;
		case 4:
			Resize(i.readInt32(), i.readInt32());
		case 5:
			var id = i.readInt32();
			var len = i.readInt32();
			SelectShader(id, len == 0 ? null : i.read(len));
		case 6:
			Material(i.readInt32());
		case 7:
			UploadShaderBuffers(i.readByte() == 1, [for( k in 0...i.readInt32() ) i.readFloat()], [for( k in 0...i.readInt32() ) i.readFloat()]);
		case 8:
			UploadShaderTextures([for( k in 0...i.readByte() ) i.readInt32()], [for( k in 0...i.readByte() ) i.readInt32()]);
		case 9:
			var id = i.readInt32();
			var len = i.readInt32();
			AllocTexture(id, len < 0 ? null : i.readString(len), i.readInt32(), i.readInt32(), haxe.EnumFlags.ofInt(i.readInt32()));
		case 10:
			AllocIndexes(i.readInt32(), i.readInt32());
		case 11:
			AllocVertexes(i.readInt32(), i.readInt32(), i.readInt32(), haxe.EnumFlags.ofInt(i.readInt32()) );
		case 12:
			DisposeTexture(i.readInt32());
		case 13:
			DisposeIndexes(i.readInt32());
		case 14:
			DisposeVertexes(i.readInt32());
		case 15:
			var id = i.readInt32();
			var w = i.readInt32();
			var h = i.readInt32();
			var format = hxd.PixelFormat.createByIndex(i.readInt32());
			var flags = haxe.EnumFlags.ofInt(i.readInt32());
			var pixels = new hxd.Pixels(w, h, i.read(w * h * 4), format);
			pixels.flags = flags;
			UploadTexture(id, pixels, i.readInt32(), i.readByte());
		case 16:
			UploadIndexes(i.readInt32(), i.readInt32(), i.readInt32(), i.read(i.readInt32()) );
		case 17:
			UploadVertexes(i.readInt32(), i.readInt32(), i.readInt32(), i.read(i.readInt32()) );
		case 18:
			SelectBuffer(i.readInt32(), i.readByte() != 0 );
		case 19:
			SelectMultiBuffer([for( k in 0...i.readByte() ) { vbuf : i.readInt32(), offset : i.readByte() } ]);
		case 20:
			Draw(i.readInt32(), i.readInt32(), i.readInt32());
		case 21:
			RenderZone(i.readInt32(), i.readInt32(), i.readInt32(), i.readInt32());
		case 22:
			RenderTarget(i.readInt32());
		case 23:
			Present;
		case x:
			throw "Invalid SCN tag " + x;
		}
	}

}