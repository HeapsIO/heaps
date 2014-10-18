package hxd.fmt.h3d;
import hxd.fmt.h3d.Data;

class Reader {

	static var FORMATS = Type.allEnums(GeometryDataFormat);
	static var BLEND = Type.allEnums(h2d.BlendMode);
	static var CULLING = Type.allEnums(h3d.mat.Data.Face);

	var i : haxe.io.Input;

	public function new(i) {
		this.i = i;
	}

	function readName() {
		var b = i.readByte();
		if( b == 0xFF ) return null;
		return i.readString(b);
	}

	function readPosition(hasScale=true) {
		var p = new Position();
		p.x = i.readFloat();
		p.y = i.readFloat();
		p.z = i.readFloat();
		p.qx = i.readFloat();
		p.qy = i.readFloat();
		p.qz = i.readFloat();
		if( hasScale ) {
			p.sx = i.readFloat();
			p.sy = i.readFloat();
			p.sz = i.readFloat();
		} else {
			p.sx = 1;
			p.sy = 1;
			p.sz = 1;
		}
		return p;
	}

	public function readHeader() : Data {
		var d = new Data();
		var h = i.readString(3);
		if( h != "H3D" ) {
			if( h.charCodeAt(0) == ";".code )
				throw "FBX was not converted to H3D";
			if( h.charCodeAt(0) == 'X'.code )
				throw "XBX was not converted to H3D";
			throw "Invalid XBX header " + StringTools.urlEncode(h);
		}
		d.version = i.readByte();
		d.geometries = [];
		d.dataPosition = i.readInt32();

		for( k in 0...i.readInt32() ) {
			var g = new Geometry();
			g.vertexCount = i.readInt32();
			g.vertexStride = i.readByte();
			g.vertexFormat = [for( k in 0...i.readByte() ) new GeometryFormat(readName(), FORMATS[i.readByte()])];
			g.vertexPosition = i.readInt32();
			g.indexCount = i.readInt32();
			g.indexPosition = i.readInt32();
			d.geometries.push(g);
		}

		d.materials = [];
		for( k in 0...i.readInt32() ) {
			var m = new Material();
			m.name = readName();
			m.diffuseTexture = readName();
			m.blendMode = BLEND[i.readByte()];
			m.culling = CULLING[i.readByte()];
			m.killAlpha = i.readFloat();
			if( m.killAlpha == 1 ) m.killAlpha = null;
			d.materials.push(m);
		}

		d.models = [];
		for( k in 0...i.readInt32() ) {
			var m = new Model();
			m.name = readName();
			m.parent = i.readInt32();
			m.follow = readName();
			m.position = readPosition();
			d.models.push(m);
			var count = i.readByte();
			if( count == 0 ) continue;
			m.geometries = [];
			m.materials = [];
			for( k in 0...count )
				m.geometries.push(i.readInt32());
			for( k in 0...count )
				m.materials.push(i.readInt32());
			var name = readName();
			if( name != null ) {
				var s = new Skin();
				s.name = name;
				s.joints = [];
				for( k in 0...i.readUInt16() ) {
					var j = new SkinJoint();
					j.name = readName();
					j.parent = i.readUInt16() - 1;
					j.position = readPosition(false);
					j.bind = i.readUInt16() - 1;
					if( j.bind >= 0 )
						j.transpos = readPosition(false);
					s.joints.push(j);
				}
				m.skin = s;
			}
		}

		d.animations = [];
		for( k in 0...i.readInt32() ) {
			var a = new Animation();
			a.name = readName();
			a.frames = i.readInt32();
			a.sampling = i.readFloat();
			a.speed = i.readFloat();
			a.loop = i.readByte() == 1;
			a.dataPosition = i.readInt32();
			a.objects = [];
			for( k in 0...i.readInt32() ) {
				var o = new AnimationObject();
				o.name = readName();
				o.flags = haxe.EnumFlags.ofInt(i.readByte());
				a.objects.push(o);
			}
			d.animations.push(a);
		}

		return d;
	}

	public function read() : Data {
		var h = readHeader();
		h.data = i.read(i.readInt32());
		return h;
	}

}