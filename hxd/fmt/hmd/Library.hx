package hxd.fmt.hmd;
import hxd.fmt.hmd.Data;

private class FormatMap {
	public var size : Int;
	public var offset : Int;
	public var def : h3d.Vector;
	public var next : FormatMap;
	public function new(size, offset, def, next) {
		this.size = size;
		this.offset = offset;
		this.def = def;
		this.next = next;
	}
}

class GeometryBuffer {
	public var vertexes : haxe.ds.Vector<Float>;
	public var indexes : haxe.ds.Vector<Int>;
	public function new() {
	}
}

class Library {

	public var header : Data;
	var entry : hxd.res.FileEntry;
	var cachedPrimitives : Array<h3d.prim.Primitive>;
	var cachedAnimations : Map<String, h3d.anim.Animation>;
	var cachedSkin : Map<String, h3d.anim.Skin>;

	public function new(entry, header) {
		this.entry = entry;
		this.header = header;
		cachedPrimitives = [];
		cachedAnimations = new Map();
		cachedSkin = new Map();
	}

	public function getData() {
		var b = haxe.io.Bytes.alloc(entry.size - header.dataPosition);
		entry.open();
		entry.skip(header.dataPosition);
		entry.read(b, 0, b.length);
		entry.close();
		return b;
	}

	@:noDebug
	public function getBuffers( geom : Geometry, format : Array<GeometryFormat>, ?defaults : Array<h3d.Vector>, ?material : Int ) {

		if( material == 0 && geom.indexCounts.length == 1 )
			material = null;

		var map = null, stride = 0;
		for( i in 0...format.length ) {
			var i = format.length - 1 - i;
			var f = format[i];
			var size  = f.format.getSize();
			var offset = 0;
			var found = false;
			for( f2 in geom.vertexFormat ) {
				if( f2.name == f.name ) {
					if( f2.format.getSize() < size )
						throw 'Requested ${f.name} data has only ${f2.format.getSize()} regs instead of $size';
					found = true;
					break;
				}
				offset += f2.format.getSize();
			}
			if( found ) {
				map = new FormatMap(size, offset, null, map);
			} else {
				var def = defaults == null ? null : defaults[i];
				if( def == null )
					throw 'Missing required ${f.name}';
				map = new FormatMap(size, 0, def, map);
			}
			stride += size;
		}

		var vsize = geom.vertexCount * geom.vertexStride * 4;
		var vbuf = hxd.impl.Tmp.getBytes(vsize);
		entry.open();
		entry.skip(header.dataPosition + geom.vertexPosition);
		entry.read(vbuf, 0, vsize);

		entry.skip(geom.indexPosition - (geom.vertexPosition + vsize));

		var isize;
		if( material == null )
			isize = geom.indexCount * 2;
		else {
			var ipos = 0;
			for( i in 0...material )
				ipos += geom.indexCounts[i];
			entry.skip(ipos * 2);
			isize = geom.indexCounts[material] * 2;
		}
		var ibuf = hxd.impl.Tmp.getBytes(isize);
		entry.read(ibuf, 0, isize);

		var buf = new GeometryBuffer();
		if( material == null ) {
			buf.vertexes = new haxe.ds.Vector(stride * geom.vertexCount);
			buf.indexes = new haxe.ds.Vector(geom.indexCount);
			var w = 0;
			for( vid in 0...geom.vertexCount ) {
				var m = map;
				while( m != null ) {
					if( m.def == null ) {
						var r = vid * geom.vertexStride;
						for( i in 0...m.size )
							buf.vertexes[w++] = vbuf.getFloat((r + m.offset + i) << 2);
					} else {
						switch( m.size ) {
						case 1:
							buf.vertexes[w++] = m.def.x;
						case 2:
							buf.vertexes[w++] = m.def.x;
							buf.vertexes[w++] = m.def.y;
						case 3:
							buf.vertexes[w++] = m.def.x;
							buf.vertexes[w++] = m.def.y;
							buf.vertexes[w++] = m.def.z;
						default:
							buf.vertexes[w++] = m.def.x;
							buf.vertexes[w++] = m.def.y;
							buf.vertexes[w++] = m.def.z;
							buf.vertexes[w++] = m.def.w;
						}
					}
					m = m.next;
				}
			}
			var r = 0;
			for( i in 0...buf.indexes.length )
				buf.indexes[i] = ibuf.get(r++) | (ibuf.get(r++) << 8);
		} else {
			var icount = geom.indexCounts[material];
			var vmap = new haxe.ds.Vector(geom.vertexCount);
			var vertexes = new hxd.FloatBuffer();
			buf.indexes = new haxe.ds.Vector(icount);
			var r = 0, vcount = 0;
			for( i in 0...buf.indexes.length ) {
				var vid = ibuf.get(r++) | (ibuf.get(r++) << 8);
				var rid = vmap[vid];
				if( rid == 0 ) {
					rid = ++vcount;
					vmap[vid] = rid;
					var m = map;
					while( m != null ) {
						if( m.def == null ) {
							var r = vid * geom.vertexStride;
							for( i in 0...m.size )
								vertexes.push(vbuf.getFloat((r + m.offset + i) << 2));
						} else {
							switch( m.size ) {
							case 1:
								vertexes.push(m.def.x);
							case 2:
								vertexes.push(m.def.x);
								vertexes.push(m.def.y);
							case 3:
								vertexes.push(m.def.x);
								vertexes.push(m.def.y);
								vertexes.push(m.def.z);
							default:
								vertexes.push(m.def.x);
								vertexes.push(m.def.y);
								vertexes.push(m.def.z);
								vertexes.push(m.def.w);
							}
						}
						m = m.next;
					}
				}
				buf.indexes[i] = rid - 1;
			}
			buf.vertexes = haxe.ds.Vector.fromData(vertexes.getNative());
		}

		entry.close();
		hxd.impl.Tmp.saveBytes(ibuf);
		hxd.impl.Tmp.saveBytes(vbuf);
		return buf;
	}

