package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;
import hxd.fmt.fbx.BaseLibrary;
import hxd.fmt.hmd.Data;

class HMDOut extends BaseLibrary {

	var d : Data;
	var dataOut : haxe.io.BytesOutput;
	var filePath : String;
	var tmp = haxe.io.Bytes.alloc(4);
	public var absoluteTexturePath : Bool;
	public var optimizeSkin = true;
	public var generateNormals = false;

	function int32tof( v : Int ) : Float {
		tmp.set(0, v & 0xFF);
		tmp.set(1, (v >> 8) & 0xFF);
		tmp.set(2, (v >> 16) & 0xFF);
		tmp.set(3, v >>> 24);
		return tmp.getFloat(0);
	}

	override function keepJoint(j:h3d.anim.Skin.Joint) {
		if( !optimizeSkin )
			return true;
		// remove these unskinned terminal bones if they are not named in a special manner
		if( ~/^Bip00[0-9] /.match(j.name) || ~/^Bone[0-9][0-9][0-9]$/.match(j.name) )
			return false;
		return true;
	}

	function buildTangents( geom : hxd.fmt.fbx.Geometry ) {
		var verts = geom.getVertices();
		var normals = geom.getNormals();
		var uvs = geom.getUVs();
		var index = geom.getIndexes();

		#if (hl && !hl_disable_mikkt && (haxe_ver >= "4.0"))
		var m = new hl.Format.Mikktspace();
		m.buffer = new hl.Bytes(8 * 4 * index.vidx.length);
		m.stride = 8;
		m.xPos = 0;
		m.normalPos = 3;
		m.uvPos = 6;

		m.indexes = new hl.Bytes(4 * index.vidx.length);
		m.indices = index.vidx.length;

		m.tangents = new hl.Bytes(4 * 4 * index.vidx.length);
		(m.tangents:hl.Bytes).fill(0,4 * 4 * index.vidx.length,0);
		m.tangentStride = 4;
		m.tangentPos = 0;

		var out = 0;
		for( i in 0...index.vidx.length ) {
			var vidx = index.vidx[i];
			m.buffer[out++] = verts[vidx*3];
			m.buffer[out++] = verts[vidx*3+1];
			m.buffer[out++] = verts[vidx*3+2];

			m.buffer[out++] = normals[i*3];
			m.buffer[out++] = normals[i*3+1];
			m.buffer[out++] = normals[i*3+2];
			var uidx = uvs[0].index[i];

			m.buffer[out++] = uvs[0].values[uidx*2];
			m.buffer[out++] = uvs[0].values[uidx*2+1];

			m.tangents[i<<2] = 1;

			m.indexes[i] = i;
		}

		m.compute();
		return m.tangents;
		#elseif (sys || nodejs)
		var tmp = Sys.getEnv("TMPDIR");
		if( tmp == null ) tmp = Sys.getEnv("TMP");
		if( tmp == null ) tmp = Sys.getEnv("TEMP");
		if( tmp == null ) tmp = ".";
		var fileName = tmp+"/mikktspace_data"+Date.now().getTime()+"_"+Std.random(0x1000000)+".bin";
		var outFile = fileName+".out";
		var outputData = new haxe.io.BytesBuffer();
		outputData.addInt32(index.vidx.length);
		outputData.addInt32(8);
		outputData.addInt32(0);
		outputData.addInt32(3);
		outputData.addInt32(6);
		for( i in 0...index.vidx.length ) {
			inline function w(v:Float) outputData.addFloat(v);
			var vidx = index.vidx[i];
			w(verts[vidx*3]);
			w(verts[vidx*3+1]);
			w(verts[vidx*3+2]);

			w(normals[i*3]);
			w(normals[i*3+1]);
			w(normals[i*3+2]);
			var uidx = uvs[0].index[i];

			w(uvs[0].values[uidx*2]);
			w(uvs[0].values[uidx*2+1]);
		}
		outputData.addInt32(index.vidx.length);
		for( i in 0...index.vidx.length )
			outputData.addInt32(i);
		sys.io.File.saveBytes(fileName, outputData.getBytes());
		var ret = try Sys.command("mikktspace",[fileName,outFile]) catch( e : Dynamic ) -1;
		if( ret != 0 ) {
			sys.FileSystem.deleteFile(fileName);
			throw "Failed to call 'mikktspace' executable required to generate tangent data. Please ensure it's in your PATH";
		}
		var bytes = sys.io.File.getBytes(outFile);
		var arr = [];
		for( i in 0...index.vidx.length*4 )
			arr[i] = bytes.getFloat(i << 2);
		sys.FileSystem.deleteFile(fileName);
		sys.FileSystem.deleteFile(outFile);
		return arr;
		#else
		throw "Tangent generation is not supported on this platform";
		return ([] : Array<Float>);
		#end
	}

