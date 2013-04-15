using h3d.fbx.Data;
using h3d.fbx.Data;

typedef K = flash.ui.Keyboard;

class Cookie
{
	static var _so = flash.net.SharedObject.getLocal("fbxViewerData");
	static public var params : {curFbxFile:String, camX:Float, camY:Float, camT:h3d.Vector, camAng:Float, camDist:Float, camZoom:Float, view:Int, smoothing:Bool, showAxis:Bool, showBones:Bool, showBox:Bool };
	static public function Cookie() {
	}
	
	static public function read() {
		params = { curFbxFile : "", camX:0, camY:0, camT:new h3d.Vector(), camAng:0, camDist:0, camZoom:0, view:0, smoothing:true, showAxis:true, showBones:false, showBox:false };
		if (_so.data.params) {
			Viewer.curData = haxe.Unserializer.run(_so.data.fbx);
			params = haxe.Unserializer.run(_so.data.params);
			
			Viewer.curFbxFile = params.curFbxFile;
			Viewer.camVars.x = params.camX;
			Viewer.camVars.y = params.camY;
			if (params.camT != null) {
				Viewer.camVars.tx = params.camT.x;
				Viewer.camVars.ty = params.camT.y;
				Viewer.camVars.tz = params.camT.z;
			}
			Viewer.camVars.angCoef = params.camAng;
			Viewer.camVars.dist = params.camDist;
			Viewer.camVars.zoom = params.camZoom;
			Viewer.view = params.view;
			Viewer.smoothing = params.smoothing;
			Viewer.showAxis = params.showAxis;
			Viewer.showBones = params.showBones;
			Viewer.showBox = params.showBox;
		}
		return Viewer.curFbxFile;
	}

	static public function write() {
		if (params == null || params.curFbxFile != Viewer.curFbxFile)
			_so.data.fbx = haxe.Serializer.run(Viewer.curData);
			
		params = {
			curFbxFile 	: Viewer.curFbxFile,
			camX 		: Viewer.camVars.x,
			camY 		: Viewer.camVars.y,
			camT		: new h3d.Vector(Viewer.camVars.tx,Viewer.camVars.ty, Viewer.camVars.tz),
			camAng 		: Viewer.camVars.angCoef,
			camDist		: Viewer.camVars.dist,
			camZoom 	: Viewer.camVars.zoom,
			view		: Viewer.view,
			smoothing 	: Viewer.smoothing,
			showAxis 	: Viewer.showAxis,
			showBones 	: Viewer.showBones,
			showBox 	: Viewer.showBox,
		}
		_so.data.params = haxe.Serializer.run(params);
		_so.flush();
	}
}

class Axis implements h3d.IDrawable {

	public function new() {
	}
	
	public function render( engine : h3d.Engine ) {
		/*engine.line(0, 0, 0, 50, 0, 0, 0xFFFF0000);
		engine.line(0, 0, 0, 0, 50, 0, 0xFF00FF00);
		engine.line(0, 0, 0, 0, 0, 50, 0xFF0000FF);*/
		engine.line(Viewer.camVars.tx, Viewer.camVars.ty, Viewer.camVars.tz, Viewer.camVars.tx + 50, Viewer.camVars.ty + 0, Viewer.camVars.tz + 0, 0xFFFF0000);
		engine.line(Viewer.camVars.tx, Viewer.camVars.ty, Viewer.camVars.tz, Viewer.camVars.tx + 0, Viewer.camVars.ty + 50, Viewer.camVars.tz + 0, 0xFF00FF00);
		engine.line(Viewer.camVars.tx, Viewer.camVars.ty, Viewer.camVars.tz, Viewer.camVars.tx + 0, Viewer.camVars.ty + 0, Viewer.camVars.tz + 50, 0xFF0000FF);
	}
	
}


class Viewer {

	var engine : h3d.Engine;
	var scene : h3d.scene.Scene;

	var time : Float;
	var anim : h3d.anim.Animation;
	var tf : flash.text.TextField;
	var tf_keys : flash.text.TextField;
	var tf_help : flash.text.TextField;
	
	var curFbx : h3d.fbx.Library;
	static public var curData : String;
	static public var curFbxFile : String;
	static public var view : Int;
	static public var showBones : Bool;
	static public var showBox : Bool;
	static public var showAxis : Bool;
	static public var smoothing : Bool;
	static public var slowDown : Bool;
	static public var animMode : h3d.fbx.Library.AnimationMode = LinearAnim;
	static public var camVars : {x:Float, y:Float, tx:Float, ty:Float, tz:Float, dist:Float, angCoef:Float, zoom:Float };
	
