package hxd.fmt.gltf;
import hxd.fmt.gltf.Data;
import hxd.fmt.hmd.Data;

private class GltfObject {
	public var index : Int;
	public var node : GltfNode;
	public var name : String;
	public var parent : GltfObject;
	public var children : Array<GltfObject> = [];
	public var isJoint = false;
	public var model = -1;

	// local transform in glTF space
	public var gltfPos : Array<Float>;
	public var gltfRot : Array<Float>;
	public var gltfScale : Array<Float>;

	var world : h3d.Matrix;

	public function new(index, node) {
		this.index = index;
		this.node = node;
	}

	public function getLocal() {
		return Library.makeMatrix(gltfPos, gltfRot, gltfScale);
	}

	public function getWorld() {
		if( world == null ) {
			world = getLocal();
			if( parent != null )
				world.multiply(world, parent.getWorld());
		}
		return world;
	}
}

private class MeshData {
	public var vertexCount = 0;
	public var positions : Array<Float> = [];
	public var normals : Array<Float> = [];
	public var hasNormals = false;
	public var uvs : Array<Array<Float>> = [];
	public var colors : Array<Float> = null;
	public var joints : Array<Float> = null;
	public var weights : Array<Float> = null;
	public var influences = 0;
	public var triangles : Array<Int> = [];
	public var triSlots : Array<Int> = [];
	public var slotCount = 0;
	public function new() {
	}
}

private typedef AnimSampler = {
	var times : Array<Float>;
	var values : Array<Float>;
	var interpolation : String;
	var comps : Int;
}

class Library extends hxd.fmt.Library {

	/**
		Frames per second used to resample animations. When null, it is detected from the keyframes (30 by default).
	**/
	public var animationSampling : Null<Float>;

	var gltf : hxd.fmt.gltf.Data;
	var doc : GltfDocument;
	var buffers : Array<haxe.io.Bytes>;
	var objects : Array<GltfObject>;
	var roots : Array<GltfObject>;
	var accessorCache : Map<Int, Array<Float>>;
	var hmat : Map<Int, Int>;
	var defaultMaterial : Null<Int>;
	var rootJointFix : Map<Int, h3d.Matrix>;
	var skinCount : Int;

	public function loadFile( data : haxe.io.Bytes ) {
		load(Parser.parse(data));
	}

	public function load( data : hxd.fmt.gltf.Data ) {
		gltf = data;
		doc = data.doc;
		buffers = [];
		accessorCache = new Map();
		if( doc.extensionsRequired != null )
			for( e in doc.extensionsRequired )
				if( !StringTools.startsWith(e, "KHR_materials_") )
					throw 'Unsupported required glTF extension $e' + (fileName == null ? "" : ' in $fileName');
		buildHierarchy();
	}

	public function toHMD( filePath : String, includeGeometry : Bool ) : Data {
		initData(filePath);
		hmat = new Map();
		defaultMaterial = null;
		skinCount = 0;
		initRootJointFix();
		addModels(includeGeometry);
		addAnimations();
		return flushData();
	}


	static inline function convVector( x : Float, y : Float, z : Float ) {
		return new h3d.Vector(z, -x, y);
	}

	static inline function convQuat( x : Float, y : Float, z : Float, w : Float ) {
		return new h3d.Quat(-z, x, -y, w);
	}

	static inline function convScale( x : Float, y : Float, z : Float ) {
		return new h3d.Vector(z, x, y);
	}

	static function convMatrix( a : Array<Float>, pos = 0 ) {
		var m = new h3d.Matrix();
		m._11 = a[pos]; m._12 = a[pos+1]; m._13 = a[pos+2]; m._14 = a[pos+3];
		m._21 = a[pos+4]; m._22 = a[pos+5]; m._23 = a[pos+6]; m._24 = a[pos+7];
		m._31 = a[pos+8]; m._32 = a[pos+9]; m._33 = a[pos+10]; m._34 = a[pos+11];
		m._41 = a[pos+12]; m._42 = a[pos+13]; m._43 = a[pos+14]; m._44 = a[pos+15];
		// M' = C^T * M * C
		var c = new h3d.Matrix();
		c.zero();
		c._31 = 1; c._12 = -1; c._23 = 1; c._44 = 1;
		var ct = c.clone();
		ct.transpose();
		var r = new h3d.Matrix();
		r.multiply(ct, m);
		r.multiply(r, c);
		return r;
	}

	public static function makeMatrix( t : Array<Float>, r : Array<Float>, s : Array<Float> ) {
		var q = convQuat(r[0], r[1], r[2], r[3]);
		q.normalize();
		var m = q.toMatrix();
		var sc = convScale(s[0], s[1], s[2]);
		m.prependScale(sc.x, sc.y, sc.z);
		var p = convVector(t[0], t[1], t[2]);
		m.translate(p.x, p.y, p.z);
		return m;
	}


