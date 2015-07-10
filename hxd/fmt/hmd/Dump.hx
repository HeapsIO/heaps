package hxd.fmt.hmd;
import hxd.fmt.hmd.Data;

class Dump {

	var buf : StringBuf;
	var prefix : String;

	public function new() {
	}

	inline function add<T>( s : T ) {
		buf.add(prefix+s+"\n");
	}

	function positionStr( p : Position ) {
		inline function fmt(v) return hxd.Math.fmt(v);
		return 'T={${fmt(p.x)},${fmt(p.y)},${fmt(p.z)}} R={${fmt(p.qx)},${fmt(p.qy)},${fmt(p.qz)}} S={${fmt(p.sx)},${fmt(p.sy)},${fmt(p.sz)}}';
	}

	function addProps( props : Properties ) {
		if( props == null ) return;
		for( p in props )
			add(Type.enumConstructor(p) + " : " + [for( p in Type.enumParameters(p) ) Std.string(p)].join(", "));
	}

	public function dump( h : Data ) : String {
		buf = new StringBuf();
		prefix = "";
		add('HMD v${h.version}');
		prefix = "\t";
		add("Header : " + hxd.Math.fmt(h.dataPosition/1024) + " KB");
		add("Data : " + hxd.Math.fmt(h.data.length / 1024) + " KB");
		addProps(h.props);
		prefix = "";
		add("");
		for( k in 0...h.geometries.length ) {
			var g = h.geometries[k];
			add('@$k GEOMETRY');
			prefix += "\t";
			add('Vertex Count : ${g.vertexCount}');
			add('Vertex Stride : ${g.vertexStride}');
			add('Index Count : ${g.indexCount} ${g.indexCounts.length > 1 ? g.indexCounts.toString() : ''}');
			add('Bounds : center=${g.bounds.getCenter()} size=${g.bounds.getSize()}');
			add('Format :');
			addProps(g.props);
			for( f in g.vertexFormat )
				add('\t${f.name} ${f.format.toString().substr(1)}');
			prefix = "";
		}
		if( h.geometries.length > 0 ) add('');
		for( k in 0...h.materials.length ) {
			var m = h.materials[k];
			add('@$k MATERIAL');
			prefix += "\t";
			if( m.name != null ) add('Name : ${m.name}');
			add('Blend : ${m.blendMode}');
			add('Cull : ${m.culling}');
			if( m.diffuseTexture != null ) add('Texture : ${m.diffuseTexture}');
			if( m.killAlpha != null ) add('KillAlpha : ${m.killAlpha}');
			addProps(m.props);
			prefix = "";
		}
		if( h.materials.length > 0 ) add('');
		for( k in 0...h.models.length ) {
			var m = h.models[k];
			add('@$k MODEL');
			prefix += "\t";
			if( m.name != null ) add('Name : ${m.name}');
			var p = h.models[m.parent];
			if( m.parent >= 0 ) add('Parent : @${m.parent} ${p == null ? "INVALID" : p.name == null ? "" : p.name }');
			if( m.follow != null ) add('Follow : ${m.follow}');
			add('Position : ${positionStr(m.position)}');
			if( m.geometry >= 0 )
				add('Geometry : @${m.geometry}');
			if( m.materials != null ) {
				for( i in 0...m.materials.length ) {
					var m = m.materials[i];
					var md = h.materials[m];
					add('Material $i : @$m ${md == null ? "INVALID" : md.name == null ? "" : md.name}');
				}
			}
			addProps(m.props);
			if( m.skin != null ) {
				var s = m.skin;
				add('Skin :');
				prefix += "\t";
				if( s.name != null ) add('Name : ${s.name}');
				addProps(s.props);
				for( i in 0...s.joints.length ) {
					var j = s.joints[i];
					add('@$i JOINT');
					prefix += "\t";
					add('Name : ${j.name}');
					if( j.parent >= 0 ) {
						var p = s.joints[j.parent];
						add('Parent : @${j.parent} ${p == null ? "INVALID" : p.name}');
					}
					add('Position : ${positionStr(j.position)}');
					if( j.bind >= 0 ) add('Bind @${j.bind}');
					if( j.transpos != null ) add('TransPos : ${positionStr(j.transpos)}');
					addProps(j.props);
					prefix = prefix.substr(1);
				}
				if( s.split != null )
					add('Split : ${s.split.length} ${s.split.toString()}');
			}
			prefix = "";
		}

		if( h.models.length > 0 ) add("");

		var FLAGS = Type.allEnums(AnimationFlag);

		for( k in 0...h.animations.length ) {
			var a = h.animations[k];
			add('@$k ANIMATION');
			prefix += '\t';
			if( a.name != null ) add('Name : ${a.name}');
			add('Frames : ${a.frames}');
			add('Sampling : ${a.sampling}');
			add('Speed : ${a.speed}');
			add('Loop : ${a.loop}');
			addProps(a.props);
			add('Objects : ');
			prefix += "\t";
			for( o in a.objects ) {
				var flags = [];
				for( f in FLAGS )
					if( o.flags.has(f) ) {
						var n = f.getName();
						if( StringTools.startsWith(n, "Has") ) n = n.substr(3);
						if( f == HasProps ) n += o.props;
						flags.push(n);
					}
				add('${o.name} : ${flags.join(",")}');
			}
			prefix = prefix.substr(1);

			if( a.events != null ) {
				add('Events : ');
				prefix += "\t";
				for( e in a.events )
					add('${e.frame} : ${e.data}');
				prefix = prefix.substr(1);
			}

			prefix = "";
		}

		if( h.animations.length > 0 ) add("");

		// ---- DUMP DATA ----

		var d = new haxe.io.BytesInput(h.data);

		for( k in 0...h.geometries.length ) {
			var g = h.geometries[k];
			var stride = 0;
			for( f in g.vertexFormat )
				stride += f.format.getSize();
			add('@$k GEOMETRY');
			prefix += '\t';
			d.position = g.vertexPosition;
			add('VertexBuffer : ' + Std.string([for( i in 0...g.vertexCount ) [for( j in 0...stride ) d.readFloat()]]));
			d.position = g.indexPosition;
			add('IndexBuffer : ' + Std.string([for( i in 0...g.indexCount ) d.readUInt16()]));
			prefix = '';
		}

		if( h.geometries.length > 0 ) add("");

		for( k in 0...h.animations.length ) {
			var a = h.animations[k];
			add('@$k ANIMATION');
			prefix += '\t';
			d.position = a.dataPosition;
			for( o in a.objects ) {
				var frames = a.frames;
				var stride = 0;
				if( o.flags.has(HasPosition) )
					stride += 3;
				if( o.flags.has(HasRotation) )
					stride += 3;
				if( o.flags.has(HasScale) )
					stride += 3;
				if( o.flags.has(SinglePosition) )
					frames = 1;
				if( stride > 0 )
					add('${o.name} Position : '+Std.string([for( i in 0...frames ) [for( j in 0...stride ) d.readFloat()]]));
				if( o.flags.has(HasUV) )
					add('${o.name} UV : '+Std.string([for( i in 0...a.frames ) [for( j in 0...2 ) d.readFloat()]]));
				if( o.flags.has(HasAlpha) )
					add('${o.name} Alpha : '+Std.string([for( i in 0...a.frames ) d.readFloat()]));
				if( o.flags.has(HasProps) ) {
					for( p in o.props )
						add('${o.name} $p : '+Std.string([for( i in 0...a.frames ) d.readFloat()]));
				}
			}
			prefix = '';
		}

		if( h.animations.length > 0 ) add("");

		add("DONE");

		return buf.toString();
	}

	public static function toString(hmd) {
		return new Dump().dump(hmd);
	}

	#if sys
	public static function main() {
		var file = Sys.args()[0];
		if( file == null ) throw "Missing file argument";
		var bytes;
		if( file.split(".").pop().toLowerCase() == "fbx" ) {
			var l = new hxd.fmt.fbx.HMDOut();
			l.loadTextFile(sys.io.File.getContent(file));
			var hmd = l.toHMD(null, !StringTools.startsWith(file.split("\\").join("/").split("/").pop(), "Anim_"));
			var out = new haxe.io.BytesOutput();
			new Writer(out).write(hmd);
			bytes = out.getBytes();
		} else
			bytes = sys.io.File.getBytes(file);
		var hmd = new Reader(new haxe.io.BytesInput(bytes)).read();
		var dump = toString(hmd);
		sys.io.File.saveContent(file+".txt", dump);
	}
	#end

}