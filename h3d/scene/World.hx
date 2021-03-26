package h3d.scene;

class WorldElement {
	public var model : WorldModel;
	public var transform : h3d.Matrix;
	public var optimized : Bool;
	public function new( model, mat, optimized ) {
		this.model = model;
		this.transform = mat;
		this.optimized = optimized;
	}
}

class WorldChunk {

	public var cx : Int;
	public var cy : Int;
	public var x : Float;
	public var y : Float;

	public var root : h3d.scene.Object;
	public var buffers : Map<Int, h3d.scene.Mesh>;
	public var bounds : h3d.col.Bounds;
	public var initialized = false;
	public var lastFrame : Int;
	public var elements : Array<WorldElement>;

	public function new(cx, cy) {
		this.cx = cx;
		this.cy = cy;
		elements = [];
		root = new h3d.scene.Object();
		buffers = new Map();
		bounds = new h3d.col.Bounds();
		root.inheritCulled = true;
		root.name = "chunk[" + cx + "-" + cy + "]";
	}

	public function dispose() {
		root.remove();
	}
}

class WorldMaterial {
	public var bits : Int;
	public var t : h3d.mat.BigTexture.BigTextureElement;
	public var spec : h3d.mat.BigTexture.BigTextureElement;
	public var normal : h3d.mat.BigTexture.BigTextureElement;
	public var mat : hxd.fmt.hmd.Data.Material;
	public var culling : Bool;
	public var blend : h3d.mat.BlendMode;
	public var killAlpha : Null<Float>;
	public var emissive : Null<Float>;
	public var stencil : Null<Int>;
	public var lights : Bool;
	public var shadows : Bool;
	public var shaders : Array<hxsl.Shader>;
	public var name : String;

	public function new() {
		lights = true;
		shadows = true;
		shaders = [];
	}

	public function clone() : WorldMaterial {
		var wm = new WorldMaterial();
		wm.bits = this.bits;
		wm.t = this.t;
		wm.spec = this.spec;
		wm.normal = this.normal;
		wm.mat = this.mat;
		wm.culling = this.culling;
		wm.blend = this.blend;
		wm.killAlpha = this.killAlpha;
		wm.emissive = this.emissive;
		wm.stencil = this.stencil;
		wm.lights = this.lights;
		wm.shadows = this.shadows;
		wm.shaders = this.shaders.copy();
		wm.name = this.name;
		return wm;
	}


	public function updateBits() {
		bits = (t.t == null ? 0 : t.t.id   		<< 18)
			| ((stencil == null ? 0 : stencil)  << 10)
			| ((normal == null ? 0 : 1)     	<< 9)
			| (blend.getIndex()             	<< 6)
			| ((killAlpha == null ? 0 : 1)  	<< 5)
			| ((emissive == null ? 0 : 1)   	<< 4)
			| ((lights ? 1 : 0)             	<< 3)
			| ((shadows ? 1 : 0)            	<< 2)
			| ((spec == null ? 0 : 1)       	<< 1)
			| (culling ? 1 : 0);
	}
}

class WorldModelGeometry {
	public var m : WorldMaterial;
	public var startVertex : Int;
	public var startIndex : Int;
	public var vertexCount : Int;
	public var indexCount : Int;
	public function new(m) {
		this.m = m;
	}
}

enum OptAlgorithm {
	None;
	/**
		Sort triangles by Z descending
	**/
	TopDown;
}

class WorldModel {
	public var r : hxd.res.Model;
	public var stride : Int;
	public var buf : hxd.FloatBuffer;
	public var idx : hxd.IndexBuffer;
	public var geometries : Array<WorldModelGeometry>;
	public var bounds : h3d.col.Bounds;
	public function new(r) {
		this.r = r;
		this.buf = new hxd.FloatBuffer();
		this.idx = new hxd.IndexBuffer();
		this.geometries = [];
		bounds = new h3d.col.Bounds();
	}

