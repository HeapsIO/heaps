import h3d.prim.Grid;
import h3d.prim.GeoSphere;
import h3d.prim.Disc;
import h3d.prim.Sphere;
import h3d.prim.Cylinder;
import h3d.prim.Cube;
import h3d.Vector;
import hxd.Key;
import h3d.scene.Mesh;

class Polygons extends hxd.App {

	var world : h3d.scene.World;
	var shadow : h3d.pass.DefaultShadowMap;
	var cameraCtrl : h3d.scene.CameraController;

	override function init() {
		world = new h3d.scene.World(64, 128, s3d);

		// Grid
		var grid = new Grid(64, 64);
		grid.addNormals();
		grid.addUVs();
		var gridMesh = new Mesh(grid, s3d);
		gridMesh.material.color.setColor(0x999999);
		world.addChild(gridMesh);

		// Cube
		var cube = Cube.defaultUnitCube();
		var cubeMesh = new Mesh(cube, s3d);
		cubeMesh.setPosition(16, 32, 0.5);
		cubeMesh.material.color.setColor(0xFFAA15);
		world.addChild(cubeMesh);

		// Cylinder
		var cylinder = new Cylinder(16, 0.5);
		cylinder.addNormals();
		cylinder.addUVs();
		var cylinderMesh = new Mesh(cylinder, s3d);
		cylinderMesh.setPosition(24, 32, 0);
		cylinderMesh.material.color.setColor(0x6FFFB0);
		world.addChild(cylinderMesh);

		// Disc on top of cylinder
		var discTopCylinder = new Disc(0.5, 16);
		discTopCylinder.addNormals();
		discTopCylinder.addUVs();
		var discTopCylinderMesh = new Mesh(discTopCylinder, s3d);
		discTopCylinderMesh.setPosition(24, 32, 1);
		discTopCylinderMesh.material.color.setColor(0x6FFFB0);
		world.addChild(discTopCylinderMesh);

		// Disc
		var disc = new Disc(0.5, 16);
		disc.addNormals();
		disc.addUVs();
		var discMesh = new Mesh(disc, s3d);
		discMesh.setPosition(32, 32, 0.1);
		discMesh.material.color.setColor(0x3D138D);
		world.addChild(discMesh);

		// Geosphere
		var geosphere = new GeoSphere();
		geosphere.addNormals();
		geosphere.addUVs();
		var geosphereMesh = new Mesh(geosphere, s3d);
		geosphereMesh.setPosition(40, 32, 0.6);
		geosphereMesh.material.color.setColor(0x00739D);
		world.addChild(geosphereMesh);

		// Sphere
		var sphere = new Sphere(0.5, 16, 16);
		sphere.addNormals();
		sphere.addUVs();
		var sphereMesh = new Mesh(sphere, s3d);
		sphereMesh.setPosition(48, 32, 0.5);
		sphereMesh.material.color.setColor(0xFF4040);
		world.addChild(sphereMesh);

		world.done();

		// Lights
		var light = new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		s3d.lightSystem.ambientLight.setColor(0x909090);

		s3d.camera.target.set(32, 32, 0);
		s3d.camera.pos.set(80, 80, 48);

		shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.size = 2048;
		shadow.power = 200;
		shadow.blur.radius= 0;
		shadow.bias *= 0.1;
		shadow.color.set(0.7, 0.7, 0.7);

		#if castle
		new hxd.inspect.Inspector(s3d);
		#end

		s3d.camera.zNear = 1;
		s3d.camera.zFar = 100;
		cameraCtrl = new h3d.scene.CameraController(s3d);
		cameraCtrl.loadFromCamera();

		hxd.Window.getInstance().addEventTarget(onEvent);
	}

	function onEvent(event : hxd.Event) {
		// Third person camera
		if (Key.isDown(Key.UP)) {
			var r = Math.atan2((s3d.camera.target.y - s3d.camera.pos.y), (s3d.camera.target.x - s3d.camera.pos.x));
			s3d.camera.pos.set(s3d.camera.pos.x + Math.cos(r), s3d.camera.pos.y + Math.sin(r), s3d.camera.pos.z);
			s3d.camera.target.set(s3d.camera.target.x + Math.cos(r), s3d.camera.target.y + Math.sin(r), s3d.camera.target.z);
			cameraCtrl.loadFromCamera();
		}
		if (Key.isDown(Key.LEFT)) {
			var r = Math.atan2((s3d.camera.target.y - s3d.camera.pos.y), (s3d.camera.target.x - s3d.camera.pos.x));
			r = r - Math.PI / 2;
			s3d.camera.pos.set(s3d.camera.pos.x + Math.cos(r), s3d.camera.pos.y + Math.sin(r), s3d.camera.pos.z);
			s3d.camera.target.set(s3d.camera.target.x + Math.cos(r), s3d.camera.target.y + Math.sin(r), s3d.camera.target.z);
			cameraCtrl.loadFromCamera();
		}
		if (Key.isDown(Key.DOWN)) {
			var r = Math.atan2((s3d.camera.target.y - s3d.camera.pos.y), (s3d.camera.target.x - s3d.camera.pos.x));
			r = r + Math.PI;
			s3d.camera.pos.set(s3d.camera.pos.x + Math.cos(r), s3d.camera.pos.y + Math.sin(r), s3d.camera.pos.z);
			s3d.camera.target.set(s3d.camera.target.x + Math.cos(r), s3d.camera.target.y + Math.sin(r), s3d.camera.target.z);
			cameraCtrl.loadFromCamera();
		}
		if (Key.isDown(Key.RIGHT)) {
			var r = Math.atan2((s3d.camera.target.y - s3d.camera.pos.y), (s3d.camera.target.x - s3d.camera.pos.x));
			r = r + Math.PI / 2;
			s3d.camera.pos.set(s3d.camera.pos.x + Math.cos(r), s3d.camera.pos.y + Math.sin(r), s3d.camera.pos.z);
			s3d.camera.target.set(s3d.camera.target.x + Math.cos(r), s3d.camera.target.y + Math.sin(r), s3d.camera.target.z);
			cameraCtrl.loadFromCamera();
		}
	}

	static function main() {
		new Polygons();
	}

}