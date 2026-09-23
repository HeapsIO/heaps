package h3d.pass;

@:access(h3d.scene.Renderer)
@:access(h3d.scene.pbr.Renderer)
class SSR implements h3d.impl.RendererFX {

	public var enabled = true;

	public var stepCount : Int = 64;
	public var fadeInExponent : Float = 0.2;
	public var fadeOutExponent : Float = 2.0;
	public var depthTolerance : Float = 0.5;
	public var distanceBias : Float = 0.0;
	public var distancePowerBias : Float = 1.0;
	public var marginSize : Float = 0.1;

	public var debugEnabled : Bool = false;
	public var debugRoughnessFactor : Float = 1.0;
	public var debugIteration : Int = 0;

	public var ssrResolve : h3d.pass.ScreenFx<h3d.shader.pbr.SSR.SSRResolve>;
	var ssrFilter :  h3d.pass.ScreenFx<h3d.shader.pbr.SSR.SSRFilter>;
	var ssrShader : h3d.shader.pbr.SSR;
	var copyPass : h3d.pass.Copy;

	public function new() {
		ssrResolve = new h3d.pass.ScreenFx(new h3d.shader.pbr.SSR.SSRResolve());
		ssrFilter = new h3d.pass.ScreenFx(new h3d.shader.pbr.SSR.SSRFilter());
		ssrFilter.shader.invSize = new h3d.Vector();
		ssrShader = new h3d.shader.pbr.SSR();
		ssrShader.screenSize = new h3d.Vector();
		copyPass = new h3d.pass.Copy();
	}

	public function apply( r : h3d.scene.pbr.Renderer ) {
		var ctx = r.ctx;
		r.mark("SSR");

		var hdr = r.textures.hdr;
		var normal = r.textures.normal;
		var roughness = r.textures.pbr;
		var hzbMax = ctx.camera.reverseDepth ? true : false;
		r.updateHZB(hzbMax);
		var hzb = ctx.hzb;

		var width = hdr.width;
		var height = hdr.height;

		var ssrTarget = r.allocTarget("SSR", false, 1.0, RGBA16F, [Writable, MipMapped, ManualMipMapGen]);
		var ssrTargetCopy = r.allocTarget("SSRCopy", false, 1.0, RGBA16F, [Writable, MipMapped, ManualMipMapGen]);
		var ssrMipLevels = r.allocTarget("SSRMipLevels", false, 1.0, R8, [Writable]);
		var ssrDebug : h3d.mat.Texture = null;

		ssrTargetCopy.filter = Nearest;
		ssrTargetCopy.mipMap = Nearest;

		ssrShader.DEBUG = debugEnabled;
		if ( debugEnabled ) {
			ssrDebug = r.allocTarget("SSRDebug", false, 1.0, RGBA, [Writable]);
			ssrDebug.clear(0, 0);
			var window = hxd.Window.getInstance();
			ssrShader.debugPixelX = window.mouseX;
			ssrShader.debugPixelY = window.mouseY;
			ssrShader.debugIteration = debugIteration;
			ssrShader.debugRoughnessFactor = debugRoughnessFactor;
			ssrShader.debugSSR = ssrDebug;
		}

		ssrShader.hdrMap = hdr;
		ssrShader.depthMap = hzb;
		ssrShader.normalMap = normal;
		ssrShader.roughnessMap = roughness;
		ssrShader.outputColor = ssrTarget;
		ssrShader.outputMipLevel = ssrMipLevels;

		ssrShader.screenSize.set(width, height);
		ssrShader.mipMaps = hzb.mipLevels;
		ssrShader.stepCount = stepCount;
		ssrShader.fadeInExponent = fadeInExponent;
		ssrShader.fadeOutExponent = fadeOutExponent;
		ssrShader.depthTolerance = depthTolerance;
		ssrShader.distanceBias = distanceBias;
		ssrShader.distancePowerBias = distancePowerBias;
		ssrShader.marginSize = marginSize;
		ssrShader.ORTHOGONAL = ctx.camera.orthoBounds != null;
		ctx.computeDispatch(ssrShader, Std.int((width + 8 - 1) / 8), Std.int((height + 8 - 1) / 8));

		copyPass.shader.texture = ssrTarget;
		ctx.engine.pushTarget(ssrTargetCopy);
		copyPass.render();
		ctx.engine.popTarget();

		var curWidth = width;
		var curHeight = height;
		var mipLevels = ssrTarget.mipLevels;
		// DX12Driver doesn't yet handle transitions at sub-resource level.
		// This means that we cannot bind a mip and use a different one as target.
		// For now, we use a copy as workaround.
		for ( lvl in 1...mipLevels ) {
			var source = lvl & 1 == 0 ? ssrTargetCopy : ssrTarget;
			var target = lvl & 1 == 0 ? ssrTarget : ssrTargetCopy;
			ssrFilter.shader.ssrColor = source;
			ssrFilter.shader.invSize.set(1.0/curWidth, 1.0/curHeight);
			ssrFilter.shader.mipLevel = lvl;
			source.startingMip = lvl - 1;
			ctx.engine.pushTarget(target, 0, lvl);
			ssrFilter.render();
			ctx.engine.popTarget();

			if ( target == ssrTargetCopy ) {
				ssrTargetCopy.startingMip = lvl;
				h3d.pass.Copy.run(ssrTargetCopy, ssrTarget, None, null, 0, lvl);
			}
			ssrTarget.startingMip = lvl;
			ctx.engine.pushTarget(ssrTargetCopy, 0, lvl);
			copyPass.render();
			ctx.engine.popTarget();
			curWidth >>= 1;
			curHeight >>= 1;
		}
		ssrTarget.startingMip = 0;
		ssrTargetCopy.startingMip = 0;

		ssrResolve.shader.ssrMipLevel = ssrMipLevels;
		ssrResolve.shader.ssrColor = ssrTarget;
		ssrResolve.pass.setBlendMode(Alpha);
		ctx.engine.pushTarget(hdr);
		ssrResolve.render();
		ctx.engine.popTarget();

		if ( debugEnabled )
			h3d.pass.Copy.run(ssrDebug, hdr, Alpha);
	}

	public function start( r : h3d.scene.Renderer ) {
	}

	public function begin( r : h3d.scene.Renderer, step : h3d.impl.RendererFX.Step ) {
	}

	public function end( r : h3d.scene.Renderer, step : h3d.impl.RendererFX.Step ) {
		if( !enabled || step != Forward )
			return;
		var r = Std.downcast(r, h3d.scene.pbr.Renderer);
		if( r != null )
			apply(r);
	}

	public function dispose() {
	}

	public function modulate( t : Float ) : h3d.impl.RendererFX {
		return this;
	}

	public function transition( r1 : h3d.impl.RendererFX, r2 : h3d.impl.RendererFX ) : h3d.impl.RendererFX.RFXTransition {
		return { effect : r2, setFactor : (f : Float) -> {} };
	}

}
