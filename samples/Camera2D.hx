import h3d.Engine;
import h2d.TextInput;
import h2d.Camera;
import h2d.Graphics;
import h2d.TileGroup;
import hxd.Key;
import hxd.Res;

//PARAM=-D resourcesPath=../../tiled_res
class Camera2D extends SampleApp {

	var camera : Camera;

	var followCamera : Camera;
	var followPoint : Graphics;

	var sliderAnchorX : h2d.Slider;
	var sliderCamAnchorX : h2d.Slider;
	var sliderCamAnchorY : h2d.Slider;
	var sliderCamX : h2d.Slider;
	var sliderCamY : h2d.Slider;
	var sliderCamScaleX : h2d.Slider;
	var sliderCamScaleY : h2d.Slider;

	var cameraPositionMarker : h2d.Graphics;

	var reportCameraParameterChangedAfterSync : Bool = false;

	override function onResize() {
		super.onResize();

		// Change slider min max values according to screen size
		sliderCamX.minValue = -s2d.width; sliderCamX.maxValue = s2d.width;
		sliderCamY.minValue = -s2d.height; sliderCamY.maxValue = s2d.height;

		onCameraParameterChanged();
		reportCameraParameterChangedAfterSync=true;
	}

	private function setSliderAndTextInputValue( slider : h2d.Slider, value : Float ) {
		slider.value = value;
		var tf : h2d.TextInput = hxd.impl.Api.downcast(slider.parent.getChildAt(2),h2d.TextInput);
		if(tf!=null) tf.text = "" + hxd.Math.fmt(value);
	}

	private function onCameraParameterChanged() {
		updateCamSliderValues();

		cameraPositionMarker.x = camera.x;
		cameraPositionMarker.y = camera.y;
	}

	private function updateCamSliderValues() {

		setSliderAndTextInputValue(sliderCamAnchorX, camera.anchorX);
		setSliderAndTextInputValue(sliderCamAnchorY, camera.anchorY);

		setSliderAndTextInputValue(sliderCamScaleX, camera.scaleX);
		setSliderAndTextInputValue(sliderCamScaleY, camera.scaleY);

		setSliderAndTextInputValue(sliderCamX, camera.x);
		setSliderAndTextInputValue(sliderCamY, camera.y);

	}

	override private function init() {
		super.init();

		// Second camera for sample controls
		var uiCamera = new Camera();
		// layerVisible allows to filter out layers that camera should not render.
		uiCamera.layerVisible = (idx) -> idx == 2;
		s2d.add(fui, 2);
		// Add UI camera to scene. Note that order of cameras in array matters, as they are rendered in-order.
		s2d.addCamera(uiCamera);
		// Only one camera can handle user input events.
		// When assigning newly-created camera as interactiveCamera - adding it to Scene can be omitted, as it will be added automatically.
		s2d.interactiveCamera = uiCamera;

		// See Tiled sample
		var followX = s2d.width * .5;
		var followY = s2d.height * .5;
		var tileSize = 16;
		var tmx = Res.tileMap.toMap();

		var tset = Res.tiles.toTile();
		var tiles = tset.gridFlatten(tileSize, 0, 0);
		for ( l in tmx.layers ) {
			var group : TileGroup = new TileGroup(tset);
			// Props layer won't be visible on main camera, but will be visible in the follower camera.
			s2d.add(group, l.name == "Props" ? 1 : 0);
			group.x = followX - tmx.width * (tileSize / 2);
			group.y = followY - tmx.height * (tileSize / 2);
			var y = 0, x = 0;
			for (gid in l.data) {
				if (gid != 0) group.add(x * tileSize, y * tileSize, tiles[gid-1]);
				if (++x == tmx.width) {
					x = 0;
					y++;
				}
			}
		}

		addText("User arrow keys to move the green arrow");
		followPoint = new Graphics(s2d);
		followPoint.beginFill(0xff00);
		followPoint.moveTo(0, -5);
		followPoint.lineTo(5, 5);
		followPoint.lineTo(-5, 5);
		followPoint.setPosition(followX, followY);

		// Anchor allows to adjust the position of camera target relative to it's top-left corner in scene viewport ratio.
		// 0.5 would ensure that whatever position camera points at would at the center of it's viewport.
		// Providing Scene instance to camera constructor automatically adds it to the Scene camera list.
		followCamera = new Camera(s2d);
		// Set viewport to take up bottom-left quarter of the screen and clip out contents outside of it.
		followCamera.setAnchor(0.5, 0.5);
		followCamera.setViewport(s2d.width * .5, s2d.height * .5, s2d.width * .5, s2d.height * .5);
		followCamera.setScale(2, 2);
		followCamera.clipViewport = true;
		followCamera.layerVisible = (idx) -> idx != 2; // skip UI layer
		followCamera.follow = followPoint;
		followCamera.followRotation = true;

		// Scene.camera proeprty provides an alias to `Scene.cameras[0]`.
		camera = s2d.camera;
		camera.setAnchor(0.5, 0.5);
		camera.setPosition(s2d.width * .5, s2d.height * .5);
		camera.layerVisible = (idx) -> idx == 0;

		// Marker for primary camera position
		cameraPositionMarker = new h2d.Graphics(s2d);
		cameraPositionMarker.x= camera.x;
		cameraPositionMarker.y= camera.y;
		cameraPositionMarker.beginFill(0xff0000,0.5);
		cameraPositionMarker.drawRect(-10, -1, 20, 2);
		cameraPositionMarker.drawRect(-1, -10, 2, 20);
		cameraPositionMarker.endFill();

		addText("Camera controls");
		sliderCamAnchorX=addSlider("Anchor X", function() { return camera.anchorX; }, function(v) { camera.anchorX = v; onCameraParameterChanged();}, 0, 1);
		sliderCamAnchorY=addSlider("Anchor Y", function() { return camera.anchorY; }, function(v) { camera.anchorY = v; onCameraParameterChanged();}, 0, 1);
		sliderCamX=addSlider("X", function() { return camera.x; }, function(v) { camera.x = v; onCameraParameterChanged();}, -s2d.width, s2d.width);
		sliderCamY=addSlider("Y", function() { return camera.y; }, function(v) { camera.y = v; onCameraParameterChanged();}, -s2d.height, s2d.height);
		// Scale and rotation happens around anchored position, so in case of anchor [0.5, 0.5] it would scale and rotate around center of the camera viewport.
		addSlider("Rotation", function() { return hxd.Math.radToDeg(camera.rotation); }, function(v) { camera.rotation = hxd.Math.degToRad(v); onCameraParameterChanged(); }, 0, 360);
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
		if (Key.isDown(Key.SHIFT)) dt *= 3;
		if (Key.isDown(Key.LEFT)) followPoint.rotation -= dt;
		if (Key.isDown(Key.RIGHT)) followPoint.rotation += dt;
		var forward = followPoint.rotation - Math.PI * .5;
		if (Key.isDown(Key.UP)) {
			followPoint.x += Math.cos(forward) * 60 * dt;
			followPoint.y += Math.sin(forward) * 60 * dt;
		}
		if (Key.isDown(Key.DOWN)) {
			followPoint.x -= Math.cos(forward) * 60 * dt;
			followPoint.y -= Math.sin(forward) * 60 * dt;
		}
		if (Key.isReleased(Key.SPACE)) {
			followPoint.setPosition(s2d.width * .5, s2d.height * .5);
			followPoint.rotation = 0;
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Camera2D();
	}

}