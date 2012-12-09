typedef K = flash.ui.Keyboard;

@:bitmap("res/texture.gif")
class Tex extends flash.display.BitmapData {
}

@:file("res/model.fbx")
class Model extends flash.utils.ByteArray {
	
}

class Axis implements h3d.IDrawable {

	public function new() {
	}
	
	public function render( engine : h3d.Engine ) {
		engine.line(0, 0, 0, 50, 0, 0, 0xFFFF0000);
		engine.line(0, 0, 0, 0, 50, 0, 0xFF00FF00);
		engine.line(0, 0, 0, 0, 0, 50, 0xFF0000FF);
	}
	
}

class LightShader extends hxsl.Shader {
	static var SRC = {
		var input : {
			pos : Float3,
			norm : Float3,
			uv : Float2,
			weights : Float3,
			index : Int,
		};
		var shade : Float;
		var tuv : Float2;

		function vertex( mpos : Matrix, mproj : Matrix, light : Float3, bones : M34<39> ) {
			var p : Float4;
			p.xyz = pos.xyzw * weights.x * bones[index.x * (255 * 3)] + pos.xyzw * weights.y * bones[index.y * (255 * 3)] + pos.xyzw * weights.z * bones[index.z * (255 * 3)];
			p.w = 1;
			out = (p * mpos) * mproj;
			shade = (norm.xyzw * mpos).xyz.dot(light).sat() * 0.8 + 0.6;
			tuv = uv;
		}
		
		function fragment( tex : Texture ) {
			var color = tex.get(tuv,nearest);
			kill(color.a - 0.001);
			color.rgb *= shade;
			out = color;
		}
	}
}

class Anim {

	var engine : h3d.Engine;
	var scene : h3d.scene.Scene;
	var obj : h3d.Drawable<LightShader>;
	var model : h3d.prim.FBXModel;
	var anim : h3d.prim.Skin.Animation;
	var time : Float;
	var palette : flash.Vector<h3d.Matrix>;
	
	var flag : Bool;
	var view : Int;

	function new() {
		time = 0;
		view = 3;
		engine = new h3d.Engine();
		engine.backgroundColor = 0xFF808080;
		engine.onReady = onReady;
		engine.init();
		scene = new h3d.scene.Scene();
	}
	
	function onReady() {
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, function(_) onUpdate());
		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, function(k:flash.events.KeyboardEvent ) {
			switch( k.keyCode ) {
			case K.NUMPAD_ADD:
				view++;
			case K.NUMPAD_SUBTRACT:
				view--;
			case K.SPACE:
				flag = !flag;
			default:
			}
		});

		var shader = new LightShader();
		var name = "";
		
		var file = new Model();
		var lib = new h3d.fbx.Library();
		lib.loadTextFile(file.readUTFBytes(file.length));
		model = new h3d.prim.FBXModel(lib.getMesh(name));
		var aname = model.listAnimations().first().split("::")[1];
		try {
			anim = model.getAnimation(aname);
		} catch( d:Dynamic ) {
			throw "no such anim " + aname + " in list : " + Std.string( [model.listAnimations()] );
		}
		anim.computeAbsoluteFrames();
		palette = anim.allocPalette();
		
		obj = new h3d.Drawable(model, shader);
		obj.material.culling = None;
		obj.material.blend(SrcAlpha, OneMinusSrcAlpha);
		obj.shader.tex = engine.mem.makeTexture(new Tex(0, 0));
	
		scene.addPass(obj);
		scene.addPass(new Axis());
	}
	
	function onUpdate() {
		if( !engine.begin() )
			return;
			
		var dist = 50., height = 10.;
		var camera = scene.camera;
		switch( view ) {
		case 0:
			camera.pos.set(0, height, dist);
			camera.up.set(0, -1, 0);
			camera.target.set(0, height, 0);
		case 1:
			camera.pos.set(0, dist, 0);
			camera.up.set(0, 1, 0);
			camera.target.set(0, 0, 0);
		case 2:
			var K = Math.sqrt(2);
			camera.pos.set(dist, height, 0);
			camera.up.set(1, 0, 0);
			camera.target.set(0, height, 0);
		case 3:
			var speed = 0.02;
			camera.pos.set(Math.cos(time * speed) * dist, Math.sin(time * speed) * dist, height);
			camera.up.set(0, 0, -1);
			camera.target.set(0, 0, height);
		default:
			view = 0;
		}
		
		time += 1;
		
		anim.updateJoints(Std.int(time), palette);
		if( flag )
			for( p in palette )
				p.identity();
		
		var lspeed = 0.03;
		var light = new h3d.Vector( -Math.cos(time * lspeed), -Math.sin(time * lspeed), 3 );
		light.normalize();
		camera.update();
		obj.shader.light = light;
		obj.shader.mproj = camera.m;
		obj.shader.mpos = h3d.Matrix.I();
		obj.shader.bones = palette;
		
		engine.render(scene);
	}
	
	static function main() {
		new Anim();
	}

}