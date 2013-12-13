import flash.Lib;
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
import openfl.Assets;


@:keep
class PointMaterial extends Material{
	var pshader : PointShader;

	public var delta(get,set) : h3d.Vector;
	public var color(get,set) : Int;
	public var size(get,set) : h3d.Vector;
	
	public function new() {
		pshader = new PointShader();
		super(pshader);
		depthTest = h3d.mat.Data.Compare.Always;
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		pshader.mproj = ctx.engine.curProjMatrix;
	}
	
	public inline function get_delta() return pshader.delta;
	public inline function set_delta(v) return pshader.delta = v;

	public inline function get_color() return pshader.color;
	public inline function set_color(v) return pshader.color = v;
	
	public inline function get_size() return pshader.size;
	public inline function set_size(v) return pshader.size=v;
}

@:keep
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
		
		if ( System.debugLevel>=2) trace("prim ok");
		
		scene = new Scene();
		
		
		var mat = new LineMaterial();
		var line = new h3d.scene.CustomObject(new h3d.prim.Plan2D(), mat, scene);
		line.material.blend(SrcAlpha, OneMinusSrcAlpha);
		line.material.depthWrite = false;
		line.material.culling = Front;
		
		mat.start = new Vector(0,0,0);
		mat.end = new Vector(1, 1, 1);
		mat.color = 0xFF00FFFF;
		
		
		/*
		var mat = new PointMaterial();
		var point = new h3d.scene.CustomObject(new h3d.prim.Plan2D(), mat, scene);
		
		mat.delta = new Vector(0, 0, 0);
		mat.color = 0xFFFFFF00;
		mat.size = new Vector(1, 1, 0);
		*/
		
		function onLoaded( bmp : hxd.BitmapData) {
			System.trace3("onLoaded");
			var tex :Texture = Texture.fromBitmap( bmp);
			var mat0 = new h3d.mat.MeshMaterial(tex);
			mat0.culling = Back;
			mat0.depthWrite = true;
			mat0.depthTest = h3d.mat.Data.Compare.Less;
			
			var mat1 = new h3d.mat.MeshMaterial(tex);
			mat1.culling = Back;
			mat1.depthWrite = true;
			mat1.depthTest = h3d.mat.Data.Compare.Less;
			
			obj1 = new Mesh(prim, mat0, scene);
			obj2 = new Mesh(prim, mat1, scene);
			
			mat1.lightSystem = mat0.lightSystem = {
				ambient : new h3d.Vector(0.5, 0.5, 0.5),
				
				dirs : [ 
					{ dir : new h3d.Vector( -0.3, -0.5, -1), color : new h3d.Vector(1, 0.5, 0.5) },
					{ dir : new h3d.Vector( -0.3, -0.5, 1), color : new h3d.Vector(0.0, 0, 1.0) }
				],
				points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(0,1,0), att : new h3d.Vector(0,0,1) }],
				
			};
			
			update();
			hxd.System.setLoop(update);
		}
		

		var bmd = Assets.getBitmapData("res/hxlogo.png");
		onLoaded(BitmapData.fromNative( bmd ));

	}
	
	function update() {	
		//System.trace3("update");
		var dist = 10;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 10);
		obj2.setRotateAxis( -0.5, 2, Math.cos(time), time + Math.PI / 2);
		obj1.setPos( 1.0, 0, 0);
		
		engine.render(scene);
	}
	
	
	static var lfs: LocalFileSystem;
	static function main() {
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		#if !openfl
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
		#end
		new Test();
		
		
	}
	
}