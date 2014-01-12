package h3d.pass;
import h3d.mat.Data;

@:allow(h3d.mat.Material)
@:build(hxd.impl.BitsBuilder.build())
class Pass {
	
	public var name(default, null) : String;
	var passId : Int;
	var bits : Int = 0;
	var parentPass : Pass;
	var shaders : Array<hxsl.Shader>;
	var nextPass : Pass;
	
	@:bits public var culling : Face;
	@:bits public var depthWrite : Bool;
	@:bits public var depthTest : Compare;
	@:bits public var blendSrc : Blend;
	@:bits public var blendDst : Blend;
	@:bits public var blendAlphaSrc : Blend;
	@:bits public var blendAlphaDst : Blend;
	@:bits public var blendOp : Operation;
	@:bits public var blendAlphaOp : Operation;
	@:bits(4) public var colorMask : Int;
	
	public function new(name, shaders, ?parent) {
		this.parentPass = parent;
		this.shaders = shaders;
		setPassName(name);
		culling = Back;
		blend(One, Zero);
		depth(true, Less);
		blendOp = blendAlphaOp = Add;
		colorMask = 15;
	}
	
	public function setPassName( name : String ) {
		this.name = name;
		passId = hxsl.Globals.allocID(name);
	}
	
	public inline function blend( src, dst ) {
		this.blendSrc = src;
		this.blendAlphaSrc = src;
		this.blendDst = dst;
		this.blendAlphaDst = dst;
	}

	public function depth( write, test ) {
		this.depthWrite = write;
		this.depthTest = test;
	}
	
	public function setColorMask(r, g, b, a) {
		this.colorMask = (r?1:0) | (g?2:0) | (b?4:0) | (a?8:0);
	}


}