import flash.Lib;
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
		pshader.mproj = ctx.engine.curProjMatrix;
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
		
		update();
		hxd.System.setLoop(update);
	}
	
	function update() {	
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		
		engine.render(scene);
	}
	
	static function main() {
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		new Test();
	}
	
}