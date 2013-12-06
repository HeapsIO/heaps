import flash.Lib;
import flash.ui.Keyboard;
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
import hxd.BitmapData;
import hxd.Pixels;
import hxd.res.Embed;
import hxd.res.EmbedFileSystem;
import hxd.res.LocalFileSystem;
import hxd.System;
import mt.flash.Key;
import openfl.Assets;

/*
class DebugShader extends MeshShader {
	
	static var VERTEX = "
		attribute vec3 pos;
		attribute vec2 uv;
		
		uniform mat4 mpos;
		uniform mat4 mproj;
		
		varying vec2 tuv;
		varying float z;
		
		void main(void) {
			gl_Position = vec4(pos.xyz, 1) * mpos * mproj;
			z = gl_Position.z;
			tuv = uv;	
		}";
		
	static var FRAGMENT = "
		varying vec2 tuv;
		varying float z;
		uniform sampler2D tex;
		
		void main(void) {
			gl_FragColor = texture2D(tex, tuv);
		}
	";
}
*/

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
		lshader.mproj = ctx.engine.curProjMatrix;
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
		engine.backgroundColor = 0xFF203020;
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
	
	function start() {
		trace("start !");
		trace("prim ok");
		scene = new Scene();
		
		var axis = new Axis();
		scene.addPass(axis);
		
		loadFbx();
		
		update();
		hxd.System.setLoop(update);
	}
	
	function loadFbx(){
		//var file = Assets.getText("assets/sphere.FBX");
		//var file = Assets.getText("assets/Cheveux.FBX");
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
		scene.addChild(o=curFbx.makeObject( function(str, mat) {
			var tex = Texture.fromBitmap( BitmapData.fromNative(Assets.getBitmapData("assets/checker.png",false)) );
			var mat = new h3d.mat.MeshMaterial(tex);
			//mat.shader = new DebugShader();
			mat.lightSystem = null;
			//mat.culling = None;
			mat.culling = Back;
			mat.blend(SrcAlpha, OneMinusSrcAlpha);
			mat.depthTest = h3d.mat.Data.Compare.Always;
			mat.depthWrite = true; 
			return mat;
		}));
		//o.rotate(Math.PI/2, 0, 0);
		
		setSkin();
	}
	
	static public var animMode : h3d.fbx.Library.AnimationMode = h3d.fbx.Library.AnimationMode.FrameAnim;
	function setSkin() {
		
		var anim = curFbx.loadAnimation(animMode);
		if ( anim != null )
		{
			anim = scene.playAnimation(anim);
			/*
			anim.setFrame(0);
			anim.update(0);
			anim.pause=true;
			*/
		}
	}
	
	function update() {	
		var dist = 50;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
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