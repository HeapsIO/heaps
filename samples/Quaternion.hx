class Quaternion extends hxd.App {

	var cube : h3d.scene.Mesh;

	var tx : Float = 0.;
	var ty : Float = 0.;
	var tz : Float = 0.;

	override function init() {
		var p = new h3d.prim.Cube(1, 1, 1);
		p.translate( -0.25, -0.5, -0.5);
		p.addUVs();
		p.addNormals();

		cube = new h3d.scene.Mesh(p, s3d);
		cube.material.texture = h2d.Tile.fromColor(0x808080).getTexture();

		var axis = new h3d.scene.Object(s3d);

		var ax = new h3d.scene.Box(0xFFFF0000, true, axis);
		ax.x = 0.5;
		ax.scaleY = 0.001;
		ax.scaleZ = 0.001;

		var ay = new h3d.scene.Box(0xFF00FF00, true, axis);
		ay.y = 0.5;
		ay.scaleX = 0.001;
		ay.scaleZ = 0.001;

		var az = new h3d.scene.Box(0xFF0000FF, true, axis);
		az.z = 0.5;
		az.scaleX = 0.001;
		az.scaleY = 0.001;

		var ax = new h3d.scene.Box(0xFF800000, true, cube);
		ax.x = 0.5;
		ax.scaleY = 0.001;
		ax.scaleZ = 0.001;

		var ay = new h3d.scene.Box(0xFF008000, true, cube);
		ay.y = 0.5;
		ay.scaleX = 0.001;
		ay.scaleZ = 0.001;

		var az = new h3d.scene.Box(0xFF000080, true, cube);
		az.z = 0.5;
		az.scaleX = 0.001;
		az.scaleY = 0.001;

		var ldir = new h3d.Vector( -1, -2, -5);
		ldir.normalize();

		/*
		cube.material.lightSystem = {
			ambient : new h3d.Vector(0.5, 0.5, 0.5),
			points : [],
			dirs : [{
				dir : ldir,
				color : new h3d.Vector(1, 1, 1),
			}],
		};
		*/
	}

	var time = 0.;

	override function update(dt:Float) {
		time += dt * 0.6;
		var q = new h3d.Quat();
		var d = new h3d.Vector( Math.cos(time), Math.sin(time), Math.cos(time / 3) * 0.1);
		q.initDirection(d);
		cube.setRotationQuat(q);
	}

	static function main() {
		new Quaternion();
	}

}