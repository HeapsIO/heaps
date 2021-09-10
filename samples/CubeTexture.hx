class CubeTexture extends hxd.App {

	var skyTexture : h3d.mat.Texture;

	override function init() {

		skyTexture = new h3d.mat.Texture(128, 128, [Cube, MipMapped]);
		var bmp = hxd.Pixels.alloc(skyTexture.width, skyTexture.height, h3d.mat.Texture.nativeFormat);
		var faceColors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
		for( i in 0...6 ) {
			for( x in 0...128 )
				for( y in 0...128 )
					bmp.setPixel(x,y, (x + y) & 1 == 0 ? faceColors[i] : (faceColors[i]>>1)&0x7F7F7F);
			skyTexture.uploadPixels(bmp, 0, i);
		}
		skyTexture.mipMap = Linear;

		var sky = new h3d.prim.Sphere(30, 128, 128);
		sky.addNormals();
		var skyMesh = new h3d.scene.Mesh(sky, s3d);
		skyMesh.material.mainPass.culling = Front;
		skyMesh.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture));
		skyMesh.material.shadows = false;

		var sp = new h3d.prim.Sphere(0.5, 64, 64);
		sp.addNormals();
		var m = new h3d.scene.Mesh(sp, null, s3d);
		m.material.mainPass.enableLights = true;
		m.material.shadows = false;
		m.material.mainPass.addShader(new h3d.shader.CubeMap(skyTexture, true));

		var pt = new h3d.scene.fwd.PointLight(s3d);
		pt.x = 2;
		pt.y = 1;
		pt.z = 4;
		pt.enableSpecular = true;
		pt.params.set(0, 1, 0);

		cast(s3d.lightSystem,h3d.scene.fwd.LightSystem).ambientLight.set(0.1, 0.1, 0.1);

		new h3d.scene.CameraController(5, s3d).loadFromCamera();

	}

	override function update(dt:Float) {
		if( hxd.Key.isPressed("M".code) ) {
			skyTexture.mipMap = switch( skyTexture.mipMap ) {
			case None: Nearest;
			case Nearest: Linear;
			case Linear: None;
			}
		}
	}

	static function main() {
		new CubeTexture();
	}

}