package h3d.scene.pbr;

class VolumetricLightmap extends h3d.scene.Mesh {

	public var lightProbes:Array<LightProbe> = [];
	public var lightProbeBuffer : h3d.Buffer;
	public var lightProbeTexture : h3d.mat.Texture;
	public var shOrder : Int = 1;
	public var voxelSize (default, set) : h3d.Vector;
	public var probeCount : h3d.col.IPoint;
	public var useAlignedProb : Bool = false;
	public var strength : Float = 1.;

	public var lastBakedProbeIndex = -1;

	var shader : h3d.shader.pbr.VolumetricLightmap;

	public function new(?parent) {
		super(new h3d.prim.Cube(1,1,1,false), null, parent);
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
		material.mainPass.stencil.setFunc(Equal, 0, 0xFF, 0xFF);
		material.mainPass.stencil.setOp(Keep, Keep, Increment);
		probeCount = new h3d.col.IPoint();
		voxelSize = new h3d.Vector(1,1,1);
	}

	function set_voxelSize(newSize) :h3d.Vector {
		voxelSize = newSize;
		updateProbeCount();
		return voxelSize;
	}

	public function updateProbeCount(){
		probeCount.set(Std.int(Math.max(1,Math.floor(scaleX/voxelSize.x)) + 1),
						Std.int(Math.max(1,Math.floor(scaleY/voxelSize.y)) + 1),
						Std.int(Math.max(1,Math.floor(scaleZ/voxelSize.z)) + 1));
	}

	override function sync(ctx:RenderContext) {
		shader.ORDER = shOrder;
		shader.SIZE = lightProbes.length * shader.ORDER * shader.ORDER;
		shader.lightmapInvPos.load(getInvPos());
		shader.lightmapSize.load(new h3d.Vector(probeCount.x, probeCount.y, probeCount.z));
		shader.voxelSize.load(new h3d.Vector(scaleX/(probeCount.x - 1), scaleY/(probeCount.y - 1), scaleZ/(probeCount.z - 1)));
		shader.lightProbeTexture = lightProbeTexture;
		shader.cameraInverseViewProj.load(ctx.camera.getInverseViewProj());
		shader.cameraPos.load(ctx.camera.pos);
		shader.strength = strength;
	}

	public function generateProbes() {
		var totalProbeCount : Int = probeCount.x * probeCount.y * probeCount.z ;
		lightProbes.resize(totalProbeCount);
		lastBakedProbeIndex = -1;

		for(i in 0 ... probeCount.x){
			for(j in 0 ... probeCount.y){
				for(k in 0 ... probeCount.z){
					var index : Int = i + j * probeCount.x + k * probeCount.x * probeCount.y;
					var probePos : h3d.Vector = new h3d.Vector( i/(probeCount.x - 1),  j/(probeCount.y - 1), k/(probeCount.z - 1));
					localToGlobal(probePos);

					if(useAlignedProb){
						var overlappedLightmaps : Array<VolumetricLightmap> = [];
						// Check if a probe is inside an other lightmap
						/*for(i in 0 ... volumetricLightmaps.length){
							if(volumetricLightmaps[i] != this && volumetricLightmaps[i].isInsideVolume(probePos)){
								overlappedLightmaps.push(volumetricLightmaps[i]);
							}
						}*/
						if(overlappedLightmaps.length > 0){
							var alignment = getWorldAlignment(overlappedLightmaps);
							probePos.set(probePos.x - probePos.x % alignment.x, probePos.y - probePos.y % alignment.y, probePos.z - probePos.z % alignment.z);
						}
					}

					lightProbes[index] = new h3d.scene.pbr.LightProbe();
					lightProbes[index].position.set(probePos.x, probePos.y, probePos.z);
				}
			}
		}
	}

	public function getWorldAlignment(lightmaps : Array<VolumetricLightmap>) : h3d.Vector {
		var result =  new h3d.Vector(scaleX/(probeCount.x - 1), scaleY/(probeCount.y - 1), scaleZ/(probeCount.z - 1));
		for(i in 0...lightmaps.length){
			result.x = Math.max(result.x, lightmaps[i].scaleX / (lightmaps[i].probeCount.x - 1.0));
			result.y = Math.max(result.y, lightmaps[i].scaleY / (lightmaps[i].probeCount.y - 1.0));
			result.z = Math.max(result.z, lightmaps[i].scaleZ / (lightmaps[i].probeCount.z - 1.0));
		}
		return result;
	}

	public function isInsideVolume(worldPos: h3d.Vector) : Bool {
		var localPos = worldPos.clone();
		globalToLocal(localPos);
		return (localPos.x >= 0 && localPos.y >= 0 && localPos.z >= 0 && localPos.x <= 1 && localPos.y <= 1 && localPos.z <= 1);
	}

	// Pack data inside an Uniform Buffer
	public function packData(){
		var coefCount : Int = shOrder * shOrder;
		var size = lightProbes.length;
		lightProbeBuffer = new h3d.Buffer(size, 4 * coefCount, [UniformBuffer, Dynamic]);
		var buffer = new hxd.FloatBuffer();
		var probeIndex : Int = 0;
		var dataIndex : Int = 0;

		buffer.resize(size * 4);

		while(probeIndex < lightProbes.length) {
			var index = probeIndex * coefCount * 4;
			for(i in 0... coefCount) {
				buffer[index + i * 4 + 0] = lightProbes[probeIndex].sh.coefR[i];
				buffer[index + i * 4 + 1] = lightProbes[probeIndex].sh.coefG[i];
				buffer[index + i * 4 + 2] = lightProbes[probeIndex].sh.coefB[i];
				buffer[index + i * 4 + 3] = 0;
			}
			++probeIndex;
		}

		lightProbeBuffer.uploadVector(buffer, 0, size, 0);
		shader.lightProbeBuffer = lightProbeBuffer;
	}

	// Pack data inside a 2D texture
	public function packDataInsideTexture(){
		var coefCount : Int = shOrder * shOrder;
		var sizeX = probeCount.x * coefCount;
		var sizeY = probeCount.y * probeCount.z;

		if(lightProbeTexture == null || lightProbeTexture.width != sizeX || lightProbeTexture.height != sizeY){
			lightProbeTexture = new h3d.mat.Texture(sizeX, sizeY, [Dynamic], RGBA32F);
			lightProbeTexture.filter = Nearest;
		}
		var pixels : hxd.Pixels.PixelsFloat = hxd.Pixels.alloc(sizeX, sizeY, RGBA32F);

		for(k in 0 ... probeCount.z){
			for(j in 0 ... probeCount.y){
				for(i in 0 ... probeCount.x){
					var probeIndex : Int = i + j * probeCount.x + k * probeCount.x * probeCount.y;
					if(probeIndex > lastBakedProbeIndex) {
						lightProbeTexture.uploadPixels(pixels,0,0);
						return;
					}
					for(coef in 0... coefCount){
						var u = i + probeCount.x * coef;
						var v = j + k * probeCount.y;
						var sh = lightProbes[probeIndex].sh;
						var	color = new h3d.Vector(lightProbes[probeIndex].sh.coefR[coef], lightProbes[probeIndex].sh.coefG[coef], lightProbes[probeIndex].sh.coefB[coef], 0);
						pixels.setPixelF(u, v, color);
					}
				}
			}
		}

		lightProbeTexture.uploadPixels(pixels,0,0);
	}
}
