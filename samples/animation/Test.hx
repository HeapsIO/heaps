import flash.Lib;
import flash.ui.Keyboard;
import h3d.impl.Shaders.LineShader;
import h3d.impl.Shaders.PointShader;
import h3d.mat.Material;
import h3d.mat.Texture;
import h3d.scene.Scene;
import h3d.scene.Mesh;
import h3d.Vector;
import haxe.CallStack;
import haxe.io.Bytes;
import hxd.BitmapData;
import hxd.Pixels;
import hxd.res.Embed;
import hxd.res.EmbedFileSystem;
import hxd.res.LocalFileSystem;
import hxd.System;
import mt.flash.Key;
import openfl.Assets;

class Axis implements h3d.IDrawable {

	public function new() {
	}
	
	public function render( engine : h3d.Engine ) {
		engine.line(0,0,0,0,2,0, 0xFFFF0000);
	}
	
}

class LineMaterial extends Material{
	var lshader : LineShader;

	public var start(get,set) : h3d.Vector;
	public var end(get,set) : h3d.Vector;
	public var color(get,set) : Int;
	
	public function new() {
		lshader = new LineShader();
		super(lshader);
		depthTest = h3d.mat.Data.Compare.Always;
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		lshader.mproj = ctx.camera.m;
	}
	
	public inline function get_start() return lshader.start;
	public inline function set_start(v) return lshader.start = v;
	
	public inline function get_end() return lshader.end;
	public inline function set_end(v) return lshader.end = v;
	
	public inline function get_color() return lshader.color;
	public inline function set_color(v) return lshader.color=v;
}

class Test {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFF20FF20;
		engine.onReady = start;
		engine.init();
		Key.init();
	}
	
	
	function addLine(start,end,?col=0xFFffffff, ?size) {
		var mat = new LineMaterial();
		var line = new h3d.scene.CustomObject(new h3d.prim.Plan2D(), mat, scene);
		line.material.blend(SrcAlpha, OneMinusSrcAlpha);
		line.material.depthWrite = false;
		line.material.culling = None;
		
		mat.start = start;
		mat.end = end;
		mat.color = 0xFFFF00FF;
	}	
	
	var loadedMat :  h3d.mat.MeshMaterial;
	function start() {
		trace("start !");
		trace("prim ok");
		scene = new Scene();
		addLine( new Vector(0, 0, 0), new Vector(1, 1, 1) );
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			loadedMat = new h3d.mat.MeshMaterial(tex);
			var mat = loadedMat;
			mat.culling = None;
			mat.lightSystem = null;
			/*
			mat.lightSystem = {
				ambient : new h3d.Vector(0.5, 0.5, 0.5),
				
				dirs : [ 
					{ dir : new h3d.Vector( -0.3, -0.5, -1), color : new h3d.Vector(1, 0.5, 0.5) },
					{ dir : new h3d.Vector( -0.3, -0.5, 1), color : new h3d.Vector(0.0, 0, 1.0) }
				],
				points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(0,1,0), att : new h3d.Vector(0,0,1) }],
				
			};
			*/
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
			
			trace("bitmap Loaded");
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
		
		var axis = new Axis();
		scene.addPass(axis);
		
		loadFbx();
	}
	
	/*
	function fileLength(f : sys.io.FileInput)
	{
		var cur = f.tell();
		f.seek( 0,sys.io.FileSeek.SeekEnd );
		var len = f.tell();
		f.seek( cur, sys.io.FileSeek.SeekBegin );
		return len;
	}
	*/
	
	function loadFbx()
	{
		//var file = sys.io.File.read("assets/Cheveux.FBX", true);
		//var len = fileLength( file );
		//var file = Assets.getText("assets/Skeleton01_anim_attack.FBX");
		var file = Assets.getText("assets/Cheveux.FBX");
		loadData(file);
	}
	
	var curFbx : h3d.fbx.Library=null;
	var curData : String = "";
	
	function loadData( data : String, newFbx = true ) {
		curFbx = new h3d.fbx.Library();
		curData = data;
		var fbx = h3d.fbx.Parser.parse(data);
		curFbx.load(fbx);
		var frame = 0;
		scene.addChild(curFbx.makeObject( function(str, mat) {
			var tex = Texture.fromBitmap( BitmapData.fromNative(Assets.getBitmapData("assets/checker.png",false)) );
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.culling = None;
			mat.lightSystem = null;
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
			return mat;
		}));
		
		
		setSkin();
	}
	
	static public var animMode : h3d.fbx.Library.AnimationMode = LinearAnim;
	function setSkin() {
		
		var anim = curFbx.loadAnimation(animMode);
		if( anim != null ) {
			anim = scene.playAnimation(anim);
		}
		
		
	}
	
	function update() {	
		var dist = 10;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		engine.render(scene);
		
		if ( Key.isDown(Keyboard.ENTER) ) {
			for ( c in scene.childs ) {
				if( Std.is(c,Mesh)){
					trace( c + " is a mesh" );
				}
			}
		}
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