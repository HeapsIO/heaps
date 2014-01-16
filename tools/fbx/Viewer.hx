using h3d.fbx.Data;
using h3d.fbx.Data;

typedef K = flash.ui.Keyboard;
typedef Props = {
	curFbxFile:String,
	camVars:Camvars,
	view:Int,
	smoothing:Bool,
	showAxis:Bool,
	showBones:Bool,
	showBox:Bool,
	slowDown:Bool,
	loop:Bool,
};
typedef Camvars = {
	x:Float,
	y:Float,
	tx:Float,
	ty:Float,
	tz:Float,
	dist:Float,
	angCoef:Float,
	zoom:Float
};
	
class Cookie
{
	static var version = 0.1;
	static var _so = flash.net.SharedObject.getLocal("fbxViewerData" + version);
	static public function Cookie() {
	}
	
	static public function read() {
		try {
			Viewer.props = haxe.Unserializer.run(_so.data.params);
		} catch( e : Dynamic ) {
		}
	}

	static public function write() {
		_so.data.params = haxe.Serializer.run(Viewer.props);
		_so.flush();
	}
}

class Axis implements h3d.IDrawable {

	public function new() {
	}
	
	public function render( engine : h3d.Engine ) {
		engine.line(Viewer.props.camVars.tx, Viewer.props.camVars.ty, Viewer.props.camVars.tz, Viewer.props.camVars.tx + 50, Viewer.props.camVars.ty + 0, Viewer.props.camVars.tz + 0, 0xFFFF0000);
		engine.line(Viewer.props.camVars.tx, Viewer.props.camVars.ty, Viewer.props.camVars.tz, Viewer.props.camVars.tx + 0, Viewer.props.camVars.ty + 50, Viewer.props.camVars.tz + 0, 0xFF00FF00);
		engine.line(Viewer.props.camVars.tx, Viewer.props.camVars.ty, Viewer.props.camVars.tz, Viewer.props.camVars.tx + 0, Viewer.props.camVars.ty + 0, Viewer.props.camVars.tz + 50, 0xFF0000FF);
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
	static public var props : Props;
	static public var animMode : h3d.fbx.Library.AnimationMode = LinearAnim;

	var rightHand : Bool;
	var playAnim : Bool;
	var rightClick : Bool;
	var freeMove : Bool;
	var pMouse : flash.geom.Point;
	var axis : Axis;
	var box : h3d.scene.Object;
	var alib : h3d.fbx.Library;
	
	function new() {
		time = 0;
		rightHand = false;
		playAnim = true;
		freeMove = false;
		rightClick = false;
		
		props = { curFbxFile : "", camVars : { x:0, y:0, tx:0, ty:0, tz:0, dist:0, angCoef:Math.PI / 7, zoom:1 }, view:0, smoothing:true, showAxis:true, showBones:false, showBox:false, slowDown:false, loop:true };
		Cookie.read();
		
		tf = new flash.text.TextField();
		var fmt = tf.defaultTextFormat;
		fmt.align = flash.text.TextFormatAlign.RIGHT;
		tf.defaultTextFormat = fmt;
		tf.width = 200;
		tf.x = flash.Lib.current.stage.stageWidth - (tf.width + 5);
		tf.y = 5;
		tf.textColor = 0xFFFFFF;
		tf.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		tf.selectable = false;
		flash.Lib.current.addChild(tf);
		
		tf_keys = new flash.text.TextField();
		tf_keys.x = 5;
		tf_keys.width = 500;
		tf_keys.height = 1000;
		tf_keys.textColor = 0xFFFFFF;
		tf_keys.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		tf_keys.visible = false;
		tf_keys.selectable = false;
		flash.Lib.current.addChild(tf_keys);
		
		tf_help = new flash.text.TextField();
		tf_help.x = 5;
		tf_help.y = flash.Lib.current.stage.stageHeight - 25;
		tf_help.width = 120;
		tf_help.text = "[H] Show/Hide keys";
		tf_help.textColor = 0xFFFFFF;
		tf_help.filters = [new flash.filters.GlowFilter(0, 1, 2, 2, 20)];
		tf_help.selectable = false;
		flash.Lib.current.addChild(tf_help);
		
		engine = new h3d.Engine();
		#if debug
		engine.debug = true;
		#end
		engine.backgroundColor = 0xFF808080;
		engine.onReady = onReady;
		engine.init();
	}
	
	function onReady() {
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, function (_) onUpdate());
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, function (e:flash.events.MouseEvent) {
			if (props.view < 3)	props.view = 3;
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
				var dz = (e.delta / Math.abs(e.delta)) * props.camVars.zoom / 8;
				props.camVars.zoom = Math.min(4, Math.max(0.4, props.camVars.zoom + dz));
				Cookie.write();
			});
		flash.Lib.current.stage.addEventListener(flash.events.Event.RESIZE, function (e:flash.events.Event) {
				tf.x = flash.Lib.current.stage.stageWidth - (tf.width + 5);
				tf_help.y = flash.Lib.current.stage.stageHeight - 25;
				tf_keys.y = flash.Lib.current.stage.stageHeight - tf_keys.textHeight - 35;
			});
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, function(k:flash.events.KeyboardEvent ) {
			var reload = false;
			var c = k.keyCode;
				
			if ( c == 49 )			props.view = 1;
			else if ( c == 50 )		props.view = 2;
			else if ( c == 51 )		props.view = 3;
			else if ( c == 52 )		props.view = 4;
			else if( c == K.F1 )
				askLoad();
			else if( c == K.F2 )
				askLoad(true);
			else if( c == K.S && k.ctrlKey ) {
				if( curFbx == null ) return;
				var data = FbxTree.toXml(curFbx.getRoot());
				var f = new flash.net.FileReference();
				var path = props.curFbxFile.substr(0, -4) + "_tree.xml";
				path = path.split("\\").pop().split("/").pop();
				f.save(data, path);
			} else if( c == K.R ) {
				rightHand = !rightHand;
				props.camVars.x *= -1;
				props.camVars.tx *= -1;
				reload = true;
			} else if( c == K.K ) {
				props.showBones = !props.showBones;
				showBonesRec(scene, props.showBones);
			} else if ( c == K.Y ) {
				props.showAxis = !props.showAxis;
				if (props.showAxis)
					scene.addPass(axis);
				else scene.removePass(axis);
			} else if ( c == K.N ) {
				props.smoothing = !props.smoothing;
				setSmoothing();
			} else if ( c == K.B ) {
				props.showBox = !props.showBox;
				if (props.showBox && box != null)
					scene.addChild(box);
				else scene.removeChild(box);
			}
			else if ( c == K.F ) {
				var b = scene.getChildAt(0).getBounds();
				var dx = b.xMax - b.xMin;
				var dy = b.yMax - b.yMin;
				var dz = b.zMax - b.zMin;
				var tdist = Math.max(dx * 4, dy * 4);
				props.camVars = { x: tdist, y:0, tx:0, ty:0, tz:0, dist:tdist, angCoef:Math.PI / 7, zoom:1 };
				var dist = props.camVars.dist;
				var ang = Math.PI / 4;
				props.camVars.x = dist * Math.cos(ang);
				props.camVars.y = dist * Math.sin(ang);
				scene.camera.pos.set(props.camVars.tx + props.camVars.x * Math.cos(Math.PI / 2 * props.camVars.angCoef), props.camVars.ty + props.camVars.y * Math.cos(Math.PI / 2 * props.camVars.angCoef), props.camVars.tz + dist * Math.sin(Math.PI / 2 * props.camVars.angCoef));
				scene.camera.zoom = 1.0;
				box.x = b.xMin + dx * 0.5;
				box.y = b.yMin + dy * 0.5;
				box.z = b.zMin + dz * 0.5;
				scene.getChildAt(0).x = 0;
				scene.getChildAt(0).y = 0;
				scene.getChildAt(0).z = 0;
			}
			else if ( c == K.H ) {
				tf_keys.visible = !tf_keys.visible;
			} else if( c == K.SPACE ) {
				if( scene.currentAnimation != null )
					scene.currentAnimation.pause = !scene.currentAnimation.pause;
			} else if( c == K.S ) {
				props.slowDown = !props.slowDown;
			} else if( c == K.A ) {
				var cst = h3d.fbx.Library.AnimationMode.createAll();
				animMode = cst[(Lambda.indexOf(cst, animMode) + 1) % cst.length];
				reload = true;
			} else if( c == K.L ) {
				props.loop = !props.loop;
				reload = true;
			}
			
			if( reload && curData != null )
				loadData(curData);
			Cookie.write();
		});
		
		scene = new h3d.scene.Scene();
		axis = new Axis();
		scene.addPass(axis);
		
		if( props.curFbxFile != null )
			loadFile(props.curFbxFile, false);
		else
			askLoad();
	}
	
	function loadFile( file : String, newFbx = true ) {
		props.curFbxFile = file;
		var l = new flash.net.URLLoader();
		l.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
			if( newFbx ) haxe.Log.trace("Failed to load " + file,null);
		});
		l.addEventListener(flash.events.Event.COMPLETE, function(_) {
			loadData(l.data, newFbx);
		});
		l.load(new flash.net.URLRequest(file));
	}
	
	function textureLoader( textureName : String, matData : h3d.fbx.Data.FbxNode ) {
		var t = engine.mem.allocTexture(1024, 1024);
		var bmp = new flash.display.BitmapData(1024, 1024, true, 0xFFFF0000);
		var mat = new h3d.mat.MeshMaterial(t);
		t.uploadBitmap(hxd.BitmapData.fromNative(bmp));
		bmp.dispose();
		loadTexture(textureName, mat);
		mat.killAlpha = true;
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
	
	function loadTexture( textureName : String, mat : h3d.mat.MeshMaterial, handleAlpha = true ) {
		var t = mat.texture;
		if( textureName.split(".").pop().toLowerCase() == "png" && handleAlpha ) {
			var loader = new flash.net.URLLoader();
			loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
			loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
				mat.culling = None;
			});
			loader.addEventListener(flash.events.Event.COMPLETE, function(_) {
				var bytes = haxe.io.Bytes.ofData(loader.data);
				var png = new format.png.Reader(new haxe.io.BytesInput(bytes)).read();
				var size = format.png.Tools.getHeader(png);
				var pixels = try format.png.Tools.extract32(png) catch( e : Dynamic ) null;
				// some unsupported formats such as 8 bits PNG
				if( pixels == null ) {
					loadTexture(textureName, mat, false);
					return;
				}
				t.resize(size.width, size.height);
				t.uploadPixels(new hxd.Pixels(size.width,size.height,pixels,BGRA));
				mat.culling = None;
			});
			loader.load(new flash.net.URLRequest(textureName));
		} else {
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
				mat.culling = None;
			});
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
				var bmp = flash.Lib.as(loader.content, flash.display.Bitmap).bitmapData;
				t.resize(bmp.width, bmp.height);
				t.uploadBitmap(hxd.BitmapData.fromNative(bmp));
				mat.culling = None;
			});
			loader.load(new flash.net.URLRequest(textureName));
		}
	}
	
	function askLoad( ?anim ) {
		var f = new flash.net.FileReference();
		f.addEventListener(flash.events.Event.COMPLETE, function(_) {
			haxe.Log.clear();
			var content = f.data.readUTFBytes(f.data.length);
			if( anim ) {
				alib = new h3d.fbx.Library();
				var fbx = h3d.fbx.Parser.parse(content);
				alib.load(fbx);
				if( !rightHand )
					alib.leftHandConvert();
				setSkin();
			} else {
				props.curFbxFile = f.name;
				loadData(content);
			}
		});
		f.addEventListener(flash.events.Event.SELECT, function(_) f.load());
		f.browse([new flash.net.FileFilter("FBX File", "*.fbx")]);
	}
	
	function loadData( data : String, newFbx = true ) {
		curFbx = new h3d.fbx.Library();
		curFbx.unskinnedJointsAsObjects = true;
		curData = data;
		var fbx = h3d.fbx.Parser.parse(data);
		curFbx.load(fbx);
		if( !rightHand )
			curFbx.leftHandConvert();
		var frame = scene == null ? 0 : (scene.currentAnimation == null ? 0 : scene.currentAnimation.frame);
		scene = new h3d.scene.Scene();
		scene.addChild(curFbx.makeObject(textureLoader));
	
		//
		var b = scene.getBounds();
		

		var dx = b.xMax - b.xMin;
		var dy = b.yMax - b.yMin;
		
		box = new h3d.scene.Box(0xFFFF9910);
		//init camera
		if (!newFbx) {
			scene.camera.pos.set(props.camVars.x * Math.cos(Math.PI/2 * props.camVars.angCoef), props.camVars.y * Math.cos(Math.PI/2 * props.camVars.angCoef), props.camVars.dist * Math.sin(Math.PI/2 * props.camVars.angCoef));
		}
		else {
			var tdist = Math.max(dx * 4, dy * 4);
			props.camVars = { x: tdist, y:0, tx:0, ty:0, tz:0, dist:tdist, angCoef:Math.PI / 7, zoom:1 };
		}
		
		scene.camera.zFar *= props.camVars.dist * 0.1;
		scene.camera.zNear *= props.camVars.dist * 0.1;
		scene.camera.zoom = props.camVars.zoom;
		//
		if (props.showBox)
			scene.addChild(box);
		if (props.showAxis)
			scene.addPass(axis);
		showBonesRec(scene, props.showBones);
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
		for( m in meshes )
			m.material.texture.filter = props.smoothing ? Linear : Nearest;
	}
	
	function setSkin() {
		var anim = curFbx.loadAnimation(animMode, null, null, alib);
		if( anim != null ) {
			anim = scene.playAnimation(anim);
			if( !props.loop ) {
				anim.loop = false;
				anim.onAnimEnd = function() anim.setFrame(0);
			}
		}
	}
	
	function onUpdate() {
		if( !engine.begin() )
			return;
			
		var dist = props.camVars.dist;
		var camera = scene.camera;
		var ang = Math.atan2(camera.pos.y - props.camVars.ty, camera.pos.x - props.camVars.tx);
		
		//FREE MOUSE MOVE
		if (freeMove) {
			var dx = (flash.Lib.current.mouseX - pMouse.x) * 0.01;
			var dy = (flash.Lib.current.mouseY - pMouse.y) * 0.01;
			props.camVars.angCoef = Math.max( -0.99, Math.min(0.99, props.camVars.angCoef + dy * 0.5));
			props.camVars.x = dist * Math.cos(ang + dx);
			props.camVars.y = dist * Math.sin(ang + dx);
			camera.pos.set(props.camVars.tx + props.camVars.x * Math.cos(Math.PI / 2 * props.camVars.angCoef), props.camVars.ty + props.camVars.y * Math.cos(Math.PI / 2 * props.camVars.angCoef), props.camVars.tz + dist * Math.sin(Math.PI / 2 * props.camVars.angCoef));
			camera.up.set(0, 0, 1);
			camera.target.set(props.camVars.tx, props.camVars.ty, props.camVars.tz);
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
		}
		else if (rightClick) {
			var dx = (pMouse.x - flash.Lib.current.mouseX);
			var dy = (pMouse.y - flash.Lib.current.mouseY);
			
			//horizontal mouse move
			props.camVars.tx += Math.cos(ang + Math.PI / 2) * dx * 0.5;
			props.camVars.ty += Math.sin(ang + Math.PI / 2) * dx * 0.5;
			//vertical mouse move
			props.camVars.tx -= Math.cos(ang) * Math.abs(props.camVars.angCoef) * dy * 0.5;
			props.camVars.ty -= Math.sin(ang) * Math.abs(props.camVars.angCoef) * dy * 0.5;
			props.camVars.tz += (1 - Math.abs(props.camVars.angCoef)) * dy;
			
			camera.pos.set(props.camVars.tx + Math.cos(ang) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.ty + Math.sin(ang) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.tz + dist * Math.sin(Math.PI / 2 * props.camVars.angCoef));
			camera.up.set(0, 0, 1);
			camera.target.set(props.camVars.tx, props.camVars.ty, props.camVars.tz);
			pMouse = new flash.geom.Point(flash.Lib.current.mouseX, flash.Lib.current.mouseY);
		}
		//VIEWS
		else {
			switch( props.view ) {
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
				camera.pos.set(props.camVars.tx + Math.cos(ang) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.ty + Math.sin(ang) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.tz + dist * Math.sin(Math.PI / 2 * props.camVars.angCoef));
				camera.up.set(0, 0, 1);
				camera.target.set(props.camVars.tx, props.camVars.ty, props.camVars.tz);
			case 4:
				camera.pos.set(props.camVars.tx + Math.cos(ang + 0.02) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.ty + Math.sin(ang + 0.02) * Math.cos(Math.PI / 2 * props.camVars.angCoef) * dist, props.camVars.tz + dist * Math.sin(Math.PI / 2 * props.camVars.angCoef));
				camera.up.set(0, 0, 1);
				camera.target.set(props.camVars.tx, props.camVars.ty, props.camVars.tz);
			default:
				props.view < 0? props.view = 4 : props.view = 0;
			}
		}
		
		camera.zoom += (props.camVars.zoom - camera.zoom) * 0.5;
		camera.rightHanded = rightHand;
		
		if( box != null ) {
			var b = scene.getBounds();
			var dx = b.xMax - b.xMin;
			var dy = b.yMax - b.yMin;
			var dz = b.zMax - b.zMin;
			box.scaleX = dx;
			box.scaleY = dy;
			box.scaleZ = dz;
			box.x = b.xMin + dx * 0.5;
			box.y = b.yMin + dy * 0.5;
			box.z = b.zMin + dz * 0.5;
		}
		
		time++;
		
		var fmt = hxd.Math.fmt;
		
		tf_keys.text = [
			"[F1] Load model",
			"[F2] Load animation",
			"[A] Animation = " + animMode,
			"[L] Loop = "+props.loop,
			"[Y] Axis = "+props.showAxis,
			"[K] Bones = "+props.showBones,
			"[B] Bounds = "+props.showBox+(box == null ? "" : " ["+fmt(box.scaleX)+" x "+fmt(box.scaleY)+" x "+fmt(box.scaleZ)+"]"),
			"[S] Slow Animation = "+props.slowDown,
			"[R] Right-Hand Camera = "+rightHand,
			"[N] Tex Smoothing = "+props.smoothing,
			"[F] Default camera",
			"[1~4] Views",
			"",
			"[Space] Pause Animation",
			"[LMB + Move] Rotation",
			"[RMB + Move] translation",
			"[Wheel] Zoom"
		].join("\n");
		tf_keys.y = flash.Lib.current.stage.stageHeight - tf_keys.textHeight - 35;
		
		
		scene.setElapsedTime((props.slowDown ? 0.1 : 1) / Math.max(engine.fps,60));
		engine.render(scene);
		tf.text = [
			(camera.rightHanded ? "R " : "") + fmt(engine.fps),
			props.curFbxFile.split("/").pop().split("\\").pop(),
			(engine.drawTriangles - (props.showBox ? 26 : 0) - (props.showAxis ? 6 : 0)) + " tri",
		].join("\n");
	}
	
	static var inst : Viewer;
	
	static function checkInvoke() {
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.InvokeEvent.INVOKE, function(e:Dynamic) {
			var e : flash.events.InvokeEvent = cast e;
			if( e.arguments.length > 0 ) {
				props.curFbxFile = e.arguments[0];
				if( inst.scene != null ) {
					inst.loadFile(props.curFbxFile);
					flash.desktop.NativeApplication.nativeApplication.openedWindows[0].activate();
				}
			}
		});
	}
	
	static function main() {
		inst = new Viewer();
		if( flash.system.Capabilities.playerType == "Desktop" )
			checkInvoke();
	}

}