package h3d.col;

@:access(h3d.col.PolygonBuffer)
@:access(h3d.scene.Skin)
class SkinCollider implements Collider {

	var obj : h3d.scene.Skin;
	var col : PolygonBuffer;
	var transform : PolygonBuffer;
	var lastFrame : Int;

	public function new( obj, col ) {
		this.obj = obj;
		this.col = col;
		this.transform = new PolygonBuffer(col.buffer.copy(), col.indexes, col.startIndex, col.triCount);
	}

	public function contains(p) {
		applyTransform();
		return transform.contains(p);
	}

	public function inFrustum(p) {
		applyTransform();
		return transform.inFrustum(p);
	}

	public function rayIntersection(r, bestMatch) {
		applyTransform();
		return transform.rayIntersection(r, bestMatch);
	}

	function applyTransform() {
		if( !obj.jointsUpdated && lastFrame == obj.lastFrame ) return;
		lastFrame = obj.lastFrame;
		obj.syncJoints();
		var j = 0, v = 0;
		var nbones = obj.skinData.bonesPerVertex;
		for( i in 0...obj.skinData.vertexCount ) {
			var px = 0., py = 0., pz = 0.;
			var p = new Point(col.buffer[v], col.buffer[v+1], col.buffer[v+2]);

			for( k in 0...nbones ) {
				var w = obj.skinData.vertexWeights[j];
				if( w == 0 ) {
					j++;
					continue;
				}
				var bid = obj.skinData.vertexJoints[j++];
				var p2 = p.clone();
				p2.transform(obj.currentPalette[bid]);
				px += p2.x * w;
				py += p2.y * w;
				pz += p2.z * w;
			}
			transform.buffer[v++] = px;
			transform.buffer[v++] = py;
			transform.buffer[v++] = pz;
		}
	}

}