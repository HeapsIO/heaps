package hxd.fmt.h3d;
import hxd.fmt.h3d.Data;

class Writer {

	var out : haxe.io.Output;

	public function new(out) {
		this.out = out;
	}

	function writeName( name : String ) {
		if( name == null ) {
			out.writeByte(0xFF);
			return;
		}
		#if (flash || js)
		out.writeByte(haxe.io.Bytes.ofString(name).length);
		#else
		out.writeByte(name.length);
		#end
		out.writeString(name);
 	}

	function writePosition( p : Position ) {
		out.writeFloat(p.x);
		out.writeFloat(p.y);
		out.writeFloat(p.z);
		out.writeFloat(p.rx);
		out.writeFloat(p.ry);
		out.writeFloat(p.rz);
		out.writeFloat(p.sx);
		out.writeFloat(p.sy);
		out.writeFloat(p.sz);
	}

	public function write( d : Data ) {
		var old = out;
		var header = new haxe.io.BytesOutput();
		out = header;

		out.writeInt32(d.geometries.length);
		for( g in d.geometries ) {
			out.writeInt32(g.vertexCount);
			out.writeByte(g.vertexStride);
			out.writeByte(g.vertexFormat.length);
			for( f in g.vertexFormat ) {
				writeName(f.name);
				out.writeByte(f.format.getIndex());
			}
			out.writeInt32(g.vertexPosition);
			out.writeInt32(g.indexCount);
			out.writeInt32(g.indexPosition);
		}
		out.writeInt32(d.materials.length);
		for( m in d.materials ) {
			writeName(m.name);
			writeName(m.diffuseTexture);
			out.writeByte(m.blendMode.getIndex());
			out.writeByte(m.culling.getIndex());
			out.writeFloat(m.killAlpha == null ? 1 : m.killAlpha);
		}
		out.writeInt32(d.models.length);
		for( m in d.models ) {
			writeName(m.name);
			out.writeInt32(m.parent);
			writePosition(m.position);
			out.writeByte(m.geometries == null ? 0 : m.geometries.length);
			if( m.geometries == null ) continue;
			if( m.materials == null || m.materials.length != m.geometries.length ) throw "assert";
			for( g in m.geometries )
				out.writeInt32(g);
			for( m in m.materials )
				out.writeInt32(m);
		}

		var bytes = header.getBytes();
		out = old;

		out.writeString("H3D");
		out.writeByte(d.version);
		out.writeInt32(bytes.length);
		out.write(bytes);
		out.writeInt32(d.data.length);
		out.write(d.data);
	}

}