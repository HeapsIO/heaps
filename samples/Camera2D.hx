import h2d.Camera;
import hxd.Timer;
import h3d.mat.Texture;
import h2d.Tile;

class Camera2D extends SampleApp {

	var camera : Camera;

	override private function init()
	{
		super.init();
		camera = new Camera(s2d);

		var font = hxd.res.DefaultFont.get();
		var offsetY : Float = 10;
		
		inline function label( text : String ) {
			var label = new h2d.Text(font, s2d);
			label.text = text;
			label.x = 10;
			label.y = offsetY;
			offsetY += label.textHeight + 10;
		}

		// label("Scrolls with camera: logo.followCamera = false");
		var logo = hxd.Res.hxlogo.toTile();
		var bitmap = new h2d.Bitmap(logo, camera);
		bitmap.y = 100;
		offsetY += logo.height + 30;

		addSlider("Scroll X", function() { return bitmap.camScrollX; }, function(v) { bitmap.camScrollX = v; }, 0, 2);
		addSlider("Scroll Y", function() { return bitmap.camScrollY; }, function(v) { bitmap.camScrollY = v; }, 0, 2);
		addSlider("Camera X", function() { return camera.x; }, function(v) { camera.x = v; }, -s2d.width, s2d.width);
		addSlider("Camera Y", function() { return camera.y; }, function(v) { camera.y = v; }, -s2d.height, s2d.height);
		addSlider("Camera Ro", function() { return hxd.Math.radToDeg(camera.rotation); }, function(v) { camera.rotation = hxd.Math.degToRad(v); }, 0, 360);
		addSlider("Camera SX", function() { return camera.scaleX; }, function(v) { camera.scaleX = v; }, 0, 5);
		addSlider("Camera SY", function() { return camera.scaleY; }, function(v) { camera.scaleY = v; }, 0, 5);

		// label("Follows with camera: logo.followCamera = true");
		// bitmap = new h2d.Bitmap(logo, camera);
		// bitmap.camScrollX = bitmap.camScrollY = 0;
		// bitmap.y = offsetY;
		// offsetY += logo.height + 10;
	}

	override private function update(dt:Float)
	{
		// camera.x = Math.cos(Timer.lastTimeStamp) * s2d.width * .2;
		// camera.centerY = Math.sin(Timer.lastTimeStamp) * 512;
		
		super.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Camera2D();
	}


}