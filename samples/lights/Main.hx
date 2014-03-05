import hxd.Math;

class Main extends hxd.App {
	
	var time : Float = 0.;
		
	override function init() {
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addUVs();
		prim.addNormals();
		engine.backgroundColor = 0xFFFFFF;
		for( i in 0...50 ) {
			var b = new h3d.scene.Mesh(prim, s3d);
			b.x = Math.srand() * 3;
			b.y = Math.srand() * 3;
			b.z = Math.srand() * 2 - 0.5;
			b.scaleX = b.scaleY = Math.random() * 0.5 + 0.2;
			var k = 1.;
			b.material.color.set(k * (0.8 + Math.srand(0.2)), k  * (0.8 + Math.srand(0.2)), k  * (0.8 + Math.srand(0.2)));
			b.material.mainPass.enableLights = true;
		}
		for( i in 0...5 ) {
			var l = new h3d.scene.PointLight(s3d);
			l.x = Math.srand() * 3;
			l.y = Math.srand() * 3;
			l.z = Math.srand() * 2 - 0.5;
		}
		s3d.camera.zNear = 2;
	}
	
	override function update( dt : Float ) {
		var dist = 5;
		time += 0.002 * dt;
		s3d.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
	}
	
	static function main() {
		new Main();
	}
	
}