	function makePrimitive( id : Int ) {
		var p = cachedPrimitives[id];
		if( p != null ) return p;
		p = new h3d.prim.HMDModel(header.geometries[id], header.dataPosition, entry);
		cachedPrimitives[id] = p;
		return p;
	}

	function makeMaterial( mid : Int, loadTexture : String -> h3d.mat.Texture ) {
		var m = header.materials[mid];
		var mat = new h3d.mat.MeshMaterial();
		mat.name = m.name;
		if( m.diffuseTexture != null ) {
			mat.texture = loadTexture(m.diffuseTexture);
			if( mat.texture == null ) mat.texture = h3d.mat.Texture.fromColor(0xFF00FF);
		}
		mat.blendMode = m.blendMode;
		mat.mainPass.culling = m.culling;
		if( m.killAlpha != null ) {
			var t = mat.mainPass.getShader(h3d.shader.Texture);
			t.killAlpha = true;
			t.killAlphaThreshold = m.killAlpha;
		}
		return mat;
	}

	@:access(h3d.anim.Skin)
	function makeSkin( skin : Skin ) {
		var s = cachedSkin.get(skin.name);
		if( s != null )
			return s;
		s = new h3d.anim.Skin(skin.name, 0, 3);
		s.namedJoints = new Map();
		s.allJoints = [];
		s.boundJoints = [];
		s.rootJoints = [];
		for( joint in skin.joints ) {
			var j = new h3d.anim.Skin.Joint();
			j.name = joint.name;
			j.index = s.allJoints.length;
			j.defMat = joint.position.toMatrix();
			if( joint.bind >= 0 ) {
				j.bindIndex = joint.bind;
				j.transPos = joint.transpos.toMatrix();
				s.boundJoints[j.bindIndex] = j;
			}
			if( joint.parent >= 0 ) {
				var p = s.allJoints[joint.parent];
				p.subs.push(j);
				j.parent = p;
			} else
				s.rootJoints.push(j);
			s.allJoints.push(j);
			s.namedJoints.set(j.name, j);
		}
		if( skin.split != null ) {
			s.splitJoints = [];
			for( ss in skin.split )
				s.splitJoints.push( { material : ss.materialIndex, joints : [for( j in ss.joints ) s.allJoints[j]] } );
		}
		cachedSkin.set(skin.name, s);
		return s;
	}

