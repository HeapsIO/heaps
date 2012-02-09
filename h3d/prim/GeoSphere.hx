package h3d.prim;

class GeoSphere extends Polygon {

	public function new( subdiv = 2 ) {
		var a = 1 / Math.sqrt(2);
		var p = [new Point(0, 0, 1), new Point(0, 0, -1), new Point(-a, -a, 0), new Point(a, -a, 0), new Point(a, a, 0), new Point( -a, a, 0)];
		var idx = [
			0, 3, 4,
			0, 4, 5,
			0, 5, 2,
			0, 2, 3,
			1, 4, 3,
			1, 5, 4,
			1, 2, 5,
			1, 3, 2,
		];
		for( k in 0...subdiv ) {
			var i = 0;
			var count = idx.length, np = p.length;
			var nidx = [], k = 0;
			while( i < count ) {
				var p1 = p[idx[i]], p2 = p[idx[i + 1]], p3 = p[idx[i + 2]];
				var pa = p1.add(p2);
				var pb = p2.add(p3);
				var pc = p3.add(p1);
				pa.normalize();
				pb.normalize();
				pc.normalize();
				
				nidx[k++] = np;
				nidx[k++] = np + 1;
				nidx[k++] = np + 2;
				
				nidx[k++] = idx[i];
				nidx[k++] = np;
				nidx[k++] = np + 2;

				nidx[k++] = np;
				nidx[k++] = idx[i + 1];
				nidx[k++] = np + 1;
				
				nidx[k++] = np + 1;
				nidx[k++] = idx[i + 2];
				nidx[k++] = np + 2;
				
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
