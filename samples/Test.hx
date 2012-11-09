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
	var rgb : RGBShader;
	var time : Float;
	var obj : h3d.Object;
	
	function new(root) {
		this.root = root;
		time = 0;
		e = new h3d.Engine();
		e.debug = true;
		e.backgroundColor = 0x202020;
		e.onReady = start;
		e.init();
	}
	
	function start() {
		root.addEventListener(flash.events.Event.ENTER_FRAME, update);
		rgb = new RGBShader();
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addTCoords();
		obj = new h3d.Object(prim, new h3d.mat.Material(rgb));
		var bmp = new flash.display.BitmapData(256, 256);
		bmp.perlinNoise(64, 64, 3, 0, true, true, 7);
		rgb.tex = e.mem.makeTexture(bmp);
		bmp.dispose();
	}
	
	function update(_) {
		var dist = 5;
		time += 0.01;
		e.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		e.camera.update();
		rgb.mproj = e.camera.m;
		e.begin();
		obj.render(e);
		e.camera.m.prependRotate(new h3d.Vector(-0.5, 2, Math.cos(time)), time + Math.PI / 2);
		rgb.mproj = e.camera.m;
		obj.render(e);
		e.end();
	}
	
	static function main() {
		haxe.Log.setColor(0xFF0000);
		new Test(flash.Lib.current);
	}
	
}