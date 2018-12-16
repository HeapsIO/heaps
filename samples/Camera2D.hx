import h2d.Object;
import h2d.Camera;
import hxd.Timer;
import h3d.mat.Texture;
import h2d.Tile;

class Camera2D extends SampleApp {

	var followObject : h2d.Graphics;
	var camera : Camera;

	override private function init()
	{
		super.init();

		// Initialize camera.
		camera = new Camera(s2d);

		// Backdrop to show the camera frame.
		new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, s2d.width, s2d.height, 0.2), camera);

		// Interactive inside camera
		var inter = new h2d.Interactive(100, 40, camera);
		inter.backgroundColor = 0xff0000ff;
		inter.x = s2d.width * .5 - 50;
		inter.y = s2d.height * .5 - 20;
		var interText = new h2d.Text(getFont(), inter);
		interText.textAlign = Center;
		interText.maxWidth = 100;
		interText.text = "In-camera Interactive";

		var camX = camera.x;
		var camY = camera.y;
		addText("Camera");
		addSlider("Anchor X", function() { return camera.anchorX; }, function(v) { camera.anchorX = v; }, 0, 1);
		addSlider("Anchor Y", function() { return camera.anchorY; }, function(v) { camera.anchorY = v; }, 0, 1);
		addSlider("View X", function() { return camera.viewX; }, function(v) { camera.viewX = v; camX = camera.x; }, -s2d.width, s2d.width);
		addSlider("View Y", function() { return camera.viewY; }, function(v) { camera.viewY = v; camY = camera.y; }, -s2d.height, s2d.height);
		addSlider("X", function() { return camera.x; }, function(v) { camera.x = v; camX = v; }, -s2d.width, s2d.width);
		addSlider("Y", function() { return camera.y; }, function(v) { camera.y = v; camY = v; }, -s2d.height, s2d.height);
		// addSlider("Rotation", function() { return hxd.Math.radToDeg(camera.rotation); }, function(v) { camera.rotation = hxd.Math.degToRad(v); }, 0, 360);
		addSlider("Scale X", function() { return camera.scaleX; }, function(v) { camera.scaleX = v; }, 0, 5);
		addSlider("Scale Y", function() { return camera.scaleY; }, function(v) { camera.scaleY = v; }, 0, 5);

	}

	static function main() {
		hxd.Res.initEmbed();
		new Camera2D();
	}


}