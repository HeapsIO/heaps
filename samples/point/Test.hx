import flash.Lib;
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
		pshader.mproj = ctx.camera.m;
	}
	
	public inline function get_delta() return pshader.delta;
	public inline function set_delta(v) return pshader.delta = v;

	public inline function get_color() return pshader.color;
	public inline function set_color(v) return pshader.color = v;
	
	public inline function get_size() return pshader.size;
	public inline function set_size(v) return pshader.size=v;
}


class Test {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFF202020;
		engine.onReady = start;
		engine.init();
	}
	
	function addPoint( pos,?col=0xFFFFFFFF,size=1.0) {
		var mat = new PointMaterial();
		var point = new h3d.scene.CustomObject(new h3d.prim.Plan2D(), mat, scene);
		mat.culling = None;
		mat.delta = pos;
		mat.color = col;
		var k = size*2.0;
		mat.size = new Vector( k /  Lib.current.stage.stageWidth, k / Lib.current.stage.stageHeight, 0);
	}
	
	function start() {
		
		scene = new Scene();
		
		addPoint(new Vector(0, 0, 0), 0xFFFFFFFF );
		addPoint(new Vector(1, 0, 0), 0xFFff0000 );
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.culling = None;
			
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