	public function makeObject( ?loadTexture : String -> h3d.mat.Texture ) : h3d.scene.Object {
		if( loadTexture == null )
			loadTexture = function(_) return h3d.mat.Texture.fromColor(0xFF00FF);
		if( header.models.length == 0 )
			throw "This file does not contain any model";
		var objs = [];
		for( m in header.models ) {
			var obj : h3d.scene.Object;
			if( m.geometry < 0 ) {
				obj = new h3d.scene.Object();
			} else {
				var prim = makePrimitive(m.geometry);
				if( m.skin != null ) {
					var skinData = makeSkin(m.skin);
					skinData.primitive = prim;
					obj = new h3d.scene.Skin(skinData, [for( m in m.materials ) makeMaterial(m, loadTexture)]);
				} else if( m.materials.length == 1 )
					obj = new h3d.scene.Mesh(prim, makeMaterial(m.materials[0],loadTexture));
				else
					obj = new h3d.scene.MultiMaterial(prim, [for( m in m.materials ) makeMaterial(m,loadTexture)]);
			}
			obj.name = m.name;
			obj.defaultTransform = m.position.toMatrix();
			objs.push(obj);
			var p = objs[m.parent];
			if( p != null ) p.addChild(obj);
		}
		return objs[0];
	}

	public function loadAnimation( ?mode : h3d.anim.Mode, ?name : String ) : h3d.anim.Animation {

		if( mode != null && mode != LinearAnim )
			throw "Mode should be LinearAnim";

		var a = cachedAnimations.get(name == null ? "" : name);
		if( a != null )
			return a;

		var a = null;
		if( name == null ) {
			if( header.animations.length == 0 )
				return null;
			a = header.animations[0];
		} else {
			for( a2 in header.animations )
				if( a2.name == name ) {
					a = a2;
					break;
				}
			if( a == null )
				throw 'Animation $name not found !';
		}

		var l = makeAnimation(a);
		cachedAnimations.set(a.name, l);
		if( name == null ) cachedAnimations.set("", l);
		return l;
	}


	function makeAnimation( a : Animation ) {

		var l = new h3d.anim.LinearAnimation(a.name, a.frames, a.sampling);
		l.speed = a.speed;
		l.loop = a.loop;

		entry.open();
		entry.skip(header.dataPosition + a.dataPosition);

		for( o in a.objects ) {
			var pos = o.flags.has(HasPosition), rot = o.flags.has(HasRotation), scale = o.flags.has(HasScale);
			if( pos || rot || scale ) {
				var frameCount = a.frames;
				if( o.flags.has(SinglePosition) )
					frameCount = 1;
				var fl = new haxe.ds.Vector<h3d.anim.LinearAnimation.LinearFrame>(frameCount);
				var size = ((pos ? 3 : 0) + (rot ? 3 : 0) + (scale?3:0)) * 4 * frameCount;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				var p = 0;
				for( i in 0...frameCount ) {
					var f = new h3d.anim.LinearAnimation.LinearFrame();
					if( pos ) {
						f.tx = data.getFloat(p); p += 4;
						f.ty = data.getFloat(p); p += 4;
						f.tz = data.getFloat(p); p += 4;
					} else {
						f.tx = 0;
						f.ty = 0;
						f.tz = 0;
					}
					if( rot ) {
						f.qx = data.getFloat(p); p += 4;
						f.qy = data.getFloat(p); p += 4;
						f.qz = data.getFloat(p); p += 4;
						var qw = 1 - (f.qx * f.qx + f.qy * f.qy + f.qz * f.qz);
						f.qw = qw < 0 ? -Math.sqrt( -qw) : Math.sqrt(qw);
					} else {
						f.qx = 0;
						f.qy = 0;
						f.qz = 0;
						f.qw = 1;
					}
					if( scale ) {
						f.sx = data.getFloat(p); p += 4;
						f.sy = data.getFloat(p); p += 4;
						f.sz = data.getFloat(p); p += 4;
					} else {
						f.sx = 1;
						f.sy = 1;
						f.sz = 1;
					}
					fl[i] = f;
				}
				l.addCurve(o.name, fl, rot, scale);
				hxd.impl.Tmp.saveBytes(data);
			}
			if( o.flags.has(HasUV) ) {
				var fl = new haxe.ds.Vector(a.frames*2);
				var size = 2 * 4 * a.frames;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addUVCurve(o.name, fl);
				hxd.impl.Tmp.saveBytes(data);
			}
			if( o.flags.has(HasAlpha) ) {
				var fl = new haxe.ds.Vector(a.frames);
				var size = 4 * a.frames;
				var data = hxd.impl.Tmp.getBytes(size);
				entry.read(data, 0, size);
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addAlphaCurve(o.name, fl);
				hxd.impl.Tmp.saveBytes(data);
			}
		}

		entry.close();


		return l;
	}

}