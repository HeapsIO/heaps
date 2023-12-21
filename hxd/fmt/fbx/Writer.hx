package hxd.fmt.fbx;
import hxd.fmt.fbx.Data;
import hxd.fmt.hmd.Data;

class Writer {

	var out : haxe.io.Output;
	var version : Int;

	public function new(out) {
		this.out = out;
	}

	function getTabFormat(depth: Int) {
		return ${StringTools.rpad("", '\t', depth)}
	}

	function writeNode(n : FbxNode, depth : Int = 0) {
		out.writeString('${getTabFormat(depth)}${n.name}:');

		if (n.props != null && n.props.length > 0) {
			for (idx => p in n.props) {
				out.writeString('${idx != 0 ? ',' : ''}${(p.match(PInt(_)) || p.match(PFloat(_)) && idx!=0) ? '' : ' '}${writeProperty(p, depth)}');
			}
		}

		if (n.childs == null || n.childs.length <= 0)
			out.writeString('\n');
		else {
			out.writeString(' {\n');
			for (c in n.childs) {
				writeNode(c, depth+1);
			}
			out.writeString('${getTabFormat(depth)}}\n');
		}
	}

	function writeProperty( p : FbxProp, depth : Int) {
		switch (p) {
			case PInt( v ):
				return Std.string(v);

			case PFloat( v ):
				return Std.string(v);

			case PString( v ):
				return '"${v}"';

			case PIdent( i ):
				return i;

			case PInts( v ):
				{
					var res = '*${v.length} {\n';
					res += '${getTabFormat(depth + 1)}a: ';

					for (idx => i in v) {
						res += '${idx !=0 ? ',' : ''}${i}';
					}

					res+='\n${getTabFormat(depth)}}';
					return res;
				}

			case PFloats( v ):
				{
					var res = '*${v.length} {\n';
					res += '${getTabFormat(depth + 1)}a: ';

					for (idx => i in v) {
						res += '${idx !=0 ? ',' : ''}${i}';
					}

					res+='\n${getTabFormat(depth)}}';
					return res;
				}

			default:
				return "Unsupported data";
		}
	}

	function writeHeader() {
		var fbxVersion = "7.3.0";

		out.writeString('; FBX ${fbxVersion} project file\n');
		out.writeString('; Copyright (C) 1997-2010 Autodesk Inc. and/or its licensors.\n');
		out.writeString('; All rights reserved.\n');
		out.writeString('; ----------------------------------------------------\n');
		out.writeString('\n');
	}

	public function write( fbx : FbxNode ) {
		var old = out;
		var header = new haxe.io.BytesOutput();
		out = header;
		// version = d.version;

		// if( version > Data.CURRENT_VERSION ) throw "Can't write HMD v" + version;

		var nodeChild : FbxNode = { name: "Version", props:[PInt(100), PString("Toto")], childs: null};
		var node : FbxNode = { name: "Version", props:[PInt(100), PString("Toto")], childs:[nodeChild, nodeChild]};

		writeHeader();
		writeNode(fbx);
		// writeProps(d.props);

		// out.writeInt32(d.geometries.length);
		// for( g in d.geometries ) {
		// 	writeProps(g.props);
		// 	out.writeInt32(g.vertexCount);
		// 	out.writeByte(g.vertexFormat.stride);
		// 	out.writeByte(@:privateAccess g.vertexFormat.inputs.length);
		// 	for( f in g.vertexFormat.getInputs() ) {
		// 		writeName(f.name);
		// 		out.writeByte(f.type.toInt() | (f.precision.toInt() << 4));
		// 	}
		// 	out.writeInt32(g.vertexPosition);
		// 	if( g.indexCounts.length >= 0xFF ) {
		// 		out.writeByte(0xFF);
		// 		out.writeInt32(g.indexCounts.length);
		// 	} else
		// 		out.writeByte(g.indexCounts.length);
		// 	for( i in g.indexCounts )
		// 		out.writeInt32(i);
		// 	out.writeInt32(g.indexPosition);
		// 	writeBounds(g.bounds);
		// }

		// out.writeInt32(d.materials.length);
		// for( m in d.materials ) {
		// 	writeProps(m.props);
		// 	writeName(m.name);
		// 	writeName(m.diffuseTexture);
		// 	out.writeByte(m.blendMode.getIndex());
		// 	out.writeByte(1); // old culling back
		// 	writeFloat(1); // old killalpha
		// 	if( m.props != null && m.props.indexOf(HasExtraTextures) >= 0 ) {
		// 		writeName(m.specularTexture);
		// 		writeName(m.normalMap);
		// 	}
		// }

		// out.writeInt32(d.models.length);
		// for( m in d.models ) {
		// 	writeProps(m.props);
		// 	writeName(m.name);
		// 	out.writeInt32(m.parent + 1);
		// 	writeName(m.follow);
		// 	writePosition(m.position);
		// 	out.writeInt32(m.geometry + 1);
		// 	if( m.geometry < 0 ) continue;
		// 	if( m.materials.length >= 0xFF ) {
		// 		out.writeByte(0xFF);
		// 		out.writeInt32(m.materials.length);
		// 	} else
		// 		out.writeByte(m.materials.length);
		// 	for( m in m.materials )
		// 		out.writeInt32(m);
		// 	if( m.skin == null )
		// 		writeName(null);
		// 	else
		// 		writeSkin(m.skin);
		// }

		// out.writeInt32(d.animations.length);
		// for( a in d.animations ) {
		// 	writeProps(a.props);
		// 	writeName(a.name);
		// 	out.writeInt32(a.frames);
		// 	writeFloat(a.sampling);
		// 	writeFloat(a.speed);
		// 	out.writeByte( (a.loop?1:0) | (a.events != null?2:0) );
		// 	out.writeInt32(a.dataPosition);
		// 	out.writeInt32(a.objects.length);
		// 	for( o in a.objects ) {
		// 		writeName(o.name);
		// 		out.writeByte(o.flags.toInt());
		// 		if( o.flags.has(HasProps) ) {
		// 			out.writeByte(o.props.length);
		// 			for( n in o.props )
		// 				writeName(n);
		// 		}
		// 	}
		// 	if( a.events != null ) {
		// 		out.writeInt32(a.events.length);
		// 		for( e in a.events ) {
		// 			out.writeInt32(e.frame);
		// 			writeName(e.data);
		// 		}
		// 	}
		// }

		var bytes = header.getBytes();
		out = old;

		// out.writeString("HMD");
		// out.writeByte(d.version);
		// out.writeInt32(bytes.length + 12);
		out.write(bytes);
		// out.writeInt32(d.data.length);
		// out.write(d.data);
	}

}