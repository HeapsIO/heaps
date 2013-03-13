import h3d.scene.*;

class Test {
	
	var root : flash.display.Sprite;
	var engine : h3d.Engine;
	var time : Float;
	var scene : Scene;
	var obj1 : Mesh;
	var obj2 : Mesh;
	
	function new(root) {
		this.root = root;
		time = 0;
		engine = new h3d.Engine();
		engine.debug = true;
		engine.backgroundColor = 0x202020;
		engine.onReady = start;
		engine.init();
	}
	
	function start() {
		root.addEventListener(flash.events.Event.ENTER_FRAME, update);
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		var bmp = new flash.display.BitmapData(256, 256);
		bmp.perlinNoise(64, 64, 3, 0, true, true, 7);
		var mat = new h3d.mat.MeshMaterial(h3d.mat.Texture.fromBitmap(bmp));
		bmp.dispose();
		
		scene = new Scene();
		obj1 = new Mesh(prim, mat, scene);
		obj2 = new Mesh(prim, mat, scene);
		
		mat.lightSystem = {
			ambient : new h3d.Vector(0, 0, 0),
			dirs : [{ pos : new h3d.Vector(0.3,0.5,1), color : new h3d.Vector(1,1,1) }],
			points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(1,0,0,0) }],
		};
	}
	
	function update(_) {
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		obj2.setRotateAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
		engine.render(scene);
	}
	
	static function main() {
		haxe.Log.setColor(0xFF0000);
		new Test(flash.Lib.current);
	}
	
}