	function updateNormals( g : Geometry, vbuf : hxd.FloatBuffer, idx : Array<Array<Int>> ) {
		var stride = g.vertexStride;
		var normalPos = 0;
		for( f in g.vertexFormat ) {
			if( f.name == "logicNormal" ) break;
			normalPos += f.format.getSize();
		}

		var points : Array<h3d.col.Point> = [];
		var pmap = [];
		for( vid in 0...g.vertexCount ) {
			var x = vbuf[vid * stride];
			var y = vbuf[vid * stride + 1];
			var z = vbuf[vid * stride + 2];
			var found = false;
			for( i in 0...points.length ) {
				var p = points[i];
				if( p.x == x && p.y == y && p.z == z ) {
					pmap[vid] = i;
					found = true;
					break;
				}
			}
			if( !found ) {
				pmap[vid] = points.length;
				points.push(new h3d.col.Point(x,y,z));
			}
		}
		var realIdx = new hxd.IndexBuffer();
		for( idx in idx )
			for( i in idx )
				realIdx.push(pmap[i]);

		var poly = new h3d.prim.Polygon(points, realIdx);
		poly.addNormals();

		for( vid in 0...g.vertexCount ) {
			var nid = pmap[vid];
			vbuf[vid*stride + normalPos] = poly.normals[nid].x;
			vbuf[vid*stride + normalPos + 1] = poly.normals[nid].y;
			vbuf[vid*stride + normalPos + 2] = poly.normals[nid].z;
		}
	}

