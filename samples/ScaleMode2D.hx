import hxd.Key;
import h2d.Scene;

class ScaleMode2D extends SampleApp {

	override function init()
	{

		var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x333333), s2d);
		var minBg = new h2d.Bitmap(h2d.Tile.fromColor(0x222222), s2d);

		super.init();

		var mode:Int = 0;
		// Width and height used in Stretch, LetterBox, Fixed and AutoZoom
		var width:Int = 320;
		var height:Int = 240;
		// Zoom used in Fixed and Zoom
		var zoom:Float = 1;
		// Integer Scale used in LetterBox and AutoZoom
		var intScale:Bool = false;
		// Vertical and Horizontal Align used in LetterBox and Fixed.
		var halign:ScaleModeAlign = Center;
		var valign:ScaleModeAlign = Center;

		var sceneInfo:h2d.Text = null;

		function setMode()
		{
			switch ( mode ) {
				case 0:
					s2d.scaleMode = Resize;
				case 1:
					s2d.scaleMode = Stretch(width, height);
				case 2:
					s2d.scaleMode = LetterBox(width, height, intScale, halign, valign);
				case 3:
					s2d.scaleMode = Fixed(width, height, zoom, valign, halign);
				case 4:
					s2d.scaleMode = Zoom(zoom);
				case 5:
					s2d.scaleMode = AutoZoom(width, height, intScale);
			}
			minBg.scaleX = width;
			minBg.scaleY = height;
			bg.scaleX = s2d.width;
			bg.scaleY = s2d.height;
			sceneInfo.text = "Scene size: " + s2d.width + "x" + s2d.height;
		}

		addText("Press R to set ScaleMode to Resize");
		addChoice("ScaleMode", ScaleMode.getConstructors(), function(idx) { mode = idx; }, 0);
		addSlider("width", function() { return width; }, function(v) { width = Std.int(v); }, 0, 800);
		addSlider("height", function() { return height; }, function(v) { height = Std.int(v); }, 0, 600);
		addSlider("zoom", function() { return zoom; }, function(v) { zoom = v; }, 0.01, 5);
		addCheck("integerScale", function() { return intScale; }, function(v) { intScale = v; });
		addChoice("HAlign", ["Left", "Center", "Right"], function(v) { halign = [Left, Center, Right][v]; }, 1 );
		addChoice("VAlign", ["Top", "Center", "Bottom"], function(v) { valign = [Top, Center, Bottom][v]; }, 1 );
		addButton("Apply", setMode);
		sceneInfo = addText("");
		addText("Light-grey: Actual Scene width and height");
		addText("Dark-grey: Parameter-specified width and height");

		setMode();
	}

	override function update(dt:Float)
	{
		if (Key.isReleased(Key.R)) s2d.scaleMode = Resize;
	}

	static function main() {
		hxd.Res.initEmbed();
		new ScaleMode2D();
	}

}