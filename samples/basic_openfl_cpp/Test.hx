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

class Test {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	var obj1 : Mesh;
	var obj2 : Mesh;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFF202020;
		engine.onReady = start;
		engine.init();
	}
	
	function start() {
		trace("start !");
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		if ( hxd.System.isVerbose) trace("prim ok");
		
		//var tex = hxd.Res.load("hxlogo").toTexture();
		
		//var tex = hxd.Res.hxlogo.toTexture();
		//trace(tex);
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.culling = None;
			
			scene = new Scene();
			
			obj1 = new Mesh(prim, mat, scene);
			obj2 = new Mesh(prim, mat, scene);
			
			mat.lightSystem = null;
			
			mat.lightSystem = {
				ambient : new h3d.Vector(0.5, 0.5, 0.5),
				//dirs : [],
				//points : [],
				
				dirs : [ 
					{ dir : new h3d.Vector( -0.3, -0.5, -1), color : new h3d.Vector(1, 0.5, 0.5) },
					{ dir : new h3d.Vector( -0.3, -0.5, 1), color : new h3d.Vector(0.0, 0, 1.0) }
				],
				points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(0,1,0), att : new h3d.Vector(0,0,1) }],
				
			};
			
			
			update();
			hxd.System.setLoop(update);
		}
		
		#if sys
		if ( lfs.exists("hxlogo.png")) {
			lfs.get("hxlogo.png").loadBitmap(onLoaded);
		}
		#else 
			//erk
			onLoaded(hxd.Res.hxlogo.toBitmap());
		#end
	}
	
	function update() {	
		
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		obj2.setRotateAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
		engine.render(scene);
	}
	
	static var lfs: LocalFileSystem;
	static function main() {
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		#if flash
			EmbedFileSystem.init();
		#else
			lfs = new hxd.res.LocalFileSystem('res');
			var it = lfs.getRoot().iterator();//bugs
			var e:Dynamic = null;
			do
			{
				e = it.next();
				trace( 'detecting file ${e.name}');
			}
			while ( it.hasNext() );
		#end
		new Test();
		
		
	}
	
}