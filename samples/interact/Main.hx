class OptimizedIntersect implements h3d.col.RayCollider {

	var sphere : h3d.col.Sphere;
	// triangles

	public function new( mesh : h3d.scene.Mesh ) {
	}

	public function rayIntersection( r : h3d.col.Ray, ?p : h3d.col.Point ) : Null<h3d.col.Point> {
		//if( !checkRaySphere(r, sphere) )
		//	return null;
		// check triangles
		// ...
		return null;
	}
}

class Main extends hxd.App {

	var rnd : hxd.Rand;
	var light : h3d.scene.DirLight;

	function initInteract( i : h3d.scene.Interactive, m : h3d.scene.Mesh ) {
		var beacon = null;
		var color = m.material.color.clone();
		i.onOver = function(e : hxd.Event) {
			m.material.color.set(0, 1, 0);
			var s = new h3d.prim.Sphere(1, 32, 32);
			s.addNormals();
			beacon = new h3d.scene.Mesh(s, m);
			beacon.material.mainPass.enableLights = true;
			beacon.material.color.set(1, 0, 0);
			beacon.scale(0.05 / m.parent.scaleX);
			beacon.x = e.relX;
			beacon.y = e.relY;
			beacon.z = e.relZ;
		};
		i.onMove = function(e:hxd.Event) {
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
		for(i in 0...6) {
			var c = new h3d.prim.Sphere(1,64,32);
			//c.unindex();
			c.addNormals();
			c.addUVs();
			var m = new h3d.scene.Mesh(c, s3d);
			m.x = rnd.srand() * 0.8;
			m.y = rnd.srand() * 0.8;
			m.scale(0.25 + rnd.rand() * 0.5);
			m.material.mainPass.enableLights = true;
			m.material.shadows = true;
			var c = 0.3 + rnd.rand() * 0.3;
			var color = new h3d.Vector(c, c * 0.6, c * 0.6);
			m.material.color.load(color);

			var interact = new h3d.scene.Interactive(m.primitive.getCollider(), m);
			initInteract(interact, m);
		}

		var cache = new h3d.prim.ModelCache();
		var obj = cache.loadModel(hxd.Res.Model);
		obj.scale(1 / 20);
		obj.rotate(0,0,Math.PI / 2);
		obj.y = 0.2;
		obj.z = -0.2;

		// disable skinning (not supported for picking)
		var pass = obj.getChildAt(1).toMesh().material.mainPass;
		pass.removeShader(pass.getShader(h3d.shader.Skin));
		s3d.addChild(obj);

		for( o in obj ) {
			var m = o.toMesh();
			var i = new h3d.scene.Interactive(m.primitive.getCollider(), o);
			initInteract(i, m);
		}

		var b = new h2d.Interactive(150, 100, s2d);
		b.backgroundColor = 0x80204060;
		b.x = 300;
		b.y = 150;
		b.rotation = Math.PI / 3;
		//b.scaleX = 1.5; // TODO

		var pix = null;
		b.onOver = function(e) {
			var t = h2d.Tile.fromColor(0xFF0000, 3, 3);
			t.dx = -1;
			t.dy = -1;
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
	}


	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}