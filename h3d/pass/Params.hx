package h3d.pass;

class Params {

	public static var defaultKillAlphaThreshold = 0.5;

	@:isVar public static var shadowShader(get, set) : hxsl.Shader;

	// delay initialization if needed only
	static function get_shadowShader() {
		var s = shadowShader;
		if( s == null ) shadowShader = s = new h3d.shader.Shadow();
		return s;
	}

	static function set_shadowShader(s) {
		return shadowShader = s;
	}

}