import hxd.Timer;
import h3d.mat.Texture;
import h2d.Tile;

class Camera2D extends SampleApp {

	override private function init()
	{
		super.init();
		var base = Tile.fromTexture(Texture.genNoise(1024));
		new h2d.Bitmap(base, s2d).setPosition(-1024, -1024);
		new h2d.Bitmap(base, s2d).setPosition(0, -1024);
		new h2d.Bitmap(base, s2d).setPosition(-1024, 0);
		new h2d.Bitmap(base, s2d).setPosition(0, 0);
		var noFollow = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		noFollow.followCamera = false;
		noFollow.setPosition(10, 10);
		noFollow.text = "Will not follow camera";
		noFollow.textColor = 0xffff0000;
	}

	override private function update(dt:Float)
	{
		s2d.camera.centerX = Math.cos(Timer.lastTimeStamp) * 512;
		s2d.camera.centerY = Math.sin(Timer.lastTimeStamp) * 512;
		
		super.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Camera2D();
	}


}