	function buildGeom( geom : hxd.fmt.fbx.Geometry, skin : h3d.anim.Skin, dataOut : haxe.io.BytesOutput, genTangents : Bool ) {
		var g = new Geometry();

		var verts = geom.getVertices();
		var normals = geom.getNormals();
		var uvs = geom.getUVs();
		var colors = geom.getColors();
		var mats = geom.getMaterials();

		// remove empty color data
		if( colors != null ) {
			var hasData = false;
			for( v in colors.values )
				if( v < 0.99 ) {
					hasData = true;
					break;
				}
			if( !hasData )
				colors = null;
		}

		// generate tangents
		var tangents = genTangents ? buildTangents(geom) : null;

		// build format
		g.vertexFormat = [
			new GeometryFormat("position", DVec3),
		];
		if( normals != null )
			g.vertexFormat.push(new GeometryFormat("normal", DVec3));
		if( tangents != null )
			g.vertexFormat.push(new GeometryFormat("tangent", DVec3));
		for( i in 0...uvs.length )
			g.vertexFormat.push(new GeometryFormat("uv" + (i == 0 ? "" : "" + (i + 1)), DVec2));
		if( colors != null )
			g.vertexFormat.push(new GeometryFormat("color", DVec3));

		if( skin != null ) {
			if(fourBonesByVertex)
				g.props = [FourBonesByVertex];
			g.vertexFormat.push(new GeometryFormat("weights", DVec3));  // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
			g.vertexFormat.push(new GeometryFormat("indexes", DBytes4));
		}

		if( generateNormals )
			g.vertexFormat.push(new GeometryFormat("logicNormal", DVec3));

		var stride = 0;
		for( f in g.vertexFormat )
			stride += f.format.getSize();
		g.vertexStride = stride;
		g.vertexCount = 0;

		// build geometry
		var gm = geom.getGeomMatrix();
		var vbuf = new hxd.FloatBuffer();
		var ibufs = [];

		if( skin != null && skin.isSplit() ) {
			for( _ in skin.splitJoints )
				ibufs.push([]);
		}

		g.bounds = new h3d.col.Bounds();
		var tmpBuf = new hxd.impl.TypedArray.Float32Array(stride);
		var vertexRemap = new Array<Int>();
		var index = geom.getPolygons();
		var count = 0, matPos = 0, stri = 0;
		var lookup = new Map();
		var tmp = new h3d.col.Point();
		for( pos in 0...index.length ) {
			var i = index[pos];
			count++;
			if( i >= 0 )
				continue;
			index[pos] = -i - 1;
			var start = pos - count + 1;
			for( n in 0...count ) {
				var k = n + start;
				var vidx = index[k];
				var p = 0;

				var x = verts[vidx * 3];
				var y = verts[vidx * 3 + 1];
				var z = verts[vidx * 3 + 2];
				if( gm != null ) {
					tmp.set(x, y, z);
					tmp.transform(gm);
					x = tmp.x;
					y = tmp.y;
					z = tmp.z;
				}
				tmpBuf[p++] = x;
				tmpBuf[p++] = y;
				tmpBuf[p++] = z;
				g.bounds.addPos(x, y, z);

				if( normals != null ) {
					var nx = normals[k * 3];
					var ny = normals[k * 3 + 1];
					var nz = normals[k * 3 + 2];
					tmpBuf[p++] = nx;
					tmpBuf[p++] = ny;
					tmpBuf[p++] = nz;
				}

				if( tangents != null ) {
					tmpBuf[p++] = round(tangents[k * 4]);
					tmpBuf[p++] = round(tangents[k * 4 + 1]);
					tmpBuf[p++] = round(tangents[k * 4 + 2]);
					if( tangents[k*4+3] < 0 ) {
						tmpBuf[p-3] *= 0.5;
						tmpBuf[p-2] *= 0.5;
						tmpBuf[p-1] *= 0.5;
					}
				}

				for( tuvs in uvs ) {
					var iuv = tuvs.index[k];
					tmpBuf[p++] = tuvs.values[iuv * 2];
					tmpBuf[p++] = 1 - tuvs.values[iuv * 2 + 1];
				}

				if( colors != null ) {
					var icol = colors.index[k];
					tmpBuf[p++] = colors.values[icol * 4];
					tmpBuf[p++] = colors.values[icol * 4 + 1];
					tmpBuf[p++] = colors.values[icol * 4 + 2];
				}

				if( skin != null ) {
					var k = vidx * skin.bonesPerVertex;
					var idx = 0;
					if(!(skin.bonesPerVertex == 3 || skin.bonesPerVertex == 4)) throw "assert";
					for( i in 0...3 )  // Only 3 weights are necessary even in fourBonesByVertex since they sum-up to 1
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
				vertexRemap.push(found);
			}

			// by-skin-group index
			if( skin != null && skin.isSplit() ) {
				for( n in 0...count - 2 ) {
					var idx = ibufs[skin.triangleGroups[stri++]];
					idx.push(vertexRemap[start + n]);
					idx.push(vertexRemap[start + count - 1]);
					idx.push(vertexRemap[start + n + 1]);
				}
			}
			// by-material index
			else {
				var mid;
				if( mats == null )
					mid = 0;
				else {
					mid = mats[matPos];
					if( mats.length > 1 ) matPos++;
				}
				var idx = ibufs[mid];
				if( idx == null ) {
					idx = [];
					ibufs[mid] = idx;
				}
				for( n in 0...count - 2 ) {
					idx.push(vertexRemap[start + n]);
					idx.push(vertexRemap[start + count - 1]);
					idx.push(vertexRemap[start + n + 1]);
				}
			}

			index[pos] = i; // restore
			count = 0;
		}

		if( generateNormals )
			updateNormals(g,vbuf,ibufs);

		// write data
		g.vertexPosition = dataOut.length;
		for( i in 0...vbuf.length )
			writeFloat(vbuf[i]);
		g.indexPosition = dataOut.length;
		g.indexCounts = [];

		var matMap = [], matCount = 0;
		var is32 = g.vertexCount > 0x10000;

		for( idx in ibufs ) {
			if( idx == null ) {
				matCount++;
				continue;
			}
			matMap.push(matCount++);
			g.indexCounts.push(idx.length);
			if( is32 ) {
				for( i in idx )
					dataOut.writeInt32(i);
			} else {
				for( i in idx )
					dataOut.writeUInt16(i);
			}
		}

		if( skin != null && skin.isSplit() )
			matMap = null;

		return { g : g, materials : matMap };
	}

	function addModels(includeGeometry) {

		var root = buildHierarchy().root;
		var objects = [], joints = [], skins = [], foundSkin : Array<TmpObject> = null;
		var uid = 0;
		function indexRec( t : TmpObject ) {
			if( t.isJoint ) {
				joints.push(t);
			} else {
				var isSkin = false;
				if( foundSkin == null ) {
					for( c in t.childs )
						if( c.isJoint ) {
							isSkin = true;
							break;
						}
				} else
					isSkin = foundSkin.indexOf(t) >= 0;
				if( isSkin ) {
					skins.push(t);
				} else
					objects.push(t);
			}
			for( c in t.childs )
				indexRec(c);
		}
		indexRec(root);

		// create joints
		for( o in joints ) {
			if( o.isMesh ) throw "assert";
			var j = new h3d.anim.Skin.Joint();
			getDefaultMatrixes(o.model); // store for later usage in animation
			j.index = o.model.getId();
			j.name = o.model.getName();
			o.joint = j;
			if( o.parent != null ) {
				j.parent = o.parent.joint;
				if( o.parent.isJoint ) o.parent.joint.subs.push(j);
			}
		}

		// mark skin references
		foundSkin = [];
		for( o in skins ) {
			function loopRec( o : TmpObject ) {
				for( j in o.childs ) {
					if( !j.isJoint ) continue;
					var s = getParent(j.model, "Deformer", true);
					if( s != null ) return s;
					s = loopRec(j);
					if( s != null ) return s;
				}
				return null;
			}
			var subDef = loopRec(o);
			// skip skin with no skinned bone
			if( subDef == null )
				continue;
			var def = getParent(subDef, "Deformer");
			var geoms = getParents(def, "Geometry");
			if( geoms.length == 0 ) continue;
			if( geoms.length > 1 ) throw "Single skin applied to multiple geometries not supported";
			var models = getParents(geoms[0],"Model");
			if( models.length == 0 ) continue;
			if( models.length > 1 ) throw "Single skin applied to multiple models not supported";
			var m = models[0];
			for( o2 in objects )
				if( o2.model == m ) {
					foundSkin.push(o);
					o2.skin = o;
					if( o.model == null ) o.model = m;
					ignoreMissingObject(m.getId()); // make sure we don't store animation for the model (only skin object has one)
					// copy parent
					var p = o.parent;
					if( p != o2 ) {
						o2.parent.childs.remove(o2);
						o2.parent = p;
						if( p != null ) p.childs.push(o2) else root = o2;
					}
					// remove skin from hierarchy
					if( p != null ) p.childs.remove(o);
					// move not joint to new parent
					// (only first level, others will follow their respective joint)
					for( c in o.childs.copy() )
						if( !c.isJoint ) {
							o.childs.remove(c);
							o2.childs.push(c);
							c.parent = o2;
						}
					break;
				}
		}

		// we need to have ignored skins objects anims first
		if( !includeGeometry )
			return;

		objects = [];
		if( root.childs.length <= 1 && root.model == null ) {
			root = root.childs[0];
			root.parent = null;
		}
		if( root != null ) indexRec(root); // reorder after we have changed hierarchy

		var hskins = new Map(), tmpGeom = new Map();
		// prepare things for skinning
		for( g in this.root.getAll("Objects.Geometry") )
			tmpGeom.set(g.getId(), { setSkin : function(_) { }, vertexCount : function() return Std.int(new hxd.fmt.fbx.Geometry(this, g).getVertices().length/3) } );

		var hgeom = new Map();
		var hmat = new Map<Int,Int>();
		var index = 0;
		for( o in objects ) {

			o.index = index++;

			var model = new Model();
			var ref = o.skin == null ? o : o.skin;

			model.name = o.model == null ? null : o.model.getName();
			model.parent = o.parent == null || o.parent.isJoint ? -1 : o.parent.index;
			model.follow = o.parent != null && o.parent.isJoint ? o.parent.model.getName() : null;
			var m = ref.model == null ? new hxd.fmt.fbx.BaseLibrary.DefaultMatrixes() : getDefaultMatrixes(ref.model);
			var p = new Position();
			p.x = m.trans == null ? 0 : -m.trans.x;
			p.y = m.trans == null ? 0 : m.trans.y;
			p.z = m.trans == null ? 0 : m.trans.z;
			p.sx = m.scale == null ? 1 : m.scale.x;
			p.sy = m.scale == null ? 1 : m.scale.y;
			p.sz = m.scale == null ? 1 : m.scale.z;

			if( o.model != null && o.model.getType() == "Camera" ) {
				var props = getChild(o.model, "NodeAttribute");
				var fov = 45., ratio = 16 / 9;
				for( p in props.getAll("Properties70.P") ) {
					switch( p.props[0].toString() ) {
					case "FilmAspectRatio":
						ratio = p.props[4].toFloat();
					case "FieldOfView":
						fov = p.props[4].toFloat();
					default:
					}
				}
				var fovY = 2 * Math.atan( Math.tan(fov * 0.5 * Math.PI / 180) / ratio ) * 180 / Math.PI;
				if( model.props == null ) model.props = [];
				model.props.push(CameraFOVY(fovY));
			}

			var q = m.toQuaternion(true);
			q.normalize();
			if( q.w < 0 ) q.negate();
			p.qx = q.x;
			p.qy = q.y;
			p.qz = q.z;
			model.position = p;
			model.geometry = -1;
			d.models.push(model);

			if( !o.isMesh ) continue;

			var mids : Array<Int> = [];
			var hasNormalMap = false;
			for( m in getChilds(o.model, "Material") ) {
				var mid = hmat.get(m.getId());
				if( mid != null ) {
					mids.push(mid);
					var m = d.materials[mid];
					hasNormalMap = m.normalMap != null;
					continue;
				}
				var mat = new Material();
				mid = d.materials.length;
				mids.push(mid);
				hmat.set(m.getId(), mid);
				d.materials.push(mat);

				mat.name = m.getName();
				mat.blendMode = null;

				// if there's a slight amount of opacity on the material
				// it's usually meant to perform additive blending on 3DSMax
				for( p in m.getAll("Properties70.P") ) {
					var pval = p.props[4];
					switch( p.props[0].toString() ) {
					case "Opacity":
						var v = pval.toFloat();
						if( v < 1 && v > 0.98 && mat.blendMode == null ) mat.blendMode = Add;
					default:
					}
				}

				// get texture
				var texture = getSpecChild(m, "DiffuseColor");
				if( texture != null ) {
					var path = makeTexturePath(texture);
					if( path != null ) mat.diffuseTexture = path;
				}

				// get other textures
				mat.normalMap = makeTexturePath(getSpecChild(m, "NormalMap"));
				if( mat.normalMap != null )
					hasNormalMap = true;
				var spec = getSpecChild(m, "SpecularFactor"); // 3dsMax
				if( spec == null ) spec = getSpecChild(m, "SpecularColor"); // maya
				mat.specularTexture = makeTexturePath(spec);
				if( mat.normalMap != null || mat.specularTexture != null ) {
					if( mat.props == null ) mat.props = [];
					mat.props.push(HasExtraTextures);
				}

				// get alpha map
				var transp = getSpecChild(m, "TransparentColor");
				if( transp != null ) {
					var path = transp.get("FileName").props[0].toString();
					if( path != "" ) {
						path = path.toLowerCase();
						var ext = path.split(".").pop();
						if( texture != null && path == texture.get("FileName").props[0].toString().toLowerCase() ) {
							// if that's the same file, we're doing alpha blending
							if( mat.blendMode == null && ext != "jpg" && ext != "jpeg" ) mat.blendMode = Alpha;
						} else
							throw "Alpha texture that is different from diffuse is not supported in HMD";
					}
				}

				if( mat.blendMode == null ) mat.blendMode = None;
			}

			var g = getChild(o.model, "Geometry");

			var skin = null;
			if( o.skin != null ) {
				var rootJoints = [];
				for( c in o.skin.childs )
					if( c.isJoint )
						rootJoints.push(c.joint);
				skin = createSkin(hskins, tmpGeom, rootJoints);
				if( skin.boundJoints.length > maxBonesPerSkin ) {
					var g = new hxd.fmt.fbx.Geometry(this, g);
					var idx = g.getIndexes();
					skin.split(maxBonesPerSkin, [for( i in idx.idx ) idx.vidx[i]], mids.length > 1 ? g.getMaterialByTriangle() : null);
				}
				model.skin = makeSkin(skin, o.skin);
			}

			var gdata = hgeom.get(g.getId());
			if( gdata == null ) {
				var geom = buildGeom(new hxd.fmt.fbx.Geometry(this, g), skin, dataOut, hasNormalMap);
				gdata = { gid : d.geometries.length, materials : geom.materials };
				d.geometries.push(geom.g);
				hgeom.set(g.getId(), gdata);
			}
			model.geometry = gdata.gid;

			if( mids.length == 0 ) {
				var mat = new Material();
				mat.blendMode = None;
				mat.name = "default";
				var mid = d.materials.length;
				d.materials.push(mat);
				mids = [mid];
			}
			if( gdata.materials == null )
				model.materials = mids;
			else
				model.materials = [for( id in gdata.materials ) mids[id]];
		}
	}

	function makeTexturePath( tex : FbxNode ) {
		if( tex == null )
			return null;
		var path = tex.get("FileName").props[0].toString();
		if( path == "" )
			return null;
		path = path.split("\\").join("/");
		if( !absoluteTexturePath ) {
			if( filePath != null && StringTools.startsWith(path.toLowerCase(), filePath) )
				path = path.substr(filePath.length);
			else {
				// relative resource path
				var k = path.split("/res/");
				if( k.length > 1 ) {
					k.shift();
					path = k.join("/res/");
				}
			}
		}
		return path;
	}

	function makeSkin( skin : h3d.anim.Skin, obj : TmpObject ) {
		var s = new Skin();
		s.name = obj.model.getName();
		s.joints = [];
		for( jo in skin.allJoints ) {
			var j = new SkinJoint();
			j.name = jo.name;
			j.parent = jo.parent == null ? -1 : jo.parent.index;
			j.bind = jo.bindIndex;
			j.position = makePosition(jo.defMat);
			if( jo.transPos != null ) {
				j.transpos = makePosition(jo.transPos);
				if( j.transpos.sx != 1 || j.transpos.sy != 1 || j.transpos.sz != 1 ) {
					// FIX : the scale is not correctly taken into account, this formula will extract it and fix things
					var tmp = jo.transPos.clone();
					tmp.transpose();
					var s = tmp.getScale();
					tmp.prependScale(1 / s.x, 1 / s.y, 1 / s.z);
					tmp.transpose();
					j.transpos = makePosition(tmp);
					j.transpos.sx = round(s.x);
					j.transpos.sy = round(s.y);
					j.transpos.sz = round(s.z);
				}
			}
			s.joints.push(j);
		}
		if( skin.splitJoints != null ) {
			s.split = [];
			for( sp in skin.splitJoints ) {
				var ss = new SkinSplit();
				ss.materialIndex = sp.material;
				ss.joints = [for( j in sp.joints ) j.index];
				s.split.push(ss);
			}
		}
		return s;
	}

	function makePosition( m : h3d.Matrix ) {
		var p = new Position();
		var s = m.getScale();
		var q = new h3d.Quat();
		q.initRotateMatrix(m);
		q.normalize();
		if( q.w < 0 ) q.negate();
		p.sx = round(s.x);
		p.sy = round(s.y);
		p.sz = round(s.z);
		p.qx = round(q.x);
		p.qy = round(q.y);
		p.qz = round(q.z);
		p.x = round(m._41);
		p.y = round(m._42);
		p.z = round(m._43);
		return p;
	}

	inline function writeFloat( f : Float ) {
		dataOut.writeFloat( f == 0 ? 0 : f ); // prevent negative zero
	}

	function writeFrame( o : h3d.anim.LinearAnimation.LinearObject, fid : Int ) {
		if( d.version < 3 ) return;
		if( o.frames != null ) {
			var f = o.frames[fid];
			if( o.hasPosition ) {
				writeFloat(f.tx);
				writeFloat(f.ty);
				writeFloat(f.tz);
			}
			if( o.hasRotation ) {
				var ql = Math.sqrt(f.qx * f.qx + f.qy * f.qy + f.qz * f.qz + f.qw * f.qw);
				if( ql * f.qw < 0 ) ql = -ql; // make sure normalized qw > 0
				writeFloat(round(f.qx / ql));
				writeFloat(round(f.qy / ql));
				writeFloat(round(f.qz / ql));
			}
			if( o.hasScale ) {
				writeFloat(f.sx);
				writeFloat(f.sy);
				writeFloat(f.sz);
			}
		}
		if( o.uvs != null ) {
			writeFloat(o.uvs[fid<<1]);
			writeFloat(o.uvs[(fid<<1)+1]);
		}
		if( o.alphas != null )
			writeFloat(o.alphas[fid]);
		if( o.propValues != null )
			writeFloat(o.propValues[fid]);
	}

	function makeAnimation( anim : h3d.anim.Animation ) {
		var a = new Animation();
		a.name = anim.name;
		a.loop = true;
		a.speed = 1;
		a.sampling = anim.sampling;
		a.frames = anim.frameCount;
		a.objects = [];
		a.dataPosition = dataOut.length;
		if( animationEvents != null )
			a.events = [for( a in animationEvents ) { var e = new AnimationEvent(); e.frame = a.frame; e.data = a.data; e; } ];
		var objects : Array<h3d.anim.LinearAnimation.LinearObject> = cast @:privateAccess anim.objects;
		objects.sort(function(o1, o2) return Reflect.compare(o1.objectName, o2.objectName));

		var animatedObjects = [];
		for( obj in objects ) {
			var o = new AnimationObject();
			var count = 0;
			o.name = obj.objectName;
			o.flags = new haxe.EnumFlags();
			o.props = [];
			if( obj.frames != null ) {
				count = obj.frames.length;
				if( obj.hasPosition || d.version < 3 )
					o.flags.set(HasPosition);
				if( obj.hasRotation )
					o.flags.set(HasRotation);
				if( obj.hasScale )
					o.flags.set(HasScale);
				if( d.version < 3 ) {
					for( f in obj.frames ) {
						if( o.flags.has(HasPosition) ) {
							writeFloat(f.tx);
							writeFloat(f.ty);
							writeFloat(f.tz);
						}
						if( o.flags.has(HasRotation) ) {
							var ql = Math.sqrt(f.qx * f.qx + f.qy * f.qy + f.qz * f.qz + f.qw * f.qw);
							if( f.qw < 0 ) ql = -ql;
							writeFloat(round(f.qx / ql));
							writeFloat(round(f.qy / ql));
							writeFloat(round(f.qz / ql));
						}
						if( o.flags.has(HasScale) ) {
							writeFloat(f.sx);
							writeFloat(f.sy);
							writeFloat(f.sz);
						}
					}
				}
			}
			if( obj.uvs != null ) {
				o.flags.set(HasUV);
				if( count == 0 ) count = obj.uvs.length>>1 else if( count != obj.uvs.length>>1 ) throw "assert";
				if( d.version < 3 )
					for( f in obj.uvs )
						writeFloat(f);
				}
			if( obj.alphas != null ) {
				o.flags.set(HasAlpha);
				if( count == 0 ) count = obj.alphas.length else if( count != obj.alphas.length ) throw "assert";
				if( d.version < 3 )
					for( f in obj.alphas )
						writeFloat(f);
			}
			if( obj.propValues != null ) {
				o.flags.set(HasProps);
				o.props.push(obj.propName);
				if( count == 0 ) count = obj.propValues.length else if( count != obj.propValues.length ) throw "assert";
				if( d.version < 3 )
					for( f in obj.propValues )
						writeFloat(f);
			}
			if( count == 0 )
				throw "assert"; // no data ?
			if( count == 1 ) {
				o.flags.set(SingleFrame);
				writeFrame(obj,0);
			} else {
				if( count != anim.frameCount ) throw "assert";
				animatedObjects.push(obj);
			}
			a.objects.push(o);
		}
		for( i in 0...anim.frameCount )
			for( obj in animatedObjects )
				writeFrame(obj,i);
		return a;
	}

	public function toHMD( filePath : String, includeGeometry : Bool ) : Data {

		// if we have only animation data, make sure to export all joints positions
		// because they might be applied to a different model at runtime
		if( !includeGeometry )
			optimizeSkin = false;

		leftHandConvert();
		autoMerge();

		if( filePath != null ) {
			filePath = filePath.split("\\").join("/").toLowerCase();
			if( !StringTools.endsWith(filePath, "/") )
				filePath += "/";
		}
		this.filePath = filePath;

		d = new Data();
		#if hmd_version
		d.version = Std.parseInt(#if macro haxe.macro.Context.definedValue("hmd_version") #else haxe.macro.Compiler.getDefine("hmd_version") #end);
		#else
		d.version = Data.CURRENT_VERSION;
		#end
		d.geometries = [];
		d.materials = [];
		d.models = [];
		d.animations = [];

		dataOut = new haxe.io.BytesOutput();

		addModels(includeGeometry);

		var names = getAnimationNames();
		for ( animName in names ) {
			var anim = loadAnimation(animName);
			if(anim != null)
				d.animations.push(makeAnimation(anim));
		}

		d.data = dataOut.getBytes();
		return d;
	}

}
