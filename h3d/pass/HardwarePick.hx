package h3d.pass;

private class FixedColor extends hxsl.Shader {

	static var SRC = {
		@param var colorID : Vec4;
		@param var viewport : Vec4;
		var output : {
			position : Vec4,
			colorID : Vec4
		};
		function vertex() {
			output.position = (output.position + vec4(viewport.xy, 0., 0.) * output.position.w) * vec4(viewport.zw, 1., 1.);
		}
		function fragment() {
			output.colorID = colorID;
		}
	}

}

class HardwarePick extends Default {

	public var pickX : Float;
	public var pickY : Float;

	var fixedColor = new FixedColor();
	var colorID : Int;
	var texOut : h3d.mat.Texture;
	var material : h3d.mat.Pass;
	public var pickedIndex = -1;

	public function new() {
		super("hwpick");
		material = new h3d.mat.Pass("");
		material.blend(One, Zero);
		texOut = new h3d.mat.Texture(3, 3, [Target]);
		#if !flash
		texOut.depthBuffer = new h3d.mat.DepthBuffer(3, 3);
		#else
		texOut.depthBuffer = h3d.mat.DepthBuffer.getDefault();
		#end
	}

	override function dispose() {
		super.dispose();
		texOut.dispose();
		#if !flash
		texOut.depthBuffer.dispose();
		#end
	}

	override function getOutputs() : Array<hxsl.Output> {
		return [Value("output.colorID")];
	}

	override function drawObject(p) {
		super.drawObject(p);
		nextID();
	}

	inline function nextID() {
		fixedColor.colorID.setColor(0xFF000000 | (++colorID));
	}

	override function draw(passes:h3d.pass.PassList,?sort) {

		for( cur in passes ) @:privateAccess {
			// force all materials to use opaque blend
			var mask = h3d.mat.Pass.blendSrc_mask | h3d.mat.Pass.blendDst_mask | h3d.mat.Pass.blendAlphaDst_mask | h3d.mat.Pass.blendAlphaSrc_mask | h3d.mat.Pass.blendOp_mask | h3d.mat.Pass.blendAlphaOp_mask;
			cur.pass.bits &= ~mask;
			cur.pass.bits |= material.bits & mask;
		}
		colorID = 0;

		nextID();
		fixedColor.viewport.set( -(pickX * 2 / ctx.engine.width - 1), (pickY * 2 / ctx.engine.height - 1), ctx.engine.width / texOut.width, ctx.engine.height / texOut.height);
		ctx.engine.pushTarget(texOut);
		ctx.engine.clear(0xFF000000, 1);
		ctx.extraShaders = ctx.allocShaderList(fixedColor);
		super.draw(passes,sort);
		ctx.extraShaders = null;
		ctx.engine.popTarget();

		for( cur in passes ) {
			// will reset bits
			cur.pass.blendSrc = cur.pass.blendSrc;
			cur.pass.blendDst = cur.pass.blendDst;
			cur.pass.blendOp = cur.pass.blendOp;
			cur.pass.blendAlphaSrc = cur.pass.blendAlphaSrc;
			cur.pass.blendAlphaDst = cur.pass.blendAlphaDst;
			cur.pass.blendAlphaOp = cur.pass.blendAlphaOp;
			cur.pass.colorMask = cur.pass.colorMask;
		}

		ctx.engine.clear(null, null, 0);
		var pix = texOut.capturePixels();
		pickedIndex = (pix.getPixel(pix.width>>1, pix.height>>1) & 0xFFFFFF) - 1;
	}

}