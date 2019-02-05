package h3d.scene.pbr;

class Light extends h3d.scene.Light {

	var _color : h3d.Vector;
	var primitive : h3d.prim.Primitive;
	@:s public var power : Float = 1.;
	public var shadows : h3d.pass.Shadows;
	public var isMainLight = false;

	function new(shader,?parent) {
		super(shader,parent);
		_color = new h3d.Vector(1,1,1,1);
		if( shadows == null ) shadows = new h3d.pass.Shadows(this);
	}

	override function sync(ctx) {
		super.sync(ctx);
		if(isMainLight){
			ctx.setGlobal("mainLightColor", _color);
			ctx.setGlobal("mainLightPower", power);
			ctx.setGlobal("mainLightPos",new h3d.Vector(absPos.tx, absPos.ty, absPos.tz));
			ctx.setGlobal("mainLightDir", absPos.front());
			ctx.setGlobal("mainLightShadowMap", shadows.getShadowTex());
			ctx.setGlobal("mainLightViewProj", shadows.getShadowProj());
		}
	}

	override function get_color() {
		return _color;
	}

	override function set_color(v:h3d.Vector) {
		return _color = v;
	}

	override function get_enableSpecular() {
		return true;
	}

	override function set_enableSpecular(b) {
		if( !b ) throw "Not implemented for this light";
		return true;
	}

}
