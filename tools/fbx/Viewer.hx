using hxd.fmt.fbx.Data;

typedef K = hxd.Key;

typedef Props = {
	curFbxFile:String,
	camPos:Campos,
	smoothing:Bool,
	showAxis:Bool,
	showBones:Bool,
	showBox:Bool,
	slowDown:Bool,
	loop:Bool,
	lights:Bool,
	normals:Bool,
}

typedef Campos = {
	x:Float,
	y:Float,
	z:Float,
	tx:Float,
	ty:Float,
	tz:Float,
}

class Viewer extends hxd.App {

	var obj : h3d.scene.Object;
	var anim : h3d.anim.Animation;
	var tf : flash.text.TextField;
	var tf_keys : flash.text.TextField;
	var tf_help : flash.text.TextField;

	var curFbx : hxd.fmt.fbx.Library;
	static public var curData : String;
	static public var props : Props;
	static public var animMode : hxd.fmt.fbx.Library.AnimationMode = LinearAnim;

	var rightHand : Bool;
	var playAnim : Bool;
	var rightClick : Bool;
	var freeMove : Bool;
	var pMouse : h2d.col.Point;
	var axis : h3d.scene.Graphics;
	var box : h3d.scene.Object;
	var alib : hxd.fmt.fbx.Library;

	function new() {
		super();

		pMouse = new h2d.col.Point();
		obj = new h3d.scene.Object();

		rightHand = false;
		playAnim = true;
		freeMove = false;
		rightClick = false;

		props = { curFbxFile : "", camPos : { x:10, y:0, z:0, tx:0, ty:0, tz:0 }, smoothing:true, showAxis:true, showBones:false, showBox:false, slowDown:false, loop:true, lights : true, normals : false }
		props = hxd.Save.load(props);

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

	}

	function save() {
		hxd.Save.save(props);
	}

	override function init() {
		engine.debug = true;
		engine.backgroundColor = 0xFF808080;
		s2d.addEventListener(onEvent);

		var len = 10;
		axis = new h3d.scene.Graphics(s3d);
		axis.lineStyle(1.5, 0xFF0000);
		axis.lineTo(len, 0, 0);
		axis.lineStyle(1.5, 0x00FF000);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, len, 0);
		axis.lineStyle(1.5, 0x0000FF);
		axis.moveTo(0, 0, 0);
		axis.lineTo(0, 0, len);

		new h3d.scene.DirLight(new h3d.Vector(3, 4, -10), s3d);


