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
		case 1:
			throw "Obsolete HasMaterialFlags";
		case 2:
			return HasExtraTextures;
		case 3:
			return FourBonesByVertex;
		case 4:
			return HasLod;
		case 5:
			return HasCollider;
		case 6:
			return HasColliders;
		case 7:
			return HasCustomCollider;
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


	static var HMD_STRINGS : Map<String,String>;

	// make sure some strings are reused between models
	// in order to prevent many similar String to be kept into memory
	function readCachedName() {
		var name = readName();
		if( name == null ) return null;
		if( HMD_STRINGS == null )
			HMD_STRINGS = new Map<String,String>();
		var n = HMD_STRINGS.get(name);
		if( n != null ) return n;
		HMD_STRINGS.set(name,name);
		return name;
	}

	function readVector() {
		var x = i.readFloat();
		var y = i.readFloat();
		var z = i.readFloat();
		return new h3d.Vector(x, y, z);
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
		var name = readCachedName();
		if( name == null )
			return null;
		var s = new Skin();
		s.props = readProps();
		s.name = name;
		s.joints = [];
		for( k in 0...i.readUInt16() ) {
			var j = new SkinJoint();
			j.props = readProps();
			j.name = readCachedName();
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

	function readLods() {
		var lodCount = i.readInt32();
		return [for (_ in 0...lodCount) i.readInt32()];
	}

	public function readHeader( fast = false ) : Data {
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
		if( fast )
			i = new haxe.io.BytesInput(i.read(d.dataPosition-12));
		d.props = readProps();

		inline function makeFormat() {
			var stride = i.readByte();
			var format = hxd.BufferFormat.make([for( k in 0...i.readByte() ) {
				var name = readCachedName();
				var type = i.readByte();
				new GeometryFormat(name, @:privateAccess GeometryDataFormat.fromInt(type&15), @:privateAccess hxd.BufferFormat.Precision.fromInt(type>>4));
			}]);
			if ( stride != format.stride ) throw "assert";
			return format;
		}
		for( k in 0...i.readInt32() ) {
			var g = new Geometry();
			g.props = readProps();
			g.vertexCount = i.readInt32();
			g.vertexFormat = makeFormat();
			g.vertexPosition = i.readInt32();
			var subCount = i.readByte();
			if( subCount == 0xFF ) subCount = i.readInt32();
			g.indexCounts = [for( k in 0...subCount ) i.readInt32()];
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
			i.readByte(); // old culling = 1
			i.readFloat(); // old killalpha = 1
			if( m.props != null && m.props.indexOf(HasExtraTextures) >= 0 ) {
				m.specularTexture = readName();
				m.normalMap = readName();
			}
			d.materials.push(m);
		}

		d.models = [];
		var hasCollider = false;
		for( k in 0...i.readInt32() ) {
			var m = new Model();
			m.props = readProps();
			m.name = readCachedName();
			m.parent = i.readInt32() - 1;
			m.follow = readCachedName();
			m.position = readPosition();
			m.geometry = i.readInt32() - 1;
			d.models.push(m);
			if( m.geometry < 0 ) continue;
			m.materials = [];
			var matCount = i.readByte();
			if( matCount == 0xFF ) matCount = i.readInt32();
			for( k in 0...matCount )
				m.materials.push(i.readInt32());
			m.skin = readSkin();
			if ( m.props != null ) {
				m.lods = m.props.contains(HasLod) ? readLods() : null;
				if ( m.props.contains(HasCollider) ) {
					m.collider = i.readInt32();
					hasCollider = true;
				}
				if( m.props.contains(HasColliders) ) {
					m.colliders = [];
					for( k in 0...i.readInt32() ) {
						m.colliders.push(i.readInt32());
					}
					hasCollider = true;
				}
			}
		}

		d.animations = [];
		for( k in 0...i.readInt32() ) {
			var a = new Animation();
			a.props = readProps();
			a.name = readName();
			a.frames = i.readInt32();
			a.sampling = i.readFloat();
			a.speed = i.readFloat();
			var flags = i.readByte();
			a.loop = flags & 1 != 0;
			a.dataPosition = i.readInt32();
			a.objects = [];
			for( k in 0...i.readInt32() ) {
				var o = new AnimationObject();
				o.name = readCachedName();
				o.flags = haxe.EnumFlags.ofInt(i.readByte());
				a.objects.push(o);
				if( o.flags.has(HasProps) )
					o.props = [for( i in 0...i.readByte() ) readName()];
			}
			if( flags & 2 != 0 ) {
				a.events = [];
				for( k in 0...i.readInt32() ) {
					var e = new AnimationEvent();
					e.frame = i.readInt32();
					e.data = readCachedName();
					a.events.push(e);
				}
			}
			d.animations.push(a);
		}

		if ( d.version >= 4 ) {
			var shapeLength = i.readInt32();
			d.shapes = [];
			for ( k in 0...shapeLength ) {
				var s = new BlendShape();
				s.name = readName();
				s.geom = i.readInt32() - 1;
				s.vertexCount = i.readInt32();
				s.vertexFormat = makeFormat();
				s.vertexPosition = i.readInt32();
				s.indexCount = i.readInt32();
				s.remapPosition = i.readInt32();
				d.shapes.push(s);
			}
		}

		if ( hasCollider ) {
			function readCollider( hasType : Bool ) : Collider {
				var type : ColliderType = hasType ? i.readByte() : ConvexHulls;
				switch( type ) {
				case ConvexHulls:
					var c = new ConvexHullsCollider();
					var n = i.readInt32();
					c.vertexCounts = [for( v in 0...n ) i.readInt32()];
					c.vertexPosition = i.readInt32();
					c.indexCounts = [for( v in 0...n ) i.readInt32()];
					c.indexPosition = i.readInt32();
					return c;
				case Mesh:
					var c = new MeshCollider();
					c.vertexCount = i.readInt32();
					c.vertexPosition = i.readInt32();
					c.indexCount = i.readInt32();
					c.indexPosition = i.readInt32();
					return c;
				case Group:
					var c = new GroupCollider();
					var n = i.readInt32();
					c.colliders = [for( v in 0...n ) readCollider(hasType) ];
					return c;
				case Sphere:
					var c = new SphereCollider();
					c.position = readVector();
					c.radius = i.readFloat();
					return c;
				case Box:
					var c = new BoxCollider();
					c.position = readVector();
					c.halfExtent = readVector();
					c.rotation = readVector();
					return c;
				case Capsule:
					var c = new CapsuleCollider();
					c.position = readVector();
					c.halfExtent = readVector();
					c.radius = i.readFloat();
					return c;
				case Cylinder:
					var c = new CylinderCollider();
					c.position = readVector();
					c.halfExtent = readVector();
					c.radius = i.readFloat();
					return c;
				}
				throw "unknown collider type " + type;
			}

			d.colliders = [];
			var hasCustom = d.props != null && d.props.contains(HasCustomCollider);
			var colliderLength = i.readInt32();
			for ( k in 0...colliderLength ) {
				var c = readCollider(hasCustom);
				d.colliders.push(c);
			}
		}

		return d;
	}

	public function read() : Data {
		var h = readHeader();
		h.data = i.read(i.readInt32());
		return h;
	}

}