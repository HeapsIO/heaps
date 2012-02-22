package h3d.mat;
import h3d.mat.Data;

class Material {
	
	public var culling : Face;
	public var depthWrite : Bool;
	public var depthTest : Compare;
	public var blendSrc : Blend;
	public var blendDst : Blend;
	public var colorMask : Int;
	public var shader : Shader;
	
	public function new(shader) {
		this.shader = shader;
		this.culling = Face.Back;
		this.depthWrite = true;
		this.depthTest = Compare.Less;
		this.blendSrc = Blend.One;
		this.blendDst = Blend.Zero;
		this.colorMask = 15;
	}
	
	public function blend(src, dst) {
		blendSrc = src;
		blendDst = dst;
	}
	
	public function depth( write, test ) {
		this.depthWrite = write;
		this.depthTest = test;
	}
	
	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}
	
}