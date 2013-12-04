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

@:keep
class TexturedShader extends MeshMaterial.MeshShader{
	
	#if flash 
	static var SRC = {
		
		var input : {
			pos : Float3,
			uv : Float2,
		};
	}
		
		var tuv : Float2;
		
		function vertex( mpos : Matrix, mproj : Matrix ) {
			var tpos = input.pos.xyzw;
			 if( mpos != null )
				tpos *= mpos;
			var ppos = tpos * mproj;
			out = ppos;
			tuv =  input.uv;
		}
		
		function fragment( tex : Texture, colorAdd : Float4, colorMul : Float4, colorMatrix : M44 ) {
		{
			var c = tex.get(tuv.xy);
			out = c;
		}
	}
	#else
	static var VERTEX = "
		attribute vec3 pos;
		attribute vec2 uv;
		
		uniform mat4 mpos;
		uniform mat4 mproj;
		
		varying vec2 tuv;
		
		void main(void) {
			vec4 tpos = vec4(pos, 1.0);
			
			#if hasPos
				tpos = mpos * tpos;
			#end
			
			vec4 ppos = mproj * tpos;
			gl_Position = ppos;
			
			vec2 t = uv;
			tuv = t;
		}";
		
	static var FRAGMENT = "
		uniform sampler2D tex;
		varying lowp vec2 tuv;
		void main(void) {
			lowp vec4 c = texture2D(tex, tuv);
			gl_FragColor = c;
		}
	";
	#end
}

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
		pshader.mproj = ctx.camera.m;
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
		line.material.culling = None;
		
		mat.start = new Vector(0,0,0);
		mat.end = new Vector(1, 1, 1);
		mat.color = 0xFF00FFFF;
		
		var mat = new PointMaterial();
		var point = new h3d.scene.CustomObject(new h3d.prim.Plan2D(), mat, scene);
		
		mat.delta = new Vector(0, 0, 0);
		mat.color = 0xFFFFFF00;
		mat.size = new Vector(1, 1, 0);
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			var mat = new h3d.mat.MeshMaterial(tex);
			mat.shader = new TexturedShader();
			mat.culling = None;
			
			obj1 = new Mesh(prim, mat, scene);
			obj2 = new Mesh(prim, mat, scene);
			
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
		obj2.setRotateAxis( -0.5, 2, Math.cos(time), time + Math.PI / 2);
		
		
		engine.render(scene);
		//scene.
		//engine.line(0,0,0, 1,1,1, 0xFFFFFFFF);
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