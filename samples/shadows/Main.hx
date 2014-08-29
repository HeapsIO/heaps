import hxd.Math;

class Main extends hxd.App {

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

		var sphere = new h3d.prim.Sphere(32,24);
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
		s3d.camera.zNear = 2;
		s3d.camera.zFar = 15;

		var ls = s3d.mainPass.getLightSystem();
		ls.ambientLight.set(0.5, 0.5, 0.5);
		ls.perPixelLighting = true;
		dir = new h3d.scene.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);

		shadow = cast(s3d.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.lightDirection = dir.direction;
		shadow.size = 512;
		shadow.blur.quality = 4;
	}

	override function update( dt : Float ) {
		s3d.camera.pos.set(6, 6, 3);
		time += dt * 0.01;
		dir.direction.set(Math.cos(time), Math.sin(time) * 2, -1);
	}

	public static var inst : Main;
	static function main() {
		inst = new Main();
	}

}
