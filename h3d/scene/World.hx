package h3d.scene;

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

	public function new(cx, cy) {
		this.cx = cx;
		this.cy = cy;
		root = new h3d.scene.Object();
		buffers = new Map();
		bounds = new h3d.col.Bounds();
		root.name = "chunk[" + cx + "-" + cy + "]";
	}

	public function dispose() {
		root.remove();
		root.dispose();
	}
}

class WorldMaterial {
	public var bits : Int;
	public var t : h3d.mat.BigTexture.BigTextureElement;
	public var spec : h3d.mat.BigTexture.BigTextureElement;
	public var mat : hxd.fmt.hmd.Data.Material;
	public var blend : h3d.mat.BlendMode;
	public var killAlpha : Null<Float>;
	public var lights : Bool;
	public var shadows : Bool;
	public var shaders : Array<hxsl.Shader>;
	public var name : String;

	public function new() {
		lights = true;
		shadows = true;
		shaders = [];
	}
	public function updateBits() {
		bits = (t.t.id << 6) | (blend.getIndex() << 3) | ((killAlpha == null ? 0 : 1) << 2) | ((lights ? 1 : 0) << 1) | (shadows ? 1 : 0);
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
}

class World extends Object {

	var chunkBits : Int;
	var chunkSize : Int;
	var worldSize : Int;
	var worldStride : Int;
	var bigTextureSize = 2048;
	var bigTextureBG = 0xFF8080FF;
	var soilColor = 0x408020;
	var chunks : Array<WorldChunk>;
	var allChunks : Array<WorldChunk>;
	var bigTextures : Array<{ diffuse : h3d.mat.BigTexture, spec : h3d.mat.BigTexture }>;
	var textures : Map<String, WorldMaterial>;
	public var enableSpecular = false;

	public function new( chunkSize : Int, worldSize : Int, ?parent ) {
		super(parent);
		chunks = [];
		bigTextures = [];
		allChunks = [];
		textures = new Map();
		this.chunkBits = 1;
		while( chunkSize > (1 << chunkBits) )
			chunkBits++;
		this.chunkSize = 1 << chunkBits;
		this.worldSize = worldSize;
		this.worldStride = Math.ceil(worldSize / chunkSize);
	}

	function buildFormat() {
		return {
			fmt : [
				new hxd.fmt.hmd.Data.GeometryFormat("position", DVec3),
				new hxd.fmt.hmd.Data.GeometryFormat("normal", DVec3),
				new hxd.fmt.hmd.Data.GeometryFormat("uv", DVec2),
			],
			defaults : [],
		};
	}

	function getBlend( r : hxd.res.Image ) : h3d.mat.BlendMode {
		if( r.entry.extension == "jpg" )
			return None;
		return Alpha;
	}

	function resolveSpecularTexture( path : String ) : hxd.res.Image {
		path =  path.substr(0, path.length - 4) + "spec.jpg";
		try {
			return hxd.res.Loader.currentInstance.load(path).toImage();
		} catch( e : hxd.res.NotFound ) {
			return null;
		}
	}

	function loadMaterialTexture( r : hxd.res.Model, mat : hxd.fmt.hmd.Data.Material ) : WorldMaterial {
		var texturePath = r.entry.directory;
		if( texturePath != "" ) texturePath += "/";
		texturePath += mat.diffuseTexture.split("/").pop();

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
			var b = new h3d.mat.BigTexture(bigTextures.length, bigTextureSize, bigTextureBG);
			btex = { diffuse : b, spec : null };
			bigTextures.unshift( btex );
			t = b.add(rt);
			if( t == null ) throw "Texture " + texturePath + " is too big";
		}

		var specTex = null;
		if( enableSpecular ) {
			var res = resolveSpecularTexture(texturePath);
			if( btex.spec == null )
				btex.spec = new h3d.mat.BigTexture(-1, bigTextureSize, bigTextureBG);
			if( res != null )
				specTex = btex.spec.add(res);
			else
				@:privateAccess btex.spec.allocPos(t.t.tex.width, t.t.tex.height); // keep UV in-sync
		}

		var m = new WorldMaterial();
		m.t = t;
		m.spec = specTex;
		m.blend = getBlend(rt);
		m.killAlpha = null;
		m.mat = mat;
		m.updateBits();
		textures.set(texturePath, m);
		return m;
	}

	public function done() {
		for( b in bigTextures ) {
			b.diffuse.done();
			if(b.spec != null)
				b.spec.done();
		}
	}