	static function decompose( a : Array<Float> ) {
		var t = [a[12], a[13], a[14]];
		var sx = Math.sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]);
		var sy = Math.sqrt(a[4] * a[4] + a[5] * a[5] + a[6] * a[6]);
		var sz = Math.sqrt(a[8] * a[8] + a[9] * a[9] + a[10] * a[10]);
		var det = a[0] * (a[5] * a[10] - a[6] * a[9]) - a[4] * (a[1] * a[10] - a[2] * a[9]) + a[8] * (a[1] * a[6] - a[2] * a[5]);
		if( det < 0 ) sx = -sx;
		// columns of the glTF matrix are the rows of a Heaps matrix
		var m = new h3d.Matrix();
		m.identity();
		if( sx != 0 ) { m._11 = a[0] / sx; m._12 = a[1] / sx; m._13 = a[2] / sx; }
		if( sy != 0 ) { m._21 = a[4] / sy; m._22 = a[5] / sy; m._23 = a[6] / sy; }
		if( sz != 0 ) { m._31 = a[8] / sz; m._32 = a[9] / sz; m._33 = a[10] / sz; }
		var q = new h3d.Quat();
		q.initRotateMatrix(m);
		q.normalize();
		return { t : t, r : [q.x, q.y, q.z, q.w], s : [sx, sy, sz] };
	}

	static function decomposeHeaps( m : h3d.Matrix ) {
		var s = m.getScale();
		var det = m._11 * (m._22 * m._33 - m._23 * m._32) - m._12 * (m._21 * m._33 - m._23 * m._31) + m._13 * (m._21 * m._32 - m._22 * m._31);
		if( det < 0 ) s.x = -s.x;
		var r = m.clone();
		r.prependScale(s.x == 0 ? 1 : 1 / s.x, s.y == 0 ? 1 : 1 / s.y, s.z == 0 ? 1 : 1 / s.z);
		r._41 = r._42 = r._43 = 0;
		var q = new h3d.Quat();
		q.initRotateMatrix(r);
		q.normalize();
		return { t : m.getPosition(), q : q, s : s };
	}


	function getBuffer( index : Int ) : haxe.io.Bytes {
		var b = buffers[index];
		if( b != null )
			return b;
		var buf = doc.buffers[index];
		var uri = buf.uri;
		if( uri == null ) {
			if( gltf.bin == null )
				throw "Missing binary chunk for buffer " + index;
			b = gltf.bin;
		} else if( StringTools.startsWith(uri, "data:") ) {
			b = decodeDataUri(uri);
		} else {
			var path = resolveUri(uri);
			b = try hxd.File.getBytes(path) catch( e : Dynamic ) throw "Could not load glTF buffer " + path;
		}
		if( b.length < buf.byteLength )
			throw "Buffer " + index + " is too small (" + b.length + " < " + buf.byteLength + ")";
		buffers[index] = b;
		return b;
	}

	function decodeDataUri( uri : String ) {
		var comma = uri.indexOf(",");
		if( comma < 0 || uri.substr(comma - 7, 7) != ";base64" )
			throw "Unsupported data uri";
		return haxe.crypto.Base64.decode(uri.substr(comma + 1));
	}

	function resolveUri( uri : String ) {
		var dir = fileName == null ? "" : haxe.io.Path.directory(fileName.split("\\").join("/"));
		var path = StringTools.urlDecode(uri);
		return dir == "" ? path : dir + "/" + path;
	}

	static function componentCount( type : String ) {
		return switch( type ) {
		case "SCALAR": 1;
		case "VEC2": 2;
		case "VEC3": 3;
		case "VEC4", "MAT2": 4;
		case "MAT3": 9;
		case "MAT4": 16;
		default: throw "Invalid accessor type " + type;
		}
	}

	function readAccessor( index : Int ) : Array<Float> {
		var out = accessorCache.get(index);
		if( out != null )
			return out;
		var a = doc.accessors[index];
		var comps = componentCount(a.type);
		var normalized = a.normalized == true;
		if( a.bufferView != null )
			out = readComponents(a.bufferView, a.byteOffset ?? 0, a.componentType, normalized, comps, a.count);
		else
			out = [for( i in 0...a.count * comps ) 0.];
		var sparse = a.sparse;
		if( sparse != null ) {
			var indexes = readComponents(sparse.indices.bufferView, sparse.indices.byteOffset ?? 0, sparse.indices.componentType, false, 1, sparse.count);
			var values = readComponents(sparse.values.bufferView, sparse.values.byteOffset ?? 0, a.componentType, normalized, comps, sparse.count);
			for( i in 0...sparse.count ) {
				var idx = Std.int(indexes[i]);
				for( c in 0...comps )
					out[idx * comps + c] = values[i * comps + c];
			}
		}
		accessorCache.set(index, out);
		return out;
	}

	function readComponents( viewIndex : Int, offset : Int, type : GltfComponentType, normalized : Bool, comps : Int, count : Int ) : Array<Float> {
		var view = doc.bufferViews[viewIndex];
		var bytes = getBuffer(view.buffer);
		var size = type.getSize();
		var stride = view.byteStride == null || view.byteStride == 0 ? size * comps : view.byteStride;
		var start = (view.byteOffset ?? 0) + offset;
		if( count > 0 && start + (count - 1) * stride + comps * size > bytes.length )
			throw "Accessor out of buffer bounds";
		var out = new Array<Float>();
		out.resize(count * comps);
		var k = 0;
		for( i in 0...count ) {
			var p = start + i * stride;
			for( c in 0...comps ) {
				var v : Float = switch( type ) {
				case Byte:
					var v = bytes.get(p);
					if( v >= 128 ) v -= 256;
					normalized ? Math.max(v / 127, -1) : v;
				case UnsignedByte:
					var v = bytes.get(p);
					normalized ? v / 255 : v;
				case Short:
					var v = bytes.getUInt16(p);
					if( v >= 32768 ) v -= 65536;
					normalized ? Math.max(v / 32767, -1) : v;
				case UnsignedShort:
					var v = bytes.getUInt16(p);
					normalized ? v / 65535 : v;
				case UnsignedInt:
					var v : Float = bytes.getInt32(p);
					if( v < 0 ) v += 4294967296.;
					v;
				case Float32:
					bytes.getFloat(p);
				default:
					throw "Invalid component type " + type;
				}
				out[k++] = v;
				p += size;
			}
		}
		return out;
	}

	function readInts( index : Int ) : Array<Int> {
		return [for( v in readAccessor(index) ) Std.int(v)];
	}


	function buildHierarchy() {
		objects = [];
		var nodes = doc.nodes ?? [];
		for( i => n in nodes ) {
			var o = new GltfObject(i, n);
			o.name = n.name;
			if( o.name == null || o.name == "" ) {
				var mesh = n.mesh == null ? null : doc.meshes[n.mesh];
				var meshName = mesh == null ? null : mesh.name;
				// don't use mesh names that would be interpreted as LODs
				o.name = meshName != null && meshName != "" && getLODInfos(meshName).lodLevel < 0 ? meshName : "Node" + i;
			}
			if( n.matrix != null ) {
				var m : Array<Float> = n.matrix;
				var trs = decompose(m);
				o.gltfPos = trs.t;
				o.gltfRot = trs.r;
				o.gltfScale = trs.s;
			} else {
				o.gltfPos = n.translation == null ? [0., 0., 0.] : [for( v in n.translation ) (v:Float)];
				o.gltfRot = n.rotation == null ? [0., 0., 0., 1.] : [for( v in n.rotation ) (v:Float)];
				o.gltfScale = n.scale == null ? [1., 1., 1.] : [for( v in n.scale ) (v:Float)];
			}
			objects.push(o);
		}
		for( o in objects ) {
			if( o.node.children == null ) continue;
			for( c in o.node.children ) {
				var child = objects[c];
				if( child == null || child.parent != null || child == o )
					throw "Invalid glTF node hierarchy for node " + c;
				child.parent = o;
				o.children.push(child);
			}
		}
		// detect cycles
		for( o in objects ) {
			var p = o.parent, depth = 0;
			while( p != null ) {
				if( ++depth > objects.length ) throw "Invalid glTF node hierarchy : cycle detected";
				p = p.parent;
			}
		}

		var scene = null;
		if( doc.scenes != null && doc.scenes.length > 0 )
			scene = doc.scenes[doc.scene ?? 0];
		if( scene != null && scene.nodes != null )
			roots = [for( i in scene.nodes ) objects[i]];
		else
			roots = [for( o in objects ) if( o.parent == null ) o];

		if( doc.skins != null )
			for( s in doc.skins )
				for( j in s.joints )
					objects[j].isJoint = true;
	}

	function makeTRSPosition( t : Array<Float>, r : Array<Float>, s : Array<Float> ) {
		var p = new Position();
		var pos = convVector(t[0], t[1], t[2]);
		var q = convQuat(r[0], r[1], r[2], r[3]);
		var sc = convScale(s[0], s[1], s[2]);
		q.normalize();
		if( q.w < 0 ) q.negate();
		p.x = round(pos.x);
		p.y = round(pos.y);
		p.z = round(pos.z);
		p.qx = round(q.x);
		p.qy = round(q.y);
		p.qz = round(q.z);
		p.sx = round(sc.x);
		p.sy = round(sc.y);
		p.sz = round(sc.z);
		return p;
	}


	function addModels( includeGeometry : Bool ) {
		if( !includeGeometry )
			return;

		var root = new Model();
		root.name = null;
		root.parent = -1;
		root.position = makeTRSPosition([0, 0, 0], [0, 0, 0, 1], [1, 1, 1]);
		root.geometry = -1;
		d.models.push(root);

		var hgeom = new Map<String, { gid : Int, materials : Array<Int>, skin : Skin }>();
		var hgeomCol = new Map<Int, hxd.fmt.Library.GeometryCollideData>();
		var hlods = new Map<String, Array<Index<Model>>>();

		function addRec( o : GltfObject, parent : Int, follow : String ) {
			if( o.isJoint ) {
				// joints are part of the skin, the objects attached to them follow the joint
				for( c in o.children )
					addRec(c, -1, o.name);
				return;
			}
			var model = new Model();
			model.name = o.name;
			model.parent = parent;
			model.follow = follow;
			model.position = makeTRSPosition(o.gltfPos, o.gltfRot, o.gltfScale);
			model.geometry = -1;

			if( o.node.camera != null ) {
				var cam = doc.cameras[o.node.camera];
				if( cam != null && cam.perspective != null ) {
					model.props = [CameraFOVY(cam.perspective.yfov * 180 / Math.PI)];
				}
			}

			o.model = d.models.length;
			d.models.push(model);
			if( o.node.mesh != null )
				addMesh(o, model, hgeom, hgeomCol, hlods);
			for( c in o.children )
				addRec(c, o.model, null);
		}
		for( r in roots )
			addRec(r, 0, null);

		removeUselessRoot();
		buildColliders(hgeomCol);
	}

	function addMesh( o : GltfObject, model : Model, hgeom : Map<String, { gid : Int, materials : Array<Int>, skin : Skin }>, hgeomCol : Map<Int, hxd.fmt.Library.GeometryCollideData>, hlods : Map<String, Array<Index<Model>>> ) {
		var mesh = doc.meshes[o.node.mesh];
		var key = o.node.mesh + ":" + o.node.skin;

		// materials slots
		var slots = [];
		for( p in mesh.primitives ) {
			if( !isTriangleMode(p.mode ?? Triangles) ) continue;
			var m = p.material ?? -1;
			if( slots.indexOf(m) < 0 ) slots.push(m);
		}
		if( slots.length == 0 )
			return; // points or lines only
		var mids = [for( m in slots ) getMaterial(m)];
		var hasNormalMap = false;
		for( mid in mids )
			if( d.materials[mid].normalMap != null )
				hasNormalMap = true;

		var gdata = hgeom.get(key);
		if( gdata == null ) {
			var data = readMesh(mesh, slots);
			var skin = o.node.skin == null ? null : createSkin(o, data);
			var geom = buildGeom(data, skin, hasNormalMap || generateTangents, 0);
			gdata = { gid : d.geometries.length, materials : geom.materials, skin : skin == null ? null : makeSkin(skin) };
			if( gdata.skin != null )
				gdata.skin.name = skinCount++ == 0 ? "Skin" : "Skin" + skinCount;
			d.geometries.push(geom.g);
			hgeom.set(key, gdata);
			hgeomCol.set(gdata.gid, { gid : gdata.gid, mids : mids, vbuf : geom.vbuf, ibufs : geom.ibufs });

			model.geometry = gdata.gid;
			model.skin = gdata.skin;
			model.materials = gdata.materials == null ? mids : [for( id in gdata.materials ) mids[id]];
			if( !registerLOD(model, hlods) && lodsDecimation != null && model.skin == null && !model.isCollider() )
				addDecimatedLODs(model, mids, hgeomCol, (factor) -> buildGeom(data, null, hasNormalMap || generateTangents, factor));
			return;
		}
		model.geometry = gdata.gid;
		model.skin = gdata.skin;
		model.materials = gdata.materials == null ? mids : [for( id in gdata.materials ) mids[id]];
		registerLOD(model, hlods);
	}

	static function isTriangleMode( mode : GltfPrimitiveMode ) {
		return mode == Triangles || mode == TriangleStrip || mode == TriangleFan;
	}


	function getMaterial( index : Int ) : Int {
		if( index < 0 ) {
			if( defaultMaterial == null )
				defaultMaterial = addDefaultMaterial();
			return defaultMaterial;
		}
		var mid = hmat.get(index);
		if( mid != null )
			return mid;
		var m = doc.materials[index];
		var mat = new Material();
		mat.name = m.name == null || m.name == "" ? "Material" + index : m.name;
		mat.blendMode = m.alphaMode == "BLEND" ? Alpha : None;
		var pbr = m.pbrMetallicRoughness;
		if( pbr != null && pbr.baseColorTexture != null )
			mat.diffuseTexture = getTexturePath(pbr.baseColorTexture.index);
		if( m.normalTexture != null )
			mat.normalMap = getTexturePath(m.normalTexture.index);
		if( mat.normalMap != null )
			mat.props = [HasExtraTextures];
		mid = d.materials.length;
		d.materials.push(mat);
		hmat.set(index, mid);
		return mid;
	}

	/**
		Returns the path of an external texture. Textures embedded in the file are not supported.
	**/
	function getTexturePath( textureIndex : Int ) : String {
		var tex = doc.textures == null ? null : doc.textures[textureIndex];
		if( tex == null || tex.source == null )
			return null;
		var img = doc.images[tex.source];
		if( img == null || img.uri == null || StringTools.startsWith(img.uri, "data:") )
			return null;
		return resolveTexturePath(resolveUri(img.uri));
	}


	function readMesh( mesh : GltfMesh, slots : Array<Int> ) : MeshData {
		var data = new MeshData();
		data.slotCount = slots.length;

		// count attributes
		var uvCount = 0, hasColor = false, influences = 0;
		for( p in mesh.primitives ) {
			if( !isTriangleMode(p.mode ?? Triangles) ) continue;
			var n = 0;
			while( p.attributes.exists("TEXCOORD_" + n) ) n++;
			if( n > uvCount ) uvCount = n;
			if( p.attributes.exists("COLOR_0") ) hasColor = true;
			var n = 0;
			while( p.attributes.exists("JOINTS_" + n) && p.attributes.exists("WEIGHTS_" + n) ) n++;
			if( n * 4 > influences ) influences = n * 4;
		}
		if( maxUVs > 0 && uvCount > maxUVs )
			uvCount = maxUVs;
		for( i in 0...uvCount )
			data.uvs.push([]);
		if( hasColor && !noColor )
			data.colors = [];
		if( influences > 0 ) {
			data.influences = influences;
			data.joints = [];
			data.weights = [];
		}

		for( p in mesh.primitives ) {
			var mode : GltfPrimitiveMode = p.mode ?? Triangles;
			if( !isTriangleMode(mode) ) continue;
			var posAcc = p.attributes.get("POSITION");
			if( posAcc == null )
				continue;
			if( p.extensions != null && Reflect.hasField(p.extensions, "KHR_draco_mesh_compression") )
				throw "Draco compressed meshes are not supported" + (fileName == null ? "" : ' ($fileName)');
			var offset = data.vertexCount;
			var count = doc.accessors[posAcc].count;
			data.vertexCount += count;

			var pos = readAccessor(posAcc);
			for( i in 0...count ) {
				var v = convVector(pos[i * 3], pos[i * 3 + 1], pos[i * 3 + 2]);
				data.positions.push(v.x);
				data.positions.push(v.y);
				data.positions.push(v.z);
			}

			var nacc = p.attributes.get("NORMAL");
			if( nacc != null ) {
				data.hasNormals = true;
				var nrm = readAccessor(nacc);
				for( i in 0...count ) {
					var v = convVector(nrm[i * 3], nrm[i * 3 + 1], nrm[i * 3 + 2]);
					data.normals.push(v.x);
					data.normals.push(v.y);
					data.normals.push(v.z);
				}
			} else {
				// will use flat normals
				for( i in 0...count * 3 )
					data.normals.push(Math.NaN);
			}

			for( k in 0...uvCount ) {
				var out = data.uvs[k];
				var uacc = p.attributes.get("TEXCOORD_" + k);
				if( uacc == null ) {
					for( i in 0...count * 2 ) out.push(0);
					continue;
				}
				for( v in readAccessor(uacc) ) out.push(v);
			}

			if( data.colors != null ) {
				var cacc = p.attributes.get("COLOR_0");
				if( cacc == null ) {
					for( i in 0...count * 4 ) data.colors.push(1);
				} else {
					var col = readAccessor(cacc);
					var comps = componentCount(doc.accessors[cacc].type);
					for( i in 0...count ) {
						data.colors.push(col[i * comps]);
						data.colors.push(col[i * comps + 1]);
						data.colors.push(col[i * comps + 2]);
						data.colors.push(comps == 4 ? col[i * comps + 3] : 1);
					}
				}
			}

			if( data.joints != null ) {
				var sets = [];
				var n = 0;
				while( n * 4 < influences ) {
					var jacc = p.attributes.get("JOINTS_" + n);
					var wacc = p.attributes.get("WEIGHTS_" + n);
					sets.push(jacc == null || wacc == null ? null : { j : readAccessor(jacc), w : readAccessor(wacc) });
					n++;
				}
				for( i in 0...count )
					for( s in sets )
						for( k in 0...4 ) {
							data.joints.push(s == null ? 0 : s.j[i * 4 + k]);
							data.weights.push(s == null ? 0 : s.w[i * 4 + k]);
						}
			}

			// triangles
			var idx = p.indices == null ? [for( i in 0...count ) i] : readInts(p.indices);
			var slot = slots.indexOf(p.material ?? -1);
			inline function addTri( a : Int, b : Int, c : Int ) {
				if( a >= count || b >= count || c >= count )
					throw "Vertex index out of range" + (fileName == null ? "" : ' ($fileName)');
				// the space conversion is a reflection : reverse the winding
				data.triangles.push(a + offset);
				data.triangles.push(c + offset);
				data.triangles.push(b + offset);
				data.triSlots.push(slot);
			}
			switch( mode ) {
			case Triangles:
				var i = 0;
				while( i + 2 < idx.length ) {
					addTri(idx[i], idx[i + 1], idx[i + 2]);
					i += 3;
				}
			case TriangleStrip:
				for( i in 0...idx.length - 2 ) {
					if( i & 1 == 0 )
						addTri(idx[i], idx[i + 1], idx[i + 2]);
					else
						addTri(idx[i], idx[i + 2], idx[i + 1]);
				}
			case TriangleFan:
				for( i in 1...idx.length - 1 )
					addTri(idx[i], idx[i + 1], idx[0]);
			default:
			}
		}
		return data;
	}

	function buildGeom( data : MeshData, skin : h3d.anim.Skin, genTangents : Bool, decimationFactor : Float ) : hxd.fmt.Library.BuiltGeometry {
		var g = new Geometry();
		var tris = data.triangles;
		var cornerCount = tris.length;

		// remove empty color data
		var colors = data.colors;
		if( colors != null ) {
			var hasData = false;
			for( v in colors )
				if( v < 0.99 ) {
					hasData = true;
					break;
				}
			if( !hasData )
				colors = null;
		}

		// normals per corner (flat normals when missing)
		var normals = new Array<Float>();
		normals.resize(cornerCount * 3);
		var pos = data.positions;
		var t = 0;
		while( t < cornerCount ) {
			var flat : h3d.Vector = null;
			for( c in 0...3 ) {
				var v = tris[t + c];
				var nx = data.normals[v * 3];
				if( Math.isNaN(nx) ) {
					if( flat == null ) {
						var i0 = tris[t] * 3, i1 = tris[t + 1] * 3, i2 = tris[t + 2] * 3;
						var e1 = new h3d.Vector(pos[i1] - pos[i0], pos[i1 + 1] - pos[i0 + 1], pos[i1 + 2] - pos[i0 + 2]);
						var e2 = new h3d.Vector(pos[i2] - pos[i0], pos[i2 + 1] - pos[i0 + 1], pos[i2 + 2] - pos[i0 + 2]);
						flat = e1.cross(e2);
						flat.normalize();
					}
					normals[(t + c) * 3] = flat.x;
					normals[(t + c) * 3 + 1] = flat.y;
					normals[(t + c) * 3 + 2] = flat.z;
				} else {
					normals[(t + c) * 3] = nx;
					normals[(t + c) * 3 + 1] = data.normals[v * 3 + 1];
					normals[(t + c) * 3 + 2] = data.normals[v * 3 + 2];
				}
			}
			t += 3;
		}

		// tangents per corner
		var tangents = null;
		if( genTangents ) {
			if( cornerCount > 0 && data.uvs.length == 0 )
				throw "Need UVs to build tangents" + (fileName == null ? "" : ' in $fileName');
			var buffer = [];
			for( k in 0...cornerCount ) {
				var v = tris[k];
				buffer.push(pos[v * 3]);
				buffer.push(pos[v * 3 + 1]);
				buffer.push(pos[v * 3 + 2]);
				buffer.push(normals[k * 3]);
				buffer.push(normals[k * 3 + 1]);
				buffer.push(normals[k * 3 + 2]);
				// mikktspace expects bottom-left uv origin
				buffer.push(data.uvs[0][v * 2]);
				buffer.push(1 - data.uvs[0][v * 2 + 1]);
			}
			tangents = computeTangents(buffer, cornerCount);
		}

		inline function getPrec(n) {
			var p = lowPrecConfig == null ? null : lowPrecConfig.get(n);
			if( p == null ) p = F32;
			return p;
		}
		var pnormal = getPrec("normal");

		// build format
		var format = [];
		inline function addFormat(name,type,prec) {
			format.push(new hxd.BufferFormat.BufferInput(name,type,prec));
		}
		addFormat("position", DVec3, getPrec("position"));
		addFormat("normal", DVec3, pnormal);
		if( tangents != null )
			addFormat("tangent", DVec3, pnormal);
		for( i in 0...data.uvs.length )
			addFormat("uv"+(i == 0 ? "" : ""+(i+1)), DVec2, getPrec("uv"));
		if( colors != null )
			addFormat("color", DVec3, getPrec("color"));
		if( skin != null ) {
			if( fourBonesByVertex )
				g.props = [FourBonesByVertex];
			addFormat("weights", DVec3, getPrec("weights"));  // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
			format.push(new GeometryFormat("indexes", DBytes4));
		}
		if( generateNormals )
			addFormat("logicNormal", DVec3, pnormal);
		g.vertexFormat = hxd.BufferFormat.make(format);
		g.vertexCount = 0;

		var ibufs : Array<Array<Int>> = [];
		if( skin != null && skin.isSplit() ) {
			for( _ in skin.splitJoints )
				ibufs.push([]);
		} else {
			for( _ in 0...data.slotCount )
				ibufs.push([]);
		}

		g.bounds = new h3d.col.Bounds();
		var stride = g.vertexFormat.stride;
		var tmpBuf = new hxd.impl.TypedArray.Float32Array(stride);
		var vbuf = new hxd.FloatBuffer();
		var lookup = new Map<Int, Array<Int>>();
		var remap = [0, 0, 0];
		for( tri in 0...Std.int(cornerCount / 3) ) {
			for( c in 0...3 ) {
				var k = tri * 3 + c;
				var vidx = tris[k];
				var p = 0;

				var x = pos[vidx * 3];
				var y = pos[vidx * 3 + 1];
				var z = pos[vidx * 3 + 2];
				tmpBuf[p++] = x;
				tmpBuf[p++] = y;
				tmpBuf[p++] = z;
				g.bounds.addPos(x, y, z);

				tmpBuf[p++] = normals[k * 3];
				tmpBuf[p++] = normals[k * 3 + 1];
				tmpBuf[p++] = normals[k * 3 + 2];

				if( tangents != null ) {
					tmpBuf[p++] = round(tangents[k * 4]);
					tmpBuf[p++] = round(tangents[k * 4 + 1]);
					tmpBuf[p++] = round(tangents[k * 4 + 2]);
					if( tangents[k * 4 + 3] < 0 ) {
						tmpBuf[p - 3] *= 0.5;
						tmpBuf[p - 2] *= 0.5;
						tmpBuf[p - 1] *= 0.5;
					}
				}

				for( uvs in data.uvs ) {
					tmpBuf[p++] = uvs[vidx * 2];
					tmpBuf[p++] = uvs[vidx * 2 + 1];
				}

				if( colors != null ) {
					tmpBuf[p++] = colors[vidx * 4];
					tmpBuf[p++] = colors[vidx * 4 + 1];
					tmpBuf[p++] = colors[vidx * 4 + 2];
				}

				if( skin != null ) {
					var k = vidx * skin.bonesPerVertex;
					var idx = 0;
					for( i in 0...3 ) // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
						tmpBuf[p++] = skin.vertexWeights[k + i];
					for( i in 0...skin.bonesPerVertex )
						idx = (skin.vertexJoints[k + i] << (8*i)) | idx;
					tmpBuf[p++] = int32tof(idx);
				}

				if( generateNormals ) {
					tmpBuf[p++] = 0;
					tmpBuf[p++] = 0;
					tmpBuf[p++] = 0;
				}

				var total = 0.;
				for( i in 0...stride )
					total += tmpBuf[i];
				var itotal = Std.int((total * 100) % 0x0FFFFFFF);

				// look if the vertex already exists
				var found : Null<Int> = null;
				var vids = lookup.get(itotal);
				if( vids == null ) {
					vids = [];
					lookup.set(itotal, vids);
				}
				for( vid in vids ) {
					var same = true;
					var p = vid * stride;
					for( i in 0...stride )
						if( vbuf[p++] != tmpBuf[i] ) {
							same = false;
							break;
						}
					if( same ) {
						found = vid;
						break;
					}
				}
				if( found == null ) {
					found = g.vertexCount;
					g.vertexCount++;
					for( i in 0...stride )
						vbuf.push(tmpBuf[i]);
					vids.push(found);
				}
				remap[c] = found;
			}
			var ibuf = skin != null && skin.isSplit() ? ibufs[skin.triangleGroups[tri]] : ibufs[data.triSlots[tri]];
			ibuf.push(remap[0]);
			ibuf.push(remap[1]);
			ibuf.push(remap[2]);
		}
		for( i in 0...ibufs.length )
			if( ibufs[i].length == 0 )
				ibufs[i] = null;

		if( generateNormals )
			updateNormals(g, vbuf, ibufs);

		if( optimizeMesh || decimationFactor > 0.0 ) {
			vbuf = optimizeGeometry(g, vbuf, ibufs, decimationFactor);
			if( vbuf == null )
				return null;
		}

		var positions = writeVertices(g, vbuf);
		var matMap = writeIndexes(g, ibufs);
		if( skin != null && skin.isSplit() )
			matMap = null;
		return { g : g, materials : matMap, vbuf : positions, ibufs : ibufs };
	}


	function getJointParent( o : GltfObject, skin : GltfSkin ) {
		var p = o.parent;
		while( p != null && skin.joints.indexOf(p.index) < 0 )
			p = p.parent;
		return p;
	}

	/**
		Root joints are relative to the skinned mesh, the transform from their
		real parent to the mesh must be applied to their default position and animation.
	**/
	function getRootJointFix( joint : GltfObject, meshObj : GltfObject ) {
		var fix = new h3d.Matrix();
		fix.identity();
		if( joint.parent != null )
			fix.load(joint.parent.getWorld());
		fix.multiply(fix, meshObj.getWorld().getInverse());
		return fix;
	}

	function initRootJointFix() {
		rootJointFix = new Map();
		for( o in objects ) {
			if( o.node.skin == null || o.node.mesh == null ) continue;
			var skin = doc.skins[o.node.skin];
			for( j in skin.joints ) {
				var jo = objects[j];
				if( rootJointFix.exists(j) || getJointParent(jo, skin) != null ) continue;
				var fix = getRootJointFix(jo, o);
				if( !isIdentity(fix) )
					rootJointFix.set(j, fix);
			}
		}
	}

	function createSkin( meshObj : GltfObject, data : MeshData ) : h3d.anim.Skin {
		var gskin = doc.skins[meshObj.node.skin];
		var ibms = gskin.inverseBindMatrices == null ? null : readAccessor(gskin.inverseBindMatrices);
		var jointIndex = new Map<Int, Int>();
		for( i => n in gskin.joints )
			jointIndex.set(n, i);

		function getDepth( o : GltfObject ) {
			var d = 0;
			while( o.parent != null ) {
				o = o.parent;
				d++;
			}
			return d;
		}
		// parents first
		var sorted = gskin.joints.copy();
		var depths = [for( n in sorted ) n => getDepth(objects[n])];
		haxe.ds.ArraySort.sort(sorted, (a, b) -> depths.get(a) != depths.get(b) ? depths.get(a) - depths.get(b) : jointIndex.get(a) - jointIndex.get(b));

		var joints = [], rootJoints = [];
		var byIndex = [];
		for( n in sorted ) {
			var o = objects[n];
			var j = new h3d.anim.Skin.Joint();
			j.name = o.name;
			j.index = joints.length;
			var jp = getJointParent(o, gskin);
			if( jp == null ) {
				// root joint position is relative to the skinned mesh
				j.defMat = o.getLocal().multiplied(getRootJointFix(o, meshObj));
				rootJoints.push(j);
			} else {
				j.defMat = jp == o.parent ? o.getLocal() : o.getWorld().multiplied(jp.getWorld().getInverse());
				j.parent = byIndex[jointIndex.get(jp.index)];
				j.parent.subs.push(j);
			}
			var i = jointIndex.get(n);
			if( ibms == null ) {
				j.transPos = new h3d.Matrix();
				j.transPos.identity();
			} else
				j.transPos = convMatrix(ibms, i * 16);
			byIndex[i] = j;
			joints.push(j);
		}

		var skin = new h3d.anim.Skin(null, data.vertexCount, fourBonesByVertex ? 4 : 3);
		if( data.joints != null ) {
			var n = data.influences;
			for( v in 0...data.vertexCount ) {
				for( k in 0...n ) {
					var w = data.weights[v * n + k];
					if( w < 0.01 )
						continue;
					var j = byIndex[Std.int(data.joints[v * n + k])];
					if( j == null )
						throw "Invalid joint index" + (fileName == null ? "" : ' ($fileName)');
					skin.addInfluence(v, j, w);
				}
			}
		}
		skin.setJoints(joints, rootJoints);
		skin.initWeights();
		if( skin.boundJoints.length > maxBonesPerSkin )
			skin.split(maxBonesPerSkin, data.triangles, data.slotCount > 1 ? data.triSlots : null);
		return skin;
	}

	static function isIdentity( m : h3d.Matrix ) {
		var id = new h3d.Matrix();
		id.identity();
		inline function eq(a:Float, b:Float) return Math.abs(a - b) < 1e-5;
		return eq(m._11,1) && eq(m._12,0) && eq(m._13,0) && eq(m._21,0) && eq(m._22,1) && eq(m._23,0)
			&& eq(m._31,0) && eq(m._32,0) && eq(m._33,1) && eq(m._41,0) && eq(m._42,0) && eq(m._43,0);
	}


	function addAnimations() {
		if( doc.animations == null )
			return;
		for( i => a in doc.animations ) {
			var anim = makeLinearAnimation(a, i);
			if( anim != null )
				d.animations.push(makeAnimation(anim));
		}
	}

	function getSampler( a : GltfAnimation, index : Int, cache : Map<Int, AnimSampler> ) : AnimSampler {
		var s = cache.get(index);
		if( s != null ) return s;
		var gs = a.samplers[index];
		var times = readAccessor(gs.input);
		var values = readAccessor(gs.output);
		var interp = gs.interpolation ?? "LINEAR";
		var keys = interp == "CUBICSPLINE" ? times.length * 3 : times.length;
		s = { times : times, values : values, interpolation : interp, comps : times.length == 0 ? 0 : Std.int(values.length / keys) };
		cache.set(index, s);
		return s;
	}

	function detectSampling( samplers : Array<AnimSampler>, maxTime : Float ) : Float {
		if( animationSampling != null )
			return animationSampling;
		var minDT = Math.POSITIVE_INFINITY;
		for( s in samplers )
			for( i in 1...s.times.length ) {
				var dt = s.times[i] - s.times[i - 1];
				if( dt > 1e-5 && dt < minDT ) minDT = dt;
			}
		if( minDT == Math.POSITIVE_INFINITY )
			return 30;
		var fps = Math.round(1 / minDT);
		if( fps < 15 || fps > 120 )
			return 30;
		// keys must be aligned on the frames, otherwise resample at a default rate
		for( s in samplers )
			for( t in s.times ) {
				var f = t * fps;
				if( Math.abs(f - Math.round(f)) > 0.05 )
					return 30;
			}
		return fps;
	}

	function sample( s : AnimSampler, time : Float, out : Array<Float> ) {
		var times = s.times;
		var n = times.length;
		var c = s.comps;
		var cubic = s.interpolation == "CUBICSPLINE";
		inline function valuePos( k : Int ) return cubic ? (k * 3 + 1) * c : k * c;
		if( n == 1 || time <= times[0] ) {
			for( i in 0...c ) out[i] = s.values[valuePos(0) + i];
			return;
		}
		if( time >= times[n - 1] ) {
			for( i in 0...c ) out[i] = s.values[valuePos(n - 1) + i];
			return;
		}
		var k = 0;
		while( k < n - 2 && times[k + 1] <= time ) k++;
		var t0 = times[k], t1 = times[k + 1];
		var dt = t1 - t0;
		var u = dt <= 0 ? 0 : (time - t0) / dt;
		switch( s.interpolation ) {
		case "STEP":
			for( i in 0...c ) out[i] = s.values[valuePos(k) + i];
		case "CUBICSPLINE":
			var u2 = u * u, u3 = u2 * u;
			var h00 = 2 * u3 - 3 * u2 + 1;
			var h10 = u3 - 2 * u2 + u;
			var h01 = -2 * u3 + 3 * u2;
			var h11 = u3 - u2;
			var p0 = valuePos(k), p1 = valuePos(k + 1);
			var m0 = (k * 3 + 2) * c; // out tangent of k
			var m1 = ((k + 1) * 3) * c; // in tangent of k + 1
			for( i in 0...c )
				out[i] = h00 * s.values[p0 + i] + h10 * dt * s.values[m0 + i] + h01 * s.values[p1 + i] + h11 * dt * s.values[m1 + i];
		default:
			var p0 = valuePos(k), p1 = valuePos(k + 1);
			if( c == 4 ) {
				// quaternion slerp
				var q0 = new h3d.Quat(s.values[p0], s.values[p0 + 1], s.values[p0 + 2], s.values[p0 + 3]);
				var q1 = new h3d.Quat(s.values[p1], s.values[p1 + 1], s.values[p1 + 2], s.values[p1 + 3]);
				var q = new h3d.Quat();
				q.slerp(q0, q1, u);
				out[0] = q.x; out[1] = q.y; out[2] = q.z; out[3] = q.w;
			} else {
				for( i in 0...c )
					out[i] = s.values[p0 + i] * (1 - u) + s.values[p1 + i] * u;
			}
		}
	}

	function makeLinearAnimation( a : GltfAnimation, index : Int ) : h3d.anim.LinearAnimation {
		var cache = new Map();
		var tracks = new Map<Int, { t : AnimSampler, r : AnimSampler, s : AnimSampler }>();
		var used = [];
		var maxTime = 0.;
		for( ch in a.channels ) {
			var node = ch.target.node;
			if( node == null ) continue;
			var s = getSampler(a, ch.sampler, cache);
			if( s.times.length == 0 ) continue;
			var tr = tracks.get(node);
			if( tr == null ) {
				tr = { t : null, r : null, s : null };
				tracks.set(node, tr);
			}
			switch( ch.target.path ) {
			case "translation": tr.t = s;
			case "rotation": tr.r = s;
			case "scale": tr.s = s;
			default: continue; // morph weights are not supported
			}
			used.push(s);
			var end = s.times[s.times.length - 1];
			if( end > maxTime ) maxTime = end;
		}
		if( used.length == 0 )
			return null;

		var sampling = detectSampling(used, maxTime);
		var frameCount = Math.round(maxTime * sampling) + 1;
		var name = a.name == null || a.name == "" ? "Animation" + index : a.name;
		var anim = new h3d.anim.LinearAnimation(name, frameCount, sampling);

		var nodes = [for( n in tracks.keys() ) n];
		nodes.sort((n1, n2) -> n1 - n2);
		var t = [0., 0., 0.], r = [0., 0., 0., 1.], s = [1., 1., 1.];
		for( n in nodes ) {
			var o = objects[n];
			var tr = tracks.get(n);
			var fix = rootJointFix.get(n);
			var frames = new haxe.ds.Vector<h3d.anim.LinearAnimation.LinearFrame>(frameCount);
			for( f in 0...frameCount ) {
				var time = Math.min(f / sampling, maxTime);
				if( tr.t != null ) sample(tr.t, time, t) else for( i in 0...3 ) t[i] = o.gltfPos[i];
				if( tr.r != null ) sample(tr.r, time, r) else for( i in 0...4 ) r[i] = o.gltfRot[i];
				if( tr.s != null ) sample(tr.s, time, s) else for( i in 0...3 ) s[i] = o.gltfScale[i];
				var frame = new h3d.anim.LinearAnimation.LinearFrame();
				var pos, q, sc;
				if( fix != null ) {
					var m = makeMatrix(t, r, s);
					m.multiply(m, fix);
					var trs = decomposeHeaps(m);
					pos = trs.t;
					q = trs.q;
					sc = trs.s;
				} else {
					pos = convVector(t[0], t[1], t[2]);
					q = convQuat(r[0], r[1], r[2], r[3]);
					q.normalize();
					sc = convScale(s[0], s[1], s[2]);
				}
				frame.tx = round(pos.x);
				frame.ty = round(pos.y);
				frame.tz = round(pos.z);
				frame.qx = q.x;
				frame.qy = q.y;
				frame.qz = q.z;
				frame.qw = q.w;
				frame.sx = round(sc.x);
				frame.sy = round(sc.y);
				frame.sz = round(sc.z);
				frames[f] = frame;
			}

			// single frame if the object does not move
			var same = true;
			var f0 = frames[0];
			for( f in frames )
				if( f.tx != f0.tx || f.ty != f0.ty || f.tz != f0.tz || f.qx != f0.qx || f.qy != f0.qy || f.qz != f0.qz || f.qw != f0.qw || f.sx != f0.sx || f.sy != f0.sy || f.sz != f0.sz ) {
					same = false;
					break;
				}
			if( same ) {
				var v = new haxe.ds.Vector(1);
				v[0] = f0;
				frames = v;
			}

			var restRot = o.gltfRot[0] != 0 || o.gltfRot[1] != 0 || o.gltfRot[2] != 0;
			var restScale = o.gltfScale[0] != 1 || o.gltfScale[1] != 1 || o.gltfScale[2] != 1;
			var hasPos = tr.t != null || !o.isJoint || fix != null;
			var hasRot = tr.r != null || restRot || fix != null;
			var hasScale = tr.s != null || restScale;
			anim.addCurve(o.name, frames, hasPos, hasRot, hasScale);
		}
		return anim;
	}

}
