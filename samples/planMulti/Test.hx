import flash.Lib;
import h3d.impl.Shaders.LineShader;
import h3d.impl.Shaders.PointShader;
import h3d.mat.Material;
import h3d.mat.Texture;
import h3d.scene.CustomObject;
import h3d.scene.Scene;
import h3d.scene.Mesh;
import h3d.Vector;
import haxe.CallStack;
import haxe.io.Bytes;
import hxd.BitmapData;
import hxd.IndexBuffer;
import hxd.Pixels;
import hxd.res.Embed;
import hxd.res.EmbedFileSystem;
import hxd.res.LocalFileSystem;
import hxd.System;

import FbxData;
import Plan3DMulti;

class CustomPrimitive extends h3d.prim.MeshPrimitive {
	
	public function new() {
		super();
	}
	
	override function getBounds() {
		var b = new h3d.col.Bounds();
		b.xMin = 0;
		b.xMax = 1;
		b.yMin = 0;
		b.yMax = 1;
		b.zMin = b.zMax = 0;
		return b;
	}
	
	override function alloc( engine : h3d.Engine ) {
		var pbuf = hxd.FloatBuffer.fromArray( FbxData.floatBuffer );
		var ibuf = IndexBuffer.fromArray( FbxData.indexBuffer );
		
		addBuffer("pos", engine.mem.allocVector(pbuf, 3, 0));
		indexes = engine.mem.allocIndex(ibuf);
	}
}

class SimpleShader extends h3d.impl.Shader {
#if flash
	static var SRC = {
		var input : {
			pos : Float3,
		};

		function vertex( mpos:Matrix, mproj : Matrix ) {
			out = input.pos.xyzw*mpos*mproj;
		}
		
		function fragment() {
			out = color( 1,0,1,1);
		}
	};
	
#elseif (js || cpp)
	static var VERTEX = "
		attribute vec3 pos;
		uniform mat4 mproj;
		uniform mat4 mpos;
		
		void main(void) {
			gl_Position = vec4(pos.xyz, 1)*mpos*mproj;
		}
	";
	
	static var FRAGMENT = "
		varying vec4 vertexColor;
		void main(void) {
			gl_FragColor = vec4(1,0,1,1);
		}
	";
#end
}

class SimpleMaterial extends h3d.mat.Material{
	var sh : SimpleShader;
	
	public function new() {
		super(sh=new SimpleShader());
		depthTest = h3d.mat.Data.Compare.Always;
		culling = None;
		blend(SrcAlpha, OneMinusSrcAlpha);
	}
	
	override function setup( ctx : h3d.scene.RenderContext ) {
		super.setup(ctx);
		sh.mproj = ctx.engine.curProjMatrix;
		sh.mpos = ctx.localPos;
	}
}

class Test {
	
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	
	function new() {
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0xFFFFFFcd;
		engine.onReady = start;
		engine.init();
	}
	
	function addPlan3dMulti(center, col) {
		
		var mat = new Plan3DMulti.PlanMultiMaterial();
		var line = new h3d.scene.CustomObject(new Plan3DMulti(), mat, scene);
		var fbx = new CustomObject(new CustomPrimitive(), new SimpleMaterial() ,scene );
		
		line.material.blend(SrcAlpha, OneMinusSrcAlpha);
		line.material.depthWrite = false;
		line.material.culling = None;
		
		mat.matColor = col;
		
		fbx.scale( 0.01);
	}	
	
	function start() {
		scene = new Scene();
		addPlan3dMulti( new Vector(0, 0, 0),  0xFFffff00 );
		update();
		hxd.System.setLoop(update);
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
		
		new Test();
	}
	
}