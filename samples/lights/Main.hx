import hxd.Math;

class Main extends hxd.App {
	
	var time : Float = 0.;
	var lights : Array<h3d.scene.PointLight>;
		
	override function init() {
		var prim = new h3d.prim.Cube();
		prim.translate( -0.5, -0.5, -0.5);
		prim.addNormals();
		for( i in 0...50 ) {
			var b = new h3d.scene.Mesh(prim, s3d);
			b.x = Math.srand() * 3;
			b.y = Math.srand() * 3;
			b.z = Math.srand() * 2 - 0.5;
			b.scaleX = b.scaleY = Math.random() * 0.5 + 0.2;
			var k = 1.;
			b.material.color.setColor(0xFFFFFF);
			b.material.mainPass.enableLights = true;
		}
		lights = [];
		var colors = [0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF, 0xFF00FF, 0xFFFF00, 0x00FFFF];
		for( c in colors ) {
			var l = new h3d.scene.PointLight(s3d);
			l.x = Math.srand() * 3;
			l.y = Math.srand() * 3;
			l.z = Math.srand() * 2 - 0.5;
			l.color.setColor(c);
			l.params.y = 3;
			lights.push(l);
		}
		s3d.camera.zNear = 2;
		
		engine.render(s3d);
	}
	
	override function update( dt : Float ) {
		var dist = 5;
		time += 0.002 * dt;
		
		var a = [0.4, 0.2, 0.5, 0.8, 1.2, 0.5, 0.7];
		for( i in 0...lights.length ) {
			var l = lights[i];
			var t = time * 5 + i;
			l.x = Math.cos(t * a[i]) * 3;
			l.y = Math.sin(t * a[(i + 3) % a.length]) * 3;
			l.z = Math.cos(t * a[(i + 4) % a.length]) * Math.sin(t * a[(i + 6) % a.length]) * 2 - 0.5;
		}
		
		s3d.camera.pos.set(Math.cos(time) * dist, Math.sin(time) * dist, 3);
	}
	
	static function main() {
		new Main();
	}
	
}
