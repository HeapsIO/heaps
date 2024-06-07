package h3d.scene;

typedef WorldData = {
	var x : Int;
	var y : Int;
	var subdivPow : Float;
	var size : Int;
	var depth : Int;
	var maxDepth : Int;
	var onCreate : HierarchicalWorld -> Void;
	var root : HierarchicalWorld;
}

class HierarchicalWorld extends Object {

	static public var FULL = false;
	static public var DEBUG = false;

	static inline final UNLOCK_COLOR = 0xFFFFFF;
	static inline final LOCK_COLOR = 0xFF0000;

	var loadingQueue : Array<h3d.scene.RenderContext -> Bool>;
	var loading : Bool = false;

	public var data : WorldData;
	var bounds : h3d.col.Bounds;
	var subdivided(default, set) = false;
	function set_subdivided(v : Bool) {
		subdivided = v;
		updateGraphics();
		return subdivided;
	}
	var debugGraphics : h3d.scene.Graphics;
	// during edition, it's necessary to lock chunks that are being modified.
	var locked(default, set) : Bool = false;
	function set_locked(v : Bool) {
		locked = v;
		updateGraphics();
		return locked;
	}
	public var level(get, null) : Int;
	public function get_level() {
		return data.maxDepth - data.depth;
	}

	function updateGraphics() {
		if ( debugGraphics == null )
			return;
		var hasLockedColor = locked && data.depth == data.maxDepth;
		var color = hasLockedColor ? LOCK_COLOR : UNLOCK_COLOR;
		var s = debugGraphics.material.mainPass.getShader(h3d.shader.FixedColor);
		s.color.setColor(color);
		debugGraphics.lineStyle(hasLockedColor ? 10.0 : 1.0, 0xFFFFFF, 1.0);
	}

	function createGraphics() {
		if ( debugGraphics != null )
			throw "??";
		var b = bounds.clone();
		b.transform(getAbsPos().getInverse());
		b.zMin = 0.0;
		b.zMax = 0.1;
		debugGraphics = new h3d.scene.Box(0xFFFFFF, b, false, this);
		debugGraphics.material.mainPass.setPassName("afterTonemapping");
		debugGraphics.material.shadows = false;
		debugGraphics.material.mainPass.addShader(new h3d.shader.FixedColor(UNLOCK_COLOR));
		updateGraphics();
	}

	public function new(parent, data : WorldData) {
		super(parent);
		this.data = data;
		this.x = data.x;
		this.y = data.y;
		calcAbsPos();
		bounds = new h3d.col.Bounds();
		// TBD : z bounds? Negative & positive infinity causes debug bounds bugs.
		// bounds is twice larger than needed so object chunks can be predicted using position and bounds only
		var pseudoInfinity = 1e10;
		bounds.addPoint(new h3d.col.Point(-data.size, -data.size, -pseudoInfinity));
		bounds.addPoint(new h3d.col.Point(data.size,data.size, pseudoInfinity));
		bounds.transform(absPos);

		if ( data.depth == 0 ) {
			data.root = this;
			loadingQueue = [];
		}
		if ( data.depth != 0 && data.onCreate != null )
			data.onCreate(this);
	}

	function init() {
		if ( data.depth == 0 && data.onCreate != null )
			data.onCreate(this);
	}

	final function isLeaf() {
		return data.depth == data.maxDepth;
	}

	function canSubdivide() {
		return !subdivided && !isLeaf();
	}

	function createNode(parent, data) {
		return new HierarchicalWorld(parent, data);
	}

	function subdivide(ctx : h3d.scene.RenderContext) {
		if ( subdivided || getScene() == null ) // parent has been removed during dequeuing.
			return false;
		if ( !loading && data.depth > 0 ) {
			loading = true;
			getRoot().loadingQueue.insert(0, subdivide);
			return false;
		}
		if ( !locked && !isClose(ctx) )
			return false;
		loading = false;
		subdivided = true;
		var childSize = data.size >> 1;
		for ( i in 0...2 ) {
			for ( j in 0...2 ) {
				var halfChildSize = childSize >> 1;
				var childData : WorldData = {
					size : childSize,
					subdivPow : data.subdivPow,
					x : i * childSize - halfChildSize,
					y : j * childSize - halfChildSize,
					depth : data.depth + 1,
					maxDepth : data.maxDepth,
					onCreate : data.onCreate,
					root : data.root,
				};
				var node = createNode(this, childData);
			}
		}
		return true;
	}

