package hxd.fmt.hmd;
import hxd.fmt.hmd.Data;

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

	inline function writeFloat( f : Float ) {
		out.writeFloat( f == 0 ? 0 : f ); // prevent negative zero
	}

	function writePosition( p : Position, hasScale = true ) {
		writeFloat(p.x);
		writeFloat(p.y);
		writeFloat(p.z);
		writeFloat(p.qx);
		writeFloat(p.qy);
		writeFloat(p.qz);
		if( hasScale ) {
			writeFloat(p.sx);
			writeFloat(p.sy);
			writeFloat(p.sz);
		}
	}

	function writeBounds( b : h3d.col.Bounds ) {
		writeFloat(b.xMin);
		writeFloat(b.yMin);
		writeFloat(b.zMin);
		writeFloat(b.xMax);
		writeFloat(b.yMax);
		writeFloat(b.zMax);
	}

	function writeSkin( s : Skin ) {
		writeName(s.name == null ? "" : s.name);
		out.writeUInt16(s.joints.length);
		for( j in s.joints ) {
			writeName(j.name);
			var rot = j.position.sx != 1 || j.position.sy != 1 || j.position.sz != 1 || (j.transpos != null && (j.transpos.sx != 1 || j.transpos.sy != 1 || j.transpos.sz != 1));
			out.writeUInt16( (j.parent + 1) | (rot?0x8000:0) );
			writePosition(j.position, rot);
			out.writeUInt16(j.bind + 1);
			if( j.bind >= 0 )
				writePosition(j.transpos, rot);
		}
		out.writeByte(s.split == null ? 0 : s.split.length);
		if( s.split != null ) {
			for( ss in s.split ) {
				out.writeByte(ss.materialIndex);
				out.writeByte(ss.joints.length);
				for( i in ss.joints )
					out.writeUInt16(i);
			}
		}
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
				out.writeByte(f.format.toInt());
			}
			out.writeInt32(g.vertexPosition);
			out.writeByte(g.indexCounts.length);
			for( i in g.indexCounts )
				out.writeInt32(i);
			out.writeInt32(g.indexPosition);
			writeBounds(g.bounds);
		}

		out.writeInt32(d.materials.length);
		for( m in d.materials ) {
			writeName(m.name);
			writeName(m.diffuseTexture);
			out.writeByte(m.blendMode.getIndex());
			out.writeByte(m.culling.getIndex());
			writeFloat(m.killAlpha == null ? 1 : m.killAlpha);
		}

		out.writeInt32(d.models.length);
		for( m in d.models ) {
			writeName(m.name);
			out.writeInt32(m.parent + 1);
			writeName(m.follow);
			writePosition(m.position);
			out.writeInt32(m.geometry + 1);
			if( m.geometry < 0 ) continue;
			out.writeByte(m.materials.length);
			for( m in m.materials )
				out.writeInt32(m);
			if( m.skin == null )
				writeName(null);
			else
				writeSkin(m.skin);
		}

		out.writeInt32(d.animations.length);
		for( a in d.animations ) {
			writeName(a.name);
			out.writeInt32(a.frames);
			writeFloat(a.sampling);
			writeFloat(a.speed);
			out.writeByte(a.loop?1:0);
			out.writeInt32(a.dataPosition);
			out.writeInt32(a.objects.length);
			for( o in a.objects ) {
				writeName(o.name);
				out.writeByte(o.flags.toInt());
			}
		}

		var bytes = header.getBytes();
		out = old;

		out.writeString("HMD");
		out.writeByte(d.version);
		out.writeInt32(bytes.length + 12);
		out.write(bytes);
		out.writeInt32(d.data.length);
		out.write(d.data);
	}

}