	public function optimize( algo : OptAlgorithm ) {
		switch( algo ) {
		case None:
		case TopDown:
			var vertexCount = Std.int(buf.length/stride);
			var vertexRemap = new haxe.ds.Vector(vertexCount);
			var indexRemap = new hxd.IndexBuffer(idx.length);
			var vidx = 0;
			var iidx = 0;
			for( i in 0...vertexCount )
				vertexRemap[i] = -1;
			for( g in geometries ) {
				var triCount = Std.int(g.indexCount/3);
				var triZ = new Array<Float>();
				var triIndexes = new Array<Int>();
				if( g.startIndex != iidx ) throw "assert";
				triZ[triCount-1] = 0;
				triIndexes[triCount-1] = 0;
				for( i in 0...triCount ) {
					var base = g.startIndex + i*3;
					var z1 = buf[idx[base++] * stride + 2];
					var z2 = buf[idx[base++] * stride + 2];
					var z3 = buf[idx[base++] * stride + 2];
					var zmin = z1;
					if( z2 < zmin ) zmin = z2;
					if( z3 < zmin ) zmin = z3;
					triIndexes[i] = i;
					triZ[i] = zmin;
				}
				haxe.ds.ArraySort.sort(triIndexes, function(i1,i2) {
					return triZ[i1] < triZ[i2] ? 1 : -1;
				});
				for( i in 0...triCount ) {
					var i2 = triIndexes[i];
					var base = g.startIndex + i2 * 3;
					for( j in 0...3 ) {
						var v = idx[base++];
						var nv = vertexRemap[v];
						if( nv < 0 ) {
							nv = vidx++;
							vertexRemap[v] = nv;
						}
						indexRemap[iidx++] = nv;
					}
				}
			}
			var bufRemap = new hxd.FloatBuffer(vertexCount*stride);
			for( v in 0...vertexCount ) {
				var nv = vertexRemap[v];
				var readPos = v * stride;
				var writePos = nv * stride;
				for( i in 0...stride )
					bufRemap[writePos++] = buf[readPos++];
			}
			this.idx = indexRemap;
			this.buf = bufRemap;
		}
	}

}

class World extends Object {

	public var chunkSize(default,null) : Int;

	/*
		For each texture loaded, will call resolveSpecularTexture and have separate spec texture.
	*/
	public var enableSpecular = false;
	/*
		For each texture loaded, will call resolveNormalMap and have separate normal texture.
	*/
	public var enableNormalMaps = false;
	/*
		When enableSpecular=true, will store the specular value in the alpha channel instead of a different texture.
		This will erase alpha value of transparent textures, so should only be used if specular is only on opaque models.
	*/
	public var specularInAlpha = false;

	var bigTextureSize = 2048;
	var defaultDiffuseBG = 0;
	var defaultNormalBG = 0x8080FF;
	var defaultSpecularBG = 0;

	var chunks : Map<Int,WorldChunk>;
	var allChunks : Array<WorldChunk>;
	var chunksBounds : { xMin : Int, yMin : Int, xMax : Int, yMax : Int };
	var bigTextures : Array<{ diffuse : h3d.mat.BigTexture, spec : h3d.mat.BigTexture, normal : h3d.mat.BigTexture }>;
	var textures : Map<String, WorldMaterial>;
	var autoCollect : Bool;

	public function new( chunkSize : Int, parent, ?autoCollect = true ) {
		super(parent);
		chunks = [];
		bigTextures = [];
		allChunks = [];
		chunksBounds = { xMin : 0x7FFFFFFF, yMin : 0x7FFFFFFF, xMax : 0x80000000, yMax : 0x80000000 };
		textures = new Map();
		this.chunkSize = chunkSize;
		this.autoCollect = autoCollect;
		if( autoCollect )
			h3d.Engine.getCurrent().mem.garbage = garbage;
	}

	public function garbage() {
		var last : WorldChunk = null;
		for( c in allChunks )
			if( c.initialized && !c.root.visible && (last == null || c.lastFrame < last.lastFrame) )
				last = c;
		if( last != null )
			cleanChunk(last);
	}

