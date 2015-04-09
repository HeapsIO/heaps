package hxd.fmt.hmd;
import hxd.fmt.hmd.Data;

class Reader {

	static var BLEND = Type.allEnums(h2d.BlendMode);
	static var CULLING = Type.allEnums(h3d.mat.Data.Face);

	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
	}

	function readProperty() {
		switch( i.readByte() ) {
		case 0:
			return CameraFOVY(i.readFloat());
		case unk:
			throw "Unknown property #" + unk;
		}
	}

	function readProps() {
		if( version == 1 )
			return null;
		var n = i.readByte();
		if( n == 0 )
			return null;
		return [for( i in 0...n ) readProperty()];
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

	function readBounds() {
		var b = new h3d.col.Bounds();
		b.xMin = i.readFloat();
		b.yMin = i.readFloat();
		b.zMin = i.readFloat();
		b.xMax = i.readFloat();
		b.yMax = i.readFloat();
		b.zMax = i.readFloat();
		return b;
	}

	function readSkin() {
		var name = readName();
		if( name == null )
			return null;
		var s = new Skin();
		s.props = readProps();
		s.name = name;
		s.joints = [];
		for( k in 0...i.readUInt16() ) {
			var j = new SkinJoint();
			j.props = readProps();
			j.name = readName();
			var pid = i.readUInt16();
			var hasScale = pid & 0x8000 != 0;
			if( hasScale ) pid &= 0x7FFF;
			j.parent = pid - 1;
			j.position = readPosition(hasScale);
			j.bind = i.readUInt16() - 1;
			if( j.bind >= 0 )
				j.transpos = readPosition(hasScale);
			s.joints.push(j);
		}
		var count = i.readByte();
		if( count > 0 ) {
			s.split = [];
			for( k in 0...count ) {
				var ss = new SkinSplit();
				ss.materialIndex = i.readByte();
				ss.joints = [for( k in 0...i.readByte() ) i.readUInt16()];
				s.split.push(ss);
			}
		}
		return s;
	}

	public function readHeader() : Data {
		var d = new Data();
		var h = i.readString(3);
		if( h != "HMD" ) {
			if( h.charCodeAt(0) == ";".code )
				throw "FBX was not converted to HMD";
			throw "Invalid HMD header " + StringTools.urlEncode(h);
		}
		version = i.readByte();
		if( version > Data.CURRENT_VERSION ) throw "Can't read HMD v" + version;
		d.version = version;
		d.geometries = [];
		d.dataPosition = i.readInt32();
		d.props = readProps();

		for( k in 0...i.readInt32() ) {
			var g = new Geometry();
			g.props = readProps();
			g.vertexCount = i.readInt32();
			g.vertexStride = i.readByte();
			g.vertexFormat = [for( k in 0...i.readByte() ) new GeometryFormat(readName(), GeometryDataFormat.fromInt(i.readByte()))];
			g.vertexPosition = i.readInt32();
			g.indexCounts = [for( k in 0...i.readByte() ) i.readInt32()];
			g.indexPosition = i.readInt32();
			g.bounds = readBounds();
			d.geometries.push(g);
		}

		d.materials = [];
		for( k in 0...i.readInt32() ) {
			var m = new Material();
			m.props = readProps();
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
			m.props = readProps();
			m.name = readName();
			m.parent = i.readInt32() - 1;
			m.follow = readName();
			m.position = readPosition();
			m.geometry = i.readInt32() - 1;
			d.models.push(m);
			if( m.geometry < 0 ) continue;
			m.materials = [];
			for( k in 0...i.readByte() )
				m.materials.push(i.readInt32());
			m.skin = readSkin();
		}

		d.animations = [];
		for( k in 0...i.readInt32() ) {
			var a = new Animation();
			a.props = readProps();
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
				if( o.flags.has(HasProps) )
					o.props = [for( i in 0...i.readByte() ) readName()];
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