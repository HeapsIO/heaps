package h3d.prim;
import h3d.col.Point;

class Cube extends Polygon {

	@:s var sizeX : Float;
	@:s var sizeY : Float;
	@:s var sizeZ : Float;

	public function new( x = 1., y = 1., z = 1., centered = false )
	{
		this.sizeX = x;
		this.sizeY = y;
		this.sizeZ = z;
		var p = [
			new Point(0, 0, 0),
			new Point(x, 0, 0),
			new Point(0, y, 0),
			new Point(0, 0, z),
			new Point(x, y, 0),
			new Point(x, 0, z),
			new Point(0, y, z),
			new Point(x, y, z),
		];
		var idx = new hxd.IndexBuffer();
		idx.push(0); idx.push(1); idx.push(5);
		idx.push(0); idx.push(5); idx.push(3);
		idx.push(1); idx.push(4); idx.push(7);
		idx.push(1); idx.push(7); idx.push(5);
		idx.push(3); idx.push(5); idx.push(7);
		idx.push(3); idx.push(7); idx.push(6);
		idx.push(0); idx.push(6); idx.push(2);
		idx.push(0); idx.push(3); idx.push(6);
		idx.push(2); idx.push(7); idx.push(4);
		idx.push(2); idx.push(6); idx.push(7);
		idx.push(0); idx.push(4); idx.push(1);
		idx.push(0); idx.push(2); idx.push(4);
		super(p, idx);
		if( centered ) translate( -x * 0.5, -y * 0.5, -z * 0.5);
	}

	override function addUVs() {
		unindex();

		var z = new UV(0, 1);
		var x = new UV(1, 1);
		var y = new UV(0, 0);
		var o = new UV(1, 0);

		uvs = [
			x, z, y,
			x, y, o,
			x, z, y,
			x, y, o,
			x, z, y,
			x, y, o,
			z, o, x,
			z, y, o,
			z, o, x,
			z, y, o,
			z, o, x,
			z, y, o,
		];
	}

	override public function getCollider() : h3d.col.Collider {
		return h3d.col.Bounds.fromValues(translatedX, translatedY, translatedZ, sizeX * scaled, sizeY * scaled, sizeZ * scaled);
	}

}