	function buildFormat() {
		var r = {
			fmt : [
				new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3),
				new hxd.fmt.hmd.Data.GeometryFormat("normal", DVec3),
			],
			defaults : [],
		};
		if(enableNormalMaps) {
			r.defaults[r.fmt.length] = new h3d.Vector(1,0,0);
			r.fmt.push(new hxd.fmt.hmd.Data.GeometryFormat("tangent", DVec3));
		}
		r.fmt.push(new hxd.fmt.hmd.Data.GeometryFormat("uv", DVec2));
		return r;
	}

	function getBlend( r : hxd.res.Image ) : h3d.mat.BlendMode {
		if( r.entry.extension == "jpg" )
			return None;
		return Alpha;
	}

	function resolveTexturePath( r : hxd.res.Model, mat : hxd.fmt.hmd.Data.Material ) {
		var path = mat.diffuseTexture;
		if( hxd.res.Loader.currentInstance.exists(path) )
			return path;
		var dir = r.entry.directory;
		if( dir != "" ) dir += "/";
		return dir + path.split("/").pop();
	}

	function resolveSpecularTexture( path : String, mat : hxd.fmt.hmd.Data.Material) : hxd.res.Image {
		if(mat.specularTexture == null)
			return null;
		try {
			return hxd.res.Loader.currentInstance.load(mat.specularTexture).toImage();
		} catch( e : hxd.res.NotFound ) try {
			var path = path.split("/");
			path.pop();
			path.push(mat.specularTexture.split("/").pop());
			return hxd.res.Loader.currentInstance.load(path.join("/")).toImage();
		} catch( e : hxd.res.NotFound ) {
			return null;
		}
	}

	function resolveNormalMap( path : String, mat : hxd.fmt.hmd.Data.Material) : hxd.res.Image {
		if(mat.normalMap == null)
			return null;
		try {
			return hxd.res.Loader.currentInstance.load(mat.normalMap).toImage();
		} catch( e : hxd.res.NotFound ) try {
			var path = path.split("/");
			path.pop();
			path.push(mat.normalMap.split("/").pop());
			return hxd.res.Loader.currentInstance.load(path.join("/")).toImage();
		} catch( e : hxd.res.NotFound ) {
			return null;
		}
	}

	function loadMaterialTexture( r : hxd.res.Model, mat : hxd.fmt.hmd.Data.Material, modelName : String ) : WorldMaterial {
		var texturePath = resolveTexturePath(r, mat);
		var m = textures.get(texturePath);
		if( m != null )
			return m;

		var rt = hxd.res.Loader.currentInstance.load(texturePath).toImage();
		var t = null;
		var btex = null;
		for( b in bigTextures ) {
			t = b.diffuse.add(rt);
			if( t != null ) {
				btex = b;
				break;
			}
		}
		if( t == null ) {
			var b = new h3d.mat.BigTexture(bigTextures.length, bigTextureSize, defaultDiffuseBG);
			btex = { diffuse : b, spec : null, normal : null };
			bigTextures.unshift( btex );
			t = b.add(rt);
			if( t == null ) throw "Texture " + texturePath + " is too big";
		}

		inline function checkSize(res:hxd.res.Image) {
			if(res != null) {
				var size = res.getSize();
				if(size.width != t.width || size.height != t.height)
					throw 'Texture ${res.entry.path} has different size from diffuse (${size.width}x${size.height})';
			}
		}

		var specTex = null;
		if( enableSpecular ) {
			var res = resolveSpecularTexture(texturePath, mat);
			checkSize(res);
			if( specularInAlpha ) {
				if( res != null ) {
					t.setAlpha(res);
					specTex = t;
				}
			} else {
				if( btex.spec == null )
					btex.spec = new h3d.mat.BigTexture(-1, bigTextureSize, defaultSpecularBG);
				if( res != null )
					specTex = btex.spec.add(res);
				else
					specTex = btex.spec.addEmpty(t.width, t.height); // keep UV in-sync
			}
		}

		var normalMap = null;
		if( enableNormalMaps ) {
			var res = resolveNormalMap(texturePath, mat);
			checkSize(res);
			if( btex.normal == null )
				btex.normal = new h3d.mat.BigTexture(-1, bigTextureSize, defaultNormalBG);
			if( res != null )
				normalMap = btex.normal.add(res);
			else
				normalMap = btex.normal.addEmpty(t.width, t.height); // keep UV in-sync
		}

		var m = new WorldMaterial();
		m.t = t;
		m.spec = specTex;
		m.normal = normalMap;
		m.blend = getBlend(rt);
		m.killAlpha = null;
		m.emissive = null;
		m.mat = mat;
		m.culling = true;
		m.stencil = null;
		m.updateBits();
		textures.set(texturePath, m);
		return m;
	}

	public function done() {
		for( b in bigTextures ) {
			b.diffuse.done();
			if(b.spec != null)
				b.spec.done();
			if(b.normal != null)
				b.normal.done();
		}
	}

	@:noDebug
	public function loadModel( r : hxd.res.Model, ?filter : hxd.fmt.hmd.Data.Model -> Bool) : WorldModel {
		var lib = r.toHmd();
		var models = lib.header.models;
		var format = buildFormat();

		var model = new WorldModel(r);
		model.stride = 0;
		for( f in format.fmt )
			model.stride += f.format.getSize();

		var startVertex = 0, startIndex = 0;
		for( m in models ) {

			// Name filtering
			if( filter != null && !filter(m) ) {
				continue;
			}

			var geom = lib.header.geometries[m.geometry];
			if( geom == null ) continue;
			var pos = m.position.toMatrix();
			var parentIdx = m.parent;
			while(parentIdx >= 0) {
				var parent = models[parentIdx];
				pos.multiply(parent.position.toMatrix(), pos);
				parentIdx = parent.parent;
			}
			for( mid in 0...m.materials.length ) {
				var mat = lib.header.materials[m.materials[mid]];
				if(mat == null || mat.diffuseTexture == null) continue;
				var wmat = loadMaterialTexture(r, mat, m.name);
				if( wmat == null ) continue;
				var data = lib.getBuffers(geom, format.fmt, format.defaults, mid);

				var m = new WorldModelGeometry(wmat);
				m.vertexCount = Std.int(data.vertexes.length / model.stride);
				m.indexCount = data.indexes.length;
				m.startVertex = startVertex;
				m.startIndex = startIndex;
				model.geometries.push(m);

				var vl = data.vertexes;
				var p = 0;
				var extra = model.stride - 8;
				if(enableNormalMaps)
					extra -= 3;

				for( i in 0...m.vertexCount ) {
					var x = vl[p++];
					var y = vl[p++];
					var z = vl[p++];
					var nx = vl[p++];
					var ny = vl[p++];
					var nz = vl[p++];
					var tx = 1., ty = 0., tz = 0.;
					if(enableNormalMaps) {
						tx = vl[p++];
						ty = vl[p++];
						tz = vl[p++];
					}
					var u = vl[p++];
					var v = vl[p++];

					// position
					var pt = new h3d.Vector(x,y,z);
					pt.transform3x4(pos);
					model.buf.push(pt.x);
					model.buf.push(pt.y);
					model.buf.push(pt.z);
					model.bounds.addPos(pt.x, pt.y, pt.z);

					// normal
					var n = new h3d.Vector(nx, ny, nz);
					n.transform3x3(pos);
					var len = hxd.Math.invSqrt(n.lengthSq());
					model.buf.push(n.x * len);
					model.buf.push(n.y * len);
					model.buf.push(n.z * len);

					if( enableNormalMaps ) {
						var t = new h3d.Vector(tx, ty, tz);
						var tlen = t.length();
						t.transform3x3(pos);
						var len = tlen * hxd.Math.invSqrt(n.lengthSq());
						model.buf.push(t.x * len);
						model.buf.push(t.y * len);
						model.buf.push(t.z * len);
					}

					// uv
					model.buf.push(u * wmat.t.su + wmat.t.du);
					model.buf.push(v * wmat.t.sv + wmat.t.dv);

					// extra
					for( k in 0...extra )
						model.buf.push(vl[p++]);
				}

				for( i in 0...m.indexCount )
					model.idx.push(data.indexes[i] + startVertex);

				startVertex += m.vertexCount;
				startIndex += m.indexCount;
			}
		}
		return model;
	}

	inline function makeId( cx : Int, cy : Int ) {
		return (cx & 0xFFFF) | ((cy & 0xFFFF) << 16);
	}

	function getChunk( x : Float, y : Float, create = false ) {
		var ix = Math.floor(x / chunkSize);
		var iy = Math.floor(y / chunkSize);
		if( ix < 0 ) ix = 0;
		if( iy < 0 ) iy = 0;
		var cid = makeId(ix,iy);
		var c = chunks[cid];
		if( c == null && create ) {
			c = new WorldChunk(ix, iy);
			c.x = ix * chunkSize;
			c.y = iy * chunkSize;
			addChild(c.root);
			chunks[cid] = c;
			if( ix < chunksBounds.xMin ) chunksBounds.xMin = ix;
			if( iy < chunksBounds.yMin ) chunksBounds.yMin = iy;
			if( ix > chunksBounds.xMax ) chunksBounds.xMax = ix;
			if( iy > chunksBounds.yMax ) chunksBounds.yMax = iy;
			allChunks.push(c);
		}
		return c;
	}

	function initChunkSoil( c : WorldChunk ) {
	}

	function initChunkElements( c : WorldChunk ) {
		for( e in c.elements ) {
			var model = e.model;
			for( g in model.geometries ) {
				var b = c.buffers.get(g.m.bits);
				if( b == null ) {
					var bp = new h3d.prim.BigPrimitive(getStride(model), true);
					bp.hasTangents = enableNormalMaps;
					b = new h3d.scene.Mesh(bp, c.root);
					b.name = g.m.name;
					c.buffers.set(g.m.bits, b);
					initMaterial(b, g.m);
				}
				var p = hxd.impl.Api.downcast(b.primitive, h3d.prim.BigPrimitive);

				if(e.optimized) {
					var m = e.transform;
					var scale = m._33;
					var rotZ = hxd.Math.atan2(m._12 / scale, m._11 / scale);
					p.addSub(model.buf, model.idx, g.startVertex, Std.int(g.startIndex / 3), g.vertexCount, Std.int(g.indexCount / 3), m.tx, m.ty, m.tz, rotZ, scale, model.stride, 0., 0., 1., null);
				}
				else
					p.addSub(model.buf, model.idx, g.startVertex, Std.int(g.startIndex / 3), g.vertexCount, Std.int(g.indexCount / 3), 0., 0., 0., 0., 0., model.stride, 0., 0., 1., e.transform);
			}
		}
	}

	function cleanChunk( c : WorldChunk ) {
		if( !c.initialized ) return;
		c.initialized = false;
		for( b in c.buffers ) {
			b.remove();
		}
		c.buffers = new Map();
	}

	function addChunkBounds(c : WorldChunk, model : WorldModel, mat : h3d.Matrix ) {
		var b = model.bounds.clone();
		b.transform(mat);
		c.bounds.add(b);
	}

	function initMaterial( mesh : h3d.scene.Mesh, mat : WorldMaterial ) {
		mesh.material.blendMode = mat.blend;
		mesh.material.texture = mat.t.t.tex;
		mesh.material.textureShader.killAlpha = mat.killAlpha != null;
		mesh.material.textureShader.killAlphaThreshold = mat.killAlpha;
		mesh.material.mainPass.enableLights = mat.lights;
		mesh.material.shadows = mat.shadows;
		mesh.material.mainPass.culling = mat.culling ? Back : None;
		mesh.material.mainPass.depthWrite = true;
		mesh.material.mainPass.depthTest = Less;

		for(s in mat.shaders){
			mesh.material.mainPass.addShader(s);
		}

		if( mat.spec != null ) {
			if( specularInAlpha ) {
				mesh.material.specularTexture = null;
				mesh.material.textureShader.specularAlpha = true;
			} else
				mesh.material.specularTexture = mat.spec.t.tex;
		} else
			mesh.material.specularAmount = 0;

		if(enableNormalMaps)
			mesh.material.normalMap = mat.normal.t.tex;

	}

	/**
		Dispose the World instance.
		Note: Only chunked world objects will be disposed. Any objects added to World object will be disposed when World is removed from scene or scene is disposed.
	**/
	public function dispose() {
		for( c in allChunks )
			c.dispose();
		allChunks = [];
		chunks = [];
		for(b in bigTextures) {
			b.diffuse.dispose();
			if(b.spec != null)
				b.spec.dispose();
			if(b.normal != null)
				b.normal.dispose();
		}
		bigTextures = [];
		textures = new Map();
		if( autoCollect )
			h3d.Engine.getCurrent().mem.garbage = noGarbage;
	}

	static function noGarbage() {}

	public function onContextLost() {
		for( c in allChunks )
			cleanChunk(c);
	}

	function getStride( model : WorldModel ) {
		return model.stride;
	}

	public function add( model : WorldModel, x : Float, y : Float, z : Float, scale = 1., rotation = 0. ) {
		var c = getChunk(x, y, true);
		var m = new h3d.Matrix();
		m.initScale(scale, scale, scale);
		m.rotate(0, 0, rotation);
		m.translate(x, y, z);
		c.elements.push(new WorldElement(model, m, true));
		addChunkBounds(c, model, m);
	}

	public function addTransform( model : WorldModel, mat : h3d.Matrix ) {
		var c = getChunk(mat.tx, mat.ty, true);
		c.elements.push(new WorldElement(model, mat, false));
		addChunkBounds(c, model, mat);
	}

	override function syncRec(ctx:RenderContext) {
		super.syncRec(ctx);
		// don't do in sync() since animations in our world might affect our chunks
		for( c in allChunks ) {
			var visible = ctx.computingStatic || c.bounds.inFrustum(ctx.camera.frustum);
			c.root.culled = !visible;
			if( visible ) {
				c.lastFrame = ctx.frame;
				initChunk(c);
			}
		}
	}

	function initChunk( c : WorldChunk ) {
		if( !c.initialized ) {
			c.initialized = true;
			initChunkSoil(c);
			initChunkElements(c);
		}
	}

	public function getWorldBounds( ?b : h3d.col.Bounds ) {
		if( b == null )
			b = new h3d.col.Bounds();
		for(c in allChunks)
			b.add(c.bounds);
		return b;
	}

	#if (hxbit && !macro && heaps_enable_serialize)
	override function customUnserialize(ctx:hxbit.Serializer) {
		super.customUnserialize(ctx);
		allChunks = [];
	}
	#end

}