import h3d.prim.Cube;
import h3d.prim.Cylinder;
import h3d.prim.Disc;
import h3d.prim.GeoSphere;
import h3d.prim.Grid;
import h3d.prim.Sphere;
import h3d.scene.CameraController;
import h3d.scene.Mesh;
import h3d.Vector;
import hxd.Key;

/**
 * Third person camera controller (top view) with arrow keys mapping
 */
class ThirdPersonCameraController extends CameraController {
	override function onEvent( e : hxd.Event ) {
		super.onEvent(e);

		// Third person camera arrow keys mapping
		if (e.keyCode == Key.UP) {
			var radian = Math.atan2((curPos.y - target.y), (curPos.x - target.x));
			pan(Math.sin(radian), Math.cos(radian));
		}
		if (e.keyCode == Key.LEFT) {
			var radian = Math.atan2((curPos.y - target.y), (curPos.x - target.x));
			radian = radian - Math.PI / 2.0;
			pan(Math.sin(radian), Math.cos(radian));
		}
		if (e.keyCode == Key.DOWN) {
			var radian = Math.atan2((curPos.y - target.y), (curPos.x - target.x));
			radian = radian + Math.PI;
			pan(Math.sin(radian), Math.cos(radian));
		}
		if (e.keyCode == Key.RIGHT) {
			var radian = Math.atan2((curPos.y - target.y), (curPos.x - target.x));
			radian = radian + Math.PI / 2.0;
			pan(Math.sin(radian), Math.cos(radian));
		}
	}
}

class Polygons extends hxd.App {

	var shadow : h3d.pass.DefaultShadowMap;
	var cameraCtrl : h3d.scene.CameraController;

	override function init() {

		// Grid
		var grid = new Grid(64, 64);
		grid.addNormals();
		grid.addUVs();
		var gridMesh = new Mesh(grid, s3d);
		gridMesh.material.color.setColor(0x999999);

		// Cube
		var cube = Cube.defaultUnitCube();
		var cubeMesh = new Mesh(cube, s3d);
		cubeMesh.setPosition(16, 32, 0.5);
		cubeMesh.material.color.setColor(0xFFAA15);

		// Cylinder
		var cylinder = new Cylinder(16, 0.5);
		cylinder.addNormals();
		cylinder.addUVs();
		var cylinderMesh = new Mesh(cylinder, s3d);
		cylinderMesh.setPosition(24, 32, 0);
		cylinderMesh.material.color.setColor(0x6FFFB0);

		// Disc on top of cylinder
		var discTopCylinder = new Disc(0.5, 16);
		discTopCylinder.addNormals();
		discTopCylinder.addUVs();
		var discTopCylinderMesh = new Mesh(discTopCylinder, s3d);
		discTopCylinderMesh.setPosition(24, 32, 1);
		discTopCylinderMesh.material.color.setColor(0x6FFFB0);

		// Disc
		var disc = new Disc(0.5, 16);
		disc.addNormals();
		disc.addUVs();
		var discMesh = new Mesh(disc, s3d);
		discMesh.setPosition(32, 32, 0.1);
		discMesh.material.color.setColor(0x3D138D);

		// Geosphere
		var geosphere = new GeoSphere();
		geosphere.addNormals();
		geosphere.addUVs();
		var geosphereMesh = new Mesh(geosphere, s3d);
		geosphereMesh.setPosition(40, 32, 0.6);
		geosphereMesh.material.color.setColor(0x00739D);

		// Sphere
		var sphere = new Sphere(0.5, 16, 16);
		sphere.addNormals();
		sphere.addUVs();
		var sphereMesh = new Mesh(sphere, s3d);
		sphereMesh.setPosition(48, 32, 0.5);
		sphereMesh.material.color.setColor(0xFF4040);

		// Lights
		var light = new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		s3d.lightSystem.ambientLight.setColor(0x909090);

		shadow = s3d.renderer.getPass(h3d.pass.DefaultShadowMap);
		shadow.size = 2048;
		shadow.power = 200;
		shadow.blur.radius= 0;
		shadow.bias *= 0.1;
		shadow.color.set(0.7, 0.7, 0.7);

		s3d.camera.target.set(32, 32, 0);
		s3d.camera.pos.set(80, 80, 48);
		cameraCtrl = new ThirdPersonCameraController(s3d);
		cameraCtrl.loadFromCamera();
	}

	static function main() {
		new Polygons();
	}

}