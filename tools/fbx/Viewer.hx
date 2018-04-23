using hxd.fmt.fbx.Data;
import hxd.Res;

typedef K = hxd.Key;

typedef Props = {
	curFile:String,
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
	materials:Bool,
}

class Viewer extends hxd.App {

	var obj : h3d.scene.Object;
	var anim : h3d.anim.Animation;
	var tf : h2d.Text;
	var tf_keys : h2d.Text;
	var tf_help : h2d.Text;

	var curFbx : hxd.fmt.fbx.Library;
	var curHmd : hxd.fmt.hmd.Library;
	static public var loadAnim = true;
	static public var curData : haxe.io.Bytes;
	static public var curDataSize : Int;
	static public var props : Props;

	var light : h3d.scene.DirLight;
	var rightHand : Bool;
	var playAnim : Bool;
	var axis : h3d.scene.Graphics;
	var box : h3d.scene.Object;
	var alib : hxd.fmt.fbx.Library;
	var ahmd : hxd.fmt.hmd.Library;
	var freezeCamera : Bool;

	var tree : TreeView;
	var checker : h3d.scene.Mesh;
	var infos : { tri : Int, objs : Int, verts : Int};
	var reload : Array<Void -> Void> = [];

	var ctrl : h3d.scene.CameraController;

	function new() {
		super();

		obj = new h3d.scene.Object();

		rightHand = false;
		playAnim = true;

		props = {
			curFile : "",
			smoothing:true,
			showAxis:true, showBones:false, showBox:false,
			speed:1., loop:true,
			lights : true, normals : false,
			convertHMD : true,
			queueAnims:false,
			treeview:true,
			checker:false,
			materials:false,
		};
		props = hxd.Save.load(props);
		props.speed = 1;
	}

	function save() {
		hxd.Save.save(props);
	}

	override function init() {
		engine.debug = true;
		engine.backgroundColor = 0xFF808080;
		ctrl = new h3d.scene.CameraController(s3d);
		s2d.addEventListener(onEvent);

		var font = hxd.res.DefaultFont.get();
		tf = new h2d.Text(font, s2d);
		tf.textAlign = Right;
		tf.maxWidth = 200;
		tf.x = s2d.width - (tf.maxWidth + 5);
		tf.y = 5;
		tf.textColor = 0xFFFFFF;

		tf_keys = new h2d.Text(font, s2d);
		tf_keys.x = 5;
		tf_keys.visible = false;

		tf_help = new h2d.Text(font, s2d);
		tf_help.x = 5;
		tf_help.text = "[H] Show/Hide keys";

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

		if( props.curFile != null )
			loadFile(props.curFile, false);
		else
			askLoad();

		if( props.showAxis )
			s3d.addChild(axis);
		else
			s3d.removeChild(axis);


		initConsole();
		onResize();
	}

	override function onResize() {
		tf.x = s2d.width - (tf.maxWidth + 5);
		tf_help.y = s2d.height - 35;
		tf_keys.y = s2d.height - tf_keys.textHeight - 35;
		tf_keys.x = tf_help.x = s2d.width - 250;
	}

