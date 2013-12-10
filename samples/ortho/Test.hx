import flash.Lib;
import h3d.Engine;
import h3d.impl.Shader;
import h3d.impl.Shaders.LineShader;
import h3d.impl.Shaders.PointShader;
import h3d.mat.Material;
import h3d.mat.MeshMaterial;
import h3d.mat.Texture;
import h3d.prim.Plan2D;
import h3d.prim.Primitive;
import h3d.scene.CustomObject;
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
class SpriteShader extends Shader{
	
	#if flash 
		static var SRC = {
			var input : {
				pos : Float3,
				uv : Float2,
			};
		
			var tuv : Float2;
			
			function vertex(mproj:Matrix) {
				out = input.pos.xyzw*mproj;
				tuv =  input.uv;
			}
			
			function fragment( tex : Texture ) {
				out = tex.get(tuv.xy);
			}
		};
	
	#else
	static var VERTEX = "
		attribute vec3 pos;
		uniform mat4 mproj;
		attribute vec2 uv;
		
		varying lowp vec2 tuv;
		
		void main(void) {
			gl_Position = vec4(pos,1)*mproj;
			tuv = uv;
		}";
		
	static var FRAGMENT = "
		uniform sampler2D tex;
		varying lowp vec2 tuv;
		void main(void) {
			gl_FragColor = texture2D(tex, tuv);
		}
	";
	#end
}


@:keep
class SpriteMaterial extends Material {
	public var tex : Texture;
	var pshader : SpriteShader;
	var ortho : h3d.Matrix;
	public function new(tex) {
		this.tex = tex;
		pshader = new SpriteShader();
		depthTest = h3d.mat.Data.Compare.Always;
		culling = None;
		ortho = new h3d.Matrix();
		ortho.makeOrtho(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		super(pshader);
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		pshader.tex = tex;
		pshader.mproj = ortho;
	}
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
		culling = None;
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

@:publicFields
class CustomPlan2D extends Plan2D {
	
	var x : Float;
	var y : Float;
	var z : Float;
	
	var width : Float;
	var height : Float;
	
	override function alloc( engine : h3d.Engine ) {
		
		var v = new hxd.FloatBuffer();
		
		v.push( x);
		v.push( y);
		v.push( z);
		
		v.push( 0);
		v.push( 0);

		v.push( x);
		v.push( y+height);
		v.push( z);
		
		v.push( 0);
		v.push( 1);

		v.push( x+width);
		v.push( y);
		v.push( z);
		
		v.push( 1);
		v.push( 0);

		v.push( x+width);
		v.push( y+height);
		v.push( z);
		
		v.push( 1);
		v.push( 1);
		
		buffer = engine.mem.allocVector(v, 5, 4);
	}
}

class Sprite extends CustomObject {
	
	public var tex(get,set) : Texture;
	
	var sm:SpriteMaterial;
	public function new(tex,parent)
	{
		var prim = new CustomPlan2D();
		prim.x = 8;
		prim.y = 8;
		prim.z = 0;
		prim.width = 16;
		prim.height = 16;
		
		super(prim, sm = new SpriteMaterial(tex),parent);
	}	
	
	function get_tex() {
		return sm.tex;
	}
	
	function set_tex(v) {
		return sm.tex = v;
	}
}

class Test {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	
	var sprite  : Sprite;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFFcd20cd;
		engine.onReady = start;
		engine.init();
	}
	
	
	function start() {
		trace("start !");
		
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
		
		function onLoaded( bmp : hxd.BitmapData) {
			var tex :Texture = Texture.fromBitmap( bmp);
			
			sprite = new Sprite(tex,scene);
			sprite.tex = tex;
			
			update();
			hxd.System.setLoop(update);
		}
		
		onLoaded( BitmapData.fromNative( Assets.getBitmapData( "assets/hxlogo.png")));
	}
	
	var fr = 0;
	function update() {	
		
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		
		engine.render(scene);
		if (fr++ % 100 == 0) trace("plouf");
	}
	
	
	static var lfs: LocalFileSystem;
	static function main() {
		
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		
		new Test();
	}
	
}