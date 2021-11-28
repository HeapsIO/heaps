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
	public var vertexes : haxe.ds.Vector<hxd.impl.Float32>;
	public var indexes : haxe.ds.Vector<Int>;
	public function new() {
	}
}

class Library {

	public var resource(default,null) : hxd.res.Resource;
	public var header(default,null) : Data;
	var cachedPrimitives : Array<h3d.prim.HMDModel>;
	var cachedAnimations : Map<String, h3d.anim.Animation>;
	var cachedSkin : Map<String, h3d.anim.Skin>;

	public function new(res,  header) {
		this.resource = res;
		this.header = header;
		cachedPrimitives = [];
		cachedAnimations = new Map();
		cachedSkin = new Map();
	}

	public function getData() {
		var entry = resource.entry;
		var b = haxe.io.Bytes.alloc(entry.size - header.dataPosition);
		entry.readFull(b, header.dataPosition, b.length);
		return b;
	}

	public function getDefaultFormat( stride : Int ) {
		var format = [
			new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3),
		];
		var defs = [null];
		if( stride > 3 ) {
			format.push(new hxd.fmt.hmd.Data.GeometryFormat("normal", DVec3));
			defs.push(null);
		}
		if( stride > 6 ) {
			format.push(new hxd.fmt.hmd.Data.GeometryFormat("uv", DVec2));
			defs.push(null);
		}
		if( stride > 8 ) {
			format.push(new hxd.fmt.hmd.Data.GeometryFormat("color", DVec3));
			defs.push(new h3d.Vector(1, 1, 1));
		}
		if( stride > 11 )
			throw "Unsupported stride";
		return { format : format, defs : defs };
	}

	public function load( format : Array<GeometryFormat>, ?defaults : Array<h3d.Vector>, modelIndex = -1 ) {
		var vtmp = new h3d.Vector();
		var models = modelIndex < 0 ? header.models : [header.models[modelIndex]];
		var outVertex = new hxd.FloatBuffer();
		var outIndex = new hxd.IndexBuffer();
		var stride = 0;
		var mid = -1;
		for( f in format )
			stride += f.format.getSize();
		for( m in models ) {
			var geom = header.geometries[m.geometry];
			if( geom == null ) continue;
			for( mat in m.materials ) {
				if( mid < 0 ) mid = mat;
				if( mid != mat ) throw "Models have several materials";
			}
			var pos = m.position.toMatrix();
			var data = getBuffers(geom, format, defaults);
			var start = Std.int(outVertex.length / stride);
			for( i in 0...Std.int(data.vertexes.length / stride) ) {
				var p = i * stride;
				vtmp.x = data.vertexes[p++];
				vtmp.y = data.vertexes[p++];
				vtmp.z = data.vertexes[p++];
				vtmp.transform3x4(pos);
				outVertex.push(vtmp.x);
				outVertex.push(vtmp.y);
				outVertex.push(vtmp.z);
				for( j in 0...stride - 3 )
					outVertex.push(data.vertexes[p++]);
			}
			for( idx in data.indexes )
				outIndex.push(idx + start);
		}
		return { vertex : outVertex, index : outIndex };
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
		var vbuf = haxe.io.Bytes.alloc(vsize);
		var entry = resource.entry;

		entry.readFull(vbuf, header.dataPosition + geom.vertexPosition, vsize);

		var dataPos = header.dataPosition + geom.indexPosition;
		var isSmall = geom.vertexCount <= 0x10000;
		var imult = isSmall ? 2 : 4;

		var isize;
		if( material == null )
			isize = geom.indexCount * imult;
		else {
			var ipos = 0;
			for( i in 0...material )
				ipos += geom.indexCounts[i];
			dataPos += ipos * imult;
			isize = geom.indexCounts[material] * imult;
		}
		var ibuf = haxe.io.Bytes.alloc(isize);
		entry.readFull(ibuf, dataPos, isize);

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
			if( isSmall ) {
				var r = 0;
				for( i in 0...buf.indexes.length )
					buf.indexes[i] = ibuf.get(r++) | (ibuf.get(r++) << 8);
			} else {
				for( i in 0...buf.indexes.length )
					buf.indexes[i] = ibuf.getInt32(i << 2);
			}
		} else {
			var icount = geom.indexCounts[material];
			var vmap = new haxe.ds.Vector(geom.vertexCount);
			var vertexes = new hxd.FloatBuffer();
			buf.indexes = new haxe.ds.Vector(icount);
			var r = 0, vcount = 0;
			for( i in 0...buf.indexes.length ) {
				var vid = isSmall ? (ibuf.get(r++) | (ibuf.get(r++) << 8)) : ibuf.getInt32(i<<2);
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
			#if neko
			buf.vertexes = haxe.ds.Vector.fromArrayCopy(vertexes.getNative());
			#else
			buf.vertexes = haxe.ds.Vector.fromData(vertexes.getNative());
			#end
		}

		return buf;
	}

	function makePrimitive( id : Int ) {
		var p = cachedPrimitives[id];
		if( p != null ) return p;
		p = new h3d.prim.HMDModel(header.geometries[id], header.dataPosition, this);
		p.incref(); // Prevent from auto-disposing
		cachedPrimitives[id] = p;
		return p;
	}

	function makeMaterial( model : Model, mid : Int, loadTexture : String -> h3d.mat.Texture ) {
		var m = header.materials[mid];
		var mat = h3d.mat.MaterialSetup.current.createMaterial();
		mat.name = m.name;
		if( m.diffuseTexture != null ) {
			mat.texture = loadTexture(m.diffuseTexture);
			if( mat.texture == null ) mat.texture = h3d.mat.Texture.fromColor(0xFF00FF);
		}
		if( m.specularTexture != null )
			mat.specularTexture = loadTexture(m.specularTexture);
		if( m.normalMap != null )
			mat.normalMap = loadTexture(m.normalMap);
		mat.blendMode = m.blendMode;
		mat.model = resource;
		var props = h3d.mat.MaterialSetup.current.loadMaterialProps(mat);
		if( props == null ) props = mat.getDefaultModelProps();
		mat.props = props;
		return mat;
	}

	@:access(h3d.anim.Skin)
	function makeSkin( skin : Skin, geom : Geometry ) {
		var s = cachedSkin.get(skin.name);
		if( s != null )
			return s;
		s = new h3d.anim.Skin(skin.name, 0, geom.props != null && geom.props.indexOf(FourBonesByVertex) >= 0 ? 4 : 3 );
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
				j.transPos = joint.transpos.toMatrix(true);
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

	public function getModelProperty<T>( objName : String, p : Property<T>, ?def : Null<T> ) : Null<T> {
		for( m in header.models )
			if( m.name == objName ) {
				if( m.props != null )
					for( pr in m.props )
						if( pr.getIndex() == p.getIndex() )
							return pr.getParameters()[0];
				return def;
			}
		if( def == null )
			throw 'Model ${objName} not found';
		return def;
	}

	#if !dataOnly
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
					var skinData = makeSkin(m.skin, header.geometries[m.geometry]);
					skinData.primitive = prim;
					obj = new h3d.scene.Skin(skinData, [for( mat in m.materials ) makeMaterial(m, mat, loadTexture)]);
				} else if( m.materials.length == 1 )
					obj = new h3d.scene.Mesh(prim, makeMaterial(m, m.materials[0],loadTexture));
				else
					obj = new h3d.scene.MultiMaterial(prim, [for( mat in m.materials ) makeMaterial(m, mat, loadTexture)]);
			}
			obj.name = m.name;
			obj.defaultTransform = m.position.toMatrix();
			objs.push(obj);
			var p = objs[m.parent];
			if( p != null ) p.addChild(obj);
		}
		var o = objs[0];
		if( o != null ) o.modelRoot = true;
		return o;
	}
	#end

	public function loadAnimation( ?name : String ) : h3d.anim.Animation {

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

		var l = header.version <= 2 ? makeLinearAnimation(a) : makeAnimation(a);
		l.speed = a.speed;
		l.loop = a.loop;
		if( a.events != null ) l.setEvents(a.events);
		l.resourcePath = resource.entry.path;
		cachedAnimations.set(a.name, l);
		if( name == null ) cachedAnimations.set("", l);
		return l;
	}

	function makeAnimation( a : Animation ) {
		var b = new h3d.anim.BufferAnimation(a.name, a.frames, a.sampling);

		var stride = 0;
		var singleFrames = [];
		var otherFrames = [];
		for( o in a.objects ) {
			var c = b.addObject(o.name, 0);
			var sm = 1;
			if( o.flags.has(SingleFrame) ) {
				c.layout.set(SingleFrame);
				singleFrames.push(c);
				sm = 0;
			} else
				otherFrames.push(c);
			if( o.flags.has(HasPosition) ) {
				c.layout.set(Position);
				stride += 3 * sm;
			}
			if( o.flags.has(HasRotation) ) {
				c.layout.set(Rotation);
				stride += 3 * sm;
			}
			if( o.flags.has(HasScale) ) {
				c.layout.set(Scale);
				stride += 3 * sm;
			}
			if( o.flags.has(HasUV) ) {
				c.layout.set(UV);
				stride += 2 * sm;
			}
			if( o.flags.has(HasAlpha) ) {
				c.layout.set(Alpha);
				stride += sm;
			}
			if( o.flags.has(HasProps) ) {
				for( i in 0...o.props.length ) {
					var c = c;
					if( i > 0 ) {
						c = b.addObject(o.name, 0);
						if( sm == 0 ) singleFrames.push(c) else otherFrames.push(c);
					}
					c.layout.set(Property);
					c.propName = o.props[i];
					stride += sm;
				}
			}
		}

		// assign data offsets
		var pos = 0;
		for( b in singleFrames ) {
			b.dataOffset = pos;
			pos += b.getStride();
		}
		var singleStride = pos;
		for( b in otherFrames ) {
			b.dataOffset = pos;
			pos += b.getStride();
		}

		var entry = resource.entry;
		var count = stride * a.frames + singleStride;
		var data = haxe.io.Bytes.alloc(count * 4);
		entry.readFull(data,header.dataPosition + a.dataPosition,data.length);

		#if hl
		b.setData(data, stride);
		#elseif js
		b.setData(new hxd.impl.TypedArray.Float32Array(@:privateAccess data.b.buffer), stride);
		#else
		var v = new hxd.impl.TypedArray.Float32Array(count);
		for( i in 0...count )
			v[i] = data.getFloat(i << 2);
		b.setData(v, stride);
		#end

		return b;
	}

	function makeLinearAnimation( a : Animation ) {
		var l = new h3d.anim.LinearAnimation(a.name, a.frames, a.sampling);

		var entry = resource.entry;
		var dataPos = header.dataPosition + a.dataPosition;

		for( o in a.objects ) {
			var pos = o.flags.has(HasPosition), rot = o.flags.has(HasRotation), scale = o.flags.has(HasScale);
			if( pos || rot || scale ) {
				var frameCount = a.frames;
				if( o.flags.has(SingleFrame) )
					frameCount = 1;
				var fl = new haxe.ds.Vector<h3d.anim.LinearAnimation.LinearFrame>(frameCount);
				var size = ((pos ? 3 : 0) + (rot ? 3 : 0) + (scale?3:0)) * 4 * frameCount;
				var data = entry.fetchBytes(dataPos, size);
				dataPos += size;
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
				l.addCurve(o.name, fl, true, rot, scale);
			}
			if( o.flags.has(HasUV) ) {
				var fl = new haxe.ds.Vector(a.frames*2);
				var size = 2 * 4 * a.frames;
				var data = entry.fetchBytes(dataPos, size);
				dataPos += size;
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addUVCurve(o.name, fl);
			}
			if( o.flags.has(HasAlpha) ) {
				var fl = new haxe.ds.Vector(a.frames);
				var size = 4 * a.frames;
				var data = entry.fetchBytes(dataPos, size);
				dataPos += size;
				for( i in 0...fl.length )
					fl[i] = data.getFloat(i * 4);
				l.addAlphaCurve(o.name, fl);
			}
			if( o.flags.has(HasProps) ) {
				for( p in o.props ) {
					var fl = new haxe.ds.Vector(a.frames);
					var size = 4 * a.frames;
					var data = entry.fetchBytes(dataPos, size);
					dataPos += size;
					for( i in 0...fl.length )
						fl[i] = data.getFloat(i * 4);
					l.addPropCurve(o.name, p, fl);
				}
			}
		}

		return l;
	}

	@:allow(h3d.anim.Skin)
	public function loadSkin( geom : Geometry, skin : h3d.anim.Skin, optimize = true ) {
		if( skin.vertexWeights != null )
			return;

		if( skin.bonesPerVertex != 3 )
			throw "assert";

		@:privateAccess skin.vertexCount = geom.vertexCount;
		var data = getBuffers(geom, [
			new hxd.fmt.hmd.Data.GeometryFormat("position",DVec3),
			new hxd.fmt.hmd.Data.GeometryFormat("weights",DVec3),
			new hxd.fmt.hmd.Data.GeometryFormat("indexes",DBytes4)]);
		skin.vertexWeights = new haxe.ds.Vector(skin.vertexCount * skin.bonesPerVertex);
		skin.vertexJoints = new haxe.ds.Vector(skin.vertexCount * skin.bonesPerVertex);

		for( j in skin.boundJoints )
			j.offsets = new h3d.col.Bounds();

		var vbuf = data.vertexes;
		var idx = 0;
		var bounds = new h3d.col.Bounds();
		var out = Math.NaN;
		var ranges;
		if( skin.splitJoints == null ) {
			var jointsByBind = [];
			for( j in skin.boundJoints )
				jointsByBind[j.bindIndex] = j;
			ranges = [{ index : 0, pos : 0, count : data.indexes.length, joints : jointsByBind }];
		} else {
			var idx = 0;
			var triPos = [], pos = 0;
			for( n in geom.indexCounts ) {
				triPos.push(pos);
				pos += n;
			}
			ranges = [for( j in skin.splitJoints ) @:privateAccess {
				index : idx,
				pos : triPos[idx],
				count : geom.indexCounts[idx++],
				joints : j.joints,
			}];
		}


		// for each joint, calculate the bounds of vertexes skinned to this joint, in absolute position
		for( r in ranges ) {
			for( idx in r.pos...r.pos+r.count ) {
				var vidx = data.indexes[idx];
				var p = vidx * 7;
				var x = vbuf[p];
				if( x != x ) {
					// already processed
					continue;
				}
				vbuf[p++] = out;
				var y = vbuf[p++];
				var z = vbuf[p++];
				var w1 = vbuf[p++];
				var w2 = vbuf[p++];
				var w3 = vbuf[p++];

				var vout = vidx * 3;
				skin.vertexWeights[vout] = w1;
				skin.vertexWeights[vout+1] = w2;
				skin.vertexWeights[vout+2] = w3;

				var w = (w1 == 0 ? 1 : 0) | (w2 == 0 ? 2 : 0) | (w3 == 0 ? 4 : 0);
				var idx = haxe.io.FPHelper.floatToI32(vbuf[p++]);
				bounds.addPos(x,y,z);
				for( i in 0...3 ) {
					if( w & (1<<i) != 0 ) {
						skin.vertexJoints[vout++] = -1;
						continue;
					}
					var idx = (idx >> (i<<3)) & 0xFF;
					var j = r.joints[idx];
					j.offsets.addPos(x,y,z);
					skin.vertexJoints[vout++] = j.bindIndex;
				}
			}
		}

		if( optimize ) {
			var idx = skin.allJoints.length - 1;
			var optOut = 0;
			var refVolume = bounds.getVolume();
			while( idx >= 0 ) {
				var j = skin.allJoints[idx--];
				if( j.offsets == null || j.parent == null || j.parent.offsets == null ) continue;
				var poff = j.parent.offsets;

				// assume our joints will only rotate
				var sp = j.offsets.toSphere();
				if( poff.containsSphere(sp) ) {
					j.offsets = null;
					optOut++;
					continue;
				}

				var pext = poff.clone();
				pext.addSphere(sp);

				// heuristic to allow children bounds to be merged within parent
				// this allow to calculate less joints when getting skin bounds
				var ratio = Math.sqrt((refVolume * 1.5) / pext.getVolume());
				var k = pext.getVolume() / poff.getVolume();

				if( k < ratio ) {
					j.parent.offsets = pext;
					j.offsets = null;
					optOut++;
					continue;
				}
			}
		}

		// transform bounds into two spheres aligned on largest
		// size. this allows Skin.getBounds to perform two transforms
		// insteas of height for each bounds corners
		for( j in skin.allJoints ) {
			if( j.offsets == null ) {
				j.offsetRay = -1;
				continue;
			}
			var b = j.offsets;
			var pt1, pt2, off = b.getCenter(), r;
			if( b.xSize > b.ySize && b.xSize > b.zSize ) {
				r = Math.max(b.ySize, b.zSize) * 0.5;
				pt1 = new h3d.col.Point(b.xMin + r, off.y, off.z);
				pt2 = new h3d.col.Point(b.xMax - r, off.y, off.z);
			} else if( b.ySize > b.zSize ) {
				r = Math.max(b.xSize, b.zSize) * 0.5;
				pt1 = new h3d.col.Point(off.x, b.yMin + r, off.z);
				pt2 = new h3d.col.Point(off.x, b.yMax - r, off.z);
			} else {
				r = Math.max(b.xSize, b.ySize) * 0.5;
				pt1 = new h3d.col.Point(off.x, off.y, b.zMin + r);
				pt2 = new h3d.col.Point(off.x, off.y, b.zMax - r);
			}
			b.setMin(pt1);
			b.setMax(pt2);
			j.offsetRay = r;
		}
	}

}