	function onEvent( e : hxd.Event ) {
		switch( e.kind ) {
		case EKeyDown:
			onKey(e);
		default:
		}
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
		case K.F5:
			var old = this.reload;
			this.reload = [];
			for( f in old ) f();
			return;
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
			var over = TreeView.currentOver;
			if( over != null ) {
				over.onKey(e);
				tree.draw();
			}
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
			if( !freezeCamera )
				resetCamera();
			if( newFbx )
				save();
		});
		l.load(new flash.net.URLRequest(file));
	}

	function textureLoader( textureName : String, matData : FbxNode ) {
		var t = new h3d.mat.Texture(1, 1);
		t.clear(0xFF0000);
		var mat = new h3d.mat.Material(t);
		loadTexture(textureName, mat);
		mat.mainPass.getShader(h3d.shader.Texture).killAlpha = true;
		mat.mainPass.blend(SrcAlpha, OneMinusSrcAlpha);
		for( p in matData.getAll("Properties70.P") )
			if( p.props[0].toString() == "TransparencyFactor" && p.props[4].toFloat() < 0.999 ) {
				mat.blendMode = Add;
				break;
			}
		return mat;
	}

	function loadTexture( textureName : String, mat : h3d.mat.Material, handleAlpha = true ) {
		var t = mat.texture;
		var texBasePath = textureName.split("\\").join("/").split("/");
		var fileBasePath = props.curFile.split("\\").join("/").split("/");
		var texFile = texBasePath.pop();
		fileBasePath.pop();
		function onError(_) {
			if( texBasePath.join("/") != fileBasePath.join("/") ) {
				fileBasePath.push(texFile);
				loadTexture(fileBasePath.join("/"), mat, handleAlpha);
			}
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
				t.wrap = t.flags.has(IsNPOT) ? Clamp : Repeat;
				t.uploadPixels(new hxd.Pixels(size.width, size.height, pixels, BGRA));
				reload.push(loadTexture.bind(textureName, mat, handleAlpha));
			});
			loader.load(new flash.net.URLRequest(textureName));
		} else {
			var loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
				var bmp = flash.Lib.as(loader.content, flash.display.Bitmap).bitmapData;
				t.resize(bmp.width, bmp.height);
				t.wrap = t.flags.has(IsNPOT) ? Clamp : Repeat;
				t.uploadBitmap(hxd.BitmapData.fromNative(bmp));
				reload.push(loadTexture.bind(textureName, mat, handleAlpha));
			});
			loader.load(new flash.net.URLRequest(textureName));
		}
	}

	function askLoad( ?anim ) {
		hxd.File.browse(function(sel) {
			sel.load(function(bytes) {
				haxe.Log.clear();
				reload = [];
				if( anim ) {
					if( props.convertHMD || bytes.get(0) == 'H'.code ) {
						ahmd = fbxToHmd(bytes, false).toModel().toHmd();
					} else {
						alib = new hxd.fmt.fbx.Library(sel.fileName);
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
					if( !freezeCamera )
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

		var hmdOut = new hxd.fmt.fbx.HMDOut("");
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
			curHmd = res.toModel().toHmd();

			obj = curHmd.makeObject(function(name) {
				var t = new h3d.mat.Texture(1, 1);
				t.clear(0xFF00FF);
				t.wrap = Repeat;
				t.setName(name);
				loadTexture(name, new h3d.mat.Material(t));
				return t;
			});

		} else {

			curFbx = new hxd.fmt.fbx.Library("");
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

		initTree();

		setMaterial();
		setAnim();
		showChecker(props.checker);

		save();
	}

	function initTree() {
		TreeView.init(s2d);
		tree = new TreeView(obj);
		tree.x = 0;
		tree.y = 0;
		tree.visible = props.treeview;
	}

	function getInfos(obj : h3d.scene.Object) {
		var tri = 0, objs = 0, verts = 0;
		function getObjectsRec( o : h3d.scene.Object) {

			// auto hide meshes with special names
			if( o.name != null && (o.name.toLowerCase().indexOf("selection") != -1 || o.name.toLowerCase().indexOf("collide") != -1) ) {
				var mats = o.getMaterials();
				if( o.numChildren == 0 && mats.length == 1 && Std.instance(mats[0], h3d.mat.Material).texture == null )
					o.visible = false;
			}

			if( !o.visible ) return;

			objs++;

			if( o.isMesh() ) {
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
		ctrl.loadFromCamera();

		var c = b.getCenter();
		box.x = c.x;
		box.y = c.y;
		box.z = c.z;

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
		if( o == null ) {
			o = obj;

			var v = props.lights ? 1 : 0;
			light.color.set(v, v, v, 1);
			var v = props.lights ? 0.5 : 1;
			s3d.lightSystem.ambientLight.set(v, v, v, 1);

			var shadows = s3d.renderer.getPass(h3d.pass.ShadowMap);
			shadows.power = 10;
			var v = props.lights ? 0.2 : 1;
			shadows.color.set(v, v, v, 1);
		}

		if( o.isMesh() ) {
			var m = o.toMesh();
			var materials = [m.material];
			var multi = Std.instance(m, h3d.scene.MultiMaterial);
			if( multi != null ) materials = multi.materials;
			for( m in materials ) {
				if( m == null ) continue;
				if( m.texture != null ) {
					m.texture.filter = props.smoothing ? Linear : Nearest;
					m.textureShader.killAlpha = true;
					m.textureShader.killAlphaThreshold = 0.5;
				}
				m.mainPass.culling = None;
			}
			var s = Std.instance(o, h3d.scene.Skin);
			if( s != null )
				s.showJoints = props.showBones;
			if(tree != null)
				tree.showJoints = props.showBones;
			if( props.normals ) {
				if( m.name != "__normals__" ) {
					var buf = try m.primitive.buildNormalsDisplay() catch( e : Dynamic ) null;
					if( buf != null ) {
						var n = new h3d.scene.Mesh(buf, m);
						n.material.color.set(0, 0, 1);
						n.material.mainPass.culling = None;
						n.material.mainPass.addShader(new h3d.shader.LineShader()).lengthScale = 0.2;
						n.name = "__normals__";
					}
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

	function initConsole() {

		function reload() {
			if( curData != null ) loadData(curData);
		}

		var console = new h2d.Console(hxd.res.DefaultFont.get(), s2d);
		console.addCommand("materials", [], function() {
			props.materials = !props.materials;
			save();
			initTree();
		});
		console.addCommand("axis", [], function() {
			props.showAxis = !props.showAxis;
			if( props.showAxis )
				s3d.addChild(axis);
			else
				s3d.removeChild(axis);
			save();
		});
		console.addCommand("righthand", [], function() {
			if( props.convertHMD ) {
				console.log("Only in FBX");
				return;
			}
			rightHand = !rightHand;
			s3d.camera.pos.x *= -1;
			s3d.camera.target.x *= -1;
			reload();
		});

		console.addCommand("normals", [], function() {
			props.normals = !props.normals;
			save();
			setMaterial();
		});

		console.addCommand("freezeCamera", [], function() {
			freezeCamera = !freezeCamera;
			ctrl.visible = !freezeCamera;
		});

		console.addCommand("ground", [], function() {
			props.checker = !props.checker;
			save();
			showChecker(props.checker);
		});

		console.addCommand("joints", [], function() {
			props.showBones = !props.showBones;
			save();
			setMaterial();
		});

		console.addCommand("smooth", [], function() {
			props.smoothing = !props.smoothing;
			save();
			setMaterial();
		});
	}

	override function update( dt : Float ) {

		if(tree != null)
			tree.update(dt);


		s3d.camera.rightHanded = rightHand;

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
			"[B] Bounds = "+props.showBox+(box == null ? "" : " ["+fmt(box.scaleX)+" x "+fmt(box.scaleY)+" x "+fmt(box.scaleZ)+"]"),
			"[S] Slow Animation",
			"[+/-] Speed Animation = "+Std.int(props.speed*100)+"%",
			"[I] Lights = " + props.lights,
			"[C] Use HMD model = " + props.convertHMD,
			"[Q] Queue anims = "+props.queueAnims,
			"[O] Show/Hide treeview = "+props.treeview,
			"[V] Show/Hide selected object",
			"[T] Change material texture",
			"[F] Default camera",
			"[Space/P] Pause Animation",
			"[LMB + Move] Rotation",
			"[RMB + Move] Translation",
			"[Wheel] Zoom"
		].join("\n");
		tf_keys.y = s2d.height - tf_keys.textHeight - 35;

		var file = props.curFile == null ? "<empty>" : props.curFile.split("/").pop().split("\\").pop();
		if( props.convertHMD && StringTools.endsWith(file.toLowerCase(), ".fbx") )
			file = file.substr(0, -3) + "hmd";

		file += " (" + Math.ceil(curDataSize / 1024) + "KB)";
		tf.text = [
			(s3d.camera.rightHanded ? "R " : "") + fmt(hxd.Timer.fps()),
			"speed : " + hxd.Math.fmt(props.speed),
			file,
			infos != null ? infos.tri + " tri  /  " + infos.objs + " obj  /  " + infos.verts + " vert" : "",
		].join("\n");

		hxd.Timer.tmod *= props.speed;
	}

	public static var inst : Viewer;

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