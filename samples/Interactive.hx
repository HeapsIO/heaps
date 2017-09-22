import h2d.Graphics;
import hxd.Event;
//PARAM=-D resourcesPath=../../skin_res

class Interactive extends hxd.App {

	var rnd : hxd.Rand;
	var light : h3d.scene.DirLight;
	var obj : h3d.scene.Object;
	var b : h2d.Interactive;

	function initInteract( i : h3d.scene.Interactive, m : h3d.scene.Mesh ) {
		var beacon = null;
		var color = m.material.color.clone();
		i.bestMatch = true;
		i.onOver = function(e : hxd.Event) {
			m.material.color.set(0, 1, 0);
			var s = new h3d.prim.Sphere(1, 32, 32);
			s.addNormals();
			beacon = new h3d.scene.Mesh(s, s3d);
			beacon.material.mainPass.enableLights = true;
			beacon.material.color.set(1, 0, 0);
			beacon.scale(0.01);
			beacon.x = e.relX;
			beacon.y = e.relY;
			beacon.z = e.relZ;
		};
		i.onMove = i.onCheck = function(e:hxd.Event) {
			if( beacon == null ) return;
			beacon.x = e.relX;
			beacon.y = e.relY;
			beacon.z = e.relZ;
		};
		i.onOut = function(e : hxd.Event) {
			m.material.color.load(color);
			beacon.remove();
			beacon = null;
		};
	}

	override function init() {
		light = new h3d.scene.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		light.enableSpecular = true;
		light.color.set(0.28, 0.28, 0.28);
		s3d.lightSystem.ambientLight.set(0.74, 0.74, 0.74);

		rnd = new hxd.Rand(5);
		for(i in 0...8) {
			var c = if( rnd.random(2) == 0 ) new h3d.prim.Cube() else new h3d.prim.Sphere(1,64,32);
			//c.unindex();
			c.addNormals();
			c.addUVs();
			var m = new h3d.scene.Mesh(c, s3d);
			m.x = rnd.srand() * 0.9;
			m.y = rnd.srand() * 0.9;
			m.scale(0.25 + rnd.rand() * 0.3);
			m.material.mainPass.enableLights = true;
			m.material.shadows = true;
			var c = 0.3 + rnd.rand() * 0.3;
			var color = new h3d.Vector(c, c * 0.6, c * 0.6);
			m.material.color.load(color);

			var interact = new h3d.scene.Interactive(m.getCollider(), s3d);
			initInteract(interact, m);
		}

		var cache = new h3d.prim.ModelCache();
		obj = cache.loadModel(hxd.Res.Model);
		obj.scale(1 / 20);
		obj.rotate(0,0,Math.PI / 2);
		obj.y = 0.2;
		obj.z = 0.2;
		s3d.addChild(obj);

		obj.playAnimation(cache.loadAnimation(hxd.Res.Model)).speed = 0.1;

		for( o in obj ) {
			var m = o.toMesh();
			var i = new h3d.scene.Interactive(m.getCollider(), s3d);
			initInteract(i, m);
		}

		s2d.setPos(10, 10);
		s2d.scaleY = 1.2;
		s2d.rotation = 0.3;
		// s2d.setFixedSize(600, 600);

		
		b = new h2d.Interactive(150, 100, s2d);
		b.backgroundColor = 0xC0204060;
		b.rotation = Math.PI / 3;
		b.scaleX = 1.2;

		var pix = null;
		b.onOver = function(e) {
			var t = h2d.Tile.fromColor(0xFF0000, 5, 5);
			t.dx = -2;
			t.dy = -2;
			pix = new h2d.Bitmap(t, b);
			pix.x = e.relX;
			pix.y = e.relY;
		};
		b.onMove = function(e) {
			if( pix == null ) return;
			pix.x = e.relX;
			pix.y = e.relY;
		}
		b.onOut = function(e) {
			pix.remove();
			pix = null;
		};
		b.onClick = function(e) {
			// Dispatch back a move event. Check that pix doesn't move on click
			var stage = hxd.Stage.getInstance();
			e.kind = EMove;
			e.relX = stage.mouseX;
			e.relY = stage.mouseY;
			s2d.dispatchEvent(e, b);
		}
		s2d.addEventListener(function (e) {
			if (e.kind == EPush) {
				var g  = new Graphics(s2d);
				g.beginFill(0xff0000);
				g.drawRect(e.relX, e.relY, 4, 4);
				g.endFill();
			}
		});

		onResize();
	}

	override function onResize() {
		b.x = (s2d.width >> 1) - 200;
		b.y = 150;
	}

	override function update(dt:Float) {
		obj.rotate(0, 0, 0.002 * dt);
		
		var i = s2d.getInteractive(s2d.mouseX, s2d.mouseY);
		if (i != null) {
			b.alpha = 0.5;
		}
		else {
			b.alpha = 1.0;
		}
	}


	static function main() {
		hxd.Res.initEmbed();
		new Interactive();
	}
}