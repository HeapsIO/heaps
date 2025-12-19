class ColorTexture extends hxsl.Shader {
	static var SRC = {

		@input var input : {
			var uv : Vec2;
		}

		@perInstance @param var textureHandle : TextureHandle;
		var pixelColor : Vec4;
		var calculatedUV : Vec2;

		function __init__() {
			calculatedUV = input.uv;
		}

		function getTexture(): Sampler2D {
			var texture : Sampler2D;
			resolveSampler(textureHandle, texture);
			return texture;
		}

		function fragment() {
			var texture = getTexture();
			pixelColor = texture.get(calculatedUV);
		}
	}
}

class Bindless extends SampleApp {

	var cache : h3d.prim.ModelCache;

	var rockTexHandle1 : h3d.mat.TextureHandle;
	var rockTexHandle2 : h3d.mat.TextureHandle;
	var treeTexHandle1 : h3d.mat.TextureHandle;
	var treeTexHandle2 : h3d.mat.TextureHandle;

	var rockShader = new ColorTexture();
	var treeShader = new ColorTexture();
	var rockInstancedShader = new ColorTexture();
	var treeInstancedShader = new ColorTexture();

	var rockBatch : h3d.scene.MeshBatch;
	var treeBatch : h3d.scene.MeshBatch;

	override function init() {
		cache = new h3d.prim.ModelCache();

		var sun = new h3d.scene.pbr.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		sun.shadows.mode = Dynamic;

		var rockTex1 = hxd.Res.rockTexture.toTexture();
		rockTexHandle1 = engine.driver.getTextureHandle(rockTex1);
		var rockTex2 = hxd.Res.rockTexture2.toTexture();
		rockTexHandle2 = engine.driver.getTextureHandle(rockTex2);

		var treeTex1 = hxd.Res.treeTexture.toTexture();
		treeTexHandle1 = engine.driver.getTextureHandle(treeTex1);
		var treeTex2 = hxd.Res.treeTexture2.toTexture();
		treeTexHandle2 = engine.driver.getTextureHandle(treeTex2);

		rockShader.textureHandle = rockTexHandle1;
		treeShader.textureHandle = treeTexHandle1;

		var rock : h3d.scene.Mesh = cast cache.loadModel(hxd.Res.rock);
		for ( m in rock.getMaterials() )
			m.mainPass.addShader(rockShader);
		var tree : h3d.scene.Mesh = cast cache.loadModel(hxd.Res.tree);
		for ( m in tree.getMaterials() )
			m.mainPass.addShader(treeShader);
		tree.y = 3.0;
		s3d.addChild(rock);
		s3d.addChild(tree);

		rockBatch = new h3d.scene.MeshBatch(cast rock.primitive,s3d);
		rockBatch.material.mainPass.addShader(rockInstancedShader);
		rockBatch.enableStorageBuffer();
		rockBatch.begin(10);
		treeBatch = new h3d.scene.MeshBatch(cast tree.primitive,s3d);
		treeBatch.material.mainPass.addShader(treeInstancedShader);
		treeBatch.enableStorageBuffer();
		treeBatch.begin(10);

		var rand = new hxd.Rand(2);
		for ( i in 0...10 ) {
			rockBatch.x = rand.rand() * 20 - 10;
			rockBatch.y = rand.rand() * 20 - 10;
			rockBatch.setRotation(0, 0, rand.rand() * Math.PI * 2);
			treeBatch.x = rand.rand() * 20 - 10;
			treeBatch.y = rand.rand() * 20 - 10;
			treeBatch.setRotation(0, 0, rand.rand() * Math.PI * 2);
			rockInstancedShader.textureHandle = (rand.rand() < 0.5) ? rockTexHandle1 : rockTexHandle2;
			treeInstancedShader.textureHandle = (rand.rand() < 0.5) ? treeTexHandle1 : treeTexHandle2;
			rockBatch.emitInstance();
			treeBatch.emitInstance();
		}

		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	static function main() {
		#if (hldx && dx12)
		h3d.mat.PbrMaterialSetup.set();
		hxd.Res.initEmbed();
		new Bindless();
		#end
	}

}
