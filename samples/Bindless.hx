class Bindless extends SampleApp {

	var cache : h3d.prim.ModelCache;

	var rockBatch : h3d.scene.MeshBatch;
	var treeBatch : h3d.scene.MeshBatch;

	override function init() {
		cache = new h3d.prim.ModelCache();

		var sun = new h3d.scene.pbr.DirLight(new h3d.Vector(0.3, -0.4, -0.9), s3d);
		sun.shadows.mode = Dynamic;

		var rockTex1 = hxd.Res.rockTexture.toTexture();
		var treeTex1 = hxd.Res.treeTexture.toTexture();

		var rock : h3d.scene.Mesh = cast cache.loadModel(hxd.Res.rock);
		var tree : h3d.scene.Mesh = cast cache.loadModel(hxd.Res.tree);

		var rockTex2 = hxd.Res.rockTexture2.toTexture();
		var treeTex2 = hxd.Res.treeTexture2.toTexture();

		rockBatch = new h3d.scene.MeshBatch(cast rock.primitive,s3d);
		rockBatch.material.texture = rockTex1;
		rockBatch.enableStorageBuffer();
		rockBatch.enablePerInstanceTexture();
		rockBatch.begin(40);
		treeBatch = new h3d.scene.MeshBatch(cast tree.primitive,s3d);
		treeBatch.material.texture = treeTex1;
		treeBatch.enableStorageBuffer();
		treeBatch.enablePerInstanceTexture();
		treeBatch.begin(40);

		var rand = new hxd.Rand(2);
		for ( i in 0...40 ) {
			rockBatch.x = rand.rand() * 40 - 20;
			rockBatch.y = rand.rand() * 40 - 20;
			rockBatch.setRotation(0, 0, rand.rand() * Math.PI * 2);
			treeBatch.x = rand.rand() * 40 - 20;
			treeBatch.y = rand.rand() * 40 - 20;
			treeBatch.setRotation(0, 0, rand.rand() * Math.PI * 2);
			rockBatch.material.texture = (rand.rand() < 0.5) ? rockTex1 : rockTex2;
			treeBatch.material.texture = (rand.rand() < 0.5) ? treeTex1 : treeTex2;
			rockBatch.emitInstance();
			treeBatch.emitInstance();
		}

		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	static function main() {
		h3d.mat.PbrMaterialSetup.set();
		hxd.Res.initEmbed();
		new Bindless();
	}

}
