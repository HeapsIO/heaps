package h3d.scene.pbr;

class VolumetricLightmap extends h3d.scene.Mesh {

	public var lightProbeTexture : h3d.mat.Texture;
	public var shOrder : Int = 1;
	public var voxelSize (default, set) : h3d.Vector;
	public var probeCount : h3d.col.IPoint;
	public var useAlignedProb : Bool = false;
	public var strength : Float = 1.;

	public var lastBakedProbeIndex = -1;

	var prim : h3d.prim.Cube;

	var shader : h3d.shader.pbr.VolumetricLightmap;

	function set_voxelSize(newSize) :h3d.Vector {
		voxelSize = newSize;
		updateProbeCount();
		return voxelSize;
	}

	public function new(?parent) {
		var prim = new h3d.prim.Cube(1,1,1,false);
		prim.addNormals();
		super(prim, null, parent);
		shader = new h3d.shader.pbr.VolumetricLightmap();
		material.mainPass.removeShader(material.mainPass.getShader(h3d.shader.pbr.PropsValues));
		material.mainPass.addShader(shader);
		material.mainPass.setPassName("volumetricLightmap");
		material.mainPass.blend(One, One);
		material.mainPass.culling = Front;
		material.mainPass.depth(false, Greater);
		material.mainPass.enableLights = false;
		material.castShadows = false;
		material.shadows = false;
		material.mainPass.stencil = new h3d.mat.Stencil();
		material.mainPass.stencil.setFunc(NotEqual, 0x80, 0x80, 0x80);
		material.mainPass.stencil.setOp(Keep, Keep, Replace);
		probeCount = new h3d.col.IPoint();
		voxelSize = new h3d.Vector(1,1,1);
	}

	public function getProbeSH(coords : h3d.col.IPoint, ?pixels : hxd.Pixels.PixelsFloat ) : SphericalHarmonic {

		if(lightProbeTexture == null)
			return new SphericalHarmonic(shOrder);

		if(pixels == null)
			pixels = lightProbeTexture.capturePixels();

		var sh = new SphericalHarmonic(shOrder);

		var coefCount = getCoefCount();
		for(c in 0...coefCount){
			var u = coords.x + probeCount.x * c;
			var v = coords.y + coords.z * probeCount.y;
			var color = pixels.getPixelF(u, v);
			sh.coefR[c] = color.r;
			sh.coefG[c] = color.g;
			sh.coefB[c] = color.b;
		}

		return sh;
	}

	public inline function getCoefCount() : Int{
		return shOrder * shOrder;
	}

	public function getProbePosition(coords : h3d.col.IPoint){
		var probePos : h3d.Vector = new h3d.Vector( coords.x/(probeCount.x - 1),  coords.y/(probeCount.y - 1), coords.z/(probeCount.z - 1));
		localToGlobal(probePos);
		return probePos;
	}

	public function getProbeCoords(i : Int) : h3d.col.IPoint {
		var coords = new h3d.col.IPoint();
		coords.z = Std.int(i / (probeCount.x * probeCount.y));
		coords.y = Std.int((i - coords.z * probeCount.y * probeCount.x) / (probeCount.x));
		coords.x = Std.int((i - coords.z * probeCount.y * probeCount.x - coords.y * probeCount.x));
		return coords;
	}

	public function getProbeCount() {
		return probeCount.x * probeCount.y * probeCount.z;
	}

	override function onRemove() {
		super.onRemove();
		if( lightProbeTexture != null ) {
			lightProbeTexture.dispose();
			lightProbeTexture = null;
		}
	}

	public function updateProbeCount(){
		syncPos();
		var scale = absPos.getScale();
		probeCount.set(Std.int(Math.max(1,Math.floor(scale.x/voxelSize.x)) + 1),
						Std.int(Math.max(1,Math.floor(scale.y/voxelSize.y)) + 1),
						Std.int(Math.max(1,Math.floor(scale.z/voxelSize.z)) + 1));
	}

	public function load( bytes : haxe.io.Bytes ) {
		if( bytes.length == 0 )
			return false;
		bytes = try haxe.zip.Uncompress.run(bytes) catch( e : Dynamic ) throw e;
		var count = getProbeCount();
		if( bytes.length != count * getCoefCount() * 4 * 4 )
			return false;
		lastBakedProbeIndex = count;
		if( lightProbeTexture != null ) lightProbeTexture.dispose();
		lightProbeTexture = new h3d.mat.Texture(probeCount.x * getCoefCount(), probeCount.y * probeCount.z, [Dynamic], RGBA32F);
		lightProbeTexture.filter = Nearest;
		lightProbeTexture.uploadPixels(new hxd.Pixels(lightProbeTexture.width, lightProbeTexture.height, bytes, RGBA32F));
		return true;
	}

	public function save() : haxe.io.Bytes {
		var data;
		if( lightProbeTexture == null )
			data = haxe.io.Bytes.alloc(0);
		else
			data = lightProbeTexture.capturePixels().bytes;
		return haxe.zip.Compress.run(data,9);
	}

	override function emit(ctx:RenderContext){
		if( lightProbeTexture != null ) super.emit(ctx);
	}

	override function sync(ctx:RenderContext) {
		if( lightProbeTexture == null )
			return;
		var scale = absPos.getScale();
		shader.ORDER = shOrder;
		shader.lightmapInvPos.load(getInvPos());
		shader.lightmapSize.load(new h3d.Vector(probeCount.x, probeCount.y, probeCount.z));
		shader.voxelSize.load(new h3d.Vector(scale.x/(probeCount.x - 1), scale.y/(probeCount.y - 1), scale.z/(probeCount.z - 1)));
		shader.lightProbeTexture = lightProbeTexture;
		shader.cameraInverseViewProj.load(ctx.camera.getInverseViewProj());
		shader.cameraPos.load(ctx.camera.pos);
		shader.strength = strength;
	}

	public function getWorldAlignment(lightmaps : Array<VolumetricLightmap>) : h3d.Vector {
		var scale = absPos.getScale();
		var result =  new h3d.Vector(scale.x/(probeCount.x - 1), scale.y/(probeCount.y - 1), scale.z/(probeCount.z - 1));
		for(i in 0...lightmaps.length){
			var lsc = lightmaps[i].absPos.getScale();
			result.x = Math.max(result.x, lsc.x / (lightmaps[i].probeCount.x - 1.0));
			result.y = Math.max(result.y, lsc.y / (lightmaps[i].probeCount.y - 1.0));
			result.z = Math.max(result.z, lsc.z / (lightmaps[i].probeCount.z - 1.0));
		}
		return result;
	}

	public function isInsideVolume(worldPos: h3d.Vector) : Bool {
		var localPos = worldPos.clone();
		globalToLocal(localPos);
		return (localPos.x >= 0 && localPos.y >= 0 && localPos.z >= 0 && localPos.x <= 1 && localPos.y <= 1 && localPos.z <= 1);
	}
}
