using hxd.fmt.fbx.Data;
import hxd.Res;

typedef K = hxd.Key;

typedef Props = {
	curFile:String,
	camPos:Campos,
	smoothing:Bool,
	showAxis:Bool,
	showBones:Bool,
	showBox:Bool,
	speed:Float,
	loop:Bool,
	lights:Bool,
	normals:Bool,
	convertHMD:Bool,
	queueAnims:Bool,
	treeview:Bool,
	checker:Bool,
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
	var curHmd : hxd.fmt.hmd.Library;
	static public var loadAnim = true;
	static public var curData : haxe.io.Bytes;
	static public var curDataSize : Int;
	static public var props : Props;

	var light : h3d.scene.DirLight;
	var rightHand : Bool;
	var playAnim : Bool;
	var rightClick : Bool;
	var freeMove : Bool;
	var pMouse : h2d.col.Point;
	var axis : h3d.scene.Graphics;
	var box : h3d.scene.Object;
	var alib : hxd.fmt.fbx.Library;
	var ahmd : hxd.fmt.hmd.Library;

	var tree : TreeView;
	var checker : h3d.scene.Mesh;
	var infos : { tri : Int, objs : Int, verts : Int};

	function new() {
		super();

		pMouse = new h2d.col.Point();
		obj = new h3d.scene.Object();

		rightHand = false;
		playAnim = true;
		freeMove = false;
		rightClick = false;

		props = {
			curFile : "",
			camPos : { x:10, y:0, z:0, tx:0, ty:0, tz:0 },
			smoothing:true,
			showAxis:true, showBones:false, showBox:false,
			speed:1., loop:true,
			lights : true, normals : false,
			convertHMD : false,
			queueAnims:false,
			treeview:true,
			checker:false,
		};
		props = hxd.Save.load(props);
		props.speed = 1;

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

		light = new h3d.scene.DirLight(new h3d.Vector(-4, -3, -10), s3d);
		var shadows = Std.instance(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadows.power = 10;

		if( props.curFile != null )
			loadFile(props.curFile, false);
		else
			askLoad();

		if( props.showAxis )
			s3d.addChild(axis);
		else
			s3d.removeChild(axis);
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
			case 1:
				freeMove = true;
			case 0:
				rightClick = true;
			}
		case ERelease:
			switch( e.button ) {
			case 1:
				freeMove = false;
			case 0:
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
		s3d.camera.follow = null;
		save();
	}

	function onKey( e : hxd.Event ) {
		var reload = false;
		var cam = s3d.camera;

		switch( e.keyCode ) {
		case K.LEFT :
			var d = hxd.Math.distance(light.direction.x, light.direction.y);
			var a = Math.atan2(light.direction.y, light.direction.x) + 0.1;
			light.direction.x = d * Math.cos(a);
			light.direction.y = d * Math.sin(a);
		case K.RIGHT :
			var d = hxd.Math.distance(light.direction.x, light.direction.y);
			var a = Math.atan2(light.direction.y, light.direction.x) - 0.1;
			light.direction.x = d * Math.cos(a);
			light.direction.y = d * Math.sin(a);

		case K.NUMPAD_ADD:
			props.speed = Math.min(10, props.speed * 1.2);
		case K.NUMPAD_SUB:
			props.speed = Math.max(0, props.speed / 1.2);
		case K.F1:
			askLoad();
		case K.F2:
			askLoad(true);
		case "S".code if( K.isDown(K.CTRL) ):
			if( curHmd != null ) {
				var h = curHmd.header;
				h.data = curHmd.getData();
				var data = hxd.fmt.hmd.Dump.toString(h);
				var path = props.curFile.substr(0, -4) + "_dump.txt";
				hxd.File.saveAs(haxe.io.Bytes.ofString(data), { defaultPath : path } );
			}
			if( curFbx != null ) {
				var data = FbxTree.toXml(curFbx.getRoot());
				var path = props.curFile.substr(0, -4) + "_tree.xml";
				hxd.File.saveAs(haxe.io.Bytes.ofString(data), { defaultPath : path } );
			}
		case "O".code:
			props.treeview = !props.treeview;
			if(tree != null)
				tree.visible = props.treeview;
		case "G".code:
			props.checker = !props.checker;
			showChecker(props.checker);

		case "R".code:
			if( props.convertHMD ) return;
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
		case "F".code if( K.isDown(K.CTRL) ):
			engine.fullScreen = !engine.fullScreen;
		case "F".code:
			resetCamera();
		case "H".code:
			tf_keys.visible = !tf_keys.visible;
		case K.SPACE, "P".code:
			if(props.speed != 0)
				props.speed = 0;
			else props.speed = 1;
		case "S".code:
			if( hxd.Key.isDown(hxd.Key.SHIFT) )
				props.speed *= 0.5;
			else if( hxd.Key.isDown(hxd.Key.CTRL) )
				props.speed *= 2;
			else
				props.speed = props.speed == 1 ? 0.1 : 1;
		case "A".code:
			loadAnim = !loadAnim;
			reload = true;
		case "L".code:
			props.loop = !props.loop;
			reload = true;
		case "I".code:
			props.lights = !props.lights;
			setMaterial();
		case "C".code:
			props.convertHMD = !props.convertHMD;
			if( props.convertHMD ) rightHand = false;
			reload = true;
		case "Q".code:
			props.queueAnims = !props.queueAnims;
		default:

		}

		if( reload && curData != null )
			loadData(curData);

		save();
	}

	function loadFile( file : String, newFbx = true ) {
		props.curFile = file;
		var l = new flash.net.URLLoader();
		l.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
		l.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
			if( newFbx ) haxe.Log.trace("Failed to load " + file,null);
		});
		l.addEventListener(flash.events.Event.COMPLETE, function(_) {
			loadData(haxe.io.Bytes.ofData(l.data));
			resetCamera();
			if( newFbx )
				save();
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
		var texBasePath = textureName.split("\\").join("/").split("/");
		var fileBasePath = props.curFile.split("\\").join("/").split("/");
		var texFile = texBasePath.pop();
		fileBasePath.pop();
		function onError(_) {
			if( texBasePath.join("/") != fileBasePath.join("/") ) {
				fileBasePath.push(texFile);
				loadTexture(fileBasePath.join("/"), mat, handleAlpha);
			} else
				mat.mainPass.culling = None;
		}
		if( textureName.split(".").pop().toLowerCase() == "png" && handleAlpha ) {
			var loader = new flash.net.URLLoader();
			loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
			loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onError);
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
			loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onError);
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
				if( anim ) {
					if( props.convertHMD || bytes.get(0) == 'H'.code ) {
						ahmd = fbxToHmd(bytes, false).toHmd();
					} else {
						alib = new hxd.fmt.fbx.Library();
						var fbx = hxd.fmt.fbx.Parser.parse(bytes.toString());
						alib.load(fbx);
						if( !rightHand )
							alib.leftHandConvert();
					}
					setAnim();
				} else {
					alib = null;
					ahmd = null;
					props.curFile = sel.fileName;
					loadData(bytes);
					resetCamera();
					save();
				}
			});
		},{ fileTypes : [{ name : "Model File", extensions : ["fbx","hmd"] }], defaultPath : props.curFile });
	}

	function fbxToHmd( data : haxe.io.Bytes, includeGeometry ) {

		// already hmd
		if( data.get(0) == 'H'.code )
			return hxd.res.Any.fromBytes("model.hmd", data);

		var hmdOut = new hxd.fmt.fbx.HMDOut();
		hmdOut.absoluteTexturePath = true;
		hmdOut.loadTextFile(data.toString());
		var hmd = hmdOut.toHMD(null, includeGeometry);
		var out = new haxe.io.BytesOutput();
		new hxd.fmt.hmd.Writer(out).write(hmd);
		var bytes = out.getBytes();
		return hxd.res.Any.fromBytes("model.hmd", bytes);
	}

	function loadData( data : haxe.io.Bytes ) {

		curData = data;
		curDataSize = data.length;

		obj.remove();

		curFbx = null;
		curHmd = null;

		if( props.convertHMD || data.get(0) == 'H'.code ) {

			var res = fbxToHmd(data, true);
			curDataSize = res.entry.getBytes().length;
			curHmd = res.toHmd();

			obj = curHmd.makeObject(function(name) {
				var t = new h3d.mat.Texture(1, 1);
				t.clear(0xFF00FF);
				loadTexture(name, new h3d.mat.MeshMaterial(t));
				return t;
			});

			for( m in obj.getMaterials() ) {
				var t = m.mainPass.getShader(h3d.shader.Texture);
				m.mainPass.culling = None;
				if( t != null) {
					t.killAlpha = true;
					if( !t.texture.flags.has(IsNPOT) ) t.texture.wrap = Repeat;
				}
				if( m.mainPass.blendDst == Zero ) m.mainPass.blend(SrcAlpha, OneMinusSrcAlpha);
			}

		} else {

			curFbx = new hxd.fmt.fbx.Library();
			curFbx.unskinnedJointsAsObjects = true;
			var fbx = hxd.fmt.fbx.Parser.parse(data.toString());
			curFbx.load(fbx);
			if( !rightHand )
				curFbx.leftHandConvert();

			obj = curFbx.makeObject(textureLoader);

		}

		s3d.addChild(obj);
		infos = getInfos(obj);

		//
		var b = obj.getBounds();

		var dx = b.xMax - b.xMin;
		var dy = b.yMax - b.yMin;

		box = new h3d.scene.Box(0xFFFF9910);

		TreeView.init(s2d);
		tree = new TreeView(obj);
		tree.x = 0;
		tree.y = 0;
		tree.visible = props.treeview;

		setMaterial();
		setAnim();

		for( m in obj.getMaterials() )
			m.shadows = true;

		showChecker(props.checker);

		save();
	}

	function getInfos(obj : h3d.scene.Object) {
		var tri = 0, objs = 0, verts = 0;
		function getObjectsRec( o : h3d.scene.Object) {
			objs++;
			if(o.isMesh()) {
				tri += o.toMesh().primitive.triCount();
				verts += o.toMesh().primitive.vertexCount();
			}
			for( e in o )
				getObjectsRec(e);
		}
		getObjectsRec(obj);
		return { tri : tri, objs : objs, verts : verts };
	}

	function showChecker(b : Bool) {
		if(!b) {
			if(checker != null)
				checker.remove();
			return;
		}

		if(checker == null) {
			var w = 10;
			var p = new h3d.prim.Cube(w, w, 0);
			p.unindex();
			p.addNormals();
			p.addUVs();
			for( v in p.uvs ) {
				v.u *= 1.25;
				v.v *= 1.25;
			}
			p.translate( -w * 0.5, -w * 0.5, 0);

			checker = new h3d.scene.Mesh(p, s3d);
			checker.material.texture = Res.checker.toTexture();
			checker.material.texture.wrap = Repeat;
			checker.material.shadows = true;
		}
		s3d.addChild(checker);
	}

	function getCamerasRec( o : h3d.scene.Object, cam : Array<h3d.scene.Object> ) {
		if( o.name != null && StringTools.startsWith(o.name, "Camera") && o.name.indexOf(".Target") < 0 )
			cam.push(o);
		for( s in o )
			getCamerasRec(s, cam);
	}

	function resetCamera() {

		var b = obj.getBounds();
		var dx = Math.max(Math.abs(b.xMax),Math.abs(b.xMin));
		var dy = Math.max(Math.abs(b.yMax),Math.abs(b.yMin));
		var dz = Math.max(Math.abs(b.zMax),Math.abs(b.zMin));
		var dist = Math.max(Math.max(dx * 6, dy * 6), dz * 4);
		var ang = Math.PI / 4;
		var zang = Math.PI * 0.4;
		s3d.camera.pos.set(Math.sin(zang) * Math.cos(ang) * dist, Math.sin(zang) * Math.sin(ang) * dist, Math.cos(zang) * dist);
		s3d.camera.target.set(0, 0, (b.zMax + b.zMin) * 0.5);

		var c = b.getCenter();
		box.x = c.x;
		box.y = c.y;
		box.z = c.z;

		s3d.camera.fovY = 25;
		s3d.camera.follow = null;

		var cameras = [];
		getCamerasRec(obj, cameras);
		if( cameras.length == 1 && curHmd != null ) {
			var c = cameras[0];
			var t = obj.getObjectByName(c.name+".Target");
			s3d.camera.fovY = curHmd.getModelProperty(c.name, CameraFOVY(0), 25);
			s3d.camera.follow = { pos : c, target : t };
		}
	}

	function setMaterial( ?o : h3d.scene.Object ) {
		if( o == null )
			o = obj;
		if( o.isMesh() ) {
			var m = o.toMesh();
			var materials = [m.material];
			var multi = Std.instance(m, h3d.scene.MultiMaterial);
			if( multi != null ) materials = multi.materials;
			for( m in materials ) {
				if( m == null ) continue;
				if( m.texture != null )
					m.texture.filter = props.smoothing ? Linear : Nearest;
				m.mainPass.enableLights = props.lights;
			}
			var s = Std.instance(o, h3d.scene.Skin);
			if( s != null )
				s.showJoints = props.showBones;
			if(tree != null)
				tree.showJoints = props.showBones;
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
		var anim;
		if( !loadAnim )
			anim = null;
		else if( curHmd != null )
			anim = (ahmd == null ? curHmd : ahmd).loadAnimation();
		else
			anim = curFbx.loadAnimation(null, null, alib);
		if( anim == null )
			return;
		var prev = s3d.currentAnimation;
		anim = s3d.playAnimation(anim);
		anim.onEvent = function(e:String) {
			var param = null;
			var name = e;
			if( StringTools.endsWith(e, ")") ) {
				var f = e.split("(");
				name = f[0];
				param = f[1].substr(0, -1);
				if( param == "" ) param = null;
			}
			switch( name ) {
			case "camera":
				if( param == null )
					s3d.camera.follow = null;
				else {
					var o = s3d.getObjectByName(param);
					var t = s3d.getObjectByName(param + ".Target");
					if( o == null || t == null )
						trace("Camera not found " + param);
					else {
						s3d.camera.follow = { pos : o, target : t };
						s3d.camera.fovY = curHmd.getModelProperty(param, CameraFOVY(0), 25);
					}
				}
			default:
				trace("EVENT @"+anim.frame+" : "+e);
			}
		};
		if( !props.loop ) {
			anim.loop = false;
			anim.onAnimEnd = function() anim.setFrame(0);
		}
		if( props.queueAnims && prev != null ) {
			var sm = new h3d.anim.SmoothTarget(anim, (anim.frameCount * 0.3) / 60 );
			sm.onAnimEnd = function() {
				if( s3d.currentAnimation != sm ) return;
				s3d.switchToAnimation(anim);
			};
			s3d.switchToAnimation(sm);
		}
	}

	override function update( dt : Float ) {
		var cam = s3d.camera;

		if(tree != null)
			tree.update(dt);

		//FREE MOUSE MOVE
		if (freeMove) {
			var dx = (s2d.mouseX - pMouse.x) * 0.01;
			var dy = (s2d.mouseY - pMouse.y) * 0.01;

			if( dx != 0 || dy != 0 )
				cam.follow = null;

			var d = cam.pos.sub(cam.target);
			var dist = d.length();
			var r = Math.acos(d.z / dist);
			r -= dy * cam.up.z;
			r = Math.max(0.0001, Math.min(Math.PI - 0.0001, r));
			var k = Math.atan2(d.y, d.x);
			k += dx * cam.up.z;

			cam.pos.set(cam.target.x + Math.sin(r) * Math.cos(k) * dist, cam.target.y + Math.sin(r) * Math.sin(k) * dist, cam.target.z + Math.cos(r) * dist);
			pMouse.set(s2d.mouseX, s2d.mouseY);
		}
		else if (rightClick) {

			var dx = (pMouse.x - s2d.mouseX) / s2d.width;
			var dy = (pMouse.y - s2d.mouseY) / s2d.height;
			if( dx != 0 || dy != 0 )
				cam.follow = null;

			var d : h3d.Vector = cam.pos.sub(cam.target);
			var dist = d.length();

			dx *= dist;
			dy *= dist;

			d.normalize();
			var left = d.cross(cam.up);
			var up = left.cross(d);

			left.scale3(dx);
			up.scale3(dy);

			cam.pos = cam.pos.add(left).sub(up);
			cam.target = cam.target.add(left).sub(up);

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
			"[A] Animation = " + loadAnim,
			"[L] Loop = "+props.loop,
			"[Y] Axis = "+props.showAxis,
			"[K] Bones = "+props.showBones,
			"[B] Bounds = "+props.showBox+(box == null ? "" : " ["+fmt(box.scaleX)+" x "+fmt(box.scaleY)+" x "+fmt(box.scaleZ)+"]"),
			"[S] Slow Animation",
			"[+/-] Speed Animation = "+props.speed,
			"[R] Right-Hand Camera = "+rightHand,
			"[M] Tex Smoothing = " + props.smoothing,
			"[N] Show normals = "+props.normals,
			"[I] Lights = " + props.lights,
			"[C] Use HMD model = " + props.convertHMD,
			"[Q] Queue anims = "+props.queueAnims,
			"[O] Show objects = "+props.treeview,
			"[G] Show ground = "+props.checker,
			"",
			"[F] Default camera",
			"[Space/P] Pause Animation",
			"[LMB + Move] Rotation",
			"[RMB + Move] translation",
			"[Wheel] Zoom"
		].join("\n");
		tf_keys.y = s2d.height - tf_keys.textHeight - 35;

		var file = props.curFile == null ? "<empty>" : props.curFile.split("/").pop().split("\\").pop();
		if( props.convertHMD && StringTools.endsWith(file.toLowerCase(), ".fbx") )
			file = file.substr(0, -3) + "hmd";

		file += " (" + Math.ceil(curDataSize / 1024) + "KB)";
		tf.text = [
			(cam.rightHanded ? "R " : "") + fmt(hxd.Timer.fps()),
			"speed : " + hxd.Math.fmt(props.speed),
			file,
			infos != null ? infos.tri + " tri  /  " + infos.objs + " obj  /  " + infos.verts + " vert" : "",
		].join("\n");

		hxd.Timer.tmod *= props.speed;
	}

	static var inst : Viewer;

	static function initAIR() {
		#if air3
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.InvokeEvent.INVOKE, function(e:Dynamic) {
			var e : flash.events.InvokeEvent = cast e;
			if( e.arguments.length > 0 ) {
				props.curFile = e.arguments[0];
				// init done ?
				if( inst.axis != null ) {
					inst.loadFile(props.curFile);
					flash.desktop.NativeApplication.nativeApplication.openedWindows[0].activate();
				}
			}
		});
		var drag = new flash.display.Sprite();
		drag.graphics.beginFill(0, 0);
		drag.graphics.drawRect(0, 0, 4000, 4000);
		flash.Lib.current.addChild(drag);
		drag.addEventListener(flash.events.NativeDragEvent.NATIVE_DRAG_ENTER, function(e:Dynamic) {
			var e : flash.events.NativeDragEvent = cast e;
			if( e.clipboard.hasFormat(FILE_LIST_FORMAT) && e.clipboard.getData(FILE_LIST_FORMAT).length == 1 )
				flash.desktop.NativeDragManager.acceptDragDrop(drag);
		});
		drag.addEventListener(flash.events.NativeDragEvent.NATIVE_DRAG_DROP, function(e:Dynamic) {
			var e : flash.events.NativeDragEvent = cast e;
			if( e.clipboard.hasFormat(FILE_LIST_FORMAT) ) {
				var a : Array<flash.filesystem.File> = e.clipboard.getData(FILE_LIST_FORMAT);
				props.curFile = a[0].nativePath;
				inst.loadFile(props.curFile);
			}
		});
		#end
	}

	static function main() {
		hxd.Res.initEmbed();
		inst = new Viewer();
		if( flash.system.Capabilities.playerType == "Desktop" )
			initAIR();
	}

}