	var rightHand : Bool;
	var playAnim : Bool;
	var rightClick : Bool;
	var freeMove : Bool;
	var pMouse : flash.geom.Point;
	var axis : Axis;
	var box : h3d.scene.Object;
	
	function new() {
		time = 0;
		view = 3;
		rightHand = false;
		playAnim = true;
		showBones = false;
		showAxis = true;
		freeMove = false;
		showBox = false;
		smoothing = false;
		rightClick = false;
		camVars = { x:0, y:0, tx:0, ty:0, tz:0, dist:0, angCoef:Math.PI / 7, zoom:1 };
		tf = new flash.text.TextField();
		tf.x = flash.Lib.current.stage.stageWidth - 40;
		tf.y = 5;
		tf.textColor = 0xFFFFFF;
		tf.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		flash.Lib.current.addChild(tf);
		
		tf_keys = new flash.text.TextField();
		tf_keys.x = 5;
		tf_keys.y = flash.Lib.current.stage.stageHeight - 235;
		tf_keys.width = 200;
		tf_keys.height = 1000;
		tf_keys.textColor = 0xFFFFFF;
		tf_keys.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		tf_keys.visible = false;
		flash.Lib.current.addChild(tf_keys);
		
		tf_help = new flash.text.TextField();
		tf_help.x = 5;
		tf_help.y = flash.Lib.current.stage.stageHeight - 25;
		tf_help.width = 120;
		tf_help.text = "[H] Show/Hide keys";
		tf_help.textColor = 0xFFFFFF;
		tf_help.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		flash.Lib.current.addChild(tf_help);
		
		engine = new h3d.Engine();
		engine.backgroundColor = 0xFF808080;
		engine.onReady = onReady;
		engine.init();
	}
	
