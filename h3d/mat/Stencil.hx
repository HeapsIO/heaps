package h3d.mat;
import h3d.mat.Data;

@:allow(h3d.mat.Material)
@:build(hxd.impl.BitsBuilder.build())
class Stencil implements h3d.impl.Serializable {

	@:s var frontRefBits : Int = 0;
	@:s var backRefBits  : Int = 0;
	@:s var opBits       : Int = 0;

	@:bits(opBits) public var frontTest : Compare;
	@:bits(opBits) public var frontSTfail : StencilOp;
	@:bits(opBits) public var frontDPfail : StencilOp;
	@:bits(opBits) public var frontDPpass : StencilOp;

	@:bits(frontRefBits, 8) public var frontRef : Int;
	@:bits(frontRefBits, 8) public var frontReadMask : Int;
	@:bits(frontRefBits, 8) public var frontWriteMask : Int;

	@:bits(opBits) public var backTest : Compare;
	@:bits(opBits) public var backSTfail : StencilOp;
	@:bits(opBits) public var backDPfail : StencilOp;
	@:bits(opBits) public var backDPpass : StencilOp;

	@:bits(backRefBits, 8) public var backRef : Int;
	@:bits(backRefBits, 8) public var backReadMask : Int;
	@:bits(backRefBits, 8) public var backWriteMask : Int;

	public function new() {
		setFunc(Both, Always, 0, 0xFF);
		setOp(Both, Keep, Keep, Keep);
		setMask(Both, 0xFF);
	}

	public function setOp( ?face : Face, stfail : StencilOp, dpfail : StencilOp, dppass : StencilOp ) {
		if( face == null ) face = Both;
		switch( face ) {
			case Front :
				frontSTfail = stfail;
				frontDPfail = dpfail;
				frontDPpass = dppass;
			case Back :
				backSTfail  = stfail;
				backDPfail  = dpfail;
				backDPpass  = dppass;
			case Both :
				frontSTfail = backSTfail = stfail;
				frontDPfail = backDPfail = dpfail;
				frontDPpass = backDPpass = dppass;
			default : throw "Invalid face (" + face + "), should be one of [Front, Back, Both]";
		}
	}

	public function setMask( ?face : Face, mask : Int ) {
		if( face == null ) face = Both;
		switch( face ) {
			case Front :
				frontWriteMask = mask;
			case Back :
				backWriteMask  = mask;
			case Both :
				frontWriteMask = backWriteMask = mask;
			default : throw "Invalid face (" + face + "), should be one of [Front, Back, Both]";
		}
	}

	public function setFunc( ?face : Face, test : Compare, ref : Int, mask : Int ) {
		if( face == null ) face = Both;
		switch( face ) {
			case Front :
				frontTest     = test;
				frontRef      = ref;
				frontReadMask = mask;
			case Back :
				backTest      = test;
				backRef       = ref;
				backReadMask  = mask;
			case Both :
				frontTest     = backTest     = test;
				frontRef      = backRef      = ref;
				frontReadMask = backReadMask = mask;
			default : throw "Invalid face (" + face + "), should be one of [Front, Back, Both]";
		}
	}

	public function clone() {
		var s = new Stencil();
		s.frontRefBits = frontRefBits;
		s.backRefBits = backRefBits;
		s.opBits = opBits;
		return s;
	}

	public function load(s : Stencil) {
		frontRefBits = s.frontRefBits;
		backRefBits = s.backRefBits;
		opBits = s.opBits;
	}

	#if hxbit
	public function customSerialize( ctx : hxbit.Serializer ) {
	}
	public function customUnserialize( ctx : hxbit.Serializer ) {
		loadFrontRefBits(frontRefBits);
		loadBackRefBits(backRefBits);
		loadOpBits(opBits);
	}
	#end

}