package h3d.mat;
import h3d.mat.Data;

class Material {
	
	public var culling : Face;
	public var zwrite : Bool;
	public var ztest : Compare;
	public var blendSrc : Blend;
	public var blendDst : Blend;
	public var shader : Shader;
	
	public function new(shader) {
		this.shader = shader;
		this.culling = Face.Back;
		this.zwrite = true;
		this.ztest = Compare.Less;
		this.blendSrc = Blend.One;
		this.blendDst = Blend.Zero;
	}
	
}