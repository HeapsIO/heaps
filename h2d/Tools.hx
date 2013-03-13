package h2d;

private class CoreObjects  {
	
	public var tmpMat1 : h3d.Vector;
	public var tmpMat2 : h3d.Vector;
	public var tmpSize : h3d.Vector;
	public var tmpUVPos : h3d.Vector;
	public var tmpUVScale : h3d.Vector;
	public var tmpColor : h3d.Vector;
	public var tmpMatrix : h3d.Matrix;
	public var tmpMaterial : h3d.mat.Material;
	public var planBuffer : h3d.impl.Buffer;
	
	var emptyTexture : h3d.mat.Texture;
	
	public function new() {
		tmpMat1 = new h3d.Vector();
		tmpMat2 = new h3d.Vector();
		tmpColor = new h3d.Vector();
		tmpSize = new h3d.Vector();
		tmpUVPos = new h3d.Vector();
		tmpUVScale = new h3d.Vector();
		tmpMatrix = new h3d.Matrix();
		tmpMaterial = new h3d.mat.Material(null);
		tmpMaterial.culling = None;
		tmpMaterial.depth(false, Always);
		
		var vector = new flash.Vector<Float>();
		for( pt in [[0, 0], [1, 0], [0, 1], [1, 1]] ) {
			vector.push(pt[0]);
			vector.push(pt[1]);
			vector.push(pt[0]);
			vector.push(pt[1]);
		}
		
		planBuffer = h3d.Engine.getCurrent().mem.allocVector(vector, 4, 4);
	}
	
	public function getEmptyTexture() {
		if( emptyTexture == null || emptyTexture.isDisposed() ) {
			emptyTexture = h3d.Engine.getCurrent().mem.allocTexture(1, 1);
			var o = haxe.io.Bytes.alloc(4);
			o.set(0, 0xFF);
			o.set(2, 0xFF);
			o.set(3, 0xFF);
			emptyTexture.uploadBytes(o);
		}
		return emptyTexture;
	}
	
	public function dispose() {
		if (tmpMaterial.shader != null) tmpMaterial.shader.free();
		if (emptyTexture != null) emptyTexture.dispose();
		planBuffer.dispose();
	}
	
}

class Tools {
	
	static var CORE = null;
	
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
	static function free()
	{
		var c = CORE;
		if( c != null ) {
			c.dispose();
			CORE = null;
		}
	}
}