import h3d.scene.*;

class Main {
	
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
		
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		
		var tex = hxd.Res.hxlogo.toTexture();
		var mat = new h3d.mat.MeshMaterial(tex);
		
		var t2 = new h3d.shader.Texture(h3d.mat.Texture.fromColor(0x80808080));
		mat.mainPass.addShader(t2);
		
		scene = new Scene();
		obj1 = new Mesh(prim, mat, scene);
		obj2 = new Mesh(prim, new h3d.mat.MeshMaterial(), scene);
		obj2.material.color.set(1, 0.7, 0.5);

			trace(mat.mainPass.getDebugShaderCode(scene));

		/*mat.lightSystem = {
			ambient : new h3d.Vector(0, 0, 0),
			dirs : [{ dir : new h3d.Vector(-0.3,-0.5,-1), color : new h3d.Vector(1,1,1) }],
			points : [{ pos : new h3d.Vector(1.5,0,0), color : new h3d.Vector(3,0,0), att : new h3d.Vector(0,0,1) }],
		};*/
		
		update();
		hxd.System.setLoop(update);
	}
	
	function update() {
		var dist = 5;
		time += 0.01;
		scene.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
		obj2.setRotateAxis(-0.5, 2, Math.cos(time), time + Math.PI / 2);
		engine.render(scene);
	}
	
	static function main() {
		#if flash
		haxe.Log.setColor(0xFF0000);
		#end
		hxd.Res.initEmbed();
		new Main();
	}
	
}