		if( props.curFbxFile != null )
			loadFile(props.curFbxFile, false);
		else
			askLoad();
	}

	override function onResize() {
		tf.x = s2d.width - (tf.width + 5);
		tf_help.y = s2d.height - 25;
		tf_keys.y = s2d.height - tf_keys.textHeight - 35;
	}

	function onEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EPush:
			pMouse.set(e.relX, e.relY);
			switch( e.button ) {
			case 0:
				freeMove = true;
			case 1:
				rightClick = true;
			}
		case ERelease:
			switch( e.button ) {
			case 0:
				freeMove = false;
			case 1:
				rightClick = false;
			}
			save();
		case EWheel:
			if( e.wheelDelta > 0 ) zoom(1.2) else zoom(1 / 1.2);
		case EKeyDown:
			onKey(e);
		default:
		}
	}

	function zoom( z : Float ) {
		var d = s3d.camera.target.sub(s3d.camera.pos);
		d.scale3(z);
		s3d.camera.pos = s3d.camera.target.sub(d);
		save();
	}

	function onKey( e : hxd.Event ) {
		var reload = false;
		var cam = s3d.camera;
/*
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
*/

		switch( e.keyCode ) {
		case K.NUMBER_1:
			var b = obj.getBounds();
			var pz = b.zMax * 2 - b.zMin ;
			cam.pos.set(pz*0.001, pz*0.001, pz);
			cam.target.set(0, 0, 0);
		case K.NUMBER_2:
			//props.view = 2;
		case K.NUMBER_3:
			//props.view = 3;
		case K.NUMBER_4:
			//props.view = 4;
		case K.F1:
			askLoad();
		case K.F2:
			askLoad(true);
		case "S".code if( K.isDown(K.CTRL) ):
			if( curFbx == null ) return;
			var data = FbxTree.toXml(curFbx.getRoot());
			var path = props.curFbxFile.substr(0, -4) + "_tree.xml";
			hxd.File.saveAs(haxe.io.Bytes.ofString(data), { defaultPath : path } );
		case "R".code:
			rightHand = !rightHand;
			cam.pos.x *= -1;
			cam.target.x *= -1;
			reload = true;
		case "K".code:
			props.showBones = !props.showBones;
			setMaterial();
		case "Y".code:
			props.showAxis = !props.showAxis;
			if( props.showAxis )
				s3d.addChild(axis);
			else
				s3d.removeChild(axis);
		case "M".code:
			props.smoothing = !props.smoothing;
			setMaterial();
		case "N".code:
			props.normals = !props.normals;
			setMaterial();
		case "B".code:
			props.showBox = !props.showBox;
			if( props.showBox && box != null )
				s3d.addChild(box);
			else
				s3d.removeChild(box);
		case "F".code:
			resetCamera();
		case "H".code:
			tf_keys.visible = !tf_keys.visible;
		case K.SPACE:
			if( obj.currentAnimation != null )
				obj.currentAnimation.pause = !obj.currentAnimation.pause;
		case "S".code:
			props.slowDown = !props.slowDown;
		case "A".code:
			var cst = hxd.fmt.fbx.Library.AnimationMode.createAll();
			animMode = cst[(Lambda.indexOf(cst, animMode) + 1) % cst.length];
			reload = true;
		case "L".code:
			props.loop = !props.loop;
			reload = true;
		case "I".code:
			props.lights = !props.lights;
			setMaterial();
		default:

		}

		if( reload && curData != null )
			loadData(curData);

		save();
	}

	function loadFile( file : String, newFbx = true ) {
		props.curFbxFile = file;
		var l = new flash.net.URLLoader();
		l.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
			if( newFbx ) haxe.Log.trace("Failed to load " + file,null);
		});
		l.addEventListener(flash.events.Event.COMPLETE, function(_) {
			loadData(l.data, newFbx);
			if( newFbx ) {
				resetCamera();
				save();
			}
		});
		l.load(new flash.net.URLRequest(file));
	}

	function textureLoader( textureName : String, matData : FbxNode ) {
		var t = new h3d.mat.Texture(1, 1);
		t.clear(0xFF0000);
		var mat = new h3d.mat.MeshMaterial(t);
		loadTexture(textureName, mat);
		mat.mainPass.getShader(h3d.shader.Texture).killAlpha = true;
		mat.mainPass.culling = Both;
		mat.mainPass.blend(SrcAlpha, OneMinusSrcAlpha);
		for( p in matData.getAll("Properties70.P") )
			if( p.props[0].toString() == "TransparencyFactor" && p.props[4].toFloat() < 0.999 ) {
				mat.blendMode = Add;
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
				mat.mainPass.culling = None;
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
				mat.mainPass.culling = None;
			});
			loader.load(new flash.net.URLRequest(textureName));
		} else {
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
				mat.mainPass.culling = None;
			});
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
				var bmp = flash.Lib.as(loader.content, flash.display.Bitmap).bitmapData;
				t.resize(bmp.width, bmp.height);
				t.uploadBitmap(hxd.BitmapData.fromNative(bmp));
				mat.mainPass.culling = None;
			});
			loader.load(new flash.net.URLRequest(textureName));
		}
	}

	function askLoad( ?anim ) {
		hxd.File.browse(function(sel) {
			sel.load(function(bytes) {
				haxe.Log.clear();
				var content = bytes.toString();
				if( anim ) {
					alib = new hxd.fmt.fbx.Library();
					var fbx = hxd.fmt.fbx.Parser.parse(content);
					alib.load(fbx);
					if( !rightHand )
						alib.leftHandConvert();
					setAnim();
				} else {
					props.curFbxFile = sel.fileName;
					loadData(content);
					resetCamera();
					save();
				}
			});
		},{ fileTypes : [{ name : "FBX File", extensions : ["fbx"] }] });
	}

	function loadData( data : String, newFbx = true ) {
		curFbx = new hxd.fmt.fbx.Library();
		curFbx.unskinnedJointsAsObjects = true;
		curData = data;
		var fbx = hxd.fmt.fbx.Parser.parse(data);
		curFbx.load(fbx);
		if( !rightHand )
			curFbx.leftHandConvert();

		var frame = obj.currentAnimation == null ? 0 : obj.currentAnimation.frame;
		obj.remove();
		obj = curFbx.makeObject(textureLoader);
		s3d.addChild(obj);

		//
		var b = obj.getBounds();


		var dx = b.xMax - b.xMin;
		var dy = b.yMax - b.yMin;

		box = new h3d.scene.Box(0xFFFF9910);

		setMaterial();
		setAnim();

		save();
	}

	function resetCamera() {

		var b = obj.getBounds();
		var dx = Math.max(Math.abs(b.xMax),Math.abs(b.xMin));
		var dy = Math.max(Math.abs(b.yMax),Math.abs(b.yMin));
		var dz = Math.max(Math.abs(b.zMax),Math.abs(b.zMin));
		var dist = Math.max(Math.max(dx * 4, dy * 4),dz * 3);
		var ang = Math.PI / 4;
		var zang = Math.PI / 4;
		s3d.camera.pos.set(Math.sin(zang) * Math.cos(ang) * dist, Math.sin(zang) * Math.sin(ang) * dist, Math.cos(ang) * dist);
		s3d.camera.target.set(0, 0, 0);

		var c = b.getCenter();
		box.x = c.x;
		box.y = c.y;
		box.z = c.z;
	}

	@:debug
	function setMaterial( ?o : h3d.scene.Object ) {
		if( o == null )
			o = obj;
		if( o.isMesh() ) {
			var m = o.toMesh();
			if( m.material.texture != null )
				m.material.texture.filter = props.smoothing ? Linear : Nearest;
			m.material.mainPass.enableLights = props.lights;
			var s = Std.instance(o, h3d.scene.Skin);
			if( s != null )
				s.showJoints = props.showBones;
			if( props.normals ) {
				if( m.name != "__normals__" ) {
					var n = new h3d.scene.Mesh(m.primitive.buildNormalsDisplay(), m);
					n.material.color.set(0, 0, 1);
					n.material.mainPass.culling = None;
					n.material.mainPass.addShader(new h3d.shader.LineShader()).lengthScale = 0.2;
					n.name = "__normals__";
				}
			} else if( m.name == "__normals__" )
				m.remove();
		}
		for( s in o )
			setMaterial(s);
	}

	function setAnim() {
		var anim = curFbx.loadAnimation(animMode, null, null, alib);
		if( anim != null ) {
			anim = s3d.playAnimation(anim);
			if( !props.loop ) {
				anim.loop = false;
				anim.onAnimEnd = function() anim.setFrame(0);
			}
		}
	}

	override function update( dt : Float ) {
		var cam = s3d.camera;

		//FREE MOUSE MOVE
		if (freeMove) {
			var dx = (s2d.mouseX - pMouse.x) * 0.01;
			var dy = (s2d.mouseY - pMouse.y) * 0.01;
			var d = cam.pos.sub(cam.target);
			var dist = d.length();
			var r = Math.acos(d.z / dist);
			var k = Math.atan2(d.y, d.x);
			r -= dy * cam.up.z;
			k += dx * cam.up.z;
			if( r < 0 ) {
				k += Math.PI;
				r = -r;
				cam.up.z *= -1;
			} else if( r > Math.PI ) {
				r -= Math.PI * 2;
				cam.up.z *= -1;
			}
			cam.pos.set(Math.sin(r) * Math.cos(k) * dist, Math.sin(r) * Math.sin(k) * dist, Math.cos(r) * dist);
			pMouse.set(s2d.mouseX, s2d.mouseY);
		}
		else if (rightClick) {

			var dx = (pMouse.x - s2d.mouseX);
			var dy = (pMouse.y - s2d.mouseY);

			var d = cam.pos.sub(cam.target);
			var dist = d.length();

			dx *= 0.01 / dist;
			dy *= 0.01 / dist;

			d.normalize();
			var left = d.cross(cam.up);
			var up = left.cross(d);

			left.scale3(dx);
			up.scale3(dy);

			cam.pos = cam.pos.add(left).add(up);
			cam.target = cam.target.add(left).add(up);

			pMouse.set(s2d.mouseX, s2d.mouseY);
		}

		if( K.isDown(K.PGDOWN) )
			zoom(Math.pow(1.03,dt));
		else if( K.isDown(K.PGUP) )
			zoom(Math.pow(0.97,dt));

		var dist = cam.target.sub(cam.pos).length();
		cam.zFar = dist * 5;
		cam.zNear = dist * 0.1;
		cam.rightHanded = rightHand;

		axis.x = cam.target.x;
		axis.y = cam.target.y;
		axis.z = cam.target.z;

		if( box != null ) {
			var b = obj.getBounds();
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
			"[M] Tex Smoothing = " + props.smoothing,
			"[N] Show normals = "+props.normals,
			"[F] Default camera",
			"[I] Lights = "+props.lights,
			"[1~4] Views",
			"",
			"[Space] Pause Animation",
			"[LMB + Move] Rotation",
			"[RMB + Move] translation",
			"[Wheel] Zoom"
		].join("\n");
		tf_keys.y = s2d.height - tf_keys.textHeight - 35;

		tf.text = [
			(cam.rightHanded ? "R " : "") + fmt(hxd.Timer.fps()),
			props.curFbxFile.split("/").pop().split("\\").pop(),
			(engine.drawTriangles - (props.showBox ? 26 : 0) - (props.showAxis ? 0 : 0)) + " tri",
		].join("\n");

		if( props.slowDown ) hxd.Timer.tmod *= 0.1;
	}

	static var inst : Viewer;

	static function checkInvoke() {
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.InvokeEvent.INVOKE, function(e:Dynamic) {
			var e : flash.events.InvokeEvent = cast e;
			if( e.arguments.length > 0 ) {
				props.curFbxFile = e.arguments[0];
				// init done ?
				if( inst.axis != null ) {
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