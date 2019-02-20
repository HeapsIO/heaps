package h3d.scene.fwd;

class PointLight extends Light {

	var pshader : h3d.shader.PointLight;
	public var params(get, set) : h3d.Vector;

	public function new(?parent) {
		pshader = new h3d.shader.PointLight();
		super(pshader, parent);
	}

	override function get_color() {
		return pshader.color;
	}

	override function set_color(v) {
		return pshader.color = v;
	}

	override function get_enableSpecular() {
		return pshader.enableSpecular;
	}

	override function set_enableSpecular(b) {
		return pshader.enableSpecular = b;
	}

	inline function get_params() {
		return pshader.params;
	}

	inline function set_params(p) {
		return pshader.params = p;
	}

	override function emit(ctx) {
		var lum = hxd.Math.max(hxd.Math.max(color.r, color.g), color.b);
		var p = params;
		// solve lum / (x + y.d + z.d²) < 1/128
		if( p.z == 0 ) {
			cullingDistance = (lum * 128 - p.x) / p.y;
		} else {
			var delta = p.y * p.y - 4 * p.z * (p.x - lum * 128);
			cullingDistance = (p.y + Math.sqrt(delta)) / (2 * p.z);
		}
		pshader.lightPosition.set(absPos._41, absPos._42, absPos._43);
		super.emit(ctx);
	}

}