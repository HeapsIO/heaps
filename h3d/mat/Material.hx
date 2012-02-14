package h3d.mat;
import h3d.mat.Data;

class Material {
	
	public var culling : Face;
	public var zwrite : Bool;
	public var ztest : Compare;
	public var blendSrc : Blend;
	public var blendDst : Blend;
	public var colorMask : Int;
	public var shader : Shader;
	
	public function new(shader) {
		this.shader = shader;
		this.culling = Face.Back;
		this.zwrite = true;
		this.ztest = Compare.Less;
		this.blendSrc = Blend.One;
		this.blendDst = Blend.Zero;
		this.colorMask = 15;
	}
	
	public function blend(src, dst) {
		blendSrc = src;
		blendDst = dst;
	}
	
	public function depth( zwrite, ztest ) {
		this.zwrite = zwrite;
		this.ztest = ztest;
	}
	
	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}
	
}