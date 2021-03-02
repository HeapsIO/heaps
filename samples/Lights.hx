import hxd.Math;

class Lights extends SampleApp {

	var lights : Array<h3d.scene.pbr.Light>;
	var movingObjects : Array<{ m : h3d.scene.Mesh, cx : Float, cy : Float, pos : Float, ray : Float, speed : Float }> = [];
	var curLight : Int = 0;
	var bitmap : h2d.Bitmap;
	var inf : h2d.Text;
	var dynCullingEnable = true;

	function addCullingCollider() {
		dynCullingEnable = true;
		for( o in s3d ) {
			if( o.cullingCollider != null ) continue;
			var absPos = o.getAbsPos();
			o.cullingCollider = new h3d.col.Sphere(absPos.tx, absPos.ty, absPos.tz, hxd.Math.max(o.scaleZ, hxd.Math.max(o.scaleX, o.scaleY)));
		}
	}

	function removeCullingCollider() {
		dynCullingEnable = false;
		for( o in s3d ) {
			o.cullingCollider = null;
		}
	}

	override function init() {
		super.init();

		s3d.camera.pos.set(100, 20, 80);
		new h3d.scene.CameraController(s3d).loadFromCamera();

		var prim = new h3d.prim.Grid(100,100,1,1);
		prim.addNormals();
		prim.addUVs();

		var floor = new h3d.scene.Mesh(prim, s3d);
		floor.material.castShadows = false;
		floor.x = -50;
		floor.y = -50;

		var box = new h3d.prim.Cube(1,1,1,true);
		box.unindex();
		box.addNormals();
		for( i in 0...50 ) {
			var m = new h3d.scene.Mesh(box, s3d);
			m.material.color.set(Math.random(), Math.random(), Math.random());
			m.material.color.normalize();
			m.scale(1 + Math.random() * 10);
			m.z = m.scaleX * 0.5;
			m.setRotation(0,0,Math.random() * Math.PI * 2);
			do {
				m.x = Std.random(80) - 40;
				m.y = Std.random(80) - 40;
			} while( m.x * m.x + m.y * m.y < 25 + m.scaleX * m.scaleX );
			m.material.getPass("shadow").isStatic = true;

			var absPos = m.getAbsPos();
			m.cullingCollider = new h3d.col.Sphere(absPos.tx, absPos.ty, absPos.tz, hxd.Math.max(m.scaleZ, hxd.Math.max(m.scaleX, m.scaleY)));
		}

		var sp = new h3d.prim.Sphere(1,16,16);
		sp.addNormals();
		for( i in 0...20 ) {
			var m = new h3d.scene.Mesh(sp, s3d);
			m.material.color.set(Math.random(), Math.random(), Math.random());
			m.material.color.normalize();
			m.scale(0.5 + Math.random() * 4);
			m.z = 2 + Math.random() * 5;
			var cx = (Math.random() - 0.5) * 20;
			var cy = (Math.random() - 0.5) * 20;

			var absPos = m.getAbsPos();
			m.cullingCollider = new h3d.col.Sphere(absPos.tx, absPos.ty, absPos.tz, hxd.Math.max(m.scaleZ, hxd.Math.max(m.scaleX, m.scaleY)));

			movingObjects.push({ m : m, pos : Math.random() * Math.PI * 2, cx : cx, cy : cy, ray : 8 + Math.random() * 50, speed : (0.5 + Math.random()) * 0.2 });
		}

		var pt = new h3d.scene.pbr.PointLight(s3d);
		pt.setPosition(0,0,15);
		pt.range = 40;
		pt.color.scale3(20);

		var sp = new h3d.scene.pbr.SpotLight(s3d);
		sp.setPosition(-30,-30,30);
		sp.setDirection(new h3d.Vector(1,2,-5));
		sp.range = 70;
		sp.angle = 70;
		sp.color.scale3(10);

		lights = [
			new h3d.scene.pbr.DirLight(new h3d.Vector(1,2,-5), s3d),
			pt,
			sp,
		];

		for( l in lights )
			l.shadows.mode = Static;
		s3d.computeStatic();
		for( l in lights )
			l.shadows.mode = Dynamic;

		for( l in lights )
			l.visible = false;
		lights[curLight].visible = true;

		addChoice("Style",["Directional","Point","Spot", "All"],function(index) {
			for( l in lights )
				l.visible = false;
			curLight = index;
			if( curLight == lights.length ) {
				for( l in lights )
					l.visible = true;
			} else
				lights[curLight].visible = true;
		},curLight);

		var modes = ([Dynamic,Static,Mixed,None] : Array<h3d.pass.Shadows.RenderMode>);
		addChoice("Shadows",[for( m in modes ) m.getName()],function(sh) {
			for( l in lights )
				l.shadows.mode = modes[sh];
		});

		var baseLS = s3d.lightSystem;
		addCheck("DynCulling", function() return dynCullingEnable, function(b) {
			dynCullingEnable = !dynCullingEnable;
			dynCullingEnable ? addCullingCollider() : removeCullingCollider();
		});

		bitmap = new h2d.Bitmap(null, s2d);
		bitmap.scale(192 / 1024);
		bitmap.filter = h2d.filter.ColorMatrix.grayed();

		inf = addText();
	}

	override function update(dt:Float) {
		for( m in movingObjects ) {
			m.pos += m.speed / m.ray;
			m.m.x = m.cx + Math.cos(m.pos) * m.ray;
			m.m.y = m.cy + Math.sin(m.pos) * m.ray;

			var cc = hxd.impl.Api.downcast(m.m.cullingCollider, h3d.col.Sphere);
			if( cc != null ) {
				var absPos = m.m.getAbsPos();
				cc.x = absPos.tx;
				cc.y = absPos.ty;
				cc.z = absPos.tz;
				cc.r = hxd.Math.max(m.m.scaleZ, hxd.Math.max(m.m.scaleX, m.m.scaleY));
			}
		}
		var light = lights[curLight];
		var tex = light == null ? null : light.shadows.getShadowTex();
		bitmap.tile = tex == null || tex.flags.has(Cube) ? null : h2d.Tile.fromTexture(tex);
		bitmap.x = s2d.width - (bitmap.tile == null ? 0 : bitmap.tile.width) * bitmap.scaleX;
		inf.text = "Shadows Draw calls: "+ s3d.lightSystem.drawPasses;

		for( o in s3d ) {
			o.culled = false;
		}
	}

	static function main() {
		h3d.mat.MaterialSetup.current = new h3d.mat.PbrMaterialSetup();
		new Lights();
	}

}
