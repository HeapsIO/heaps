package h3d.mat;
import h3d.mat.Data;

@:allow(h3d.mat.Material)
#if !macro
@:build(hxd.impl.BitsBuilder.build())
#end
class Stencil {

	var maskBits  : Int = 0;
	var opBits    : Int = 0;

	@:bits(maskBits, 8) public var readMask : Int;
	@:bits(maskBits, 8) public var writeMask : Int;
	@:bits(maskBits, 8) public var reference : Int;

	@:bits(opBits) public var frontTest : Compare;
	@:bits(opBits) public var frontPass : StencilOp;
	@:bits(opBits) public var frontSTfail : StencilOp;
	@:bits(opBits) public var frontDPfail : StencilOp;

	@:bits(opBits) public var backTest : Compare;
	@:bits(opBits) public var backPass : StencilOp;
	@:bits(opBits) public var backSTfail : StencilOp;
	@:bits(opBits) public var backDPfail : StencilOp;

	public function new() {
		setOp(Keep, Keep, Keep);
		setFunc(Always);
	}

	public function setFront( stfail : StencilOp, dpfail : StencilOp, pass : StencilOp ) {
		frontSTfail = stfail;
		frontDPfail = dpfail;
		frontPass   = pass;
	}

	public function setBack( stfail : StencilOp, dpfail : StencilOp, pass : StencilOp ) {
		backSTfail  = stfail;
		backDPfail  = dpfail;
		backPass    = pass;
	}

	public function setOp( stfail : StencilOp, dpfail : StencilOp, pass : StencilOp ) {
		setFront(stfail, dpfail, pass);
		setBack(stfail, dpfail, pass);
	}

	public function setFunc( f : Compare, reference = 0, readMask = 0xFF, writeMask = 0xFF ) {
		frontTest = backTest = f;
		this.reference = reference;
		this.readMask = readMask;
		this.writeMask = writeMask;
	}

	public function clone() {
		var s = new Stencil();
		s.opBits = opBits;
		s.maskBits = maskBits;
		s.readMask = readMask;
		s.writeMask = writeMask;
		s.reference = reference;
		s.frontTest = frontTest;
		s.frontPass = frontPass;
		s.frontSTfail = frontSTfail;
		s.frontDPfail = frontDPfail;
		s.backTest = backTest;
		s.backPass = backPass;
		s.backSTfail = backSTfail;
		s.backDPfail = backDPfail;
		return s;
	}

	public function load(s : Stencil) {
		opBits = s.opBits;
		maskBits = s.maskBits;
		readMask = s.readMask;
		writeMask = s.writeMask;
		reference = s.reference;
		frontTest = s.frontTest;
		frontPass = s.frontPass;
		frontSTfail = s.frontSTfail;
		frontDPfail = s.frontDPfail;
		backTest = s.backTest;
		backPass = s.backPass;
		backSTfail = s.backSTfail;
		backDPfail = s.backDPfail;
	}

}