	public function loadModel( r : hxd.res.Model ) : WorldModel {
		var lib = r.toHmd();
		var models = lib.header.models;
		var format = buildFormat();

		var model = new WorldModel(r);
		model.stride = 0;
		for( f in format.fmt )
			model.stride += f.format.getSize();

		var startVertex = 0, startIndex = 0;
		for( m in models ) {
			var geom = lib.header.geometries[m.geometry];
			if( geom == null ) continue;
			var pos = m.position.toMatrix();
			for( mid in 0...m.materials.length ) {
				var mat = loadMaterialTexture(r, lib.header.materials[m.materials[mid]]);
				if( mat == null ) continue;
				var data = lib.getBuffers(geom, format.fmt, format.defaults, mid);

				var m = new WorldModelGeometry(mat);
				m.vertexCount = Std.int(data.vertexes.length / model.stride);
				m.indexCount = data.indexes.length;
				m.startVertex = startVertex;
				m.startIndex = startIndex;
				model.geometries.push(m);

				var vl = data.vertexes;
				var p = 0;
				var extra = model.stride - 8;
				for( i in 0...m.vertexCount ) {
					var x = vl[p++];
					var y = vl[p++];
					var z = vl[p++];
					var nx = vl[p++];
					var ny = vl[p++];
					var nz = vl[p++];
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

					// uv
					model.buf.push(u * mat.t.su + mat.t.du);
					model.buf.push(v * mat.t.sv + mat.t.dv);

					// extra
					for( k in 0...extra )
						model.buf.push(vl[p++]);
				}

				for( i in 0...m.indexCount )
					model.idx.push(data.indexes[i] + startIndex);

				startVertex += m.vertexCount;
				startIndex += m.indexCount;
			}
		}
		return model;
	}

	function getChunk( x : Float, y : Float, create = false ) {
		var ix = Std.int(x) >> chunkBits;
		var iy = Std.int(y) >> chunkBits;
		if( ix < 0 ) ix = 0;
		if( iy < 0 ) iy = 0;
		var cid = ix + iy * worldStride;
		var c = chunks[cid];
		if( c == null && create ) {
			c = new WorldChunk(ix, iy);
			c.x = ix * chunkSize;
			c.y = iy * chunkSize;
			addChild(c.root);
			chunks[cid] = c;
			allChunks.push(c);
		}
		return c;
	}

	function initSoil( c : WorldChunk ) {
		var cube = new h3d.prim.Cube(chunkSize, chunkSize, 0);
		cube.addNormals();
		cube.addUVs();
		var soil = new h3d.scene.Mesh(cube, c.root);
		soil.x = c.x;
		soil.y = c.y;
		soil.material.texture = h3d.mat.Texture.fromColor(soilColor);
		soil.material.shadows = true;
	}

	function initMaterial( mesh : h3d.scene.Mesh, mat : WorldMaterial ) {
		mesh.material.blendMode = mat.blend;
		mesh.material.texture = mat.t.t.tex;
		mesh.material.textureShader.killAlpha = mat.killAlpha != null;
		mesh.material.textureShader.killAlphaThreshold = mat.killAlpha;
		mesh.material.mainPass.enableLights = mat.lights;
		mesh.material.shadows = mat.shadows;

		for(s in mat.shaders)
			mesh.material.mainPass.addShader(s);

		if(mat.spec != null)
			mesh.material.specularTexture = mat.spec.t.tex;
		else mesh.material.specularAmount = 0;
	}

	override function dispose() {
		super.dispose();
		for( c in allChunks )
			c.dispose();
		allChunks = [];
		chunks = [];
		for(b in bigTextures) {
			b.diffuse.dispose();
			if(b.spec != null)
				b.spec.dispose();
		}
		bigTextures = [];
		textures = new Map();
	}

	function getStride( model : WorldModel ) {
		return model.stride;
	}

	public function add( model : WorldModel, x : Float, y : Float, z : Float, scale = 1., rotation = 0. ) {
		var c = getChunk(x, y, true);

		for( g in model.geometries ) {
			var b = c.buffers.get(g.m.bits);
			if( b == null ) {
				b = new h3d.scene.Mesh(new h3d.prim.BigPrimitive(getStride(model), true), c.root);
				b.name = g.m.name;
				c.buffers.set(g.m.bits, b);
				initMaterial(b, g.m);
			}
			var p = Std.instance(b.primitive, h3d.prim.BigPrimitive);
			p.addSub(model.buf, model.idx, g.startVertex, Std.int(g.startIndex / 3), g.vertexCount, Std.int(g.indexCount / 3), x, y, z, rotation, scale, model.stride);
		}


		// update bounds
		var cosR = Math.cos(rotation);
		var sinR = Math.sin(rotation);

		inline function addPoint(dx:Float, dy:Float, dz:Float) {
			var tx = dx * cosR - dy * sinR;
			var ty = dx * sinR + dy * cosR;
			c.bounds.addPos(tx * scale + x, ty * scale + y, dz * scale + z);
		}

		addPoint(model.bounds.xMin, model.bounds.yMin, model.bounds.zMin);
		addPoint(model.bounds.xMin, model.bounds.yMin, model.bounds.zMax);
		addPoint(model.bounds.xMin, model.bounds.yMax, model.bounds.zMin);
		addPoint(model.bounds.xMin, model.bounds.yMax, model.bounds.zMax);
		addPoint(model.bounds.xMax, model.bounds.yMin, model.bounds.zMin);
		addPoint(model.bounds.xMax, model.bounds.yMin, model.bounds.zMax);
		addPoint(model.bounds.xMax, model.bounds.yMax, model.bounds.zMin);
		addPoint(model.bounds.xMax, model.bounds.yMax, model.bounds.zMax);
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);

		for( c in allChunks ) {
			c.root.visible = c.bounds.inFrustum(ctx.camera.m);
			if( c.root.visible ) {
				if( !c.initialized) {
					c.initialized = true;
					initSoil(c);
				}
				c.lastFrame = ctx.frame;
			}
		}
	}

}