	function onReady() {
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, function (_) onUpdate());
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, function (e:flash.events.MouseEvent) {
			if (view < 3)	view = 3;
			freeMove = true;
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
			});
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, function (e:flash.events.MouseEvent) {
			freeMove = false;
			Cookie.write();
			});
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_DOWN, function (e:flash.events.MouseEvent) {
			rightClick = true;
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
			});
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_UP, function (e:flash.events.MouseEvent) {
			rightClick = false;
			Cookie.write();
			});
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, function (e:flash.events.MouseEvent) {
				var dz = (e.delta / Math.abs(e.delta)) * camVars.zoom / 8;
				camVars.zoom = Math.min(4, Math.max(0.4, camVars.zoom + dz));
				Cookie.write();
			});
		flash.Lib.current.stage.addEventListener(flash.events.Event.RESIZE, function (e:flash.events.Event) {
				tf.x = flash.Lib.current.stage.stageWidth - 40;
				tf_help.y = flash.Lib.current.stage.stageHeight - 25;
				tf_keys.y = flash.Lib.current.stage.stageHeight - 235;
			});
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, function(k:flash.events.KeyboardEvent ) {
			var reload = false;
			var c = k.keyCode;
				
			if ( c == 49 )			view = 1;
			else if ( c == 50 )		view = 2;
			else if ( c == 51 )		view = 3;
			else if ( c == 52 )		view = 4;
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
			} else if( c == K.K ) {
				showBones = !showBones;
				showBonesRec(scene, showBones);
			} else if ( c == K.Y ) {
				showAxis = !showAxis;
				if (showAxis)
					scene.addPass(axis);
				else scene.removePass(axis);
			} else if ( c == K.N ) {
				smoothing = !smoothing;
				setSmoothing();
			} else if ( c == K.B ) {
				showBox = !showBox;
				if (showBox && box != null)
					scene.addChild(box);
				else scene.removeChild(box);
			}
			else if ( c == K.F ) {
				var b = scene.getChildAt(0).getBounds();
				var dx = b.xMax - b.xMin;
				var dy = b.yMax - b.yMin;
				var dz = b.zMax - b.zMin;
				var tdist = Math.max(dx * 4, dy * 4);
				camVars = { x: tdist, y:0, tx:0, ty:0, tz:0, dist:tdist, angCoef:Math.PI / 7, zoom:1 };
				var dist = camVars.dist;
				var ang = Math.PI / 4;
				camVars.x = dist * Math.cos(ang);
				camVars.y = dist * Math.sin(ang);
				scene.camera.pos.set(camVars.tx + camVars.x * Math.cos(Math.PI / 2 * camVars.angCoef), camVars.ty + camVars.y * Math.cos(Math.PI / 2 * camVars.angCoef), camVars.tz + dist * Math.sin(Math.PI / 2 * camVars.angCoef));
				scene.camera.zoom = 1.0;
				scene.camera.fov = calcFov(40);
				box.x = b.xMin + dx * 0.5;
				box.y = b.yMin + dy * 0.5;
				box.z = b.zMin + dz * 0.5;
				scene.getChildAt(0).x = 0;
				scene.getChildAt(0).y = 0;
				scene.getChildAt(0).z = 0;
				Cookie.write();
			}
			else if ( c == K.H ) {
				tf_keys.visible = !tf_keys.visible;
			} else if( c == K.SPACE ) {
				if( scene.currentAnimation != null )
					scene.currentAnimation.pause = !scene.currentAnimation.pause;
			} else if( c == K.S ) {
				slowDown = !slowDown;
			} else if( c == K.A ) {
				var cst = h3d.fbx.Library.AnimationMode.createAll();
				animMode = cst[(Lambda.indexOf(cst, animMode) + 1) % cst.length];
				reload = true;
			}
			
			if( reload && curData != null )
				loadData(curData);
			Cookie.write();
		});
		
		scene = new h3d.scene.Scene();
		axis = new Axis();
		scene.addPass(axis);
		
		if (Cookie.read() != null)
			loadData(curData);
		else askLoad();
	}
	
	function textureLoader( textureName : String, matData : h3d.fbx.Data.FbxNode ) {
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
		mat.blend(SrcAlpha, OneMinusSrcAlpha);
		for( p in matData.getAll("Properties70.P") )
			if( p.props[0].toString() == "TransparencyFactor" && p.props[4].toFloat() < 0.999 ) {
				mat.blend(SrcAlpha, One);
				mat.renderPass = 1;
				mat.depthWrite = false;
				break;
			}
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
		var frame = scene == null ? 0 : (scene.currentAnimation == null ? 0 : scene.currentAnimation.frame);
		scene = curFbx.makeScene(textureLoader, 3);
		
		//
		var b = scene.getChildAt(0).getBounds();
		var dx = b.xMax - b.xMin;
		var dy = b.yMax - b.yMin;
		var dz = b.zMax - b.zMin;
		
		box = new h3d.scene.Box(0xFFFF9910);
		box.scaleX = dx;
		box.scaleY = dy;
		box.scaleZ = dz;
		box.x = b.xMin + dx * 0.5;
		box.y = b.yMin + dy * 0.5;
		box.z = b.zMin + dz * 0.5;

		//init camera
		
		if (curFbxFile == Cookie.params.curFbxFile) {
			scene.camera.pos.set(camVars.x * Math.cos(Math.PI/2 * camVars.angCoef), camVars.y * Math.cos(Math.PI/2 * camVars.angCoef), camVars.dist * Math.sin(Math.PI/2 * camVars.angCoef));
		}
		else {
			var tdist = Math.max(dx * 4, dy * 4);
			camVars = { x: tdist, y:0, tx:0, ty:0, tz:0, dist:tdist, angCoef:Math.PI / 7, zoom:1 };
		}
			
		scene.camera.zFar *= camVars.dist * 0.1;
		scene.camera.zNear *= camVars.dist * 0.1;
		scene.camera.zoom = camVars.zoom;
		scene.camera.fov = calcFov(40);
		//
		if (showBox)
			scene.addChild(box);
		if (showAxis)
			scene.addPass(axis);
		showBonesRec(scene, showBones);
		setSmoothing();
		setSkin();
		
		Cookie.write();
	}
	
	function getMeshes(obj : h3d.scene.Object) {
		var m = [];
		function loop( o : h3d.scene.Object ) {
			if ( o.isMesh() ) m.push(o.toMesh());
			for( i in 0...o.numChildren )
				loop(o.getChildAt(i));
		}
		loop(obj);
		return m;
	}
	
	function showBonesRec( o : h3d.scene.Object, show = true ) {
		var s = flash.Lib.as(o, h3d.scene.Skin);
		if( s != null )
			s.showJoints = show;
		for( i in 0...o.numChildren )
			showBonesRec(o.getChildAt(i), show);
	}
	
	function setSmoothing() {
		var meshes = getMeshes(scene.getChildAt(0));
		for (m in meshes) {
			m.material.killAlpha = !smoothing;
			m.material.texNearest = !smoothing;
		}
	}
	
	function setSkin() {
		var anim = curFbx.loadAnimation(animMode);
		if( anim != null )
			anim = scene.playAnimation(anim);
	}
	
	function onUpdate() {
		if( !engine.begin() )
			return;
			
		var dist = camVars.dist;
		var camera = scene.camera;
		var ang = Math.atan2(camera.pos.y - camVars.ty, camera.pos.x - camVars.tx);
		
		//FREE MOUSE MOVE
		if (freeMove) {
			var dx = (flash.Lib.current.mouseX - pMouse.x) * 0.01;
			var dy = (flash.Lib.current.mouseY - pMouse.y) * 0.01;
			camVars.angCoef = Math.max( -0.99, Math.min(0.99, camVars.angCoef + dy * 0.5));
			camVars.x = dist * Math.cos(ang + dx);
			camVars.y = dist * Math.sin(ang + dx);
			camera.pos.set(camVars.tx + camVars.x * Math.cos(Math.PI / 2 * camVars.angCoef), camVars.ty + camVars.y * Math.cos(Math.PI / 2 * camVars.angCoef), camVars.tz + dist * Math.sin(Math.PI / 2 * camVars.angCoef));
			camera.up.set(0, 0, 1);
			camera.target.set(camVars.tx, camVars.ty, camVars.tz);
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
		}
		else if (rightClick) {
			var dx = (pMouse.x - flash.Lib.current.mouseX);
			var dy = (pMouse.y - flash.Lib.current.mouseY);
			
			//horizontal mouse move
			camVars.tx += Math.cos(ang + Math.PI / 2) * dx * 0.5;
			camVars.ty += Math.sin(ang + Math.PI / 2) * dx * 0.5;
			//vertical mouse move
			camVars.tx -= Math.cos(ang) * Math.abs(camVars.angCoef) * dy * 0.5;
			camVars.ty -= Math.sin(ang) * Math.abs(camVars.angCoef) * dy * 0.5;
			camVars.tz += (1 - Math.abs(camVars.angCoef)) * dy;
			
			camera.pos.set(camVars.tx + Math.cos(ang) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.ty + Math.sin(ang) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.tz + dist * Math.sin(Math.PI / 2 * camVars.angCoef));
			camera.up.set(0, 0, 1);
			camera.target.set(camVars.tx, camVars.ty, camVars.tz);
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
		}
		//VIEWS
		else {
			switch( view ) {
			case 0:
				camera.pos.set(0, 0, dist);
				camera.up.set(0, 1, 0);
				camera.target.set(0, 0, 0);
			case 1:
				camera.pos.set(0, dist, 0);
				camera.up.set(0, 0, 1);
				camera.target.set(0, 0, 0);
			case 2:
				camera.pos.set(rightHand ? -dist : dist, 0, 0);
				camera.up.set(0, 0, 1);
				camera.target.set(0, 0, 0);
			case 3:
				camera.pos.set(camVars.tx + Math.cos(ang) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.ty + Math.sin(ang) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.tz + dist * Math.sin(Math.PI / 2 * camVars.angCoef));
				camera.up.set(0, 0, 1);
				camera.target.set(camVars.tx, camVars.ty, camVars.tz);
			case 4:
				camera.pos.set(camVars.tx + Math.cos(ang + 0.02) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.ty + Math.sin(ang + 0.02) * Math.cos(Math.PI / 2 * camVars.angCoef) * dist, camVars.tz + dist * Math.sin(Math.PI / 2 * camVars.angCoef));
				camera.up.set(0, 0, 1);
				camera.target.set(camVars.tx, camVars.ty, camVars.tz);
			default:
				view < 0? view = 4 : view = 0;
			}
		}
		
		camera.zoom += (camVars.zoom - camera.zoom) * 0.5;
		camera.rightHanded = rightHand;
		
		time++;
		tf.text = (camera.rightHanded ? "R " : "") + engine.fps;
		
		tf_keys.text = [
			"[F1] Load model",
			"[A] Animation : "+animMode,
			"[Y] Axis : "+showAxis,
			"[K] Bones : "+showBones,
			"[B] Bounds : "+showBox,
			"[S] Slow Animation : "+slowDown,
			"[R] Right-Hand Camera : "+rightHand,
			"[N] Tex Smoothing : "+smoothing,
			"[F] Default camera",
			"[1~4] Views",
			"",
			"[Space] Pause Animation",
			"[LMB + Move] Rotation",
			"[RMB + Move] translation",
			"[Wheel] Zoom"
		].join("\n");
		
		scene.setElapsedTime((slowDown ? 0.1 : 1) / Math.max(engine.fps,60));
		engine.render(scene);
		
	}
	
	function calcFov( fov : Float ) {
		return Math.atan( (engine.width / engine.height) * Math.tan(fov * Math.PI / 180)) * 180 / Math.PI;
	}
	
	static function main() {
		new Viewer();
	}

}