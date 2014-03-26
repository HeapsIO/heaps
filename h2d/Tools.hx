package h2d;

private class CoreObjects  {
	
	public var tmpMatA : h3d.Vector;
	public var tmpMatB : h3d.Vector;
	public var tmpSize : h3d.Vector;
	public var tmpUVPos : h3d.Vector;
	public var tmpUVScale : h3d.Vector;
	public var tmpColor : h3d.Vector;
	public var tmpMatrix : h3d.Matrix;
	public var tmpMaterial : h3d.mat.Material;
	public var planBuffer : h3d.Buffer;
	public var nullTile : Tile;
	
	var emptyTexture : h3d.mat.Texture;
	
	public function new() {
		tmpMatA = new h3d.Vector();
		tmpMatB = new h3d.Vector();
		tmpColor = new h3d.Vector();
		tmpSize = new h3d.Vector();
		tmpUVPos = new h3d.Vector();
		tmpUVScale = new h3d.Vector();
		tmpMatrix = new h3d.Matrix();
		tmpMaterial = new h3d.mat.Material(null);
		tmpMaterial.culling = None;
		tmpMaterial.depth(false, Always);
		
		var vector = new hxd.FloatBuffer();
		for( pt in [[0, 0], [1, 0], [0, 1], [1, 1]] ) {
			vector.push(pt[0]);
			vector.push(pt[1]);
			vector.push(pt[0]);
			vector.push(pt[1]);
		}
		
		planBuffer = new h3d.Buffer(4, 4, [Quads]);
		planBuffer.uploadVector(vector, 0, 4);
		nullTile = new Tile(null, 0, 0, 5, 5);
	}
	
}

class Tools {
	
	static var CORE : CoreObjects = null;
	
	@:allow(h2d)
	static function getCoreObjects() {
		var c = CORE;
		if( c == null ) {
			c = new CoreObjects();
			CORE = c;
		}
		return c;
	}
	
	@:allow(h2d)
	@:access(h3d.impl.BigBuffer)
	static function checkCoreObjects() {
		var c = CORE;
		if( c == null ) return;
		// if we have lost our context
		if( c.planBuffer.isDisposed() )
			CORE = null;
	}
	
}