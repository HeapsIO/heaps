class CubeTexture extends hxd.App {

	override function init() {

		var skyTexture = new h3d.mat.Texture(128, 128, [Cube]);
		var bmp = hxd.Pixels.alloc(skyTexture.width, skyTexture.height, h3d.mat.Texture.nativeFormat);
		var faceColors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
		for( i in 0...6 ) {
			bmp.clear(faceColors[i]);
			skyTexture.uploadPixels(bmp, 0, i);
		}

		var sky = new h3d.prim.Sphere(30, 128, 128);
		sky.addNormals();
		var skyMesh = new h3d.scene.Mesh(sky, s3d);
		skyMesh.material.mainPass.culling = Front;
		skyMesh.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture));

		var sp = new h3d.prim.Sphere(0.5, 64, 64);
		sp.addNormals();
		var m = new h3d.scene.Mesh(sp, null, s3d);
		m.material.mainPass.enableLights = true;
		m.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture, true));

		var pt = new h3d.scene.PointLight(s3d);
		pt.x = 2;
		pt.y = 1;
		pt.z = 4;
		pt.enableSpecular = true;
		pt.params.set(0, 1, 0);

		s3d.lightSystem.ambientLight.set(0.1, 0.1, 0.1);

		new h3d.scene.CameraController(5, s3d).loadFromCamera();

	}

	static function main() {
		new CubeTexture();
	}

}