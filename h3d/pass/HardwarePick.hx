package h3d.pass;

private class FixedColor extends hxsl.Shader {

	static var SRC = {
		@param var colorID : Vec4;
		@param var viewport : Vec4;
		var output : {
			position : Vec4,
			pickPosition : Vec4,
			colorID : Vec4
		};
		function vertex() {
			output.pickPosition = (output.position + vec4(viewport.xy, 0., 0.) * output.position.w) * vec4(viewport.zw, 1., 1.);
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
		super();
		material = new h3d.mat.Pass("");
		material.blend(One, Zero);
		texOut = new h3d.mat.Texture(3, 3, [Target, TargetUseDefaultDepth]);
	}

	override function dispose() {
		super.dispose();
		texOut.dispose();
	}

	override function getOutputs() {
		return ["output.pickPosition", "output.colorID"];
	}

	override function drawObject(p) {
		super.drawObject(p);
		nextID();
	}

	inline function nextID() {
		fixedColor.colorID.setColor(0xFF000000 | (++colorID));
	}

	override function draw(passes:Object) {

		var cur = passes;
		while( cur != null ) {
			// force all materials to use opaque blend
			@:privateAccess {
				var mask = h3d.mat.Pass.blendSrc_mask | h3d.mat.Pass.blendDst_mask | h3d.mat.Pass.blendAlphaDst_mask | h3d.mat.Pass.blendAlphaSrc_mask | h3d.mat.Pass.blendOp_mask | h3d.mat.Pass.blendAlphaOp_mask | h3d.mat.Pass.colorMask_mask;
				cur.pass.bits &= ~mask;
				cur.pass.bits |= material.bits & mask;
			}
			cur = cur.next;
		}
		colorID = 0;

		nextID();
		fixedColor.viewport.set( -(pickX * 2 / ctx.engine.width - 1), (pickY * 2 / ctx.engine.height - 1), ctx.engine.width / texOut.width, ctx.engine.height / texOut.height);
		ctx.engine.pushTarget(texOut);
		ctx.engine.clear(0xFF000000, 1);
		ctx.extraShaders = ctx.allocShaderList(fixedColor);
		var passes = super.draw(passes);
		ctx.extraShaders = null;
		ctx.engine.popTarget();

		var cur = passes;
		while( cur != null ) {
			// will reset bits
			cur.pass.blendSrc = cur.pass.blendSrc;
			cur.pass.blendDst = cur.pass.blendDst;
			cur.pass.blendOp = cur.pass.blendOp;
			cur.pass.blendAlphaSrc = cur.pass.blendAlphaSrc;
			cur.pass.blendAlphaDst = cur.pass.blendAlphaDst;
			cur.pass.blendAlphaOp = cur.pass.blendAlphaOp;
			cur.pass.colorMask = cur.pass.colorMask;
			cur = cur.next;
		}

		ctx.engine.clear(null, null, 0);
		var pix = texOut.capturePixels();
		pickedIndex = (pix.getPixel(pix.width>>1, pix.height>>1) & 0xFFFFFF) - 1;
		return passes;
	}

}