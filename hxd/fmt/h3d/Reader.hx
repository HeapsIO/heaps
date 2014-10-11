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
		return i.readString(i.readByte());
	}

	function readPosition() {
		var p = new Position();
		p.x = i.readFloat();
		p.y = i.readFloat();
		p.z = i.readFloat();
		p.rx = i.readFloat();
		p.ry = i.readFloat();
		p.rz = i.readFloat();
		p.sx = i.readFloat();
		p.sy = i.readFloat();
		p.sz = i.readFloat();
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
			m.position = readPosition();
			var count = i.readByte();
			if( count == 0 ) continue;
			m.geometries = [];
			m.materials = [];
			for( k in 0...count )
				m.geometries.push(i.readInt32());
			for( k in 0...count )
				m.materials.push(i.readInt32());
			d.models.push(m);
		}
		return d;
	}

	public function read() : Data {
		var h = readHeader();
		h.data = i.read(i.readInt32());
		return h;
	}

}