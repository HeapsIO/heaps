import hxd.Math;

class Shadows extends SampleApp {

	var time : Float = 0.;
	var spheres : Array<h3d.scene.Object>;
	var dir : h3d.scene.fwd.DirLight;
	var shadow : h3d.pass.DefaultShadowMap;

	override function init() {
		super.init();

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
		cast(s3d.lightSystem,h3d.scene.fwd.LightSystem).ambientLight.set(0.5, 0.5, 0.5);

		dir = new h3d.scene.fwd.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);
		dir.enableSpecular = true;

		shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		addSlider("Power", function() return shadow.power, function(p) shadow.power = p, 0, 100);
		addSlider("Radius", function() return shadow.blur.radius, function(r) shadow.blur.radius = r, 0, 20);
		addSlider("Quality", function() return shadow.blur.quality, function(r) shadow.blur.quality = r);
		addSlider("Bias", function() return shadow.bias, function(r) shadow.bias = r, 0, 0.1);

		s3d.camera.pos.set(12, 12, 6);
		new h3d.scene.CameraController(s3d).loadFromCamera();
	}

	override function update( dt : Float ) {
		time += dt * 0.6;
		dir.setDirection(new h3d.Vector(Math.cos(time), Math.sin(time) * 2, -1));
	}

	static function main() {
		new Shadows();
	}

}
