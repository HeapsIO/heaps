package hxd.fmt.hmd;
import hxd.fmt.hmd.Data;

class Writer {

	var out : haxe.io.Output;
	var version : Int;

	public function new(out) {
		this.out = out;
	}

	function writeProperty( p : Property<Dynamic> ) {
		out.writeByte(p.getIndex());
		switch( p ) {
		case CameraFOVY(v):
			out.writeFloat(v);
		case Unused_HasMaterialFlags:
		case HasExtraTextures:
		case FourBonesByVertex:
		case HasLod:
		case HasCollider:
		case HasColliders:
		case HasCustomCollider:
		}
	}

	function writeProps( props : Properties ) {
		if( props == null ) {
			if( version == 1 )
				return;
			out.writeByte(0);
			return;
		}
		if( version == 1 )
			throw "Properties not supported in HMDv1";
		out.writeByte(props.length);
		for( p in props )
			writeProperty(p);
	}

	function writeName( name : String ) {
		if ( name == "" )
			throw "?";
		if( name == null ) {
			out.writeByte(0xFF);
			return;
		}
		#if js
		out.writeByte(haxe.io.Bytes.ofString(name).length);
		#else
		out.writeByte(name.length);
		#end
		out.writeString(name);
 	}

	inline function writeFloat( f : Float ) {
		out.writeFloat( f == 0 ? 0 : f ); // prevent negative zero
	}

	function writeVector( p :h3d.Vector ) {
		writeFloat(p.x);
		writeFloat(p.y);
		writeFloat(p.z);
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
		writeProps(s.props);
		out.writeUInt16(s.joints.length);
		for( j in s.joints ) {
			writeProps(j.props);
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
		version = d.version;

		if( version > Data.CURRENT_VERSION ) throw "Can't write HMD v" + version;

		writeProps(d.props);

		function writeFormat(format : hxd.BufferFormat) {
			out.writeByte(format.stride);
			out.writeByte(@:privateAccess format.inputs.length);
			for( f in format.getInputs() ) {
				writeName(f.name);
				out.writeByte(f.type.toInt() | (f.precision.toInt() << 4));
			}
		}
		out.writeInt32(d.geometries.length);
		for( g in d.geometries ) {
			writeProps(g.props);
			out.writeInt32(g.vertexCount);
			writeFormat(g.vertexFormat);
			out.writeInt32(g.vertexPosition);
			if( g.indexCounts.length >= 0xFF ) {
				out.writeByte(0xFF);
				out.writeInt32(g.indexCounts.length);
			} else
				out.writeByte(g.indexCounts.length);
			for( i in g.indexCounts )
				out.writeInt32(i);
			out.writeInt32(g.indexPosition);
			writeBounds(g.bounds);
		}

		out.writeInt32(d.materials.length);
		for( m in d.materials ) {
			writeProps(m.props);
			writeName(m.name);
			writeName(m.diffuseTexture);
			out.writeByte(m.blendMode.getIndex());
			out.writeByte(1); // old culling back
			writeFloat(1); // old killalpha
			if( m.props != null && m.props.indexOf(HasExtraTextures) >= 0 ) {
				writeName(m.specularTexture);
				writeName(m.normalMap);
			}
		}

		out.writeInt32(d.models.length);
		for( m in d.models ) {
			writeProps(m.props);
			writeName(m.name);
			out.writeInt32(m.parent + 1);
			writeName(m.follow);
			writePosition(m.position);
			out.writeInt32(m.geometry + 1);
			if( m.geometry < 0 ) continue;
			if( m.materials.length >= 0xFF ) {
				out.writeByte(0xFF);
				out.writeInt32(m.materials.length);
			} else
				out.writeByte(m.materials.length);
			for( m in m.materials )
				out.writeInt32(m);
			if( m.skin == null )
				writeName(null);
			else
				writeSkin(m.skin);
			if ( m.lods != null ) {
				out.writeInt32(m.lods.length);
				for ( lod in m.lods )
					out.writeInt32(lod);
			}
			if ( m.collider != null && m.collider >= 0 )
				out.writeInt32(m.collider);
			if ( m.colliders != null && m.colliders.length > 0 ) {
				out.writeInt32(m.colliders.length);
				for( c in m.colliders )
					out.writeInt32(c);
			}
		}

		out.writeInt32(d.animations.length);
		for( a in d.animations ) {
			writeProps(a.props);
			writeName(a.name);
			out.writeInt32(a.frames);
			writeFloat(a.sampling);
			writeFloat(a.speed);
			out.writeByte( (a.loop?1:0) | (a.events != null?2:0) );
			out.writeInt32(a.dataPosition);
			out.writeInt32(a.objects.length);
			for( o in a.objects ) {
				writeName(o.name);
				out.writeByte(o.flags.toInt());
				if( o.flags.has(HasProps) ) {
					out.writeByte(o.props.length);
					for( n in o.props )
						writeName(n);
				}
			}
			if( a.events != null ) {
				out.writeInt32(a.events.length);
				for( e in a.events ) {
					out.writeInt32(e.frame);
					writeName(e.data);
				}
			}
		}

		out.writeInt32(d.shapes.length);
		for ( s in d.shapes ) {
			writeName(s.name);
			out.writeInt32(s.geom + 1);
			out.writeInt32(s.vertexCount);
			writeFormat(s.vertexFormat);
			out.writeInt32(s.vertexPosition);
			out.writeInt32(s.indexCount);
			out.writeInt32(s.remapPosition);
		}

		if ( d.colliders != null ) {
			function writeCollider( c : Collider, withType : Bool ) {
				var type = c.type;
				if( withType )
					out.writeByte(type);
				switch( type ) {
				case ConvexHulls:
					var c = Std.downcast(c, ConvexHullsCollider);
					out.writeInt32(c.vertexCounts.length);
					for ( v in c.vertexCounts )
						out.writeInt32(v);
					out.writeInt32(c.vertexPosition);
					if ( c.indexCounts.length != c.vertexCounts.length )
						throw "assert";
					for ( i in c.indexCounts )
						out.writeInt32(i);
					out.writeInt32(c.indexPosition);
				case Mesh:
					var c = Std.downcast(c, MeshCollider);
					out.writeInt32(c.vertexCount);
					out.writeInt32(c.vertexPosition);
					out.writeInt32(c.indexCount);
					out.writeInt32(c.indexPosition);
				case Group:
					var c = Std.downcast(c, GroupCollider);
					out.writeInt32(c.colliders.length);
					for( sub in c.colliders )
						writeCollider(sub, withType);
				case Sphere:
					var c = Std.downcast(c, SphereCollider);
					writeVector(c.position);
					writeFloat(c.radius);
				case Box:
					var c = Std.downcast(c, BoxCollider);
					writeVector(c.position);
					writeVector(c.halfExtent);
					writeVector(c.rotation);
				case Capsule:
					var c = Std.downcast(c, CapsuleCollider);
					writeVector(c.position);
					writeVector(c.halfExtent);
					writeFloat(c.radius);
				case Cylinder:
					var c = Std.downcast(c, CylinderCollider);
					writeVector(c.position);
					writeVector(c.halfExtent);
					writeFloat(c.radius);
				}
			}

			out.writeInt32(d.colliders.length);
			var hasCustom = d.props != null && d.props.indexOf(HasCustomCollider) >= 0;
			for ( c in d.colliders ) {
				writeCollider(c, hasCustom);
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