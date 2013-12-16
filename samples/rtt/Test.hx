import flash.Lib;
import flash.ui.Keyboard;
import h2d.Bitmap;
import h3d.impl.Shaders.LineShader;
import h3d.impl.Shaders.PointShader;
import h3d.mat.Material;
import h3d.mat.MeshMaterial;
import h3d.mat.Texture;
import h3d.scene.Scene;
import h3d.scene.Mesh;
import h3d.Vector;
import haxe.CallStack;
import haxe.io.Bytes;
import haxe.Log;
import hxd.BitmapData;
import hxd.Pixels;
import hxd.res.Embed;
import hxd.res.EmbedFileSystem;
import hxd.res.LocalFileSystem;
import hxd.System;
import hxd.Key;
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
		depthWrite = false;
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		lshader.mproj = ctx.engine.curProjMatrix;
		depthTest = h3d.mat.Data.Compare.Always;
		depthWrite = false;
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
	var scene2 : h2d.Scene;
	 
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFF203020;
		engine.onReady = start;
		
		engine.init();
		Key.initialize();
		trace("new()");
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
		var v3 = new Vector();
		v3.set(1, 1, 1);
	}	
	
	function start() {
		scene = new Scene();
		
		loadFbx();
		
		update();
		hxd.System.setLoop(update);
	}
	
	function loadFbx(){

		var file = Assets.getText("assets/Skeleton01_anim_attack.FBX");
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
		var o : h3d.scene.Object = null;
		var bmpData = BitmapData.fromNative(Assets.getBitmapData("assets/checker.png", false));
		
		
		scene.addChild(o=curFbx.makeObject( function(str, mat) {
			var tex = Texture.fromBitmap( BitmapData.fromNative(Assets.getBitmapData("assets/checker.png", false)) );
			if ( tex == null ) throw "no texture :-(";
			
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.lightSystem = null;
			mat.culling = Back;
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
			mat.depthTest = h3d.mat.Data.Compare.Less;
			mat.depthWrite = true; 
			return mat;
		}));
		
		
		setSkin();
		//o.setRotate(0,2*Math.PI/3,0);
		scene2 = new h2d.Scene();
		spr = new h2d.Sprite(scene2);
		spr.x = 10;
		spr.y = 10;
		
		bmp = new Bitmap( h2d.Tile.fromBitmap(bmpData ) ,spr);
		//bmp.
		bmp.x = 100;
		bmp.y = 100;
		bmp.scaleY = bmp.scaleX = 0.125;
		
		bmp = new Bitmap( h2d.Tile.fromBitmap(bmpData ) ,spr);
		//bmp.
		bmp.x = 200;
		bmp.y = 100;
		bmp.scaleY = bmp.scaleX = 0.125;
		
		scene.addPass( scene2 );
	}
	
	static public var animMode : h3d.fbx.Library.AnimationMode = h3d.fbx.Library.AnimationMode.FrameAnim;
	function setSkin() {
		var anim = curFbx.loadAnimation(animMode);
		if ( anim != null )	anim = scene.playAnimation(anim);
	}
	
	var fr = 0;
	var spr : h2d.Sprite;
	var bmp : h2d.Bitmap;
	var shotList : List<Bitmap>;
	
	static var cx = 0;
	function update() {	
		if ( shotList == null) shotList = new List();
		var dist = 100;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		
		engine.render(scene);
		//engine.render(scene2);
		
		if ( Key.isReleased(Key.SPACE ) ) {
			trace("truc");
			var tempBmp : Bitmap = scene2.captureBitmap();
			
			shotList.push( tempBmp );
			
			spr.addChild(tempBmp);
			tempBmp.scaleX = tempBmp.scaleY = 0.125;
			tempBmp.x = cx;
			tempBmp.y = 300;
			cx += 100;
		}
		
	
	}
	
	static function main() {
		var p = haxe.Log.trace;
		
		trace("STARTUP");
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		trace("Booting App");
		new Test();
		
		
	}
	
}