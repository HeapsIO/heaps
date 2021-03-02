package h3d.col;

@:access(h3d.col.PolygonBuffer)
@:access(h3d.scene.Skin)
class SkinCollider implements hxd.impl.Serializable implements Collider {

	@:s var obj : h3d.scene.Skin;
	@:s var col : PolygonBuffer;
	var currentBounds : h3d.col.Bounds;
	var transform : PolygonBuffer;
	var lastFrame = -1;
	var lastBoundsFrame = -1;

	public function new( obj, col ) {
		this.obj = obj;
		this.col = col;
		this.transform = new PolygonBuffer();
		this.transform.setData(col.buffer.copy(), col.indexes, col.startIndex, col.triCount);
		currentBounds = new h3d.col.Bounds();
	}

	public function contains(p) {
		checkBounds();
		if( !currentBounds.contains(p) )
			return false;
		applyTransform();
		return transform.contains(p);
	}

	public function inFrustum(p, ?m : h3d.Matrix ) {
		checkBounds();
		if( !currentBounds.inFrustum(p,m) )
			return false;
		if( m != null )
			throw "Not implemented";
		applyTransform();
		return transform.inFrustum(p);
	}

	public function inSphere( s : Sphere ) {
		checkBounds();
		if( !currentBounds.inSphere(s) )
			return false;
		applyTransform();
		throw "Not implemented";
		return false;
	}

	public function rayIntersection(r, bestMatch) {
		checkBounds();
		if( currentBounds.rayIntersection(r, false) < 0 )
			return -1.;
		applyTransform();
		return transform.rayIntersection(r, bestMatch);
	}

	function checkBounds() {
		if( !obj.jointsUpdated && lastBoundsFrame == obj.lastFrame ) return;
		lastBoundsFrame = obj.lastFrame;
		obj.syncJoints();
		currentBounds.empty();
		obj.getBoundsRec(currentBounds);
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

	#if (hxbit && !macro)
	function customSerialize( ctx : hxbit.Serializer ) {
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		this.transform = new PolygonBuffer();
		this.transform.setData(col.buffer.copy(), col.indexes, col.startIndex, col.triCount);
	}
	#end

}