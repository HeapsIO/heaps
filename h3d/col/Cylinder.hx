package h3d.col;

class Cylinder extends Collider {

	public var a : Point;
	public var b : Point;
	public var r : Float;

	public inline function new(a : Point, b : Point, r : Float) {
		this.a = a;
		this.b = b;
		this.r = r;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		throw "Not implemented";
	}

	public inline function contains( p : Point ) : Bool {
		throw "Not implemented";
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) : Bool {
		throw "Not implemented";
	}

	public function inSphere( s : Sphere ) : Bool {
		throw "Not implemented";
	}

	public function toString() {
		return "Cylinder{" + a + "," + b + "," + hxd.Math.fmt(r) + "}";
	}

	public function dimension() : Float {
		throw "Not implemented";
	}

	public function closestPoint(p : Point) : Point {
		throw "not implemented";
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var obj = new h3d.scene.Object();

		var segW = 12;
		var segH = 6;

		var dir = a.sub(b);
		var full = a.add(b);
		var dist = a.distance(b);
		var midPoint = new Point(full.x / 2, full.y / 2, full.z / 2);

		var prim = new h3d.prim.Disc(r, segW);
		prim.translate(0, 0, dist / 2);
		prim.addNormals();
		var disca = new h3d.scene.Mesh(prim);
		var discb = disca.clone();
		disca.rotate(0, Math.PI / 2, 0);
		obj.addChild(disca);
		discb.rotate(0, -1 * Math.PI / 2, 0);
		obj.addChild(discb);

		var cyl = new h3d.prim.Cylinder(segW, r, dist, true);
		cyl.addNormals();
		var cylMesh = new h3d.scene.Mesh(cyl);
		cylMesh.rotate(0, Math.PI / 2, 0);
		obj.addChild(cylMesh);

		obj.setDirection(dir.toVector());
		obj.setPosition(midPoint.x, midPoint.y, midPoint.z);
		return obj;
	}
	#end

}
