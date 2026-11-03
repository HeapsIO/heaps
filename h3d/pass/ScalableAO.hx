package h3d.pass;

class ScalableAO extends h3d.pass.ScreenFx<h3d.shader.SAO> {

	static var lastPyramid : h3d.mat.Texture;
	static var lastPyramidSource : h3d.mat.Texture;
	static var lastPyramidFrame = -1;
	static var lastPyramidLevels = 0;

	public var depthPyramidLevels = 5;

	var pyramidPass : h3d.pass.ScreenFx<h3d.shader.SAO.SAODepthPyramid>;
	var pyramid : h3d.mat.Texture;
	var pyramidCopy : h3d.mat.Texture;

	public function new() {
		super(new h3d.shader.SAO());
	}

	function getDepthPyramid( depth : h3d.mat.Texture ) : h3d.mat.Texture {
		var frame = hxd.Timer.frameCount;
		if( lastPyramidFrame == frame && lastPyramidSource == depth && lastPyramid != null && !lastPyramid.isDisposed() && lastPyramidLevels >= depthPyramidLevels )
			return lastPyramid;
		var width = hxd.Math.imax(depth.width >> 1, 1);
		var height = hxd.Math.imax(depth.height >> 1, 1);
		if( pyramid == null || pyramid.isDisposed() || pyramid.width != width || pyramid.height != height ) {
			disposePyramid();
			var flags : Array<h3d.mat.Data.TextureFlags> = [Target, MipMapped, ManualMipMapGen];
			pyramid = new h3d.mat.Texture(width, height, flags, R32F);
			pyramidCopy = new h3d.mat.Texture(width, height, flags, R32F);
			pyramid.setName("saoDepthPyramid");
			pyramidCopy.setName("saoDepthPyramidCopy");
			pyramid.filter = pyramidCopy.filter = Nearest;
			pyramid.mipMap = pyramidCopy.mipMap = Nearest;
		}
		if( pyramidPass == null )
			pyramidPass = new h3d.pass.ScreenFx(new h3d.shader.SAO.SAODepthPyramid());
		var levels = hxd.Math.imin(depthPyramidLevels, pyramid.mipLevels);
		var shader = pyramidPass.shader;
		var prevFilter = depth.filter;
		depth.filter = Nearest;
		shader.source = depth;
		shader.sourceSize.set(depth.width, depth.height);
		engine.pushTarget(pyramid, 0, 0);
		pyramidPass.render();
		engine.popTarget();
		depth.filter = prevFilter;
		var curWidth = width;
		var curHeight = height;
		for( lvl in 1...levels ) {
			var source = lvl & 1 == 0 ? pyramidCopy : pyramid;
			var target = lvl & 1 == 0 ? pyramid : pyramidCopy;
			source.startingMip = lvl - 1;
			shader.source = source;
			shader.sourceSize.set(curWidth, curHeight);
			engine.pushTarget(target, 0, lvl);
			pyramidPass.render();
			engine.popTarget();
			if( target == pyramidCopy )
				h3d.pass.Copy.run(pyramidCopy, pyramid, None, null, 0, lvl, lvl);
			curWidth = hxd.Math.imax(curWidth >> 1, 1);
			curHeight = hxd.Math.imax(curHeight >> 1, 1);
		}
		pyramid.startingMip = 0;
		pyramidCopy.startingMip = 0;
		lastPyramid = pyramid;
		lastPyramidSource = depth;
		lastPyramidFrame = frame;
		lastPyramidLevels = levels;
		return pyramid;
	}

	function disposePyramid() {
		if( pyramid != null ) pyramid.dispose();
		if( pyramidCopy != null ) pyramidCopy.dispose();
		pyramid = pyramidCopy = null;
	}

	override function dispose() {
		super.dispose();
		disposePyramid();
		if( pyramidPass != null ) pyramidPass.dispose();
	}

	public function apply( depthTexture : h3d.mat.Texture, normalTexture : h3d.mat.Texture, camera : h3d.Camera ) {
		var depthPyramid = getDepthPyramid(depthTexture);
		var oldFilter = depthTexture.filter;
		// Nearest filtering introduce artefacts on low resolution with our implementation.
		depthTexture.filter = Linear;
		shader.depthTexture = depthTexture;
		shader.depthPyramid = depthPyramid;
		shader.depthPyramidMaxLod = hxd.Math.imin(depthPyramidLevels, depthPyramid.mipLevels) - 1;
		shader.depthHeight = depthTexture.height;
		shader.normalTexture = normalTexture;
		shader.cameraView = camera.mcam;
		shader.cameraInverseViewProj = camera.getInverseViewProj();
		shader.screenRatio.set(engine.height / engine.width, 1);
		shader.fovTan = 1.0 / (2.0 * Math.tan(camera.fovY * (Math.PI / 180) * 0.5));
		shader.ORTHO = camera.orthoBounds != null;
		if ( shader.ORTHO )
			shader.invOrthoHeight = 1.0 / camera.orthoBounds.ySize;
		render();
		depthTexture.filter = oldFilter;
	}

}