package h3d.mat;

class Defaults {

	public static var defaultKillAlphaThreshold = 0.5;
	public static var loadingTextureColor = 0xFFFF00FF;

	@:isVar public static var shadowShader(get, set) : hxsl.Shader;

	// delay initialization if needed only
	static function get_shadowShader() {
		var s = shadowShader;
		if( s == null ) {
			shadowShader = s = new h3d.shader.Shadow();
			shadowShader.setPriority(-1);
		}
		return s;
	}

	static function set_shadowShader(s) {
		return shadowShader = s;
	}

	public dynamic static function makeVolumeDecal( bounds : h3d.col.Bounds ) : hxsl.Shader {
		return new h3d.shader.VolumeDecal(bounds.xSize, bounds.ySize);
	}

}
