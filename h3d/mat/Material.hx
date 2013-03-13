package h3d.mat;
import h3d.mat.Data;

class Material {
	
	var bits : Int;
	public var culling(default,set) : Face;
	public var depthWrite(default,set) : Bool;
	public var depthTest(default,set) : Compare;
	public var blendSrc(default,set) : Blend;
	public var blendDst(default,set) : Blend;
	public var colorMask(default,set) : Int;
	public var shader : hxsl.Shader;
	public var renderPass : Int;
	
	public function new(shader) {
		bits = 0;
		renderPass = 0;
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
	
	public function clone( ?m : Material ) {
		if( m == null ) m = new Material(null);
		m.culling = culling;
		m.depthWrite = depthWrite;
		m.depthTest = depthTest;
		m.blendSrc = blendSrc;
		m.blendDst = blendDst;
		m.colorMask = colorMask;
		return m;
	}
	
	public function depth( write, test ) {
		this.depthWrite = write;
		this.depthTest = test;
	}
	
	public function free() {
		if (shader != null) shader.free();
	}
	
	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}

	function set_culling(f) {
		culling = f;
		bits = (bits & ~(3 << 0)) | (Type.enumIndex(f) << 0);
		return f;
	}
	
	function set_depthWrite(b) {
		depthWrite = b;
		bits = (bits & ~(1 << 2)) | ((b ? 1 : 0) << 2);
		return b;
	}
	
	function set_depthTest(c) {
		depthTest = c;
		bits = (bits & ~(7 << 3)) | (Type.enumIndex(c) << 3);
		return c;
	}
	
	function set_blendSrc(b) {
		blendSrc = b;
		bits = (bits & ~(15 << 6)) | (Type.enumIndex(b) << 6);
		return b;
	}

	function set_blendDst(b) {
		blendDst = b;
		bits = (bits & ~(15 << 10)) | (Type.enumIndex(b) << 10);
		return b;
	}
	
	function set_colorMask(m) {
		m &= 15;
		colorMask = m;
		bits = (bits & ~(15 << 14)) | (m << 14);
		return m;
	}

}