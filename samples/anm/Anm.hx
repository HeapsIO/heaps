import flash.Lib;
import h3d.mat.Texture;
import h3d.scene.*;
import haxe.CallStack;
import haxe.io.Bytes;
import hxd.BitmapData;
import hxd.Pixels;
import hxd.res.Embed;
import hxd.res.EmbedFileSystem;
import hxd.res.LocalFileSystem;

class Anm {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	
	var animMesh  : Mesh;
	var anim : h3d.anim.Animation;
	var curFbx = new h3d.fbx.Library();
	var curData : String;
	
	var obj1 : Mesh;
	
	static public var animMode : h3d.fbx.Library.AnimationMode = LinearAnim;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFF0000FF;
		engine.onReady = start;
		engine.init();
	}
	
	function setSkin() {
		var anim = curFbx.loadAnimation(animMode);
		if( anim != null ) {
			anim = scene.playAnimation(anim);
		}
	}
		
		
	function loadData( data : String, newFbx = true ) {
		curFbx = new h3d.fbx.Library();
		curData = data;
		var fbx = h3d.fbx.Parser.parse(data);
		curFbx.load(fbx);
		var frame = scene == null ? 0 : (scene.currentAnimation == null ? 0 : scene.currentAnimation.frame);
		scene = new h3d.scene.Scene();

		setSkin();
	}
	
	function start() {
		trace("start !");
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.culling = None;
			
			scene = new Scene();
			obj1 = new Mesh(prim, mat, scene);
			
			mat.lightSystem = {
				ambient : new h3d.Vector(0.5, 0.5, 0.5),
				
				dirs : [ 
					{ dir : new h3d.Vector( -0.3, -0.5, -1), color : new h3d.Vector(1, 0.5, 0.5) },
					{ dir : new h3d.Vector( -0.3, -0.5, 1), color : new h3d.Vector(0.0, 0, 1.0) }
				],
				points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(0,1,0), att : new h3d.Vector(0,0,1) }],
				
			};
			
			update();
			hxd.System.setLoop(update);
			
			
			if ( lfs.exists("Skeleton01_anim_attack.FBX") ) {
				var lfbx = lfs.get("Skeleton01_anim_attack.FBX");
				function onFbxLoaded()
				{
					trace("animated file loaded");
					var bytes = lfbx.getBytes();
					curFbx = new h3d.fbx.Library();
					curData = bytes.toString();
					
					trace("animated file prepared");
					var fbx = h3d.fbx.Parser.parse(curData);
					trace("animated file parsed");
					scene.addChild(curFbx.makeObject(function(name, node) {
						return mat;
					}));
					trace("animated file to be skinned");
					setSkin();
					trace("animated file ready");
				}
				lfbx.load(onFbxLoaded);
			}
			else {
				trace("cant find animation file");
			}
		}
		
		
		if ( lfs.exists("checker.png")) {
			lfs.get("checker.png").loadBitmap(onLoaded);
		}
		
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
	
	function update() {	
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		engine.render(scene);
	}
	
	static var lfs: LocalFileSystem;
	static function main() {
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		lfs = new hxd.res.LocalFileSystem('res');
		var it = lfs.getRoot().iterator();//bugs
		var e:Dynamic = null;
		do{
			e = it.next();
			trace( 'detecting file ${e.name}');
		}
		while ( it.hasNext() );
		
		new Anm();
		
		
	}
	
}