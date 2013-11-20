import flash.Lib;
import h3d.mat.Texture;
import h3d.scene.*;
import haxe.CallStack;
import haxe.io.Bytes;
import hxd.BitmapData;
import hxd.Pixels;
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
		engine.onReady = function() { 
			//if ( engine.onReady != null)
			//	engine.onReady();  
			start();
		};
		
		if( hxd.System.isVerbose) trace("calling engine init");
		engine.init();
		if( hxd.System.isVerbose) trace("calling engine inited");
	}
	
	/*
	function textureLoader( textureName : String , done:Bool->Void ) {
	  var t = engine.mem.allocTexture(512, 512);
	  var mat = new h3d.mat.MeshMaterial(t);
	  loadTexture(textureName, mat , true , done);
	  return mat;
	}
 
	function loadTexture( textureName : String, mat : h3d.mat.MeshMaterial, handleAlpha = true ,done ) {
		var t = mat.texture;
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(_) {
			mat.culling = None;
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
			trace("textureLoaderFbx ->Failed to load " + textureName);
			done(false);
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var bmp = flash.Lib.as(loader.content, flash.display.Bitmap).bitmapData;			
			t.resize(bmp.width, bmp.height);
			t.uploadBitmap(hxd.BitmapData.fromNative(bmp));
			mat.culling = None;
			done(true);
		  });
	}
	*/
 
	
	function start() {
		trace("Start !");
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		if ( hxd.System.isVerbose) trace("prim ok");
		
		//var tex = hxd.Res.load("hxlogo").toTexture();
		
		//var tex = hxd.Res.hxlogo.toTexture();
		//trace(tex);
		
		function onLoaded( bmp : hxd.BitmapData) {
			//var tex :Texture = //engine.mem.allocTexture(bmp.width, bmp.height);
			//tex.uploadBitmap(bmp);
			var tex :Texture = Texture.fromBitmap( bmp);
			//var tex :Texture = Texture.fromColor( 0xFFFF0000);
			if ( hxd.System.isVerbose) trace("getting tex");
			
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.culling = None;
			if ( hxd.System.isVerbose) trace("mat ok");
			
			scene = new Scene();
			
			if ( hxd.System.isVerbose) trace("scene ok");
			
			obj1 = new Mesh(prim, mat, scene);
			obj2 = new Mesh(prim, mat, scene);
			
			if ( hxd.System.isVerbose) trace("mesh ok");
			
			mat.lightSystem = null;
			/*
			mat.lightSystem = {
				ambient : new h3d.Vector(1, 1, 1),
				dirs : [],
				points : [],
				//dirs : [{ dir : new h3d.Vector(-0.3,-0.5,-1), color : new h3d.Vector(1,1,1) }],
				//points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(3,0,0), att : new h3d.Vector(0,0,1) }],
			};
			*/
			if ( hxd.System.isVerbose) trace("light system");
			
			if( hxd.System.isVerbose) trace("try update");
			update();
			
			if( hxd.System.isVerbose) trace("setting loop");
			hxd.System.setLoop(update);
			if ( hxd.System.isVerbose) trace("apps started");
		}
		if ( hxd.System.isVerbose) trace("call load");
		
		if ( lfs.exists("hxlogo.png")) {
			if ( hxd.System.isVerbose) trace("exist load");
			var e = lfs.get("hxlogo.png");
			if ( hxd.System.isVerbose) trace("file entry got");
			e.loadBitmap(onLoaded);
			if ( hxd.System.isVerbose) trace("loadBitmap called");
		}
		else 
			if ( hxd.System.isVerbose) trace("impossible to find bitmap");
			
		if ( hxd.System.isVerbose) trace("called load");
		
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
		
		var bytes = Bytes.alloc(4);
		bytes.set(0, 0xde);
		bytes.set(0, 0xad);
		bytes.set(0, 0xbe);
		bytes.set(0, 0xef);
		
		var p = new Pixels(1, 1, bytes, hxd.PixelFormat.ARGB);
		p.convert( RGBA );
		
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		lfs = new hxd.res.LocalFileSystem('res');
		var it = lfs.getRoot().iterator();
		var e:Dynamic = null;
		do
		{
			e = it.next();
			trace( 'detecting file ${e.name}');
		}
		while ( it.hasNext() );
		new Test();
		
		
	}
	
}