	function removeSubdivisions() {
		if ( !subdivided )
			return;
		subdivided = false;
		var i = children.length;
		while ( i-- > 0 ) {
			if ( Std.isOfType(children[i], HierarchicalWorld) )
				children[i].remove();
		}
	}

	function calcDist(ctx : h3d.scene.RenderContext) {
		var camPos = new h2d.col.Point(ctx.camera.pos.x, ctx.camera.pos.y);
		var chunkPos = getAbsPos().getPosition();
		return camPos.distance(new h2d.col.Point(chunkPos.x, chunkPos.y));
	}

	function isClose(ctx : h3d.scene.RenderContext) {
		return calcDist(ctx) < data.size * data.subdivPow;
	}

	override function syncRec(ctx : h3d.scene.RenderContext) {
		if ( debugGraphics == null && DEBUG ) {
			createGraphics();
		} else if ( debugGraphics != null && !DEBUG ) {
			debugGraphics.remove();
			debugGraphics = null;
		}

		culled = !bounds.inFrustum(ctx.camera.frustum);
		if ( !isLeaf() ) {
			var close = isClose(ctx);
			if ( FULL || close ) {
				if ( canSubdivide() && !loading )
					subdivide(ctx);
			} else if ( !locked && !close ) {
				removeSubdivisions();
			}
		}
		super.syncRec(ctx);

		if ( loadingQueue != null ) {
			while ( loadingQueue.length > 0 ) {
				var load = loadingQueue.pop();
				if ( load(ctx) )
					break;
			}
		}
	}

	override function emitRec(ctx : h3d.scene.RenderContext) {
		if ( culled )
			return;
		super.emitRec(ctx);
	}

	public function getChunkPos(x : Float, y : Float, depth = -1) {
		var root = getRoot();
		var depth = depth;
		if ( depth < 0 )
			depth = data.maxDepth;
		var chunkSize = root.data.size >> depth;
		return new h2d.col.Point((Math.floor(x / chunkSize) + 0.5) * chunkSize,
			(Math.floor(y / chunkSize) + 0.5) * chunkSize);
	}

	public function containsAt(x : Float, y : Float) {
		return bounds.contains(new h3d.col.Point(x, y, 0.0));
	}

	public function requestCreateAt(x : Float, y : Float, lock : Bool) {
		if ( !containsAt(x, y) )
			return;
		if ( lock )
			locked = true;
		if ( canSubdivide() ) {
			loading = true;
			subdivide(null);
		}
		for ( c in children ) {
			var node = Std.downcast(c, HierarchicalWorld);
			if ( node == null )
				continue;
			node.requestCreateAt(x, y, lock);
		}
	}

	// Get the chunk at the given position, creating it if it doesn't exist
	public function getChunkAtLock(x: Float, y: Float) : HierarchicalWorld {
		requestCreateAt(x,y, true);

		function rec(chunk: HierarchicalWorld, x:Float,y:Float) : HierarchicalWorld {
			if (!chunk.containsAt(x,y))
				return null;
			if (chunk.isLeaf())
				return chunk;
			for ( c in chunk.children ) {
				var node = Std.downcast(c, HierarchicalWorld);
				if ( node == null )
					continue;
				var r = rec(node,x,y);
				if (r != null)
					return r;
			}
			return null;
		}

		return rec(this,x,y);
	}

	public function lockAt(x : Float, y : Float) {
		if ( !containsAt(x, y) )
			return;
		locked = true;
		for ( c in children ) {
			var node = Std.downcast(c, HierarchicalWorld);
			if ( node == null )
				continue;
			node.lockAt(x, y);
		}
	}

	public function unlockAt(x : Float, y : Float) {
		if ( !containsAt(x, y) )
			return;
		locked = false;
		for ( c in children ) {
			var node = Std.downcast(c, HierarchicalWorld);
			if ( node == null )
				continue;
			node.unlockAt(x, y);
		}
	}

	public function unlockAll() {
		locked = false;
		for ( c in children ) {
			var node = Std.downcast(c, HierarchicalWorld);
			if ( node == null )
				continue;
			node.unlockAll();
		}
	}

	public function getRoot() : h3d.scene.HierarchicalWorld {
		return data.root;
	}

	public function refresh() {
		subdivided = false;
		var i = children.length;
		while ( i-- > 0 ) {
			var node = Std.downcast(children[i], h3d.scene.HierarchicalWorld);
			if ( node != null )
				node.remove();
		}
	}

	override function onRemove() {
		if ( data.depth == 0 )
			loadingQueue = [];
		super.onRemove();
	}
}