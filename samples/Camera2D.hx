import h3d.Engine;
import h2d.TextInput;
import h2d.Interactive;
import h2d.Bitmap;
import h2d.Object;
import h2d.Camera;
import hxd.Timer;
import h3d.mat.Texture;
import h2d.Tile;


class Camera2D extends SampleApp {

	var camera : Camera;

	var bg : Bitmap;
	var inter : Interactive;

	var sliderAnchorX : h2d.Slider;
	var sliderCamAnchorX : h2d.Slider;
	var sliderCamAnchorY : h2d.Slider;
	var sliderCamViewX : h2d.Slider;
	var sliderCamViewY : h2d.Slider;
	var sliderCamX : h2d.Slider;
	var sliderCamY : h2d.Slider;
	var sliderCamScaleX : h2d.Slider;
	var sliderCamScaleY : h2d.Slider;	

	var anchorMarkerScreenSpace : h2d.Graphics;
	var anchorMarkerSceneSpaceA : h2d.Bitmap;
	var anchorMarkerSceneSpaceB : h2d.Bitmap;

	var reportCameraParameterChangedAfterSync : Bool = false;

	static inline var scaleContentRelativeToScene : Bool = false;

	override function onResize()  {
		super.onResize();

		//change slide min max values according to screen size
		sliderCamViewX.minValue = -s2d.width*2; sliderCamViewX.maxValue = s2d.width*2;
		sliderCamViewY.minValue = -s2d.height*2; sliderCamViewY.maxValue = s2d.height*2;
		
		sliderCamX.minValue = -s2d.width; sliderCamX.maxValue = s2d.width; 
		sliderCamY.minValue = -s2d.height; sliderCamY.maxValue = s2d.height; 

		//scale content relative to scene
		if(scaleContentRelativeToScene)
		{
			bg.tile.scaleToSize(s2d.width,s2d.height);

			inter.x = s2d.width * .5 - 50;
			inter.y = s2d.height * .5 - 80;
		}

		onCameraParameterChanged();
		reportCameraParameterChangedAfterSync=true;
	}

	private function setSliderAndTextInputValue(slider : h2d.Slider, value : Float)
	{
		slider.value = value; 
		var  tf : h2d.TextInput = hxd.impl.Api.downcast(slider.parent.getChildAt(2),h2d.TextInput);		
		if(tf!=null) tf.text = "" + hxd.Math.fmt(value);	
	}

	private function onCameraParameterChanged()
	{
		updateCamSliderValues();

		anchorMarkerScreenSpace.x=camera.anchorX*s2d.width;
		anchorMarkerScreenSpace.y=camera.anchorY*s2d.height;

		anchorMarkerSceneSpaceA.x=camera.viewX/camera.scaleX-20;
		anchorMarkerSceneSpaceA.y=camera.viewY/camera.scaleY-2;

		anchorMarkerSceneSpaceB.x=camera.viewX/camera.scaleX-2;
		anchorMarkerSceneSpaceB.y=camera.viewY/camera.scaleY-20;
	}

	private function updateCamSliderValues() {

		setSliderAndTextInputValue(sliderCamAnchorX, camera.anchorX);
		setSliderAndTextInputValue(sliderCamAnchorY, camera.anchorY);

		setSliderAndTextInputValue(sliderCamViewX, camera.viewX);
		setSliderAndTextInputValue(sliderCamViewY, camera.viewY);

		setSliderAndTextInputValue(sliderCamScaleX, camera.scaleX);
		setSliderAndTextInputValue(sliderCamScaleY, camera.scaleY);

		setSliderAndTextInputValue(sliderCamX, camera.x);
		setSliderAndTextInputValue(sliderCamY, camera.y);

	}

	override private function init()
	{
		super.init();

		// Initialize camera.
		camera = new Camera(s2d);

		// Backdrop to show the camera frame.
		bg = new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, s2d.width, s2d.height, 0.2), camera);

		// Interactive inside camera
		inter = new h2d.Interactive(100, 40, camera);
		inter.backgroundColor = 0xff0000ff;
		inter.x = s2d.width * .5 - 50;
		inter.y = s2d.height * .5 - 80;
		var interText = new h2d.Text(getFont(), inter);
		interText.textAlign = Center;
		interText.maxWidth = 100;
		interText.text = "In-camera Interactive";

		//anchor marker in screen space
		anchorMarkerScreenSpace = new h2d.Graphics(s2d);
		anchorMarkerScreenSpace.x=camera.anchorX*s2d.width;
		anchorMarkerScreenSpace.y=camera.anchorY*s2d.height;
		anchorMarkerScreenSpace.beginFill(0xff0000,0.5);
		anchorMarkerScreenSpace.drawRect(-10, -1, 20, 2);
		anchorMarkerScreenSpace.drawRect(-1, -10, 2, 20);
		anchorMarkerScreenSpace.endFill();

		//anchor marker in screen space
		anchorMarkerSceneSpaceA = new h2d.Bitmap(h2d.Tile.fromColor(0xfffffff, 40,4, 0.5), camera);
		anchorMarkerSceneSpaceA.x=camera.viewX/camera.scaleX-20;
		anchorMarkerSceneSpaceA.y=camera.viewY/camera.scaleY-2;
		anchorMarkerSceneSpaceB = new h2d.Bitmap(h2d.Tile.fromColor(0xfffffff, 4,40, 0.5), camera);
		anchorMarkerSceneSpaceB.x=camera.viewX/camera.scaleX-2;
		anchorMarkerSceneSpaceB.y=camera.viewY/camera.scaleY-20;

		addText("Camera");
		sliderCamAnchorX=addSlider("Anchor X", function() { return camera.anchorX; }, function(v) { camera.anchorX = v; onCameraParameterChanged();}, 0, 1);
		sliderCamAnchorY=addSlider("Anchor Y", function() { return camera.anchorY; }, function(v) { camera.anchorY = v; onCameraParameterChanged();}, 0, 1);
		sliderCamViewX=addSlider("View X", function() { return camera.viewX; }, function(v) { camera.viewX = v; onCameraParameterChanged();}, -s2d.width*2, s2d.width*2);
		sliderCamViewY=addSlider("View Y", function() { return camera.viewY; }, function(v) { camera.viewY = v; onCameraParameterChanged();}, -s2d.height*2, s2d.height*2);
		sliderCamX=addSlider("X", function() { return camera.x; }, function(v) { camera.x = v; onCameraParameterChanged();}, -s2d.width, s2d.width);
		sliderCamY=addSlider("Y", function() { return camera.y; }, function(v) { camera.y = v; onCameraParameterChanged();}, -s2d.height, s2d.height);
		// addSlider("Rotation", function() { return hxd.Math.radToDeg(camera.rotation); }, function(v) { camera.rotation = hxd.Math.degToRad(v); onCameraParameterChanged(); }, 0, 360);
		sliderCamScaleX=addSlider("Scale X", function() { return camera.scaleX; }, function(v) { camera.scaleX = v; onCameraParameterChanged();}, 0, 5);
		sliderCamScaleY=addSlider("Scale Y", function() { return camera.scaleY; }, function(v) { camera.scaleY = v; onCameraParameterChanged();}, 0, 5);

	}

	override function render(e:Engine) {
		super.render(e);
		if(reportCameraParameterChangedAfterSync)
		{
			reportCameraParameterChangedAfterSync=false;
			onCameraParameterChanged();
		}
	}

	override function update(dt:Float) {
		super.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Camera2D();
	}

}