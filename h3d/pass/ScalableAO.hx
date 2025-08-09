package h3d.pass;

class ScalableAO extends h3d.pass.ScreenFx<h3d.shader.SAO> {

	public function new() {
		super(new h3d.shader.SAO());
	}

	public function apply( depthTexture : h3d.mat.Texture, normalTexture : h3d.mat.Texture, camera : h3d.Camera ) {
		shader.depthTexture = depthTexture;
		shader.normalTexture = normalTexture;
		shader.cameraView = camera.mcam;
		shader.cameraInverseViewProj = camera.getInverseViewProj();
		shader.screenRatio.set(engine.height / engine.width, 1);
		shader.fovTan = 1.0 / (2.0 * Math.tan(camera.fovY * (Math.PI / 180) * 0.5));
		shader.ORTHO = camera.orthoBounds != null;
		if ( shader.ORTHO )
			shader.invOrthoHeight = 1.0 / camera.orthoBounds.ySize; 
		render();
	}

}