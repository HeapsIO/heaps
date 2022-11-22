package h3d.col;

@:access(h3d.col.PolygonBuffer)
@:access(h3d.scene.Skin)
class SkinCollider implements Collider {

	var obj : h3d.scene.Skin;
	var col : PolygonBuffer;
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

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var ret = new SkinColliderDebugObj(this);
		ret.ignoreParentTransform = true;
		return ret;
	}
	#end

}

#if !macro
@:access(h3d.col.SkinCollider)
@:access(h3d.scene.Skin)
class SkinColliderDebugObj extends h3d.scene.Object {
	var col : SkinCollider;
	var skin : h3d.scene.Skin;

	var box : h3d.scene.Box;
	var boxes : Array<h3d.scene.Box> = [];

	public function new(col : SkinCollider) {
		super(null);
		this.col = col;
		this.skin = col.obj;
		this.box = new h3d.scene.Box(0xFFFFFF, col.currentBounds);
		addChild(box);
		this.ignoreParentTransform = true;
		createJoints();
	}

	function createJoints() {
		var joints = skin.getSkinData().allJoints;
		for( j in joints ) {
			var b = new h3d.scene.Box(0xA0A0A0, h3d.col.Bounds.fromValues(-1,-1,-1,2,2,2), this);
			if( j.offsets != null ) {
				b.bounds.empty();
				var pt = j.offsets.getMin();
				b.bounds.addSpherePos(pt.x, pt.y, pt.z, j.offsetRay);
				var pt = j.offsets.getMax();
				b.bounds.addSpherePos(pt.x, pt.y, pt.z, j.offsetRay);
			} else {
				b.bounds.empty();
				b.bounds.addSpherePos(0,0,0,0.1);
			}
			boxes.push(b);
		}
	}

	function updateJoints() {
		for( i in 0...boxes.length ) {
			var j = skin.skinData.allJoints[i];
			var b = boxes[i];
			if( j.offsets != null ) {
				var m = skin.currentPalette[j.bindIndex];
				b.setTransform(m);
			} else
				b.setTransform(skin.currentAbsPose[j.index]);
		}
	}

	override function sync( ctx : h3d.scene.RenderContext ) {
		col.checkBounds();
		updateJoints();
	}
}
#end