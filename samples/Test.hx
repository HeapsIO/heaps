class RGBShader extends h3d.Shader {
	
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		
		function vertex( mproj : M44 ) {
			out = pos.xyzw * mproj;
			tuv = uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv.xy);
		}
	}
	
}

class Test {
	
	var root : flash.display.Sprite;
	var e : h3d.Engine;
	var time : Float;
	var camera : h3d.Camera;
	var obj : h3d.CoreObject<RGBShader>;
	
	function new(root) {
		this.root = root;
		time = 0;
		e = new h3d.Engine();
		camera = new h3d.Camera();
		e.debug = true;
		e.backgroundColor = 0x202020;
		e.onReady = start;
		e.init();
	}
	
	function start() {
		root.addEventListener(flash.events.Event.ENTER_FRAME, update);
		var rgb = new RGBShader();
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addTCoords();
		obj = new h3d.CoreObject(prim, rgb);
		var bmp = new flash.display.BitmapData(256, 256);
		bmp.perlinNoise(64, 64, 3, 0, true, true, 7);
		rgb.tex = e.mem.makeTexture(bmp);
		bmp.dispose();
	}
	
	function update(_) {
		var dist = 5;
		time += 0.01;
		camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		camera.update();
		obj.shader.mproj = camera.m;
		e.begin();
		obj.render(e);
		camera.m.prependRotate(new h3d.Vector(-0.5, 2, Math.cos(time)), time + Math.PI / 2);
		obj.shader.mproj = camera.m;
		obj.render(e);
		e.end();
	}
	
	static function main() {
		haxe.Log.setColor(0xFF0000);
		new Test(flash.Lib.current);
	}
	
}