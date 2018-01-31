import hxd.Math;

class Shadows extends hxd.App {

	var time : Float = 0.;
	var spheres : Array<h3d.scene.Object>;
	var dir : h3d.scene.DirLight;
	var shadow : h3d.pass.ShadowMap;

	override function init() {

		var floor = new h3d.prim.Cube(10, 10, 0.1);
		floor.addNormals();
		floor.translate( -5, -5, 0);
		var m = new h3d.scene.Mesh(floor, s3d);
		m.material.mainPass.enableLights = true;
		m.material.shadows = true;

		var sphere = new h3d.prim.Sphere(1, 32, 24);
		sphere.addNormals();
		spheres  = [];
		for( i in 0...15 ) {
			var p = new h3d.scene.Mesh(sphere, s3d);
			p.scale(0.2 + Math.random());
			p.x = Math.srand(3);
			p.y = Math.srand(3);
			p.z = Math.random() * p.scaleX;
			p.material.mainPass.enableLights = true;
			p.material.shadows = true;
			p.material.color.setColor(Std.random(0x1000000));
		}
		s3d.camera.zNear = 6;
		s3d.camera.zFar = 30;
		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);

		dir = new h3d.scene.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);
		dir.enableSpecular = true;

		shadow = s3d.renderer.getPass(h3d.pass.ShadowMap);
		shadow.blur.passes = 3;

		s3d.camera.pos.set(12, 12, 6);
		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	override function update( dt : Float ) {
		time += dt * 0.01;
		dir.direction.set(Math.cos(time), Math.sin(time) * 2, -1);
	}

	static function main() {
		new Shadows();
	}

}
