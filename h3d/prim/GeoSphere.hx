package h3d.prim;
import h3d.col.Point;

class GeoSphere extends Polygon {

	public function new( subdiv = 2 ) {
		var a = 1 / Math.sqrt(2);
		var p = [new Point(0, 0, 1), new Point(0, 0, -1), new Point(-a, -a, 0), new Point(a, -a, 0), new Point(a, a, 0), new Point( -a, a, 0)];
		var idx = new hxd.IndexBuffer();
		idx.push(0); idx.push(3); idx.push(4);
		idx.push(0); idx.push(4); idx.push(5);
		idx.push(0); idx.push(5); idx.push(2);
		idx.push(0); idx.push(2); idx.push(3);
		idx.push(1); idx.push(4); idx.push(3);
		idx.push(1); idx.push(5); idx.push(4);
		idx.push(1); idx.push(2); idx.push(5);
		idx.push(1); idx.push(3); idx.push(2);
		for( k in 0...subdiv ) {
			var i = 0;
			var count = idx.length, np = p.length;
			var nidx = new hxd.IndexBuffer();
			while( i < count ) {
				var p1 = p[idx[i]], p2 = p[idx[i + 1]], p3 = p[idx[i + 2]];
				var pa = p1.add(p2);
				var pb = p2.add(p3);
				var pc = p3.add(p1);
				pa.normalize();
				pb.normalize();
				pc.normalize();

				nidx.push(np);
				nidx.push(np + 1);
				nidx.push(np + 2);

				nidx.push(idx[i]);
				nidx.push(np);
				nidx.push(np + 2);

				nidx.push(np);
				nidx.push(idx[i + 1]);
				nidx.push(np + 1);

				nidx.push(np + 1);
				nidx.push(idx[i + 2]);
				nidx.push(np + 2);

				p[np++] = pa;
				p[np++] = pb;
				p[np++] = pc;
				i += 3;
			}
			idx = nidx;
		}
		super(p, idx);
	}

}
