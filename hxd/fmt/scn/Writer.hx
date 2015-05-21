package hxd.fmt.scn;
import hxd.fmt.scn.Data;

class Writer {

	var out : haxe.io.BytesBuffer;

	public function new() {
		out = new haxe.io.BytesBuffer();
	}

	public function write( d : Data ) {
		out.addByte(d.version);
		for( op in d.ops ) {
			out.addByte(op.getIndex());
			switch( op ) {
			case Log(str):
				out.addInt32(str.length);
				out.addString(str);
			case Begin, Reset, Present:
			case Clear(color, depth, stencil):
				out.addByte((color == null ? 0 : 1) | (depth == null ? 0 : 2) | (stencil == null ? 0 : 4));
				if( color != null ) {
					out.addFloat(color.r);
					out.addFloat(color.g);
					out.addFloat(color.b);
					out.addFloat(color.a);
				}
				if( depth != null )
					out.addFloat(depth);
				if( stencil != null )
					out.addInt32(stencil);
			case Resize(w, h):
				out.addInt32(w);
				out.addInt32(h);
			case SelectShader(id, data):
				out.addInt32(id);
				if( data != null ) out.addBytes(data, 0, data.length);
			case Material(bits):
				out.addInt32(bits);
			case UploadShaderTextures(vertex, fragment):
				out.addByte(vertex.length);
				for( t in vertex )
					out.addInt32(t);
				out.addByte(fragment.length);
				for( t in fragment )
					out.addInt32(t);
			case UploadShaderBuffers(g, vertex, fragment):
				out.addByte(g?1:0);
				out.addInt32(vertex.length);
				for( v in vertex )
					out.addFloat(v);
				out.addInt32(fragment.length);
				for( v in fragment )
					out.addFloat(v);
			case AllocTexture(id, name, w, h, flags):
				out.addInt32(id);
				if( name == null )
					out.addInt32( -1);
				else {
					out.addInt32(name.length);
					out.addString(name);
				}
				out.addInt32(w);
				out.addInt32(h);
				out.addInt32(flags.toInt());
			case AllocIndexes(id, count):
				out.addInt32(id);
				out.addInt32(count);
			case AllocVertexes(id, stride, count, flags):
				out.addInt32(id);
				out.addInt32(stride);
				out.addInt32(count);
				out.addInt32(flags.toInt());
			case UploadTexture(id, pixels, mipMap, side):
				out.addInt32(id);
				out.addInt32(pixels.width);
				out.addInt32(pixels.height);
				out.addInt32(pixels.format.getIndex());
				out.addInt32(pixels.flags.toInt());
				out.add(pixels.bytes);
			case UploadVertexes(id, start, count, data):
				out.addInt32(id);
				out.addInt32(start);
				out.addInt32(count);
				out.addInt32(data.length);
				out.add(data);
			case UploadIndexes(id, start, count, data):
				out.addInt32(id);
				out.addInt32(start);
				out.addInt32(count);
				out.addInt32(data.length);
				out.add(data);
			case RenderTarget(id), DisposeIndexes(id), DisposeTexture(id), DisposeVertexes(id):
				out.addInt32(id);
			}
		}
		return out.getBytes();
	}

}