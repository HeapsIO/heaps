typedef K = flash.ui.Keyboard;

class Axis implements h3d.IDrawable {

	public function new() {
	}
	
	public function render( engine : h3d.Engine ) {
		engine.line(0, 0, 0, 50, 0, 0, 0xFFFF0000);
		engine.line(0, 0, 0, 0, 50, 0, 0xFF00FF00);
		engine.line(0, 0, 0, 0, 0, 50, 0xFF0000FF);
	}
	
}

class Viewer {

	var engine : h3d.Engine;
	var scene : h3d.scene.Scene;

	var time : Float;
	var anim : h3d.prim.Animation;
	var tf : flash.text.TextField;
	
	var pause : Bool;
	var view : Int;
	
	var curFbx : h3d.fbx.Library;
	var curFbxFile : String;
	var curData : String;
	
	var rightHand : Bool;
	var applySkin : Bool;
	var showBones : Bool;
	
	function new() {
		time = 0;
		view = 4;
		rightHand = false;
		applySkin = true;
		showBones = false;
		tf = new flash.text.TextField();
		tf.x = tf.y = 5;
		tf.textColor = 0xFFFFFF;
		tf.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		flash.Lib.current.addChild(tf);
		engine = new h3d.Engine();
		engine.backgroundColor = 0xFF808080;
		engine.onReady = onReady;
		engine.init();
	}
	
	function onReady() {
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, function (_) onUpdate());
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, function(k:flash.events.KeyboardEvent ) {
			var reload = false;
			var c = k.keyCode;
			if( c == K.NUMPAD_ADD )
				view++;
			else if( c == K.NUMPAD_SUBTRACT )
				view--;
			else if( c == K.SPACE )
				pause = !pause;
			else if( c == K.F1 )
				askLoad();
			else if( c == K.S && k.ctrlKey ) {
				if( curFbx == null ) return;
				var data = FbxTree.toString(curFbx.getRoot());
				var f = new flash.net.FileReference();
				f.save(data, curFbxFile.substr(0, -4) + "_tree.txt");
			} else if( c == K.R ) {
				rightHand = !rightHand;
				reload = true;
			} else if( c == K.S ) {
				applySkin = !applySkin;
				reload = true;
			} else if( c == K.K ) {
				showBones = !showBones;
				reload = true;
			}
			if( reload && curData != null )
				loadData(curData);
		});
		scene = new h3d.scene.Scene();
		scene.addPass(new Axis());
		askLoad();
	}
	
	function textureLoader( textureName : String ) {
		var t = engine.mem.allocTexture(1024, 1024);
		var bmp = new flash.display.BitmapData(1024, 1024, true, 0xFFFF0000);
		var mat = new h3d.mat.MeshMaterial(t);
		t.upload(bmp);
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
			mat.culling = None;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var c = flash.Lib.as(loader.content, flash.display.Bitmap).bitmapData;
			bmp.fillRect(bmp.rect, 0);
			bmp.copyPixels(c, c.rect, new flash.geom.Point(0, 0), c, new flash.geom.Point(0, 0), true);
			mat.uvScale = new h3d.Vector(c.width / bmp.width, c.height / bmp.height);
			t.upload(bmp);
			mat.culling = None;
		});
		loader.load(new flash.net.URLRequest(textureName));
		mat.culling = Both;
		mat.killAlpha = true;
		mat.blend(SrcAlpha, OneMinusSrcAlpha);
		return mat;
	}
	
	function askLoad() {
		var f = new flash.net.FileReference();
		f.addEventListener(flash.events.Event.COMPLETE, function(_) {
			curFbxFile = f.name;
			loadData(f.data.readUTFBytes(f.data.length));
		});
		f.addEventListener(flash.events.Event.SELECT, function(_) f.load());
		f.browse([new flash.net.FileFilter("FBX File", "*.fbx")]);
	}
	
	function loadData( data : String ) {
		curFbx = new h3d.fbx.Library();
		curData = data;
		var fbx = h3d.fbx.Parser.parse(data);
		curFbx.load(fbx);
		if( !rightHand )
			curFbx.leftHandConvert();
		var time = scene == null ? 0 : (scene.currentAnimation == null ? 0 : scene.currentAnimation.time);
		scene = curFbx.makeScene(textureLoader, 3);
		if( applySkin )
			scene.playAnimation(curFbx.loadAnimation(), time );
		if( showBones )
			showBonesRec(scene);
		scene.addPass(new Axis());
	}
	
	function showBonesRec( o : h3d.scene.Object ) {
		var s = flash.Lib.as(o, h3d.scene.Skin);
		if( s != null )
			s.showJoints = true;
		for( i in 0...o.numChildren )
			showBonesRec(o.getChildAt(i));
	}
	
	function onUpdate() {
		if( !engine.begin() )
			return;
			
		var dist = 50., height = 10.;
		var camera = scene.camera;
		switch( view ) {
		case 0:
			camera.pos.set(0, 0, dist);
			camera.up.set(0, 1, 0);
			camera.target.set(0, 0, 0);
		case 1:
			camera.pos.set(0, dist, height);
			camera.up.set(0, 0, 1);
			camera.target.set(0, 0, height);
		case 2:
			var K = Math.sqrt(2);
			camera.pos.set(rightHand ? -dist : dist, 0, height);
			camera.up.set(0, 0, 1);
			camera.target.set(0, 0, height);
		case 3:
			var K = Math.sqrt(2);
			camera.pos.set(dist, dist, height);
			camera.up.set(0, 0, 1);
			camera.target.set(0, 0, height);
		case 4:
			var speed = 0.02;
			camera.pos.set(Math.cos(time * speed) * dist, Math.sin(time * speed) * dist, height);
			camera.up.set(0, 0, 1);
			camera.target.set(0, 0, height);
		default:
			view = 0;
		}
		camera.rightHanded = rightHand;
		if( !pause )
			time++;
		tf.text = (camera.rightHanded ? "R " : "")+engine.fps;
		engine.render(scene);
	}
	
	static function main() {
		new Viewer();
	}

}