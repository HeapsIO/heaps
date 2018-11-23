package h3d.scene.pbr.terrain;

class Surface {
	public var albedo : h3d.mat.Texture;
	public var normal : h3d.mat.Texture;
	public var pbr : h3d.mat.Texture;
	public var tilling = 1.0;
	public var offset : h3d.Vector;
	public var angle = 0.0;

	public function new(?albedo : h3d.mat.Texture, ?normal : h3d.mat.Texture, ?pbr : h3d.mat.Texture){
		this.albedo = albedo;
		this.normal = normal;
		this.pbr = pbr;
		this.offset = new h3d.Vector(0);
	}

	public function dispose() {
		if(albedo != null) albedo.dispose();
		if(normal != null) normal.dispose();
		if(pbr != null) pbr.dispose();
	}
}

class SurfaceArray {
	public var albedo : h3d.mat.TextureArray;
	public var normal : h3d.mat.TextureArray;
	public var pbr : h3d.mat.TextureArray;
	public var params : Array<h3d.Vector> = [];
	public var secondParams : Array<h3d.Vector> = [];

	public function new(count, res){
		albedo = new h3d.mat.TextureArray(res, res, count, [Target]);
		normal = new h3d.mat.TextureArray(res, res, count, [Target]);
		pbr = new h3d.mat.TextureArray(res, res, count, [Target]);
		albedo.wrap = Repeat;
		normal.wrap = Repeat;
		pbr.wrap = Repeat;
	}

	public function dispose() {
		if(albedo != null) albedo.dispose();
		if(normal != null) normal.dispose();
		if(pbr != null) pbr.dispose();
	}
}
